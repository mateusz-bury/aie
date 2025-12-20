class RegisterModel {
  final String email;
  final String password;
  final String confirmPassword;
  final String firstName;
  final String lastName;
  final String userName;
  final int roleId;

  RegisterModel({
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.roleId,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'confirmPassword': confirmPassword,
      'firstName': firstName,
      'lastName': lastName,
      'userName': userName,
      'roleId': roleId,
    };
  }

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      confirmPassword: json['confirmPassword'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      userName: json['userName'] ?? '',
      roleId: json['roleId'] ?? 0,
    );
  }
}
