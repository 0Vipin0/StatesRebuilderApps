class User {
  String _userId;
  String _name;
  String _password;

  User(this._userId, this._name, this._password);

  String get userId => _userId;
  String get name => _name;
  String get password => _password;

  @override
  String toString() {
    return 'User{_userId: $_userId, _name: $_name, _password: $_password}';
  }
}
