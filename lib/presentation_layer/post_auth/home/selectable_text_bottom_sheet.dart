import 'package:chatgpt/service_layer/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectableTextBottomSheet extends StatelessWidget {
  const SelectableTextBottomSheet(
    this.text, {
    super.key,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(15.r),
      color: themeService.state.primaryBackgroundColor,
      child: Container(
        height: 0.9.sh,
        padding: EdgeInsets.symmetric(
          horizontal: 25.w,
          vertical: 15.h,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Select Text',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: themeService.state.primaryTextColor,
                      fontSize: 20.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                InkWell(
                  onTap: navigationService.pop,
                  child: Icon(
                    Icons.cancel,
                    size: 25.r,
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.h),
            Expanded(
              child: SingleChildScrollView(
                child: SelectableText(
                  text,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: themeService.state.primaryTextColor,
                    fontSize: 17.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
