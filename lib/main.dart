import 'dart:core';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'task.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ALESS Experiment',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'ALESS Experiment'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int situation = 0;
  String name = "";
  static const int situationCount = 7;

  final audioPlayer = AudioPlayer();
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    //LOOPの設定
    audioPlayer.setReleaseMode(ReleaseMode.loop);
    //再生中か停止中かの状態を取得
    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });
  }

  void downLoad() async {
    final answers =
        await FirebaseFirestore.instance.collection("Answers").get();
    final Excel excel = Excel.createExcel();
    final Sheet sheet1 = excel['Stocks Table'];
    sheet1.cell(CellIndex.indexByString('A1')).value = TextCellValue('time');
    sheet1.cell(CellIndex.indexByString('B1')).value =
        TextCellValue('name-hash');
    sheet1.cell(CellIndex.indexByString('C1')).value =
        TextCellValue("situation");
    sheet1.cell(CellIndex.indexByString('D1')).value = TextCellValue("data");
    int k = 2;
    for (var doc in answers.docs) {
      Timestamp time = doc.data()["time"];
      String nameHash = doc.data()["name-hash"];
      int situation = doc.data()["situation"];
      List<int> data = doc.data()["data"].cast<int>();
      sheet1.cell(CellIndex.indexByString('A$k')).value =
          TextCellValue(time.toDate().toString());
      sheet1.cell(CellIndex.indexByString('B$k')).value =
          TextCellValue(nameHash);
      print(situation);
      sheet1.cell(CellIndex.indexByString('C$k')).value =
          TextCellValue(situation.toString());
      for (int i = 0; i < 10; i++) {
        print(data[i]);
        sheet1
            .cell(
                CellIndex.indexByColumnRow(columnIndex: 4 + i, rowIndex: k - 1))
            .value = TextCellValue(data[i].toString());
      }
      k++;
    }
    const fileName = 'data.xlsx';
    excel.save(fileName: fileName);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var maxHeight = size.height - 56;
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black12,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: size.width * 0.15,
              height: maxHeight * 0.1,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(0))),
                      backgroundColor: Colors.black),
                  onPressed: () {
                    setState(() {
                      situation = (situation + 1) % situationCount;
                    });
                    audioPlayer.pause();
                    if (situation != 0) {
                      audioPlayer.play(
                        AssetSource("$situation.mp3"),
                      );
                    }
                  },
                  child: FittedBox(
                    child: Text(
                      situation.toString(),
                      style:
                          const TextStyle(color: Colors.white, fontSize: 196),
                    ),
                  )),
            ),
            SizedBox(
              width: size.width * 0.3,
              height: maxHeight * 0.1,
              child: TextField(
                onChanged: (text) {
                  name = text;
                },
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white54,
                      ),
                    ),
                    hintText: "姓名",
                    hintStyle: TextStyle(color: Colors.white24)),
              ),
            ),
            SizedBox(
              width: size.width * 0.3,
              height: maxHeight * 0.2,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(0))),
                      backgroundColor: Colors.black),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TaskPage(
                                situation: situation,
                                name: name,
                              )),
                    );
                  },
                  child: const FittedBox(
                    child: Text(
                      "START",
                      style: TextStyle(color: Colors.white, fontSize: 196),
                    ),
                  )),
            ),
            SizedBox(
              width: size.width * 0.3,
              height: maxHeight * 0.2,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(0))),
                      backgroundColor: Colors.black),
                  onPressed: () {
                    downLoad();
                  },
                  child: const FittedBox(
                    child: Text(
                      "DOWNLOAD",
                      style: TextStyle(color: Colors.white, fontSize: 196),
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
