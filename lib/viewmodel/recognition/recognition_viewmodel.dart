import 'dart:io';

import 'package:docscanner/utils/app_colors.dart';
import 'package:docscanner/views/screen/recognition/recognition_result_screen.dart';
import 'package:docscanner/views/widgets/crop_image_screen.dart';
import 'package:docscanner/views/widgets/custom_snackbar/custom_snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class RecognitionViewmodel extends GetxController {
  XFile? selectedImage;
  var textRecognizer = TextRecognizer();
  var isScanning = false.obs;
  RxString scannedText = ''.obs;
  final imagePicker = ImagePicker();
  var isCopied = false.obs;

  Future<void> scanImage(BuildContext context) async {
    isScanning.value = true;
    try {
      final file = File(selectedImage!.path);

      final inputImage = InputImage.fromFile(file);
      final recognizedText = await textRecognizer.processImage(inputImage);
      scannedText.value = recognizedText.text;
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  RecognitionResultScreen(file: selectedImage)));
    } catch (e) {
      var snackbar = failedSnackBar("Failed to scan image");
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    } finally {
      isScanning.value = false;
      update();
    }
  }

  void showDeleteDialog(BuildContext context) {
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
                  selectedImage = null;
                  update();
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

  Future<void> selectImage(BuildContext context) async {
    selectedImage = await imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    if (selectedImage == null) {
      return;
    }
    final cropped = await ImageCropper().cropImage(
      sourcePath: selectedImage!.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop',
          toolbarColor: AppColors.brandColor,
          toolbarWidgetColor: Colors.white,
          statusBarColor: AppColors.brandColor,
          activeControlsWidgetColor: AppColors.brandColor,
          lockAspectRatio: false,
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPresetCustom(),
          ],
        ),
        IOSUiSettings(
          title: 'Cropper',
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPresetCustom(),
          ],
        ),
        WebUiSettings(
          context: context,
          presentStyle: WebPresentStyle.dialog,
          size: const CropperSize(
            width: 520,
            height: 520,
          ),
        ),
      ],
    );
    if (cropped != null) {
      selectedImage = XFile(cropped.path);
    }
    update();
  }

  Future<void> captureImage(BuildContext context) async {
    selectedImage = await imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );
    if (selectedImage == null) {
      return;
    }
    final cropped = await ImageCropper().cropImage(
      sourcePath: selectedImage!.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
      uiSettings: [
        AndroidUiSettings(
          cropStyle: CropStyle.rectangle,
          toolbarTitle: 'Crop',
          toolbarColor: AppColors.brandColor,
          toolbarWidgetColor: Colors.white,
          statusBarColor: AppColors.brandColor,
          activeControlsWidgetColor: AppColors.brandColor,
          lockAspectRatio: false,
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPresetCustom(),
          ],
        ),
        IOSUiSettings(
          title: 'Cropper',
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPresetCustom(),
          ],
        ),
        WebUiSettings(
          context: context,
          presentStyle: WebPresentStyle.dialog,
          size: const CropperSize(
            width: 520,
            height: 520,
          ),
        ),
      ],
    );
    if (cropped != null) {
      selectedImage = XFile(cropped.path);
    }
    update();
  }

  void copyTextToClipboard(BuildContext context) {
    if (scannedText.value.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: scannedText.value));
      var snackbar = successSnackBar("Copied to clipboard");
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
      isCopied.value = true;
      Future.delayed(const Duration(seconds: 5), () {
        isCopied.value = false;
      });
    }
  }
}
