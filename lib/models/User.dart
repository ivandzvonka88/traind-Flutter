class User {
  String uid;
  String firstName;
  String lastName;
  String email;
  String dob;
  String phone;
  int gender;

  User(
      {this.uid,
      this.firstName,
      this.lastName,
      this.email,
      this.dob,
      this.phone,
      this.gender});

  User.fromJsonMap(Map<String, dynamic> map)
      : uid = map["uid"],
        firstName = map["firstName"],
        lastName = map["lastName"],
        email = map["email"],
        dob = map["dob"],
        phone = map["phone"],
        gender = map["gender"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = uid;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['email'] = email;
    data['dob'] = dob;
    data['phone'] = phone;
    data['gender'] = gender;
    return data;
  }
}
