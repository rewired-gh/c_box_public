import 'package:c_box/models/global_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'logic.dart';

class DetailsPage extends StatelessWidget {
  final DetailsLogic logic = Get.put(DetailsLogic());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 64.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(14.0)),
        ),
        title: Text('Page Details'.tr),
        leading: IconButton(
          tooltip: 'Back'.tr,
          onPressed: () {
            Get.back();
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios_rounded),
        ),
        actions: [
          IconButton(
            onPressed: () {
              return;
              // TODO
              showDialog(
                context: context,
                builder: (_) {
                  return AlertDialog(
                    title: Text('Send Content'.tr),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'Public Key'.tr,
                          ),
                          controller: logic.textSenderPublicKeyController,
                        ),
                        SizedBox(height: 16.0),
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'Encrypted Content'.tr,
                            border: OutlineInputBorder(),
                            contentPadding:
                                EdgeInsets.fromLTRB(8.0, 10.0, 8.0, 10.0),
                          ),
                          style: TextStyle(
                            fontSize: 10.0,
                          ),
                          minLines: 4,
                          maxLines: 20,
                          controller:
                              logic.textSenderEncryptedContentController,
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {},
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
            icon: Icon(Icons.arrow_circle_up_rounded),
            tooltip: 'Send Content'.tr,
          ),
          SizedBox(width: 10.0),
          IconButton(
            onPressed: () {
              return;
              // TODO
              showDialog(
                context: context,
                builder: (_) {
                  return AlertDialog(
                    title: Text('Receive Content'.tr),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'Public Key'.tr,
                          ),
                          controller: logic.textReceiverPublicKeyController,
                        ),
                        SizedBox(height: 16.0),
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'Encrypted Content'.tr,
                            border: OutlineInputBorder(),
                            contentPadding:
                                EdgeInsets.fromLTRB(8.0, 10.0, 8.0, 10.0),
                          ),
                          style: TextStyle(
                            fontSize: 10.0,
                          ),
                          minLines: 4,
                          maxLines: 20,
                          controller:
                              logic.textReceiverEncryptedContentController,
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          logic.generateKeyPair();
                        },
                        child: Text('Generate'.tr),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text('Import'.tr),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text('Show Private Key'.tr),
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
            icon: Icon(Icons.arrow_circle_down_rounded),
            tooltip: 'Receive Content'.tr,
          ),
          SizedBox(width: 10.0),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            child: Icon(Icons.save),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) {
                  return AlertDialog(
                    title: Text('Confirm Password'.tr),
                    content: TextField(
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'Type password again'.tr,
                        helperText:
                            'Tips: It\'s better to use complicated password with more than 12 characters.'
                                .tr,
                        helperMaxLines: 2,
                      ),
                      controller: logic.textPasswordAgainController,
                      obscureText: true,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () async {
                          if (logic.textPasswordAgainController.text ==
                              logic.textKeyController.text) {
                            final isOk = await logic.save();
                            if (isOk) {
                              GlobalSnackBar.show(
                                  context, 'Save page successfully'.tr);
                            } else {
                              GlobalSnackBar.show(
                                  context, 'Failed when saving page'.tr);
                            }
                            logic.textPasswordAgainController.clear();
                            Get.back();
                          } else {
                            logic.textPasswordAgainController.clear();
                          }
                        },
                        child: Text('Save'.tr),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.back();
                          logic.textPasswordAgainController.clear();
                        },
                        child: Text('Back'.tr),
                      ),
                    ],
                  );
                },
              );
            },
            heroTag: 'save',
            tooltip: 'Save Page'.tr,
          ),
          SizedBox(
            width: 20.0,
          ),
          FloatingActionButton(
            child: Icon(Icons.auto_fix_high),
            onPressed: logic.magicalize,
            heroTag: 'magicalize',
            tooltip: 'Decrypt Page'.tr,
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 86.0),
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Page Title'.tr,
            ),
            onChanged: logic.onTitleChanged,
            controller: logic.textTitleController,
          ),
          SizedBox(height: 8.0),
          TextField(
            decoration: InputDecoration(
              hintText: 'Password'.tr,
            ),
            obscureText: true,
            controller: logic.textKeyController,
          ),
          SizedBox(height: 8.0),
          TextField(
            decoration: InputDecoration(
              hintText: 'Original Content'.tr,
            ),
            minLines: 1,
            maxLines: 128,
            controller: logic.textContentController,
          ),
        ],
      ),
    );
  }
}
