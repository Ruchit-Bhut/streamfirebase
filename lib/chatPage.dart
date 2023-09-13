import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _chat = TextEditingController();

  final Stream<QuerySnapshot> streamdata =
      FirebaseFirestore.instance.collection("chat").snapshots();

  final ScrollController _scroll = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: const Icon(
          Icons.arrow_back_ios_new,
          color: Color(0xff1f3250),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.all(8),
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                  "https://storage.googleapis.com/cms-storage-bucket/780e0e64d323aad2cdd5.png"),
              backgroundColor: Colors.white12,
              radius: 20,
            ),
          )
        ],
        title: const Text(
          "Chat Page",
          style: TextStyle(color: Color(0xff172c49), fontSize: 25),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: streamdata,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            log("Something went wrong");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final List<dynamic> storeData = [];
          snapshot.data!.docs.map(
            (DocumentSnapshot document) {
              Map a = document.data() as Map<String, dynamic>;
              storeData.add(a);
            },
          ).toList();

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scroll,
                  itemCount: storeData.length,
                  itemBuilder: (context, index) {
                    if (index == storeData.length) {
                      return Container(
                        height: 70,
                      );
                    }
                    final ruchitId = storeData[index]['ruchitId'];
                    final harshId = storeData[index]['harshId'];
                    final pradipId = storeData[index]['pradipId'];
                    final date = storeData[index]['time'];

                    return Slidable(
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        extentRatio: .20,
                        children: [
                          SlidableAction(
                            onPressed: (context) async {
                              ruchitId != null
                                  ? await FirebaseFirestore.instance
                                      .collection('chat')
                                      .doc(ruchitId)
                                      .delete()
                                  : harshId != null
                                      ? await FirebaseFirestore.instance
                                          .collection('chat')
                                          .doc(harshId)
                                          .delete()
                                      : pradipId != null
                                          ? await FirebaseFirestore.instance
                                              .collection('chat')
                                              .doc(pradipId)
                                              .delete()
                                          : const SizedBox();
                            },
                            borderRadius: BorderRadius.circular(10),
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                      child: Align(
                        alignment: ruchitId != null
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Padding(
                          padding: ruchitId != null
                              ? const EdgeInsets.only(left: 50)
                              : const EdgeInsets.only(right: 50),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: ruchitId != null
                                      ? const BorderRadius.only(
                                          topRight: Radius.circular(15),
                                          topLeft: Radius.circular(15),
                                          bottomLeft: Radius.circular(15),
                                        )
                                      : const BorderRadius.only(
                                          topRight: Radius.circular(15),
                                          topLeft: Radius.circular(15),
                                          bottomRight: Radius.circular(15),
                                        ),
                                ),
                                elevation: 0.0,
                                color: ruchitId != null
                                    ? const Color(0xffff5a6e)
                                    : const Color(0x4dacc2ca),
                                margin: const EdgeInsets.all(10),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Wrap(
                                        alignment: WrapAlignment.end,
                                        children: [
                                          Text(
                                            storeData[index]['text'],
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: ruchitId != null
                                                  ? Colors.white
                                                  : const Color(0xff172c49),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: Text(
                                  date.toString(),
                                  style: const TextStyle(
                                      fontSize: 13,
                                      color: Color(0x73acc2ca),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          textCapitalization: TextCapitalization.sentences,
                          controller: _chat,
                          minLines: 1,
                          maxLines: 5,
                          decoration: const InputDecoration(
                            contentPadding:
                                EdgeInsets.only(left: 10, bottom: 10, top: 20),
                            filled: true,
                            hintText: "Type a message",
                            hintStyle: TextStyle(color: Colors.blueGrey),
                            fillColor: Color.fromRGBO(183, 189, 193, 100),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: const Color(0xff172c49),
                        child: IconButton(
                          onPressed: () async {
                            if (_chat.text == "") {
                              log("isEmpty");
                            } else {
                              final idDateTime = DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString();
                              final datTime =
                                  DateFormat('hh:mm a').format(DateTime.now());
                              _scroll.animateTo(
                                  _scroll.position.maxScrollExtent + 70,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.bounceOut);
                              await FirebaseFirestore.instance
                                  .collection('chat')
                                  .doc(idDateTime)
                                  .set(
                                {
                                  "text": _chat.text,
                                  "ruchitId": idDateTime,
                                  "time": datTime
                                },
                              );
                              _chat.clear();
                            }
                          },
                          icon: const Icon(Icons.send),
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
