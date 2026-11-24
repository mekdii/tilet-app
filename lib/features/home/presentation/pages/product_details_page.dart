import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tilet/core/theme/app_colors.dart';
import 'package:tilet/core/widgets/textile_footer.dart';
import 'package:tilet/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:tilet/features/cart/presentation/bloc/cart_event.dart';
import 'package:tilet/features/home/data/models/product_model.dart';
import 'package:tilet/features/home/presentation/widgets/product_image_slider.dart';
import 'package:tilet/features/home/presentation/widgets/size_selector.dart';

class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({super.key, required this.product});

  final ProductModel product;

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  static const _sizes = ['S', 'M', 'L', 'XL', 'Custom Fit'];
  String _selectedSize = 'M';
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.product.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.cream,
        body: SingleChildScrollView(
          child: Stack(
            children: [
              // Top Full-Bleed Sliding Gallery
              ProductImageSlider(
                images: product.images,
                isFavorite: _isFavorite,
                onBackTap: () => Navigator.pop(context),
                onFavoriteTap: () => setState(() => _isFavorite = !_isFavorite),
              ),

              // Rounded Cream Details Sheet overlapping the bottom of the slider
              Container(
                margin: const EdgeInsets.only(top: 400),
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(22, 26, 22, 24),
                decoration: const BoxDecoration(
                  color: AppColors.cream,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title & Rating
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            product.title,
                            style: const TextStyle(
                              color: AppColors.forest,
                              fontSize: 25,
                              height: 1.15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: AppColors.star,
                                size: 18,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                product.rating,
                                style: const TextStyle(
                                  fontFamily: 'Arial',
                                  color: AppColors.ink,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Price
                    Text(
                      product.price,
                      style: const TextStyle(
                        fontFamily: 'Arial',
                        color: AppColors.ink,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 22),

                    // Size Selector
                    const Text(
                      'Select Size',
                      style: TextStyle(
                        fontFamily: 'Arial',
                        color: AppColors.ink,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizeSelector(
                      sizes: _sizes,
                      selectedSize: _selectedSize,
                      onSelected: (size) =>
                          setState(() => _selectedSize = size),
                    ),
                    const SizedBox(height: 24),

                    // Details Description
                    const Text(
                      'Details',
                      style: TextStyle(
                        fontFamily: 'Arial',
                        color: AppColors.ink,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product.description,
                      style: const TextStyle(
                        fontFamily: 'Arial',
                        color: AppColors.muted,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Sticky Add to Bag Bar + Tilet Footer
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: AppColors.cream,
              padding: const EdgeInsets.fromLTRB(22, 10, 22, 12),
              child: SizedBox(
                height: 54,
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    context.read<CartBloc>().add(
                      CartItemAdded(product: product, size: _selectedSize),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: AppColors.forest,
                        content: Text(
                          'Added ${product.title} ($_selectedSize) to your bag',
                          style: const TextStyle(fontFamily: 'Arial'),
                        ),
                      ),
                    );
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.forest,
                    foregroundColor: AppColors.goldLight,
                    side: const BorderSide(
                      color: AppColors.goldBorder,
                      width: 1.2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: const Text(
                    'Add to Bag',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            const TextileFooter(height: 36),
          ],
        ),
      ),
    );
  }
}
