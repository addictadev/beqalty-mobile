class SplashConfigModel {
  final bool isTestMode;
  final String testStoreVersion;
  final int splashDuration;
  final bool enableUpdateCheck;
  final bool enableLogging;

  const SplashConfigModel({
    this.isTestMode = true,
    this.testStoreVersion = '2.0.0',
    this.splashDuration = 500,
    this.enableUpdateCheck = true,
    this.enableLogging = true,
  });

  SplashConfigModel copyWith({
    bool? isTestMode,
    String? testStoreVersion,
    int? splashDuration,
    bool? enableUpdateCheck,
    bool? enableLogging,
  }) {
    return SplashConfigModel(
      isTestMode: isTestMode ?? this.isTestMode,
      testStoreVersion: testStoreVersion ?? this.testStoreVersion,
      splashDuration: splashDuration ?? this.splashDuration,
      enableUpdateCheck: enableUpdateCheck ?? this.enableUpdateCheck,
      enableLogging: enableLogging ?? this.enableLogging,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isTestMode': isTestMode,
      'testStoreVersion': testStoreVersion,
      'splashDuration': splashDuration,
      'enableUpdateCheck': enableUpdateCheck,
      'enableLogging': enableLogging,
    };
  }

  factory SplashConfigModel.fromJson(Map<String, dynamic> json) {
    return SplashConfigModel(
      isTestMode: json['isTestMode'] ?? true,
      testStoreVersion: json['testStoreVersion'] ?? '2.0.0',
      splashDuration: json['splashDuration'] ?? 500,
      enableUpdateCheck: json['enableUpdateCheck'] ?? true,
      enableLogging: json['enableLogging'] ?? true,
    );
  }

  @override
  String toString() {
    return 'SplashConfigModel(isTestMode: $isTestMode, testStoreVersion: $testStoreVersion, splashDuration: $splashDuration, enableUpdateCheck: $enableUpdateCheck, enableLogging: $enableLogging)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SplashConfigModel &&
        other.isTestMode == isTestMode &&
        other.testStoreVersion == testStoreVersion &&
        other.splashDuration == splashDuration &&
        other.enableUpdateCheck == enableUpdateCheck &&
        other.enableLogging == enableLogging;
  }

  @override
  int get hashCode {
    return isTestMode.hashCode ^
        testStoreVersion.hashCode ^
        splashDuration.hashCode ^
        enableUpdateCheck.hashCode ^
        enableLogging.hashCode;
  }
}
