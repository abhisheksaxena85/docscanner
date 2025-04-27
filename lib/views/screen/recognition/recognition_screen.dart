import 'package:docscanner/utils/app_colors.dart';
import 'package:flutter/material.dart';

class RecognitionScreen extends StatefulWidget {
  const RecognitionScreen({super.key});

  @override
  State<RecognitionScreen> createState() => _RecognitionScreenState();
}

class _RecognitionScreenState extends State<RecognitionScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.brandBgColor,
    );
  }
}
