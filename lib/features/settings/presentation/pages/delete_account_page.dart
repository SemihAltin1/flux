import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flux/common/widgets/action_button.dart';
import 'package:flux/common/widgets/custom_dialogs.dart';
import 'package:flux/common/widgets/default_app_bar.dart';
import 'package:flux/features/settings/presentation/cubit/settings_cubit.dart';

final class DeleteAccountPage extends StatelessWidget {
  const DeleteAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar(title: "Delete Account"),
      body: ListView(
        padding: const .all(20),
        children: [
          _description(),
          const SizedBox(height: 20),

          ActionButton(title: "Delete Account", onTap: ()=>_handleDelete(context)),
        ],
      ),
    );
  }
  
  Widget _description() {
    return const Column(
      spacing: 5,
      crossAxisAlignment: .start,
      children: [
        Text(
          "Are you sure you want to delete your account?",
          style: TextStyle(
            fontSize: 16,
            fontWeight: .bold,
          ),
        ),

        Text(
          "Once you delete your account, all your notes and personal data will be permanently removed from both your device and our servers. This action is irreversible and you will not be able to recover your data.",
        ),
      ],
    );
  }
  void _handleDelete(BuildContext context) {
    CustomDialogs.showConfirmationDialog(
      context,
      "Delete Account",
      "Are you sure you want to delete your account?",
      "Delete",
        () => context.read<SettingsCubit>().deleteAccount(),
    );
  }
  
}
