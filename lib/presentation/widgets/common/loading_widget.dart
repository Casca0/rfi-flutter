import 'package:flutter/material.dart';

/// Widget de loading reutilizável
class LoadingWidget extends StatelessWidget {
  final Color? color;
  final double size;

  const LoadingWidget({super.key, this.color, this.size = 32.0});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        color: color ?? Theme.of(context).colorScheme.primary,
        strokeWidth: 3.0,
      ),
    );
  }
}
