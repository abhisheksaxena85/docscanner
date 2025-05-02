import 'dart:io';

import 'package:docscanner/utils/app_colors.dart';
import 'package:docscanner/viewmodel/recognition/recognition_viewmodel.dart';
import 'package:docscanner/views/widgets/image_view/image_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class RecognitionResultScreen extends StatefulWidget {
  final XFile? file;
  const RecognitionResultScreen({super.key, required this.file});

  @override
  State<RecognitionResultScreen> createState() =>
      _RecognitionResultScreenState();
}

class _RecognitionResultScreenState extends State<RecognitionResultScreen> {
  final RecognitionViewmodel controller = Get.put(RecognitionViewmodel());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,
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
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildImageContainer(context),
            SizedBox(height: 20.h),
            _buildSelectableTextArea(context, controller),
          ],
        ),
      ),
    );
  }

  Widget _buildImageContainer(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return GetBuilder<RecognitionViewmodel>(builder: (controller) {
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
            child: Image.file(
              File(controller.selectedImage?.path ?? ''),
              fit: BoxFit.fitHeight,
            ),
          ));
    });
  }

  Widget _buildSelectableTextArea(
      BuildContext context, RecognitionViewmodel controller) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.whiteBgColor,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.teritiaryBlackColor.withOpacity(0.2),
              blurRadius: 5,
              spreadRadius: 1,
              offset: const Offset(0, 3),
            ),
          ]),
      padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
      margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header row of selectable text area
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Scanned Text',
                textAlign: TextAlign.start,
                style: GoogleFonts.openSans(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryBlackColor,
                    fontSize: 18.sp),
              ),
              Obx(() {
                return InkWell(
                  onTap: () {
                    controller.copyTextToClipboard(context);
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 3.h, horizontal: 5.w),
                    child: Row(
                      children: [
                        Icon(
                          controller.isCopied.value == true
                              ? Icons.check
                              : Icons.copy_rounded,
                          color: AppColors.primaryBlackColor,
                          size: 16.sp,
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          controller.isCopied.value == true ? 'Copied' : 'Copy',
                          style: GoogleFonts.openSans(
                              fontWeight: FontWeight.w400,
                              color: AppColors.primaryBlackColor,
                              fontSize: 12.sp),
                        ),
                      ],
                    ),
                  ),
                );
              })
            ],
          ),
          Divider(
            color: AppColors.teritiaryBlackColor.withOpacity(0.5),
            thickness: 0.6,
          ),

          SizedBox(height: 10.h),

          /// Selectable Text Area
          controller.scannedText.value.isEmpty
              ? Center(
                  child: Text(
                    'No text found',
                    style: GoogleFonts.openSans(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.secondaryBlackColor),
                  ),
                )
              : SelectableText(controller.scannedText.value,
                  textAlign: TextAlign.start,
                  toolbarOptions: const ToolbarOptions(
                      copy: true, selectAll: true, cut: false, paste: false),
                  style: GoogleFonts.openSans(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.secondaryBlackColor)),
        ],
      ),
    );
  }
}
