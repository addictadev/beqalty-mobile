import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'app_assets.dart';
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

  @override
  Widget build(BuildContext context) {
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
        fadeInDuration: const Duration(milliseconds: 100),
        placeholder: (context, url) => placeholderWidget ?? _buildPlaceholder(),
        errorWidget: (context, url, error) =>
            errorWidget ?? _buildErrorWidget(),
        imageBuilder: (context, imageProvider) => Container(
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
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(2.w),
        child: Image.asset(
          AppAssets.appIcon,
          width: width,
          height: height,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
