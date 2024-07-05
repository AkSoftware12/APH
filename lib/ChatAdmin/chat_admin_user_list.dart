import 'dart:async';
import 'dart:convert';

import 'package:aph/baseurlp/baseurl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../Utils/color.dart';
import '../Videocall/demo_call.dart';
import '../chatAdminUser/chat_admin_screen.dart';
import '../chatAdminUser/chat_controller.dart';
import '../constants/color_constants.dart';
import 'dart:io';

import '../ooo.dart';


class ChatAdminUserScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<ChatAdminUserScreen> {
  List<dynamic> apiData = [];
  bool _isLoading = false;
  Timer? timer;
  File? avatarImageFile;

  Future<void> chaiUserListApi() async {
    // Replace 'your_token_here' with your actual token

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token',);
    final Uri uri = Uri.parse(getUsers);
    final Map<String, String> headers = {'Authorization': 'Bearer $token'};

    final response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the data
      final Map<String, dynamic> responseData = json.decode(response.body);

      // Check if the response contains a 'data' key
      if (responseData.containsKey('users')) {
        setState(() {
          // Assuming 'data' is a list, update apiData accordingly
          apiData = responseData['users'];
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
    chaiUserListApi();

    timer = Timer.periodic(Duration(seconds: 2), (Timer t) => chaiUserListApi());

  }
  @override
  void dispose() {
    timer?.cancel(); // Cancel timer to prevent memory leaks
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: Container(
          padding: EdgeInsets.all(1.0),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 1.0),
                child: Container(
                  child: Container(
                    child: apiData.isEmpty
                        ? const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            ColorSelect.buttonColor),
                      ),
                    )
                        : ListView.builder(
                      itemCount: apiData.length,
                      itemBuilder: (context, index) {
                        return Container(
                          color: Colors.white,
                          child: Column(
                            children: [
                              ListTile(
                                leading: Container(
                                  child: avatarImageFile == null
                                      ? apiData[index]['picture_data']
                                      .isNotEmpty
                                      ? ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.network(
                                      apiData[index]['picture_data'],
                                      fit: BoxFit.cover,
                                      width: 60,
                                      height: 60,
                                      errorBuilder: (context, object,
                                          stackTrace) {
                                        return Icon(
                                          Icons.account_circle,
                                          size: 50,
                                          color: ColorConstants.greyColor,
                                        );
                                      },
                                      loadingBuilder: (BuildContext context,
                                          Widget child,
                                          ImageChunkEvent? loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Container(
                                          width: 50,
                                          height: 50,
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
                                      : Icon(
                                    Icons.account_circle,
                                    size: 50,
                                    color: ColorConstants.greyColor,
                                  )
                                      : ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: Image.file(
                                      avatarImageFile!,
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  apiData[index]['name'].toString(),
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                subtitle: Text(
                                    apiData[index]['email'].toString()),
                                trailing: apiData[index]['status'] == 0
                                    ? GestureDetector(
                                  onTap: () async {


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
                                      Uri.parse(UnblockUser),
                                      headers: {
                                        'Authorization': 'Bearer $token',
                                        'Content-Type': 'application/json',
                                      },
                                      body: jsonEncode({'user_id': apiData[index]['id'],}),
                                    );
                                    Navigator.of(context).pop();

                                    if (response.statusCode == 200) {
                                      print('UnBlock User successfully!');



                                      setState(() {
                                        _isLoading = false;
// Stop the progress bar
                                      });
                                    } else {
                                      // Handle error
                                      print('Failed to Unblock user: ${response.reasonPhrase}');
                                    }

                                    setState(() {
                                      _isLoading = false; // Stop the progress bar
                                    });

                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('  Unblock  '),
                                    ),
                                  ),
                                ) // Replace with your block icon
                                    : GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return ChangeNotifierProvider(
                                            create: (_) => ChatController(),
                                            child: ChatScreen1(
                                              chatId: apiData[index]['id']
                                                  .toString(),
                                              userName: apiData[index]['name']
                                                  .toString(),
                                              image: apiData[index]['picture_data']
                                                  .toString(),
                                            ),
                                          );
                                        },
                                      ),
                                    );

                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (context) {
                                    //       return ChangeNotifierProvider(
                                    //         create: (_) => ChatController(),
                                    //         child: ChatScreen(
                                    //           chatId: apiData[index]['id']
                                    //               .toString(),
                                    //           userName: apiData[index]['name']
                                    //               .toString(),
                                    //           image: apiData[index]['picture_data']
                                    //               .toString(),
                                    //         ),
                                    //       );
                                    //     },
                                    //   ),
                                    // );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('message'),
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
              ),

            ],
          ),
        ));
  }
}



