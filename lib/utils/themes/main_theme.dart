import 'package:docscanner/utils/themes/appbar_theme.dart';
import 'package:docscanner/utils/themes/button_theme.dart';
import 'package:docscanner/utils/themes/dialog_theme.dart';
import 'package:flutter/material.dart';

ThemeData mainTheme() {
  return ThemeData(
    useMaterial3: true,
    appBarTheme: mainAppBarTheme(),
    dialogTheme: mainDialogTheme(),
    buttonTheme: mainButtonTheme(),
  );
}
