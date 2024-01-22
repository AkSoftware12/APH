import 'package:aph/Home/home_%20deatils.dart';
import 'package:aph/Model/all_posts.dart';
import 'package:aph/Model/video_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Utils/color.dart';
import '../Utils/gradients.dart';
import '../Video Player/video.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {



  bool _isLoading = true;
  List<AllPostModel> allpost = [
    AllPostModel(
      id: '1',
      userImage:
          'https://c.saavncdn.com/057/Barse-Re-From-Manush-Hindi-Hindi-2023-20231113122507-500x500.jpg',
      userName: 'dsfshdvjbk',
      image:
          'https://c.saavncdn.com/205/Pakeezah-From-Do-Ajnabee-Hindi-2023-20231023153010-500x500.jpg',
      title: 'Ravikant Saini',
      comment: '01/01/2024 | 10:25 PM',
      isLiked: false,
      type: 'image', url: '',
    ),
    AllPostModel(
        id: '1',
        userImage:
            'https://api-private.atlassian.com/users/1a80abede0a9f4d0661e20d74bb6079b/avatar',
        userName: 'jfeaugihb',
        image:
            'https://c.saavncdn.com/744/The-Archies-Hindi-2023-20231127202131-500x500.jpg',
        title: 'Rajat Kumar',
        isLiked: false,
        comment: 'comment', type: 'image', url: ''),
    AllPostModel(
      id: '1',
      userImage:
          'https://c.saavncdn.com/216/Ishq-Nahi-Aasan-From-Anari-Is-Backk-Hindi-2023-20231207111403-500x500.jpg',
      userName: 'oeshioeon',
      image:
          'https://c.saavncdn.com/205/Pakeezah-From-Do-Ajnabee-Hindi-2023-20231023153010-500x500.jpg',
      title: 'Anuj Saini',
      comment: '01/01/2024 | 10:25 PM',
      isLiked: false, type: 'image', url: '',
    ),
    AllPostModel(
      id: '1',
      userImage:
          'https://c.saavncdn.com/616/Tiger-3-Hindi-2023-20231206092502-500x500.jpg',
      userName: 'bjdfjbi',
      image:
          'https://c.saavncdn.com/744/The-Archies-Hindi-2023-20231127202131-500x500.jpg',
      title: 'Rahul Kumar',
      comment: '01/01/2024 | 10:25 PM',
      isLiked: false, type: 'image', url: '',
    ),
    AllPostModel(
      id: '1',
      userImage:
          'https://c.saavncdn.com/172/Pippa-Hindi-2023-20231113184331-500x500.jpg',
      userName: 'ogipheg',
      image:
          'https://c.saavncdn.com/205/Pakeezah-From-Do-Ajnabee-Hindi-2023-20231023153010-500x500.jpg',
      title: 'Harshu Saini',
      comment: '01/01/2024 | 10:25 PM',
      isLiked: false, type: 'image', url: '',
    ),
    AllPostModel(
      id: '1',
      userImage:
          'https://c.saavncdn.com/120/Farrey-Hindi-2023-20231120143048-500x500.jpg',
      userName: 'ioheagioh',
      image:
          'https://c.saavncdn.com/744/The-Archies-Hindi-2023-20231127202131-500x500.jpg',
      title: 'Robin saini',
      comment: '01/01/2024 | 10:25 PM',
      isLiked: false, type: 'image', url: '',
    ),
  ];
  List<dynamic> apiData = [];



  // Add a variable to store the fetched data
  String? yourTextVariable;

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('http://74.208.221.57:3000/api/get/videos'));

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the data
      final Map<String, dynamic> responseData = json.decode(response.body);

      // Check if the response contains a 'data' key
      if (responseData.containsKey('data')) {
        setState(() {
          // Assuming 'data' is a list, update apiData accordingly
          apiData = responseData['data'];
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

  // Future apiCall() async {
  //   http.Response response;
  //   response = await http
  //       .get(Uri.parse("http://74.208.221.57:3000/api/get/videos"));
  //
  //   if (response.statusCode == 200) {
  //     var jsonResponse =
  //     convert.jsonDecode(response.body) as Map<String, dynamic>;
  //     var itemCount = jsonResponse['data'];
  //     print('Number of books about http: $itemCount.');
  //   } else {
  //     print('Request failed with status: ${response.statusCode}.');
  //   }
  // }

  @override
  void initState() {
    super.initState();
    // Simulate loading data after a delay
    // loadData();
     fetchData();


    // apiCall();

  }

  // void loadData() async {
  //   // Simulate data loading delay
  //   await Future.delayed(Duration(seconds: 2));
  //
  //   // Load your data into _data list
  //   // allpost = List.generate(10, (index) => 'Item $index');
  //
  //   // Set isLoading to false to hide ProgressBar
  //   setState(() {
  //     _isLoading = false;
  //   });
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSelect.background,
        body: Container(
      padding: EdgeInsets.all(10.0),
      child: Stack(
        children: [
          Container(
            child: Container(
              child: allpost.isEmpty
                  ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(ColorSelect.buttonColor),
                ),
              )
                  : ListView.builder(
                itemCount: allpost.length,
                itemBuilder: (context, index) {
                  AllPostModel currentComment = allpost[index];
                  return GestureDetector(
                      onTap: () {
                        //
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return VideoApp();
                            },
                          ),
                        );

                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) {
                        //       return HomeDetailsScreen( todo: allpost[index],);
                        //     },
                        //   ),
                        // );
                      },


                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0),
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
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius
                                          .zero, // This makes the card edges non-rounded
                                    ),
                                    child: Image.network(
                                      currentComment.image ,
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
                                    // child: Text(currentComment.userName),
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
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.center,
                                //   children: [
                                //     // Like icon
                                //     IconButton(
                                //       icon: currentComment.isLiked
                                //           ? Icon(Icons.thumb_up, color: Colors.red)
                                //           : Icon(Icons.thumb_up_alt_outlined),
                                //       onPressed: () {
                                //         setState(() {
                                //           // Toggle the like state
                                //           currentComment.isLiked =
                                //           !currentComment.isLiked;
                                //
                                //           // Perform additional logic if needed, such as updating like count on a server.
                                //         });
                                //       },
                                //     ),
                                //
                                //     // Like count
                                //     Text('42'),
                                //
                                //     // Spacer to create some space between like and comment
                                //     Spacer(),
                                //
                                //     // Comment icon
                                //     IconButton(
                                //       icon: Icon(Icons.comment),
                                //       onPressed: () {
                                //         // Handle comment button press
                                //       },
                                //     ),
                                //
                                //     // Comment count
                                //     Padding(
                                //       padding: const EdgeInsets.only(right: 8.0),
                                //       child: Text('7'),
                                //     ),
                                //   ],
                                // ),
                              ],
                            ),
                          ),
                        ),
                      )
                  );
                },
              ),
            ),

          ),

        ],
      ),
    ));
  }
}
