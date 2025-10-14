import 'package:baqalty/core/network/dio/dio_helper.dart';
import 'package:baqalty/features/profile/data/models/addresses_response_model.dart';
import 'package:baqalty/features/profile/data/models/add_address_request_model.dart';
import 'package:baqalty/features/profile/data/models/update_address_request_model.dart';

abstract class ProfileServices {
  Future<ApiResponse<AddressesResponseModel>> getAddresses();
  Future<ApiResponse<AddressModel>> addAddress(AddAddressRequestModel request);
  Future<ApiResponse<AddressModel>> updateAddress(
    int addressId,
    UpdateAddressRequestModel request,
  );
  Future<ApiResponse<void>> deleteAddress(int addressId);
}
