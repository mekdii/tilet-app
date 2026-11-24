import 'package:flutter/material.dart';
import 'package:tilet/core/theme/app_colors.dart';

class ProductImage extends StatelessWidget {
  const ProductImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.topCenter,
    this.borderRadius,
  });

  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final AlignmentGeometry alignment;
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) {
    final Widget content = _buildImage();

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: content,
      );
    }
    return content;
  }

  Widget _buildImage() {
    if (imageUrl.isEmpty) {
      return _buildPlaceholder(Icons.image_not_supported_outlined);
    }

    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      return Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        alignment: alignment,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return SizedBox(
            width: width,
            height: height,
            child: const ColoredBox(
              color: AppColors.cream,
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.forest,
                ),
              ),
            ),
          );
        },
        errorBuilder: (_, __, ___) =>
            _buildPlaceholder(Icons.broken_image_outlined),
      );
    }

    return Image.asset(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      errorBuilder: (_, __, ___) =>
          _buildPlaceholder(Icons.broken_image_outlined),
    );
  }

  Widget _buildPlaceholder(IconData icon) {
    return SizedBox(
      width: width,
      height: height,
      child: ColoredBox(
        color: AppColors.line,
        child: Center(
          child: Icon(icon, color: AppColors.muted),
        ),
      ),
    );
  }
}