import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import '../widgets/crunching_file_tile.dart';

class FileManagerScreen extends StatefulWidget {
  @override
  _FileManagerScreenState createState() => _FileManagerScreenState();
}

class _FileManagerScreenState extends State<FileManagerScreen> {
  List<File> selectedFiles = [];

  Future<void> _pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      setState(() {
        selectedFiles = result.paths.map((e) => File(e!)).toList();
      });
    }
  }

  Widget buildFileList() {
    return ListView.builder(
      itemCount: selectedFiles.length,
      itemBuilder: (context, index) {
        return CrunchingFileTile(
          file: selectedFiles[index],
          onCrunchComplete: () {
            // File is now visually 'locked' (you can prepare it for sending here)
            print("Crunched: ${selectedFiles[index].path}");
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Select Files"),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                foregroundColor: Colors.black,
              ),
              onPressed: _pickFiles,
              child: Text("📂 Browse Files"),
            ),
          ),
          Expanded(
            child: selectedFiles.isEmpty
                ? Center(
                    child: Text(
                      "No files selected",
                      style: TextStyle(color: Colors.white70),
                    ),
                  )
                : buildFileList(),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyanAccent,
                foregroundColor: Colors.black,
              ),
              onPressed: () {
                // You can trigger send logic here
              },
              child: Text("🚀 Send Files"),
            ),
          )
        ],
      ),
    );
  }
}
