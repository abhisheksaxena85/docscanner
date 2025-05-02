import 'dart:io';

import 'package:docscanner/utils/app_colors.dart';
import 'package:docscanner/viewmodel/recognition/recognition_viewmodel.dart';
import 'package:docscanner/views/widgets/image_view/image_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/app_images.dart';

class RecognitionScreen extends StatefulWidget {
  const RecognitionScreen({super.key});

  @override
  State<RecognitionScreen> createState() => _RecognitionScreenState();
}

class _RecognitionScreenState extends State<RecognitionScreen> {
  final RecognitionViewmodel controller = Get.put(RecognitionViewmodel());
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
    return GetBuilder<RecognitionViewmodel>(builder: (controller) {
      return Container(
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
                ? Colors.transparent
                : AppColors.primaryBlackColor,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: controller.selectedImage == null
              ? Container(
                  padding: EdgeInsets.all(20.r),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(26.r),
                    border: Border.all(
                      color: AppColors.brandColor,
                      width: 1,
                    ),
                  ),
                  child: SvgPicture.asset(
                    AppImages.imagePlaceholderIcon,
                    height: 120.h,
                    width: 120.w,
                    color: AppColors.brandColor.withOpacity(1),
                  ),
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
                    controller.showDeleteDialog(context);
                  },
                  child: Hero(
                    tag: controller.selectedImage!.path,
                    child: Image.file(
                      File(controller.selectedImage?.path ?? ''),
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ));
    });
  }

  Widget _buildSelectButton() {
    return GetBuilder<RecognitionViewmodel>(builder: (controller) {
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
            ? _buildCaptureSelectButton(controller)
            : _buildScanImageButton(controller),
      );
    });
  }

  Widget _buildScanImageButton(RecognitionViewmodel controller) {
    return InkWell(
      onTap: () async {
        await controller.scanImage(context);
      },
      child: Obx(() {
        return controller.isScanning.value == true
            ? Container(
                alignment: Alignment.center,
                child: Container(
                    width: 30.w,
                    height: 30.h,
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(
                      color: AppColors.whiteBgColor,
                      strokeCap: StrokeCap.round,
                      strokeWidth: 3.5,
                    )),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20.w,
                    height: 20.h,
                    child: SvgPicture.asset(
                      AppImages.scanIconSvg,
                      color: AppColors.whiteBgColor,
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Text(
                    'Scan Text',
                    style: GoogleFonts.openSans(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.whiteBgColor),
                  ),
                ],
              );
      }),
    );
  }

  Widget _buildCaptureSelectButton(RecognitionViewmodel controller) {
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
}
