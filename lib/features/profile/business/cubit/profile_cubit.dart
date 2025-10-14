import 'dart:developer';

import 'package:baqalty/features/profile/data/models/add_address_request_model.dart';
import 'package:baqalty/features/profile/data/models/addresses_response_model.dart';
import 'package:baqalty/features/profile/data/services/profile_services.dart';
import 'package:baqalty/features/profile/data/services/profile_services_impl.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());
  final ProfileServices _profileServices = ProfileServicesImpl();
  Future<void> getAddresses() async {
    try {
      emit(ProfileLoading());

      final response = await _profileServices.getAddresses();

      if (response.status && response.data != null) {
        emit(ProfileLoaded(addresses: response.data!));
      } else {
        log('❌ ProfileCubit: API returned error: ${response.message}');
        emit(
          ProfileError(message: response.message ?? 'Failed to load addresses'),
        );
      }
    } catch (e, stackTrace) {
      log('❌ ProfileCubit: Exception occurred: $e');
      log('❌ ProfileCubit: Stack trace: $stackTrace');
      emit(ProfileError(message: e.toString()));
    }
  }

  Future<void> addAddress(AddAddressRequestModel request) async {
    try {
      emit(AddAddressLoading());
      final response = await _profileServices.addAddress(request);
      if (response.status && response.data != null) {
        emit(AddAddressLoaded(address: response.data!));
      } else {
        log('❌ ProfileCubit: API returned error: ${response.message}');
        emit(
          AddAddressError(message: response.message ?? 'Failed to add address'),
        );
      }
    } catch (e, stackTrace) {
      log('❌ ProfileCubit: Exception occurred: $e');
      log('❌ ProfileCubit: Stack trace: $stackTrace');
      emit(ProfileError(message: e.toString()));
    }
  }
}
