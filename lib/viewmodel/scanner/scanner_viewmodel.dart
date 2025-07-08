// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:docscanner/utils/app_colors.dart';
import 'package:docscanner/views/screen/scanner/scanner_result_screen.dart';
import 'package:docscanner/views/widgets/crop_image_screen.dart';
import 'package:docscanner/views/widgets/custom_snackbar/custom_snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mlkit_barcode_scanning/src/barcode_scanner.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_entity_extraction/google_mlkit_entity_extraction.dart';
import 'package:url_launcher/url_launcher.dart';

class ScannerViewmodel extends GetxController {
  XFile? selectedImage;
  final ImagePicker imagePicker = ImagePicker();
  var isScanning = false.obs;
  var isCopied = false.obs;
  RxString qrScanResult = ''.obs;
  List<EntityAnnotation> annotations = [];

  void selectImage(BuildContext context) async {
    selectedImage = await imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
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

  void captureImage(BuildContext context) async {
    selectedImage = await imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 100,
    );
    if (selectedImage == null) {
      return;
    }
    final cropped = await ImageCropper().cropImage(
      sourcePath: selectedImage?.path ?? '',
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

  Future<void> scan(BuildContext context) async {
    isScanning.value = true;
    try {
      if (selectedImage == null) {
        return;
      }
      final inputImage = InputImage.fromFilePath(selectedImage?.path ?? '');
      final textRecognizer =
          TextRecognizer(script: TextRecognitionScript.latin);
      final recognizedText = await textRecognizer.processImage(inputImage);
      await textRecognizer.close();

      final rawText = recognizedText.text;

      final extractor = EntityExtractor(
        language: EntityExtractorLanguage.english,
      );

      final modelManager = EntityExtractorModelManager();
      await modelManager.downloadModel(EntityExtractorLanguage.english.name);

      annotations = await extractor.annotateText(rawText);

      if (annotations.isNotEmpty) {
        var snackbar = successSnackBar(
            "Successfully extracted ${annotations.length} entities from the image.");
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ScannerResultScreen(file: selectedImage)));
      } else {
        qrScanResult.value = await qrScan(File(selectedImage?.path ?? '').path);
        if (qrScanResult.value != '') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ScannerResultScreen(
                        file: selectedImage,
                      )));
        } else {
          var snackbar = failedSnackBar(
              "Not able to extract any entities from the image.");
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
        }
      }

      await extractor.close();
    } catch (e) {
      log("Error : $e");
      isScanning.value = false;
    } finally {
      isScanning.value = false;
    }
  }

  Future<String> qrScan(String path) async {
    try {
      final inputImage = InputImage.fromFilePath(path);

      final scanner = BarcodeScanner(formats: [BarcodeFormat.qrCode]);

      // 3. Process the image
      final List<Barcode> barcodes = await scanner.processImage(inputImage);
      await scanner.close();
      // 4. Extract the first QR value (if any)
      String result = barcodes.isNotEmpty
          ? barcodes.first.rawValue ?? 'No data'
          : 'No QR code found';
      return result;
    } catch (e) {
      log("Error while scanning QR code: $e");
      return '';
    }
  }

  Future<void> launchApp(EntityType type, String text) async {
    if (type == EntityType.phone) {
      await dialPhoneNumber(text);
    } else if (type == EntityType.email) {
      await launchEmail(text, "Subject", "Message...");
    } else if (type == EntityType.url) {
      await launchUrlLink(text);
    } else if (type == EntityType.address) {
      await openMapOldApi(text);
    } else {
      log("Unsupported entity type");
    }
  }

  Future<void> dialPhoneNumber(String phoneNumber) async {
    try {
      final Uri telUri = Uri(scheme: 'tel', path: phoneNumber);
      if (!await canLaunchUrl(telUri)) {
        throw 'Could not dial $phoneNumber';
      }
      await launchUrl(telUri);
    } catch (e) {
      log("Error while dialing phone $e");
    }
  }

  Future<void> launchEmail(
      String toEmail, String? subject, String? body) async {
    try {
      final Uri emailUri = Uri(
        scheme: 'mailto',
        path: toEmail,
        query: <String, String>{
          if (subject != null) 'subject': subject,
          if (body != null) 'body': body,
        }
            .entries
            .map((e) =>
                '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
            .join('&'),
      );
      if (!await canLaunchUrl(emailUri)) {
        throw 'Could not launch email to $toEmail';
      }
      await launchUrl(emailUri);
    } catch (e) {
      log("Error while launching email $e");
    }
  }

  Future<void> launchUrlLink(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.inAppBrowserView,
        );
      }
    } catch (e) {
      log("Error while launching url $e");
    }
  }

  Future<void> openMapOldApi(String address) async {
    try {
      final encoded = Uri.encodeComponent(address);
      final url = 'https://www.google.com/maps/search/?api=1&query=$encoded';

      if (!await canLaunch(url)) {
        throw 'Could not open the map for $address';
      }
      await launch(url);
    } catch (e) {
      log("Error while opening map $e");
    }
  }

  void copyTextToClipboard(BuildContext context) {
    if (qrScanResult.value != '') {
      Clipboard.setData(ClipboardData(text: qrScanResult.value));
      var snackbar = successSnackBar("Copied to clipboard");
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
      isCopied.value = true;
      Future.delayed(const Duration(seconds: 5), () {
        isCopied.value = false;
      });
    }
  }
}
