import 'package:flutter/widgets.dart';
import '../constants/app_breakpoints.dart';

extension ResponsiveContext on BuildContext {
  /// Retorna a largura atual da tela.
  double get screenWidth => MediaQuery.sizeOf(this).width;

  /// Indica se o layout atual deve ser tratado como mobile.
  bool get isMobile => screenWidth <= AppBreakpoints.mobileMax;

  /// Indica se o layout atual deve ser tratado como tablet.
  bool get isTablet =>
      screenWidth > AppBreakpoints.mobileMax &&
      screenWidth <= AppBreakpoints.tabletMax;

  /// Indica se o layout atual deve ser tratado como desktop.
  bool get isDesktop => screenWidth > AppBreakpoints.tabletMax;
}
