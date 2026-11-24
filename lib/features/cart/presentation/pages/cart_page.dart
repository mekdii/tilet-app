import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tilet/core/theme/app_colors.dart';
import 'package:tilet/core/widgets/textile_footer.dart';
import 'package:tilet/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:tilet/features/cart/presentation/bloc/cart_event.dart';
import 'package:tilet/features/cart/presentation/bloc/cart_state.dart';
import 'package:tilet/features/cart/presentation/bloc/widgets/cart_checkout_bar.dart';
import 'package:tilet/features/cart/presentation/bloc/widgets/cart_item_tile.dart';
import 'package:tilet/features/cart/presentation/bloc/widgets/promo_code_bar.dart';
import 'package:tilet/features/checkout/presentation/pages/checkout_page.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.forest,
            body: Column(
              children: [
                // Deep Forest Green Header
                SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 8, 18, 18),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.arrow_back,
                            color: AppColors.cream,
                          ),
                        ),
                        const Text(
                          'My Bag',
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
                            '${state.totalItems} ${state.totalItems == 1 ? 'item' : 'items'}',
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
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(32),
                      ),
                    ),
                    child: state.items.isEmpty
                        ? const Center(
                            child: Text(
                              'Your bag is empty',
                              style: TextStyle(
                                color: AppColors.muted,
                                fontSize: 16,
                              ),
                            ),
                          )
                        : ListView(
                            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                            children: [
                              for (int i = 0; i < state.items.length; i++) ...[
                                CartItemTile(
                                  item: state.items[i],
                                  onIncrement: () =>
                                      context.read<CartBloc>().add(
                                        CartQuantityChanged(
                                          productId: state.items[i].product.id,
                                          size: state.items[i].size,
                                          delta: 1,
                                        ),
                                      ),
                                  onDecrement: () =>
                                      context.read<CartBloc>().add(
                                        CartQuantityChanged(
                                          productId: state.items[i].product.id,
                                          size: state.items[i].size,
                                          delta: -1,
                                        ),
                                      ),
                                  onRemove: () => context.read<CartBloc>().add(
                                    CartItemRemoved(
                                      productId: state.items[i].product.id,
                                      size: state.items[i].size,
                                    ),
                                  ),
                                ),
                                const Divider(color: AppColors.line, height: 1),
                              ],
                              const SizedBox(height: 22),
                              PromoCodeBar(
                                onApply: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      backgroundColor: AppColors.forest,
                                      content: Text('Promo code applied!'),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
            bottomNavigationBar: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CartCheckoutBar(
                  formattedTotal: state.formattedTotal,
                  enabled: state.items.isNotEmpty,
                  onCheckout: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CheckoutPage()),
                  ),
                ),
                const TextileFooter(height: 36),
              ],
            ),
          );
        },
      ),
    );
  }
}
