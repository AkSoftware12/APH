
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import '../Live/common.dart';

class CallPage extends StatefulWidget {
  final String callId;
  final String userName;
  final String userId;
  const CallPage({Key? key,  required this.callId, required this.userName, required this.userId}) : super(key: key);

  @override
  State<StatefulWidget> createState() => CallPageState();
}

class CallPageState extends State<CallPage> {
  @override
  Widget build(BuildContext context) {


    return SafeArea(
      child: ZegoUIKitPrebuiltCall(
        appID: 1935322508 /*input your AppID*/,
        appSign: 'ffb19a8f293b5d4980f4ee4c2f1586ca97ad62ebf09640383125adfa1af01198'
        /*input your AppSign*/,
        userID: widget.userId,
        userName:widget.userName,
        callID: widget.callId,
        config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()

          /// support minimizing
          ..topMenuBar.isVisible = true
          ..topMenuBar.buttons = [
            ZegoCallMenuBarButtonName.minimizingButton,
            ZegoCallMenuBarButtonName.showMemberListButton,
            ZegoCallMenuBarButtonName.soundEffectButton,
          ]
          ..avatarBuilder = customAvatarBuilder,
      ),
    );
  }
}
