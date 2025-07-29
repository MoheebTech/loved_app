import 'package:get/get.dart';
import 'package:loved_app/controllers/general_controller.dart';
import 'package:loved_app/controllers/home_controller.dart';
import 'package:loved_app/controllers/i_am_lost_controller.dart';
import 'package:loved_app/controllers/i_have_found_controller.dart';
import 'package:loved_app/utils/chat_module_by_aqib/controller/chat_controller.dart';

import '../controllers/auth_controller.dart';


Future  DataBindings() async{



  Get.lazyPut(() => AuthController(),fenix: true);
  Get.lazyPut(() => GeneralController(),fenix: true);
  Get.lazyPut(() => HomeController(),fenix: true);
  Get.lazyPut(() => IAmLostController(),fenix: true);
  Get.lazyPut(() => IHaveFoundSomeoneController(),fenix: true);
  Get.lazyPut(() => ChatController(),fenix: true);




}