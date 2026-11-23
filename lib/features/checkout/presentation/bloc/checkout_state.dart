import 'package:equatable/equatable.dart';

enum DeliveryMethod { standard, express }

enum PaymentProvider { chapa, stripe }

enum CheckoutStatus { initial, loading, success, failure }

class CheckoutState extends Equatable {
  const CheckoutState({
    required this.subtotal,
    this.deliveryMethod = DeliveryMethod.standard,
    this.paymentProvider = PaymentProvider.chapa,
    this.status = CheckoutStatus.initial,
    this.city = 'Bole, Addis Ababa',
    this.addressLine = 'Cameroon St, House 14 • +251 911 234 567',
    this.errorMessage,
  });

  final int subtotal;
  final DeliveryMethod deliveryMethod;
  final PaymentProvider paymentProvider;
  final CheckoutStatus status;
  final String city;
  final String addressLine;
  final String? errorMessage;

  int get deliveryFee => deliveryMethod == DeliveryMethod.express ? 250 : 0;

  int get total => subtotal + deliveryFee;

  String _formatEtb(int amount) {
    final formatted = amount.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]},',
        );
    return 'ETB $formatted';
  }

  String get formattedSubtotal => _formatEtb(subtotal);
  String get formattedDelivery =>
      deliveryFee == 0 ? 'Free' : _formatEtb(deliveryFee);
  String get formattedTotal => _formatEtb(total);

  CheckoutState copyWith({
    DeliveryMethod? deliveryMethod,
    PaymentProvider? paymentProvider,
    CheckoutStatus? status,
    String? city,
    String? addressLine,
    String? errorMessage,
  }) {
    return CheckoutState(
      subtotal: subtotal,
      deliveryMethod: deliveryMethod ?? this.deliveryMethod,
      paymentProvider: paymentProvider ?? this.paymentProvider,
      status: status ?? this.status,
      city: city ?? this.city,
      addressLine: addressLine ?? this.addressLine,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        subtotal,
        deliveryMethod,
        paymentProvider,
        status,
        city,
        addressLine,
        errorMessage,
      ];
}