import 'package:aph/UploadImage/load_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import '../Home/home.dart';
import '../Utils/color.dart';


class AllPosts extends StatefulWidget {
  const AllPosts({super.key});

  @override
  State<AllPosts> createState() => _AllPostsState();
}

class _AllPostsState extends State<AllPosts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("geeksforgeeks"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('all_posts').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((document) {
              return GestureDetector(
                  onTap: () {
                    // //
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) {
                    //       return AddData();
                    //     },
                    //   ),
                    // );

                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) {
                    //       return HomeDetailsScreen( todo: currentComment, type: currentComment.type,);
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
                                        if ( document['type'] == 'video')
                                          VideoPlayerScreen(videoUrl: document['url']),
                                        if ( document['type'] == 'image')
                                          Container(
                                              height: 300,
                                              width: double.infinity,
                                              child: Image.network(document['url'],fit: BoxFit.fill,)),
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
                                child: Text(document['title']),
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
                                  icon: document['like']
                                      ? Icon(Icons.thumb_up, color: Colors.red)
                                      : Icon(Icons.thumb_up_alt_outlined),
                                  onPressed: () {
                                    setState(() {
                                      // Toggle the like state
                                      document['true'].isLiked =
                                      !document['false'].isLiked;

                                      // Perform additional logic if needed, such as updating like count on a server.
                                    });
                                  },
                                ),

                                // Like count
                                Text('22'),

                                Spacer(),

                                // Comment icon
                                IconButton(
                                  icon: Icon(Icons.date_range),
                                  onPressed: () {
                                    // Handle comment button press
                                  },
                                ),

                                // Comment count
                                // Padding(
                                //   padding: const EdgeInsets.only(right: 8.0),
                                //   child: Text(document['date']),
                                // ),

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
                                  child: Text(document['comment']),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
