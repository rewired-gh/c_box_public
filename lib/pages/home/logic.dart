import 'dart:async';
import 'dart:convert';

import 'package:c_box/common/strings.dart';
import 'package:c_box/models/page.dart';
import 'package:clipboard/clipboard.dart';
import 'package:cryptography/cryptography.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeLogic extends GetxController {
  late final List<String> pageList;
  late final RxList<String> titleList;
  var doneInit = false;
  var doneSync = true;
  final syncUsernameController = TextEditingController();
  final syncPasswordController = TextEditingController();

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey('pages')) {
      pageList = prefs.getStringList('pages')!;
    } else {
      pageList = List.empty(growable: true);
    }

    if (prefs.containsKey('titles')) {
      titleList = prefs.getStringList('titles')!.obs;
    } else {
      titleList = RxList.empty(growable: true);
    }

    doneInit = true;
  }

  void addPage() {
    titleList.add('untitled');
    pageList.add(json.encode(CPage().toJson()));

    saveData();
  }

  void openPage(int index) {
    Get.toNamed('/page/$index')?.then((value) {
      update(); //sus
    });
  }

  void deletePage(int index) {
    titleList.removeAt(index);
    pageList.removeAt(index);

    saveData();
  }

  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('pages', pageList);
    prefs.setStringList('titles', titleList);
  }

  Future<String> hashPassword(String text) async {
    final hashAlgorithm = Pbkdf2(
      macAlgorithm: Hmac.sha256(),
      iterations: PBKDF2_ITERATIONS,
      bits: 256,
    );
    final hash = base64.encode(await (await hashAlgorithm.deriveKey(
      secretKey: SecretKey(utf8.encode(text)),
      nonce: utf8.encode(SALT_STRING),
    ))
        .extractBytes());
    return hash;
  }

  Future<void> initCloud() async {
    WidgetsFlutterBinding.ensureInitialized();
    if (!Parse().hasParseBeenInitialized()) {
      await Parse().initialize(
        APP_ID_STRING,
        PARSE_SERVER_URL_STRING,
        clientKey: CLIENT_KEY_STRING,
        autoSendSessionId: false,
      );
    }
  }

  Future<void> saveUsername() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('username', syncUsernameController.text);
  }

  Future<void> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('username')) {
      syncUsernameController.text = prefs.getString('username') ?? '';
    }
  }

  Future<bool> cloudAction(Future<bool> Function(ParseUser user) action) async {
    if (doneSync &&
        syncUsernameController.text.isNotEmpty &&
        syncPasswordController.text.isNotEmpty) {
      doneSync = false;

      await initCloud();

      var user = ParseUser(
        syncUsernameController.text,
        await hashPassword(syncPasswordController.text),
        null,
      );

      final response = await user.login();

      var actionOk = false;

      if (response.success) {
        user = response.result;

        actionOk = await action(user);
      }

      syncPasswordController.clear();
      saveUsername();

      doneSync = true;
      return actionOk;
    }
    return false;
  }

  Future<bool> pushCloud(user) async {
    user.set('appData', getData());
    return (await user.update()).success;
  }

  Future<bool> pullCloud(user) async {
    final appData = user.get('appData') as String?;
    if (appData != null) {
      setData(appData);
      return true;
    }
    return false;
  }

  String getData() {
    var data = '';
    for (var i = 0; i < titleList.length; i++) {
      data = data + titleList[i] + '\n';
      data = data + pageList[i] + '\n';
    }
    return utf8.fuse(base64).encode(data);
  }

  void setData(String data) {
    data = data.trim();
    if (data.isNotEmpty) {
      data = utf8.fuse(base64).decode(data);
      final lineSplitter = LineSplitter();
      final List<String> lines = lineSplitter.convert(data);
      if (lines.length % 2 == 0) {
        titleList.clear();
        pageList.clear();
        for (var i = 0; i < lines.length; i++) {
          titleList.add(lines[i]);

          i++;

          pageList.add(lines[i]);
        }
        saveData();
      }
    }
  }

  Future<bool> toClipboard() async {
    try {
      var data = getData();
      await FlutterClipboard.copy(data);
    } catch (e) {
      return false;
    }
    return true;
  }

  Future<bool> fromClipboard() async {
    try {
      await FlutterClipboard.paste().then((value) {
        setData(value);
      });
    } catch (e) {
      return false;
    }
    return true;
  }
}
