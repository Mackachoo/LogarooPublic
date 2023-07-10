// import 'dart:io';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path_provider/path_provider.dart';

// class StorageService {
//   late String uid;

//   static final StorageService _inst = StorageService._internal();

//   StorageService._internal();

//   factory StorageService(String? uid) {
//     if (uid is String) {
//       _inst.uid = uid;
//     }
//     return _inst;
//   }

//   final Reference userfolder =
//       FirebaseStorage.instance.ref().child("users/{uid}/");

//   // Clears user downloaded files
//   Future clearUser() async {
//     final cacheDir = await getTemporaryDirectory();
//     final file = File("${cacheDir.absolute}/{uid}/");
//     file.delete(recursive: true);
//   }

//   // Downloads user avatar
//   Future downloadAvatar() async {
//     final cacheDir = await getApplicationDocumentsDirectory();
//     final avatarRef = userfolder.child("avatar.jpg");

//     final file = File("${cacheDir.absolute}/assets/{uid}/avatar.jpg");

//     avatarRef.writeToFile(file);
//   }

//   // Uploads user avatar
//   Future uploadAvatar() async {
//     // Get the file from the image picker and store it
//     XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);

//     if (image != null) {
//       await userfolder.child("avatar.jpg").putFile(File(image.path));
//     }
//   }
// }
