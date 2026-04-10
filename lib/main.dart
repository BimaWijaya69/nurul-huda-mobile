import 'package:flutter/material.dart';
import 'package:nurul_huda_mobile/core/routes/app_routes.dart';
import 'package:nurul_huda_mobile/core/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await initializeDateFormatting('id_ID', null);

  final box = GetStorage();
  final token = box.read('token');

  bool isTokenExpired = token == null || JwtDecoder.isExpired(token);
  runApp(MyApp(initialRoute: isTokenExpired ? Routes.STARTED : Routes.LAYOUT));
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
