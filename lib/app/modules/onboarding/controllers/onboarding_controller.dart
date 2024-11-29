import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../routes/app_pages.dart';

class OnboardingController extends GetxController {
  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);
    
    // Check if location is initialized
    bool isLocationInitialized = prefs.getBool('locationInitialized') ?? false;
    
    // Navigate to appropriate screen
    if (isLocationInitialized) {
      Get.offAllNamed(Routes.HOME);
    } else {
      Get.offAllNamed(Routes.PERMISSION);
    }
  }
}
