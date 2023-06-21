<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

The flutter_firebase_storage_offline plugin is a powerful Flutter package that enhances the offline capabilities of Firebase Cloud Storage in your Flutter applications. With this plugin, you can seamlessly manage file uploads, downloads, and synchronization with Firebase Cloud Storage, even when the device is offline.

## Features

Key Features:

Offline File Queue Management: The plugin provides a robust mechanism to store file upload and download requests while the device is offline. It ensures that your app can track pending operations and automatically synchronizes them with Firebase Cloud Storage as soon as the internet connection is restored.

Local File Caching: Enjoy efficient file access even without an internet connection. The plugin offers local file caching capabilities, allowing users to access previously downloaded files directly from the device storage, eliminating the need for repeated downloads.

Connectivity Handling: Seamlessly detect changes in network connectivity using the plugin's built-in connectivity handling utilities. It leverages popular packages like connectivity to monitor network status, enabling automatic synchronization as soon as the device goes online.

Conflict Resolution: When conflicts arise between local and remote files during synchronization, the plugin provides flexible options for conflict resolution. Implement custom conflict resolution strategies or present the user with choices to resolve conflicts based on your app's specific requirements.

Synchronization Status and Progress Tracking: Keep your users informed about the status and progress of file uploads and downloads. The plugin offers intuitive interfaces and feedback mechanisms to track synchronization operations, ensuring a transparent user experience.

Error Handling and Retry Mechanisms: Handle errors gracefully during file operations, such as network timeouts or authentication issues. The plugin includes robust error handling and retry mechanisms, allowing failed operations to be retried automatically once connectivity is restored.

## Getting started

add the following to your pubspec.yaml file:

```yaml
  firebase_storage_offline:
    git:
      url: https://github.com/cylyl/flutter_firebase_storage_offline
      
```      

## Usage

TODO: Include short and useful examples for package users. Add longer examples
to `/example` folder.

```dart
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

  Fso fso = Fso(rootPath: '/data/files');

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
```

## Additional information

Get the most out of Firebase Cloud Storage in your Flutter app by integrating the flutter_firebase_storage_offline plugin. Empower your users to work with files seamlessly, even in offline scenarios, and deliver a robust and reliable storage experience.
