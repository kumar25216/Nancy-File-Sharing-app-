import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:lottie/lottie.dart';
import '../widgets/animated_file_tile.dart';

class FileManagerScreen extends StatefulWidget {
  @override
  _FileManagerScreenState createState() => _FileManagerScreenState();
}

class _FileManagerScreenState extends State<FileManagerScreen> {
  List<FileSystemEntity> selectedFiles = [];

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
        return AnimatedFileTile(
          file: selectedFiles[index],
          animationPath: 'assets/animations/crunch_animation.json',
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text("Select Files"), backgroundColor: Colors.transparent),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _pickFiles,
            child: Text("Browse Files"),
          ),
          Expanded(
            child: selectedFiles.isEmpty
                ? Center(child: Text("No files selected", style: TextStyle(color: Colors.white70)))
                : buildFileList(),
          ),
          ElevatedButton(onPressed: () {}, child: Text("Send Files"))
        ],
      ),
    );
  }
}
