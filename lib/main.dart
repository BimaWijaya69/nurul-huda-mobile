import 'package:flutter/material.dart';
import 'package:nurul_huda_mobile/core/routes/app_routes.dart';
import 'package:nurul_huda_mobile/core/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:nurul_huda_mobile/views/auth/auth_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await initializeDateFormatting('id_ID', null);
  Get.put(AuthController(), permanent: true);
  final box = GetStorage();
  final token = box.read('token');
  print('🚀 [MAIN] Initial token: $token');
  bool isTokenEmpty = token == null || token.toString().trim().isEmpty;

  runApp(MyApp(initialRoute: isTokenEmpty ? Routes.STARTED : Routes.LAYOUT));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    final baseTheme = ThemeData.light();

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      getPages: AppPages.Pages,
      theme: baseTheme.copyWith(
        textTheme: GoogleFonts.plusJakartaSansTextTheme(baseTheme.textTheme),
        primaryTextTheme:
            GoogleFonts.plusJakartaSansTextTheme(baseTheme.primaryTextTheme),
      ),
    );
  }
}
