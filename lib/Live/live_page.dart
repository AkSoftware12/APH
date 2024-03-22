// Flutter imports:
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Package imports:
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

// Project imports:
import 'common.dart';
import 'constants.dart';

class LivePage extends StatefulWidget {
  final String liveID;
  final bool isHost;

  const LivePage({
    Key? key,
    required this.liveID,
    this.isHost = false,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => LivePageState();
}

class LivePageState extends State<LivePage> {

// Future<void> User() async {
//
//   final SharedPreferences prefs = await SharedPreferences.getInstance();
//   final String? name = prefs.getString('name');
//
// }

  final String yourAppID ='';
  @override
  Widget build(BuildContext context) {
    return SafeArea(

      child: ZegoUIKitPrebuiltLiveStreaming(
        appID: 557710623 /*input your AppID*/,
        appSign: '3828cc02e07d76d289e60cc34a638a7554bb8ff1341fcc55745c00c600887a19', /*input your AppSign*/
        userID: localUserID,
        userName: localUserID,
        liveID: widget.liveID,
        config: (widget.isHost
            ? ZegoUIKitPrebuiltLiveStreamingConfig.host()
            : ZegoUIKitPrebuiltLiveStreamingConfig.audience())
          ..avatarBuilder = customAvatarBuilder,
      ),
    );
  }
}
