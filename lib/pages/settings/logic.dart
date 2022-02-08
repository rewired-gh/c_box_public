import 'package:c_box/common/i18n_service.dart';
import 'package:c_box/pages/home/logic.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsLogic extends GetxController {
  final HomeLogic homeLogic = Get.find();
  final altIoTextController = TextEditingController();
  final syncPasswordController = TextEditingController();
  final syncHashController = TextEditingController();

  int localeIndex = -1;

  void pushData() {
    altIoTextController.text = homeLogic.getData();
    altIoTextController.selection = TextSelection(
      baseOffset: 0,
      extentOffset: altIoTextController.text.length,
    );
  }

  void pullData() {
    homeLogic.setData(altIoTextController.text);
    altIoTextController.clear();
  }

  void changeLanguage() {
    if (localeIndex >= 0) {
      Get.updateLocale(I18nService.locales[localeIndex]);
    } else {
      Get.updateLocale(Get.deviceLocale ?? I18nService.fallbackLocale);
    }
  }

  Future<void> saveLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('locale', localeIndex);
  }

  Future<void> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('locale')) {
      localeIndex = prefs.getInt('locale')!;
    }
  }
}
