import 'package:c_box/common/strings.dart';
import 'package:c_box/models/global_snack_bar.dart';
import 'package:c_box/models/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'logic.dart';

class HomePage extends StatelessWidget {
  final HomeLogic logic = Get.put(HomeLogic());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 64.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(14.0)),
        ),
        title: Text(
          TITLE_STRING,
          style: GoogleFonts.ubuntu(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          tooltip: 'Advanced Settings'.tr,
          onPressed: () {
            Get.toNamed('/settings')?.then((value) {
              logic.update(); //sus
            });
          },
          icon: Icon(Icons.developer_mode_rounded),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) {
                  logic.getUsername();
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    ),
                    title: Text('Cloud Data Sync'.tr),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          decoration: InputDecoration(hintText: 'Username'.tr),
                          controller: logic.syncUsernameController,
                        ),
                        SizedBox(height: 8.0),
                        TextField(
                          decoration: InputDecoration(hintText: 'Password'.tr),
                          controller: logic.syncPasswordController,
                          obscureText: true,
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () async {
                          final isOk = await logic.cloudAction(logic.pushCloud);
                          if (isOk) {
                            GlobalSnackBar.show(
                                context, 'Upload to cloud successfully'.tr);
                          } else {
                            GlobalSnackBar.show(
                                context, 'Failed when uploading to cloud'.tr);
                          }
                        },
                        child: Text('Upload'.tr),
                      ),
                      TextButton(
                        onPressed: () async {
                          final isOk = await logic.cloudAction(logic.pullCloud);
                          if (isOk) {
                            GlobalSnackBar.show(
                                context, 'Download from cloud successfully'.tr);
                          } else {
                            GlobalSnackBar.show(context,
                                'Failed when downloading from cloud'.tr);
                          }
                        },
                        child: Text('Download'.tr),
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
            icon: Icon(Icons.cloud_outlined),
            tooltip: 'Cloud Data Sync'.tr,
          ),
          SizedBox(width: 10.0),
          IconButton(
            onPressed: () async {
              final isOk = await logic.toClipboard();
              if (isOk) {
                GlobalSnackBar.show(
                    context, 'Copy data to clipboard successfully'.tr);
              } else {
                GlobalSnackBar.show(
                    context, 'Failed when copying data to clipboard'.tr);
              }
            },
            icon: Icon(Icons.copy_rounded),
            tooltip: 'Copy Data to Clipboard'.tr,
          ),
          SizedBox(width: 10.0),
          IconButton(
            onPressed: () async {
              final isOk = await logic.fromClipboard();
              if (isOk) {
                GlobalSnackBar.show(
                    context, 'Load data from clipboard successfully'.tr);
              } else {
                GlobalSnackBar.show(
                    context, 'Failed when loading data from clipboard'.tr);
              }
            },
            icon: Icon(Icons.paste_rounded),
            tooltip: 'Load Data from Clipboard'.tr,
          ),
          SizedBox(width: 10.0),
        ],
      ),
      body: FutureBuilder<void>(
        future: logic.init(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Obx(() {
              return ListView.builder(
                padding: EdgeInsets.fromLTRB(0.0, 6.0, 0.0, 86.0),
                itemCount: logic.titleList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 1.0, 8.0, 1.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                      child: ListTile(
                        title: Text(logic.titleList[index]),
                        trailing: Icon(Icons.keyboard_arrow_right_rounded),
                        contentPadding:
                            EdgeInsets.fromLTRB(16.0, 3.0, 12.0, 3.0),
                        onTap: () {
                          logic.openPage(index);
                        },
                        onLongPress: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16.0)),
                              ),
                              title: Text('Be careful!'.tr),
                              content: Text(
                                  'Are you sure you want to delete "%0\$" at %1\$? This action cannot be undone.'
                                      .tr
                                      .format([logic.titleList[index], index])),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    logic.deletePage(index);
                                    Get.back();
                                  },
                                  child: Text('Yes'.tr),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: Text('No'.tr),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            });
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: logic.addPage,
        tooltip: 'Add Page'.tr,
        child: Icon(Icons.add),
      ),
    );
  }
}
