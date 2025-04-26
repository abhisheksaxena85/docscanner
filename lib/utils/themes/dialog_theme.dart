import 'package:docscanner/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

DialogTheme mainDialogTheme() {
  return DialogTheme(
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    contentTextStyle: GoogleFonts.openSans(
      fontSize: 14.sp,
      color: AppColors.primaryBlackColor,
    ),
    titleTextStyle: GoogleFonts.openSans(
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.secondaryBlackColor),
    surfaceTintColor: AppColors.whiteBgColor,
    clipBehavior: Clip.antiAlias,
    elevation: 0.r,
    iconColor: AppColors.primaryBlackColor,
  );
}
