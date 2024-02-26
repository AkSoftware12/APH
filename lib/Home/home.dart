
import 'package:aph/Model/all_posts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import '../ApiModel/post_data.dart';
import '../Utils/color.dart';
import 'home_ deatils.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  bool _isLiked = false;

  bool _isLoading = true;
  List<AllPostModel> allpost = [

    AllPostModel(
      id: '1',
      userImage:
      'https://c.saavncdn.com/616/Tiger-3-Hindi-2023-20231206092502-500x500.jpg',
      userName: 'पति पत्नी मे अनबन',
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
      userName: 'सास को काबू करना',
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
    // Replace 'your_token_here' with your actual token

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token =  prefs.getString('token',);
    final Uri uri = Uri.parse('https://api.astropanditharidwar.in/api/get_posts');
    final Map<String, String> headers = {'Authorization': 'Bearer $token'};

    final response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the data
      final Map<String, dynamic> responseData = json.decode(response.body);

      // Check if the response contains a 'data' key
      if (responseData.containsKey('posts')) {
        setState(() {
          // Assuming 'data' is a list, update apiData accordingly
          apiData = responseData['posts'];
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
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState)
          {
            return SingleChildScrollView(
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
                              style: TextStyle(fontSize: 13),
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
                                return ListTile(
                                  title: Text('No comments'),
                                );
                              }

                              // If comments list is not empty, display comments
                              var comment = comments[commentIndex];
                              return ListTile(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Ravi',
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
                                    'photoUrl',
                                    fit: BoxFit.cover,
                                    width: 50,
                                    height: 50,
                                    errorBuilder: (context, object, stackTrace) {
                                      return ClipRRect(
                                        borderRadius: BorderRadius.circular(30), // Half of width/height for perfect circle
                                        child: Image.network(
                                          'https://media.istockphoto.com/id/1394514999/photo/woman-holding-a-astrology-book-astrological-wheel-projection-choose-a-zodiac-sign-astrology.jpg?s=612x612&w=0&k=20&c=XIH-aZ13vTzkcGUTbVLwPcp_TUB4hjVdeSSY-taxlOo=',
                                          fit: BoxFit.cover,
                                          width: 50,
                                          height: 50,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                      ],
                    ),
                  ),
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
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.send),
                          onPressed: () async {
                            final message = messageController.text;
                            final SharedPreferences prefs = await SharedPreferences.getInstance();
                            final String? token =  prefs.getString('token');
                            final response = await http.post(
                              Uri.parse('https://api.astropanditharidwar.in/api/comment'),
                              headers: {
                                'Authorization': 'Bearer $token',
                                'Content-Type': 'application/json',
                              },
                              body: jsonEncode({'post_id':apiData[index]['id'],'comment': message}),
                            );

                            if (response.statusCode == 200) {
                              print('comment successfully!');
                            } else {
                              // Handle error
                              print('Failed to comment post: ${response.reasonPhrase}');
                            }

                            if (messageController.text.isNotEmpty) {
                              setState(() {
                                messageController.clear();
                              });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: EdgeInsets.all(1.0),
      child: Stack(
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Container(
          //     height: 100,
          //     child: ListView.builder(
          //       scrollDirection: Axis.horizontal,
          //       itemCount: 10,
          //       itemBuilder: (context, index) {
          //         return Padding(
          //           padding: const EdgeInsets.only(right: 8.0),
          //           child: ClipRRect(
          //             borderRadius: BorderRadius.circular(50), // 50 is half of your desired width
          //             child: Image.network(
          //               'https://c.saavncdn.com/905/Tujhe-Yaad-Na-Meri-Ayee-2-Hindi-2023-20231107133527-500x500.jpg',
          //               width: 100,
          //               height: 100,
          //             ),
          //           ),
          //         );
          //
          //       },
          //     ),
          //   ),
          // ),

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
                    // Data currentComment = apiData[index];
                    return GestureDetector(
                        onTap: () {
                   },

                        child: Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Card(
                            color: ColorSelect.redColor.shade100,
                            elevation: 5,
                            child: Container(
                              decoration: BoxDecoration(
                                color: ColorSelect.textcolor,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [

                                        Align(
                                          alignment: Alignment.center,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text('Vashikaran',
                                              style: GoogleFonts.poppins(
                                                textStyle: const TextStyle(
                                                    color: ColorSelect.black,
                                                    fontSize: 21,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                            // child: Text(apiData[index]['video']),
                                          ),
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
                                              'assets/image1.png',
                                              width: 30,
                                              height: 30,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(1.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              whatsapp();
                                            },
                                            child: Image.asset(
                                              'assets/play.png',
                                              width: 40,
                                              height: 40,
                                            ),
                                          ),
                                        ),
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
                                        )


                                      ],
                                    ),
                                  ),


                                  SizedBox(
                                    height: 250,
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

                                    child: Card(
                                      color: Colors.redAccent,
                                      elevation: 5,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius
                                            .zero, // This makes the card edges non-rounded
                                      ),
                                      child: Card(
                                        child: Column(
                                          children: [
                                            if (apiData[index]['file_type'] == 'video')
                                              VideoPlayerScreen(url: allpost[index].url),
                                            if (apiData[index]['file_type']  == 'image')
                                              Container(
                                                height: 234,
                                                  width: double.infinity,
                                                  child: Image.network(apiData[index]['post_data'],
                                                    fit: BoxFit.fill,
                                                  )),
                                          ],
                                        ),
                                      )
                                    ),
                                    )
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(apiData[index]['title']),
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
                                              Uri.parse('https://your-api-url/like'),
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
                                          child: Text(apiData[index]['created_at'].toString()),
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
    _controller.play();
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
            height: 234,
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

