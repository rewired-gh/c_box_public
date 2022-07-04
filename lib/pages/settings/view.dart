import 'package:c_box/common/i18n_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Widget/card_item.dart';
import 'logic.dart';

class SettingsPage extends StatelessWidget {
  final logic = Get.put(SettingsLogic());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 64.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(14.0)),
        ),
        title: Text('Advanced Settings'.tr),
        leading: IconButton(
          tooltip: 'Back'.tr,
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios_rounded),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(0.0, 6.0, 0.0, 86.0),
        children: [
          CustomCardItem(
            child: FutureBuilder(
              future: logic.loadLanguage(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return PopupMenuButton(
                    padding: EdgeInsets.zero,
                    offset: Offset(0xffffffff, 0.0),
                    child: ListTile(
                      contentPadding: EdgeInsets.fromLTRB(16.0, 3.0, 12.0, 3.0),
                      leading: Icon(Icons.translate_rounded),
                      title: Text('App Language'.tr),
                    ),
                    onSelected: (value) {
                      logic.localeIndex = value as int;
                      logic.changeLanguage();
                      logic.saveLanguage();
                    },
                    itemBuilder: (context) {
                      return [
                            CheckedPopupMenuItem(
                              padding: EdgeInsets.zero,
                              checked: logic.localeIndex == -1,
                              value: -1,
                              child: Text('Auto Detect'.tr),
                            )
                          ] +
                          I18nService.languages
                              .asMap()
                              .map((index, text) => MapEntry(
                                  index,
                                  CheckedPopupMenuItem(
                                    padding: EdgeInsets.zero,
                                    checked: logic.localeIndex == index,
                                    value: index,
                                    child: Text(text),
                                  )))
                              .values
                              .toList();
                    },
                  );
                } else {
                  return ListTile(
                    contentPadding: EdgeInsets.fromLTRB(16.0, 3.0, 12.0, 3.0),
                    leading: Icon(Icons.translate_rounded),
                    title: Text('App Language'.tr),
                  );
                }
              },
            ),
          ),
          CardItem(
            title: 'Alternative Data I/O'.tr,
            leading: Icon(Icons.construction_rounded),
            onTap: () {
              showDialog(
                context: context,
                builder: (_) {
                  logic.altIoTextController.clear();
                  return AlertDialog(
                    title: Text('Alternative Data I/O'.tr),
                    content: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.fromLTRB(8.0, 10.0, 8.0, 10.0),
                      ),
                      style: TextStyle(
                        fontSize: 10.0,
                      ),
                      minLines: 4,
                      maxLines: 20,
                      controller: logic.altIoTextController,
                    ),
                    actions: [
                      TextButton(
                        onPressed: logic.pushData,
                        child: Text('Export'.tr),
                      ),
                      TextButton(
                        onPressed: logic.pullData,
                        child: Text('Import'.tr),
                      ),
                      TextButton(
                        onPressed: () {
                          logic.altIoTextController.clear();
                        },
                        child: Text('Clear'.tr),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          CardItem(
            title: 'Password Hash Generator'.tr,
            leading: Icon(Icons.security_rounded),
            onTap: () {
              showDialog(
                context: context,
                builder: (_) {
                  logic.altIoTextController.clear();
                  return AlertDialog(
                    title: Text('Password Hash Generator'.tr),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          decoration: InputDecoration(hintText: 'Password'.tr),
                          controller: logic.syncPasswordController,
                          obscureText: true,
                        ),
                        SizedBox(height: 8.0),
                        TextField(
                          decoration:
                              InputDecoration(hintText: 'Hash Result'.tr),
                          controller: logic.syncHashController,
                          minLines: 1,
                          maxLines: 4,
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () async {
                          logic.syncHashController.text = await logic.homeLogic
                              .hashPassword(logic.syncPasswordController.text);
                          logic.syncPasswordController.clear();
                        },
                        child: Text('Generate'.tr),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: Text('Back'.tr),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          CardItem(
            title: 'About'.tr,
            subtitle: Padding(
              padding: EdgeInsets.only(top: 6.0),
              child: Text(
                '(c) Haojun Li <c@hopp.top> 2022\nApp Website: http://c-box.hopp.top'
                    .tr,
                style: GoogleFonts.ubuntuMono(
                  fontSize: 14.0,
                  height: 1.6,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            leading: Icon(Icons.info_outline_rounded),
          ),
        ],
      ),
    );
  }
}
