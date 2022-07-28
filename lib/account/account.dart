class account {

  static String? fname_;
  static String? lname_;
  static String? email_;
  static String? pass_;
  static String? num_;

  String? fname;
  String? lname;
  String? email;
  String? pass;
  String? num;

  account({this.fname, this.lname, this.email, this.pass, this.num});

  account.fromJson(Map<String, dynamic> json) {
    fname = json['fname'];
    lname = json['lname'];
    email = json['email'];
    pass = json['pass'];
    num = json['num'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fname'] = this.fname;
    data['lname'] = this.lname;
    data['email'] = this.email;
    data['pass'] = this.pass;
    data['num'] = this.num;
    return data;
  }
}
