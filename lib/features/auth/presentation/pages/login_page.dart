import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flux/common/widgets/action_button.dart';
import 'package:flux/common/widgets/custom_dialogs.dart';
import 'package:flux/common/widgets/default_input.dart';
import 'package:flux/common/widgets/loading_animation.dart';
import 'package:flux/config/assets/app_images.dart';
import 'package:flux/config/theme/app_colors.dart';
import 'package:flux/features/auth/data/models/login_request.dart';
import 'package:flux/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flux/features/auth/presentation/cubit/auth_state.dart';
import 'package:flux/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:flux/features/auth/presentation/pages/register_page.dart';
import 'package:flux/features/notes/presentation/pages/notes_page.dart';
import '../../../notes/presentation/cubit/notes_cubit.dart';

final class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            CustomDialogs.showErrorDialog(context, "Sign In", state.message);
          }
          if (state is Authenticated) { _navigateToApp(context); }
        },
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            final bool isLoading = state is AuthLoading;

            return Stack(
              children: [
                ListView(
                  padding: const .only(top: 100, right: 20, left: 20, bottom: 20),
                  children: [
                    _logo(),
                    const SizedBox(height: 20),

                    _welcomeText(),
                    const SizedBox(height: 50),

                    _inputs(),

                    _forgotPasswordText(context),
                    const SizedBox(height: 20),

                    ActionButton(title: "Sign In", onTap: () => _handleLogin(context)),
                    const SizedBox(height: 20),

                    _registerText(context),
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

  //region - UI COMPONENTS
  Widget _logo() {
    return Center(
      child: ClipRRect(
        borderRadius: .circular(20),
        child: Image.asset(
          AppImages.logo,
          width: 100,
        ),
      ),
    );
  }

  Widget _welcomeText() {
    return const Column(
      children: [
        Text(
          "Welcome Back!",
          style: TextStyle(
            fontSize: 20,
            fontWeight: .bold,
          ),
          textAlign: .center,
        ),

        Text(
          "Sign in to access your notes",
          style: TextStyle(
            fontSize: 14,
          ),
          textAlign: .center,
        ),
      ],
    );
  }

  Widget _inputs() {
    return Column(
      children: [
        DefaultInput(title: "Email", controller: _emailController, hint: "email@example.com"),
        const SizedBox(height: 12),

        DefaultInput(title: "Password", controller: _passwordController, hint: "******", isPassword: true),
      ],
    );
  }

  Widget _forgotPasswordText(BuildContext context) {
    return Row(
      mainAxisAlignment: .end,
      children: [
        CupertinoButton(
          padding: .zero,
          onPressed: () => _navigateToForgotPassword(context),
          child: const Text(
            "Forgot Password",
            style: TextStyle(
              fontSize: 14,
              fontWeight: .w500,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _registerText(BuildContext context) {
    final theme = Theme.of(context);
    return RichText(
      textAlign: .center,
      text: TextSpan(
        text: "Don't have an account? ",
        style: TextStyle(
          fontSize: 12,
          color: theme.textTheme.bodyMedium?.color,
        ),
        children: <TextSpan>[
          TextSpan(
            text: 'Sign Up',
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: .bold,
            ),
            recognizer: TapGestureRecognizer()..onTap = () => _navigateToRegisterPage(context),
          ),
        ],
      ),
    );
  }
  //endregion

  //region - FUNCTIONS
  void _handleLogin(BuildContext context) {
    final request = LoginRequest(email: _emailController.text, password: _passwordController.text);
    context.read<AuthCubit>().signIn(request);
  }
  
  void _navigateToRegisterPage(BuildContext context) {
    final authCubit = BlocProvider.of<AuthCubit>(context);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: authCubit,
          child: RegisterPage(),
        ),
      ),
    );
  }

  void _navigateToApp(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => NotesCubit()..getNotesFromRemote(),
          child: const NotesPage(),
        ),
      ),
        (dynamic routes) => false,
    );
  }

  void _navigateToForgotPassword(BuildContext context) {
    final authCubit = BlocProvider.of<AuthCubit>(context);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: authCubit,
          child: ForgotPasswordPage(),
        ),
      ),
    );
  }
  //endregion
}
