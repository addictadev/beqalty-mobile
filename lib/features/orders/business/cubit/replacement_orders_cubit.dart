import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:baqalty/features/orders/data/services/replacement_orders_service.dart';
import 'package:baqalty/features/orders/business/cubit/replacement_orders_state.dart';

class ReplacementOrdersCubit extends Cubit<ReplacementOrdersState> {
  final ReplacementOrdersService _replacementOrdersService;

  ReplacementOrdersCubit(this._replacementOrdersService) : super(ReplacementOrdersInitial());

  Future<void> getReplacementOrders() async {
    try {
      emit(ReplacementOrdersLoading());
      
      final response = await _replacementOrdersService.getReplacementOrders();
      
      if (response.status && response.data != null) {
        emit(ReplacementOrdersLoaded(replacementOrders: response.data!.data));
      } else {
        emit(ReplacementOrdersError(message: response.message ?? 'Unknown error'));
      }
    } catch (e) {
      emit(ReplacementOrdersError(message: e.toString()));
    }
  }

  Future<void> selectReplacement({
    required int orderId,
    required int? replacementId, // Made nullable to support canceling
    required int orderItemId,
  }) async {
    try {
      emit(ReplacementOrdersLoading());
      
      final response = await _replacementOrdersService.selectReplacement(
        orderId: orderId,
        replacementId: replacementId,
        orderItemId: orderItemId,
      );
      
      if (response.status) {
        // Refresh the replacement orders list after successful selection
        await getReplacementOrders();
      } else {
        emit(ReplacementOrdersError(message: response.message ?? 'Unknown error'));
      }
    } catch (e) {
      emit(ReplacementOrdersError(message: e.toString()));
    }
  }

  Future<void> cancelReplacement({
    required int orderId,
    required int orderItemId,
  }) async {
    try {
      emit(ReplacementOrdersLoading());
      
      final response = await _replacementOrdersService.cancelReplacement(
        orderId: orderId,
        orderItemId: orderItemId,
      );
      
      if (response.status) {
        // Refresh the replacement orders list after successful cancellation
        await getReplacementOrders();
      } else {
        emit(ReplacementOrdersError(message: response.message ?? 'Unknown error'));
      }
    } catch (e) {
      emit(ReplacementOrdersError(message: e.toString()));
    }
  }
}
