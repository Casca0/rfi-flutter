import 'package:flutter/material.dart';

class PageConfig {
  final String title;
  final IconData? icon;
  final List<Widget>? actions;

  const PageConfig({required this.title, this.icon, this.actions});
}
