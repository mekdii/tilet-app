import 'package:equatable/equatable.dart';
import 'package:tilet/features/checkout/presentation/bloc/checkout_state.dart';

sealed class CheckoutEvent extends Equatable {
  const CheckoutEvent();

  @override
  List<Object?> get props => [];
}

final class CheckoutDeliveryChanged extends CheckoutEvent {
  const CheckoutDeliveryChanged(this.method);
  final DeliveryMethod method;

  @override
  List<Object?> get props => [method];
}

final class CheckoutPaymentChanged extends CheckoutEvent {
  const CheckoutPaymentChanged(this.provider);
  final PaymentProvider provider;

  @override
  List<Object?> get props => [provider];
}

final class CheckoutSubmitted extends CheckoutEvent {
  const CheckoutSubmitted();
}


final class CheckoutAddressUpdated extends CheckoutEvent {
  const CheckoutAddressUpdated({
    required this.city,
    required this.addressLine,
  });

  final String city;
  final String addressLine;

  @override
  List<Object?> get props => [city, addressLine];
}