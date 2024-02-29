
import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Utils/color.dart';
import 'package:http/http.dart' as http;

import '../../baseurlp/baseurl.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key,}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController messageController = TextEditingController();
  Timer? timer;

  List<dynamic> apiData = [];
  Future<void> chatApi() async {
    // Replace 'your_token_here' with your actual token

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token =  prefs.getString('token',);
    final Uri uri = Uri.parse('https://api.astropanditharidwar.in/api/chat_get_user');
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
  @override
  void initState() {
    super.initState();
    // chatApi();
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => chatApi());

  }

  @override
  void dispose() {
    timer?.cancel(); // Cancel timer to prevent memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text('Admin Chat'),
        backgroundColor: Colors.orangeAccent,
        actions: [
        ],
      ),
      body: Stack(
        children: <Widget>[
          // chat messages here
          chatMessages(),
          Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              width: MediaQuery.of(context).size.width,
              color: Colors.grey[700],
              child: Row(children: [
                Expanded(
                    child: TextFormField(
                  controller: messageController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: "Send a message...",
                    hintStyle: TextStyle(color: Colors.white, fontSize: 16),
                    border: InputBorder.none,
                  ),
                )),
                const SizedBox(
                  width: 12,
                ),
                GestureDetector(
                  onTap: () async {
                    final message = messageController.text;
                    final SharedPreferences prefs = await SharedPreferences.getInstance();
                    final String? token =  prefs.getString('token');
                    final response = await http.post(
                      Uri.parse('https://api.astropanditharidwar.in/api/chat_user'),
                      headers: {
                        'Authorization': 'Bearer $token',
                        'Content-Type': 'application/json',
                      },
                      body: jsonEncode({'chat': message}),
                    );

                    if (response.statusCode == 200) {
                      print('msg successfully!');
                    } else {
                      // Handle error
                      print('Failed to comment post: ${response.reasonPhrase}');
                    }

                    if (messageController.text.isNotEmpty) {
                      setState(() {
                        messageController.clear();
                      });
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
                    )),
                  ),
                )
              ]),
            ),
          )
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
            itemCount: apiData.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  mainAxisAlignment: apiData[index]['flag'] == 0
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: apiData[index]['flag'] == 0
                              ? Colors.blue
                              : Colors.black,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Text(
                          apiData[index]['chat'],
                          textAlign: TextAlign.right,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          maxLines: 10,
                          style: TextStyle(
                            color: apiData[index]['flag'] == 1
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
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
