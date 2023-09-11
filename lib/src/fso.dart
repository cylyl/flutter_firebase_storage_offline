import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:cross_file/cross_file.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class FsoFile {
  final bool debug = false;
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
        if(debug)print('upload....');
        uploadTask = ref.putFile(File(xfile!.path));
      }
    }
    return uploadTask;
  }

  download() async {
    var storageRef = FirebaseStorage.instance.ref(rootPath);
    if (kIsWeb) {
    } else {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      File downloadToFile = File(("/" + ref.fullPath).replaceFirst(rootPath!, appDocDir.path));
      await ref.writeToFile(downloadToFile);
    }
  }
}

class Fso {
  final bool debug = false;
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
          if (debug) print(e.path);
          filename = path.basename(xfile.path);
          if (debug) print(filename);
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

  Future<String> getDownloadURL(String filepath) async {
    return await child(rootPath +'/'+ path.basename(filepath)).getDownloadURL();
  }
}
