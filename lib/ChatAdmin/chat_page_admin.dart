
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Utils/color.dart';
import 'package:http/http.dart' as http;

import '../../baseurlp/baseurl.dart';

class ChatPageAdmin extends StatefulWidget {
  final String image;
  final String chatId;
  final String userName;
  const ChatPageAdmin({Key? key, required this.chatId, required this.userName, required this.image,}) : super(key: key);

  @override
  State<ChatPageAdmin> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPageAdmin> {
  TextEditingController messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();


  TextEditingController titleController = TextEditingController();
  TextEditingController subtitleController = TextEditingController();
  TextEditingController artistController = TextEditingController();
  File? file;
  FilePickerResult? result;
  final formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final FocusNode focusNodeNickname = FocusNode();

  Timer? timer;

  List<dynamic> apiData = [];
  Future<void> chatAdminApi() async {
    // Replace 'your_token_here' with your actual token

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token =  prefs.getString('token',);
    final Uri uri = Uri.parse('https://api.astropanditharidwar.in/api/chat_get_admin/${widget.chatId}');
    final Map<String, String> headers = {'Authorization': 'Bearer $token'};

    final response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the data
      final Map<String, dynamic> responseData = json.decode(response.body);

      // Check if the response contains a 'data' key
      if (responseData.containsKey('chats')) {
        setState(() {
          // Assuming 'data' is a list, update apiData accordingly
          apiData = responseData['chats'];
          print(apiData);
        });
      } else {
        throw Exception('Invalid API response: Missing "data" key');
      }
    } else {
      // If the server did not return a 200 OK response,
      // throw an exception.
      throw Exception('Failed to load data');
    }
  }

  void _openFilePicker() async {
    FilePickerResult? result =await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png',],
    );

    if (result != null) {
      PlatformFile file = result.files.first;

      // Handle the selected file here
      String filePath = file.path ?? "";
      print('Selected file path: $filePath');

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

      final type = 'file';
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');


      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://api.astropanditharidwar.in/api/chat_admin/${widget.chatId}'),
      );

      // Add token to request headers
      request.headers['Authorization'] = 'Bearer $token';

      request.fields['chat_type'] = type!;
      if (file != null) {
        request.files.add(await http.MultipartFile.fromPath('chat',filePath));
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);


      // Close the progress dialog
      Navigator.pop(context);

