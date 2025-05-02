import 'package:docscanner/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

void showLoadingIndicator(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return WillPopScope(
        onWillPop: () async => false,
        child: Container(
          alignment: Alignment.center,
          child: Container(
            height: 100.h,
            margin: EdgeInsets.symmetric(horizontal: 50.w),
            padding: EdgeInsets.only(left: 25.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircularProgressIndicator(
                  color: AppColors.errorColor,
                ),
                SizedBox(width: 20.w),
                Text(
                  'Loading...',
                  style: GoogleFonts.openSans(
                    fontSize: 16.sp,
                    color: AppColors.teritiaryBlackColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
