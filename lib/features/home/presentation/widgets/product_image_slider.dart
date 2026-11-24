import 'package:flutter/material.dart';
import 'package:tilet/core/theme/app_colors.dart';
import 'package:tilet/core/widgets/product_image.dart';

class ProductImageSlider extends StatefulWidget {
  const ProductImageSlider({
    super.key,
    required this.images,
    required this.isFavorite,
    required this.onBackTap,
    required this.onFavoriteTap,
    this.height = 430,
  });

  final List<String> images;
  final bool isFavorite;
  final VoidCallback onBackTap;
  final VoidCallback onFavoriteTap;
  final double height;

  @override
  State<ProductImageSlider> createState() => _ProductImageSliderState();
}

class _ProductImageSliderState extends State<ProductImageSlider> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Sliding Image Gallery
          PageView.builder(
            controller: _controller,
            itemCount: widget.images.length,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemBuilder: (context, index) {
              final imageUrl = widget.images.isEmpty
                  ? ''
                  : widget.images[index];
              return ProductImage(
                imageUrl: imageUrl,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              );
              // return Image.asset(
              //   widget.images[index],
              //   fit: BoxFit.cover,
              //   alignment: Alignment.topCenter,
              // );
            },
          ),

          // Subtle top gradient so status bar icons stay readable
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 110,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black.withOpacity(0.45), Colors.transparent],
                ),
              ),
            ),
          ),

          // Floating Back & Favorite Buttons
          Positioned(
            top: 0,
            left: 16,
            right: 16,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _CircleGlassButton(
                      icon: Icons.arrow_back,
                      color: AppColors.ink,
                      onTap: widget.onBackTap,
                    ),
                    _CircleGlassButton(
                      icon: widget.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: widget.isFavorite
                          ? Colors.redAccent
                          : AppColors.ink,
                      onTap: widget.onFavoriteTap,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Animated Dot Indicators (shown when there are 2+ images)
          if (widget.images.length > 1)
            Positioned(
              left: 0,
              right: 0,
              bottom: 42,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.images.length, (index) {
                  final active = index == _currentIndex;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 7,
                    width: active ? 22 : 7,
                    decoration: BoxDecoration(
                      color: active
                          ? AppColors.goldLight
                          : Colors.white.withOpacity(0.75),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }
}

class _CircleGlassButton extends StatelessWidget {
  const _CircleGlassButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        width: 44,
        decoration: BoxDecoration(
          color: AppColors.cream.withOpacity(0.82),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 22),
      ),
    );
  }
}
