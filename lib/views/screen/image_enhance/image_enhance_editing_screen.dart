import 'dart:io';

import 'package:docscanner/utils/app_colors.dart';
import 'package:docscanner/viewmodel/image_enhancement/image_enhancement_viewmodel.dart';
import 'package:docscanner/views/widgets/image_view/image_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class ImageEnhanceEditingScreen extends StatefulWidget {
  final XFile? file;
  const ImageEnhanceEditingScreen({super.key, required this.file});

  @override
  State<ImageEnhanceEditingScreen> createState() =>
      _ImageEnhanceEditingScreenState();
}

class _ImageEnhanceEditingScreenState extends State<ImageEnhanceEditingScreen> {
  final ImageEnhancementViewmodel controller =
      Get.put(ImageEnhancementViewmodel());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Image Enhance Editing',
          style: GoogleFonts.openSans(
              color: AppColors.whiteBgColor, fontSize: 18.sp),
        ),
        leadingWidth: 55.w,
        leading: IconButton(
          tooltip: "Navigation",
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.whiteBgColor,
            size: 23.sp,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            tooltip: "Save File",
            icon: Icon(
              Icons.save_sharp,
              color: AppColors.whiteBgColor,
              size: 26.sp,
            ),
            onPressed: () {
              // Save action
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildImageContainer(context),
          SizedBox(height: 20.h),
          _buildImageEnhanceButton(controller),
        ],
      ),
    );
  }

  Widget _buildImageContainer(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return GetBuilder<ImageEnhancementViewmodel>(builder: (controller) {
      return Container(
          width: double.infinity,
          height: height * 0.65,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.teritiaryBlackColor.withOpacity(0.5),
              width: 0.6,
            ),
            color: AppColors.primaryBlackColor,
          ),
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ImageView(
                            image: controller.selectedImage,
                          )));
            },
            child: Hero(
              tag: controller.selectedImage!.path,
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  AppColors.primaryBlackColor
                      .withOpacity(controller.imageEnhanceDarkeningValue.value),
                  BlendMode.colorBurn,
                ),
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    AppColors.whiteBgColor.withOpacity(
                        controller.imageEnhanceWhiteningValue.value),
                    BlendMode.overlay,
                  ),
                  child: Image.file(
                    File(controller.selectedImage?.path ?? ''),
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
            ),
          ));
    });
  }

  Widget _buildImageEnhanceButton(ImageEnhancementViewmodel controller) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.w),
      margin: EdgeInsets.symmetric(horizontal: 5.w),
      decoration: BoxDecoration(
        color: AppColors.brandColor,
        borderRadius: BorderRadius.all(
          Radius.circular(2.r),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Obx(() {
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 15.w,
                ),
                Icon(
                  Icons.brightness_6_outlined,
                  color: AppColors.whiteBgColor,
                  size: 25.sp,
                ),
                Expanded(
                  child: Slider(
                    activeColor: AppColors.whiteBgColor,
                    inactiveColor: AppColors.teritiaryBlackColor,
                    value: controller.imageEnhanceWhiteningValue.value,
                    min: 0,
                    max: 1,
                    divisions: 100,
                    onChanged: (value) {
                      controller.imageEnhanceWhiteningValue.value = value;
                      controller.update();
                    },
                  ),
                ),
              ],
            );
          }),
          Obx(() {
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 15.w,
                ),
                Icon(
                  Icons.brightness_4_outlined,
                  color: AppColors.whiteBgColor,
                  size: 25.sp,
                ),
                Expanded(
                  child: Slider(
                    activeColor: AppColors.whiteBgColor,
                    inactiveColor: AppColors.teritiaryBlackColor,
                    value: controller.imageEnhanceDarkeningValue.value,
                    min: 0,
                    max: 1,
                    divisions: 100,
                    onChanged: (value) {
                      controller.imageEnhanceDarkeningValue.value = value;
                      controller.update();
                    },
                  ),
                ),
              ],
            );
          })
        ],
      ),
    );
  }
}
