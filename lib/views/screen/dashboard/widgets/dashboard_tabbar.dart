import 'package:docscanner/utils/app_colors.dart';
import 'package:docscanner/utils/app_images.dart';
import 'package:docscanner/utils/constants.dart';
import 'package:docscanner/viewmodel/dashboard/dashboard_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_fonts/google_fonts.dart';

Widget buildTabBar(BuildContext context, DashboardViewmodel controller) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 60.h,
    margin: EdgeInsets.symmetric(horizontal: 5.w),
    decoration: BoxDecoration(
      color: AppColors.brandColor,
      borderRadius: BorderRadius.all(
        Radius.circular(8.r),
      ),
    ),
    child: Obx(() {
      return TabBar(
        onTap: (index) {
          controller.currentIndex.value = index;
        },
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: EdgeInsets.only(top: 57.h),
        indicator: BoxDecoration(
          color: AppColors.whiteBgColor,
          borderRadius: BorderRadius.all(
            Radius.circular(8.r),
          ),
        ),
        controller: controller.tabController,
        tabs: [
          Tab(
            child: buildTabBarItem(
              Constants.scannerTitle,
              AppImages.scanIconSvg,
              controller.currentIndex.value == 0,
            ),
          ),
          Tab(
            child: buildTabBarItem(
              Constants.recognizeTitle,
              AppImages.fileSearchIconSvg,
              controller.currentIndex.value == 1,
            ),
          ),
          Tab(
            child: buildTabBarItem(
              Constants.enhanceTitle,
              AppImages.imageEnhanceIconSvg,
              controller.currentIndex.value == 2,
            ),
          ),
        ],
      );
    }),
  );
}

Widget buildTabBarItem(String title, String icon, bool isSelected) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SizedBox(
        height: isSelected ? 26.h : 25.h,
        width: isSelected ? 26.w : 25.w,
        child: SvgPicture.asset(
          icon,
          color: isSelected ? AppColors.whiteBgColor : AppColors.brandBgColor,
        ),
      ),
      SizedBox(height: 0.h),
      Text(
        title,
        style: GoogleFonts.openSans(
          fontSize: 12.sp,
          color: isSelected ? AppColors.whiteBgColor : AppColors.brandBgColor,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
        ),
      ),
    ],
  );
}
