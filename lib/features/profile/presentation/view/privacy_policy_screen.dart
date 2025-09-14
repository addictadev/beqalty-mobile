import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/utils/styles/font_utils.dart';
import 'package:baqalty/core/utils/styles/styles.dart';
import 'package:baqalty/core/widgets/custom_appbar.dart';
import 'package:baqalty/core/widgets/bordered_button.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sizer/sizer.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColors.scaffoldBackground,
      appBar: CustomAppBar(
        title: "privacy_policy".tr(),
        titleColor: AppColors.textPrimary,
        iconColor: AppColors.textPrimary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(context.responsivePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Version Badge
              _buildVersionBadge(context),
              SizedBox(height: 2.h),

              // Title
              _buildTitle(context),
              SizedBox(height: 1.h),

              // Effective Date
              _buildEffectiveDate(context),
              SizedBox(height: 2.h),

              // Download PDF Button
              _buildDownloadButton(context),
              SizedBox(height: 3.h),

              // Introduction
              _buildIntroduction(context),
              SizedBox(height: 2.h),

              // Information We Collect Section
              _buildInformationWeCollect(context),
              SizedBox(height: 2.h),

              // How We Use Information Section
              _buildHowWeUseInformation(context),
              SizedBox(height: 2.h),

              // Data Security Section
              _buildDataSecurity(context),
              SizedBox(height: 2.h),

              // Your Rights Section
              _buildYourRights(context),
              SizedBox(height: 2.h),

              // Contact Us Section
              _buildContactUs(context),
              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVersionBadge(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
        decoration: BoxDecoration(
          color: AppColors.textLight.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          "v2.5.2",
          style: TextStyles.textViewRegular12.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Center(
      child: Text(
        "privacy_policy".tr(),
        style: TextStyles.textViewBold24.copyWith(
          color: AppColors.textPrimary,
          fontSize: FontSizes.s24,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildEffectiveDate(BuildContext context) {
    return Center(
      child: Text(
        "effective_date".tr(),
        style: TextStyles.textViewRegular14.copyWith(
          color: AppColors.textSecondary,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildDownloadButton(BuildContext context) {
    return Center(
      child: BorderedButton(
        text: "download_as_pdf".tr(),
        onPressed: _downloadPDF,
        textColor: AppColors.textPrimary,
        borderColor: AppColors.primary.withValues(alpha: 0.3),
        borderRadius: 25,
        height: 50,
        textStyle: TextStyles.textViewMedium16.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
        icon: Icons.download,
      ),
    );
  }

  Widget _buildIntroduction(BuildContext context) {
    return _buildContentSection(
      context,
      content: "privacy_policy_intro".tr(),
    );
  }

  Widget _buildInformationWeCollect(BuildContext context) {
    return _buildSection(
      context,
      title: "information_we_collect".tr(),
      content: "information_we_collect_intro".tr(),
      items: [
        "personal_information_desc".tr(),
        "financial_data_desc".tr(),
      ],
    );
  }

  Widget _buildHowWeUseInformation(BuildContext context) {
    return _buildSection(
      context,
      title: "how_we_use_information".tr(),
      content: "how_we_use_information_intro".tr(),
      items: [
        "service_provision_desc".tr(),
        "communication_desc".tr(),
        "improvement_desc".tr(),
      ],
    );
  }

  Widget _buildDataSecurity(BuildContext context) {
    return _buildSection(
      context,
      title: "data_security".tr(),
      content: "data_security_desc".tr(),
    );
  }

  Widget _buildYourRights(BuildContext context) {
    return _buildSection(
      context,
      title: "your_rights".tr(),
      content: "your_rights_intro".tr(),
      items: [
        "access_data_desc".tr(),
        "correct_data_desc".tr(),
        "delete_data_desc".tr(),
        "portability_desc".tr(),
      ],
    );
  }

  Widget _buildContactUs(BuildContext context) {
    return _buildContentSection(
      context,
      content: "contact_us_desc".tr(),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required String content,
    List<String>? items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyles.textViewBold18.copyWith(
            color: AppColors.textPrimary,
            fontSize: FontSizes.s18,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          content,
          style: TextStyles.textViewRegular14.copyWith(
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
        if (items != null) ...[
          SizedBox(height: 1.h),
          ...items.map((item) => _buildBulletPoint(context, item)),
        ],
      ],
    );
  }

  Widget _buildContentSection(BuildContext context, {required String content}) {
    return Text(
      content,
      style: TextStyles.textViewRegular14.copyWith(
        color: AppColors.textSecondary,
        height: 1.5,
      ),
    );
  }

  Widget _buildBulletPoint(BuildContext context, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 0.5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 0.5.h, right: 1.w),
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.textSecondary,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyles.textViewRegular14.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _downloadPDF() {
    // TODO: Implement PDF download functionality
    debugPrint('Download PDF tapped');
  }
}
