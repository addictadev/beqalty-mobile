import 'user_registration_model.dart';
import 'address_model.dart';

class RegistrationDataModel {
  final UserRegistrationModel userData;
  final AddressModel addressData;

  RegistrationDataModel({required this.userData, required this.addressData});

  bool get isRegistrationComplete {
    return userData.toJson().isNotEmpty && addressData.toJson().isNotEmpty;
  }

  Map<String, dynamic> toRegistrationJson() {
    // Create a flat structure by combining user and address data
    final Map<String, dynamic> flatJson = {};

    // Add user data fields
    flatJson.addAll(userData.toJson());

    // Add address data fields
    flatJson.addAll(addressData.toJson());

    return flatJson;
  }

  RegistrationDataModel copyWith({
    UserRegistrationModel? userData,
    AddressModel? addressData,
  }) {
    return RegistrationDataModel(
      userData: userData ?? this.userData,
      addressData: addressData ?? this.addressData,
    );
  }
}
