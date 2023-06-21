import 'package:flutter_test/flutter_test.dart';

import 'package:firebase_storage_offline/firebase_storage_offline.dart';
import 'package:cross_file/cross_file.dart';

void main() {

  Fso fsoFile = Fso();

  //create test
  test('create file', () async {
    //create file
    fsoFile.child('test.txt').putString('test');
    //check if file exists
    expect(await fsoFile.child('test.txt').getDownloadURL(), 'test');
  });
}
