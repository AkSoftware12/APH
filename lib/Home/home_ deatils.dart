import 'package:aph/Model/all_posts.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Utils/color.dart';
import '../constants/color_constants.dart';
import '../constants/firestore_constants.dart';


class HomeDetailsScreen extends StatefulWidget {
  const HomeDetailsScreen({super.key, required this.todo});

  // Declare a field that holds the Todo.
  final AllPostModel todo;

  @override
  State<HomeDetailsScreen> createState() => _HomeDetailsScreenState();
}

class _HomeDetailsScreenState extends State<HomeDetailsScreen> {

  TextEditingController _textEditingController = TextEditingController();

  String id = '';
  String nickname = '';
  String aboutMe = '';
  String photoUrl = '';
  String userEmail = '';


  @override
  void initState() {
    super.initState();
    readLocal();
  }

  Future<void> readLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      id = prefs.getString(FirestoreConstants.id) ?? "";
      nickname = prefs.getString(FirestoreConstants.nickname) ?? "";
      photoUrl = prefs.getString(FirestoreConstants.photoUrl) ?? "";
      userEmail = prefs.getString(FirestoreConstants.userEmail) ?? "";
    });

    // controllerNickname = TextEditingController(text: nickname);
    // controllerEmail = TextEditingController(text: userEmail);
    // controllerAboutMe = TextEditingController(text: aboutMe);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Card with Image
            Padding(
              padding: const EdgeInsets.all( 10.0),
              child: Card(
                color: ColorSelect.textcolor,
                elevation: 5,
                child: Container(
                  decoration: BoxDecoration(
                    color: ColorSelect.textcolor,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 300,
                        width: double.infinity,
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius
                                .zero, // This makes the card edges non-rounded
                          ),
                          child: Image.network(
                            widget.todo.image,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(widget.todo.userName),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Divider(
                        height: 1,
                        color: ColorSelect.subtextcolor.shade300,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // Like icon
                          IconButton(
                            icon: widget.todo.isLiked
                                ? Icon(Icons.thumb_up, color: Colors.red)
                                : Icon(Icons.thumb_up_alt_outlined),
                            onPressed: () {
                              // setState(() {
                              //   // Toggle the like state
                              //   todo.isLiked =
                              //   !todo.isLiked;
                              //
                              //   // Perform additional logic if needed, such as updating like count on a server.
                              // });
                            },
                          ),

                          // Like count
                          Text('42'),

                          // Spacer to create some space between like and comment


                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.comment),
                    onPressed: () {
                      // Handle comment button press
                    },
                  ),
                  Text(
                    'Comments',
                    style: TextStyle(fontSize: 20, ),
                  ),
                ],
              ),
            ),


          ],
        ),
      ),
      bottomSheet:  Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Stack(fit: StackFit.loose, children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.network(
                        photoUrl,
                        fit: BoxFit.cover,
                        width: 60,
                        height: 60,
                        errorBuilder: (context, object, stackTrace) {
                          return Icon(
                            Icons.account_circle,
                            size: 90,
                            color: ColorConstants.greyColor,
                          );
                        },
                        loadingBuilder: (BuildContext context,
                            Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            width: 90,
                            height: 90,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: ColorConstants.themeColor,
                                value: loadingProgress
                                    .expectedTotalBytes !=
                                    null
                                    ? loadingProgress
                                    .cumulativeBytesLoaded /
                                    loadingProgress
                                        .expectedTotalBytes!
                                    : null,
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ]),
            ),
            SizedBox(width: 10.0),
            // Text Input for Chat
            Expanded(
              child: TextField(
                controller: _textEditingController,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(width: 10.0),

            // Send Button
            IconButton(
              icon: Icon(Icons.send),
              onPressed: () {
                // Handle send button press
                String message = _textEditingController.text;
                // Add your logic for sending the message
                print('Sending message: $message');
                // Clear the text input after sending the message
                _textEditingController.clear();
              },
            ),
          ],
        ),
      )
    );
  }
}
