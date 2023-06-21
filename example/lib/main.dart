import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:path_provider/path_provider.dart';
import 'firebase_options.dart';
import 'package:firebase_storage_offline/firebase_storage_offline.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
        // dark mode
        brightness: Brightness.dark,
      ),
      home: StorageList(),
    );
  }
}
class StorageList extends StatefulWidget {
  @override
  _StorageListState createState() => _StorageListState();
}

class _StorageListState extends State<StorageList> {

  Fso fso = Fso(rootPath: '/data/1cc760adfc7c3111');

  List<FsoFile> _filesAndDirs = [];

  @override
  void initState() {
    super.initState();
    _listFilesAndDirs();
  }

  Future<void> _listFilesAndDirs() async {
    List<FsoFile> result = await fso.listAll(
    );

    setState(() {
      _filesAndDirs = result;
    });
  }

  Future<void> _downloadFile(String fileName) async {
  }

  @override
  Widget build(BuildContext context) {



/*    getApplicationDocumentsDirectory().then((value) {
      print(value.path);
      new File(value.path + "/test").writeAsString("asd");

      new File(value.path + "/test").readAsString().then((value) =>
        print("read >>>>>>>>>.. " + value )
      );
    });*/

/*
    getApplicationDocumentsDirectory().then((dir) {
      //print dir list
      dir.listSync().forEach((element) {
        print(element.path);
      });
    });
*/




    return Scaffold(
      appBar: AppBar(
        title: Text('Storage List'),
      ),
      body: ListView.builder(
        itemCount: _filesAndDirs.length,
        itemBuilder: (BuildContext context, int index) {
          String name = _filesAndDirs[index].ref.name;

          return ListTile(
            title: Text(name),
            onTap: () {
              // _downloadFile(name);
              _filesAndDirs[index].upload();
            },
          );
        },
      ),
    );
  }
}