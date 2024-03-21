import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:gstark/screens/authentication/splash_screen.dart';

import 'controller/login_screen_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const MyApp(),
  );
  Get.put(LoginScreenController());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      enableLog: false,
      home: const SplashScreen(),
      title: 'Boas App',
      theme: ThemeData(fontFamily: 'Poppins'),
      locale: _locale,
    );
  }
}
