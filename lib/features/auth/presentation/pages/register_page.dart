import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flux/common/widgets/action_button.dart';
import 'package:flux/common/widgets/default_app_bar.dart';
import '../../../../common/widgets/default_input.dart';
import '../../../../common/widgets/loading_animation.dart';
import '../../../notes/presentation/cubit/notes_cubit.dart';
import '../../../notes/presentation/pages/notes_page.dart';
import '../../data/models/register_request.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

final class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) { _navigateToApp(context); }
      },
      builder: (context, state) {
        final bool isLoading = state is AuthLoading;

        return Stack(
          children: [
            Scaffold(
              appBar: defaultAppBar(title: "Sign Up"),
              body: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _welcomeText(),
                  const SizedBox(height: 50),
                  _inputs(),
                  const SizedBox(height: 20),

                  ActionButton(
                    title: "Sign Up",
                    onTap: () => _onSignUpTap(context),
                  ),
                ],
              ),
            ),

            if(isLoading)
              const LoadingAnimation()
          ],
        );
      },
    );
  }

  Widget _welcomeText() {
    return const Column(
      children: [
        Text(
          "Create Account",
          style: TextStyle(
            fontSize: 20,
            fontWeight: .bold,
          ),
          textAlign: .center,
        ),

        Text(
          "Get started in just a few seconds",
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
        DefaultInput(title: "First name", controller: _firstNameController, hint: "Enter your first name"),
        const SizedBox(height: 12),

        DefaultInput(title: "Last name", controller: _lastNameController, hint: "Enter your last name"),
        const SizedBox(height: 12),

        DefaultInput(title: "Email", controller: _emailController, hint: "email@example.com"),
        const SizedBox(height: 12),

        DefaultInput(title: "Password", controller: _passwordController, hint: "******", isPassword: true),
      ],
    );
  }

  void _onSignUpTap(BuildContext context) {
    final request = RegisterRequest(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      email: _emailController.text,
      password: _passwordController.text,
    );
    context.read<AuthCubit>().signUp(request);
  }

  void _navigateToApp(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => NotesCubit()..fetchNotesFromLocal(),
          child: const NotesPage(),
        ),
      ),
        (dynamic routes) => false,
    );
  }
  
}
