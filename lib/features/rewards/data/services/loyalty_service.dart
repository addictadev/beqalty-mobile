import 'package:baqalty/core/network/dio/dio_helper.dart';
import 'package:baqalty/core/network/end points/end_points.dart';
import 'package:baqalty/features/rewards/data/models/loyalty_response_model.dart';
import 'package:baqalty/features/rewards/data/models/loyalty_redeem_request_model.dart';
import 'package:baqalty/features/rewards/data/models/loyalty_redeem_response_model.dart';
import 'package:baqalty/features/rewards/data/models/points_transactions_response_model.dart';

abstract class LoyaltyService {
  Future<ApiResponse<LoyaltyResponseModel>> getLoyaltyData();
  Future<ApiResponse<LoyaltyRedeemResponseModel>> redeemLoyaltyPoints(LoyaltyRedeemRequestModel request);
  Future<ApiResponse<PointsTransactionsResponseModel>> getPointsTransactions();
}

class LoyaltyServiceImpl implements LoyaltyService {
  @override
  Future<ApiResponse<LoyaltyResponseModel>> getLoyaltyData() async {
    try {
      final response = await DioHelper.get<Map<String, dynamic>>(
        EndPoints.loyalty,
        requiresAuth: true,
      );

      final responseModel = LoyaltyResponseModel.fromJson(response.data!);

      return ApiResponse<LoyaltyResponseModel>(
        data: responseModel,
        message: responseModel.message,
        status: responseModel.success,
        statusCode: response.statusCode ?? 200,
      );
    } catch (e) {
      throw Exception('Failed to get loyalty data: $e');
    }
  }

  @override
  Future<ApiResponse<LoyaltyRedeemResponseModel>> redeemLoyaltyPoints(LoyaltyRedeemRequestModel request) async {
    try {
      final response = await DioHelper.post<Map<String, dynamic>>(
        EndPoints.loyaltyRedeem,
        data: request.toJson(),
        requiresAuth: true,
      );

      final responseModel = LoyaltyRedeemResponseModel.fromJson(response.data!);

      return ApiResponse<LoyaltyRedeemResponseModel>(
        data: responseModel,
        message: responseModel.message,
        status: responseModel.success,
        statusCode: response.statusCode ?? 200,
      );
    } catch (e) {
      throw Exception('Failed to redeem loyalty points: $e');
    }
  }

  @override
  Future<ApiResponse<PointsTransactionsResponseModel>> getPointsTransactions() async {
    try {
      final response = await DioHelper.get<Map<String, dynamic>>(
        EndPoints.pointsTransactions,
        requiresAuth: true,
      );

      final responseModel = PointsTransactionsResponseModel.fromJson(response.data!);

      return ApiResponse<PointsTransactionsResponseModel>(
        data: responseModel,
        message: responseModel.message,
        status: responseModel.success,
        statusCode: response.statusCode ?? 200,
      );
    } catch (e) {
      throw Exception('Failed to get points transactions: $e');
    }
  }
}
