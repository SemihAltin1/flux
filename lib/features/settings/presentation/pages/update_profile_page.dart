import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flux/common/widgets/action_button.dart';
import 'package:flux/common/widgets/custom_dialogs.dart';
import 'package:flux/common/widgets/default_app_bar.dart';
import 'package:flux/common/widgets/default_input.dart';
import 'package:flux/common/widgets/loading_animation.dart';
import 'package:flux/features/settings/data/models/update_profile_request.dart';
import 'package:flux/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:flux/features/settings/presentation/cubit/settings_state.dart';

final class UpdateProfilePage extends StatelessWidget {
  UpdateProfilePage({super.key});

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    context.read<SettingsCubit>().getProfile();

    return BlocListener<SettingsCubit,SettingsState>(
      listener: (context,state){
        if (state is SettingsOperationSuccess) {
          CustomDialogs.showSuccessDialog(context, "Update Profile", "Your profile has been updated successfully.");
        }
        if (state is SettingsProfileLoaded) {
          _firstNameController.text = state.user.firstName ?? "";
          _lastNameController.text = state.user.lastName ?? "";
          _emailController.text = state.user.email ?? "";
        }
      },
      child: BlocBuilder<SettingsCubit,SettingsState>(
        builder: (context,state) {
          return Stack(
            children: [
              Scaffold(
                appBar: defaultAppBar(title: "Update Profile"),
                body: ListView(
                  padding: const .all(20),
                  children: [
                    _description(),
                    const SizedBox(height: 20),

                    _inputs(),
                    const SizedBox(height: 20),

                    ActionButton(title: "Update", onTap: ()=>_handeUpdate(context)),
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
    return const Text(
      "Make it yours. Customize your profile details here.",
    );
  }

  Widget _inputs() {
    return Column(
      children: [
        DefaultInput(title: "First name", controller: _firstNameController, hint: "Enter your first name"),
        const SizedBox(height: 12),

        DefaultInput(title: "Last name", controller: _lastNameController, hint: "Enter your last name"),
        const SizedBox(height: 12),

        DefaultInput(title: "Email", controller: _emailController, hint: "mail@example.com", isEnable: false),
      ],
    );
  }

  void _handeUpdate(BuildContext context) {
    final request = UpdateProfileRequest(firstName: _firstNameController.text, lastName: _lastNameController.text);
    context.read<SettingsCubit>().updateProfile(request);
  }
  
}
