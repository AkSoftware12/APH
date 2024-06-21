import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Admin/home_admin.dart';
import '../Utils/color.dart';


final Color yellow = Color(0xfffbc31b);
final Color orange = Color(0xfffb6900);
final String image1 = "images/broccoli.jpg";
final String image2 = "images/carrots.jpg";

String image = image1;

class AddImage extends StatefulWidget {
  final String? type;
  AddImage({Key? key, required this.type}) : super(key: key);
  @override
  _LoadFirbaseStorageImageState createState() =>
      _LoadFirbaseStorageImageState();
}

class _LoadFirbaseStorageImageState extends State<AddImage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController subtitleController = TextEditingController();
  TextEditingController artistController = TextEditingController();
  File? file;
  FilePickerResult? result;
  final formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final FocusNode focusNodeNickname = FocusNode();


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
    final type = widget.type;
    final des = artistController.text;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');


    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://api.astropanditharidwar.in/api/add_post'),
    );

    // Add token to request headers
    request.headers['Authorization'] = 'Bearer $token';

    request.fields['title'] = title;
    request.fields['file_type'] = type!;
    request.fields['description'] = des;
    if (file != null) {
      request.files.add(await http.MultipartFile.fromPath('file', file.path));
    }

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 201) {
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


  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
              height: 400,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50.0),
                      bottomRight: Radius.circular(50.0)),
                  gradient: LinearGradient(
                      colors: [orange, yellow],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight)),
              child: Container(
                child: GestureDetector(
                  onTap: () async {
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
                  child: Center(
                    child: Card(
                      child: GestureDetector(
                        onTap: () async {
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
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0), // Adjust the border radius as needed
                          child: (file != null || result != null) ?
                          (kIsWeb ?
                          Image.memory(
                            result!.files.first.bytes!,
                            height: 350,
                            width: 350,
                            fit: BoxFit.fill,
                          ) :
                          Image.file(
                            file!,
                            height: 300,
                            width: 350,
                            fit: BoxFit.fill,
                          )
                          ) :
                          SizedBox(
                            height: 300,
                            width: 350,
                            child: Center(
                              child: Text(
                                'No image Selected',

                                style: TextStyle(
                                    color: Colors.black
                                ),// Replace 'default_image.png' with the path to your default image asset
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            ),
            Container(
              height: MediaQuery.of(context).size.height - 400,
              margin: const EdgeInsets.only(top: 400),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20.0),
                  Expanded(
                    child: Stack(
                      children: <Widget>[
                        Container(
                          child: Column( // Use Column for vertical alignment
                            crossAxisAlignment: CrossAxisAlignment.start, // Align children to the start
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: Text('Title', textAlign: TextAlign.start,
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold),
                                  ),),
                              ), // Align text to the start
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Card(
                                  elevation: 5.0,
                                  color: Colors.white, // Set the background color here
                                  margin: EdgeInsets.only(left: 15.0, right: 15),
                                  child: Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: TextField(
                                      controller: titleController,
                                      decoration: InputDecoration(
                                        hintText: 'Enter title',
                                        border: InputBorder.none,
                                      ),
                                      style: TextStyle(
                                          color: Colors.black
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(left: 15.0,top: 15),
                                child: Text('Description', textAlign: TextAlign.start,
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold),
                                  ),),
                              ), // Align text to the start
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Card(
                                  elevation: 5.0,
                                  color: Colors.white, // Set the background color here
                                  margin: EdgeInsets.only(left: 15.0, right: 15),
                                  child: Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: TextField(
                                      controller: artistController,
                                      decoration: InputDecoration(
                                        hintText: 'Enter description',
                                        border: InputBorder.none,
                                      ),
                                      style: TextStyle(
                                          color: Colors.black
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(left: 15.0,top: 20),
                                child: Text('File Type', textAlign: TextAlign.start,
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold),
                                  ),),
                              ), // Align text to the start
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Container(
                                  color: Colors.white,
                                  height: 60.0, // Set the desired height here
                                  width: double.infinity, // Set the desired width here
                                  child: Card(
                                    elevation: 5.0,
                                    // Set the background color here
                                    margin: EdgeInsets.only(left: 15.0, right: 15),
                                    child: Padding(
                                      padding: EdgeInsets.all(5.0),
                                      child: Center(
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            widget.type.toString() ?? 'Default Email',
                                            textAlign: TextAlign.start,
                                            style: GoogleFonts.poppins(
                                              textStyle: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 19,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )

                        ),

                      ],
                    ),
                  ),
                  loadButton(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget loadButton(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            padding:
            const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
            margin: const EdgeInsets.only(
                top: 30, left: 20.0, right: 20.0, bottom: 20.0),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [yellow, orange],
                ),
                borderRadius: BorderRadius.circular(30.0)),
            child: ElevatedButton(
              onPressed: () {
                if (file != null) {
                  addPost(file);
                } else {
                  print('Please pick a file first.');
                }
              },
              child: Text(
                "Post",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
