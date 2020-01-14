
class User {
  String _username;
  String _password;
  String _email;

  User( {String user = "", String pw = "", String email = ""} ):
  _username = user,
  _password = pw,
  _email = email;

  void enterUserName(String username){
    this._username = username;
  }

  void enterPassword(String pw){
    this._password = pw;
  }

  void enterEmail(String email){
    this._email = email;
  }

  //Incorrect function
  bool authenicate(){
    return this._password == this._password 
    && this._username == this._username
    && this._email == this._email;
  }

}