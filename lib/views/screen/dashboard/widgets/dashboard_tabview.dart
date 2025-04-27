import 'package:docscanner/viewmodel/dashboard/dashboard_viewmodel.dart';
import 'package:docscanner/views/screen/image_enhance/image_enhance_screen.dart';
import 'package:docscanner/views/screen/recognition/recognition_screen.dart';
import 'package:docscanner/views/screen/scanner/scanner_screen.dart';
import 'package:flutter/material.dart';

class DashboardTabview extends StatefulWidget {
  final DashboardViewmodel controller;
  const DashboardTabview({super.key, required this.controller});

  @override
  State<DashboardTabview> createState() => _DashboardTabviewState();
}

class _DashboardTabviewState extends State<DashboardTabview> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TabBarView(
        controller: widget.controller.tabController,
        children: const <Widget>[
          ScannerScreen(),
          RecognitionScreen(),
          ImageEnhanceScreen(),
        ],
      ),
    );
  }
}
