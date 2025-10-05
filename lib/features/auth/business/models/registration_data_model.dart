import 'user_registration_model.dart';
import 'address_model.dart';

class RegistrationDataModel {
  final UserRegistrationModel? userData;
  final AddressModel? addressData;

  const RegistrationDataModel({this.userData, this.addressData});

  RegistrationDataModel copyWith({
    UserRegistrationModel? userData,
    AddressModel? addressData,
  }) {
    return RegistrationDataModel(
      userData: userData ?? this.userData,
      addressData: addressData ?? this.addressData,
    );
  }

  bool get isUserDataComplete => userData != null;
  bool get isAddressDataComplete => addressData != null;
  bool get isRegistrationComplete =>
      isUserDataComplete && isAddressDataComplete;

  Map<String, dynamic> toRegistrationJson() {
    if (!isRegistrationComplete) {
      throw Exception('Registration data is incomplete');
    }

    return {...userData!.toJson(), ...addressData!.toJson()};
  }
}
