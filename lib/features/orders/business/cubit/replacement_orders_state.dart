import 'package:equatable/equatable.dart';
import 'package:baqalty/features/orders/data/models/replacement_order_model.dart';

abstract class ReplacementOrdersState extends Equatable {
  const ReplacementOrdersState();

  @override
  List<Object?> get props => [];
}

class ReplacementOrdersInitial extends ReplacementOrdersState {}

class ReplacementOrdersLoading extends ReplacementOrdersState {}

class ReplacementOrdersLoaded extends ReplacementOrdersState {
  final List<ReplacementOrderModel> replacementOrders;

  const ReplacementOrdersLoaded({required this.replacementOrders});

  @override
  List<Object?> get props => [replacementOrders];
}

class ReplacementOrdersError extends ReplacementOrdersState {
  final String message;

  const ReplacementOrdersError({required this.message});

  @override
  List<Object?> get props => [message];
}
