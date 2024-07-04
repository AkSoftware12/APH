
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import '../Live/common.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';


class CallPage extends StatefulWidget {
  final String callId;
  final String userName;
  final String userId;
  final String userImage;
  final String type;
  const CallPage({Key? key,  required this.callId,
    required this.userName, required this.userId,
    required this.userImage, required this.type}) : super(key: key);

  @override
  State<StatefulWidget> createState() => CallPageState();
}

class CallPageState extends State<CallPage> {



  @override
  Widget build(BuildContext context) {


    return SafeArea(
      child:


      ZegoUIKitPrebuiltCall(
        appID: 1935322508 /*input your AppID*/,
        appSign: 'ffb19a8f293b5d4980f4ee4c2f1586ca97ad62ebf09640383125adfa1af01198'
        /*input your AppSign*/,
        userID: widget.userId,
        userName:widget.userName,
        callID: widget.callId,

        config:
       widget.type=='video'
            ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
            : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall()

          /// support minimizing
          ..topMenuBar.isVisible = true

          ..topMenuBar.buttons = [
            // ZegoCallMenuBarButtonName.minimizingButton,
            // ZegoCallMenuBarButtonName.showMemberListButton,
            // ZegoCallMenuBarButtonName.soundEffectButton,
          ]
          ..avatarBuilder = customAvatarBuilder,
      ),
    );
  }
  // Custom avatar builder function
  Widget customAvatarBuilder(
      BuildContext context,
      Size size,
      ZegoUIKitUser? user,
      Map<String, dynamic> extraInfo,
      ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        CircleAvatar(
          radius: 100 / 2,
          backgroundImage: NetworkImage(widget.userImage),
        ),

        SizedBox(
          height: 10,
        ),
        Text(widget.userName,style: TextStyle(
          fontSize: 11.sp,
          color: Colors.white
        ),)
      ],
    );
  }
}
