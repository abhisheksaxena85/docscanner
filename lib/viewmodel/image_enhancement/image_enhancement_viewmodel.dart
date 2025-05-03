import 'dart:developer';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:docscanner/utils/app_colors.dart';
import 'package:docscanner/views/widgets/crop_image_screen.dart';
import 'package:docscanner/views/widgets/custom_snackbar/custom_snackbar.dart';
import 'package:docscanner/views/widgets/show_loading_indicator_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
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

  Future<void> selectImage(BuildContext context) async {
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

  Future<void> captureImage(BuildContext context) async {
    selectedImage = await imagePicker.pickImage(
      source: ImageSource.camera,
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
}
