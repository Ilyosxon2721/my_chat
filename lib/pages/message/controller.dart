import 'package:get/get.dart';
import 'package:my_chat/common/routes/names.dart';
import 'package:my_chat/pages/message/state.dart';

class MessageController extends GetxController {
  MessageController();
  final state = MessageState();

  void goProfile() async {
    await Get.toNamed(AppRoutes.Profile);
  }
}
