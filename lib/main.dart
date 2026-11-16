import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/auth_controller.dart';
import 'controllers/favorite_controller.dart';
import 'controllers/show_controller.dart';
import 'services/hive_service.dart';
import 'views/auth/login_page.dart';
import 'views/main_navigation_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Hive Local Storage
  await HiveService.init();

  // Inisialisasi GetX Controllers
  final authController = Get.put(AuthController());
  Get.put(FavoriteController());
  Get.put(ShowController());

  // Pastikan status login ter-update sebelum UI ditampilkan
  await authController.checkLoginStatus();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return GetMaterialApp(
      title: 'NontonSkuy! - Latres Mobile 124240172',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: const Color(0xFFE50914),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFE50914),
          secondary: Color(0xFFEF4444),
          surface: Color(0xFF1E1E22),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF121212),
          elevation: 0,
          centerTitle: false,
        ),
        useMaterial3: true,
      ),
      home: Obx(() {
        return authController.isLoggedIn.value
            ? const MainNavigationPage()
            : const LoginPage();
      }),
    );
  }
}
