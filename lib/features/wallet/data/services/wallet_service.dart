import 'package:baqalty/core/network/dio/dio_helper.dart';
import 'package:baqalty/core/network/end points/end_points.dart';
import 'package:baqalty/features/wallet/data/models/wallet_transactions_response_model.dart';

abstract class WalletService {
  Future<ApiResponse<WalletTransactionsResponseModel>> getWalletTransactions();
}

class WalletServiceImpl implements WalletService {
  @override
  Future<ApiResponse<WalletTransactionsResponseModel>> getWalletTransactions() async {
    try {
      final response = await DioHelper.get<Map<String, dynamic>>(
        EndPoints.walletTransactions,
        requiresAuth: true,
      );

      final responseModel = WalletTransactionsResponseModel.fromJson(response.data!);

      return ApiResponse<WalletTransactionsResponseModel>(
        data: responseModel,
        message: responseModel.message,
        status: responseModel.success,
        statusCode: response.statusCode ?? 200,
      );
    } catch (e) {
      throw Exception('Failed to get wallet transactions: $e');
    }
  }
}
