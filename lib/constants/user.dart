class User {
  final String id;
  final String password;

  User({required this.id, required this.password});

  final List<User> detailUser = [
    User(id: 'E001', password: 'password123'),
    User(id: 'E002', password: 'securePass!'),
  ];
}
