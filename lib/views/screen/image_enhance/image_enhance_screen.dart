// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:docscanner/utils/app_colors.dart';
import 'package:docscanner/utils/app_images.dart';
import 'package:docscanner/viewmodel/image_enhancement/image_enhancement_viewmodel.dart';
import 'package:docscanner/views/screen/image_enhance/image_enhance_editing_screen.dart';
import 'package:docscanner/views/widgets/image_view/image_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

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
      height: MediaQuery.of(context).size.height,
      color: AppColors.brandBgColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildImageContainer(context),
          _buildSelectButton(),
        ],
      ),
    );
  }

  Widget _buildImageContainer(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return GetBuilder<ImageEnhancementViewmodel>(builder: (controller) {
      return Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 14.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text(
                      '*',
                      style: GoogleFonts.openSans(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.italic,
                          color: AppColors.errorColor),
                    ),
                    SizedBox(
                      width: 2.w,
                    ),
                    Text(
                      'Enhance the selected image\'s color',
                      style: GoogleFonts.openSans(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.italic,
                          color: AppColors.primaryBlackColor.withOpacity(0.7)),
                    ),
                  ],
                ),
                controller.selectedImage == null
                    ? const SizedBox()
                    : InkWell(
                        onTap: () {
                          controller.showDeleteDialog(context);
                        },
                        child: Padding(
                          padding: EdgeInsets.all(3.r),
                          child: Icon(
                            Icons.refresh,
                            color: AppColors.primaryBlackColor,
                            size: 22.sp,
                          ),
                        ),
                      )
              ],
            ),
          ),
          SizedBox(
            height: 8.h,
          ),
          Container(
              width: double.infinity,
              height: height * 0.7,
              margin: EdgeInsets.symmetric(horizontal: 12.w),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.teritiaryBlackColor.withOpacity(0.5),
                  width: 0.6,
                ),
                color: controller.selectedImage == null
                    ? Colors.white
                    : AppColors.primaryBlackColor,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: controller.selectedImage == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(10.r),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(
                              color: AppColors.secondaryBlackColor,
                              width: 1,
                            ),
                          ),
                          child: SvgPicture.asset(
                            AppImages.imagePlaceholderIcon,
                            height: 120.h,
                            width: 120.w,
                            color:
                                AppColors.secondaryBlackColor.withOpacity(0.7),
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          'Select Image for color enhancement!',
                          style: GoogleFonts.openSans(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.secondaryBlackColor),
                        ),
                      ],
                    )
                  : InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ImageView(
                                      image: controller.selectedImage,
                                    )));
                      },
                      onLongPress: () {
                        showAlertDialog();
                      },
                      child: Hero(
                        tag: controller.selectedImage?.path ?? '',
                        child: Image.file(
                          File(controller.selectedImage?.path ?? ''),
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    )),
        ],
      );
    });
  }

  Widget _buildSelectButton() {
    return GetBuilder<ImageEnhancementViewmodel>(builder: (controller) {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 60.h,
        margin: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          color: AppColors.brandColor,
          borderRadius: BorderRadius.all(
            Radius.circular(8.r),
          ),
        ),
        child: controller.selectedImage == null
            ? _buildCaptureSelectButton()
            : _buildEnhanceButton(),
      );
    });
  }

  Widget _buildEnhanceButton() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ImageEnhanceEditingScreen(file: controller.selectedImage)));
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.photo_filter_rounded,
            color: AppColors.whiteBgColor,
            size: 20.sp,
          ),
          SizedBox(
            width: 10.w,
          ),
          Text(
            'Enhance Image',
            style: GoogleFonts.openSans(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.whiteBgColor),
          ),
        ],
      ),
    );
  }

  Widget _buildCaptureSelectButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            controller.captureImage(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.camera_alt_outlined,
                color: AppColors.whiteBgColor,
                size: 20.sp,
              ),
              SizedBox(
                width: 10.w,
              ),
              Text(
                'Capture Image',
                style: GoogleFonts.openSans(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.whiteBgColor),
              ),
            ],
          ),
        ),
        InkWell(
          onTap: () {
            controller.selectImage(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.photo_library_outlined,
                color: AppColors.whiteBgColor,
                size: 20.sp,
              ),
              SizedBox(
                width: 10.w,
              ),
              Text(
                'Select Image',
                style: GoogleFonts.openSans(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.whiteBgColor),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void showAlertDialog() {
    showDialog(
        context: context,
        builder: (_) {
          return CupertinoAlertDialog(
            title: Text(
              'Reset Image',
              style: GoogleFonts.openSans(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryBlackColor),
            ),
            content: Text(
              'Are you sure you want to reset the image?',
              textAlign: TextAlign.start,
              style: GoogleFonts.openSans(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.secondaryBlackColor),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Cancel',
                  style: GoogleFonts.openSans(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.brandColor),
                ),
              ),
              TextButton(
                onPressed: () {
                  controller.selectedImage = null;
                  controller.update();
                  Navigator.pop(context);
                },
                child: Text(
                  'Reset',
                  style: GoogleFonts.openSans(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.brandColor),
                ),
              ),
            ],
          );
        });
  }
}
