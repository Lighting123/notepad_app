import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const NotepadApp(),
    );
  }
}

class NotepadApp extends StatefulWidget {
  const NotepadApp({super.key});

  @override
  State<NotepadApp> createState() => _NotepadAppState();
}

class _NotepadAppState extends State<NotepadApp> {
  String title = 'Untitled Document';
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
        actions: [
          IconButton(
              onPressed: () async {
                if (Platform.isAndroid) {
                  // Get the external storage directory
                  final directory = await getExternalStorageDirectory();

                  // Specify the file path
                  final filePath = '${directory!.path}/my_file.txt';

                  // Create a File instance
                  final file = File(filePath);

                  // Write some data to the file
                  await file.writeAsString(textController.text);

                  print('File saved to $filePath');
                  title = 'my_file.txt';
                } else {
                  final directory = await getApplicationDocumentsDirectory();

                  final filePath = '${directory.path}/my_file.txt';

                  final file = File(filePath);

                  await file.writeAsString(textController.text);
                }
              },
              icon: const Icon(Icons.save)),
          IconButton(
              onPressed: () async {
                FilePickerResult? result =
                    await FilePicker.platform.pickFiles();

                if (result != null) {
                  File file = File(result.files.single.path!);
                  textController.text = await file.readAsString();
                  var fileName = file.path.split('/').last;

                  setState(() {
                    title = fileName;
                  });
                } else {}
              },
              icon: const Icon(Icons.file_open))
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: TextField(
              controller: textController,
              expands: true,
              maxLines: null,
              decoration: const InputDecoration(
                  hintText: 'Type anything here.....',
                  border: InputBorder.none),
            ),
          )
        ],
      ),
    );
  }
}
