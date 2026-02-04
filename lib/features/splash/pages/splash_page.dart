import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flux/config/assets/app_images.dart';
import 'package:flux/config/theme/app_colors.dart';
import 'package:flux/core/constants/constants.dart';
import 'package:flux/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flux/features/auth/presentation/pages/login_page.dart';
import 'package:flux/features/splash/cubit/splash_controller.dart';
import 'package:flux/features/splash/cubit/splash_state.dart';
import '../../notes/presentation/cubit/notes_cubit.dart';
import '../../notes/presentation/pages/notes_page.dart';

final class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

final class _SplashPageState extends State<SplashPage> with SplashDelegate {
  final _controller = SplashController();

  @override
  void initState() {
    super.initState();
    _controller.delegate = this;
    _controller.checkCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: .bottomCenter,
        children: [
          Center(
            child: Column(
              mainAxisAlignment: .center,
              spacing: 20,
              children: [
                ClipRRect(
                  borderRadius: .circular(20),
                  child: Image.asset(
                    AppImages.logo,
                    width: 100,
                    height: 100,
                  ),
                ),
                const CircularProgressIndicator(color: AppColors.primary),
              ],
            ),
          ),

          Padding(
            padding: const .only(bottom: 40),
            child: Text(
              "AppVersion: $appVersion",
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToApp() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => NotesCubit()..syncNotes(),
          child: const NotesPage(),
        ),
      ),
          (dynamic) => false,
    );
  }

  void _navigateToLogin() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => AuthCubit(),
          child: LoginPage(),
        ),
      ),
      (dynamic routes) => false,
    );
  }

  @override
  void notify(SplashState state) {
    switch(state) {
      case SplashSuccess():
        _navigateToApp();
      case SplashFailed():
        _navigateToLogin();
    }
  }

}
