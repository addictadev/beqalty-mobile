import 'dart:developer';

import 'package:baqalty/core/network/dio/dio_helper.dart';
import 'package:baqalty/core/network/end%20points/end_points.dart';
import 'package:baqalty/features/profile/data/models/addresses_response_model.dart';
import 'package:baqalty/features/profile/data/models/add_address_request_model.dart';
import 'package:baqalty/features/profile/data/models/update_address_request_model.dart';
import 'package:baqalty/features/profile/data/services/profile_services.dart';

class ProfileServicesImpl implements ProfileServices {
  @override
  Future<ApiResponse<AddressesResponseModel>> getAddresses() async {
    try {
      log('🔄 ProfileServicesImpl: Making API call to ${EndPoints.addresses}');

      final response = await DioHelper.get<AddressesResponseModel>(
        EndPoints.addresses,
        requiresAuth: true,
        fromJson: (json) {
          log('📥 ProfileServicesImpl: Raw JSON response: $json');
          try {
            final parsedResponse = AddressesResponseModel.fromJson(
              json as Map<String, dynamic>,
            );
            log(
              '✅ ProfileServicesImpl: Successfully parsed response with ${parsedResponse.data.length} addresses',
            );
            return parsedResponse;
          } catch (parseError) {
            log('❌ ProfileServicesImpl: JSON parsing error: $parseError');
            log('❌ ProfileServicesImpl: JSON data: $json');
            rethrow;
          }
        },
      );

      log(
        '📥 ProfileServicesImpl: DioHelper response status: ${response.status}',
      );
      log(
        '📥 ProfileServicesImpl: DioHelper response message: ${response.message}',
      );

      return response;
    } catch (e, stackTrace) {
      log('❌ ProfileServicesImpl: Exception occurred: $e');
      log('❌ ProfileServicesImpl: Stack trace: $stackTrace');
      return ApiResponse<AddressesResponseModel>(
        status: false,
        message: e.toString(),
      );
    }
  }

  @override
  Future<ApiResponse<AddressModel>> addAddress(
    AddAddressRequestModel request,
  ) async {
    try {
      log('🔄 ProfileServicesImpl: Request data: ${request.toFormData()}');
      final response = await DioHelper.post<AddressModel>(
        EndPoints.addresses,
        requiresAuth: true,
        data: request.toFormData(),
        fromJson: (json) => AddressModel.fromJson(json as Map<String, dynamic>),
      );
      return response;
    } catch (e, stackTrace) {
      log('❌ ProfileServicesImpl: Exception occurred in addAddress: $e');
      log('❌ ProfileServicesImpl: Stack trace: $stackTrace');
      return ApiResponse<AddressModel>(status: false, message: e.toString());
    }
  }

  @override
  Future<ApiResponse<AddressModel>> updateAddress(
    int addressId,
    UpdateAddressRequestModel request,
  ) async {
    try {
      final response = await DioHelper.post<AddressModel>(
        '${EndPoints.addresses}/$addressId',
        requiresAuth: true,
        data: request.toFormData(),
        fromJson: (json) => AddressModel.fromJson(json as Map<String, dynamic>),
      );
      return response;
    } catch (e, stackTrace) {
      log('❌ ProfileServicesImpl: Exception occurred in updateAddress: $e');
      log('❌ ProfileServicesImpl: Stack trace: $stackTrace');
      return ApiResponse<AddressModel>(status: false, message: e.toString());
    }
  }

  @override
  Future<ApiResponse<void>> deleteAddress(int addressId) async {
    try {
      log(
        '🔄 ProfileServicesImpl: Making DELETE request for address $addressId',
      );

      final response = await DioHelper.delete<void>(
        '${EndPoints.addresses}/$addressId',
        requiresAuth: true,
        fromJson: (json) {
          log(
            '📥 ProfileServicesImpl: Raw JSON response for delete address: $json',
          );
          // DELETE requests typically return void or success message
          return;
        },
      );

      log(
        '📥 ProfileServicesImpl: Delete address response status: ${response.status}',
      );
      log(
        '📥 ProfileServicesImpl: Delete address response message: ${response.message}',
      );

      return response;
    } catch (e, stackTrace) {
      log('❌ ProfileServicesImpl: Exception occurred in deleteAddress: $e');
      log('❌ ProfileServicesImpl: Stack trace: $stackTrace');
      return ApiResponse<void>(status: false, message: e.toString());
    }
  }
}
