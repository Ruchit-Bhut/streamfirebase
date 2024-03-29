import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _chat = TextEditingController();

  final Stream<QuerySnapshot> streamdata =
      FirebaseFirestore.instance.collection("chat").snapshots();

  final ScrollController _scroll = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade200,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(254, 30, 150, 138),
        title: const Text("Chat Page"),
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
                            backgroundColor: Colors.red,
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
                          child: Card(
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
                                ? Colors.green[100]
                                : Colors.white,
                            margin: const EdgeInsets.all(10),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    harshId != null
                                        ? "Harsh"
                                        : pradipId != null
                                            ? "Pradip"
                                            : "Ruchit",
                                    style: TextStyle(
                                        color: harshId != null
                                            ? Colors.red
                                            : pradipId != null
                                                ? Colors.green
                                                : Colors.blue,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Wrap(
                                    alignment: WrapAlignment.end,
                                    children: [
                                      Text(
                                        storeData[index]['text'],
                                        style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(
                                        width: 7,
                                      ),
                                      Column(
                                        children: [
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            date.toString(),
                                            style: const TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
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
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _chat,
                          minLines: 1,
                          maxLines: 5,
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.only(left: 25, bottom: 10, top: 20),
                            filled: true,
                            hintText: "Type a message",
                            hintStyle: const TextStyle(color: Colors.blueGrey),
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(350),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: const Color.fromARGB(254, 30, 150, 138),
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
