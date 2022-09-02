// ignore_for_file: public_member_api_docs
// coverage:ignore-file

import 'package:json_annotation/json_annotation.dart';

@JsonEnum(fieldRename: FieldRename.pascal)
enum DayPart {
  breakfast,
  lunch,
  evening,
}
