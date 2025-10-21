import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:baqalty/features/cart/data/services/shared_cart_service.dart';
import 'package:baqalty/features/cart/data/models/cart_response_model.dart';
import 'package:baqalty/features/cart/business/cubit/shared_cart_state.dart';

class SharedCartCubit extends Cubit<SharedCartState> {
  final SharedCartService _sharedCartService;

  SharedCartCubit(this._sharedCartService) : super(SharedCartInitial());

  Future<void> getSharedCart(String sharedCartId) async {
    emit(SharedCartLoading());
    
    try {
      final response = await _sharedCartService.getSharedCart(sharedCartId);
      emit(SharedCartLoaded(response.data!));
    } catch (e) {
      emit(SharedCartError(e.toString()));
    }
  }
}
