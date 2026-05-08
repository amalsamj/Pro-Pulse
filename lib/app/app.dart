import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pro_pulse_medical_app/app/bindings/initial_bindings.dart';
import 'package:pro_pulse_medical_app/app/localization/app_translations.dart';
import 'package:pro_pulse_medical_app/app/routes/app_pages.dart';
import 'package:pro_pulse_medical_app/app/routes/app_routes.dart';
import 'package:pro_pulse_medical_app/app/theme/app_theme.dart';
import 'package:pro_pulse_medical_app/modules/splash/view/splash_view.dart';
import 'package:get/get.dart';

class ProPulseApp extends StatelessWidget {
  const ProPulseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return GetMaterialApp(
          title: 'Flutter Demo',
          translations: AppTranslations(),
          locale: const Locale('en', 'US'),
          fallbackLocale: const Locale('en', 'US'),
          theme: AppTheme.light(context),
          debugShowCheckedModeBanner: false,
          initialBinding: InitialBindings(),
          initialRoute: Routes.splash,
          getPages: AppPages.pages,
        );
      },
      child: const SplashView(),
    );
  }
}

void configureSystemUi() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
}
