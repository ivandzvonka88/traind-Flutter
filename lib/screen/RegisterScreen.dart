import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:regexed_validator/regexed_validator.dart';
import 'package:traind_flutter/models/User.dart';
import 'package:traind_flutter/services/AuthResponse.dart';
import 'package:traind_flutter/services/auth.dart';
import 'package:traind_flutter/services/firebasedb.dart';
import 'package:traind_flutter/utils/AppConstant.dart';
import 'package:traind_flutter/utils/Utils.dart';
import 'package:url_launcher/url_launcher.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return RegisterState();
  }
}

class RegisterState extends State<RegisterScreen> {
  BaseAuth _auth = new Auth();
  final _formKey = GlobalKey<FormState>();

  TextEditingController fnameController = new TextEditingController();
  TextEditingController lnameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController dobController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();

  List<String> genderType = ['Male', 'Female', 'Other'];
  int selectedGender = 0;

  bool agreeStatus = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(25.0),
            children: <Widget>[
              logoContainer,
              titleContainer,
              getEditTextContainer(fnameController, 'First Name',
                  inputType: TextInputType.text,
                  margineTop: 20, validator: (value) {
                if (value.isEmpty) {
                  return 'Enter First Name';
                }
                return null;
              }),
              getEditTextContainer(lnameController, 'Last Name',
                  margineTop: 10,
                  inputType: TextInputType.text, validator: (value) {
                if (value.isEmpty) {
                  return 'Enter Last Name';
                }
                return null;
              }),
              getEditTextContainer(emailController, 'Email',
                  margineTop: 10,
                  inputType: TextInputType.emailAddress, validator: (value) {
                if (value.isEmpty) {
                  return 'Enter Email';
                } else if (!validator.email(value)) {
                  return 'Enter valid Email';
                }
                return null;
              }),
              getEditTextContainer(passwordController, 'Password',
                  margineTop: 10,
                  inputType: TextInputType.text,
                  isPassword: true, validator: (value) {
                if (value.isEmpty) {
                  return 'Enter Password';
                } else if (value.length < 6) {
                  return 'Password field must be at least 6 characters in length.';
                }
                return null;
              }),
              getEditTextContainer(dobController, 'Date of Birth',
                  inputType: TextInputType.datetime,
                  margineTop: 10, validator: (value) {
                if (value.isEmpty) {
                  return 'Enter Date of Birth';
                }
                return null;
              }),
              getEditTextContainer(phoneController, 'Phone Number',
                  inputType: TextInputType.phone,
                  margineTop: 10, validator: (value) {
                if (value.isEmpty) {
                  return 'Enter Phone Number';
                } else if (!validator.phone(value)) {
                  return 'Enter valid Phone Number';
                }
                return null;
              }),
              genderContainer,
              termsAndConditionCheckContainer(),
              submitButtonContainer
            ],
          ),
        ),
      ),
    );
  }

  Widget logoContainer = Container(
    child: Image.asset(
      'images/icon_app.png',
      height: 60,
    ),
  );
  Widget titleContainer = Container(
    margin: EdgeInsets.only(top: 30.0),
    padding: EdgeInsets.all(20.0),
    child: Text(
      'Create a new\nuser account',
      style: TextStyle(
          fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
    ),
  );

  Widget getEditTextContainer1(TextEditingController _controller, String hint,
      {double margineTop = 0,
      TextInputType inputType = TextInputType.text,
      bool isPassword = false,
      FormFieldValidator<String> validator}) {
    return Container(
      margin: EdgeInsets.only(top: margineTop),
      child: Material(
        elevation: 0.5,
        shadowColor: Color.fromRGBO(210, 216, 227, 1.0),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            side: BorderSide(
              color: Color.fromRGBO(210, 216, 227, 1.0),
            )),
        child: TextFormField(
          controller: _controller,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          obscureText: isPassword,
          decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Color.fromRGBO(117, 142, 166, 1)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              contentPadding: EdgeInsets.only(
                  left: 25.0, top: 20.0, bottom: 20.0, right: 25.0)),
          keyboardType: inputType,
          validator: validator,
        ),
      ),
    );
  }

  Widget getEditTextContainer(TextEditingController _controller, String hint,
      {double margineTop = 0,
      TextInputType inputType = TextInputType.text,
      bool isPassword = false,
      FormFieldValidator<String> validator}) {
    return Container(
      margin: EdgeInsets.only(top: margineTop),
      child: TextFormField(
        controller: _controller,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        obscureText: isPassword,
        decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Color.fromRGBO(117, 142, 166, 1)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide(
                  color: Color.fromRGBO(210, 216, 227, 1.0), width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide:
                  BorderSide(color: Theme.of(context).primaryColor, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide(
                  color: Color.fromRGBO(210, 216, 227, 1.0), width: 1.5),
            ),
            contentPadding: EdgeInsets.only(
                left: 25.0, top: 20.0, bottom: 20.0, right: 25.0)),
        keyboardType: inputType,
        validator: validator,
      ),
    );
  }

  Widget get genderContainer {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 20.0),
            child: Text(
              'Gender',
              style: TextStyle(
                  color: Color.fromRGBO(117, 142, 166, 1),
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
            ),
          ),
          RadioButtonGroup(
            margin: EdgeInsets.only(top: 10),
            orientation: GroupedButtonsOrientation.HORIZONTAL,
            labels: genderType,
            picked: genderType[selectedGender],
            onSelected: (selected) {
              setState(() {
                selectedGender = genderType.indexOf(selected);
              });
            },
            itemBuilder: (Radio rb, Text txt, int i) {
              return Row(
                children: <Widget>[
                  rb,
                  Text(
                    txt.data,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 15),
                  )
                ],
              );
            },
          )
        ],
      ),
    );
  }

  Widget termsAndConditionCheckContainer() {
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      child: Row(
        children: <Widget>[
          Checkbox(
            value: agreeStatus,
            onChanged: (value) {
              setState(() {
                agreeStatus = value;
              });
            },
          ),
          Flexible(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'I agree to Traind',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: ' terms ',
                    style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        if (await canLaunch(AppConstant.TERMS_URL)) {
                          await launch(AppConstant.TERMS_URL);
                        }
                      },
                  ),
                  TextSpan(
                    text: 'and',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: ' privacy policy. ',
                    style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        if (await canLaunch(AppConstant.PRIVACY_POLICY_URL)) {
                          await launch(AppConstant.PRIVACY_POLICY_URL);
                        }
                      },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget get submitButtonContainer {
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      alignment: Alignment.center,
      child: ButtonTheme(
        minWidth: double.maxFinite,
        height: 60.0,
        child: RaisedButton(
          padding: EdgeInsets.all(5.0),
          child: Text(
            'Create',
            style: TextStyle(fontSize: 15, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          color: Theme.of(context).primaryColor,
          onPressed: () {
            if (_formKey.currentState.validate()) {
              if (!agreeStatus) {
                Utils().showMessageDialog(context, 'Error',
                    'Please accept terms & privacy policy for submit');
              } else {
                register(
                    fnameController.text,
                    lnameController.text,
                    emailController.text,
                    passwordController.text,
                    dobController.text,
                    phoneController.text,
                    selectedGender);
              }
            }
          },
        ),
      ),
    );
  }

  register(String fname, String lname, String email, String password,
      String dob, String phone, int gender) async {
    AuthResponse authResponse = await _auth.signUp(context, email, password);
    if (authResponse != null) {
      if (authResponse.success) {
        print('UID : ${authResponse.user.uid}');
        FirebaseDB db = new DB();
        User data = new User();
        data.uid = authResponse.user.uid;
        data.firstName = fname;
        data.lastName = lname;
        data.email = email;
        data.dob = dob;
        data.phone = phone;
        data.gender = gender;
        db.createUser(context, data);
      } else {
        Utils().showMessageDialog(context, 'Login', authResponse.error);
      }
    }
  }
}
