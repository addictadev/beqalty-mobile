import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:baqalty/features/orders/data/models/order_details_response_model.dart';
import 'package:baqalty/features/orders/data/services/order_details_service.dart';

part 'order_details_state.dart';

class OrderDetailsCubit extends Cubit<OrderDetailsState> {
  final OrderDetailsService _orderDetailsService;

  OrderDetailsCubit(this._orderDetailsService) : super(OrderDetailsInitial());

  Future<void> getOrderDetails(int orderId) async {
    emit(OrderDetailsLoading());
    
    try {
      final response = await _orderDetailsService.getOrderDetails(orderId);
      emit(OrderDetailsLoaded(orderDetails: response.data));
    } catch (e) {
      emit(OrderDetailsError(message: e.toString()));
    }
  }

  void resetState() {
    emit(OrderDetailsInitial());
  }
}
