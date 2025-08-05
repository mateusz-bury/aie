class User {
  final String firstName;
  final String lastName;
  final String email;
  final String username;
  final String password;

  User({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.username,
    required this.password,
  });
}

class AuthService {
  static final List<User> _registeredUsers = [];
  static User? _currentUser;

  static bool register({
    required String firstName,
    required String lastName,
    required String email,
    required String username,
    required String password,
  }) {

    if (_registeredUsers.any((u) => u.email == email || u.username == username)) {
      return false;
    }

    final user = User(
      firstName: firstName,
      lastName: lastName,
      email: email,
      username: username,
      password: password,
    );

    _registeredUsers.add(user);
    return true;
  }

  static bool login(String loginOrEmail, String password) {
    final user = _registeredUsers.firstWhere(
      (u) =>
          (u.email == loginOrEmail || u.username == loginOrEmail) &&
          u.password == password,
      orElse: () => null as User,
    );

    if (user != null) {
      _currentUser = user;
      return true;
    }
    return false;
  }

  static User? getCurrentUser() => _currentUser;
}
