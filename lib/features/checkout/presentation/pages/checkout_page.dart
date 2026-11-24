import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tilet/core/theme/app_colors.dart';
import 'package:tilet/core/widgets/textile_footer.dart';
import 'package:tilet/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:tilet/features/cart/presentation/bloc/cart_event.dart';
import 'package:tilet/features/cart/presentation/bloc/widgets/cart_checkout_bar.dart';
import 'package:tilet/features/checkout/presentation/bloc/checkout_bloc.dart';
import 'package:tilet/features/checkout/presentation/bloc/checkout_event.dart';
import 'package:tilet/features/checkout/presentation/bloc/checkout_state.dart';
import 'package:tilet/features/checkout/presentation/pages/edit_address_page.dart';
import 'package:tilet/features/checkout/presentation/widgets/delivery_speed_toggle.dart';
import 'package:tilet/features/checkout/presentation/widgets/payment_method_card.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final subtotal = context.read<CartBloc>().state.totalPrice;
    return BlocProvider(
      create: (_) => CheckoutBloc(subtotal: subtotal),
      child: const _CheckoutView(),
    );
  }
}

class _CheckoutView extends StatelessWidget {
  const _CheckoutView();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: BlocConsumer<CheckoutBloc, CheckoutState>(
        listener: (context, state) {
          if (state.status == CheckoutStatus.success) {
            context.read<CartBloc>().add(const CartCleared());
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => AlertDialog(
                backgroundColor: AppColors.cream,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                title: const Text(
                  'Order Confirmed',
                  style: TextStyle(
                    color: AppColors.forest,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: Text(
                  'Paid ${state.formattedTotal} via ${state.paymentProvider == PaymentProvider.chapa ? 'Chapa' : 'Stripe'}. Your Kemis is being prepared!',
                  style: const TextStyle(
                    fontFamily: 'Arial',
                    color: AppColors.ink,
                  ),
                ),
                actions: [
                  FilledButton(
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.forest,
                      foregroundColor: AppColors.cream,
                    ),
                    child: const Text('Back to Home'),
                  ),
                ],
              ),
            );
          } else if (state.status == CheckoutStatus.failure &&
              state.errorMessage != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          }
        },
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
                          'Checkout',
                          style: TextStyle(
                            color: AppColors.cream,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(right: 6),
                          child: Icon(
                            Icons.lock_outline_rounded,
                            color: AppColors.goldLight,
                            size: 22,
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
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(20, 22, 20, 24),
                      children: [
                        // 1. Delivery Address
                        const _SectionTitle('Delivery Address'),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.paper,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: AppColors.line),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.location_on_rounded,
                                color: AppColors.forest,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      state.city,
                                      style: const TextStyle(
                                        fontFamily: 'Arial',
                                        color: AppColors.ink,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      state.addressLine,
                                      style: const TextStyle(
                                        fontFamily: 'Arial',
                                        color: AppColors.muted,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => EditAddressPage(
                                        initialCity: state.city,
                                        initialAddressLine: state.addressLine,
                                      ),
                                    ),
                                  );

                                  if (result != null && context.mounted) {
                                    context.read<CheckoutBloc>().add(
                                      CheckoutAddressUpdated(
                                        city: result['city']!,
                                        addressLine: result['addressLine']!,
                                      ),
                                    );
                                  }
                                },
                                child: const Text(
                                  'Edit',
                                  style: TextStyle(
                                    fontFamily: 'Arial',
                                    color: AppColors.gold,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 22),

                        // 2. Delivery Speed
                        const _SectionTitle('Delivery Speed'),
                        const SizedBox(height: 10),
                        DeliverySpeedToggle(
                          selected: state.deliveryMethod,
                          onChanged: (method) => context
                              .read<CheckoutBloc>()
                              .add(CheckoutDeliveryChanged(method)),
                        ),
                        const SizedBox(height: 22),

                        // 3. Payment Method (Chapa & Stripe)
                        const _SectionTitle('Payment Method'),
                        const SizedBox(height: 10),
                        PaymentMethodCard(
                          title: 'Chapa',
                          subtitle: 'Telebirr, CBE Birr & Local Banks',
                          isSelected:
                              state.paymentProvider == PaymentProvider.chapa,
                          onTap: () => context.read<CheckoutBloc>().add(
                            const CheckoutPaymentChanged(PaymentProvider.chapa),
                          ),
                        ),
                        const SizedBox(height: 10),
                        PaymentMethodCard(
                          title: 'Stripe',
                          subtitle: 'Visa, Mastercard & International',
                          isSelected:
                              state.paymentProvider == PaymentProvider.stripe,
                          onTap: () => context.read<CheckoutBloc>().add(
                            const CheckoutPaymentChanged(
                              PaymentProvider.stripe,
                            ),
                          ),
                        ),
                        const SizedBox(height: 22),

                        // 4. Order Summary
                        const _SectionTitle('Order Summary'),
                        const SizedBox(height: 10),
                        _SummaryRow(
                          label: 'Subtotal',
                          value: state.formattedSubtotal,
                        ),
                        const Divider(color: AppColors.line, height: 18),
                        _SummaryRow(
                          label: 'Delivery',
                          value: state.formattedDelivery,
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
                  buttonLabel: 'Pay Now  ›',
                  deliveryNote: state.deliveryFee == 0
                      ? 'Free delivery'
                      : 'Express delivery',
                  isLoading: state.status == CheckoutStatus.loading,
                  onCheckout: () => context.read<CheckoutBloc>().add(
                    const CheckoutSubmitted(),
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

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.forest,
        fontSize: 17,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Arial',
            color: AppColors.muted,
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Arial',
            color: AppColors.ink,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
