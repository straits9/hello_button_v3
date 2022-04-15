class User {
  String username;
  String name;
  Role role;
  String token;
  String? siteId;

  User({
    required this.username,
    required this.name,
    required this.role,
    required this.token,
    this.siteId,
  });

  User.fromJson(Map<String, dynamic> json)
      : username = json['id'],
        name = json['name'],
        // role = json['role'].toRole(),
        role = stringToRole(json['role']),
        token = json['token'],
        siteId = json['siteId'];

  Map<String, dynamic> toJson() => {
        'id': username,
        'name': name,
        'role': role.toString(),
        'token': token,
        'siteId': siteId
      };

  @override
  String toString() => 'User { name: $name, id: $username, role: $role, siteId: $siteId }';
}

enum Role {
  none,
  user,
  staff,
  manager,
  captain,
  distributor,
  admin,
  system,
}

extension RoleParsing on String {
  Role toRole() {
    switch (this) {
      case 'user':
        return Role.user;
      case 'staff':
        return Role.staff;
      case 'manager':
        return Role.manager;
      case 'captain':
        return Role.captain;
      case 'distributor':
        return Role.distributor;
      case 'admin':
        return Role.admin;
      case 'system':
        return Role.system;
      case 'none':
      default:
        return Role.none;
    }
  }
}

Role stringToRole(String val) {
  switch (val) {
    case 'Role.user':
      return Role.user;
    case 'Role.staff':
      return Role.staff;
    case 'Role.manager':
      return Role.manager;
    case 'Role.captain':
      return Role.captain;
    case 'Role.distributor':
      return Role.distributor;
    case 'Role.admin':
      return Role.admin;
    case 'Role.system':
      return Role.system;
    case 'Role.none':
    default:
      return Role.none;
  }
}
