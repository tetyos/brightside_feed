class UserModel {
  final String id;
  String email = "";
  String rank = "none";
  String? signupDate;

  UserModel({required this.id});

  void update(Map<String, dynamic> userDoc) {
    String? email = userDoc["email"];
    if (email != null) {
      this.email = email;
    }

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