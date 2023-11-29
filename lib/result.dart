import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ResultPage extends StatefulWidget {
  const ResultPage(
      {super.key,
      required this.answerTime,
      required this.situation,
      required this.name});
  final List<int> answerTime;
  final int situation;
  final String name;

  @override
  State<StatefulWidget> createState() => _ResultPage();
}

class _ResultPage extends State<ResultPage> {
  late Size size;

  void sendData() async {
    FirebaseFirestore.instance
        .collection("Answers")
        .doc(const Uuid().v4())
        .set({
      'name': widget.name,
      'situation': widget.situation,
      'time': Timestamp.fromDate(DateTime.now()),
      'data': widget.answerTime
    });
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    var maxHeight = size.height - 56;

    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
          title: const Text(
        "Result",
        style: TextStyle(color: Colors.white),
      )),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: maxHeight * 0.6,
                width: size.width * 0.6,
                child: Table(
                  border: TableBorder.all(color: Colors.white30, width: 5.0),
                  children: [
                    for (int i = 0; i < widget.answerTime.length; i++)
                      TableRow(children: [
                        SizedBox(
                          height: maxHeight * 0.06,
                          width: size.width * 0.2,
                          child: FittedBox(
                            child: Text(
                              (i + 1).toString(),
                              style: const TextStyle(
                                  fontSize: 48, color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: maxHeight * 0.06,
                          width: size.width * 0.2,
                          child: FittedBox(
                              child: Text(widget.answerTime[i].toString(),
                                  style: const TextStyle(
                                      fontSize: 48, color: Colors.white))),
                        )
                      ])
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: maxHeight * 0.2,
            width: size.width * 0.3,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(0))),
                  backgroundColor: Colors.black),
              onPressed: () {
                sendData();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const FittedBox(
                child: Text(
                  "SEND",
                  style: TextStyle(fontSize: 40, color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
