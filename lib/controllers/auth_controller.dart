import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../views/auth/login_page.dart';
import '../views/main_navigation_page.dart';

class AuthController extends GetxController {
  // Kredensial sesuai kriteria tugas:
  // Username: NIM (124240172)
  // Password: 123
  static const String validUsername = '124240172';
  static const String validPassword = '123';

  final RxBool isLoggedIn = false.obs;
  final RxString currentUsername = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool isPasswordVisible = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  /// Cek session login dari SharedPreferences
  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final bool loggedIn = prefs.getBool('isLoggedIn') ?? false;
    final String? username = prefs.getString('username');

    if (loggedIn && username != null && username.isNotEmpty) {
      isLoggedIn.value = true;
      currentUsername.value = username;
    } else {
      isLoggedIn.value = false;
      currentUsername.value = '';
    }
  }

  /// Fungsi Login
  Future<bool> login(String username, String password) async {
    isLoading.value = true;

    // Simulasi delay singkat agar UX loading terasa halus
    await Future.delayed(const Duration(milliseconds: 500));

    final trimmedUser = username.trim();
    final trimmedPass = password.trim();

    if (trimmedUser.isEmpty || trimmedPass.isEmpty) {
      isLoading.value = false;
      Get.snackbar(
        'Peringatan',
        'Username dan Password wajib diisi!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.amber.shade800,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      );
      return false;
    }

    if (trimmedUser == validUsername && trimmedPass == validPassword) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('username', trimmedUser);

      isLoggedIn.value = true;
      currentUsername.value = trimmedUser;
      isLoading.value = false;

      Get.snackbar(
        'Berhasil',
        'Selamat datang kembali, $trimmedUser!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFF10B981),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      );

      Get.offAll(() => const MainNavigationPage());
      return true;
    } else {
      isLoading.value = false;
      Get.snackbar(
        'Login Gagal',
        'Username harus NIM ($validUsername) & Password harus $validPassword',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFE50914),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      );
      return false;
    }
  }

  /// Fungsi Logout (Menghapus session SharedPreferences & kembali ke Login)
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('username');

    isLoggedIn.value = false;
    currentUsername.value = '';

    Get.snackbar(
      'Logout Berhasil',
      'Session login telah dihapus.',
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFF374151),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    );

    Get.offAll(() => const LoginPage());
  }
}
