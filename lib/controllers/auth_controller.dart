import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok_clone/constants.dart';
import 'package:tiktok_clone/models/user.dart' as model;
import 'package:tiktok_clone/views/screens/auth/login_screen.dart';
import 'package:tiktok_clone/views/screens/home_screen.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  late Rx<User?> _user;
  late Rx<File?> _pickedImage;

  File? get profilePhoto => _pickedImage.value;

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(firebaseAuth.currentUser);
    _user.bindStream(firebaseAuth.authStateChanges());
    ever(_user, _setInitialScreen);
  }

  // register the user
  Future<void> registerUser(
      String username, String email, String password, File? image) async {
    try {
      if (username.isNotEmpty &&
          email.isNotEmpty &&
          password.isNotEmpty &&
          image != null) {
        UserCredential userCredential = await firebaseAuth
            .createUserWithEmailAndPassword(email: email, password: password);
        String downloadUrl = await _uploadToStorage(image);
        model.User user = model.User(
          name: username,
          profilePhoto: downloadUrl,
          uid: userCredential.user!.uid,
          email: email,
        );
        await firebaseFirestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(user.toJson());
      } else {
        String title = 'Error creating account';
        String message = 'Please enter all the fields';
        Get.snackbar(title, message);
      }
    } catch (e) {
      String title = "Error creating an user";
      String message = e.toString();
      Get.snackbar(title, message);
    }
  }

  Future<String> _uploadToStorage(File image) async {
    Reference reference = firebaseStorage
        .ref()
        .child('profilePics')
        .child(firebaseAuth.currentUser!.uid);
    UploadTask uploadTask = reference.putFile(image);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  void pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      Get.snackbar('Profile picture', 'Picked successfully');
    }
    _pickedImage = Rx<File?>(File(pickedImage!.path));
  }

  void loginUser(String email, String password) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
        print('login successfully');
      } else {
        String title = 'Error logging in account';
        String message = 'Please enter all the fields';
        Get.snackbar(title, message);
      }
    } catch (e) {
      Get.snackbar('Error logging in', 'Cannot login');
    }
  }

  _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => LoginScreen());
    } else {
      Get.offAll(() => const HomeScreen());
    }
  }
}
