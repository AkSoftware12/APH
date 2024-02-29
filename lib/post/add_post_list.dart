import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Admin/home_admin.dart';

class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  TextEditingController titleController = TextEditingController();
  TextEditingController subtitleController = TextEditingController();
  TextEditingController artistController = TextEditingController();
  File? file;
  FilePickerResult? result;
  final formKey = GlobalKey<FormState>();
  bool _isLoading = false;


  Future<void> addPost(File? file) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                color: Colors.orangeAccent,
              ),
              // SizedBox(width: 16.0),
              // Text("Logging in..."),
            ],
          ),
        );
      },
    );

        setState(() {
          _isLoading = true;
        });
        final title = titleController.text;
        final type = subtitleController.text;
        final des = artistController.text;
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final String? token = prefs.getString('token');

        try {
          var request = http.MultipartRequest(
            'POST',
            Uri.parse('https://api.astropanditharidwar.in/api/add_post'),
          );

          // Add token to request headers
          request.headers['Authorization'] = 'Bearer $token';

          request.fields['title'] = title;
          request.fields['file_type'] = type;
          request.fields['description'] = des;
          if (file != null) {
            request.files.add(await http.MultipartFile.fromPath('file', file.path));
          }

          var streamedResponse = await request.send();
          var response = await http.Response.fromStream(streamedResponse);

          if (response.statusCode == 200) {
            print("Post added successfully");
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => AdminPage(),
              ),
            );
          } else {
            print("Failed to add post. Error: ${response.body}");
            // Handle failure
          }
        } catch (error) {
          print("Error: $error");
          // Handle error
        }

    }



  // Future<void> addPost(File? file) async {
  //   final title = titleController.text;
  //   final type = subtitleController.text;
  //   final des = artistController.text;
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final String? token = prefs.getString('token');
  //
  //   try {
  //     var request = http.MultipartRequest(
  //       'POST',
  //       Uri.parse('https://api.astropanditharidwar.in/api/add_post'),
  //     );
  //
  //     // Add token to request headers
  //     request.headers['Authorization'] = 'Bearer $token';
  //
  //     request.fields['title'] = title;
  //     request.fields['file_type'] = type;
  //     request.fields['description'] = des;
  //     if (file != null) {
  //       request.files.add(await http.MultipartFile.fromPath('file', file.path));
  //     }
  //
  //     var streamedResponse = await request.send();
  //     var response = await http.Response.fromStream(streamedResponse);
  //
  //     if (response.statusCode == 200) {
  //       print("Post added successfully");
  //       // Handle success
  //     } else {
  //       print("Failed to add post. Error: ${response.body}");
  //       // Handle failure
  //     }
  //   } catch (error) {
  //     print("Error: $error");
  //     // Handle error
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('File Picker')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextFormField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                labelStyle: TextStyle(color: Colors.black),
              ),
              style: TextStyle(color: Colors.black),
            ),
            TextFormField(
              controller: subtitleController,
              decoration: InputDecoration(
                labelText: 'File Type',
                labelStyle: TextStyle(color: Colors.black),
              ),
              style: TextStyle(color: Colors.black),
            ),
            TextFormField(
              controller: artistController,
              decoration: InputDecoration(
                labelText: 'Description',
                labelStyle: TextStyle(color: Colors.black),
              ),
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    result = await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['jpg', 'jpeg', 'png', 'mp4', 'mov', 'avi'],
                    );
                    if (result != null) {
                      if (!kIsWeb) {
                        file = File(result!.files.single.path!);
                      }
                      setState(() {});
                    } else {
                      // User canceled the picker
                    }
                  } catch (_) {}
                },
                child: const Text('Pick File'),
              ),
            ),
            SizedBox(height: 20),
            if (file != null || result != null)
              kIsWeb
                  ? Image.memory(
                result!.files.first.bytes!,
                height: 350,
                width: 350,
                fit: BoxFit.fill,
              )
                  : Image.file(
                file!,
                height: 150,
                width: 150,
                fit: BoxFit.fill,
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (file != null) {
                  addPost(file);
                } else {
                  print('Please pick a file first.');
                }
              },
              child: const Text('Add Post'),
            ),
          ],
        ),
      ),
    );
  }
}

