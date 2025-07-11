import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import '../widgets/crunching_file_tile.dart';
import '../controllers/gesture_controller.dart';
import '../services/socket_server.dart';

class FileManagerScreen extends StatefulWidget {
  @override
  _FileManagerScreenState createState() => _FileManagerScreenState();
}

class _FileManagerScreenState extends State<FileManagerScreen> {
  List<File> selectedFiles = [];
  bool serverStarted = false;

  Future<void> _pickFiles() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      setState(() {
        selectedFiles = result.paths.map((e) => File(e!)).toList();
      });
    }
  }

  void _startSending(File file) async {
    if (serverStarted) return;
    serverStarted = true;
    final server = SocketServer(port: 8989, fileToSend: file);
    await server.startServer();

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('📡 Sharing started on hotspot... waiting for receiver'),
    ));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final gestureController = Provider.of<GestureController>(context);

    gestureController.addListener(() {
      if (gestureController.isFistClosed && selectedFiles.isNotEmpty) {
        print("🤜 Fist Closed → Start sending");
        _startSending(selectedFiles.first); // Send first file for now
      }
    });
  }

  Widget buildFileList() {
    return ListView.builder(
      itemCount: selectedFiles.length,
      itemBuilder: (context, index) {
        return CrunchingFileTile(
          file: selectedFiles[index],
          onCrunchComplete: () {
            print("✅ Crunched: ${selectedFiles[index].path}");
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
                if (selectedFiles.isNotEmpty) {
                  _startSending(selectedFiles.first);
                }
              },
              child: Text("🚀 Send Files"),
            ),
          )
        ],
      ),
    );
  }
}
