import 'package:c_box/common/i18n_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

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
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 1.0, 8.0, 1.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
              child: FutureBuilder(
                future: logic.loadLanguage(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return PopupMenuButton(
                      padding: EdgeInsets.zero,
                      offset: Offset(0xffffffff, 0.0),
                      child: ListTile(
                        contentPadding:
                            EdgeInsets.fromLTRB(16.0, 3.0, 12.0, 3.0),
                        leading: Icon(Icons.translate_rounded),
                        title: Text('App Language'.tr),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
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
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 1.0, 8.0, 1.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.fromLTRB(16.0, 3.0, 12.0, 3.0),
                leading: Icon(Icons.construction_rounded),
                title: Text('Alternative Data I/O'.tr),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) {
                      logic.altIoTextController.clear();
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                        ),
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
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 1.0, 8.0, 1.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.fromLTRB(16.0, 3.0, 12.0, 3.0),
                leading: Icon(Icons.security_rounded),
                title: Text('Password Hash Generator'.tr),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) {
                      logic.altIoTextController.clear();
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                        ),
                        title: Text('Password Hash Generator'.tr),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              decoration:
                                  InputDecoration(hintText: 'Password'.tr),
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
                              logic.syncHashController.text =
                                  await logic.homeLogic.hashPassword(
                                      logic.syncPasswordController.text);
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
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 1.0, 8.0, 1.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.fromLTRB(16.0, 10.0, 12.0, 10.0),
                leading: Icon(Icons.info_outline_rounded),
                title: Text('About'.tr),
                subtitle: Text(
                  '(c) Haojun Li <c@hopp.top> 2022\nApp Website: http://c-box.hopp.top'
                      .tr,
                  style: GoogleFonts.ubuntuMono(
                    fontSize: 14.0,
                    height: 2.0,
                    fontWeight: FontWeight.w200,
                    color: Color.fromRGBO(0, 0, 0, 0.3),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
