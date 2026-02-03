import 'package:flux/core/helpers/dio_helper.dart';
import 'package:flux/features/splash/cubit/splash_state.dart';

final class SplashController {

  SplashDelegate? delegate;

  Future<void> checkCurrentUser() async {
    final token = await DioHelper.getToken();
    if(token == null) {
      delegate?.notify(SplashFailed());
    } else {
      delegate?.notify(SplashSuccess());
    }
  }

}

mixin SplashDelegate {
  void notify(SplashState state);
}