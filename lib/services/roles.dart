Map allPermissions = {
  "Control": ["Edit Roles", "Add Role", "Change User Role"],
  "Settings": ["Edit Name"],
  "Instructor": ["Add Activity"]
};

class Role {
  final String name;
  final int rank; // This needs to be replaced with a pointer system
  final List<String> permissions;
  Role({required this.name, required this.rank, required this.permissions});

  bool checkPermission(String permission) {
    return permissions.contains(permission);
  }

  void flipPermission(String permission) {}

  void setRank(int rank) {}

  @override
  String toString() {
    return "$name role";
  }
}
