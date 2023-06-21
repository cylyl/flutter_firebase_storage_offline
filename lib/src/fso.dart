import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:cross_file/cross_file.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class FsoFile {
  Reference ref;
  bool? uploadPending;
  XFile? xfile;

  String? rootPath;

  FsoFile(this.ref, {this.xfile, required this.rootPath}) {
    uploadPending = xfile != null;
  }

  Future<UploadTask> upload() async {
    UploadTask uploadTask;
    var filename = path.basename(xfile!.path);
    // var storageRef = FirebaseStorage.instance.ref(rootPath);
    if (xfile == null) {
      throw Exception('xfile is null');
    } else {
      if (kIsWeb) {
        uploadTask =
            ref.putData(await xfile!.readAsBytes());
      } else {
        print('upload....');
        uploadTask = ref.putFile(File(xfile!.path));
      }
    }
    return uploadTask;
  }

  download() async {
    var storageRef = FirebaseStorage.instance.ref(rootPath);
    if (kIsWeb) {
    } else {
      var filename = path.basename(xfile!.path);
      Reference ref = storageRef.child(filename);
      Directory appDocDir = await getApplicationDocumentsDirectory();
      File downloadToFile = File('${appDocDir.path}/$filename');
      await ref.writeToFile(downloadToFile);
    }
  }
}

class Fso {
  final storageRef = FirebaseStorage.instance.ref();

  String rootPath;

  Fso({this.rootPath = '/'});

  Reference child(String path) {
    return storageRef.child(path);
  }

  Future<List<FsoFile>> listAll() async {
    Directory root;
    List<FsoFile> allFiles = [];
    var allRemote = await storageRef.child(rootPath).listAll();
    var items = allRemote.items;
    for (var e in items) {
      allFiles.add(FsoFile(e, rootPath: rootPath));
    }
    String filename;
    XFile xfile;
    if (kIsWeb) {
      xfile = XFile('assets/dir_a/1');
      filename = path.basename(xfile.path);
      bool found = isFileExistInRemote(filename, allFiles);
      if (!found) {
        var pending = storageRef.child(rootPath).child("$filename");
        allFiles.add(FsoFile(pending, xfile: xfile, rootPath: rootPath));
      }
    } else {
      root = await getApplicationDocumentsDirectory() ;
      String filesDir = "${root.path}/files";
      if(!Directory(filesDir).existsSync()){
        Directory(filesDir).createSync();
      }
      root = Directory(filesDir);

      //list all file in root
      var files = root.listSync();
      //loop files
      for (var e in files) {
        //check if file is file
        if (FileSystemEntity.isFileSync(e.path)) {
          //check if file is not pending
          //check if file is not in remote
          xfile = XFile(e.path);
          if (kDebugMode) print(e.path);
          filename = path.basename(xfile.path);
          if (kDebugMode) print(filename);
          bool found = isFileExistInRemote(filename, allFiles);
          if (!found) {
            var pending = storageRef.child(rootPath).child("$filename");
            allFiles.add(FsoFile(pending, xfile: xfile, rootPath: rootPath));
          }
        }
      }
    }

    return allFiles;
  }

  bool isFileExistInRemote(String filename, List<FsoFile> result) {
    bool found = false;
    for (var e in result) {
      if (e.ref.name == filename) {
        if (!found) {
          found = true;
          break;
        }
      }
    }
    return found;
  }
}
