import 'package:aph/Model/all_posts.dart';
import 'package:aph/UploadImage/all_post.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
      'https://c.saavncdn.com/616/Tiger-3-Hindi-2023-20231206092502-500x500.jpg',
      userName: '',
      image:
      'https://c.saavncdn.com/744/The-Archies-Hindi-2023-20231127202131-500x500.jpg',
      title: 'प्रेम विवाह ,शादी मे समस्या , ग्रह कलेश , पति पत्नी मे अनबन , सौतन से छुटकारा , सास को काबू करना , प्यार में धोखा खाये प्रेमी प्रेमिका एक बार अवश्य संपर्क करें - +91-8192926565',
      comment: '12/01/2024 | 01:25 PM',
      isLiked: false, type: 'image', url: 'https://astropanditharidwar.in/astrologgerAssets/images/bannerImg2.png',
    ),
    AllPostModel(
      id: '1',
      userImage:
      'https://c.saavncdn.com/616/Tiger-3-Hindi-2023-20231206092502-500x500.jpg',
      userName: '',
      image:
      'https://c.saavncdn.com/744/The-Archies-Hindi-2023-20231127202131-500x500.jpg',
      title: 'प्रेम विवाह ,शादी मे समस्या , ग्रह कलेश , पति पत्नी मे अनबन , सौतन से छुटकारा , सास को काबू करना , प्यार में धोखा खाये प्रेमी प्रेमिका एक बार अवश्य संपर्क करें - +91-8192926565',
      comment: '12/01/2024 | 01:25 PM',
      isLiked: false, type: 'image', url: 'https://astropanditharidwar.in/astrologgerAssets/images/bannerImg1.png',
    ),
    AllPostModel(
      id: '1',
      userImage:
      'https://c.saavncdn.com/616/Tiger-3-Hindi-2023-20231206092502-500x500.jpg',
      userName: 'अपने पूर्व प्रेम को वापस पाएं',
      image:
      'https://c.saavncdn.com/744/The-Archies-Hindi-2023-20231127202131-500x500.jpg',
      title: '"खो चुके प्रेम को फिर से पाने के लिए आकाशीय क्षेत्रों की ओर मुख करें। हमारे व्यक्तिगत उपाय आपके संबंध में विशेष समस्याओं का समाधान करेंगे।"',
      comment: '12/01/2024 | 01:25 PM',
      isLiked: false, type: 'image', url: 'http://192.168.1.8:5500/astrologgerAssets/images/serviceImg4.png',
    ),
    AllPostModel(
      id: '1',
      userImage:
      'https://c.saavncdn.com/616/Tiger-3-Hindi-2023-20231206092502-500x500.jpg',
      userName: 'प्रेम विवाह समस्या',
      image:
      'https://c.saavncdn.com/744/The-Archies-Hindi-2023-20231127202131-500x500.jpg',
      title: 'अगर आप अपने प्रेम विवाह में चुनौतियों का सामना कर रहे हैं, तो आपको यह आश्वासन दिया जाता है कि किसी भी अप्रत्याशित बाधा से अपने विवाहीय खुशियों को संरक्षित करने के लिए वास्तविक समाधान मौजूद हैं',
      comment: '12/01/2024 | 01:25 PM',
      isLiked: false, type: 'image', url: 'https://astropanditharidwar.in/astrologgerAssets/images/serviceImg1.png'
    ),
    AllPostModel(
      id: '1',
      userImage:
      'https://c.saavncdn.com/616/Tiger-3-Hindi-2023-20231206092502-500x500.jpg',
      userName: 'संबंध समस्या',
      image:
      'https://c.saavncdn.com/744/The-Archies-Hindi-2023-20231127202131-500x500.jpg',
      title: 'ज्योतिष द्वारा प्रदान की गई अनुभूतियों का स्वागत करने से, एक स्वस्थ और अधिक संतोषप्रद संबंध का मार्ग खोला जा सकता है, इसका ध्यान रखते हुए कि आप और आपका साथी चुनौतियों का सामना कर सकते हैं और एक मजबूत बंधन बना सकते हैं।',
      comment: '12/01/2024 | 01:25 PM',
      isLiked: false, type: 'image', url: 'https://astropanditharidwar.in/astrologgerAssets/images/serviceImg2.png',
    ),
    AllPostModel(
      id: '1',
      userImage:
      'https://c.saavncdn.com/616/Tiger-3-Hindi-2023-20231206092502-500x500.jpg',
      userName: 'आर्थिक समस्या',
      image:
      'https://c.saavncdn.com/744/The-Archies-Hindi-2023-20231127202131-500x500.jpg',
      title: '"आर्थिक प्रतिकूलताओं का बोझ बोझ न उठाएं; बजाय इसके, इन शक्तिशाली समाधानों का उपयोग करें जो नुकसान को रोकने और एक स्थिर समृद्धि के दौर को आगे बढ़ाने के लिए तैयार किए गए हैं, और अपने आर्थिक भविष्य को संभालें।"',
      comment: '12/01/2024 | 01:25 PM',
      isLiked: false, type: 'image', url: 'https://astropanditharidwar.in/astrologgerAssets/images/serviceImg3.png',
    ),
    AllPostModel(
      id: '1',
      userImage:
          'https://c.saavncdn.com/057/Barse-Re-From-Manush-Hindi-Hindi-2023-20231113122507-500x500.jpg',
      userName: 'dsfshdvjbk',
      image:
          'https://storage.googleapis.com/gtv-videos-bucket/sample/images/BigBuckBunny.jpg',
      title: 'Big Buck Bunny tells the story of a giant rabbit with a heart bigger than himself. When one sunny day three rodents rudely harass him, something snaps... and the rabbit ain',
      comment: '02/02/2024 | 10:25 PM',
      isLiked: false,
      type: 'video', url: 'https://media.istockphoto.com/id/1301645599/video/studying-plotting-course-on-the-map.mp4?s=mp4-640x640-is&k=20&c=zphk5Vk9bTXhe5utAIMoXv1cPAloRqejiMAegxCDGIY=',
    ),
    AllPostModel(
        id: '1',
        userImage:
            'https://api-private.atlassian.com/users/1a80abede0a9f4d0661e20d74bb6079b/avatar',
        userName: 'जाति-धर्म विवाह',
        image:
            'https://c.saavncdn.com/744/The-Archies-Hindi-2023-20231127202131-500x500.jpg',
        title: 'अंतर्जातीय विवाह की यात्रा में सावधानी से अपने साथी के साथ एक सुगम संयुक्ति तय करना, जो एक विभिन्न जाति से हो, साथ ही माता-पिता की स्वीकृति भी संबंध में निरंतर रखना।',
        isLiked: false,
        comment:  '015/01/2024 | 04:25 PM',
        type: 'image', url: 'https://astropanditharidwar.in/astrologgerAssets/images/serviceImg6.png'),
    AllPostModel(
      id: '1',
      userImage:
          'https://c.saavncdn.com/216/Ishq-Nahi-Aasan-From-Anari-Is-Backk-Hindi-2023-20231207111403-500x500.jpg',
      userName: 'oeshioeon',
      image:
          'https://c.saavncdn.com/205/Pakeezah-From-Do-Ajnabee-Hindi-2023-20231023153010-500x500.jpg',
      title: '"अंतर्जातीय विवाह की यात्रा में सावधानी से अपने साथी के साथ एक सुगम संयुक्ति तय करना, जो एक विभिन्न जाति से हो, साथ ही माता-पिता की स्वीकृति भी संबंध में निरंतर रखना।"',
      comment: '04/01/2024 | 07:25 AM',
      isLiked: false, type: 'video', url: 'https://media.istockphoto.com/id/475338912/video/flying-through-stars-and-nebula.mp4?s=mp4-640x640-is&k=20&c=v1Vdy3BfZkiIQ5i3bk0K8pIKI0_xKn0FGPtAs0Y9O-M=',
    ),
    AllPostModel(
      id: '1',
      userImage:
          'https://c.saavncdn.com/616/Tiger-3-Hindi-2023-20231206092502-500x500.jpg',
      userName: 'पति-पत्नी की समस्या',
      image:
          'https://c.saavncdn.com/744/The-Archies-Hindi-2023-20231127202131-500x500.jpg',
      title: '"वह एक जगह है जहां सभी संतोष बसता है, और उस आनंद की प्रेरणा बन जाती है जो आपकी आत्मा के सार के रूप में विकसित होती है, और जिसकी उत्कृष्टता आपकी खुशी की नींव बनती है।"',
      comment: '12/01/2024 | 01:25 PM',
      isLiked: false, type: 'image', url: 'https://astropanditharidwar.in/astrologgerAssets/images/serviceImg5.png',
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
      isLiked: false, type: 'video', url: 'https://media.istockphoto.com/id/1323074672/video/astrology-chart.mp4?s=mp4-640x640-is&k=20&c=Da13LXViq1Fl4ybcEFiOt7PWaoUFnLYewQWK2fLDleM=',
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
      isLiked: false, type: 'video', url: 'https://cdn.pixabay.com/vimeo/601190875/moon-87691.mp4?width=640&hash=e8f1ae41c729d52b70081de40c7128f5cfcb0105',
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
      isLiked: false, type: 'video', url: 'https://cdn.pixabay.com/vimeo/509542715/signs-64055.mp4?width=640&hash=b5985b3ff6f86263cd4863d260a3f81a8e932d51',
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
      isLiked: false, type: 'video', url: 'https://cdn.pixabay.com/vimeo/800681001/aries-151417.mp4?width=640&hash=681b539070525ccf58de40054ad50ec2c26e0d48',
    ),
    AllPostModel(
      id: '1',
      userImage:
          'https://c.saavncdn.com/120/Farrey-Hindi-2023-20231120143048-500x500.jpg',
      userName: 'ioheagioh',
      image:
          'https://c.saavncdn.com/744/The-Archies-Hindi-2023-20231127202131-500x500.jpg',
      title: 'Big Buck Bunny tells the story of a giant rabbit with a heart bigger than himself. When one sunny day three rodents rudely harass him, something snaps... and the rabbit ain',
      comment: '01/12/2023 | 10:25 AM',
      isLiked: false, type: 'image', url: 'https://cdn.pixabay.com/photo/2016/09/05/17/39/zodiac-1647160_640.jpg',
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
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) {
                        //       return AllPosts();
                        //     },
                        //   ),
                        // );

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return HomeDetailsScreen( todo: currentComment, type: currentComment.type,);
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
                                Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(currentComment.userName,
                                      style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                            color: ColorSelect.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    // child: Text(apiData[index]['video']),
                                  ),
                                ),
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
                                Container(
                                  color: Colors.orange.shade100,
                                  child: Row(
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
                                        child: Text(currentComment.comment.toString()),
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