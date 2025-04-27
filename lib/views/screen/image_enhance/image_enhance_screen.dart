// ignore_for_file: deprecated_member_use

import 'package:docscanner/utils/app_colors.dart';
import 'package:docscanner/utils/app_images.dart';
import 'package:docscanner/viewmodel/image_enhancement/image_enhancement_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ImageEnhanceScreen extends StatefulWidget {
  const ImageEnhanceScreen({super.key});

  @override
  State<ImageEnhanceScreen> createState() => _ImageEnhanceScreenState();
}

class _ImageEnhanceScreenState extends State<ImageEnhanceScreen> {
  final ImageEnhancementViewmodel controller =
      Get.put(ImageEnhancementViewmodel());
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.brandBgColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImageContainer(context),
          SizedBox(
            height: 10.h,
          ),
          _buildSelectButton(),
        ],
      ),
    );
  }

  Widget _buildImageContainer(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Container(
        width: double.infinity,
        height: height * 0.7.h,
        margin: EdgeInsets.symmetric(horizontal: 12.w),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.teritiaryBlackColor.withOpacity(0.5),
            width: 0.6,
          ),
          color: AppColors.lavendarBlueColor.withOpacity(0.3),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Container(
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26.r),
            border: Border.all(
              color: AppColors.whiteBgColor,
              width: 1,
            ),
          ),
          child: SvgPicture.asset(
            AppImages.imagePlaceholderIcon,
            height: 120.h,
            width: 120.w,
            color: AppColors.brandColor.withOpacity(1),
          ),
        ));
  }

  Widget _buildSelectButton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 60.h,
      margin: EdgeInsets.symmetric(horizontal: 5.w),
      decoration: BoxDecoration(
        color: AppColors.brandColor,
        borderRadius: BorderRadius.all(
          Radius.circular(8.r),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton(
            onPressed: () {},
            child: Text('Select Image'),
          ),
        ],
      ),
    );
  }
}
