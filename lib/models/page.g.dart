// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CPage _$CPageFromJson(Map<String, dynamic> json) {
  return CPage(
    cipherText:
        (json['cipherText'] as List<dynamic>).map((e) => e as int).toList(),
    macBytes: (json['macBytes'] as List<dynamic>).map((e) => e as int).toList(),
    nonce: (json['nonce'] as List<dynamic>).map((e) => e as int).toList(),
  );
}

Map<String, dynamic> _$CPageToJson(CPage instance) => <String, dynamic>{
      'cipherText': instance.cipherText,
      'macBytes': instance.macBytes,
      'nonce': instance.nonce,
    };
