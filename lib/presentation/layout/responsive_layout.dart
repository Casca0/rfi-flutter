import 'package:flutter/widgets.dart';
import '../../core/utils/responsive_utils.dart';

/// Widget utilitário para alternar entre layouts conforme o tamanho da tela.
class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    super.key,
    required this.mobile,
    Widget? tablet,
    required this.desktop,
  }) : _tablet = tablet ?? desktop;

  final Widget mobile;
  final Widget desktop;
  final Widget _tablet;

  @override
  Widget build(BuildContext context) {
    if (context.isMobile) {
      return mobile;
    }

    if (context.isTablet) {
      return _tablet;
    }

    return desktop;
  }
}
