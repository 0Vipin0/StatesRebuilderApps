import '../Data/Model/User.dart';
import '../Data/UserRepository.dart';

class UserStore {
  UserRepository _userRepository;
  UserStore(this._userRepository);

  bool _isVerified;
  bool get isVerified => _isVerified;

  bool _isAdded;
  bool get isAdded => _isAdded;

  Future<void> verifyUser(String name, String password) async {
    _isVerified = await _userRepository.verifyUser(name, password);
  }

  Future<void> addUser(String name, String password) async {
    _isAdded = await _userRepository.addUser(name, password);
  }

  User findUser(String name, String password){
    return _userRepository.findUser(name, password);
  }

  User findUserById(String userId){
    return _userRepository.findUserByID(userId);
  }
}
