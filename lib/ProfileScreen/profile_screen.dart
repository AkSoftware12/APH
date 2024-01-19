import 'package:aph/Utils/color.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Auth/auth_service.dart';
import '../Login/login.dart';
import '../constants/color_constants.dart';
import '../constants/firestore_constants.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: const ProfileWidget(),
    );
  }
}

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({super.key});

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  File? galleryFile;
  final picker = ImagePicker();
  bool isVisible = false;
  AuthService _authService = AuthService();
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

  bool isEditing = false;

  String id = '';
  String nickname = '';
  String aboutMe = '';
  String photoUrl = '';
  String userEmail = '';

  bool isLoading = false;
  File? avatarImageFile;

  @override
  void initState() {
    super.initState();
    readLocal();
  }

  Future<void> readLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      id = prefs.getString(FirestoreConstants.id) ?? "";
      nickname = prefs.getString(FirestoreConstants.nickname) ?? "";
      photoUrl = prefs.getString(FirestoreConstants.photoUrl) ?? "";
      userEmail = prefs.getString(FirestoreConstants.userEmail) ?? "";
    });

    controllerNickname = TextEditingController(text: nickname);
    controllerEmail = TextEditingController(text: userEmail);
    controllerAboutMe = TextEditingController(text: aboutMe);
  }



  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
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
                                  errorBuilder: (context, object, stackTrace) {
                                    return Icon(
                                      Icons.account_circle,
                                      size: 90,
                                      color: ColorConstants.greyColor,
                                    );
                                  },
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Container(
                                      width: 90,
                                      height: 90,
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
                                size: 90,
                                color: ColorConstants.greyColor,
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
                  padding: const EdgeInsets.only(top: 135.0, right: 110.0),
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
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.only(top: 5.0),
            child: Divider(
              color: Colors.grey, // Set the color of the divider
              thickness: 1.0, // Set the thickness of the divider
              height: 1, // Set the height of the divider
            ),
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
            subtitle: TextField(
              decoration: const InputDecoration(
                hintText: 'Sweetie',
                contentPadding: EdgeInsets.all(5),
                hintStyle: TextStyle(
                  color: ColorConstants.greyColor,
                ),
                // Remove underline
                border: InputBorder.none,
              ),
              controller: controllerNickname,
              onChanged: (value) {
                nickname = value;
              },
              focusNode: focusNodeNickname,
            ),
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
              subtitle: TextField(
                decoration: const InputDecoration(
                  hintText: 'Sweetie',
                  contentPadding: EdgeInsets.all(5),
                  hintStyle: TextStyle(
                    color: ColorConstants.greyColor,
                  ),
                  // Remove underline
                  border: InputBorder.none,
                ),
                controller: controllerEmail,
                onChanged: (value) {
                  userEmail = value;
                },
                focusNode: focusNodeEmail,
              )),
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
                'About Me',
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 19,
                      fontWeight: FontWeight.normal),
                ),
              ),
              subtitle: TextField(
                decoration: const InputDecoration(
                  hintText: 'Bio',
                  contentPadding: EdgeInsets.all(5),
                  hintStyle: TextStyle(
                    color: ColorConstants.greyColor,
                  ),
                  // Remove underline
                  border: InputBorder.none,
                ),
                controller: controllerAboutMe,
                onChanged: (value) {
                  aboutMe = value;
                },
                focusNode: focusNodeAboutMe,
              )),
          const Divider(
            color: Colors.grey, // Set the color of the divider
            thickness: 1.0, // Set the thickness of the divider
            height: 1, // Set the height of the divider
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(top: 28.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary:ColorSelect.buttonColor // Set the background color here
              ),
              onPressed: () {
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
    ));
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
  Future getImage(  ImageSource img,) async {
    ImagePicker imagePicker = ImagePicker();
    XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.gallery).catchError((err) {
      Fluttertoast.showToast(msg: err.toString());
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
  }

}
