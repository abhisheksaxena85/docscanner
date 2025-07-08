import 'package:docscanner/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

SnackBar failedSnackBar(String message) {
  return SnackBar(
    content: Row(
      children: [
        const Icon(
          Icons.error_outline,
          color: AppColors.errorColor,
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(
            message,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.roboto(
                color: AppColors.errorColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600),
          ),
        ),
      ],
    ),
    duration: const Duration(seconds: 4),
    backgroundColor: AppColors.redBg,
    showCloseIcon: true,
    closeIconColor: AppColors.secondaryBlackColor,
  );
}

SnackBar successSnackBar(String message) {
  return SnackBar(
    content: Row(
      children: [
        const Icon(
          Icons.check_circle,
          color: AppColors.successColor,
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(
            message,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.roboto(
                color: AppColors.successColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600),
          ),
        ),
      ],
    ),
    duration: const Duration(seconds: 4),
    backgroundColor: AppColors.greenBg,
    showCloseIcon: true,
    closeIconColor: AppColors.secondaryBlackColor,
  );
}

SnackBar waitingSnackbar(String message) {
  return SnackBar(
    content: Row(
      children: [
        const Icon(
          Icons.downloading,
          color: AppColors.contextualYellow,
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(
            message,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.roboto(
                color: AppColors.contextualYellow,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600),
          ),
        ),
      ],
    ),
    duration: const Duration(seconds: 4),
    backgroundColor: AppColors.yellowBg,
    showCloseIcon: true,
    closeIconColor: AppColors.secondaryBlackColor,
  );
}
