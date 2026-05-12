import 'package:flutter/material.dart';

/// A utility class that provides responsive scaling for mobile and tablet devices.
/// 
/// Base design width is 375px (standard mobile). On tablets (width >= 600),
/// dimensions scale up proportionally so the UI looks well-proportioned.
class ResponsiveHelper {
  static double _screenWidth = 375.0;
  static double _screenHeight = 812.0;
  static double _shortestSide = 375.0;

  /// Initialize with the current BuildContext. Call once in the app's root builder.
  static void init(BuildContext context) {
    final size = MediaQuery.of(context).size;
    _screenWidth = size.width;
    _screenHeight = size.height;
    _shortestSide = size.shortestSide;
  }

  static double get screenWidth => _screenWidth;
  static double get screenHeight => _screenHeight;

  /// Whether the device is a tablet (shortest side >= 600).
  static bool get isTablet => _shortestSide >= 600;

  /// Base design width for scaling calculations.
  static const double _baseWidth = 375.0;

  /// General scale factor based on screen width vs base design width.
  static double get _scaleFactor {
    double factor = _screenWidth / _baseWidth;
    // Clamp the scale factor to prevent overly large scaling on very wide screens
    return factor.clamp(1.0, 1.8);
  }

  /// Font scale factor — slightly reduced on tablets to avoid oversized text.
  static double get _fontScale {
    if (isTablet) {
      return (_screenWidth / _baseWidth * 0.78).clamp(1.0, 1.45);
    }
    return 1.0;
  }

  /// Scale a font size value.
  static double fontSize(double size) => size * _fontScale;

  /// Scale a height value.
  static double height(double h) => h * _scaleFactor;

  /// Scale a width value.
  static double width(double w) => w * _scaleFactor;

  /// Scale a padding/margin value.
  static double padding(double p) {
    if (isTablet) {
      return p * (_scaleFactor * 0.85);
    }
    return p;
  }

  /// Scale a border radius value.
  static double radius(double r) {
    if (isTablet) {
      return r * (_scaleFactor * 0.8);
    }
    return r;
  }

  /// Scale an icon size.
  static double iconSize(double s) => s * _fontScale;

  /// Max content width for form-heavy pages on tablets.
  /// Returns null on phones so no constraint is applied.
  static double? get maxContentWidth => isTablet ? 550.0 : null;

  /// Symmetric horizontal padding that adapts to screen width.
  static double get horizontalPadding {
    if (isTablet) {
      return (_screenWidth - 550) / 2;
    }
    return 20.0;
  }

  /// Scale a SizedBox spacing value.
  static double space(double s) {
    if (isTablet) {
      return s * (_scaleFactor * 0.75);
    }
    return s;
  }
}
