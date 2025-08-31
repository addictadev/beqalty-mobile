import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ForceUpdateManager {
  ForceUpdateManager({
    this.isTestMode = false,
    this.testStoreVersion = '',
    this.isMandatoryUpdate = true,
    Widget Function(
      BuildContext context,
      VoidCallback onUpdateNow,
      VoidCallback? onSkip,
    )?
    customUpdateDialog,
  }) : _customUpdateDialog = customUpdateDialog;

  String _installedVersion = "";
  final bool isTestMode;
  final String testStoreVersion;
  final bool isMandatoryUpdate;

  String androidPackageName = 'com.app.raalc';
  String iosBundleId = 'com.app.raalc';
  String iosAppId = '0000000000';

  final Widget Function(
    BuildContext context,
    VoidCallback onUpdateNow,
    VoidCallback? onSkip,
  )?
  _customUpdateDialog;

  // Add a flag to prevent multiple dialog displays
  bool _isDialogShowing = false;

  Future<void> initialize() async {
    await _getInstalledVersion();
  }

  Future<void> _getInstalledVersion() async {
    try {
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      _installedVersion = packageInfo.version;
      log('Current app version: $_installedVersion');
    } catch (e) {
      log('Error getting app version: $e');
    }
  }

  Future<void> checkForUpdates(BuildContext context) async {
    // Avoid showing dialog if one is already displayed
    if (_isDialogShowing) {
      return;
    }

    if (_installedVersion.isEmpty) {
      await _getInstalledVersion();
    }

    if (Platform.isAndroid && context.mounted) {
      await _checkForUpdateAndroid(context);
    } else if (Platform.isIOS && context.mounted) {
      await _checkForUpdateIOS(context);
    }
  }

  Future<void> _checkForUpdateAndroid(BuildContext context) async {
    try {
      if (isTestMode) {
        if (_isUpdateRequired(_installedVersion, testStoreVersion)) {
          if (context.mounted) {
            _showUpdateDialog(context);
          }
        }
        return;
      }

      // For production
      final AppUpdateInfo updateInfo = await InAppUpdate.checkForUpdate();
      log('Update info: ${updateInfo.toString()}');

      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable &&
          context.mounted) {
        _showUpdateDialog(context);
      }
    } catch (e) {
      log('Error checking for Android update: $e', error: e);
    }
  }

  Future<void> _checkForUpdateIOS(BuildContext context) async {
    try {
      // In debug mode with test flag enabled
      if (isTestMode) {
        if (_isUpdateRequired(_installedVersion, testStoreVersion)) {
          if (context.mounted) {
            _showUpdateDialog(context);
          }
        }
        return;
      }

      // For production
      final Response response = await Dio().get(
        'https://itunes.apple.com/lookup?bundleId=$iosBundleId',
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.data);
        log('iTunes API response: $responseData');

        if (responseData.containsKey('results') &&
            responseData['results'] is List &&
            responseData['results'].isNotEmpty) {
          final List<dynamic> results = responseData['results'];
          final Map<String, dynamic> entry = results.first;
          final String storeVersion = entry['version'];

          log(
            'Store version: $storeVersion, Installed version: $_installedVersion',
          );

          if (_isUpdateRequired(_installedVersion, storeVersion) &&
              context.mounted) {
            _showUpdateDialog(context);
          }
        } else {
          log('No app information found in iTunes API response');
        }
      } else {
        log(
          'Failed to get app information from iTunes. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      log('Error checking for iOS update: $e', error: e);
    }
  }

  bool _isUpdateRequired(String currentVersion, String storeVersion) {
    final int installedVersionNumber = _getExtendedVersionNumber(
      currentVersion,
    );
    final int storeVersionNumber = _getExtendedVersionNumber(storeVersion);

    log(
      'Comparing versions: $currentVersion ($installedVersionNumber) vs $storeVersion ($storeVersionNumber)',
    );

    return storeVersionNumber > installedVersionNumber;
  }

  int _getExtendedVersionNumber(String version) {
    List versionParts = version.split('.');
    versionParts = versionParts.map((i) => int.parse(i)).toList();

    while (versionParts.length < 3) {
      versionParts.add(0);
    }

    return versionParts[0] * 100000 + versionParts[1] * 1000 + versionParts[2];
  }

  void _showUpdateDialog(BuildContext context) {
    // Check if context is mounted/valid first
    if (!context.mounted) {
      log('Context is not mounted, skipping update dialog');
      return;
    }

    // Set flag to prevent multiple dialogs
    _isDialogShowing = true;

    if (_customUpdateDialog != null) {
      showCupertinoDialog(
        barrierDismissible: !isMandatoryUpdate,
        context: context,
        builder: (BuildContext dialogContext) {
          // Create callbacks that handle navigation properly
          void onUpdateNow() {
            // Close dialog first, then open store
            Navigator.of(dialogContext).pop();
            _openAppStore();
          }

          void onSkip() {
            if (!isMandatoryUpdate) {
              Navigator.of(dialogContext).pop();
            }
          }

          return _customUpdateDialog(
            dialogContext,
            onUpdateNow,
            isMandatoryUpdate ? null : onSkip,
          );
        },
      ).then((_) {
        // Reset flag when dialog is closed
        _isDialogShowing = false;
      });
    } else {
      showCupertinoDialog(
        barrierDismissible: !isMandatoryUpdate,
        context: context,
        builder: (BuildContext dialogContext) {
          return _buildDefaultUpdateDialog(dialogContext);
        },
      ).then((_) {
        // Reset flag when dialog is closed
        _isDialogShowing = false;
      });
    }
  }

  Widget _buildDefaultUpdateDialog(BuildContext context) {
    return PopScope(
      canPop: isMandatoryUpdate ? false : true,
      child: AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
        ),
        title: const Text(
          'Update Available',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          isMandatoryUpdate
              ? 'A new version of the app is available. Please update to continue using the app.'
              : 'A new version of the app is available. We recommend updating for the best experience.',
        ),
        actions: [
          // Skip button only shows when update is not mandatory
          if (!isMandatoryUpdate)
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Skip'),
            ),
          ElevatedButton(
            onPressed: () {
              // Close dialog first, then open store
              Navigator.of(context).pop();
              _openAppStore();
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: const Text('Update Now'),
          ),
        ],
      ),
    );
  }

  /// Open the appropriate app store
  Future<void> _openAppStore() async {
    String url;

    if (Platform.isAndroid) {
      url = 'market://details?id=$androidPackageName';
    } else if (Platform.isIOS) {
      url = 'itms-apps://itunes.apple.com/app/$iosAppId';
    } else {
      log('Platform not supported for store navigation');
      return;
    }

    // Log the URL before attempting to open it
    log('Attempting to open store URL: $url');
    log('🔗 Store URL: $url'); // Additional print for visibility

    try {
      final Uri uri = Uri.parse(url);

      // Check if the URL can be launched before attempting
      if (await canLaunchUrl(uri)) {
        log('✅ URL can be launched, opening store...');
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        log('✅ Store opened successfully');
      } else {
        log('❌ Cannot launch primary URL, trying fallback...');
        await _launchFallbackUrl();
      }
    } catch (e) {
      log('❌ Error launching primary URL: $e');
      await _launchFallbackUrl();
    }
  }

  /// Launch fallback web URL if native store URL fails
  Future<void> _launchFallbackUrl() async {
    String fallbackUrl;

    if (Platform.isAndroid) {
      fallbackUrl =
          'https://play.google.com/store/apps/details?id=$androidPackageName';
    } else if (Platform.isIOS) {
      fallbackUrl = 'https://apps.apple.com/app/id$iosAppId';
    } else {
      log('❌ No fallback URL available for this platform');
      return;
    }

    log('🔗 Fallback URL: $fallbackUrl');
    log('🔗 Fallback URL: $fallbackUrl'); // Additional print for visibility

    try {
      final Uri fallbackUri = Uri.parse(fallbackUrl);

      if (await canLaunchUrl(fallbackUri)) {
        log('✅ Fallback URL can be launched, opening web store...');
        await launchUrl(fallbackUri, mode: LaunchMode.externalApplication);
        log('✅ Web store opened successfully');
      } else {
        log('❌ Cannot launch fallback URL either');
      }
    } catch (e) {
      log('❌ Error launching fallback URL: $e');
    }
  }
}
