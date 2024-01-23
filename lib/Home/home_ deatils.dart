import 'package:aph/Model/all_comment.dart';
import 'package:aph/Model/all_posts.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Utils/color.dart';
import '../Video Player/demo.dart';
import '../constants/color_constants.dart';
import '../constants/firestore_constants.dart';


class HomeDetailsScreen extends StatefulWidget {
  const HomeDetailsScreen({super.key, required this.todo, required this.type});

  // Declare a field that holds the Todo.
  final AllPostModel todo;
  final String type;

  @override
  State<HomeDetailsScreen> createState() => _HomeDetailsScreenState();
}

class _HomeDetailsScreenState extends State<HomeDetailsScreen> {
  DateTime now = DateTime.now();

  TextEditingController _textEditingController = TextEditingController();
  TextEditingController commentController = TextEditingController();

  String id = '';
  String nickname = '';
  String aboutMe = '';
  String photoUrl = '';
  String userEmail = '';

  List<CommentModel> commentsList = [];
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
  void sendMessage() {
    String commentText = commentController.text;
    String formattedDate = "${now.day}/${now.month}/${now.year}";
    String formattedTime = "${now.hour}:${now.minute}";

    if (commentText.isNotEmpty) {
      CommentModel newComment = CommentModel(
        comment: commentText,
        formattedDate: formattedDate,
        formattedTime: formattedTime,
      );

      setState(() {
        commentsList.add(newComment);
        commentController.clear();

      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 65.0),
          child: Column(
            children: [
              // Card with Image
              Padding(
                padding: const EdgeInsets.only(top: 10.0,left: 15,right: 15),
                child: Card(
                  color: ColorSelect.textcolor,
                  elevation: 10,
                  child: Container(
                    decoration: BoxDecoration(
                      color: ColorSelect.textcolor,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 316,
                          width: double.infinity,
                          child: Card(
                              elevation: 5,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius
                                    .zero, // This makes the card edges non-rounded
                              ),
                              child: Card(
                                child: Column(
                                  children: [
                                    if (widget.todo.type == 'video')
                                      VideoPlayerScreen(url: widget.todo.url),
                                    if (widget.todo.type  == 'image')
                                      Container(
                                          height: 300,
                                          width: double.infinity,
                                          child: Image.network(widget.todo.url,fit: BoxFit.fill,)),
                                  ],
                                ),
                              )
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(widget.todo.title),
                            // child: Text(apiData[index]['video']),
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Like icon
                            IconButton(
                              icon: widget.todo.isLiked
                                  ? Icon(Icons.thumb_up, color: Colors.red)
                                  : Icon(Icons.thumb_up_alt_outlined),
                              onPressed: () {
                                setState(() {
                                  // Toggle the like state
                                  widget.todo.isLiked =
                                  !widget.todo.isLiked;

                                  // Perform additional logic if needed, such as updating like count on a server.
                                });
                              },
                            ),

                            // Like count
                            Text('42'),

                            // Spacer to create some space between like and comment
                            Spacer(),

                            // Comment icon
                            IconButton(
                              icon: Icon(Icons.comment),
                              onPressed: () {
                                // Handle comment button press
                              },
                            ),

                            // Comment count
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text('7'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.comment,size: 18,),
                    onPressed: () {
                      // Handle comment button press
                    },
                  ),
                  Text(
                    'Comments',
                    style: TextStyle(fontSize: 13, ),
                  ),


                ],
              ),
              // Display List of Comments
              ListView.builder(
                shrinkWrap: true,
                itemCount: commentsList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 8.0,right: 8),
                    child: Card(
                      elevation: 5,
                      color: ColorSelect.background,
                      child: Container(
                    decoration: BoxDecoration(
                    color: ColorSelect.textcolor,
                    borderRadius: BorderRadius.circular(10.0),
                    ),
                        child: ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                nickname,
                                style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                commentsList[index].comment,
                              ),
                              Text('${commentsList[index].formattedDate} | ${commentsList[index].formattedTime}', // Replace with your time variable
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Image.network(
                              photoUrl,
                              fit: BoxFit.cover,
                              width: 50,
                              height: 50,
                              errorBuilder: (context, object, stackTrace) {
                                return Icon(
                                  Icons.account_circle,
                                  size: 90,
                                  color: ColorConstants.greyColor,
                                );
                              },
                              loadingBuilder: (BuildContext context, Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  width: 90,
                                  height: 90,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: ColorConstants.themeColor,
                                      value: loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                          : null,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          // Add any additional comment-related UI components as needed
                        ),
                      ),

                    ),
                  );
                },
              ),





            ],
          ),
        ),
      ),
      bottomSheet: Container(
        decoration: BoxDecoration(
          color: ColorSelect.textcolor,
          border: Border.all(
            color: ColorSelect.buttonColor, // Set your desired border color here
            width: 1.0, // Set the width of the border
          ),
          borderRadius: BorderRadius.circular(10.0), // Set the border radius
        ),
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
                        width: 50,
                        height: 50,
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
                controller: commentController,
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
                sendMessage();
              },
            ),
          ],
        ),
      ),
    );
  }
}
