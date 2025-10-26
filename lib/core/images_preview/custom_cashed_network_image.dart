import 'package:baqalty/core/images_preview/app_assets.dart';
import 'package:baqalty/core/images_preview/custom_asset_img.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sizer/sizer.dart';

class CustomCachedImage extends StatelessWidget {
  const CustomCachedImage({
    super.key,
    required this.imageUrl,
    this.width = 100.0,
    this.height = 100.0,
    this.alignment,
    this.isBaseURL = false,
    this.fit = BoxFit.cover,
    this.memCacheWidth,
    this.memCacheHeight,
    this.maxWidthDiskCache,
    this.maxHeightDiskCache,
    this.useOldImageOnUrlChange = false,
    this.fadeInDuration = const Duration(milliseconds: 300),
    this.errorWidget,
    this.placeholderWidget,
    this.enableDebugLogging = false,
  });

  final String imageUrl;
  final double width;
  final double height;
  final Alignment? alignment;
  final BoxFit fit;
  final bool isBaseURL;
  final int? memCacheWidth;
  final int? memCacheHeight;
  final int? maxWidthDiskCache;
  final int? maxHeightDiskCache;
  final bool useOldImageOnUrlChange;
  final Duration fadeInDuration;
  final Widget? errorWidget;
  final Widget? placeholderWidget;
  final bool enableDebugLogging;

  @override
  Widget build(BuildContext context) {
    // Validate image URL
    if (imageUrl.isEmpty) {
      debugPrint('CustomCachedImage: Empty image URL provided');
      return _buildErrorWidget();
    }

    // Log URL details for debugging
    if (enableDebugLogging) {
      _logUrlIssues(imageUrl);
    }

    // Check if URL is valid
    final uri = Uri.tryParse(imageUrl);
    if (uri == null || !uri.hasAbsolutePath) {
      debugPrint('CustomCachedImage: Invalid URL format: $imageUrl');
      return _buildErrorWidget();
    }

    return RepaintBoundary(
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        alignment: alignment ?? Alignment.center,
        fit: fit,
        memCacheHeight: memCacheHeight ?? 400,
        memCacheWidth: memCacheWidth ?? 400,
        maxHeightDiskCache: maxHeightDiskCache ?? 800,
        maxWidthDiskCache: maxWidthDiskCache ?? 800,
        useOldImageOnUrlChange: useOldImageOnUrlChange,
        fadeInDuration: fadeInDuration,
        placeholder: (context, url) => placeholderWidget ?? _buildPlaceholder(),
        errorWidget: (context, url, error) {
          // Debug information for troubleshooting
          debugPrint('CustomCachedImage Error: $error');
          debugPrint('CustomCachedImage URL: $url');
          debugPrint('CustomCachedImage Error Type: ${error.runtimeType}');
          return errorWidget ?? _buildErrorWidget();
        },
        imageBuilder: (context, imageProvider) => Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2.w),
            image: DecorationImage(image: imageProvider, fit: fit),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Skeletonizer(
      enabled: true,
      containersColor: Colors.grey.shade300,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(2.w),
        child: Container(
          width: width,
          height: height,
          color: Colors.grey.shade300,
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: 
      Image.asset(
         AppAssets.appIcon,
        width: width,
        height: height,
      ),
    );
  }

  /// Helper method to validate and log URL issues
  void _logUrlIssues(String url) {
    debugPrint('=== CustomCachedImage Debug Info ===');
    debugPrint('URL: $url');
    debugPrint('URL Length: ${url.length}');
    debugPrint('URL Starts with http: ${url.startsWith('http')}');
    debugPrint('URL Starts with https: ${url.startsWith('https')}');
    debugPrint('URL Contains spaces: ${url.contains(' ')}');
    debugPrint('URL Contains newlines: ${url.contains('\n')}');
    debugPrint('=====================================');
  }
}
