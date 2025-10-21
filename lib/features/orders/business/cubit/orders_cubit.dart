import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:baqalty/features/orders/data/models/orders_response_model.dart';
import 'package:baqalty/features/orders/data/services/orders_service.dart';

part 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final OrdersService _ordersService;

  OrdersCubit(this._ordersService) : super(OrdersInitial());

  Future<void> getAllOrders() async {
    emit(OrdersLoading());
    
    try {
      final response = await _ordersService.getAllOrders();
      emit(OrdersLoaded(orders: response.data));
    } catch (e) {
      emit(OrdersError(message: e.toString()));
    }
  }

  void resetState() {
    emit(OrdersInitial());
  }
}
