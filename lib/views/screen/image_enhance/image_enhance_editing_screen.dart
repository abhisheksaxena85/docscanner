// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:docscanner/utils/app_colors.dart';
import 'package:docscanner/viewmodel/image_enhancement/image_enhancement_viewmodel.dart';
import 'package:docscanner/views/widgets/image_view/image_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  void initState() {
    controller.imageEnhanceWhiteningValue.value = 0.01;
    controller.imageEnhanceDarkeningValue.value = 0.01;
    super.initState();
  }

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
              controller.saveImage(context);
            },
          ),
        ],
      ),
      body: Container(
        color: AppColors.whiteBgColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildImageContainer(context),
            SizedBox(height: 20.h),
            _buildImageEnhanceButton(controller),
          ],
        ),
      ),
    );
  }

  Widget _buildImageContainer(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return GetBuilder<ImageEnhancementViewmodel>(builder: (controller) {
      return Container(
          width: double.infinity,
          height: height * 0.6,
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
                            brightness:
                                controller.imageEnhanceWhiteningValue.value,
                            contrast:
                                controller.imageEnhanceDarkeningValue.value,
                          )));
            },
            child: Hero(
              tag: controller.selectedImage?.path ?? '',
              child: RepaintBoundary(
                key: controller.globalKey,
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    AppColors.primaryBlackColor.withOpacity(
                        controller.imageEnhanceDarkeningValue.value),
                    BlendMode.overlay,
                  ),
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      AppColors.whiteBgColor.withOpacity(
                          controller.imageEnhanceWhiteningValue.value),
                      BlendMode.overlay,
                    ),
                    child: Image.file(
                      File(controller.selectedImage?.path ?? ''),
                    ),
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
      margin: EdgeInsets.symmetric(horizontal: 7.w),
      decoration: BoxDecoration(
        color: AppColors.whiteBgColor,
        borderRadius: BorderRadius.all(
          Radius.circular(6.r),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 15.w),
            child: Text(
              "Brightness",
              style: GoogleFonts.roboto(
                color: AppColors.brandColor,
                fontSize: 17.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Obx(() {
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 15.w,
                ),
                Icon(
                  Icons.brightness_high,
                  color: AppColors.brandColor,
                  size: 25.sp,
                ),
                Expanded(
                  child: Slider(
                    activeColor: AppColors.brandColor,
                    inactiveColor: AppColors.brandBgColor,
                    value: controller.imageEnhanceWhiteningValue.value,
                    min: 0,
                    max: 1,
                    divisions: 100,
                    onChanged: (value) {
                      if (value == 0) {
                        return;
                      }
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
                  Icons.contrast,
                  color: AppColors.secondaryBlackColor,
                  size: 25.sp,
                ),
                Expanded(
                  child: Slider(
                    activeColor: AppColors.secondaryBlackColor,
                    inactiveColor:
                        AppColors.secondaryBlackColor.withOpacity(0.3),
                    value: controller.imageEnhanceDarkeningValue.value,
                    min: 0,
                    max: 1,
                    divisions: 100,
                    onChanged: (value) {
                      if (value == 0) {
                        return;
                      }
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
