import 'package:twitter/models/user_model.dart';
import 'package:twitter/utils/resource.dart';

abstract class BaseViewModel {
  Future<Resource<UserModel>> getUserModelById(String userId);
}
