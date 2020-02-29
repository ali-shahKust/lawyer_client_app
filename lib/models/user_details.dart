
class UserDetails {

  String name;
  String emailId;
  String photoUrl;
  String uid;

  UserDetails({this.name, this.emailId, this.photoUrl, this.uid});

  Map toMap(UserDetails userDetails) {
    var data = Map<String, String>();
    data['username'] = userDetails.name;
    data['user_email'] = userDetails.emailId;
    data['user_dp'] = userDetails.photoUrl;
    data['user_uid'] = userDetails.uid;
    return data;
  }

  UserDetails.fromMap(Map<String, String> mapData) {
    this.name = mapData['username'];
    this.emailId = mapData['user_email'];
    this.photoUrl = mapData['user_dp'];
    this.uid = mapData['user_uid'];
  }

  String get _name => name;
  String get _emailId => emailId;
  String get _photoUrl => photoUrl;
  String get _uid => uid;

  set _photoUrl(String photoUrl) {
    this.photoUrl = photoUrl;
  }

  set _name(String name) {
    this.name = name;
  }

  set _emailId(String emailId) {
    this.emailId = emailId;
  }

  set _uid(String uid) {
    this.uid = uid;
  }

}