import 'dart:convert';

import 'package:aph/Utils/color.dart';
import 'package:aph/baseurlp/baseurl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Auth/auth_service.dart';
import '../Login/login.dart';
import '../constants/color_constants.dart';
import '../constants/firestore_constants.dart';
import 'package:http/http.dart' as http;
import 'dart:io';


class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key,});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {


  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController bioController = TextEditingController();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();

  TextEditingController titleController = TextEditingController();
  TextEditingController subtitleController = TextEditingController();
  TextEditingController artistController = TextEditingController();
  TextEditingController controllerContact = TextEditingController();
  File? galleryFile;

  final picker = ImagePicker();

  bool isVisible = false;

  final FocusNode focusNodeNickname = FocusNode();

  final FocusNode focusNodeEmail = FocusNode();

  final FocusNode focusNodeAboutMe = FocusNode();

  void toggleVisibility() {
    setState(() {
      isVisible = !isVisible;
    });
  }

  TextEditingController? controllerNickname;

  TextEditingController? controllerEmail;

  TextEditingController? controllerAboutMe;
  // TextEditingController? controllerContact;

  bool isEditing = false;

  String id = '';

  String nickname = '';

  String aboutMe = '';

  String photoUrl = '';

  String userEmail = '';

  bool isLoading = false;

  File? avatarImageFile;

  bool _loading = false;

