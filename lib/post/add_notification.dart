import 'dart:convert';
import 'dart:math';
import 'package:aph/baseurlp/baseurl.dart';
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

class AddNotification extends StatefulWidget {
  AddNotification({Key? key,}) : super(key: key);
  @override
  _LoadFirbaseStorageImageState createState() =>
      _LoadFirbaseStorageImageState();
}

class _LoadFirbaseStorageImageState extends State<AddNotification> {
  TextEditingController titleController = TextEditingController();

  File? file;
  FilePickerResult? result;
  final formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final FocusNode focusNodeNickname = FocusNode();
  void addNotificationApi(String title) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
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

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(addNotification),
    );

    // Add token to request headers
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['note'] = title;


    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 201) {
      print("add notification Successfully");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AdminPage(),
        ),
      );
    } else {
      print("Failed to add notification. Error: ${response.body}");
      // Handle failure
    }
  }


  // void AddNotification(String title) async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final String? token = prefs.getString('token');
  //
  //   final response = await http.post(
  //     Uri.parse(addNotification),
  //     headers: {
  //       'Authorization': 'Bearer $token',
  //       'Content-Type': 'application/json',
  //     },
  //     body: jsonEncode('note': title,),
  //   );
  //
  //   if (response.statusCode == 200) {
  //     print('add notification successfully!');
  //
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => AdminPage(),
  //       ),
  //     );
  //   } else {
  //     // Handle error
  //     print('Failed to send message: ${response.reasonPhrase}');
  //   }
  // }




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

                  },
                  child: Center(
                    child: Card(
                      child: GestureDetector(
                        onTap: () async {

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
                          Image.network(
                            'https://static.vecteezy.com/system/resources/previews/010/366/202/original/bell-icon-transparent-notification-free-png.png',
                            height: 300,
                            width: 350,
                            fit: BoxFit.fill,
                          )
                          ) :
                          SizedBox(
                            height: 300,
                            width: 350,
                            child: Center(
                              child: Image.network(
                                'https://static.vecteezy.com/system/resources/previews/010/366/202/original/bell-icon-transparent-notification-free-png.png', // Replace 'default_image.png' with the path to your default image asset
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
                                  child: Text('Note', textAlign: TextAlign.start,
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
                                        maxLines: 10,
                                        decoration: InputDecoration(
                                          hintText: 'Enter title',
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                // Padding(
                                //   padding: const EdgeInsets.only(left: 15.0,top: 15),
                                //   child: Text('Description', textAlign: TextAlign.start,
                                //     style: GoogleFonts.poppins(
                                //       textStyle: const TextStyle(
                                //           color: Colors.black,
                                //           fontSize: 19,
                                //           fontWeight: FontWeight.bold),
                                //     ),),
                                // ), // Align text to the start
                                // Padding(
                                //   padding: const EdgeInsets.only(top: 5.0),
                                //   child: Card(
                                //     elevation: 5.0,
                                //     color: Colors.white, // Set the background color here
                                //     margin: EdgeInsets.only(left: 15.0, right: 15),
                                //     child: Padding(
                                //       padding: EdgeInsets.all(5.0),
                                //       child: TextField(
                                //         decoration: InputDecoration(
                                //           hintText: 'Enter description',
                                //           border: InputBorder.none,
                                //         ),
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                //
                                // Padding(
                                //   padding: const EdgeInsets.only(left: 15.0,top: 20),
                                //   child: Text('File Type', textAlign: TextAlign.start,
                                //     style: GoogleFonts.poppins(
                                //       textStyle: const TextStyle(
                                //           color: Colors.black,
                                //           fontSize: 19,
                                //           fontWeight: FontWeight.bold),
                                //     ),),
                                // ), // Align text to the start
                                // Padding(
                                //   padding: const EdgeInsets.only(top: 8.0),
                                //   child: Container(
                                //     color: Colors.white,
                                //     height: 60.0, // Set the desired height here
                                //     width: double.infinity, // Set the desired width here
                                //     child: Card(
                                //       elevation: 5.0,
                                //       // Set the background color here
                                //       margin: EdgeInsets.only(left: 15.0, right: 15),
                                //       child: Padding(
                                //         padding: EdgeInsets.all(5.0),
                                //         child: Center(
                                //           child: Align(
                                //             alignment: Alignment.centerLeft,
                                //             child: Text('',
                                //               textAlign: TextAlign.start,
                                //               style: GoogleFonts.poppins(
                                //                 textStyle: const TextStyle(
                                //                   color: Colors.black,
                                //                   fontSize: 19,
                                //                   fontWeight: FontWeight.bold,
                                //                 ),
                                //               ),
                                //             ),
                                //           ),
                                //         ),
                                //       ),
                                //     ),
                                //   ),
                                // ),
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
                final title = titleController.text;

                addNotificationApi(title);
              },
              child: Text(
                "Add Notification",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
