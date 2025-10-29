import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:baqalty/features/rewards/data/services/loyalty_service.dart';
import 'package:baqalty/features/rewards/data/models/loyalty_redeem_request_model.dart';
import 'package:baqalty/features/rewards/business/cubit/loyalty_state.dart';

class LoyaltyCubit extends Cubit<LoyaltyState> {
  final LoyaltyService _loyaltyService;

  LoyaltyCubit(this._loyaltyService) : super(LoyaltyInitial());

  Future<void> getLoyaltyData() async {
    try {
      emit(LoyaltyLoading());
      
      final response = await _loyaltyService.getLoyaltyData();
      
      if (response.status) {
        emit(LoyaltyLoaded(loyaltyData: response.data!.data));
      } else {
        emit(LoyaltyError(message: response.message ?? 'Unknown error'));
      }
    } catch (e) {
      emit(LoyaltyError(message: e.toString()));
    }
  }

  Future<void> redeemLoyaltyPoints(int loyaltyPointId) async {
    try {
      emit(LoyaltyLoading());
      
      final request = LoyaltyRedeemRequestModel(loyaltyPointId: loyaltyPointId);
      final response = await _loyaltyService.redeemLoyaltyPoints(request);
      
      if (response.status) {
        // Refresh loyalty data after successful redemption
        final loyaltyResponse = await _loyaltyService.getLoyaltyData();
        if (loyaltyResponse.status) {
          emit(LoyaltyLoaded(loyaltyData: loyaltyResponse.data!.data));
        } else {
          emit(LoyaltyError(message: 'Failed to refresh data'));
        }
      } else {
        emit(LoyaltyError(message: response.message ?? 'Unknown error'));
      }
    } catch (e) {
      emit(LoyaltyError(message: e.toString()));
    }
  }

  Future<void> getPointsTransactions() async {
    try {
      emit(LoyaltyLoading());
      
      final response = await _loyaltyService.getPointsTransactions();
      
      if (response.status) {
        emit(LoyaltyTransactionsLoaded(transactionsData: response.data!.data));
      } else {
        emit(LoyaltyError(message: response.message ?? 'Unknown error'));
      }
    } catch (e) {
      emit(LoyaltyError(message: e.toString()));
    }
  }
}
