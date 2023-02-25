import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_chat/common/store/store.dart';

import 'state.dart';

class ProfileController extends GetxController {
  ProfileController();
  final state = ProfileState();

  Future<void> goLogout() async {
    await GoogleSignIn().signOut();
    await UserStore.to.onLogout();
  }
}
