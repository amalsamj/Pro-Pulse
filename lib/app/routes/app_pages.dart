import 'package:get/get.dart';
import 'package:pro_pulse_medical_app/modules/Home/shopping/bindings/shopping_binding.dart';
import 'package:pro_pulse_medical_app/modules/Home/shopping/controller/shopping_controller.dart';
import 'package:pro_pulse_medical_app/modules/Home/shopping/view/shopping_cart_view.dart';
import 'package:pro_pulse_medical_app/modules/Home/shopping/view/shopping_view.dart';
import 'package:pro_pulse_medical_app/modules/Home/view/home_view.dart';
import 'package:pro_pulse_medical_app/modules/auth/landing/bindings/landing_binding.dart';
import 'package:pro_pulse_medical_app/modules/auth/landing/view/landing_view.dart';
import 'package:pro_pulse_medical_app/modules/auth/login/bindings/login_binding.dart';
import 'package:pro_pulse_medical_app/modules/auth/login/view/login_mobile_view.dart';
import 'package:pro_pulse_medical_app/modules/auth/login/view/login_otp_view.dart';
import 'package:pro_pulse_medical_app/modules/auth/signup/bindings/signup_binding.dart';
import 'package:pro_pulse_medical_app/modules/auth/signup/view/signup_view.dart';
import 'package:pro_pulse_medical_app/modules/booking/bindings/booking_binding.dart';
import 'package:pro_pulse_medical_app/modules/patient/view/patient_form_view.dart';
import 'package:pro_pulse_medical_app/modules/splash/view/splash_view.dart';
import 'package:pro_pulse_medical_app/modules/welcome/view/onboarding_view.dart';
import '../../modules/booking/view/booking_form.dart';
import '../../modules/Home/bindings/home_binding.dart';
import '../../modules/patient/bindings/patient_binding.dart';
import '../../modules/splash/bindings/splash_binding.dart';
import '../../modules/welcome/bindings/onboarding_binding.dart';

import 'app_routes.dart';

class AppPages {
  AppPages._();

  static final List<GetPage> pages = [
    GetPage(
      name: Routes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: Routes.onboarding,
      page: () => OnboardingView(),
      binding: OnboardingBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.login,
      page: () => MobileLoginView(),
      binding: LoginBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.loginOtp,
      page: () => OtpVerificationView(),
      binding: LoginBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.signup,
      page: () => SignupView(),
      binding: SignupBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.home,
      page: () => HomeView(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.booking,
      page: () => const BookingPage(),
      binding: BookingBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.patient,
      page: () => PatientFormView(),
      binding: PatientBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.landing,
      page: () => LandingView(),
      binding: LandingBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.shopping,
      page: () => ShoppingView(),
      binding: ShoppingBinding(),
    ),
    GetPage(
      name: Routes.shoppingCart,
      page: () => ShoppingCartView(controller: Get.find<ShoppingController>()),
      binding: ShoppingBinding(),
    ),
  ];
}
