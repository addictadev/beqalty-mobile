import 'package:equatable/equatable.dart';
import 'package:baqalty/features/rewards/data/models/loyalty_response_model.dart';
import 'package:baqalty/features/rewards/data/models/points_transactions_response_model.dart';

abstract class LoyaltyState extends Equatable {
  const LoyaltyState();

  @override
  List<Object> get props => [];
}

class LoyaltyInitial extends LoyaltyState {}

class LoyaltyLoading extends LoyaltyState {}

class LoyaltyLoaded extends LoyaltyState {
  final LoyaltyDataModel loyaltyData;

  const LoyaltyLoaded({required this.loyaltyData});

  @override
  List<Object> get props => [loyaltyData];
}

class LoyaltyTransactionsLoaded extends LoyaltyState {
  final PointsTransactionsDataModel transactionsData;

  const LoyaltyTransactionsLoaded({required this.transactionsData});

  @override
  List<Object> get props => [transactionsData];
}

class LoyaltyRedeemSuccess extends LoyaltyState {
  final String message;

  const LoyaltyRedeemSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class LoyaltyError extends LoyaltyState {
  final String message;

  const LoyaltyError({required this.message});

  @override
  List<Object> get props => [message];
}
