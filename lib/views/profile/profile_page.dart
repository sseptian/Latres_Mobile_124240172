import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        title: const Text(
          'Profil',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),

              // User Avatar
              Center(
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: const Color(0xFF26262C),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFE50914),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 56,
                    color: Colors.white70,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Username from SharedPreferences
              Obx(
                () => Text(
                  authController.currentUsername.value.isNotEmpty
                      ? authController.currentUsername.value
                      : '124240172',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 4),

              const SizedBox(height: 28),

              // Kesan dan Pesan Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1E),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFF282830)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: const [SizedBox(width: 8)]),
                    const SizedBox(height: 8),
                    Text(
                      'sudah bagus seperti pak bagus',
                      style: TextStyle(
                        color: Colors.grey.shade300,
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14.0),
                      child: Divider(color: Color(0xFF282830), height: 1),
                    ),
                    Row(),
                    const SizedBox(height: 8),
                    Text(
                      'makasih mas umar sama mas zaki semoga di perlancar skripsinya (dengan nada a minor dgn harap saya dapet nilai a 😁)',
                      style: TextStyle(
                        color: Colors.grey.shade300,
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 36),

              // Logout Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _showLogoutDialog(context, authController),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE50914),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  icon: const Icon(Icons.logout_rounded, size: 20),
                  label: const Text(
                    'Logout',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, AuthController authController) {
    Get.defaultDialog(
      title: 'Konfirmasi Logout',
      titleStyle: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      backgroundColor: const Color(0xFF1E1E22),
      middleText: 'Apakah Anda yakin ingin keluar dari akun?',
      middleTextStyle: TextStyle(color: Colors.grey.shade300, fontSize: 14),
      textConfirm: 'Ya, Logout',
      textCancel: 'Batal',
      confirmTextColor: Colors.white,
      cancelTextColor: Colors.grey.shade400,
      buttonColor: const Color(0xFFE50914),
      onConfirm: () {
        Get.back(); // tutup dialog
        authController.logout();
      },
    );
  }
}
