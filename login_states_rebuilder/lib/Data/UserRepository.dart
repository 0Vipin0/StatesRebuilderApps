import 'Model/User.dart';

abstract class UserRepository {
  Future<bool> verifyUser(String name, String password);
  Future<bool> addUser(String name, String password);
  User findUser(String name, String password);
  User findUserByID(String userId);
}

class FakeUserRepository implements UserRepository {
  List<User> _user = [
    User("1","Vipin", "123456"),
  ];

  @override
  Future<bool> verifyUser(String name, String password) {
    return Future.delayed(Duration(seconds: 2), () {
      return _user.firstWhere((user) => user.name == name && user.password == password, orElse: ()=> null) != null
          ? true
          : false;
    });
  }

  @override
  Future<bool> addUser(String name, String password) {
    return Future.delayed(Duration(seconds: 2), () {
      User newUser = User(DateTime.now().toIso8601String(),name, password);
      try {
        _user.add(newUser);
        newUser.toString();
        return true;
      } catch (error) {
        print(error);
        return false;
      }
    });
  }

  @override
  User findUser(String name, String password){
    return _user.firstWhere((user)=>user.name==name&&user.password==password);
  }

  @override
  User findUserByID(String userId) {
    return _user.firstWhere((user)=>user.userId==userId);
  }
}
