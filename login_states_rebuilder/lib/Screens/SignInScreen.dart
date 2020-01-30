import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import '../Screens/HomeScreen.dart';
import '../Screens/SignUpScreen.dart';
import '../State/UserStore.dart';

class SignInScreen extends StatelessWidget {
  static String route = "signin_screen";
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: LoginForm(),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  String inputtedName;
  String inputtedPassword;
  String userId;
  FocusNode _passwordFocusNode = FocusNode();
  final _loginKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<Widget> _showErrorDialog(String errorMessage) {
    return showDialog(
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

  @override
  Widget build(BuildContext context) {
    return StateBuilder<UserStore>(
      models: [Injector.getAsReactive<UserStore>()],
      builder: (context, reactiveModel) {
        if (reactiveModel.isWaiting) {
          return buildLoading();
        }
        return buildForm();
      },
    );
  }

  Widget buildForm() {
    return Padding(
      padding: const EdgeInsets.only(left: 30.0, right: 30.0),
      child: Form(
        key: _loginKey,
        child: ListView(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
            ),
            buildNameField(),
            SizedBox(height: 10),
            buildPasswordField(),
            SizedBox(height: 15),
            buildSubmitButton(context),
            SizedBox(height: 15),
            buildSignUpText(),
          ],
        ),
      ),
    );
  }

  GestureDetector buildSignUpText() {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SignUpScreen(),
        ),
      ),
      child: Center(
        child: Text(
          "Want to SignUp?",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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

  void _saveForm(BuildContext context) {
    final isValid = _loginKey.currentState.validate();
    if (!isValid) {
      return;
    }
    _loginKey.currentState.save();
    print(inputtedName);
    print(inputtedPassword);
    Injector.getAsReactive<UserStore>().setState(
      (userStore) => userStore.verifyUser(inputtedName, inputtedPassword),
      onData: (context, store) {
        if (store.isVerified) {
          userId = store.findUser(inputtedName, inputtedPassword).userId;
          Navigator.pushNamed(context, HomeScreen.route, arguments: userId);
        } else {
          _showErrorDialog("Please Enter correct Details");
        }
      },
      onError: (context, error) => _showErrorDialog(error.toString()),
    );
  }
}
