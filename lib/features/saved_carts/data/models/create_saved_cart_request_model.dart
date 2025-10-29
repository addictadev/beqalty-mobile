import 'package:equatable/equatable.dart';

class CreateSavedCartRequestModel extends Equatable {
  final String name;

  const CreateSavedCartRequestModel({
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }

  @override
  List<Object?> get props => [name];
}
