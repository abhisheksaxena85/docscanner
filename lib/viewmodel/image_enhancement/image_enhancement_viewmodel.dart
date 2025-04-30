import 'dart:developer';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:docscanner/utils/app_colors.dart';
import 'package:docscanner/views/widgets/custom_snackbar/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:typed_data';
import 'package:saver_gallery/saver_gallery.dart';

class ImageEnhancementViewmodel extends GetxController {
  XFile? selectedImage;
  final ImagePicker imagePicker = ImagePicker();
  var imageEnhanceWhiteningValue = 0.0.obs;
  var imageEnhanceDarkeningValue = 0.0.obs;
  var isImageSaving = false.obs;

  Future<void> selectImage() async {
    selectedImage = await imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    update();
  }

  Future<void> captureImage() async {
    selectedImage = await imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );
    update();
  }

  GlobalKey globalKey = GlobalKey();

  Future<void> saveImage(BuildContext context) async {
    isImageSaving.value = true;
    showLoadingIndicator(context);
    try {
      var status = await Permission.storage.request();
      if (!status.isGranted) return;

      RenderRepaintBoundary boundary =
          globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(
          pixelRatio: 3.0); // Higher pixelRatio = better quality
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final fileName =
          'Enhanced Image ${DateTime.now().millisecondsSinceEpoch}.png';
      const androidRelativePath = "Pictures/DocScanner";
      final filePath = Platform.isAndroid
          ? "/storage/emulated/0/$androidRelativePath/$fileName"
          : "/path/to/ios/directory/$fileName";

      final result = await SaverGallery.saveImage(
        pngBytes,
        quality: 60,
        fileName: fileName,
        androidRelativePath: androidRelativePath,
        skipIfExists: false,
      );

      if (result.isSuccess == true) {
        final snackbar = successSnackBar("Image saved to gallery successfully");
        log('Image saved to gallery successfully');
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      } else {
        final snackbar = failedSnackBar("Failed to save image");
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
        log('Failed to save image: ${result.errorMessage}');
      }
      log('Image saved at: ${filePath}');
    } catch (e) {
      log('Error saving image: $e');
      final snackbar = failedSnackBar("Failed to save image");
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    } finally {
      Navigator.of(context).pop();
      isImageSaving.value = false;
      update();
    }
  }

  void showLoadingIndicator(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Container(
            alignment: Alignment.center,
            child: Container(
              height: 100.h,
              margin: EdgeInsets.symmetric(horizontal: 50.w),
              padding: EdgeInsets.only(left: 25.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    color: AppColors.errorColor,
                  ),
                  SizedBox(width: 20.w),
                  Text(
                    'Loading...',
                    style: GoogleFonts.openSans(
                      fontSize: 16.sp,
                      color: AppColors.teritiaryBlackColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
