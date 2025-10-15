import 'package:baqalty/core/navigation_services/navigation_manager.dart';
import 'package:baqalty/features/profile/business/cubit/profile_cubit.dart';
import 'package:baqalty/features/profile/data/models/addresses_response_model.dart';
import 'package:baqalty/features/profile/presentation/view/addresses_shimmer_view.dart';
import 'package:baqalty/features/profile/presentation/view/add_address_screen.dart';
import 'package:baqalty/core/widgets/custom_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/utils/styles/styles.dart';
import 'package:baqalty/core/widgets/custom_appbar.dart';
import 'package:baqalty/core/widgets/custom_back_button.dart';
import 'package:baqalty/core/widgets/primary_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:iconsax/iconsax.dart';

class AddressesScreen extends StatelessWidget {
  const AddressesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit()..getAddresses(),
      child: const AddressesScreenBody(),
    );
  }
}

class AddressesScreenBody extends StatefulWidget {
  const AddressesScreenBody({super.key});

  @override
  State<AddressesScreenBody> createState() => _AddressesScreenBodyState();
}

class _AddressesScreenBodyState extends State<AddressesScreenBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "my_addresses".tr(),
        titleColor: AppColors.textPrimary,
        iconColor: AppColors.textPrimary,
        leading: CustomBackButton(),
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is GetAddressesLoading) {
            return _buildLoadingState();
          }

          if (state is GetAddressesError) {
            return _buildErrorState(context, state.message);
          }

          if (state is GetAddressesLoaded) {
            return _buildLoadedState(context, state.addresses);
          }

          return _buildLoadingState();
        },
      ),
      floatingActionButton: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is GetAddressesLoaded && state.addresses.isNotEmpty) {
            return FloatingActionButton(
              onPressed: () =>
                  NavigationManager.navigateTo(const AddAddressScreen()),
              backgroundColor: AppColors.primary,
              child: Icon(
                Iconsax.add,
                color: AppColors.white,
                size: context.responsiveIconSize * 1.2,
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return const AddressesShimmerView();
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Container(
        margin: EdgeInsets.all(context.responsivePadding * 2),
        child: CustomErrorWidget(
          message: message,
          onRetry: () {
            context.read<ProfileCubit>().getAddresses();
          },
        ),
      ),
    );
  }

  Widget _buildLoadedState(BuildContext context, List<AddressModel> addresses) {
    if (addresses.isEmpty) {
      return _buildEmptyState(context);
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<ProfileCubit>().getAddresses();
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 100),
        child: ListView.builder(
          padding: EdgeInsets.all(context.responsivePadding),
          itemCount: addresses.length,
          itemBuilder: (context, index) {
            final address = addresses[index];
            return _buildAddressCard(context, address);
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.responsivePadding * 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: context.responsiveIconSize * 4,
              height: context.responsiveIconSize * 4,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Iconsax.location,
                size: context.responsiveIconSize * 2,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: context.responsiveMargin * 2),
            Text(
              "no_addresses_found".tr(),
              style: TextStyles.textViewBold18.copyWith(
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: context.responsiveMargin),
            Text(
              "add_your_first_address".tr(),
              style: TextStyles.textViewRegular14.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: context.responsiveMargin * 3),
            PrimaryButton(
              text: "add_address".tr(),
              onPressed: () =>
                  NavigationManager.navigateTo(const AddAddressScreen()),
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressCard(BuildContext context, AddressModel address) {
    return Container(
      margin: EdgeInsets.only(bottom: context.responsiveMargin),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(context.responsiveBorderRadius),
        border: address.isDefault
            ? Border.all(color: AppColors.primary, width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.all(context.responsivePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(context.responsivePadding * 0.5),
                    decoration: BoxDecoration(
                      color: _getAddressTypeColor(
                        address.addressType,
                      ).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getAddressTypeIcon(address.addressType),
                      size: context.responsiveIconSize,
                      color: _getAddressTypeColor(address.addressType),
                    ),
                  ),
                  SizedBox(width: context.responsiveMargin),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              address.title,
                              style: TextStyles.textViewSemiBold16.copyWith(
                                color: AppColors.textPrimary,
                              ),
                            ),
                            if (address.isDefault) ...[
                              SizedBox(width: context.responsiveMargin * 0.5),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: context.responsivePadding * 0.5,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  "default".tr(),
                                  style: TextStyles.textViewRegular10.copyWith(
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        SizedBox(height: context.responsiveMargin * 0.5),
                        Text(
                          address.fullAddress,
                          style: TextStyles.textViewRegular14.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) => _handleAddressAction(value, address),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(
                              Iconsax.edit,
                              size: 16,
                              color: AppColors.textSecondary,
                            ),
                            SizedBox(width: 8),
                            Text("edit".tr()),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'set_default',
                        enabled: !address.isDefault,
                        child: Row(
                          children: [
                            Icon(
                              Iconsax.star,
                              size: 16,
                              color: AppColors.textSecondary,
                            ),
                            SizedBox(width: 8),
                            Text("set_as_default".tr()),
                          ],
                        ),
                      ),
                      // PopupMenuItem(
                      //   value: 'delete',
                      //   child: Row(
                      //     children: [
                      //       Icon(
                      //         Iconsax.trash,
                      //         size: 16,
                      //         color: AppColors.error,
                      //       ),
                      //       SizedBox(width: 8),
                      //       Text(
                      //         "delete".tr(),
                      //         style: TextStyle(color: AppColors.error),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                    child: Icon(
                      Iconsax.more,
                      color: AppColors.textSecondary,
                      size: context.responsiveIconSize,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleAddressAction(String action, AddressModel address) {
    switch (action) {
      case 'edit':
        _navigateToEditAddress(context, address);
        break;
      case 'set_default':
        _setAddressAsDefault(context, address);
        break;
      case 'delete':
        _deleteAddress(context, address);
        break;
    }
  }

  IconData _getAddressTypeIcon(AddressType type) {
    switch (type) {
      case AddressType.home:
        return Iconsax.home;
      case AddressType.work:
        return Iconsax.building;
      case AddressType.other:
        return Iconsax.location;
    }
  }

  Color _getAddressTypeColor(AddressType type) {
    switch (type) {
      case AddressType.home:
        return AppColors.primary;
      case AddressType.work:
        return AppColors.warning;
      case AddressType.other:
        return AppColors.textSecondary;
    }
  }

  void _navigateToEditAddress(BuildContext context, AddressModel address) {
    NavigationManager.navigateTo(
      AddAddressScreen(isEdit: true, addressToEdit: address),
    );
  }

  void _setAddressAsDefault(BuildContext context, AddressModel address) {
    final profileCubit = context.read<ProfileCubit>();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text("set_as_default".tr()),
        content: Text(
          "set_default_confirmation".tr().replaceAll(
            '{address}',
            address.title,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text("cancel".tr()),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);

              profileCubit.setAddressAsDefault(address);
            },
            child: Text(
              "confirm".tr(),
              style: TextStyle(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  void _deleteAddress(BuildContext context, AddressModel address) {
    final profileCubit = context.read<ProfileCubit>();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text("delete_address".tr()),
        content: Text(
          "delete_address_confirmation".tr().replaceAll(
            '{address}',
            address.title,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text("cancel".tr()),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              profileCubit.deleteAddress(address.id);
            },
            child: Text(
              "delete".tr(),
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
