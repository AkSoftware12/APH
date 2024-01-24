import 'package:aph/Model/all_posts.dart';
import 'package:aph/UploadImage/all_post.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';
import '../UploadImage/get_image.dart';
import '../UploadImage/load_image.dart';
import '../UploadImage/real.dart';
import '../UploadImage/upload_image.dart';
import '../Utils/color.dart';
import '../Video Player/demo.dart';
import 'home_ deatils.dart';

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
          'https://storage.googleapis.com/gtv-videos-bucket/sample/images/BigBuckBunny.jpg',
      title: 'Big Buck Bunny tells the story of a giant rabbit with a heart bigger than himself. When one sunny day three rodents rudely harass him, something snaps... and the rabbit ain',
      comment: '01/01/2024 | 10:25 PM',
      isLiked: false,
      type: 'video', url: 'https://storage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
    ),
    AllPostModel(
        id: '1',
        userImage:
            'https://api-private.atlassian.com/users/1a80abede0a9f4d0661e20d74bb6079b/avatar',
        userName: 'jfeaugihb',
        image:
            'https://c.saavncdn.com/744/The-Archies-Hindi-2023-20231127202131-500x500.jpg',
        title: 'The Smoking Tire meets up with Chris and Jorge from CarsForAGrand.com to see just how far 1,000 can go when looking for a car.The Smoking Tire meets up with Chris and Jorge from CarsForAGrand.com to see just how far 1,000 can go when looking for a car.',
        isLiked: false,
        comment: 'comment', type: 'image', url: 'https://c.saavncdn.com/744/The-Archies-Hindi-2023-20231127202131-500x500.jpg'),
    AllPostModel(
      id: '1',
      userImage:
          'https://c.saavncdn.com/216/Ishq-Nahi-Aasan-From-Anari-Is-Backk-Hindi-2023-20231207111403-500x500.jpg',
      userName: 'oeshioeon',
      image:
          'https://c.saavncdn.com/205/Pakeezah-From-Do-Ajnabee-Hindi-2023-20231023153010-500x500.jpg',
      title: 'The Smoking Tire is going on the 2010 Bullrun Live Rally in a 2011 Shelby GT500, and posting a video from the road every single day! The only place to watch them is by subscribing to The Smoking Tire or watching at BlackMagicShine.com',
      comment: '01/01/2024 | 10:25 PM',
      isLiked: false, type: 'video', url: 'https://storage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
    ),
    AllPostModel(
      id: '1',
      userImage:
          'https://c.saavncdn.com/616/Tiger-3-Hindi-2023-20231206092502-500x500.jpg',
      userName: 'bjdfjbi',
      image:
          'https://c.saavncdn.com/744/The-Archies-Hindi-2023-20231127202131-500x500.jpg',
      title: 'Tears of Steel was realized with crowd-funding by users of the open source 3D creation tool Blender. Target was to improve and test a complete open and free pipeline for visual effects in film - and to make a compelling sci-fi film in Amsterdam, the Netherlands.  The film itself, and all raw material used for making it, have been released under the Creatieve Commons 3.0 Attribution license. Visit the tearsofsteel.org website to find out more about this, or to purchase the 4-DVD box with a lot of extras.  (CC) Blender Foundation - http://www.tearsofsteel.org',
      comment: '01/01/2024 | 10:25 PM',
      isLiked: false, type: 'image', url: 'https://c.saavncdn.com/616/Tiger-3-Hindi-2023-20231206092502-500x500.jpg',
    ),
    AllPostModel(
      id: '1',
      userImage:
          'https://c.saavncdn.com/172/Pippa-Hindi-2023-20231113184331-500x500.jpg',
      userName: 'ogipheg',
      image:
          'https://c.saavncdn.com/205/Pakeezah-From-Do-Ajnabee-Hindi-2023-20231023153010-500x500.jpg',
      title: 'Big Buck Bunny tells the story of a giant rabbit with a heart bigger than himself. When one sunny day three rodents rudely harass him, something snaps... and the rabbit ain',
      comment: '01/01/2024 | 10:25 PM',
      isLiked: false, type: 'video', url: 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    ),
    AllPostModel(
      id: '1',
      userImage:
          'https://c.saavncdn.com/120/Farrey-Hindi-2023-20231120143048-500x500.jpg',
      userName: 'ioheagioh',
      image:
          'https://c.saavncdn.com/744/The-Archies-Hindi-2023-20231127202131-500x500.jpg',
      title: 'Big Buck Bunny tells the story of a giant rabbit with a heart bigger than himself. When one sunny day three rodents rudely harass him, something snaps... and the rabbit ain',
      comment: '01/01/2024 | 10:25 PM',
      isLiked: false, type: 'image', url: 'https://c.saavncdn.com/744/The-Archies-Hindi-2023-20231127202131-500x500.jpg',
    ),
  ];
  List<dynamic> apiData = [];
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

  @override
  void initState() {
    super.initState();
     fetchData();

  }

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
                        // //
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return AllPosts();
                            },
                          ),
                        );

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
                                          if (allpost[index].type == 'video')
                                            VideoPlayerScreen(url: allpost[index].url),
                                          if (allpost[index].type  == 'image')
                                            Container(
                                              height: 300,
                                                width: double.infinity,
                                                child: Image.network(allpost[index].url,fit: BoxFit.fill,)),
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
                                    child: Text(currentComment.title),
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
                                      child: Text(currentComment.timestamp.toString()),
                                    ),

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

          ),

        ],
      ),
    ));
  }
}
class VideoPlayerScreen extends StatefulWidget {

  final String url;
  const VideoPlayerScreen({super.key, required this.url});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();

    // Create and store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(
        widget.url,
      ),
    );

    // Initialize the controller and store the Future for later use.
    _initializeVideoPlayerFuture = _controller.initialize();

    // Use the controller to loop the video.
    _controller.setLooping(true);
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
            height: 300,
            width: double.infinity,
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              // Use the VideoPlayer widget to display the video.
              child: VideoPlayer(_controller),
            )
        ),
        Center(

          child: FloatingActionButton(
            onPressed: () {
              // Wrap the play or pause in a call to `setState`. This ensures the
              // correct icon is shown.
              setState(() {
                // If the video is playing, pause it.
                if (_controller.value.isPlaying) {
                  _controller.pause();
                } else {
                  // If the video is paused, play it.
                  _controller.play();
                }
              });
            },
            // Display the correct icon depending on the state of the player.
            child: Icon(
              _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
            ),
          ),
        ),
      ],
    );
  }
}