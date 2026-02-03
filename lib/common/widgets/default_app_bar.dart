import 'package:flutter/material.dart';

AppBar defaultAppBar({required String title, List<Widget>? actions}) => AppBar(
  title: Text(title),
  centerTitle: true,
  backgroundColor: Colors.transparent,
  actions: actions,
);