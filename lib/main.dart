import 'package:chatgpt/firebase_options.dart';
import 'package:chatgpt/service_layer/service_locator.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocator();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => const MyApp(),
    ),
  );
}

///App's entry point
class MyApp extends StatelessWidget {
  ///Default constructor for [MyApp]
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          builder: DevicePreview.appBuilder,
          debugShowCheckedModeBanner: false,
          title: appConfig.appName,
          routerConfig: navigationService.appRoutersService.router,
        );
      },
    );
  }
}
