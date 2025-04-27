import 'package:docscanner/utils/app_colors.dart';
import 'package:docscanner/viewmodel/dashboard/dashboard_viewmodel.dart';
import 'package:docscanner/views/screen/dashboard/widgets/dashboard_tabbar.dart';
import 'package:docscanner/views/screen/dashboard/widgets/dashboard_tabview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  // Create an instance of the DashboardViewmodel
  final DashboardViewmodel controller = Get.put(DashboardViewmodel());

  @override
  void initState() {
    super.initState();
    controller.tabController = TabController(
        length: 3,
        vsync: this,
        initialIndex: 0,
        animationDuration: const Duration(milliseconds: 50))
      ..addListener(() {
        controller.currentIndex.value = controller.tabController.index;
      });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          backgroundColor: AppColors.brandBgColor,
          appBar: AppBar(
            toolbarHeight: 0.h,
            title: const Text('Dashboard'),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Build Tabbar header
              buildTabBar(context, controller),

              SizedBox(
                height: 10.h,
              ),

              /// Build Tabbar view
              DashboardTabview(controller: controller),
            ],
          )),
    );
  }
}
