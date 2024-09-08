import 'dart:io';

import 'package:path_provider/path_provider.dart';

void writeTextFile(String text) async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/note.txt');

  file.writeAsString(text);
}
