import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VideoPickerWidget extends StatefulWidget {
  @override
  _VideoPickerWidgetState createState() => _VideoPickerWidgetState();
}

class _VideoPickerWidgetState extends State<VideoPickerWidget> {
  String _filePath = '';

  Future<void> _pickVideo() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.video,
        allowCompression: true,
      );

      if (result != null) {
        setState(() {
          _filePath = result.files.single.path!;
        });
      }
    } catch (e) {
      print('Error picking video: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Picker'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _pickVideo,
              child: Text('Pick a video'),
            ),
            SizedBox(height: 20),
            Text(
              _filePath.isNotEmpty ? 'Selected file: $_filePath' : 'No file selected',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
