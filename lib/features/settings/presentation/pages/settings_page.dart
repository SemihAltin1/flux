import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flux/common/widgets/custom_dialogs.dart';
import 'package:flux/common/widgets/default_app_bar.dart';
import 'package:flux/common/widgets/loading_animation.dart';
import 'package:flux/config/assets/app_icons.dart';
import 'package:flux/config/theme/app_colors.dart';
import 'package:flux/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:flux/features/settings/presentation/cubit/settings_state.dart';
import 'package:flux/features/settings/presentation/pages/delete_account_page.dart';
import 'package:flux/features/settings/presentation/pages/privacy_policy_page.dart';
import 'package:flux/features/settings/presentation/pages/update_password_page.dart';
import 'package:flux/features/settings/presentation/pages/update_profile_page.dart';
import 'package:flux/features/splash/pages/splash_page.dart';

final class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsCubit, SettingsState>(
      listener: (context,state) {
        if(state is SignedOut) {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const SplashPage()), (dynamic rotes) => false);
        }
        if(state is SettingsError) {
          CustomDialogs.showErrorDialog(context, "Settings", state.message);
        }
      },
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          return Stack(
            children: [
              Scaffold(
                appBar: defaultAppBar(title: "Settings"),
                body: _menu(context),
              ),

              if(state is SettingsLoading)
                const LoadingAnimation()
            ],
          );
        },
      ),
    );
  }

  Widget _menu(BuildContext context) {
    return Padding(
      padding: const .all(20),
      child: Column(
        children: [
          _menuItem(context, "Update Profile", AppIcons.user, UpdateProfilePage()),
          _menuItem(context, "Update Password", AppIcons.lock, UpdatePasswordPage()),
          _menuItem(context, "Delete Account", AppIcons.trash, const DeleteAccountPage()),
          _menuItem(context, "Privacy Policy", AppIcons.shield, const PrivacyPolicyPage()),
          _logoutButton(context),
        ],
      ),
    );
  }

  Widget _menuItem(BuildContext context, String title, String icon, Widget target) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        final authCubit = BlocProvider.of<SettingsCubit>(context);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: authCubit,
              child: target,
            ),
          ),
        );
      },
      child: Container(
        height: 45,
        padding: const .symmetric(horizontal: 10),
        margin: const .only(bottom: 10),
        decoration: BoxDecoration(
          color: theme.cardColor,
          border: .all(width: 1, color: theme.dividerColor),
          borderRadius: .circular(10),
        ),
        child: Row(
          spacing: 5,
          children: [
            ImageIcon(
              AssetImage(icon),
              color: AppColors.primary,
            ),
      
            Expanded(
              child: Text(
                title,
                overflow: .ellipsis,
              ),
            ),
      
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey)
          ],
        ),
      ),
    );
  }

  Widget _logoutButton(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        context.read<SettingsCubit>().signOut();
      },
      child: Container(
        height: 45,
        padding: const .symmetric(horizontal: 10),
        margin: const .only(bottom: 10),
        decoration: BoxDecoration(
          color: theme.cardColor,
          border: .all(width: 1, color: theme.dividerColor),
          borderRadius: .circular(10),
        ),
        child: Row(
          spacing: 5,
          children: [
            ImageIcon(
              AssetImage(AppIcons.signOut),
              color: AppColors.primary,
            ),

            const Expanded(
              child: Text(
                "Sign Out",
                overflow: .ellipsis,
              ),
            ),

            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey)
          ],
        ),
      ),
    );
  }
}
