import 'package:flutter/material.dart';
import '../navigation_services/navigation_manager.dart';

/// A smart back button that provides options for app control
/// Shows a dialog with options to minimize to background or close app
class SmartBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget? child;
  final Color? color;
  final double? size;

  const SmartBackButton({
    super.key,
    this.onPressed,
    this.child,
    this.color,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed ?? () => _handleBackPress(context),
      icon: child ?? Icon(Icons.arrow_back, color: color, size: size),
    );
  }

  void _handleBackPress(BuildContext context) {
    // Check if we can pop the current route
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      // If we're at the root, show exit dialog
      NavigationManager.showExitDialog(context);
    }
  }
}

/// A simple back button that moves app to background when at root
class BackgroundBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget? child;
  final Color? color;
  final double? size;

  const BackgroundBackButton({
    super.key,
    this.onPressed,
    this.child,
    this.color,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed ?? () => _handleBackPress(context),
      icon: child ?? Icon(Icons.arrow_back, color: color, size: size),
    );
  }

  void _handleBackPress(BuildContext context) {
    // Check if we can pop the current route
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      // If we're at the root, move to background
      NavigationManager.moveToBackground();
    }
  }
}

/// A floating action button for quick app control
class AppControlFAB extends StatelessWidget {
  final bool showBackgroundOption;
  final bool showExitOption;

  const AppControlFAB({
    super.key,
    this.showBackgroundOption = true,
    this.showExitOption = true,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _showControlDialog(context),
      tooltip: 'App Control',
      child: Icon(Icons.more_vert),
    );
  }

  void _showControlDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showBackgroundOption)
                ListTile(
                  leading: Icon(Icons.minimize),
                  title: Text('Minimize to Background'),
                  subtitle: Text('Keep app running in background'),
                  onTap: () {
                    Navigator.of(context).pop();
                    NavigationManager.moveToBackground();
                  },
                ),
              if (showExitOption)
                ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text('Close App'),
                  subtitle: Text('Completely close the application'),
                  onTap: () {
                    Navigator.of(context).pop();
                    NavigationManager.exitApp();
                  },
                ),
              ListTile(
                leading: Icon(Icons.cancel),
                title: Text('Cancel'),
                onTap: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
    );
  }
}
