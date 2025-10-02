import 'package:diyar_app/feature/auth/model/login_response_model.dart';

LoginResponseModel? userModel;
Future<void> updateUserModel(LoginResponseModel? user) async {
  userModel = user;
}
