import 'package:image_picker/image_picker.dart';

Future<String> chooseImage() async {
  XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
  if (image != null) return image.path;
  return '';
}
