import 'package:equatable/equatable.dart';

class SaveCartRequestModel extends Equatable {
  final String name;

  const SaveCartRequestModel({
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }

  Map<String, dynamic> toFormData() {
    return {
      'name': name,
    };
  }

  @override
  List<Object?> get props => [name];
}
