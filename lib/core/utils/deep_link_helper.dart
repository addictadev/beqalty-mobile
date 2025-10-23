import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class DeepLinkHelper {
  // Deep link scheme for the app
  static const String appScheme = 'baqalty';
  static const String appStoreUrl = 'https://apps.apple.com/app/baqalty/id123456789'; // Replace with actual App Store URL
  static const String playStoreUrl = 'https://play.google.com/store/apps/details?id=com.baqalty.app'; // Replace with actual Play Store URL

  /// Generates a deep link for shared cart
  static String generateSharedCartLink(String sharedCartId) {
    return '$appScheme://shared-cart?id=$sharedCartId';
  }

  /// Generates a Universal Link for iOS
  static String generateUniversalLink(String sharedCartId) {
    return 'https://baqalty-back.addictaco.website/shared-cart?id=$sharedCartId';
  }

  /// Generates a web link that redirects to app or store
  static String generateWebLink(String sharedCartId) {
    return 'https://baqalty-back.addictaco.website/shared-cart-redirect.html?shared_cart_id=$sharedCartId'; // Points to your server
  }

  /// Shares cart via WhatsApp with deep link
  static Future<void> shareCartViaWhatsApp(String sharedCartUrl) async {
    final message = '''
${"share_cart_message".tr()}

$sharedCartUrl

#Baqalty #SharedCart
''';

    try {
      // Try to share via WhatsApp
      final whatsappUrl = 'whatsapp://send?text=${Uri.encodeComponent(message)}';
      final whatsappUri = Uri.parse(whatsappUrl);
      
      if (await canLaunchUrl(whatsappUri)) {
        await launchUrl(whatsappUri);
      } else {
        // Fallback to general share
        await Share.share(message);
      }
    } catch (e) {
      // Fallback to general share
      await Share.share(message);
    }
  }

  /// Shares cart via general share
  static Future<void> shareCart(String sharedCartUrl) async {
    final message = '''
${"share_cart_message".tr()}

$sharedCartUrl

#Baqalty #SharedCart
''';

    await Share.share(message);
  }

  /// Handles incoming deep link
  static Map<String, String>? parseDeepLink(String link) {
    try {
      final uri = Uri.parse(link);
      
      // Handle custom scheme deep links
      if (uri.scheme == appScheme) {
        if (uri.host == 'shared-cart') {
          // Try both 'id' and 'shared_cart_id' parameters
          final sharedCartId = uri.queryParameters['id'] ?? uri.queryParameters['shared_cart_id'];
          if (sharedCartId != null) {
            return {
              'type': 'shared-cart',
              'id': sharedCartId,
            };
          }
        }
      }
      
      // Handle API URLs that need to be converted to redirect URLs
      if (uri.scheme == 'https' && uri.host == 'baqalty-back.addictaco.website') {
        if (uri.path == '/api/v1/cart') {
          final sharedCartId = uri.queryParameters['shared_cart_id'];
          if (sharedCartId != null) {
            return {
              'type': 'shared-cart',
              'id': sharedCartId,
            };
          }
        }
      }
      
      // Handle redirect URLs
      if (uri.scheme == 'https' && uri.host == 'baqalty-back.addictaco.website') {
        if (uri.path == '/shared-cart-redirect.html' || uri.path == '/shared-cart.html') {
          final sharedCartId = uri.queryParameters['shared_cart_id'] ?? uri.queryParameters['id'];
          if (sharedCartId != null) {
            return {
              'type': 'shared-cart',
              'id': sharedCartId,
            };
          }
        }
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Converts API URL to redirect URL
  static String convertApiUrlToRedirectUrl(String apiUrl) {
    try {
      final uri = Uri.parse(apiUrl);
      if (uri.host == 'baqalty-back.addictaco.website' && uri.path == '/api/v1/cart') {
        final sharedCartId = uri.queryParameters['shared_cart_id'];
        if (sharedCartId != null) {
          return generateWebLink(sharedCartId);
        }
      }
      return apiUrl; // Return original if can't convert
    } catch (e) {
      return apiUrl; // Return original if error
    }
  }

  /// Opens app store for download
  static Future<void> openAppStore() async {
    try {
      // Try to detect platform and open appropriate store
      // For now, we'll try both and let the system handle it
      final appStoreUri = Uri.parse(appStoreUrl);
      final playStoreUri = Uri.parse(playStoreUrl);
      
      if (await canLaunchUrl(appStoreUri)) {
        await launchUrl(appStoreUri, mode: LaunchMode.externalApplication);
      } else if (await canLaunchUrl(playStoreUri)) {
        await launchUrl(playStoreUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      // Handle error
    }
  }
}
