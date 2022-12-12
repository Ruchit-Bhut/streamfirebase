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

  ScrollController _scroll = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade200,
      appBar: AppBar(
        backgroundColor:Color.fromARGB(254, 30, 150, 138),
        title: Text("Chat Page"),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: streamdata,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            print("Something went wrong");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
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
                        motion: ScrollMotion(),
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
                                          : SizedBox();
                            },
                            borderRadius: BorderRadius.circular(10),
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                      child: Align(
                        alignment: ruchitId != null
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0.0,
                          color: ruchitId!=null?Colors.green[100]:Colors.white,
                          margin: EdgeInsets.all(10),
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
                                              : Colors.blue,fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  storeData[index]['text'],
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  date.toString(),
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
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
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 15),
                            filled: true,
                            hintText: "Type Here",
                            hintStyle: TextStyle(color: Colors.blueGrey),
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(350),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Color.fromARGB(254, 30, 150, 138),
                        child: IconButton(
                          onPressed: () async {
                            final id_dateTime = DateTime.now()
                                .millisecondsSinceEpoch
                                .toString();
                            final datTime =
                                DateFormat('hh:mm a').format(DateTime.now());
                            _scroll.animateTo(
                                _scroll.position.maxScrollExtent + 70,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.bounceOut);
                            await FirebaseFirestore.instance
                                .collection('chat')
                                .doc(id_dateTime)
                                .set(
                              {
                                "text": _chat.text,
                                "ruchitId": id_dateTime,
                                "time": datTime
                              },
                            );
                            _chat.clear();
                          },
                          icon: Icon(Icons.send),color: Colors.white,
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
