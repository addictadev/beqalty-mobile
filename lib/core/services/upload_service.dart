import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../utils/custom_new_toast.dart';

class UploadService {
  static final ImagePicker _imagePicker = ImagePicker();

  static const List<String> _supportedImageExtensions = [
    'jpg',
    'jpeg',
    'png',
    'bmp',
    'webp',
    'tiff',
    'tif',
  ];

  static const List<String> _supportedFileExtensions = [
    'pdf',
    'doc',
    'docx',
    'txt',
    'rtf',
    'odt',
    'xls',
    'xlsx',
    'csv',
    'ods',
    'ppt',
    'pptx',
    'odp',
    'zip',
    'rar',
    '7z',
    'tar',
    'gz',
  ];

  static const int _maxImageSize = 10 * 1024 * 1024;
  static const int _maxFileSize = 50 * 1024 * 1024;

  static Future<File?> pickImageFromCamera() async {
    try {
      final status = await Permission.camera.request();
      if (status != PermissionStatus.granted) {
        ToastHelper.showErrorToast(
          'camera_permission_denied'.tr(),
          title: 'permission_required'.tr(),
        );
        return null;
      }

      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (image != null) {
        final file = File(image.path);
        return await _validateAndProcessImage(file);
      }
      return null;
    } catch (e) {
      ToastHelper.showErrorToast('camera_error'.tr(), title: 'error'.tr());
      return null;
    }
  }

  static Future<File?> pickImageFromGallery() async {
    try {
      final status = await Permission.storage.request();
      if (status != PermissionStatus.granted) {
        ToastHelper.showErrorToast(
          'storage_permission_denied'.tr(),
          title: 'permission_required'.tr(),
        );
        return null;
      }

      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (image != null) {
        final file = File(image.path);
        return await _validateAndProcessImage(file);
      }
      return null;
    } catch (e) {
      ToastHelper.showErrorToast('gallery_error'.tr(), title: 'error'.tr());
      return null;
    }
  }

  static Future<File?> pickFile() async {
    try {
      final status = await Permission.storage.request();
      if (status != PermissionStatus.granted) {
        ToastHelper.showErrorToast(
          'storage_permission_denied'.tr(),
          title: 'permission_required'.tr(),
        );
        return null;
      }

      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          ..._supportedImageExtensions,
          ..._supportedFileExtensions,
        ],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = File(result.files.first.path!);
        return await _validateAndProcessFile(file);
      }
      return null;
    } catch (e) {
      ToastHelper.showErrorToast('file_picker_error'.tr(), title: 'error'.tr());
      return null;
    }
  }

  static Future<File?> _validateAndProcessImage(File file) async {
    try {
      final fileSize = await file.length();
      if (fileSize > _maxImageSize) {
        ToastHelper.showErrorToast(
          'image_size_too_large'.tr(),
          title: 'validation_error'.tr(),
        );
        return null;
      }

      final extension = file.path.split('.').last.toLowerCase();
      if (!_supportedImageExtensions.contains(extension)) {
        ToastHelper.showErrorToast(
          'unsupported_image_format'.tr(),
          title: 'validation_error'.tr(),
        );
        return null;
      }

      final bytes = await file.openRead(0, 8).first;
      if (!_isImageFile(bytes)) {
        ToastHelper.showErrorToast(
          'invalid_image_file'.tr(),
          title: 'validation_error'.tr(),
        );
        return null;
      }

      return file;
    } catch (e) {
      ToastHelper.showErrorToast(
        'image_validation_error'.tr(),
        title: 'error'.tr(),
      );
      return null;
    }
  }

  static Future<File?> _validateAndProcessFile(File file) async {
    try {
      final fileSize = await file.length();
      if (fileSize > _maxFileSize) {
        ToastHelper.showErrorToast(
          'file_size_too_large'.tr(),
          title: 'validation_error'.tr(),
        );
        return null;
      }

      final extension = file.path.split('.').last.toLowerCase();
      if (!_supportedFileExtensions.contains(extension) &&
          !_supportedImageExtensions.contains(extension)) {
        ToastHelper.showErrorToast(
          'unsupported_file_format'.tr(),
          title: 'validation_error'.tr(),
        );
        return null;
      }

      return file;
    } catch (e) {
      ToastHelper.showErrorToast(
        'file_validation_error'.tr(),
        title: 'error'.tr(),
      );
      return null;
    }
  }

  static bool _isImageFile(List<int> bytes) {
    if (bytes.length < 2) return false;

    if (bytes[0] == 0xFF && bytes[1] == 0xD8) return true;

    if (bytes.length >= 8 &&
        bytes[0] == 0x89 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x4E &&
        bytes[3] == 0x47) {
      return true;
    }

    if (bytes.length >= 6 &&
        bytes[0] == 0x47 &&
        bytes[1] == 0x49 &&
        bytes[2] == 0x46) {
      return true;
    }

    if (bytes.length >= 2 && bytes[0] == 0x42 && bytes[1] == 0x4D) return true;

    if (bytes.length >= 12 &&
        bytes[0] == 0x52 &&
        bytes[1] == 0x49 &&
        bytes[2] == 0x46 &&
        bytes[3] == 0x54 &&
        bytes[8] == 0x57 &&
        bytes[9] == 0x45 &&
        bytes[10] == 0x42 &&
        bytes[11] == 0x50) {
      return true;
    }

    return false;
  }

  static String getFileSizeString(int bytes) {
    if (bytes < 1024) return '$bytes ${'bytes'.tr()}';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} ${'kilobytes'.tr()}';
    }
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} ${'megabytes'.tr()}';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} ${'gigabytes'.tr()}';
  }

  static String getFileExtension(String path) {
    return path.split('.').last.toLowerCase();
  }

  static bool isImageFile(String path) {
    final extension = getFileExtension(path);
    return _supportedImageExtensions.contains(extension);
  }

  static List<String> getSupportedExtensions() {
    return [..._supportedImageExtensions, ..._supportedFileExtensions];
  }

  static String getMaxFileSizeString() {
    return getFileSizeString(_maxFileSize);
  }

  static String getMaxImageSizeString() {
    return getFileSizeString(_maxImageSize);
  }
}
