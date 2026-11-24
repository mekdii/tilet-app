import 'package:flutter/material.dart';
import 'package:tilet/core/theme/app_colors.dart';
import 'package:tilet/features/home/data/models/product_model.dart';
import 'package:tilet/features/home/presentation/widgets/product_card.dart';

class WishlistTab extends StatelessWidget {
  const WishlistTab({
    super.key,
    required this.favorites,
    required this.onProductTap,
    required this.onFavoriteTap,
    required this.onExploreTap,
  });

  final List<ProductModel> favorites;
  final ValueChanged<ProductModel> onProductTap;
  final ValueChanged<ProductModel> onFavoriteTap;
  final VoidCallback onExploreTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.forest,
      child: Column(
        children: [
          // Deep Forest Green Header
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'My Wishlist',
                    style: TextStyle(
                      color: AppColors.cream,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: AppColors.goldBorder,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      '${favorites.length} ${favorites.length == 1 ? 'item' : 'items'}',
                      style: const TextStyle(
                        fontFamily: 'Arial',
                        color: AppColors.goldLight,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Rising Warm Cream Sheet
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.cream,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: favorites.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.favorite_border_rounded,
                              size: 52,
                              color: AppColors.gold,
                            ),
                            const SizedBox(height: 14),
                            const Text(
                              'Your wishlist is empty',
                              style: TextStyle(
                                color: AppColors.forest,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Tap the heart icon on any Habesha Kemis to save it here.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Arial',
                                color: AppColors.muted,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 20),
                            FilledButton(
                              onPressed: onExploreTap,
                              style: FilledButton.styleFrom(
                                backgroundColor: AppColors.forest,
                                foregroundColor: AppColors.goldLight,
                                side: const BorderSide(
                                  color: AppColors.goldBorder,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                              ),
                              child: const Text(
                                'Explore Collection',
                                style: TextStyle(
                                  fontFamily: 'Arial',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 14,
                        crossAxisSpacing: 14,
                        childAspectRatio: 0.64,
                      ),
                      itemCount: favorites.length,
                      itemBuilder: (context, index) {
                        final product = favorites[index];
                        return ProductCard(
                          product: product,
                          onTap: () => onProductTap(product),
                          onFavoriteTap: () => onFavoriteTap(product),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}