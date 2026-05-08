import 'dart:io';
import 'package:flutter/material.dart';

ImageProvider? getPatientImageProvider(String path) {
  if (path.trim().isEmpty) return null;

  final isNetwork =
      path.startsWith('http://') || path.startsWith('https://');

  if (isNetwork) {
    return NetworkImage(path);
  }

  return FileImage(File(path));
}
