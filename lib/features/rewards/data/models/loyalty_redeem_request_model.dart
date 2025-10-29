import 'package:equatable/equatable.dart';

class LoyaltyRedeemRequestModel extends Equatable {
  final int loyaltyPointId;

  const LoyaltyRedeemRequestModel({
    required this.loyaltyPointId,
  });

  Map<String, dynamic> toJson() {
    return {
      'loyalty_point_id': loyaltyPointId,
    };
  }

  @override
  List<Object?> get props => [loyaltyPointId];
}