  bool _isLoading = false;

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    fetchProfileData();
  }
  Future<void> fetchProfileData() async {

    setState(() {
      _isLoading = true;
    });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString(
      'token',
    );
    final Uri uri =
    Uri.parse(getProfile);
    final Map<String, String> headers = {'Authorization': 'Bearer $token'};
    final response = await http.get(uri, headers: headers);

    setState(() {
      _isLoading =
      false; // Set loading state to false after registration completes
    });
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      setState(() {
        nameController.text = jsonData['user']['name'];
        emailController.text = jsonData['user']['email'];
        phoneController.text = jsonData['user']['contact'];
        bioController.text = jsonData['user']['bio'];
        photoUrl = jsonData['user']['picture_data'];
      });
    } else {
      throw Exception('Failed to load profile data');
    }
  }

  Future<void> _updateProfile() async {
    // Show loading dialog
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

    // Get user input data
    String name = _nameController.text;
    String email = _emailController.text;
    String phoneNumber = _phoneNumberController.text;

    // Get the selected image file
    File? imageFile = await getImageFile(); // Implement this method to pick an image

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    // Your API endpoint for updating profile
    String apiUrl = 'https://api.astropanditharidwar.in/api/update_profile';

    try {
      // Create multipart request for image upload
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      // Add image file to the request
      if (imageFile != null) {
        request.files.add(
          http.MultipartFile(
            'profile_image',
            imageFile.readAsBytes().asStream(),
            imageFile.lengthSync(),
            filename: (imageFile.path),
          ),
        );
      }

      // Add other fields to the request
      request.fields.addAll({
        'name': name,
        'email': email,
        'phone_number': phoneNumber,
      });

      // Add authorization header
      request.headers['Authorization'] = 'Bearer $token';

      // Send the request
      var response = await request.send();

      if (response.statusCode == 200) {
        // Profile updated successfully
        print('Profile updated successfully');

        Navigator.pop(context); // Close loading dialog

        Fluttertoast.showToast(
          msg: "Update Profile successfully",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 22.0,
        );
        // You can navigate to another screen or show a success message
      } else {
        // Error occurred while updating profile
        print('Failed to update profile. Error: ${response.statusCode}');
        // Handle error accordingly, show error message, etc.
      }
    } catch (e) {
      print('Exception occurred: $e');
      // Handle exception, show error message, etc.
    }
  }

  Future<File?> getImageFile() async {
    // Implement method to pick an image from gallery or camera
    // You can use plugins like image_picker to achieve this
    // Example:
    // final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
    // return pickedFile != null ? File(pickedFile.path) : null;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: Text('Update Profile'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      color: Colors.orangeAccent,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5.0, bottom: 50),
                        child: Stack(fit: StackFit.loose, children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.all(20),
                                child: avatarImageFile == null
                                    ? photoUrl.isNotEmpty
                                    ? ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: Image.network(
                                    photoUrl,
                                    fit: BoxFit.cover,
                                    width: 140,
                                    height: 140,
                                    errorBuilder:
                                        (context, object, stackTrace) {
                                      return Image.network(
                                        'https://media.istockphoto.com/id/1394514999/photo/woman-holding-a-astrology-book-astrological-wheel-projection-choose-a-zodiac-sign-astrology.jpg?s=612x612&w=0&k=20&c=XIH-aZ13vTzkcGUTbVLwPcp_TUB4hjVdeSSY-taxlOo=',
                                        fit: BoxFit.cover,
                                        width: 140,
                                        height: 140,
                                      );
                                    },
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null)
                                        return child;
                                      return Container(
                                        width: 90,
                                        height: 90,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            color:
                                            ColorConstants.themeColor,
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
                                    : ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  // Half of width/height for perfect circle
                                  child: Image.network(
                                    'https://media.istockphoto.com/id/1394514999/photo/woman-holding-a-astrology-book-astrological-wheel-projection-choose-a-zodiac-sign-astrology.jpg?s=612x612&w=0&k=20&c=XIH-aZ13vTzkcGUTbVLwPcp_TUB4hjVdeSSY-taxlOo=',
                                    fit: BoxFit.cover,
                                    width: 140,
                                    height: 140,
                                  ),
                                )
                                    : ClipRRect(
                                  borderRadius: BorderRadius.circular(45),
                                  child: Image.file(
                                    avatarImageFile!,
                                    width: 90,
                                    height: 90,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                              padding:
                              const EdgeInsets.only(top: 135.0, right: 110.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  InkWell(
                                      onTap: () {
                                        _showPicker(context: context);
                                      },
                                      child: const CircleAvatar(
                                        backgroundColor: Colors.red,
                                        radius: 15.0,
                                        child: Icon(
                                          Icons.camera_alt,
                                          color: Colors.white,
                                        ),
                                      )),
                                ],
                              )),
                        ]),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 1.0),
                      child: Divider(
                        color: Colors.grey, // Set the color of the divider
                        thickness: 1.0, // Set the thickness of the divider
                        height: 0, // Set the height of the divider
                      ),
                    ),

                    Container(
                      color: Color(0xffFFFFFF),
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 25.0),
                        child:  Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 10.0,bottom: 25),
                                child:  Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text(
                                          'Parsonal Information',
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    // new Column(
                                    //   mainAxisAlignment: MainAxisAlignment.end,
                                    //   mainAxisSize: MainAxisSize.min,
                                    //   children: <Widget>[
                                    //     _status ? _getEditIcon() : new Container(),
                                    //   ],
                                    // )
                                  ],
                                )),
                            const Divider(
                              color: Colors.grey, // Set the color of the divider
                              thickness: 1.0, // Set the thickness of the divider
                              height: 1, // Set the height of the divider
                            ),
                            ListTile(
                              leading: const Icon(
                                Icons.account_circle,
                                size: 30,
                                color: Colors.black,
                              ),
                              title: Text(
                                'Name',
                                style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 19,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                              subtitle: Padding(
                                  padding: EdgeInsets.only(
                                      left: 0.0, right: 25.0, top: 0.0),
                                  child:  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Flexible(
                                        child:  TextField(
                                          controller: nameController,
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,

                                            hintText: "Enter Your Name",
                                          ),
                                          // enabled: !_status,
                                          // autofocus: !_status,
                                          style: TextStyle(color: Colors.black),


                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                            const Divider(
                              color: Colors.grey, // Set the color of the divider
                              thickness: 1.0, // Set the thickness of the divider
                              height: 1, // Set the height of the divider
                            ),
                            ListTile(
                              leading: const Icon(
                                Icons.email,
                                size: 30,
                                color: Colors.black,
                              ),
                              title: Text(
                                'Email',
                                style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 19,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                              subtitle:                             Padding(
                                  padding: EdgeInsets.only(
                                      left: 0.0, right: 25.0, top: 0.0),
                                  child:  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Flexible(
                                        child:  TextField(
                                          controller: emailController,
                                          decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              hintText: "Enter Email ID"),
                                          style: TextStyle(color: Colors.black),

                                        ),
                                      ),
                                    ],
                                  )),

                            ),
                            const Divider(
                              color: Colors.grey, // Set the color of the divider
                              thickness: 1.0, // Set the thickness of the divider
                              height: 1, // Set the height of the divider
                            ),

                            ListTile(
                              leading: Icon(
                                Icons.account_circle,
                                size: 30,
                                color: Colors.black,
                              ),
                              title: Padding(
                                  padding: EdgeInsets.only(
                                      left: 0.0, right: 25.0, top: 0.0),
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          new Text(
                                            'Mobile',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),

                              subtitle:  Padding(
                                  padding: EdgeInsets.only(
                                      left: 0.0, right: 25.0, top: 0.0),
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Flexible(
                                        child: new TextField(
                                          controller: phoneController,
                                          decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              hintText: "Enter Mobile Number"),
                                          style: TextStyle(color: Colors.black,fontSize: 20),

                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                            const Divider(
                              color: Colors.grey, // Set the color of the divider
                              thickness: 1.0, // Set the thickness of the divider
                              height: 1, // Set the height of the divider
                            ),
                            ListTile(
                              leading: Icon(
                                Icons.account_circle,
                                size: 30,
                                color: Colors.black,
                              ),
                              title: Text(
                                'Bio',
                                style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 19,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                              subtitle:                             Padding(
                                  padding: EdgeInsets.only(
                                      left: 0.0, right: 25.0, top: 0),
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Flexible(
                                        child: Padding(
                                          padding: EdgeInsets.only(right: 10.0),
                                          child: new TextField(
                                            controller: bioController,
                                            decoration: const InputDecoration(
                                                border: InputBorder.none,
                                                hintText: "bio"),
                                            style: TextStyle(color: Colors.black),

                                          ),
                                        ),
                                        flex: 2,
                                      ),
                                    ],
                                  )),

                            ),
                            const Divider(
                              color: Colors.grey, // Set the color of the divider
                              thickness: 1.0, // Set the thickness of the divider
                              height: 1, // Set the height of the divider
                            ),
                            SizedBox(height: 20),


                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 28.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: ColorSelect
                                .buttonColor // Set the background color here
                        ),
                        onPressed: () {
                          // _updateProfile();
                          _updateProfile();

                        },
                        child: Text(
                          'Update Profile',
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      ),
                    ),


                  ],
                ),
              )),
          _loading ? Center(child: CircularProgressIndicator(
            color: Colors.orangeAccent,
          )) : SizedBox(),
        ],
      ),
    );
  }

  void _showPicker({
    required BuildContext context,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Library'),
                onTap: () {
                  getImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  getImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future getImage(
      ImageSource img,
      ) async {

    setState(() {
      _loading = true; // Show progress indicator
    });

    ImagePicker imagePicker = ImagePicker();
    XFile? pickedFile = await imagePicker
        .pickImage(source: ImageSource.gallery)
        .catchError((err) {
      Fluttertoast.showToast(msg: err.toString());
      setState(() {
        _loading = false; // Hide progress indicator
      });
      return null;
    });
    File? image;
    if (pickedFile != null) {
      image = File(pickedFile.path);
    }
    if (image != null) {
      setState(() {
        avatarImageFile = image;
        isLoading = true;
      });
      // uploadFile();
    }

    setState(() {
      _loading = false; // Hide progress indicator
    });
  }

}


