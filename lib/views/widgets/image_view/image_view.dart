import 'dart:io';

import 'package:docscanner/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class ImageView extends StatefulWidget {
  final XFile? image;
  final double? brightness;
  final double? contrast;
  const ImageView(
      {super.key, required this.image, this.brightness, this.contrast});

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_outlined,
            size: 28.sp,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Hero(
        tag: widget.image!.path,
        child: Container(
          alignment: Alignment.center,
          color: Colors.black,
          child: InteractiveViewer(
            boundaryMargin: EdgeInsets.all(5.r),
            alignment: Alignment.center,
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                AppColors.primaryBlackColor.withOpacity(widget.contrast ?? 0.0),
                BlendMode.overlay,
              ),
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  AppColors.whiteBgColor.withOpacity(widget.brightness ?? 0.0),
                  BlendMode.overlay,
                ),
                child: Image.file(
                  File(widget.image!.path),
                  fit: BoxFit.contain,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
          ),
        ),
      ),
    ));
  }
}
