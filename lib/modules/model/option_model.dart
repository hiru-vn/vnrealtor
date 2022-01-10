import 'package:flutter/material.dart';

class OptionModel {
  final String code;
  final String name;
  final String type;
  final String? description;
  final String? keySearch;
  final String? parentCode;
  // String get searchToken {
  //   final toLower = name.toLowerCase();
  //   return '${TiengViet.parse(toLower)} $toLower';
  // }

  const OptionModel({
    required this.code,
    required this.name,
    required this.type,
    this.keySearch,
    this.description,
    this.parentCode,
  });

  const OptionModel.empty()
      : code = '',
        name = '',
        type = '',
        keySearch = '',
        description = '',
        parentCode = '';

  DropdownMenuItem<String> buildDropdownItem() =>
      DropdownMenuItem<String>(value: code, child: Text(name));
}

class MultiOptionModel extends OptionModel {
  bool checked;
  MultiOptionModel({
    required String code,
    required String name,
    required String type,
    this.checked = false,
    String? keySearch,
    String? description,
    String? parentCode,
  }) : super(
          code: code,
          name: name,
          type: type,
          keySearch: keySearch,
          description: description,
          parentCode: parentCode,
        );
}
