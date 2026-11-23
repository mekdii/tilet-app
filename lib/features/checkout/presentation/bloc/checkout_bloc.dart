import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tilet/features/checkout/presentation/bloc/checkout_event.dart';
import 'package:tilet/features/checkout/presentation/bloc/checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  CheckoutBloc({required int subtotal})
    : super(CheckoutState(subtotal: subtotal)) {
    on<CheckoutDeliveryChanged>(_onDeliveryChanged);
    on<CheckoutPaymentChanged>(_onPaymentChanged);
    on<CheckoutSubmitted>(_onSubmitted);
  }

  void _onDeliveryChanged(
    CheckoutDeliveryChanged event,
    Emitter<CheckoutState> emit,
  ) {
    emit(state.copyWith(deliveryMethod: event.method));
  }

  void _onPaymentChanged(
    CheckoutPaymentChanged event,
    Emitter<CheckoutState> emit,
  ) {
    emit(state.copyWith(paymentProvider: event.provider));
  }

  Future<void> _onSubmitted(
    CheckoutSubmitted event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(state.copyWith(status: CheckoutStatus.loading));

    try {
      await Future.delayed(const Duration(seconds: 1));

      emit(state.copyWith(status: CheckoutStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          status: CheckoutStatus.failure,
          errorMessage: 'Payment failed. Please try again.',
        ),
      );
    }
  }
}
