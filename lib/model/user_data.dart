class UserModel {
  final String id;
  final String email;
  String rank = "none";
  String? signupDate;

  UserModel({required this.id, required this.email});

  void update(Map<String, dynamic> userDoc) {
    String? rank = userDoc["rank"];
    if (rank != null) {
      this.rank = rank;
    }

    String? signupDate = userDoc["signupDate"];
    if (signupDate != null) {
      this.signupDate = signupDate;
    }
  }
}