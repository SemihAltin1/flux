import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flux/common/widgets/custom_dialogs.dart';
import 'package:flux/common/widgets/default_app_bar.dart';
import 'package:flux/features/settings/data/models/update_password_request.dart';

import '../../../../common/widgets/action_button.dart';
import '../../../../common/widgets/default_input.dart';
import '../../../../common/widgets/loading_animation.dart';
import '../cubit/settings_cubit.dart';
import '../cubit/settings_state.dart';

final class UpdatePasswordPage extends StatelessWidget {
  UpdatePasswordPage({super.key});

  final _currentPassword = TextEditingController();
  final _newPassword = TextEditingController();
  final _newPasswordConfirmation = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsCubit,SettingsState>(
      listener: (context,state){
        if (state is SettingsOperationSuccess) {
          CustomDialogs.showSuccessDialog(context, "Settings", "Your password has been updated successfully");
        }
      },
      child: BlocBuilder<SettingsCubit,SettingsState>(
        builder: (context,state) {
          return Stack(
            children: [
              Scaffold(
                appBar: defaultAppBar(title: "Update Password"),
                body: ListView(
                  padding: const .all(20),
                  children: [
                    _description(),
                    const SizedBox(height: 20),

                    _inputs(),
                    const SizedBox(height: 20),

                    ActionButton(title: "Update", onTap: ()=>_handleUpdate(context)),
                  ],
                ),
              ),

              if(state is SettingsLoading)
                const LoadingAnimation()
            ],
          );
        },
      ),
    );
  }

  Widget _description() {
    return const Text("Update your password to keep your account secure. Please enter your new password below.");
  }
  Widget _inputs() {
    return Column(
      children: [
        DefaultInput(title: "Current Password", controller: _currentPassword, hint: "Enter your current password", isPassword: true),
        const SizedBox(height: 12),

        DefaultInput(title: "New Password", controller: _newPassword, hint: "Enter your new password", isPassword: true),
        const SizedBox(height: 12),

        DefaultInput(title: "Confirmation", controller: _newPasswordConfirmation, hint: "Confirm your new password", isPassword: true),
      ],
    );
  }

  void _handleUpdate(BuildContext context) {
    final request = UpdatePasswordRequest(currentPassword: _currentPassword.text, newPassword: _newPassword.text, newPasswordConfirmation: _newPasswordConfirmation.text);
    context.read<SettingsCubit>().updatePassword(request);
  }

}
