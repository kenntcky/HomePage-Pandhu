import 'package:get/get.dart';

import '../modules/Report/bindings/report_binding.dart';
import '../modules/Report/views/report_view.dart';
import '../modules/artikel/bindings/artikel_binding.dart';
import '../modules/artikel/views/artikel_view.dart';
import '../modules/chat/bindings/chat_binding.dart';
import '../modules/chat/views/chat_view.dart';
import '../modules/detail_gempa/bindings/detail_gempa_binding.dart';
import '../modules/detail_gempa/views/detail_gempa_view.dart';
import '../modules/gantilok_editlok/bindings/gantilok_editlok_binding.dart';
import '../modules/gantilok_editlok/views/gantilok_editlok_view.dart';
import '../modules/gantilok_failed/bindings/gantilok_failed_binding.dart';
import '../modules/gantilok_failed/views/gantilok_failed_view.dart';
import '../modules/gantilok_success/bindings/gantilok_success_binding.dart';
import '../modules/gantilok_success/views/gantilok_success_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/main_artikel/bindings/main_artikel_binding.dart';
import '../modules/main_artikel/views/main_artikel_view.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/permission/bindings/permission_binding.dart';
import '../modules/permission/views/permission_view.dart';
import '../modules/posko/bindings/posko_binding.dart';
import '../modules/posko/views/posko_view.dart';
import '../modules/riwayat/bindings/riwayat_binding.dart';
import '../modules/riwayat/views/riwayat_view.dart';
import '../modules/search/bindings/search_binding.dart';
import '../modules/search/views/search_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/warning/bindings/warning_binding.dart';
import '../modules/warning/views/warning_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.ONBOARDING,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: _Paths.RIWAYAT,
      page: () => const RiwayatView(),
      binding: RiwayatBinding(),
    ),
    GetPage(
      name: _Paths.PERMISSION,
      page: () => PermissionView(),
      binding: PermissionBinding(),
    ),
    GetPage(
      name: _Paths.SEARCH,
      page: () => const SearchView(),
      binding: SearchBinding(),
    ),
    GetPage(
      name: _Paths.REPORT,
      page: () => const ReportView(),
      binding: ReportBinding(),
    ),
    GetPage(
      name: _Paths.CHAT,
      page: () => const ChatView(),
      binding: ChatBinding(),
    ),
    GetPage(
      name: _Paths.WARNING,
      page: () => WarningView(),
      binding: WarningBinding(),
    ),
    GetPage(
      name: _Paths.GANTILOK_FAILED,
      page: () => const GantilokFailedView(),
      binding: GantilokFailedBinding(),
    ),
    GetPage(
      name: _Paths.GANTILOK_SUCCESS,
      page: () => const GantilokSuccessView(),
      binding: GantilokSuccessBinding(),
    ),
    GetPage(
      name: _Paths.GANTILOK_EDITLOK,
      page: () => const GantilokEditlokView(),
      binding: GantilokEditlokBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_GEMPA,
      page: () => Googlemapflutter(gempaData: Get.arguments),
      binding: DetailGempaBinding(),
    ),
    GetPage(
      name: _Paths.ARTIKEL,
      page: () => const ArtikelView(),
      binding: ArtikelBinding(),
    ),
    GetPage(
      name: _Paths.POSKO,
      page: () => const PoskoView(),
      binding: PoskoBinding(),
    ),
    GetPage(
      name: _Paths.MAIN_ARTIKEL,
      page: () => const MainArtikelView(),
      binding: MainArtikelBinding(),
    ),
  ];
}
