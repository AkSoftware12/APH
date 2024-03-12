import 'dart:convert';

import 'package:aph/baseurlp/baseurl.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../Utils/color.dart';


class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<dynamic> apiData = [];
  Future<void> notificationApi() async {
    // Replace 'your_token_here' with your actual token

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token =  prefs.getString('token',);
    final Uri uri = Uri.parse(notifications);
    final Map<String, String> headers = {'Authorization': 'Bearer $token'};

    final response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the data
      final Map<String, dynamic> responseData = json.decode(response.body);

      // Check if the response contains a 'data' key
      if (responseData.containsKey('notifications')) {
        setState(() {
          // Assuming 'data' is a list, update apiData accordingly
          apiData = responseData['notifications'];
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
    notificationApi();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(
          backgroundColor: Colors.orangeAccent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text('Notification'),
        ),


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
                        valueColor: AlwaysStoppedAnimation<Color>(ColorSelect.buttonColor),
                      ),
                    )
                        : ListView.builder(
                      itemCount: apiData.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              color: Colors.white,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 1.0),
                                    child: ListTile(
                                      leading:  SizedBox(
                                          width: 35,
                                          height: 35,
                                          child: Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRW1M6rWv6rw08_Q-pe5saIIzYFgYrgwy_taMlDxjqOZ5j3gRPY2RtnbNrvhQ&s')),
                                      title: Text(apiData[index]['note'].toString()),
                                      subtitle: Text(apiData[index]['created_at'].toString()),
                                      trailing: Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(apiData[index]['id'].toString()),

                                        ],
                                      ),


                                    ),

                                  ),
                                  const Divider(
                                    color: Colors.grey, // Set the color of the divider
                                    thickness: 1.0, // Set the thickness of the divider
                                    height: 1, // Set the height of the divider
                                  ),
                                ],
                              )
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



