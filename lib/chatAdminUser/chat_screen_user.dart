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

import '../Utils/color.dart';
import '../baseurlp/baseurl.dart';
import 'chat.dart';
import 'chat_controller.dart';
import 'package:http/http.dart' as http;

class ChatUserScreen extends StatefulWidget {
  const ChatUserScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ChatUserScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatUserScreen> {
  TextEditingController messageController = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  TextEditingController titleController = TextEditingController();
  TextEditingController subtitleController = TextEditingController();
  TextEditingController artistController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final FocusNode focusNodeNickname = FocusNode();
  Timer? timer;
  bool _isPressed = false;

  List<dynamic> apiData = [];

  Future<void> chatApi() async {
    // Replace 'your_token_here' with your actual token

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString(
      'token',
    );
    final Uri uri =
        Uri.parse('https://api.astropanditharidwar.in/api/chat_get_user');
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
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'jpg',
        'jpeg',
        'png',
      ],
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
        Uri.parse('https://api.astropanditharidwar.in/api/chat_user'),
      );

      // Add token to request headers
      request.headers['Authorization'] = 'Bearer $token';

      request.fields['chat_type'] = type!;
      if (file != null) {
        request.files.add(await http.MultipartFile.fromPath('chat', filePath));
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
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text('Admin Chat'),
        backgroundColor: Colors.orangeAccent,
        actions: [],
      ),
      body: Stack(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                context.read<ChatController>().focusNode.unfocus();
                // FocusScope.of(context).unfocus();
              },
              child: Align(
                alignment: Alignment.topCenter,
                child: Selector<ChatController, List<Chat>>(
                  selector: (context, controller) =>
                      controller.chatList.reversed.toList(),
                  builder: (context, chatList, child) {
                    return Stack(
                      children: [
                        Image.asset(
                          'assets/astrology_bg.png',
                          // Replace 'assets/background_image.jpg' with your image path
                          fit: BoxFit.cover,
                          // Adjust the fit according to your requirement
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                        ),
                        ListView.separated(
                          shrinkWrap: true,
                          reverse: true,
                          padding: const EdgeInsets.only(top: 1, bottom: 2) +
                              const EdgeInsets.symmetric(horizontal: 12),
                          separatorBuilder: (_, __) => const SizedBox(
                            height: 2,
                          ),
                          controller:
                              context.read<ChatController>().scrollController,
                          itemCount: apiData.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.symmetric(vertical: 5.0),
                              child: Row(
                                mainAxisAlignment: apiData[index]['flag'] == 0
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (apiData[index]['flag'] == 0) {
                                        // Add your click functionality here
                                        print('Container clicked!');
                                      }
                                    },
                                    onLongPress: () {
                                      if (apiData[index]['flag'] == 0) {
                                        setState(() {
                                          _isPressed = true;
                                          showModalBottomSheet(
                                            context: context,
                                            builder: (BuildContext bc) {
                                              return Container(
                                                height: 150,
                                                child: Wrap(
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 8.0),
                                                      child: ListTile(
                                                        leading:
                                                            Icon(Icons.copy),
                                                        title: Text('Copy'),
                                                        onTap: () {
                                                          // Add functionality to remove data or perform any action here
                                                          // For demonstration, simply print a message
                                                          print('Item removed');
                                                          Navigator.of(context)
                                                              .pop(); // Close the bottom sheet
                                                        },
                                                      ),
                                                    ),
                                                    ListTile(
                                                      leading:
                                                          Icon(Icons.delete),
                                                      title:
                                                          Text('Delete Chat'),
                                                      onTap: () async {
                                                        Navigator.of(context)
                                                            .pop();

                                                        showDialog(
                                                          context: context,
                                                          barrierDismissible:
                                                              false,
                                                          // Prevent user from dismissing dialog
                                                          builder: (BuildContext
                                                              context) {
                                                            return Center(
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  CircularProgressIndicator(
                                                                    color: Colors
                                                                        .orangeAccent,
                                                                  ),
                                                                  // SizedBox(width: 16.0),
                                                                  // Text("Logging in..."),
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                        );

                                                        try {
                                                          final SharedPreferences
                                                              prefs =
                                                              await SharedPreferences
                                                                  .getInstance();
                                                          final String? token =
                                                              prefs.getString(
                                                                  'token');
                                                          final response =
                                                              await http.post(
                                                            Uri.parse(
                                                                chatDelete),
                                                            headers: {
                                                              'Authorization':
                                                                  'Bearer $token',
                                                              'Content-Type':
                                                                  'application/json',
                                                            },
                                                            body: jsonEncode({
                                                              'chat_id':
                                                                  apiData[index]
                                                                      ['id'],
                                                            }),
                                                          );

                                                          if (response
                                                                  .statusCode ==
                                                              200) {
                                                            print(response);

                                                            // If the server returns a 200 OK response, parse the data
                                                          } else {
                                                            // If the server did not return a 200 OK response,
                                                            // throw an exception.
                                                            throw Exception(
                                                                'Failed to load data');
                                                          }
                                                        } catch (e) {
                                                          Navigator.pop(
                                                              context); // Close the progress dialog
                                                          // Handle errors appropriately
                                                        }
                                                        Navigator.of(context)
                                                            .pop();

                                                        // Close the bottom sheet
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        });
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child:
                                          apiData[index]['chat_type'] == 'text'
                                              ? Container(
                                                  padding: EdgeInsets.all(10.0),
                                                  decoration: BoxDecoration(
                                                    color: apiData[index]
                                                                ['flag'] ==
                                                            0
                                                        ? Colors.blue
                                                        : Colors.black,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  child: Text(
                                                    apiData[index]['chat'],
                                                    textAlign: TextAlign.right,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    softWrap: true,
                                                    maxLines: 10,
                                                    style: TextStyle(
                                                      color: apiData[index]
                                                                  ['flag'] ==
                                                              1
                                                          ? Colors.white
                                                          : Colors.black,
                                                    ),
                                                  ),
                                                )
                                              : apiData[index]['chat_type'] ==
                                                      'file'
                                                  ? Container(
                                                      width: 300,
                                                      height: 300,
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          if (apiData[index]
                                                                  ['flag'] ==
                                                              0) {
                                                            // Add your click functionality here
                                                            print(
                                                                'Container clicked!');
                                                          }
                                                        },
                                                        onLongPress: () {
                                                          if (apiData[index]
                                                                  ['flag'] ==
                                                              0) {
                                                            setState(() {
                                                              _isPressed = true;
                                                              showModalBottomSheet(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        bc) {
                                                                  return Container(
                                                                    height: 150,
                                                                    child: Wrap(
                                                                      children: <Widget>[
                                                                        Padding(
                                                                          padding: const EdgeInsets
                                                                              .only(
                                                                              top: 8.0),
                                                                          child:
                                                                              ListTile(
                                                                            leading:
                                                                                Icon(Icons.copy),
                                                                            title:
                                                                                Text('Copy'),
                                                                            onTap:
                                                                                () {
                                                                              // Add functionality to remove data or perform any action here
                                                                              // For demonstration, simply print a message
                                                                              print('Item removed');
                                                                              Navigator.of(context).pop(); // Close the bottom sheet
                                                                            },
                                                                          ),
                                                                        ),
                                                                        ListTile(
                                                                          leading:
                                                                              Icon(Icons.delete),
                                                                          title:
                                                                              Text('Delete Chat'),
                                                                          onTap:
                                                                              () async {
                                                                            Navigator.of(context).pop();

                                                                            showDialog(
                                                                              context: context,
                                                                              barrierDismissible: false,
                                                                              // Prevent user from dismissing dialog
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

                                                                            try {
                                                                              final SharedPreferences prefs = await SharedPreferences.getInstance();
                                                                              final String? token = prefs.getString('token');
                                                                              final response = await http.post(
                                                                                Uri.parse(chatDelete),
                                                                                headers: {
                                                                                  'Authorization': 'Bearer $token',
                                                                                  'Content-Type': 'application/json',
                                                                                },
                                                                                body: jsonEncode({
                                                                                  'chat_id': apiData[index]['id'],
                                                                                }),
                                                                              );

                                                                              if (response.statusCode == 200) {
                                                                                print(response);

                                                                                // If the server returns a 200 OK response, parse the data
                                                                              } else {
                                                                                // If the server did not return a 200 OK response,
                                                                                // throw an exception.
                                                                                throw Exception('Failed to load data');
                                                                              }
                                                                            } catch (e) {
                                                                              Navigator.pop(context); // Close the progress dialog
                                                                              // Handle errors appropriately
                                                                            }
                                                                            Navigator.of(context).pop();

                                                                            // Close the bottom sheet
                                                                          },
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  );
                                                                },
                                                              );
                                                            });
                                                          }
                                                        },
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: apiData[index]
                                                                        [
                                                                        'flag'] ==
                                                                    0
                                                                ? Colors.grey
                                                                : Colors.black,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                            child:
                                                                CachedNetworkImage(
                                                              height: 300,
                                                              width: 300,
                                                              imageUrl:
                                                                  apiData[index]
                                                                      ['file'],
                                                              fit: BoxFit.cover,
                                                              placeholder:
                                                                  (context,
                                                                          url) =>
                                                                      Center(
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  color: Colors
                                                                      .orangeAccent,
                                                                ),
                                                              ),
                                                              errorWidget: (context,
                                                                      url,
                                                                      error) =>
                                                                  Icon(Icons
                                                                      .error),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  : Container(),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                      ],
                    );
                  },
                ),
              ),
            ),
          ),

          // const _BottomInputField(),

          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                alignment: Alignment.bottomCenter,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  width: MediaQuery.of(context).size.width,


                  decoration: BoxDecoration(
                    color: Colors.grey[700],
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(children: [
                    Flexible(
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
                      onTap: _openFilePicker,
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
                    const SizedBox(
                      width: 12,
                    ),
                    GestureDetector(
                      onTap: () async {
                        final message = messageController.text;
                        if (messageController.text.isNotEmpty) {
                          setState(() {
                            messageController.clear();
                          });
                        }
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        final String? token = prefs.getString('token');
                        final response = await http.post(
                          Uri.parse(
                              'https://api.astropanditharidwar.in/api/chat_user'),
                          headers: {
                            'Authorization': 'Bearer $token',
                            'Content-Type': 'application/json',
                          },
                          body: jsonEncode(
                              {'chat': message, 'chat_type': 'text'}),
                        );

                        if (response.statusCode == 200) {
                          print('msg successfully!');
                        } else {
                          // Handle error
                          print(
                              'Failed to comment post: ${response.reasonPhrase}');
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
              )),
        ],
      ),
    );
  }

  CustomClipper<Path>? get clipperOnType {
    return null;
  }
}

/// Bottom Fixed Filed
class _BottomInputField extends StatelessWidget {
  const _BottomInputField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      child: Container(
        constraints: const BoxConstraints(minHeight: 48),
        width: double.infinity,
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Color(0xFFE5E5EA),
            ),
          ),
        ),
        child: Stack(
          children: [
            TextField(
              focusNode: context.read<ChatController>().focusNode,
              onChanged: context.read<ChatController>().onFieldChanged,
              controller: context.read<ChatController>().textEditingController,
              maxLines: null,
              textAlignVertical: TextAlignVertical.top,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.only(
                  right: 42,
                  left: 16,
                  top: 18,
                ),
                hintText: 'message',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            // custom suffix btn

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
            Positioned(
              bottom: 0,
              right: 0,
              child: IconButton(
                icon: SvgPicture.asset(
                  "assets/icons/send.svg",
                  colorFilter: ColorFilter.mode(
                    context.select<ChatController, bool>(
                            (value) => value.isTextFieldEnable)
                        ? const Color(0xFF007AFF)
                        : const Color(0xFFBDBDC2),
                    BlendMode.srcIn,
                  ),
                ),
                onPressed: context.read<ChatController>().onFieldSubmitted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
