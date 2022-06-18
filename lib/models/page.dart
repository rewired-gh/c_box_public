import 'package:cryptography/cryptography.dart';
import 'package:json_annotation/json_annotation.dart';

part 'page.g.dart';

@JsonSerializable()
class CPage {
  List<int> cipherText;
  List<int> macBytes;
  List<int> nonce;

  @JsonKey(ignore: true)
  SecretBox get eContent {
    return SecretBox(
      cipherText,
      nonce: nonce,
      mac: Mac(macBytes),
    );
  }

  set eContent(SecretBox secretBox) {
    cipherText = secretBox.cipherText;
    nonce = secretBox.nonce;
    macBytes = secretBox.mac.bytes;
  }

  CPage({
    this.cipherText = const [],
    this.macBytes = const [],
    this.nonce = const [],
  });

  factory CPage.fromJson(Map<String, dynamic> json) => _$CPageFromJson(json);

  Map<String, dynamic> toJson() => _$CPageToJson(this);
}
