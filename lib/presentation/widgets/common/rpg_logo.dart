import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Logo do RPG reutilizável
class RPGLogo extends StatelessWidget {
  final double size;
  final Color? color;
  final Color? iconColor;

  final String? svgAsset;

  const RPGLogo({
    super.key,
    this.size = 64.0,
    this.color,
    this.iconColor,
    this.svgAsset,
  });

  @override
  Widget build(BuildContext context) {
    final Color effectiveIconColor = iconColor ?? AppColors.success;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: color != null ? null : AppColors.primaryGradient,
        color: color,
        border: Border.all(color: iconColor ?? AppColors.success, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowDark,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: svgAsset != null
            ? SvgPicture.asset(
                svgAsset!,
                width: size * 0.6,
                height: size * 0.6,
                // Força a cor no SVG (funciona mesmo se o SVG tiver fill)
                colorFilter: ColorFilter.mode(
                  effectiveIconColor,
                  BlendMode.srcIn,
                ),
                // Se o seu SVG usa 'currentColor' no fill/stroke, poderia usar:
                // color: effectiveIconColor, // (para versões antigas do pacote)
              )
            : Icon(
                Icons.casino_rounded,
                size: size * 0.6,
                color: effectiveIconColor,
              ),
      ),
    );
  }
}
