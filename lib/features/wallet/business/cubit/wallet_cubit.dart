import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:baqalty/features/wallet/data/services/wallet_service.dart';
import 'package:baqalty/features/wallet/business/cubit/wallet_state.dart';

class WalletCubit extends Cubit<WalletState> {
  final WalletService _walletService;

  WalletCubit(this._walletService) : super(WalletInitial());

  Future<void> getWalletTransactions() async {
    try {
      emit(WalletLoading());
      
      final response = await _walletService.getWalletTransactions();
      
      if (response.status) {
        emit(WalletLoaded(walletData: response.data!.data));
      } else {
        emit(WalletError(message: response.message ?? 'Unknown error'));
      }
    } catch (e) {
      emit(WalletError(message: e.toString()));
    }
  }
}
