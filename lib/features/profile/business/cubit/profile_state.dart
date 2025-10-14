part of 'profile_cubit.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

final class ProfileInitial extends ProfileState {}

final class ProfileLoading extends ProfileState {}

final class ProfileLoaded extends ProfileState {
  final AddressesResponseModel addresses;

  const ProfileLoaded({required this.addresses});
}

final class ProfileError extends ProfileState {
  final String message;

  const ProfileError({required this.message});
}

final class AddAddressLoading extends ProfileState {}

final class AddAddressLoaded extends ProfileState {
  final AddressModel address;

  const AddAddressLoaded({required this.address});
}

final class AddAddressError extends ProfileState {
  final String message;

  const AddAddressError({required this.message});
}