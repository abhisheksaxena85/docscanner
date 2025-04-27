import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ImageEnhancementViewmodel extends GetxController {
  XFile? selectedImage;
  final ImagePicker imagePicker = ImagePicker();

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
}
