import 'dart:math' as math;

import 'package:aless_arithmetic_task/result.dart';
import 'package:flutter/material.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key, required this.situation, required this.name});

  final int situation;
  final String name;

  @override
  State<StatefulWidget> createState() => _TaskPage();
}

class _TaskPage extends State<TaskPage> {
  late Size size;
  late double resultAreaHeight;
  late double tenkeyAreaHeight;
  var rand = math.Random();
  final stopWatch = Stopwatch();
  String input = "";
  int taskLeft = 0;
  int taskRight = 0;
  List<int> answerTime = [];
  static const int maxTask = 10;

  void generateTask() {
    stopWatch.reset();
    setState(() {
      taskLeft = 100 + rand.nextInt(900);
      taskRight = 100 + rand.nextInt(900);
    });
    stopWatch.start();
  }

  void checkAns() {
    if ((taskLeft + taskRight).toString() == input) {
      stopWatch.stop();
      answerTime.add(stopWatch.elapsedMilliseconds);
      if (answerTime.length == maxTask) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ResultPage(
                  answerTime: answerTime,
                  situation: widget.situation,
                  name: widget.name)),
        );
      }
      setState(() {
        generateTask();
        input = "";
      });
    }
  }

  SizedBox NumButtonBox(val) {
    return SizedBox(
        height: tenkeyAreaHeight / 4 * 0.9,
        width: size.width / 3 * 0.9,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(0))),
                backgroundColor: Colors.black),
            onPressed: () {
              setState(() {
                if (val.toString() == "B") {
                  input = input.substring(0, input.length - 1);
                } else if (val.toString() == "C") {
                  input = "";
                } else {
                  input = input + val.toString();
                }
                checkAns();
              });
            },
            child: FittedBox(
              child: Text(
                val.toString(),
                style: const TextStyle(fontSize: 196, color: Colors.white),
              ),
            )));
  }

  Row ButtonRow(val1, val2, val3) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [NumButtonBox(val1), NumButtonBox(val2), NumButtonBox(val3)]);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    generateTask();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    var maxHeight = size.height - 56;
    resultAreaHeight = maxHeight * (30 / 100);
    tenkeyAreaHeight = maxHeight * (70 / 100);

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.black54,
          title: Text(
            "Task:No.${answerTime.length + 1}",
            style: const TextStyle(color: Colors.white),
          )),
      body: Column(
        children: <Widget>[
          Container(
              decoration: const BoxDecoration(color: Colors.black),
              width: size.width,
              height: resultAreaHeight,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: size.width * 0.9,
                      height: resultAreaHeight * 0.5 * 0.9,
                      child: FittedBox(
                          child: Text(
                        "$taskLeft+$taskRight",
                        style:
                            const TextStyle(fontSize: 40, color: Colors.white),
                      )),
                    ),
                    SizedBox(
                      width: size.width * 0.9,
                      height: resultAreaHeight * 0.5 * 0.9,
                      child: FittedBox(
                          child: Text(
                        input,
                        style:
                            const TextStyle(fontSize: 40, color: Colors.white),
                      )),
                    )
                  ])),
          Container(
            decoration: const BoxDecoration(color: Colors.black87),
            width: size.width,
            height: tenkeyAreaHeight,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ButtonRow(7, 8, 9),
                ButtonRow(4, 5, 6),
                ButtonRow(1, 2, 3),
                ButtonRow("C", 0, "B")
              ],
            ),
          ),
        ],
      ),
    );
  }
}
