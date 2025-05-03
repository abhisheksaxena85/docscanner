import 'dart:io';

import 'package:docscanner/utils/app_colors.dart';
import 'package:docscanner/viewmodel/scanner/scanner_viewmodel.dart';
import 'package:docscanner/views/widgets/image_view/image_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mlkit_entity_extraction/google_mlkit_entity_extraction.dart';
import 'package:image_picker/image_picker.dart';

class ScannerResultScreen extends StatefulWidget {
  final XFile? file;
  const ScannerResultScreen({super.key, required this.file});

  @override
  State<ScannerResultScreen> createState() => _ScannerResultScreenState();
}

class _ScannerResultScreenState extends State<ScannerResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      appBar: AppBar(
        title: Text(
          'Scan Result',
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
        primary: true,
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildImageContainer(context),
            SizedBox(height: 20.h),
            _buildEntityList(),
          ],
        ),
      ),
    );
  }

  Widget _buildImageContainer(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return GetBuilder<ScannerViewmodel>(builder: (controller) {
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
                          )));
            },
            child: Hero(
              tag: widget.file?.path ?? '',
              child: Image.file(
                File(controller.selectedImage?.path ?? ''),
                fit: BoxFit.fitHeight,
              ),
            ),
          ));
    });
  }

  Widget _buildEntityList() {
    return GetBuilder<ScannerViewmodel>(builder: (controller) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        margin: EdgeInsets.only(bottom: 25.h),
        child: ListView.builder(
          shrinkWrap: true,
          primary: false,
          itemCount: controller.annotations.length,
          itemBuilder: (context, index) {
            return _buildEntityItem(
              controller.annotations[index],
              controller,
            );
          },
        ),
      );
    });
  }

  Widget _buildEntityItem(
      EntityAnnotation entity, ScannerViewmodel controller) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
      padding: EdgeInsets.symmetric(
        vertical: 10.h,
        horizontal: 15.w,
      ),
      decoration: BoxDecoration(
        color: AppColors.whiteBgColor,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.teritiaryBlackColor.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    entity.entities[0].type == EntityType.address
                        ? Icons.location_on_outlined
                        : entity.entities[0].type == EntityType.email
                            ? Icons.email_outlined
                            : entity.entities[0].type == EntityType.phone
                                ? Icons.phone_outlined
                                : entity.entities[0].type == EntityType.url
                                    ? Icons.link
                                    : entity.entities[0].type ==
                                            EntityType.money
                                        ? Icons.monetization_on_outlined
                                        : entity.entities[0].type ==
                                                EntityType.dateTime
                                            ? Icons.calendar_today_outlined
                                            : entity.entities[0].type ==
                                                    EntityType.flightNumber
                                                ? Icons.flight_takeoff_outlined
                                                : entity.entities[0].type ==
                                                        EntityType.paymentCard
                                                    ? Icons.credit_card_outlined
                                                    : Icons
                                                        .text_snippet_outlined,
                    color: AppColors.primaryBlackColor,
                    size: 20.sp,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    entity.entities[0].type == EntityType.address
                        ? 'Address'
                        : entity.entities[0].type == EntityType.email
                            ? 'Email'
                            : entity.entities[0].type == EntityType.phone
                                ? 'Phone'
                                : entity.entities[0].type == EntityType.url
                                    ? 'URL'
                                    : entity.entities[0].type ==
                                            EntityType.money
                                        ? 'Money'
                                        : entity.entities[0].type ==
                                                EntityType.dateTime
                                            ? 'Date Time'
                                            : entity.entities[0].type ==
                                                    EntityType.flightNumber
                                                ? 'Flight Number'
                                                : entity.entities[0].type ==
                                                        EntityType.paymentCard
                                                    ? 'Payment Card'
                                                    : 'Text',
                    textAlign: TextAlign.start,
                    style: GoogleFonts.openSans(
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryBlackColor,
                        fontSize: 16.sp),
                  ),
                ],
              ),
              entity.entities[0].type == EntityType.address ||
                      entity.entities[0].type == EntityType.email ||
                      entity.entities[0].type == EntityType.phone ||
                      entity.entities[0].type == EntityType.url
                  ? InkWell(
                      onTap: () {
                        controller.launchApp(
                            entity.entities[0].type, entity.text);
                      },
                      child: Container(
                        padding: EdgeInsets.all(4.sp),
                        child: Icon(
                          Icons.launch_outlined,
                          color: Colors.blue.shade700,
                          size: 20.sp,
                        ),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
          Divider(
            color: AppColors.teritiaryBlackColor.withOpacity(0.5),
            thickness: 0.6,
          ),
          SizedBox(height: 10.h),
          SelectableText(entity.text,
              textAlign: TextAlign.start,
              toolbarOptions: const ToolbarOptions(
                  copy: true, selectAll: true, cut: false, paste: false),
              style: GoogleFonts.openSans(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.secondaryBlackColor))
        ],
      ),
    );
  }
}
