import 'package:docscanner/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

AppBarTheme mainAppBarTheme() {
  return AppBarTheme(
    backgroundColor: AppColors.brandBgColor,
    foregroundColor: AppColors.brandBgColor,
    elevation: 0,
    toolbarHeight: 40.h,
    shadowColor: Colors.transparent,
    centerTitle: false,
    titleTextStyle: GoogleFonts.openSans(
      fontSize: 16.sp,
      fontWeight: FontWeight.w600,
      color: AppColors.primaryBlackColor,
    ),
    iconTheme: IconThemeData(color: AppColors.primaryBlackColor, size: 18.sp),
  );
}