      if (response.statusCode == 201) {
        print("Post added successfully");
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => AdminPage(),
        //   ),
        // );
      } else {
        print("Failed to add post. Error: ${response.body}");
        // Handle failure
      }




    } else {
      // User canceled the picker
      print('User canceled file picking');
    }
  }
  void sendMessage(String message) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    final response = await http.post(
      Uri.parse('https://api.astropanditharidwar.in/api/chat_admin/${widget.chatId}'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'chat': message,'chat_type': 'text'}),
    );

    if (response.statusCode == 200) {
      print('Message sent successfully!');
    } else {
      // Handle error
      print('Failed to send message: ${response.reasonPhrase}');
    }
  }






  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      // Scroll to the bottom after the widget is built
      _scrollToBottom();
    });

    chatAdminApi();
     timer = Timer.periodic(Duration(seconds: 1), (Timer t) => chatAdminApi());

  }

  @override
  void dispose() {
    _scrollController.dispose();
    timer?.cancel(); // Cancel timer to prevent memory leaks
    super.dispose();
  }


  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 0.0),
              child: SizedBox(
                width: 50,
                child: GestureDetector(
                  onTap: () {
                    // Add onTap functionality for the image here
                  },
                  child: Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.network(
                        widget.image,
                        fit: BoxFit.cover,
                        width: 50,
                        height: 50,
                        errorBuilder: (context, object, stackTrace) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(30), // Half of width/height for perfect circle
                            child: Image.network(
                              'https://cdn.pixabay.com/photo/2016/08/31/11/54/icon-1633249_640.png',
                              fit: BoxFit.cover,
                              width: 50,
                              height: 50,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(
                widget.userName,
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                      color: ColorSelect.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.orangeAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert), // Add your desired icon here
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Block User'),
                    content: Text('Are you sure you want to block this user?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          // Handle cancel action
                          Navigator.of(context).pop(false);
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () async {


                          // User clicked Yes
                          // Perform delete operation here

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
                          final response = await http.post(
                            Uri.parse(BlockUser),
                            headers: {
                              'Authorization': 'Bearer $token',
                              'Content-Type': 'application/json',
                            },
                            body: jsonEncode({'post_id': widget.chatId,}),
                          );
                          Navigator.of(context).pop();

                          if (response.statusCode == 200) {
                            print('Block User successfully!');



                            setState(() {
                              _isLoading = false;
                              Navigator.of(context).pop();
// Stop the progress bar
                            });
                          } else {
                            // Handle error
                            print('Failed to block user: ${response.reasonPhrase}');
                          }

                          setState(() {
                            _isLoading = false; // Stop the progress bar
                          });
                        },


                        child: Text('Block'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),


      body: Stack(
        children: <Widget>[

          // chat messages here
          // chatMessages(),


          ListView.builder(
            controller: _scrollController,
            itemCount: apiData.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  mainAxisAlignment: apiData[index]['flag'] == 1
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: apiData[index]['chat_type'] == 'text'
                          ? Container(
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: apiData[index]['flag'] == 1 ? Colors.blue : Colors.black,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child:Text(
                            apiData[index]['chat'],
                            textAlign: TextAlign.right,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            maxLines: 10,
                            style: TextStyle(
                              color: apiData[index]['flag'] == 0 ? Colors.white : Colors.black,
                            ),
                          ) // Empty container if message type is not recognized
                      )
                          : apiData[index]['chat_type'] == 'file'
                          ? Container(
                          width: 300,
                          height: 300,
                          decoration: BoxDecoration(
                            color: apiData[index]['flag'] == 1 ? Colors.grey : Colors.black,
                            borderRadius: BorderRadius.circular(10), // 150 is half of the width/height to make it a perfect circle
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: CachedNetworkImage(
                              height: 300,
                              width: 300,
                              imageUrl: apiData[index]['file'],
                              fit: BoxFit.cover, // Adjust this according to your requirement
                              placeholder: (context, url) => Center(
                                child: CircularProgressIndicator(
                                  color: Colors.orangeAccent,
                                ),
                              ),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                            ),
                          )

                      )

                          : Container(),
                    ),
                  ],
                ),
              );
            },
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              color: Colors.grey[700],
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: messageController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: "Send a message...",
                        hintStyle: TextStyle(color: Colors.white, fontSize: 16),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.orangeAccent,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.attach_file,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () {
                      final message = messageController.text;
                      if (message.isNotEmpty) {
                        setState(() {
                          messageController.clear();
                        });
                        sendMessage(message);
                        // Scroll to bottom after sending a message
                        _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        );
                      }
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.orangeAccent,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }

  chatMessages() {
    return Padding(

      padding: const EdgeInsets.only(bottom: 108.0),
      child: Container(
        child: Container(
          child: apiData.isEmpty
              ? Center(
            child: const Text(
              "Chat not found",
              style: TextStyle(
                color: Colors.black, // Choose your desired color
                fontSize: 16.0, // Choose your desired font size
              ),
            ),
          )
              : ListView.builder(
            controller: _scrollController,
            itemCount: apiData.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  mainAxisAlignment: apiData[index]['flag'] == 1
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: apiData[index]['chat_type'] == 'text'
                  ? Container(
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: apiData[index]['flag'] == 1 ? Colors.blue : Colors.black,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child:Text(
                          apiData[index]['chat'],
                          textAlign: TextAlign.right,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          maxLines: 10,
                          style: TextStyle(
                            color: apiData[index]['flag'] == 0 ? Colors.white : Colors.black,
                          ),
                        ) // Empty container if message type is not recognized
                      )
                          : apiData[index]['chat_type'] == 'file'
                          ? Container(
                        width: 300,
                        height: 300,
                          decoration: BoxDecoration(
                            color: apiData[index]['flag'] == 1 ? Colors.grey : Colors.black,
                            borderRadius: BorderRadius.circular(10), // 150 is half of the width/height to make it a perfect circle
                          ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: CachedNetworkImage(
                            height: 300,
                            width: 300,
                            imageUrl: apiData[index]['file'],
                            fit: BoxFit.cover, // Adjust this according to your requirement
                            placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(
                                color: Colors.orangeAccent,
                              ),
                            ),
                            errorWidget: (context, url, error) => Icon(Icons.error),
                          ),
                        )

                      )

                          : Container(),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );

  }

}
