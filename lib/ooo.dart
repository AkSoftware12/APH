
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Model/popup_choices.dart';
import '../Utils/color.dart';
import '../baseurlp/baseurl.dart';
import 'package:http/http.dart' as http;

class OppoScreen extends StatefulWidget {
  final String chatId;

  const OppoScreen({Key? key, required this.chatId,}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<OppoScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<String> _messages = [];


  //

  TextEditingController messageController = TextEditingController();

  TextEditingController titleController = TextEditingController();
  TextEditingController subtitleController = TextEditingController();
  TextEditingController artistController = TextEditingController();
  File? file;
  FilePickerResult? result;
  final formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final FocusNode focusNodeNickname = FocusNode();
  bool _isPressed = false;

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

    messageController.clear();
    setState(() {
      apiData.insert(0, message);
    });
    _scrollController.animateTo(
      0.0,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );

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
    //
    // WidgetsBinding.instance?.addPostFrameCallback((_) {
    //   // Scroll to the bottom after the widget is built
    //   // _scrollToBottom();
    // });

    chatAdminApi();
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => chatAdminApi());

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        child: Column(
          children: <Widget>[
            Flexible(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: apiData.length,
                reverse: true,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(apiData[index]['chat']),
                  );
                },
              ),
            ),
            Divider(height: 1.0),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
              ),
              child: _buildTextComposer(),
            ),
          ],
        ),


      ),
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).dividerColor),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: messageController,
                onSubmitted: sendMessage,
                decoration:
                InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: () => sendMessage(messageController.text),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    setState(() {
      _messages.insert(0, text);
    });
    _scrollController.animateTo(
      0.0,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
  }
}