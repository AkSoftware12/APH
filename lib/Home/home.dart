
import 'dart:async';
import 'dart:typed_data';
import 'package:aph/baseurlp/baseurl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../Utils/color.dart';
class Item {
  final String name;
  final String category;

  Item({required this.name, required this.category});
}


class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer? timer;

  GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
  GlobalKey<RefreshIndicatorState>();

  String nickname = '';
  String photoUrl = '';
  bool _isLiked = false;

  bool _isLoading = true;
  List<dynamic> apiData = [];

  String? yourTextVariable;


  Future<void> fetchData() async {
    // Replace 'your_token_here' with your actual token

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token =  prefs.getString('token',);
    final Uri uri = Uri.parse(home);
    final Map<String, String> headers = {'Authorization': 'Bearer $token'};

    final response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the data
      final Map<String, dynamic> responseData = json.decode(response.body);

      // Check if the response contains a 'data' key
      if (responseData.containsKey('posts')) {
        setState(()  {
          // Assuming 'data' is a list, update apiData accordingly
          apiData = responseData['posts'];

          // await saveDataLocally(responseData['posts']);
        });
      } else {
        throw Exception('Invalid API response: Missing "data" key');
      }
    }
  }
  Future<void> fetchProfileData() async {
    await  Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = true;
    });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString(
      'token',
    );
    final Uri uri = Uri.parse(getProfile);
    final Map<String, String> headers = {'Authorization': 'Bearer $token'};
    final response = await http.get(uri, headers: headers);

    setState(() {
      _isLoading =
      false; // Set loading state to false after registration completes
    });
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      setState(() {
        nickname = jsonData['user']['name'];
        photoUrl = jsonData['user']['picture_data'];
      });
    }
  }
  bool admin = true;
  String? adminButton='';
  bool _isPressed = false;


  @override
  void dispose() {
    timer?.cancel(); // Cancel timer to prevent memory leaks
    super.dispose();
  }


  @override
  void initState() {
    super.initState();


    adminButton1();
    fetchData();

    fetchProfileData();
    timer = Timer.periodic(Duration(seconds: 2), (Timer t) =>    fetchData());
    timer = Timer.periodic(Duration(seconds: 5), (Timer t) =>    fetchProfileData());


  }

  Future<void> adminButton1() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
     adminButton = prefs.getString('adminButton');



  }
  whatsapp() async{
    var contact = "+916397199758";
    var androidUrl = "whatsapp://send?phone=$contact&text=Hi, I need some help";
    var iosUrl = "https://wa.me/$contact?text=${Uri.parse('Hi, I need some help')}";

    try{
      await launchUrl(Uri.parse(androidUrl));

    } on Exception{
      // EasyLoading.showError('WhatsApp is not installed.');
    }
  }

  Future<void> _openFacebook() async {
    String fbProtocolUrl;
    fbProtocolUrl = 'fb://page/{your-page-id}';


    String fallbackUrl = 'https://www.facebook.com/{your-page-uri}';

    try {
      Uri fbBundleUri = Uri.parse(fbProtocolUrl);
      var canLaunchNatively = await canLaunchUrl(fbBundleUri);

      if (canLaunchNatively) {
        launchUrl(fbBundleUri);
      } else {
        await launchUrl(Uri.parse(fallbackUrl),
            mode: LaunchMode.externalApplication);
      }
    } catch (e, st) {
      // Handle this as you prefer
    }
  }

  void _showBottomSheet(BuildContext context, int index) {
    TextEditingController messageController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Enable full-screen mode
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.4,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.comment, size: 18),
                              onPressed: () {
                                // Handle comment button press
                              },
                            ),
                            Text(
                              'Comments',
                              style: TextStyle(fontSize: 13,color: Colors.black),
                            ),
                          ],
                        ),
                        RefreshIndicator(
                          onRefresh: fetchData,
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: apiData[index]['comments'].length,
                            itemBuilder: (BuildContext context, int commentIndex) {
                              var comments = apiData[index]['comments'];

                              // Check if comments list is empty
                              if (comments.isEmpty) {
                                setState(() {
                                  apiData[index]['comments'];
                                });
                                return ListTile(
                                  title: Text('No comments'),
                                );
                              }

                              // If comments list is not empty, display comments
                              var comment = comments[commentIndex];
                              return GestureDetector(
                                onLongPress: () {
                                  if (comment['user']['id'] == comment['user_id']) {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext bc) {
                                        return Container(
                                          height: 150,
                                          child: Wrap(
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(top: 8.0),
                                                child: ListTile(
                                                  leading: Icon(Icons.copy),
                                                  title: Text('Copy'),
                                                  onTap: () {
                                                    // Add functionality to remove data or perform any action here
                                                    // For demonstration, simply print a message
                                                    print('Item removed');
                                                    Navigator.of(context).pop(); // Close the bottom sheet
                                                  },
                                                ),
                                              ),
                                              ListTile(
                                                leading: Icon(Icons.delete),
                                                title: Text('Remove'),
                                                onTap: () {
                                                  Navigator.of(context).pop(); // Close the bottom sheet
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  }
                                },
                                child: ListTile(
                                  title: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        comment['user']['name'],
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        comment['comment'],
                                      ),
                                    ],
                                  ),
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: Image.network(
                                      comment['user']['picture_data'],
                                      fit: BoxFit.cover,
                                      width: 50,
                                      height: 50,
                                      errorBuilder: (context, object, stackTrace) {
                                        return ClipRRect(
                                          borderRadius: BorderRadius.circular(30), // Half of width/height for perfect circle
                                          child: Image.network(
                                            'https://w7.pngwing.com/pngs/178/595/png-transparent-user-profile-computer-icons-login-user-avatars-thumbnail.png',
                                            fit: BoxFit.cover,
                                            width: 50,
                                            height: 50,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            controller: messageController,
                            decoration: InputDecoration(
                              hintText: 'Type your message...',
                            ),
                            style: TextStyle(
                              color: Colors.black
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.send),
                          onPressed: () async {
                            final message = messageController.text;
                            if (messageController.text.isNotEmpty) {
                              setState(() {
                                messageController.clear();
                              });
                            }
                            final SharedPreferences prefs = await SharedPreferences.getInstance();
                            final String? token = prefs.getString('token');
                            final response = await http.post(
                              Uri.parse(comment),
                              headers: {
                                'Authorization': 'Bearer $token',
                                'Content-Type': 'application/json',
                              },
                              body: jsonEncode({'post_id': apiData[index]['id'], 'comment': message}),
                            );

                            if (response.statusCode == 200) {
                              print('comment successfully!');
                            } else {
                              // Handle error
                              print('Failed to comment post: ${response.reasonPhrase}');
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }


  final List<Item> items = [
    Item(name: 'Item 0', category: 'All'),
    Item(name: 'Item 1', category: 'video'),
    Item(name: 'Item 2', category: 'image'),

  ];

  // Selected category from horizontal list
  String selectedCategory = 'All';
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
      padding: EdgeInsets.all(0.0),
      child: Stack(
        children: [

          Container(
            height: 50,
            color: Colors.orangeAccent,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = item.category;
                    });
                  },
                  child: Container(
                    width: 80,
                    height: 50,
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: item.category == selectedCategory
                          ? Colors.black
                          : Colors.grey,
                      borderRadius: BorderRadius.circular(10), // Adjust the value to change the roundness
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      item.category,
                      style: const TextStyle(fontSize: 18,
                        color: Colors.white,
                      ),

                    ),
                  ),

                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: RefreshIndicator(
              key: refreshIndicatorKey,
              onRefresh: fetchProfileData,
              child: Padding(
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
                        final item = apiData[index];

                        if (item['file_type'] == selectedCategory) {
                          return GestureDetector(
                              onTap: () {
                              },

                              child: Padding(
                                padding: const EdgeInsets.only(top: 1.0),

                                child: Container(
                                  decoration: BoxDecoration(
                                    color: ColorSelect.textcolor,
                                    borderRadius: BorderRadius.circular(0.0),
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [

                                            Row(
                                              children: [


                                                Padding(
                                                  padding:  EdgeInsets.only(left: 5.sp),
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(30),
                                                    child: Image.network(
                                                      '',
                                                      fit: BoxFit.cover,
                                                      width: 50,
                                                      height: 50,
                                                      errorBuilder: (context, object, stackTrace) {
                                                        return ClipRRect(
                                                          borderRadius: BorderRadius.circular(30), // Half of width/height for perfect circle
                                                          child: Image.network(
                                                            'https://w7.pngwing.com/pngs/178/595/png-transparent-user-profile-computer-icons-login-user-avatars-thumbnail.png',
                                                            fit: BoxFit.cover,
                                                            width: 50,
                                                            height: 50,
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),

                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:  EdgeInsets.only(left: 5.sp),
                                                      child: Text('Name',
                                                        style: GoogleFonts.poppins(
                                                          textStyle:  TextStyle(
                                                              color: ColorSelect.black,
                                                              fontSize: 15.sp,
                                                              fontWeight: FontWeight.bold),
                                                        ),
                                                      ),
                                                      // child: Text(apiData[index]['video']),
                                                    ),
                                                    Padding(
                                                      padding:  EdgeInsets.only(left: 8.sp),
                                                      child: Text('${apiData[index]['time_difference'].toString()} ${'ago'}',
                                                        style: GoogleFonts.poppins(
                                                          textStyle:  TextStyle(
                                                              color: ColorSelect.black,
                                                              fontSize: 11.sp,
                                                              fontWeight: FontWeight.normal),
                                                        ),),
                                                    ),


                                                  ],
                                                )

                                              ],
                                            ),
                                            // Comment count
                                            Spacer(),

                                            // Spacer to create some space between like and comment
                                            Spacer(),

                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: GestureDetector(
                                                onTap: () {
                                                  whatsapp();
                                                },
                                                child: Image.asset(
                                                  'assets/whatsapp.png',
                                                  width: 30,
                                                  height: 30,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: GestureDetector(
                                                onTap: () {
                                                  _openFacebook();
                                                },
                                                child: Image.asset(
                                                  'assets/facebook.png',
                                                  width: 30,
                                                  height: 30,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),



                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: adminButton != null
                                                  ? IconButton(
                                                icon: Icon(Icons.delete),
                                                onPressed: () async {
                                                  showDialog(
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Text('Delete Post?',
                                                          style: TextStyle(
                                                            color: Colors.black
                                                          ),
                                                        ),
                                                        content: Text('Are you sure you want to delete this post?',
                                                          style: TextStyle(
                                                              color: Colors.black
                                                          ),
                                                        ),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            onPressed: () {
                                                              // User clicked No
                                                              Navigator.of(context).pop();
                                                            },
                                                            child: Text('No'),
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
                                                                Uri.parse(PostDelete),
                                                                headers: {
                                                                  'Authorization': 'Bearer $token',
                                                                  'Content-Type': 'application/json',
                                                                },
                                                                body: jsonEncode({'post_id': apiData[index]['id'],}),
                                                              );
                                                              Navigator.of(context).pop();

                                                              if (response.statusCode == 200) {
                                                                print('Post Delete successfully!');



                                                                setState(() {
                                                                  _isLoading = false;
                                                                  Navigator.of(context).pop();
                                                                  // Stop the progress bar
                                                                });
                                                              } else {
                                                                // Handle error
                                                                print('Failed to delete post: ${response.reasonPhrase}');
                                                              }

                                                              setState(() {
                                                                _isLoading = false; // Stop the progress bar
                                                              });
                                                            },
                                                            child: Text('Yes'),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );

                                                },
                                              )
                                                  : Container(), // This will hide the button if user is not admin
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            )
                                          ],
                                        ),
                                      ),


                                      SizedBox(
                                          width: double.infinity,
                                          child:  GestureDetector(
                                            onTap: () {
                                              // //
                                              // Navigator.push(
                                              //   context,
                                              //   MaterialPageRoute(
                                              //     builder: (context) {
                                              //       return AllPosts();
                                              //     },
                                              //   ),
                                              // );

                                              // Navigator.push(
                                              //   context,
                                              //   MaterialPageRoute(
                                              //     builder: (context) {
                                              //       return HomeDetailsScreen( todo: currentComment, type: currentComment.posts[index].fileType,);
                                              //     },
                                              //   ),
                                              // );
                                            },

                                            child: Column(
                                              children: [
                                                if (apiData[index]['file_type'] == 'video')
                                                  Container(
                                                      child: VideoPlayerScreen1(videoUrl: apiData[index]['post_data'],)),
                                                if (apiData[index]['file_type']  == 'image')
                                                  Container(
                                                    color: Colors.white,
                                                    // child: Image.network(apiData[index]['post_data'],
                                                    //   fit: BoxFit.fill,
                                                    //
                                                    // )


                                                    child:  CachedNetworkImage(
                                                      height: 300,
                                                      width: double.infinity,
                                                      imageUrl: apiData[index]['post_data'],
                                                      fit: BoxFit.cover, // Adjust this according to your requirement
                                                      placeholder: (context, url) => Center(
                                                        child: CircularProgressIndicator(
                                                          color: Colors.orangeAccent,
                                                        ),
                                                      ),
                                                      errorWidget: (context, url, error) => Icon(Icons.error),
                                                    ),


                                                    // Image.network(
                                                    //   apiData[index]['post_data'],
                                                    //   fit: BoxFit.cover,
                                                    //   loadingBuilder: (BuildContext context,
                                                    //       Widget child,
                                                    //       ImageChunkEvent? loadingProgress) {
                                                    //     if (loadingProgress == null) return child;
                                                    //     return Container(
                                                    //       height: 350,
                                                    //       child: Center(
                                                    //         child: CircularProgressIndicator(
                                                    //           color: ColorConstants.themeColor,
                                                    //           value: loadingProgress
                                                    //               .expectedTotalBytes !=
                                                    //               null
                                                    //               ? loadingProgress
                                                    //               .cumulativeBytesLoaded /
                                                    //               loadingProgress
                                                    //                   .expectedTotalBytes!
                                                    //               : null,
                                                    //         ),
                                                    //       ),
                                                    //     );
                                                    //   },
                                                    // ),
                                                  ),
                                              ],
                                            ),

                                            // child: Card(
                                            //   elevation: 5,
                                            //   shape: const RoundedRectangleBorder(
                                            //     borderRadius: BorderRadius
                                            //         .zero, // This makes the card edges non-rounded
                                            //   ),
                                            //   child: Column(
                                            //     children: [
                                            //       if (apiData[index]['file_type'] == 'video')
                                            //         Container(
                                            //             child: VideoPlayerScreen1(videoUrl: apiData[index]['post_data'],)),
                                            //       if (apiData[index]['file_type']  == 'image')
                                            //         Container(
                                            //           color: Colors.white,
                                            //           // child: Image.network(apiData[index]['post_data'],
                                            //           //   fit: BoxFit.fill,
                                            //           //
                                            //           // )
                                            //
                                            //
                                            //           child:  CachedNetworkImage(
                                            //             height: 300,
                                            //             width: double.infinity,
                                            //             imageUrl: apiData[index]['post_data'],
                                            //             fit: BoxFit.cover, // Adjust this according to your requirement
                                            //             placeholder: (context, url) => Center(
                                            //               child: CircularProgressIndicator(
                                            //                 color: Colors.orangeAccent,
                                            //               ),
                                            //             ),
                                            //             errorWidget: (context, url, error) => Icon(Icons.error),
                                            //           ),
                                            //
                                            //
                                            //           // Image.network(
                                            //           //   apiData[index]['post_data'],
                                            //           //   fit: BoxFit.cover,
                                            //           //   loadingBuilder: (BuildContext context,
                                            //           //       Widget child,
                                            //           //       ImageChunkEvent? loadingProgress) {
                                            //           //     if (loadingProgress == null) return child;
                                            //           //     return Container(
                                            //           //       height: 350,
                                            //           //       child: Center(
                                            //           //         child: CircularProgressIndicator(
                                            //           //           color: ColorConstants.themeColor,
                                            //           //           value: loadingProgress
                                            //           //               .expectedTotalBytes !=
                                            //           //               null
                                            //           //               ? loadingProgress
                                            //           //               .cumulativeBytesLoaded /
                                            //           //               loadingProgress
                                            //           //                   .expectedTotalBytes!
                                            //           //               : null,
                                            //           //         ),
                                            //           //       ),
                                            //           //     );
                                            //           //   },
                                            //           // ),
                                            //         ),
                                            //     ],
                                            //   ),
                                            // ),
                                          )
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(apiData[index]?['title'] ?? 'No title available',style: TextStyle(color: Colors.black),),
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
                                      Container(
                                        color: Colors.orangeAccent.shade100,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            // Like icon
                                            IconButton(
                                              icon: apiData[index]['like_flag']
                                                  ? Icon(Icons.thumb_up, color: Colors.red)
                                                  : Icon(Icons.thumb_up_alt_outlined),
                                              onPressed: () async {
                                                final SharedPreferences prefs = await SharedPreferences.getInstance();
                                                final String? token =  prefs.getString('token',);
                                                final response = await http.post(
                                                  Uri.parse(like),
                                                  headers: {
                                                    'Authorization': 'Bearer $token',
                                                    'Content-Type': 'application/json',
                                                  },
                                                  body: jsonEncode({'post_id': apiData[index]['id']}),
                                                );

                                                if (response.statusCode == 200) {
                                                  setState(() {
                                                    _isLiked = !_isLiked;
                                                  });
                                                } else {
                                                  // Handle error
                                                  print('Failed to like post: ${response.reasonPhrase}');
                                                }
                                              },
                                            ),

                                            // Like count
                                            Text(apiData[index]['likes'].toString()),

                                            Spacer(),

                                            // Comment icon
                                            IconButton(
                                              icon: Icon(Icons.date_range),
                                              onPressed: () {
                                                // Handle comment button press
                                              },
                                            ),

                                            // Comment count
                                            Padding(
                                              padding: const EdgeInsets.only(right: 8.0),
                                              child: Text(apiData[index]['date'].toString()),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(right: 1.0),
                                              child: Text('/ ${apiData[index]['time'].toString()}'),
                                            ),

                                            // Spacer to create some space between like and comment
                                            Spacer(),

                                            // Comment icon
                                            IconButton(
                                              icon: Icon(Icons.comment),
                                              onPressed: () {
                                                _showBottomSheet(context, index);

                                              },
                                            ),

                                            // Comment count
                                            Padding(
                                              padding: const EdgeInsets.only(right: 8.0),
                                              child: Text(apiData[index]['total_comments'].toString()),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                //                             child: Card(
                                //                               color: ColorSelect.redColor.shade100,
                                //                               elevation: 5,
                                //                               child: Container(
                                //                                 decoration: BoxDecoration(
                                //                                   color: ColorSelect.textcolor,
                                //                                   borderRadius: BorderRadius.circular(0.0),
                                //                                 ),
                                //                                 child: Column(
                                //                                   children: [
                                //                                     Container(
                                //                                       child: Row(
                                //                                         mainAxisAlignment: MainAxisAlignment.center,
                                //                                         children: [
                                //
                                //                                           Column(
                                //                                             children: [
                                //                                               Align(
                                //                                                 alignment: Alignment.center,
                                //                                                 child: Padding(
                                //                                                   padding: const EdgeInsets.all(8.0),
                                //                                                   child: Text('Vashikaran',
                                //                                                     style: GoogleFonts.poppins(
                                //                                                       textStyle: const TextStyle(
                                //                                                           color: ColorSelect.black,
                                //                                                           fontSize: 21,
                                //                                                           fontWeight: FontWeight.bold),
                                //                                                     ),
                                //                                                   ),
                                //                                                   // child: Text(apiData[index]['video']),
                                //                                                 ),
                                //                                               ),
                                //                                               Align(
                                //                                                   alignment: Alignment.center,
                                //                                                   child: Row(
                                //                                                     children: [
                                //                                                       Padding(
                                //                                                         padding: const EdgeInsets.only(right: 5.0),
                                //                                                         child: Text(apiData[index]['time_difference'].toString(),
                                //                                                           style: GoogleFonts.poppins(
                                //                                                             textStyle: const TextStyle(
                                //                                                                 color: ColorSelect.black,
                                //                                                                 fontSize: 17,
                                //                                                                 fontWeight: FontWeight.normal),
                                //                                                           ),),
                                //                                                       ),
                                //                                                       Text('ago',
                                //                                                         style: GoogleFonts.poppins(
                                //                                                           textStyle: const TextStyle(
                                //                                                               color: ColorSelect.black,
                                //                                                               fontSize: 17,
                                //                                                               fontWeight: FontWeight.normal),
                                //                                                         ),),
                                //                                                     ],
                                //                                                   )
                                //
                                //                                               ),
                                //                                             ],
                                //                                           ),
                                //                                           // Comment count
                                //                                           Spacer(),
                                //
                                //                                           // Spacer to create some space between like and comment
                                //                                           Spacer(),
                                //                                           Padding(
                                //                                             padding: const EdgeInsets.all(8.0),
                                //                                             child: GestureDetector(
                                //                                               onTap: () {
                                //                                                 whatsapp();
                                //                                               },
                                //                                               child: Image.asset(
                                //                                                 'assets/image1.png',
                                //                                                 width: 30,
                                //                                                 height: 30,
                                //                                               ),
                                //                                             ),
                                //                                           ),
                                //                                           Padding(
                                //                                             padding: const EdgeInsets.all(1.0),
                                //                                             child: GestureDetector(
                                //                                               onTap: () {
                                //                                                 whatsapp();
                                //                                               },
                                //                                               child: Image.asset(
                                //                                                 'assets/play.png',
                                //                                                 width: 40,
                                //                                                 height: 40,
                                //                                               ),
                                //                                             ),
                                //                                           ),
                                //                                           Padding(
                                //                                             padding: const EdgeInsets.all(8.0),
                                //                                             child: GestureDetector(
                                //                                               onTap: () {
                                //                                                 whatsapp();
                                //                                               },
                                //                                               child: Image.asset(
                                //                                                 'assets/whatsapp.png',
                                //                                                 width: 30,
                                //                                                 height: 30,
                                //                                               ),
                                //                                             ),
                                //                                           ),
                                //                                           Padding(
                                //                                             padding: const EdgeInsets.all(8.0),
                                //                                             child: GestureDetector(
                                //                                               onTap: () {
                                //                                                 _openFacebook();
                                //                                               },
                                //                                               child: Image.asset(
                                //                                                 'assets/facebook.png',
                                //                                                 width: 30,
                                //                                                 height: 30,
                                //                                               ),
                                //                                             ),
                                //                                           ),
                                //                                           SizedBox(
                                //                                             width: 5,
                                //                                           ),
                                //
                                //
                                //
                                //                                           Padding(
                                //                                             padding: const EdgeInsets.all(8.0),
                                //                                             child: adminButton != null
                                //                                                 ? IconButton(
                                //                                               icon: Icon(Icons.delete),
                                //                                               onPressed: () async {
                                //                                                 showDialog(
                                //                                                   context: context,
                                //                                                   builder: (BuildContext context) {
                                //                                                     return AlertDialog(
                                //                                                       title: Text('Delete Post?'),
                                //                                                       content: Text('Are you sure you want to delete this post?'),
                                //                                                       actions: <Widget>[
                                //                                                         TextButton(
                                //                                                           onPressed: () {
                                //                                                             // User clicked No
                                //                                                             Navigator.of(context).pop();
                                //                                                           },
                                //                                                           child: Text('No'),
                                //                                                         ),
                                //                                                         TextButton(
                                //                                                           onPressed: () async {
                                //                                                             // User clicked Yes
                                //                                                             // Perform delete operation here
                                //
                                //                                                             showDialog(
                                //                                                               context: context,
                                //                                                               barrierDismissible: false,
                                //                                                               builder: (BuildContext context) {
                                //                                                                 return const Center(
                                //                                                                   child: Row(
                                //                                                                     mainAxisSize: MainAxisSize.min,
                                //                                                                     children: [
                                //                                                                       CircularProgressIndicator(
                                //                                                                         color: Colors.orangeAccent,
                                //                                                                       ),
                                //                                                                       // SizedBox(width: 16.0),
                                //                                                                       // Text("Logging in..."),
                                //                                                                     ],
                                //                                                                   ),
                                //                                                                 );
                                //                                                               },
                                //                                                             );
                                //
                                //                                                             setState(() {
                                //                                                               _isLoading = true;
                                //                                                             });
                                //
                                //                                                             final SharedPreferences prefs = await SharedPreferences.getInstance();
                                //                                                             final String? token = prefs.getString('token');
                                //                                                             final response = await http.post(
                                //                                                               Uri.parse(PostDelete),
                                //                                                               headers: {
                                //                                                                 'Authorization': 'Bearer $token',
                                //                                                                 'Content-Type': 'application/json',
                                //                                                               },
                                //                                                               body: jsonEncode({'post_id': apiData[index]['id'],}),
                                //                                                             );
                                //                                                             Navigator.of(context).pop();
                                //
                                //                                                             if (response.statusCode == 200) {
                                //                                                               print('Post Delete successfully!');
                                //
                                //
                                //
                                //                                                               setState(() {
                                //                                                                 _isLoading = false;
                                //                                                                 Navigator.of(context).pop();
                                // // Stop the progress bar
                                //                                                               });
                                //                                                             } else {
                                //                                                               // Handle error
                                //                                                               print('Failed to delete post: ${response.reasonPhrase}');
                                //                                                             }
                                //
                                //                                                             setState(() {
                                //                                                               _isLoading = false; // Stop the progress bar
                                //                                                             });
                                //                                                           },
                                //                                                           child: Text('Yes'),
                                //                                                         ),
                                //                                                       ],
                                //                                                     );
                                //                                                   },
                                //                                                 );
                                //
                                //
                                //
                                //
                                //
                                //
                                //
                                //                                               },
                                //                                             )
                                //                                                 : Container(), // This will hide the button if user is not admin
                                //                                           ),
                                //                                           SizedBox(
                                //                                             width: 5,
                                //                                           )
                                //                                         ],
                                //                                       ),
                                //                                     ),
                                //
                                //
                                //                                     SizedBox(
                                //                                         width: double.infinity,
                                //                                         child:  GestureDetector(
                                //                                           onTap: () {
                                //                                             // //
                                //                                             // Navigator.push(
                                //                                             //   context,
                                //                                             //   MaterialPageRoute(
                                //                                             //     builder: (context) {
                                //                                             //       return AllPosts();
                                //                                             //     },
                                //                                             //   ),
                                //                                             // );
                                //
                                //                                             // Navigator.push(
                                //                                             //   context,
                                //                                             //   MaterialPageRoute(
                                //                                             //     builder: (context) {
                                //                                             //       return HomeDetailsScreen( todo: currentComment, type: currentComment.posts[index].fileType,);
                                //                                             //     },
                                //                                             //   ),
                                //                                             // );
                                //                                           },
                                //
                                //                                           child: Card(
                                //                                             elevation: 5,
                                //                                             shape: const RoundedRectangleBorder(
                                //                                               borderRadius: BorderRadius
                                //                                                   .zero, // This makes the card edges non-rounded
                                //                                             ),
                                //                                             child: Column(
                                //                                               children: [
                                //                                                 if (apiData[index]['file_type'] == 'video')
                                //                                                   Container(
                                //                                                       child: VideoPlayerScreen1(videoUrl: apiData[index]['post_data'],)),
                                //                                                 if (apiData[index]['file_type']  == 'image')
                                //                                                   Container(
                                //                                                     color: Colors.white,
                                //                                                     // child: Image.network(apiData[index]['post_data'],
                                //                                                     //   fit: BoxFit.fill,
                                //                                                     //
                                //                                                     // )
                                //
                                //
                                //                                                     child:  CachedNetworkImage(
                                //                                                       height: 300,
                                //                                                       width: double.infinity,
                                //                                                       imageUrl: apiData[index]['post_data'],
                                //                                                       fit: BoxFit.cover, // Adjust this according to your requirement
                                //                                                       placeholder: (context, url) => Center(
                                //                                                         child: CircularProgressIndicator(
                                //                                                           color: Colors.orangeAccent,
                                //                                                         ),
                                //                                                       ),
                                //                                                       errorWidget: (context, url, error) => Icon(Icons.error),
                                //                                                     ),
                                //
                                //
                                //                                                     // Image.network(
                                //                                                     //   apiData[index]['post_data'],
                                //                                                     //   fit: BoxFit.cover,
                                //                                                     //   loadingBuilder: (BuildContext context,
                                //                                                     //       Widget child,
                                //                                                     //       ImageChunkEvent? loadingProgress) {
                                //                                                     //     if (loadingProgress == null) return child;
                                //                                                     //     return Container(
                                //                                                     //       height: 350,
                                //                                                     //       child: Center(
                                //                                                     //         child: CircularProgressIndicator(
                                //                                                     //           color: ColorConstants.themeColor,
                                //                                                     //           value: loadingProgress
                                //                                                     //               .expectedTotalBytes !=
                                //                                                     //               null
                                //                                                     //               ? loadingProgress
                                //                                                     //               .cumulativeBytesLoaded /
                                //                                                     //               loadingProgress
                                //                                                     //                   .expectedTotalBytes!
                                //                                                     //               : null,
                                //                                                     //         ),
                                //                                                     //       ),
                                //                                                     //     );
                                //                                                     //   },
                                //                                                     // ),
                                //                                                   ),
                                //                                               ],
                                //                                             ),
                                //                                           ),
                                //                                         )
                                //                                     ),
                                //                                     SizedBox(
                                //                                       height: 5,
                                //                                     ),
                                //                                     Align(
                                //                                       alignment: Alignment.centerLeft,
                                //                                       child: Padding(
                                //                                         padding: const EdgeInsets.all(8.0),
                                //                                         child: Text(apiData[index]?['title'] ?? 'No title available'),
                                //                                         // child: Text(apiData[index]['video']),
                                //                                       ),
                                //                                     ),
                                //                                     SizedBox(
                                //                                       height: 5,
                                //                                     ),
                                //                                     Divider(
                                //                                       height: 1,
                                //                                       color: ColorSelect.subtextcolor.shade300,
                                //                                     ),
                                //                                     SizedBox(
                                //                                       height: 5,
                                //                                     ),
                                //                                     Container(
                                //                                       color: Colors.orangeAccent.shade100,
                                //                                       child: Row(
                                //                                         mainAxisAlignment: MainAxisAlignment.center,
                                //                                         children: [
                                //                                           // Like icon
                                //                                           IconButton(
                                //                                             icon: apiData[index]['like_flag']
                                //                                                 ? Icon(Icons.thumb_up, color: Colors.red)
                                //                                                 : Icon(Icons.thumb_up_alt_outlined),
                                //                                             onPressed: () async {
                                //                                               final SharedPreferences prefs = await SharedPreferences.getInstance();
                                //                                               final String? token =  prefs.getString('token',);
                                //                                               final response = await http.post(
                                //                                                 Uri.parse(like),
                                //                                                 headers: {
                                //                                                   'Authorization': 'Bearer $token',
                                //                                                   'Content-Type': 'application/json',
                                //                                                 },
                                //                                                 body: jsonEncode({'post_id': apiData[index]['id']}),
                                //                                               );
                                //
                                //                                               if (response.statusCode == 200) {
                                //                                                 setState(() {
                                //                                                   _isLiked = !_isLiked;
                                //                                                 });
                                //                                               } else {
                                //                                                 // Handle error
                                //                                                 print('Failed to like post: ${response.reasonPhrase}');
                                //                                               }
                                //                                             },
                                //                                           ),
                                //
                                //                                           // Like count
                                //                                           Text(apiData[index]['likes'].toString()),
                                //
                                //                                           Spacer(),
                                //
                                //                                           // Comment icon
                                //                                           IconButton(
                                //                                             icon: Icon(Icons.date_range),
                                //                                             onPressed: () {
                                //                                               // Handle comment button press
                                //                                             },
                                //                                           ),
                                //
                                //                                           // Comment count
                                //                                           Padding(
                                //                                             padding: const EdgeInsets.only(right: 8.0),
                                //                                             child: Text(apiData[index]['date'].toString()),
                                //                                           ),
                                //                                           Padding(
                                //                                             padding: const EdgeInsets.only(right: 1.0),
                                //                                             child: Text('/ ${apiData[index]['time'].toString()}'),
                                //                                           ),
                                //
                                //                                           // Spacer to create some space between like and comment
                                //                                           Spacer(),
                                //
                                //                                           // Comment icon
                                //                                           IconButton(
                                //                                             icon: Icon(Icons.comment),
                                //                                             onPressed: () {
                                //                                               _showBottomSheet(context, index);
                                //
                                //                                             },
                                //                                           ),
                                //
                                //                                           // Comment count
                                //                                           Padding(
                                //                                             padding: const EdgeInsets.only(right: 8.0),
                                //                                             child: Text(apiData[index]['total_comments'].toString()),
                                //                                           ),
                                //                                         ],
                                //                                       ),
                                //                                     ),
                                //                                   ],
                                //                                 ),
                                //                               ),
                                //                             ),
                              )
                          );
                        } else if(selectedCategory== 'All') {
                          return GestureDetector(
                              onTap: () {
                              },

                              child: Padding(
                                padding: const EdgeInsets.only(top: 1.0),

                                child: Container(
                                  decoration: BoxDecoration(
                                    color: ColorSelect.textcolor,
                                    borderRadius: BorderRadius.circular(0.0),
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [

                                            Row(
                                              children: [


                                                Padding(
                                                  padding:  EdgeInsets.only(left: 5.sp),
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(30),
                                                    child: Image.network(
                                                      '',
                                                      fit: BoxFit.cover,
                                                      width: 50,
                                                      height: 50,
                                                      errorBuilder: (context, object, stackTrace) {
                                                        return ClipRRect(
                                                          borderRadius: BorderRadius.circular(30), // Half of width/height for perfect circle
                                                          child: Image.network(
                                                            'https://w7.pngwing.com/pngs/178/595/png-transparent-user-profile-computer-icons-login-user-avatars-thumbnail.png',
                                                            fit: BoxFit.cover,
                                                            width: 50,
                                                            height: 50,
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),

                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:  EdgeInsets.only(left: 5.sp),
                                                      child: Text('Name',
                                                        style: GoogleFonts.poppins(
                                                          textStyle:  TextStyle(
                                                              color: ColorSelect.black,
                                                              fontSize: 15.sp,
                                                              fontWeight: FontWeight.bold),
                                                        ),
                                                      ),
                                                      // child: Text(apiData[index]['video']),
                                                    ),
                                                    Padding(
                                                      padding:  EdgeInsets.only(left: 8.sp),
                                                      child: Text('${apiData[index]['time_difference'].toString()} ${'ago'}',
                                                        style: GoogleFonts.poppins(
                                                          textStyle:  TextStyle(
                                                              color: ColorSelect.black,
                                                              fontSize: 11.sp,
                                                              fontWeight: FontWeight.normal),
                                                        ),),
                                                    ),


                                                  ],
                                                )

                                              ],
                                            ),
                                            // Comment count
                                            Spacer(),

                                            // Spacer to create some space between like and comment
                                            Spacer(),

                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: GestureDetector(
                                                onTap: () {
                                                  whatsapp();
                                                },
                                                child: Image.asset(
                                                  'assets/whatsapp.png',
                                                  width: 30,
                                                  height: 30,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: GestureDetector(
                                                onTap: () {
                                                  _openFacebook();
                                                },
                                                child: Image.asset(
                                                  'assets/facebook.png',
                                                  width: 30,
                                                  height: 30,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),



                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: adminButton != null
                                                  ? IconButton(
                                                icon: Icon(Icons.delete),
                                                onPressed: () async {
                                                  showDialog(
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Text('Delete Post?'),
                                                        content: Text('Are you sure you want to delete this post?'),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            onPressed: () {
                                                              // User clicked No
                                                              Navigator.of(context).pop();
                                                            },
                                                            child: Text('No'),
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
                                                                Uri.parse(PostDelete),
                                                                headers: {
                                                                  'Authorization': 'Bearer $token',
                                                                  'Content-Type': 'application/json',
                                                                },
                                                                body: jsonEncode({'post_id': apiData[index]['id'],}),
                                                              );
                                                              Navigator.of(context).pop();

                                                              if (response.statusCode == 200) {
                                                                print('Post Delete successfully!');



                                                                setState(() {
                                                                  _isLoading = false;
                                                                  Navigator.of(context).pop();
                                                                  // Stop the progress bar
                                                                });
                                                              } else {
                                                                // Handle error
                                                                print('Failed to delete post: ${response.reasonPhrase}');
                                                              }

                                                              setState(() {
                                                                _isLoading = false; // Stop the progress bar
                                                              });
                                                            },
                                                            child: Text('Yes'),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );







                                                },
                                              )
                                                  : Container(), // This will hide the button if user is not admin
                                            ),
                                            SizedBox(
                                              width: 5,
                                            )
                                          ],
                                        ),
                                      ),


                                      SizedBox(
                                          width: double.infinity,
                                          child:  GestureDetector(
                                            onTap: () {
                                              // //
                                              // Navigator.push(
                                              //   context,
                                              //   MaterialPageRoute(
                                              //     builder: (context) {
                                              //       return AllPosts();
                                              //     },
                                              //   ),
                                              // );

                                              // Navigator.push(
                                              //   context,
                                              //   MaterialPageRoute(
                                              //     builder: (context) {
                                              //       return HomeDetailsScreen( todo: currentComment, type: currentComment.posts[index].fileType,);
                                              //     },
                                              //   ),
                                              // );
                                            },

                                            child: Column(
                                              children: [
                                                if (apiData[index]['file_type'] == 'video')
                                                  Container(
                                                      child: VideoPlayerScreen1(videoUrl: apiData[index]['post_data'],)),
                                                if (apiData[index]['file_type']  == 'image')
                                                  Container(
                                                    color: Colors.white,
                                                    // child: Image.network(apiData[index]['post_data'],
                                                    //   fit: BoxFit.fill,
                                                    //
                                                    // )


                                                    child:  CachedNetworkImage(
                                                      height: 300,
                                                      width: double.infinity,
                                                      imageUrl: apiData[index]['post_data'],
                                                      fit: BoxFit.cover, // Adjust this according to your requirement
                                                      placeholder: (context, url) => Center(
                                                        child: CircularProgressIndicator(
                                                          color: Colors.orangeAccent,
                                                        ),
                                                      ),
                                                      errorWidget: (context, url, error) => Icon(Icons.error),
                                                    ),


                                                    // Image.network(
                                                    //   apiData[index]['post_data'],
                                                    //   fit: BoxFit.cover,
                                                    //   loadingBuilder: (BuildContext context,
                                                    //       Widget child,
                                                    //       ImageChunkEvent? loadingProgress) {
                                                    //     if (loadingProgress == null) return child;
                                                    //     return Container(
                                                    //       height: 350,
                                                    //       child: Center(
                                                    //         child: CircularProgressIndicator(
                                                    //           color: ColorConstants.themeColor,
                                                    //           value: loadingProgress
                                                    //               .expectedTotalBytes !=
                                                    //               null
                                                    //               ? loadingProgress
                                                    //               .cumulativeBytesLoaded /
                                                    //               loadingProgress
                                                    //                   .expectedTotalBytes!
                                                    //               : null,
                                                    //         ),
                                                    //       ),
                                                    //     );
                                                    //   },
                                                    // ),
                                                  ),
                                              ],
                                            ),

                                            // child: Card(
                                            //   elevation: 5,
                                            //   shape: const RoundedRectangleBorder(
                                            //     borderRadius: BorderRadius
                                            //         .zero, // This makes the card edges non-rounded
                                            //   ),
                                            //   child: Column(
                                            //     children: [
                                            //       if (apiData[index]['file_type'] == 'video')
                                            //         Container(
                                            //             child: VideoPlayerScreen1(videoUrl: apiData[index]['post_data'],)),
                                            //       if (apiData[index]['file_type']  == 'image')
                                            //         Container(
                                            //           color: Colors.white,
                                            //           // child: Image.network(apiData[index]['post_data'],
                                            //           //   fit: BoxFit.fill,
                                            //           //
                                            //           // )
                                            //
                                            //
                                            //           child:  CachedNetworkImage(
                                            //             height: 300,
                                            //             width: double.infinity,
                                            //             imageUrl: apiData[index]['post_data'],
                                            //             fit: BoxFit.cover, // Adjust this according to your requirement
                                            //             placeholder: (context, url) => Center(
                                            //               child: CircularProgressIndicator(
                                            //                 color: Colors.orangeAccent,
                                            //               ),
                                            //             ),
                                            //             errorWidget: (context, url, error) => Icon(Icons.error),
                                            //           ),
                                            //
                                            //
                                            //           // Image.network(
                                            //           //   apiData[index]['post_data'],
                                            //           //   fit: BoxFit.cover,
                                            //           //   loadingBuilder: (BuildContext context,
                                            //           //       Widget child,
                                            //           //       ImageChunkEvent? loadingProgress) {
                                            //           //     if (loadingProgress == null) return child;
                                            //           //     return Container(
                                            //           //       height: 350,
                                            //           //       child: Center(
                                            //           //         child: CircularProgressIndicator(
                                            //           //           color: ColorConstants.themeColor,
                                            //           //           value: loadingProgress
                                            //           //               .expectedTotalBytes !=
                                            //           //               null
                                            //           //               ? loadingProgress
                                            //           //               .cumulativeBytesLoaded /
                                            //           //               loadingProgress
                                            //           //                   .expectedTotalBytes!
                                            //           //               : null,
                                            //           //         ),
                                            //           //       ),
                                            //           //     );
                                            //           //   },
                                            //           // ),
                                            //         ),
                                            //     ],
                                            //   ),
                                            // ),
                                          )
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(apiData[index]?['title'] ?? 'No title available',style: TextStyle(color: Colors.black),),
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
                                      Container(
                                        color: Colors.orangeAccent.shade100,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            // Like icon
                                            IconButton(
                                              icon: apiData[index]['like_flag']
                                                  ? Icon(Icons.thumb_up, color: Colors.red)
                                                  : Icon(Icons.thumb_up_alt_outlined),
                                              onPressed: () async {
                                                final SharedPreferences prefs = await SharedPreferences.getInstance();
                                                final String? token =  prefs.getString('token',);
                                                final response = await http.post(
                                                  Uri.parse(like),
                                                  headers: {
                                                    'Authorization': 'Bearer $token',
                                                    'Content-Type': 'application/json',
                                                  },
                                                  body: jsonEncode({'post_id': apiData[index]['id']}),
                                                );

                                                if (response.statusCode == 200) {
                                                  setState(() {
                                                    _isLiked = !_isLiked;
                                                  });
                                                } else {
                                                  // Handle error
                                                  print('Failed to like post: ${response.reasonPhrase}');
                                                }
                                              },
                                            ),

                                            // Like count
                                            Text(apiData[index]['likes'].toString()),

                                            Spacer(),

                                            // Comment icon

                                            // Comment count
                                            Padding(
                                              padding: const EdgeInsets.only(right: 8.0),
                                              child: Text(apiData[index]['date'].toString()),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(right: 1.0),
                                              child: Text('/ ${apiData[index]['time'].toString()}'),
                                            ),

                                            Spacer(),

                                            // Comment icon
                                            IconButton(
                                              icon: Icon(Icons.comment),
                                              onPressed: () {
                                                _showBottomSheet(context, index);

                                              },
                                            ),

                                            // Comment count
                                            Padding(
                                              padding: const EdgeInsets.only(right: 8.0),
                                              child: Text(apiData[index]['total_comments'].toString()),
                                            ),



                                            //
                                            // Spacer(),
                                            //
                                            // // Comment icon
                                            // SizedBox(
                                            //     height: 18,
                                            //     width: 20,
                                            //     child: Image.asset('assets/comment_icon.png')),
                                            //
                                            // // Comment count
                                            // SizedBox(
                                            //
                                            //
                                            //   child: Padding(
                                            //     padding: const EdgeInsets.only(left: 8,right: 8.0),
                                            //     child: Center(child: Text('Comment',style: TextStyle(fontSize: 13),)),
                                            //   ),
                                            // ),
                                            //
                                            // Spacer(),
                                            //
                                            // // Comment icon
                                            // SizedBox(
                                            //     height: 18,
                                            //     width: 20,
                                            //     child: Image.asset('assets/whatsapp_icon.png')),
                                            //
                                            // // Comment count
                                            // SizedBox(
                                            //   height: 18,
                                            //
                                            //   child: Padding(
                                            //     padding: const EdgeInsets.only(left: 8,right: 8.0),
                                            //     child: Text('Send',style: TextStyle(fontSize: 13),),
                                            //   ),
                                            // ),
                                            //
                                            // Spacer(),
                                            //
                                            // // Comment icon
                                            // SizedBox(
                                            //     height: 18,
                                            //     width: 20,
                                            //     child: Image.asset('assets/share.png')),
                                            //
                                            // // Comment count
                                            // SizedBox(
                                            //   height: 18,
                                            //
                                            //   child: Padding(
                                            //     padding: const EdgeInsets.only(left: 8,right: 8.0),
                                            //     child: Text('Share',style: TextStyle(fontSize: 13),),
                                            //   ),
                                            // ),

                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                //                             child: Card(
                                //                               color: ColorSelect.redColor.shade100,
                                //                               elevation: 5,
                                //                               child: Container(
                                //                                 decoration: BoxDecoration(
                                //                                   color: ColorSelect.textcolor,
                                //                                   borderRadius: BorderRadius.circular(0.0),
                                //                                 ),
                                //                                 child: Column(
                                //                                   children: [
                                //                                     Container(
                                //                                       child: Row(
                                //                                         mainAxisAlignment: MainAxisAlignment.center,
                                //                                         children: [
                                //
                                //                                           Column(
                                //                                             children: [
                                //                                               Align(
                                //                                                 alignment: Alignment.center,
                                //                                                 child: Padding(
                                //                                                   padding: const EdgeInsets.all(8.0),
                                //                                                   child: Text('Vashikaran',
                                //                                                     style: GoogleFonts.poppins(
                                //                                                       textStyle: const TextStyle(
                                //                                                           color: ColorSelect.black,
                                //                                                           fontSize: 21,
                                //                                                           fontWeight: FontWeight.bold),
                                //                                                     ),
                                //                                                   ),
                                //                                                   // child: Text(apiData[index]['video']),
                                //                                                 ),
                                //                                               ),
                                //                                               Align(
                                //                                                   alignment: Alignment.center,
                                //                                                   child: Row(
                                //                                                     children: [
                                //                                                       Padding(
                                //                                                         padding: const EdgeInsets.only(right: 5.0),
                                //                                                         child: Text(apiData[index]['time_difference'].toString(),
                                //                                                           style: GoogleFonts.poppins(
                                //                                                             textStyle: const TextStyle(
                                //                                                                 color: ColorSelect.black,
                                //                                                                 fontSize: 17,
                                //                                                                 fontWeight: FontWeight.normal),
                                //                                                           ),),
                                //                                                       ),
                                //                                                       Text('ago',
                                //                                                         style: GoogleFonts.poppins(
                                //                                                           textStyle: const TextStyle(
                                //                                                               color: ColorSelect.black,
                                //                                                               fontSize: 17,
                                //                                                               fontWeight: FontWeight.normal),
                                //                                                         ),),
                                //                                                     ],
                                //                                                   )
                                //
                                //                                               ),
                                //                                             ],
                                //                                           ),
                                //                                           // Comment count
                                //                                           Spacer(),
                                //
                                //                                           // Spacer to create some space between like and comment
                                //                                           Spacer(),
                                //                                           Padding(
                                //                                             padding: const EdgeInsets.all(8.0),
                                //                                             child: GestureDetector(
                                //                                               onTap: () {
                                //                                                 whatsapp();
                                //                                               },
                                //                                               child: Image.asset(
                                //                                                 'assets/image1.png',
                                //                                                 width: 30,
                                //                                                 height: 30,
                                //                                               ),
                                //                                             ),
                                //                                           ),
                                //                                           Padding(
                                //                                             padding: const EdgeInsets.all(1.0),
                                //                                             child: GestureDetector(
                                //                                               onTap: () {
                                //                                                 whatsapp();
                                //                                               },
                                //                                               child: Image.asset(
                                //                                                 'assets/play.png',
                                //                                                 width: 40,
                                //                                                 height: 40,
                                //                                               ),
                                //                                             ),
                                //                                           ),
                                //                                           Padding(
                                //                                             padding: const EdgeInsets.all(8.0),
                                //                                             child: GestureDetector(
                                //                                               onTap: () {
                                //                                                 whatsapp();
                                //                                               },
                                //                                               child: Image.asset(
                                //                                                 'assets/whatsapp.png',
                                //                                                 width: 30,
                                //                                                 height: 30,
                                //                                               ),
                                //                                             ),
                                //                                           ),
                                //                                           Padding(
                                //                                             padding: const EdgeInsets.all(8.0),
                                //                                             child: GestureDetector(
                                //                                               onTap: () {
                                //                                                 _openFacebook();
                                //                                               },
                                //                                               child: Image.asset(
                                //                                                 'assets/facebook.png',
                                //                                                 width: 30,
                                //                                                 height: 30,
                                //                                               ),
                                //                                             ),
                                //                                           ),
                                //                                           SizedBox(
                                //                                             width: 5,
                                //                                           ),
                                //
                                //
                                //
                                //                                           Padding(
                                //                                             padding: const EdgeInsets.all(8.0),
                                //                                             child: adminButton != null
                                //                                                 ? IconButton(
                                //                                               icon: Icon(Icons.delete),
                                //                                               onPressed: () async {
                                //                                                 showDialog(
                                //                                                   context: context,
                                //                                                   builder: (BuildContext context) {
                                //                                                     return AlertDialog(
                                //                                                       title: Text('Delete Post?'),
                                //                                                       content: Text('Are you sure you want to delete this post?'),
                                //                                                       actions: <Widget>[
                                //                                                         TextButton(
                                //                                                           onPressed: () {
                                //                                                             // User clicked No
                                //                                                             Navigator.of(context).pop();
                                //                                                           },
                                //                                                           child: Text('No'),
                                //                                                         ),
                                //                                                         TextButton(
                                //                                                           onPressed: () async {
                                //                                                             // User clicked Yes
                                //                                                             // Perform delete operation here
                                //
                                //                                                             showDialog(
                                //                                                               context: context,
                                //                                                               barrierDismissible: false,
                                //                                                               builder: (BuildContext context) {
                                //                                                                 return const Center(
                                //                                                                   child: Row(
                                //                                                                     mainAxisSize: MainAxisSize.min,
                                //                                                                     children: [
                                //                                                                       CircularProgressIndicator(
                                //                                                                         color: Colors.orangeAccent,
                                //                                                                       ),
                                //                                                                       // SizedBox(width: 16.0),
                                //                                                                       // Text("Logging in..."),
                                //                                                                     ],
                                //                                                                   ),
                                //                                                                 );
                                //                                                               },
                                //                                                             );
                                //
                                //                                                             setState(() {
                                //                                                               _isLoading = true;
                                //                                                             });
                                //
                                //                                                             final SharedPreferences prefs = await SharedPreferences.getInstance();
                                //                                                             final String? token = prefs.getString('token');
                                //                                                             final response = await http.post(
                                //                                                               Uri.parse(PostDelete),
                                //                                                               headers: {
                                //                                                                 'Authorization': 'Bearer $token',
                                //                                                                 'Content-Type': 'application/json',
                                //                                                               },
                                //                                                               body: jsonEncode({'post_id': apiData[index]['id'],}),
                                //                                                             );
                                //                                                             Navigator.of(context).pop();
                                //
                                //                                                             if (response.statusCode == 200) {
                                //                                                               print('Post Delete successfully!');
                                //
                                //
                                //
                                //                                                               setState(() {
                                //                                                                 _isLoading = false;
                                //                                                                 Navigator.of(context).pop();
                                // // Stop the progress bar
                                //                                                               });
                                //                                                             } else {
                                //                                                               // Handle error
                                //                                                               print('Failed to delete post: ${response.reasonPhrase}');
                                //                                                             }
                                //
                                //                                                             setState(() {
                                //                                                               _isLoading = false; // Stop the progress bar
                                //                                                             });
                                //                                                           },
                                //                                                           child: Text('Yes'),
                                //                                                         ),
                                //                                                       ],
                                //                                                     );
                                //                                                   },
                                //                                                 );
                                //
                                //
                                //
                                //
                                //
                                //
                                //
                                //                                               },
                                //                                             )
                                //                                                 : Container(), // This will hide the button if user is not admin
                                //                                           ),
                                //                                           SizedBox(
                                //                                             width: 5,
                                //                                           )
                                //                                         ],
                                //                                       ),
                                //                                     ),
                                //
                                //
                                //                                     SizedBox(
                                //                                         width: double.infinity,
                                //                                         child:  GestureDetector(
                                //                                           onTap: () {
                                //                                             // //
                                //                                             // Navigator.push(
                                //                                             //   context,
                                //                                             //   MaterialPageRoute(
                                //                                             //     builder: (context) {
                                //                                             //       return AllPosts();
                                //                                             //     },
                                //                                             //   ),
                                //                                             // );
                                //
                                //                                             // Navigator.push(
                                //                                             //   context,
                                //                                             //   MaterialPageRoute(
                                //                                             //     builder: (context) {
                                //                                             //       return HomeDetailsScreen( todo: currentComment, type: currentComment.posts[index].fileType,);
                                //                                             //     },
                                //                                             //   ),
                                //                                             // );
                                //                                           },
                                //
                                //                                           child: Card(
                                //                                             elevation: 5,
                                //                                             shape: const RoundedRectangleBorder(
                                //                                               borderRadius: BorderRadius
                                //                                                   .zero, // This makes the card edges non-rounded
                                //                                             ),
                                //                                             child: Column(
                                //                                               children: [
                                //                                                 if (apiData[index]['file_type'] == 'video')
                                //                                                   Container(
                                //                                                       child: VideoPlayerScreen1(videoUrl: apiData[index]['post_data'],)),
                                //                                                 if (apiData[index]['file_type']  == 'image')
                                //                                                   Container(
                                //                                                     color: Colors.white,
                                //                                                     // child: Image.network(apiData[index]['post_data'],
                                //                                                     //   fit: BoxFit.fill,
                                //                                                     //
                                //                                                     // )
                                //
                                //
                                //                                                     child:  CachedNetworkImage(
                                //                                                       height: 300,
                                //                                                       width: double.infinity,
                                //                                                       imageUrl: apiData[index]['post_data'],
                                //                                                       fit: BoxFit.cover, // Adjust this according to your requirement
                                //                                                       placeholder: (context, url) => Center(
                                //                                                         child: CircularProgressIndicator(
                                //                                                           color: Colors.orangeAccent,
                                //                                                         ),
                                //                                                       ),
                                //                                                       errorWidget: (context, url, error) => Icon(Icons.error),
                                //                                                     ),
                                //
                                //
                                //                                                     // Image.network(
                                //                                                     //   apiData[index]['post_data'],
                                //                                                     //   fit: BoxFit.cover,
                                //                                                     //   loadingBuilder: (BuildContext context,
                                //                                                     //       Widget child,
                                //                                                     //       ImageChunkEvent? loadingProgress) {
                                //                                                     //     if (loadingProgress == null) return child;
                                //                                                     //     return Container(
                                //                                                     //       height: 350,
                                //                                                     //       child: Center(
                                //                                                     //         child: CircularProgressIndicator(
                                //                                                     //           color: ColorConstants.themeColor,
                                //                                                     //           value: loadingProgress
                                //                                                     //               .expectedTotalBytes !=
                                //                                                     //               null
                                //                                                     //               ? loadingProgress
                                //                                                     //               .cumulativeBytesLoaded /
                                //                                                     //               loadingProgress
                                //                                                     //                   .expectedTotalBytes!
                                //                                                     //               : null,
                                //                                                     //         ),
                                //                                                     //       ),
                                //                                                     //     );
                                //                                                     //   },
                                //                                                     // ),
                                //                                                   ),
                                //                                               ],
                                //                                             ),
                                //                                           ),
                                //                                         )
                                //                                     ),
                                //                                     SizedBox(
                                //                                       height: 5,
                                //                                     ),
                                //                                     Align(
                                //                                       alignment: Alignment.centerLeft,
                                //                                       child: Padding(
                                //                                         padding: const EdgeInsets.all(8.0),
                                //                                         child: Text(apiData[index]?['title'] ?? 'No title available'),
                                //                                         // child: Text(apiData[index]['video']),
                                //                                       ),
                                //                                     ),
                                //                                     SizedBox(
                                //                                       height: 5,
                                //                                     ),
                                //                                     Divider(
                                //                                       height: 1,
                                //                                       color: ColorSelect.subtextcolor.shade300,
                                //                                     ),
                                //                                     SizedBox(
                                //                                       height: 5,
                                //                                     ),
                                //                                     Container(
                                //                                       color: Colors.orangeAccent.shade100,
                                //                                       child: Row(
                                //                                         mainAxisAlignment: MainAxisAlignment.center,
                                //                                         children: [
                                //                                           // Like icon
                                //                                           IconButton(
                                //                                             icon: apiData[index]['like_flag']
                                //                                                 ? Icon(Icons.thumb_up, color: Colors.red)
                                //                                                 : Icon(Icons.thumb_up_alt_outlined),
                                //                                             onPressed: () async {
                                //                                               final SharedPreferences prefs = await SharedPreferences.getInstance();
                                //                                               final String? token =  prefs.getString('token',);
                                //                                               final response = await http.post(
                                //                                                 Uri.parse(like),
                                //                                                 headers: {
                                //                                                   'Authorization': 'Bearer $token',
                                //                                                   'Content-Type': 'application/json',
                                //                                                 },
                                //                                                 body: jsonEncode({'post_id': apiData[index]['id']}),
                                //                                               );
                                //
                                //                                               if (response.statusCode == 200) {
                                //                                                 setState(() {
                                //                                                   _isLiked = !_isLiked;
                                //                                                 });
                                //                                               } else {
                                //                                                 // Handle error
                                //                                                 print('Failed to like post: ${response.reasonPhrase}');
                                //                                               }
                                //                                             },
                                //                                           ),
                                //
                                //                                           // Like count
                                //                                           Text(apiData[index]['likes'].toString()),
                                //
                                //                                           Spacer(),
                                //
                                //                                           // Comment icon
                                //                                           IconButton(
                                //                                             icon: Icon(Icons.date_range),
                                //                                             onPressed: () {
                                //                                               // Handle comment button press
                                //                                             },
                                //                                           ),
                                //
                                //                                           // Comment count
                                //                                           Padding(
                                //                                             padding: const EdgeInsets.only(right: 8.0),
                                //                                             child: Text(apiData[index]['date'].toString()),
                                //                                           ),
                                //                                           Padding(
                                //                                             padding: const EdgeInsets.only(right: 1.0),
                                //                                             child: Text('/ ${apiData[index]['time'].toString()}'),
                                //                                           ),
                                //
                                //                                           // Spacer to create some space between like and comment
                                //                                           Spacer(),
                                //
                                //                                           // Comment icon
                                //                                           IconButton(
                                //                                             icon: Icon(Icons.comment),
                                //                                             onPressed: () {
                                //                                               _showBottomSheet(context, index);
                                //
                                //                                             },
                                //                                           ),
                                //
                                //                                           // Comment count
                                //                                           Padding(
                                //                                             padding: const EdgeInsets.only(right: 8.0),
                                //                                             child: Text(apiData[index]['total_comments'].toString()),
                                //                                           ),
                                //                                         ],
                                //                                       ),
                                //                                     ),
                                //                                   ],
                                //                                 ),
                                //                               ),
                                //                             ),
                              )
                          );// Hides the item if not in selected category
                        }
                        else {
                          return SizedBox.shrink(); // Hides the item if not in selected category
                        }


                      },
                    ),
                  ),

                ),
              ),
            ),
          ),


        ],
      ),
    ));
  }
}


// class VideoPlayerScreen extends StatefulWidget {
//   final String videoUrl;
//
//   const VideoPlayerScreen({Key? key, required this.videoUrl}) : super(key: key);
//
//   @override
//   _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
// }
//
// class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
//   late VideoPlayerController _controller;
//   late Future<void> _initializeVideoPlayerFuture;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.network(
//       widget.videoUrl,
//     );
//
//     _initializeVideoPlayerFuture = _controller.initialize().then((_) {
//       // Ensure the first frame is shown after the video is initialized
//       setState(() {});
//     });
//
//     _controller.setLooping(true); // Set looping to true
//     _controller.play(); // Start playing the video
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose(); // Ensure disposing of the VideoPlayerController to free up resources
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: _initializeVideoPlayerFuture,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.done) {
//           return Container(
//             child: AspectRatio(
//               aspectRatio: _controller.value.aspectRatio,
//               child: VideoPlayer(_controller),
//             ),
//           );
//         } else {
//           return Center(
//             child: CircularProgressIndicator(), // Display a loading spinner until the video is initialized
//           );
//         }
//       },
//     );
//   }
// }
//
//
//
//
//
//
//
//
// class VideoScreen extends StatefulWidget {
//   final String videoUrl;
//
//   VideoScreen({required this.videoUrl, });
//
//   @override
//   _VideoScreenState createState() => _VideoScreenState();
// }
//
// class _VideoScreenState extends State<VideoScreen> {
//   late VideoPlayerController _videoPlayerController;
//   late ChewieController _chewieController;
//   bool _showThumbnail = true;
//
//   @override
//   void initState() {
//     super.initState();
//     // Replace the video URL with your own video URL
//     _videoPlayerController = VideoPlayerController.network(
//       widget.videoUrl,
//     );
//
//     _chewieController = ChewieController(
//       videoPlayerController: _videoPlayerController,
//       autoPlay: false,
//       looping: false,
//       allowFullScreen: false,
//       allowedScreenSleep: false,
//       aspectRatio: 10 / 15,
//       autoInitialize: false,
//       errorBuilder: (context, errorMessage) {
//         return Center(
//           child: Text(
//             errorMessage,
//             style: TextStyle(color: Colors.white),
//           ),
//         );
//       },
//     );
//
//     // Listen to video player controller for when video starts playing
//     _videoPlayerController.addListener(() {
//       if (_videoPlayerController.value.isPlaying) {
//         setState(() {
//           _showThumbnail = false;
//         });
//       }
//     });
//
//     // Initialize the video player
//     _videoPlayerController.initialize().then((_) {
//       setState(() {});
//     });
//   }
//
//   @override
//   void dispose() {
//     _videoPlayerController.dispose();
//     _chewieController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Stack(
//         alignment: Alignment.center,
//         children: [
//
//           Container(
//             height: 605,
//             child: Chewie(
//               controller: _chewieController,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }








class VideoPlayerScreen1 extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerScreen1({Key? key, required this.videoUrl}) : super(key: key);


  @override
  _VideoPlayerScreenState1 createState() => _VideoPlayerScreenState1();
}

class _VideoPlayerScreenState1 extends State<VideoPlayerScreen1> {
  late VideoPlayerController? _controller;
  late Future<Uint8List> _thumbnailFuture;
  late ChewieController _chewieController;


  @override
  void initState() {
    super.initState();


    //
    // _controller = VideoPlayerController.network(
    //   widget.videoUrl,);
    //
    // // Initialize the chewie controller
    // _chewieController = ChewieController(
    //   videoPlayerController: _controller,
    //   autoPlay: false, // Set autoPlay to true to automatically play the video
    //   looping: false, // Set looping to true if you want the video to loop
    //   aspectRatio: _controller.value.aspectRatio, // Adjust aspect ratio as per your video dimensions
    //   autoInitialize: false,
    // );


    // _thumbnailFuture = _getThumbnail();
    _controller = VideoPlayerController.network(
      widget.videoUrl,
    )..initialize().then((_) {
      setState(() {
        // _controller.play();
      });
    });
  }



  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }

  // Future<Uint8List> _getThumbnail() async {
  //   final thumbnail = await VideoThumbnail.thumbnailData(
  //     video: widget.videoUrl,
  //     imageFormat: ImageFormat.JPEG,
  //     maxWidth: 128,
  //     quality: 25,
  //   );
  //   return thumbnail!;
  // }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Stack(
      alignment: Alignment.center,
      children: [
        AspectRatio(

          aspectRatio: _controller!.value.aspectRatio,
          child: VideoPlayer(_controller!),
        ),

        // FutureBuilder<Uint8List>(
        //   future: _thumbnailFuture,
        //   builder: (BuildContext context,
        //       AsyncSnapshot<Uint8List> snapshot) {
        //     if (snapshot.connectionState ==
        //         ConnectionState.waiting) {
        //       return CircularProgressIndicator();
        //     } else if (snapshot.hasError) {
        //       return Text('Error: ${snapshot.error}');
        //     } else {
        //       return Image.memory(snapshot.data!);
        //     }
        //   },
        // ),
        Positioned(
          child: IconButton(
            icon: Icon(
              _controller!.value.isPlaying
                  ? Icons.pause
                  : Icons.play_arrow,size: 50,
            ),
            onPressed: () {
              setState(() {
                if (_controller!.value.isPlaying) {
                  _controller!.pause();
                } else {
                  _controller!.play();
                }
              });
            },
          ),
        ),
      ],
    );
  }
}



