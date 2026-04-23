// import 'package:get/get.dart';
// import 'package:flutter/material.dart';
// // import 'package:google_sign_in/google_sign_in.dart'as google_auth;
// import 'package:musafer/routes/app_routes/app_routes.dart';
//
// class LoginController extends GetxController {
//
//   late TextEditingController emailController;
//   late TextEditingController passwordController;
//   var isPasswordHidden = true.obs;
//   var rememberMe = false.obs;
//   var isLoading = false.obs;
//   var isLogin = true.obs;
//   // final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);
//
//   @override
//   void onInit() {
//     emailController = TextEditingController();
//     passwordController = TextEditingController();
//     super.onInit();
//   }
//
//   @override
//   void onClose() {
//     emailController.dispose();
//     passwordController.dispose();
//     super.onClose();
//   }
//   void togglePasswordVisibility() {
//     isPasswordHidden.value = !isPasswordHidden.value;
//   }
//   void toggleRememberMe(bool? value) {
//     rememberMe.value = value ?? false;
//   }
//   void toggleAuthMode() {
//     isLogin.value = !isLogin.value;
//   }
//
//   void login() async {
//     isLoading.value = true;
//     // محاكاة الاتصال بالـ API
//     await Future.delayed(const Duration(seconds: 2));
//     print("Email: ${emailController.text}");
//     isLoading.value = false;
//     Get.offAllNamed(AppRoute.main_layout, arguments: 2);
//   }
//
//   void signInWithGoogle() async {
//     // try {
//     //   isLoading.value = true;
//     //   // استخدام الـ Alias هنا لنوع البيانات والدالة
//     //   final google_auth.GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//     //
//     //   if (googleUser != null) {
//     //     final google_auth.GoogleSignInAuthentication googleAuth = await googleUser.authentication;
//     //
//     //     print("User: ${googleUser.displayName}");
//     //     // print("Token: ${googleAuth.accessToken}");
//     //
//     //     Get.offAllNamed(AppRoute.main_layout);
//     //   }
//     // } catch (error) {
//     //   Get.snackbar("خطأ", "فشل تسجيل الدخول عبر جوجل");
//     //   print("Google Auth Error: $error");
//     // } finally {
//     //   isLoading.value = false;
//     // }
//   }
// }



import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../../routes/app_routes/app_routes.dart';

class LoginController extends GetxController {
  late TextEditingController usernameController; // تم تغيير الاسم ليكون عاماً (إيميل أو رقم)
  late TextEditingController passwordController;

  var isPasswordHidden = true.obs;
  var rememberMe = false.obs;
  var isLoading = false.obs;
  var isLogin = true.obs;

  final GetStorage _box = GetStorage();

  late GoogleSignIn _googleSignIn;

  @override
  void onInit() {
    usernameController = TextEditingController();
    passwordController = TextEditingController();

    rememberMe.value = _box.read('remember_me') ?? false;
    if (rememberMe.value) {
      usernameController.text = _box.read('saved_username') ?? "";
      passwordController.text = _box.read('saved_password') ?? "";
    }
    super.onInit();
  }

  void togglePasswordVisibility() => isPasswordHidden.value = !isPasswordHidden.value;

  void toggleRememberMe(bool? value) {
    rememberMe.value = value ?? false;
    _box.write('remember_me', rememberMe.value);
  }

  void login() async {
    String input = usernameController.text.trim();

    if (input.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar("تنبيه", "يرجى إدخال البيانات المطلوبة");
      return;
    }

    isLoading.value = true;

    // التحقق هل المدخل إيميل أم رقم هاتف (منطق بسيط للباك إيند)
    bool isEmail = GetUtils.isEmail(input);
    bool isPhone = GetUtils.isPhoneNumber(input);

    if (!isEmail && !isPhone) {
      isLoading.value = false;
      Get.snackbar("خطأ", "يرجى إدخال إيميل صحيح أو رقم هاتف صحيح");
      return;
    }

    print("Sending to API: User: $input, Type: ${isEmail ? 'Email' : 'Phone'}");

    await Future.delayed(const Duration(seconds: 2));

    if (rememberMe.value) {
      _box.write('saved_username', input);
      _box.write('saved_password', passwordController.text);
    } else {
      _box.remove('saved_username');
      _box.remove('saved_password');
    }

    isLoading.value = false;
    Get.offAllNamed(AppRoute.main_layout, arguments: 2);
  }

  // void signInWithGoogle() async {
  //   try {
  //     isLoading.value = true;
  //     // التأكد من استدعاء الدالة
  //     final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
  //     if (googleUser != null) {
  //       print("Success: ${googleUser.email}");
  //       Get.offAllNamed(AppRoute.main_layout);
  //     }
  //   } catch (error) {
  //     print("Google Auth Error: $error");
  //     Get.snackbar("خطأ", "فشل تسجيل الدخول عبر جوجل");
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }
  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}