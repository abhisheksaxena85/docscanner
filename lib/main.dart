import 'package:docscanner/utils/themes/main_theme.dart';
import 'package:docscanner/views/screen/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(412, 892),
        minTextAdapt: true,
        builder: (context, child) {
          return GetMaterialApp(
            title: 'Doc-Scanner',
            debugShowCheckedModeBanner: false,
            theme: mainTheme(),
            home: const Dashboard(),
          );
        });
  }
}
