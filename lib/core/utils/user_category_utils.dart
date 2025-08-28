import '../di/service_locator.dart';
import '../services/shared_preferences_service.dart';

class UserCategoryUtils {
  static SharedPreferencesService get _sharedPreferencesService {
    return ServiceLocator.sharedPreferencesService;
  }

  /// Get the current user category
  static String? getUserCategory() {
    return _sharedPreferencesService.getUserCategory();
  }

  /// Check if the user is a company
  static bool isCompany() {
    return _sharedPreferencesService.isCompany();
  }

  /// Check if the user is an individual
  static bool isIndividual() {
    return _sharedPreferencesService.isIndividual();
  }

  /// Check if user category is set
  static bool hasUserCategory() {
    return _sharedPreferencesService.hasUserCategory();
  }

  /// Get user category display name
  static String getUserCategoryDisplayName() {
    if (isCompany()) {
      return 'Company';
    } else if (isIndividual()) {
      return 'Individual';
    }
    return 'Not Set';
  }

  /// Clear user category
  static Future<bool> clearUserCategory() async {
    return await _sharedPreferencesService.clearUserCategory();
  }
}
