import 'package:docscanner/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

ButtonThemeData mainButtonTheme() {
  return ButtonThemeData(
    buttonColor: AppColors.brandColor,
    splashColor: AppColors.brandBgColor,
    disabledColor: AppColors.teritiaryBlackColor,
    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
    textTheme: ButtonTextTheme.normal,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(4.r),
    ),
  );
}
