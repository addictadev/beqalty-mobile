import 'package:equatable/equatable.dart';
import 'package:baqalty/features/wallet/data/models/wallet_transactions_response_model.dart';

abstract class WalletState extends Equatable {
  const WalletState();

  @override
  List<Object> get props => [];
}

class WalletInitial extends WalletState {}

class WalletLoading extends WalletState {}

class WalletLoaded extends WalletState {
  final WalletTransactionsDataModel walletData;

  const WalletLoaded({required this.walletData});

  @override
  List<Object> get props => [walletData];
}

class WalletError extends WalletState {
  final String message;

  const WalletError({required this.message});

  @override
  List<Object> get props => [message];
}
