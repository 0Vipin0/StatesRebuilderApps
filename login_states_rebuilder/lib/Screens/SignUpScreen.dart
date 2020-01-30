import 'package:flutter/material.dart';
import 'package:login_states_rebuilder/Screens/HomeScreen.dart';
import 'package:login_states_rebuilder/State/UserStore.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class SignUpScreen extends StatelessWidget {
  static String route = "signup_screen";
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SignUpForm(),
        ),
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  String userId;
  String inputtedName;
  String inputtedPassword;
  String inputtedConfirmPassword;
  FocusNode _passwordFocusNode = FocusNode();
  FocusNode _confirmPasswordFocusNode = FocusNode();
  final _signUpKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StateBuilder(
        models: [Injector.getAsReactive<UserStore>()],
        builder: (context, reactiveModel) => reactiveModel.whenConnectionState(
              onIdle: buildForm,
              onWaiting: buildLoading,
              onData: (store) => buildForm(),
              onError: null,
            ));
  }

  Widget buildForm() {
    return Padding(
      padding: const EdgeInsets.only(left: 30.0, right: 30.0),
      child: Form(
        key: _signUpKey,
        child: ListView(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
            ),
            buildNameField(),
            SizedBox(height: 10),
            buildPasswordField(),
            SizedBox(height: 10),
            buildConfirmPasswordField(),
            SizedBox(height: 15),
            buildSubmitButton(context),
            SizedBox(height: 15),
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Center(
                child: Text(
                  "Want to Login?",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Container buildSubmitButton(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(15),
      ),
      child: FlatButton(
        onPressed: () {
          _saveForm(context);
        },
        child: Text(
          "Submit",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  TextFormField buildPasswordField() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: "Enter your Password",
        labelText: "Password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      focusNode: _passwordFocusNode,
      onChanged: (val) => inputtedPassword = val,
      validator: (val) {
        if (val.isEmpty) {
          return "Please enter Something";
        }
        return null;
      },
      obscureText: true,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (_) {
        FocusScope.of(context).requestFocus(_confirmPasswordFocusNode);
      },
    );
  }

  TextFormField buildConfirmPasswordField() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: "Enter your Password again",
        labelText: "Confirm Password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      onChanged: (val) => inputtedConfirmPassword = val,
      focusNode: _confirmPasswordFocusNode,
      validator: (val) {
        if (val.isEmpty) {
          return "Please enter Something";
        }
        if (inputtedConfirmPassword != inputtedPassword) {
          return "Confirm Password do not Match";
        }
        return null;
      },
      obscureText: true,
      textInputAction: TextInputAction.done,
    );
  }

  TextFormField buildNameField() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: "Enter your Name",
        labelText: "Name",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      onChanged: (val) => inputtedName = val,
      validator: (val) {
        if (val.isEmpty) {
          return "Please enter Something";
        }
        return null;
      },
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (_) {
        FocusScope.of(context).requestFocus(_passwordFocusNode);
      },
    );
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Error Occured"),
        content: Text(errorMessage),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Okay"),
          ),
        ],
      ),
    );
  }

  void _saveForm(BuildContext context) {
    final isValid = _signUpKey.currentState.validate();
    if (!isValid) {
      return;
    }
    _signUpKey.currentState.save();
    print(inputtedName);
    print(inputtedPassword);
    Injector.getAsReactive<UserStore>().setState(
        (userStore) => userStore.addUser(inputtedName, inputtedPassword),
        onError: (context, error) => _showErrorDialog(error),
        onData: (context, store) {
          if (store.isAdded) {
            userId = store.findUser(inputtedName, inputtedPassword).userId;
            Navigator.pushNamed(context, HomeScreen.route,arguments: userId);
          } else {
            _showErrorDialog("Unable to add User. Please try again later.");
          }
        });
  }
}
