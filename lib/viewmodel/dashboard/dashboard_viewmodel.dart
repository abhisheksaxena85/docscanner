import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class DashboardViewmodel extends GetxController {
  RxInt currentIndex = 0.obs;
  late TabController tabController;
}
