import 'package:flutter/material.dart';
import '/core/app_export.dart';

class AppDecoration {
  // Fill decorations
  static BoxDecoration get fillBlueGray => BoxDecoration(
        color: appTheme.blueGray50,
      );
  static BoxDecoration get fillDeepPurple => BoxDecoration(
        color: appTheme.deepPurple300,
      );
  static BoxDecoration get fillGray => BoxDecoration(
        color: appTheme.gray200,
      );
  static BoxDecoration get fillGray30002 => BoxDecoration(
        color: appTheme.gray30002,
      );
  static BoxDecoration get fillOrange => BoxDecoration(
        color: appTheme.orange600,
      );
  static BoxDecoration get fillPrimary => BoxDecoration(
        color: theme.colorScheme.primary,
      );
  static BoxDecoration get fillPrimaryContainer => BoxDecoration(
        color: theme.colorScheme.primaryContainer,
      );
  static BoxDecoration get fillRed => BoxDecoration(
        color: appTheme.red100,
      );
  static BoxDecoration get fillYellow => BoxDecoration(
        color: appTheme.yellow100,
      );

  static BoxDecoration get fillGreen => BoxDecoration(
        color: appTheme.green600,
      );

  static BoxDecoration get fillOnPrimary => BoxDecoration(
        color: theme.colorScheme.onPrimary,
      );

  // Gradient decorations
  static BoxDecoration get gradientDeepPurpleToBlue => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.46, 0),
          end: Alignment(0.6, 0.63),
          colors: [
            appTheme.deepPurple300,
            appTheme.blue100,
          ],
        ),
      );
  static BoxDecoration get gradientDeepPurpleToPink => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.5, 0.03),
          end: Alignment(0.65, 0.56),
          colors: [
            appTheme.deepPurple300,
            appTheme.pink50,
          ],
        ),
      );
  static BoxDecoration get gradientPinkToBlueGray => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.73, 0.23),
          end: Alignment(0.43, 1.55),
          colors: [
            appTheme.pink50,
            appTheme.blueGray30001,
          ],
        ),
      );
  static BoxDecoration get gradientPrimaryToOrange => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.54, 0.06),
          end: Alignment(0.67, 1.3),
          colors: [
            theme.colorScheme.primary,
            appTheme.red200,
            appTheme.orange300,
          ],
        ),
      );
  static BoxDecoration get gradientPrimaryToPurple => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.6, -1.44),
          end: Alignment(0.21, 1.59),
          colors: [
            theme.colorScheme.primary,
            appTheme.purple300,
          ],
        ),
      );

  // Outline decorations
  static BoxDecoration get outlineDeepOrange => BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        border: Border.all(
          color: appTheme.deepOrange300,
          width: 1.h,
        ),
      );
  static BoxDecoration get outlineGray => BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        border: Border(
          bottom: BorderSide(
            color: appTheme.gray200,
            width: 1.h,
          ),
        ),
      );
}

class BorderRadiusStyle {
  // Custom borders
  static BorderRadius get customBorderBL8 => BorderRadius.vertical(
        bottom: Radius.circular(8.h),
      );
  static BorderRadius get customBorderTL16 => BorderRadius.vertical(
        top: Radius.circular(16.h),
      );
  static BorderRadius get customBorderTL4 => BorderRadius.horizontal(
        left: Radius.circular(4.h),
      );

  // Rounded borders
  static BorderRadius get roundedBorder12 => BorderRadius.circular(
        12.h,
      );
  static BorderRadius get roundedBorder5 => BorderRadius.circular(
        5.h,
      );
  static BorderRadius get roundedBorder8 => BorderRadius.circular(
        8.h,
      );
}

// Comment/Uncomment the below code based on your Flutter SDK version.

// For Flutter SDK Version 3.7.2 or greater.

double get strokeAlignInside => BorderSide.strokeAlignInside;

double get strokeAlignCenter => BorderSide.strokeAlignCenter;

double get strokeAlignOutside => BorderSide.strokeAlignOutside;

// For Flutter SDK Version 3.7.1 or less.

// StrokeAlign get strokeAlignInside => StrokeAlign.inside;
//
// StrokeAlign get strokeAlignCenter => StrokeAlign.center;
//
// StrokeAlign get strokeAlignOutside => StrokeAlign.outside;
