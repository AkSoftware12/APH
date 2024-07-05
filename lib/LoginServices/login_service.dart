// Package imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

// Project imports:
import 'common.dart';
import 'constants.dart';

/// local virtual login
Future<void> loginCall({
  required String userID,
  required String userName,
  required String userImage,
}) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString(cacheUserIDKey, userID);

  currentUser.id = userID;
  currentUser.name = userName;
  currentUser.image = userImage;
}

/// local virtual logout
Future<void> logout() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.remove(cacheUserIDKey);
}

/// on user login
Future<void> onUserLogin() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? image = prefs.getString('userImage',);
  final String? id = prefs.getString('userId',);
  final String? name = prefs.getString('name',);
  /// 4/5. initialized ZegoUIKitPrebuiltCallInvitationService when account is logged in or re-logged in
  ZegoUIKitPrebuiltCallInvitationService().init(
    appID: 1935322508 /*input your AppID*/,
    appSign: 'ffb19a8f293b5d4980f4ee4c2f1586ca97ad62ebf09640383125adfa1af01198',
    userID:id.toString(),
    userName: name.toString(),
    plugins: [ZegoUIKitSignalingPlugin()],
    requireConfig: (ZegoCallInvitationData data) {
      final config = (data.invitees.length > 1)
          ? ZegoCallInvitationType.videoCall == data.type
              ? ZegoUIKitPrebuiltCallConfig.groupVideoCall()
              : ZegoUIKitPrebuiltCallConfig.groupVoiceCall()
          : ZegoCallInvitationType.videoCall == data.type
              ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
              : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall();

      /// custom avatar
      config.avatarBuilder = customAvatarBuilder;

      /// support minimizing, show minimizing button
      config.topMenuBar.isVisible = true;
      config.topMenuBar.buttons
          .insert(0, ZegoCallMenuBarButtonName.minimizingButton);
      config.topMenuBar.buttons
          .insert(1, ZegoCallMenuBarButtonName.soundEffectButton);

      return config;
    },
  );
}

/// on user logout
void onUserLogout() {
  /// 5/5. de-initialization ZegoUIKitPrebuiltCallInvitationService when account is logged out
  ZegoUIKitPrebuiltCallInvitationService().uninit();
}
Widget customAvatarBuilder(
    BuildContext context,
    Size size,
    ZegoUIKitUser? user,
    Map<String, dynamic> extraInfo,
    ) {
  return  CircleAvatar(
    radius: 100 / 2,
    backgroundImage: NetworkImage('https://sya.utl.gov.in/public/assets/images/admin_login.png'),
  );
}