import 'package:aph/Home/home_%20deatils.dart';
import 'package:aph/Model/all_posts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Utils/color.dart';
import '../Utils/gradients.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
        comment: 'comment'),
    AllPostModel(
      id: '1',
      userImage:
          'https://c.saavncdn.com/216/Ishq-Nahi-Aasan-From-Anari-Is-Backk-Hindi-2023-20231207111403-500x500.jpg',
      userName: 'oeshioeon',
      image:
          'https://c.saavncdn.com/205/Pakeezah-From-Do-Ajnabee-Hindi-2023-20231023153010-500x500.jpg',
      title: 'Anuj Saini',
      comment: '01/01/2024 | 10:25 PM',
      isLiked: false,
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
      isLiked: false,
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
      isLiked: false,
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
      isLiked: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSelect.background,
        body: Container(
      padding: EdgeInsets.all(10.0),
      child: Container(
        child: ListView.builder(
          itemCount: allpost.length,
          itemBuilder: (context, index) {
            AllPostModel currentComment = allpost[index];
            return GestureDetector(
                onTap: () {

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return HomeDetailsScreen( todo: allpost[index],);
                  },
                ),
              );
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
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius
                                .zero, // This makes the card edges non-rounded
                          ),
                          child: Image.network(
                            currentComment.image,
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
                          child: Text(currentComment.userName),
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
                            icon: currentComment.isLiked
                                ? Icon(Icons.thumb_up, color: Colors.red)
                                : Icon(Icons.thumb_up_alt_outlined),
                            onPressed: () {
                              setState(() {
                                // Toggle the like state
                                currentComment.isLiked =
                                    !currentComment.isLiked;

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
            )
            );
          },
        ),
      ),
    ));
  }
}
