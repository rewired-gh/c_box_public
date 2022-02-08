import 'package:c_box/common/strings.dart';
import 'package:c_box/pages/settings/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'common/i18n_service.dart';
import 'common/strings.dart';
import 'pages/details/view.dart';
import 'pages/home/view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: TITLE_STRING,
      onInit: () async {
        final prefs = await SharedPreferences.getInstance();
        if (prefs.containsKey('locale')) {
          I18nService.locale = I18nService.locales[prefs.getInt('locale')!];
        } else {
          I18nService.locale = Get.deviceLocale ?? I18nService.fallbackLocale;
        }
        Get.updateLocale(I18nService.locale);
      },
      theme: ThemeData(
        fontFamily: 'Noto Sans',
        primarySwatch: Colors.deepOrange,
        textTheme: TextTheme(
          headline6: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en', 'US'),
        Locale('zh', 'CN'),
      ],
      home: HomePage(),
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/',
          page: () => HomePage(),
        ),
        GetPage(
          name: '/page/:index',
          page: () => DetailsPage(),
        ),
        GetPage(
          name: '/settings',
          page: () => SettingsPage(),
        )
      ],
      fallbackLocale: I18nService.fallbackLocale,
      translations: I18nService(),
    );
  }
}
