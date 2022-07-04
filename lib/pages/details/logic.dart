import 'dart:convert';

import 'package:c_box/common/strings.dart';
import 'package:c_box/models/page.dart';
import 'package:c_box/pages/home/logic.dart';
import 'package:cryptography/cryptography.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailsLogic extends GetxController {
  final HomeLogic homeLogic = Get.find();
  final index = int.parse(Get.parameters['index']!);
  final textTitleController = TextEditingController();
  final textKeyController = TextEditingController();
  final textContentController = TextEditingController();
  final textPasswordAgainController = TextEditingController();
  final textSenderPublicKeyController = TextEditingController();
  final textSenderEncryptedContentController = TextEditingController();
  final textReceiverPublicKeyController = TextEditingController();
  final textReceiverEncryptedContentController = TextEditingController();

  SimpleKeyPair? keyPair;
  SimpleKeyPair? publicKeyPair;

  Future<void> onTitleChanged(String text) async {
    homeLogic.titleList[index] = text;

    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('titles', homeLogic.titleList);
  }

  Future<List<int>> hashPassword(String text, List<int> nonce) async {
    final hashAlgorithm = Pbkdf2(
      macAlgorithm: Hmac.sha256(),
      iterations: PBKDF2_ITERATIONS,
      bits: 256,
    );
    final hash = await (await hashAlgorithm.deriveKey(
      secretKey: SecretKey(utf8.encode(text)),
      nonce: nonce,
    ))
        .extractBytes();
    return hash;
  }

  Future<bool> save() async {
    if (textKeyController.text.isEmpty || textContentController.text.isEmpty) {
      return false;
    } else {
      final encryptAlgorithm = AesGcm.with256bits();
      final nonce = encryptAlgorithm.newNonce();

      final hash = await hashPassword(textKeyController.text, nonce);

      final secretKey = SecretKey(hash);

      final cPage = CPage();
      cPage.eContent = await compute((List<dynamic> args) async {
        return await (args[0] as AesGcm).encrypt(
          utf8.encode(args[1]),
          secretKey: args[2],
          nonce: args[3],
        );
      }, [encryptAlgorithm, textContentController.text, secretKey, nonce]);

      try {
        homeLogic.pageList[index] = json.encode(cPage.toJson());
        final prefs = await SharedPreferences.getInstance();
        prefs.setStringList('pages', homeLogic.pageList);
      } catch (e) {
        return false;
      }

      textContentController.clear();
      textKeyController.clear();
      return true;
    }
  }

  Future<void> magicalize() async {
    if (textKeyController.text.isEmpty) {
      return;
    }

    final secretBox =
        CPage.fromJson(json.decode(homeLogic.pageList[index])).eContent;

    final hash = await hashPassword(textKeyController.text, secretBox.nonce);

    final algorithm = AesGcm.with256bits();
    final secretKey = SecretKey(hash);

    textContentController.text = await compute((List<dynamic> args) async {
      return await utf8.decode(
          await (args[0] as AesGcm).decrypt(args[1], secretKey: args[2]));
    }, [algorithm, secretBox, secretKey]);

    textKeyController.text = '';
  }

  Future<void> generateKeyPair() async {
    // TODO
  }

  void generateEncryptedContent() {
    // TODO
  }

  @override
  onReady() {
    super.onReady();
    if (!homeLogic.doneInit) {
      homeLogic.init().then((value) {
        textTitleController.text = homeLogic.titleList[index];
      });
    } else {
      textTitleController.text = homeLogic.titleList[index];
    }
  }
}
