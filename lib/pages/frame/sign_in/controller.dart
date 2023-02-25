import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_chat/common/apis/apis.dart';
import 'package:my_chat/common/entities/entities.dart';
import 'package:my_chat/common/store/store.dart';
import 'package:my_chat/common/widgets/toast.dart';
import 'package:my_chat/pages/frame/sign_in/state.dart';

import '../../../common/routes/names.dart';

class SignInController extends GetxController {
  SignInController();
  final state = SignInState();

  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['openid']);
  Future<void> handleSignIn(String type) async {
    // 1: email, 2:google 3: facebook 4: apple 5: phone
    try {
      if (type == 'phone number') {
        if (kDebugMode) {
          print('... you are logging in with phone number');
        }
      } else if (type == "google") {
        if (kDebugMode) {
          print('... you are logging in with google');
        }
        var user = await _googleSignIn.signIn();
        if (user != null) {
          final _gAuthentication = await user.authentication;
          final _credential = GoogleAuthProvider.credential(
              idToken: _gAuthentication.idToken,
              accessToken: _gAuthentication.accessToken);
          await FirebaseAuth.instance.signInWithCredential(_credential);
          print("name ${user.displayName}");
          String? displayName = user.displayName;
          String email = user.email;
          String id = user.id;
          String photoUrl = user.photoUrl ?? 'assets/icons/google.png';
          LoginRequestEntity loginPanelListRequestEntity = LoginRequestEntity();
          loginPanelListRequestEntity.avatar = photoUrl;
          loginPanelListRequestEntity.name = displayName;
          loginPanelListRequestEntity.email = email;
          loginPanelListRequestEntity.open_id = id;
          loginPanelListRequestEntity.type = 2;
          if (kDebugMode) {
            print(jsonEncode(loginPanelListRequestEntity));
          }
          asyncPostAllData(loginPanelListRequestEntity);
        }
      } else {
        if (kDebugMode) {
          print('... login type not sure');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('...error with login $e');
      }
    }
  }

  asyncPostAllData(LoginRequestEntity loginRequestEntity) async {
    //first save in the database
    //second save in the local storage

    // await HttpUtil()
    //     .get('/api/index')
    //     .then((value) => print("Result $value"))
    //     .catchError((e) => Get.defaultDialog(title: 'Error', content: e))
    //     .whenComplete(() => UserStore.to.setIsLogin = true);
    EasyLoading.show(
      indicator: const CircularProgressIndicator(),
      maskType: EasyLoadingMaskType.clear,
      dismissOnTap: true,
    );
    var result = await UserAPI.Login(params: loginRequestEntity);
    result.code == 0
        ? {
            await UserStore.to.saveProfile(result.data!),
            EasyLoading.dismiss(),
          }
        : {EasyLoading.dismiss(), toastInfo(msg: "Internet error")};

    Get.offAllNamed(AppRoutes.Message);
  }
}
