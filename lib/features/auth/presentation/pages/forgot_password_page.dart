import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flux/common/widgets/action_button.dart';
import 'package:flux/common/widgets/default_app_bar.dart';
import 'package:flux/common/widgets/default_input.dart';
import 'package:flux/common/widgets/loading_animation.dart';
import 'package:flux/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flux/features/auth/presentation/cubit/auth_state.dart';

final class ForgotPasswordPage extends StatelessWidget {
  ForgotPasswordPage({super.key});

  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar(title: "Forgot Password"),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
          if (state is PasswordResetEmailSent) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("The link was sent"), backgroundColor: Colors.red),
            );
          }
        },
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            final bool isLoading = state is AuthLoading;

            return Stack(
              children: [
                ListView(
                  padding: const .all(20),
                  children: [
                    _descriptionText(),
                    const SizedBox(height: 20),

                    DefaultInput(title: "Email", controller: _emailController, hint: "email@example.com"),
                    const SizedBox(height: 20),

                    ActionButton(title: "Send", onTap: ()=>_sendButtonTapped(context)),
                  ],
                ),

                if(isLoading)
                  const LoadingAnimation()
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _descriptionText() {
    return const Text(
      "Enter your email address and we'll send you a link to reset your password.",
    );
  }
  
  void _sendButtonTapped(BuildContext context) {
    context.read<AuthCubit>().sendResetPasswordLink(_emailController.text);
  }

}
