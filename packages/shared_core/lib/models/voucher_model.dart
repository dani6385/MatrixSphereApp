// ignore_for_file: unused_import
import 'package:flutter/material.dart';


class VoucherModel {
  final String code;
  final String status;
  final String profile;

  VoucherModel({required this.code, required this.status, required this.profile});

  // Factory untuk merubah data dari Firestore menjadi Object
  factory VoucherModel.fromMap(Map<String, dynamic> map) {
    return VoucherModel(
      code: map['code'] ?? '',
      status: map['status'] ?? 'available',
      profile: map['profile'] ?? 'default',
    );
  }
}