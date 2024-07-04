// Flutter imports:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Package imports:
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

// Project imports:
import 'common.dart';
import 'constants.dart';

class LivePage extends StatefulWidget {
  final String liveID;
  final String userName;
  final String userId;
  final String userImage;
  final bool isHost;

  const LivePage({
    Key? key,
    required this.liveID,
    this.isHost = false, required this.userName, required this.userId, required this.userImage,
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(

      child: ZegoUIKitPrebuiltLiveStreaming(
        appID: 86453696 /*input your AppID*/,
        appSign: 'a03a9ba69242a083f74d421edc611b8925f5bd12a2e6200cf605e6247840bd6f', /*input your AppSign*/
        userID: widget.userId,
        userName: widget.userName,
        liveID: widget.liveID,
        config: (widget.isHost
            ? ZegoUIKitPrebuiltLiveStreamingConfig.host()
            : ZegoUIKitPrebuiltLiveStreamingConfig.audience())
          ..avatarBuilder = customAvatarBuilder,
      ),
    );
  }

  Widget customAvatarBuilder(
      BuildContext context,
      Size size,
      ZegoUIKitUser? user,
      Map<String, dynamic> extraInfo,
      ) {
    return CachedNetworkImage(
      imageUrl: widget.userImage,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      progressIndicatorBuilder: (context, url, downloadProgress) =>
          CircularProgressIndicator(value: downloadProgress.progress),
      errorWidget: (context, url, error) {
        ZegoLoggerService.logInfo(
          '$user avatar url is invalid',
          tag: 'live audio',
          subTag: 'live page',
        );
        return ZegoAvatar(user: user, avatarSize: size);
      },
    );
  }
}
