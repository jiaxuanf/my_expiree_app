import 'package:flutter/material.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'expireeWelcome.dart';
import 'package:provider/provider.dart';
import "package:expiree_app/states/currentUser.dart";
import 'package:expiree_app/helper/helperfunctions.dart';
import 'package:expiree_app/database.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  //final _formKey = GlobalKey<FormState>();
  //String _email, _password;
  final _passKey = GlobalKey<FormFieldState>();
  TextStyle style = GoogleFonts.chelseaMarket(
    fontSize: 20,
  );
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  void _signUpUser(String email, String password, String username, BuildContext context) async {
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);

    try {
      String _returnString = await _currentUser.signUpUser(email, password, username);
      if (_returnString == "success") {
        Navigator.pop(context);
      } else {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(_returnString),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final usernameField = TextFormField(
      controller: _usernameController,
      obscureText: false,
      style: GoogleFonts.roboto(
        fontSize: 17,
        color: Colors.black,
      ),
      decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
          hintText: 'Type in your username',
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(15.0))),
      validator: (input) {
        if (input.isEmpty) {
          return 'Please provide your username';
        }
        return null;
      },
      //onSaved: (input) => _email = input,
    );

    final newEmailField = TextFormField(
      controller: _emailController,
      obscureText: false,
      style: GoogleFonts.roboto(
        fontSize: 17,
        color: Colors.black,
      ),
      decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
          hintText: 'Type in your email',
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(15.0))),
      validator: (input) {
        if (input.isEmpty) {
          return 'Please provide your email';
        } else if (!input.contains('@')) {
          return 'Input is not an email';
        }
        return null;
      },
      //onSaved: (input) => _email = input,
    );

    final newPasswordField = TextFormField(
      controller: _passwordController,
      key: _passKey,
      obscureText: true,
      //controller: TextEditingController(),
      style: GoogleFonts.roboto(
        fontSize: 17,
        color: Colors.black,
      ),
      decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
          hintText: 'Type in a new password',
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(15.0))),
      validator: (input) {
        if (input.isEmpty) {
          return "Please provide a password";
        } else if (input.length < 6) {
          return 'Password should be at least 6 characters long';
        }
        return null;
      },
      //onSaved: (input) => _password = input,
    );

    final confirmPasswordField = TextFormField(
      controller: _confirmPasswordController,
      obscureText: true,
      style: GoogleFonts.roboto(
        fontSize: 17,
        color: Colors.black,
      ),
      decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
          hintText: 'Type in password again',
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(15.0))),
      validator: (input) {
        if (input.isEmpty) {
          return "Please confirm your password";
        }
        if (input != _passKey.currentState.value) {
          return 'Password does not match';
        }
        return null;
      },
    );

    final createAccountButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.brown,
      child: MaterialButton(
        minWidth: 90,
        padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
        onPressed: () {
          if (_passwordController.text == _confirmPasswordController.text) {
            _signUpUser(
                _emailController.text, _passwordController.text, _usernameController.text, context);
            Map<String, String> userDataMap = {
              "userName": _usernameController.text,
              "userEmail": _emailController.text
            };

            databaseMethods.addUserInfo(userDataMap);

            HelperFunctions.saveUserLoggedInSharedPreference(true);
            HelperFunctions.saveUserNameSharedPreference(
                _usernameController.text);
            HelperFunctions.saveUserEmailSharedPreference(
                _emailController.text);
          } else {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text("Passwords do not match"),
                duration: Duration(seconds: 2),
              ),
            );
          }
        },
        child: Text(
          'Create Account',
          textAlign: TextAlign.center,
          style: GoogleFonts.permanentMarker(fontSize: 22, color: Colors.white),
        ),
      ),
    );

    final cancelButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.red[900],
      child: MaterialButton(
        minWidth: 90,
        //MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text('Cancel and Go Back',
            textAlign: TextAlign.center,
            style:
                GoogleFonts.permanentMarker(fontSize: 22, color: Colors.white)),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Create a new account'),
      ),
      body: SingleChildScrollView(
        child: Form(
          //key: _formKey,
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Column(
                //infinite height
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Username',
                    style: GoogleFonts.kalam(fontSize: 20, color: Colors.black),
                    textAlign: TextAlign.start,
                  ),
                  usernameField,
                  SizedBox(height: 20.0),
                  Text(
                    'Email',
                    style: GoogleFonts.kalam(fontSize: 20, color: Colors.black),
                    textAlign: TextAlign.start,
                  ),
                  newEmailField,
                  SizedBox(height: 20.0),
                  Text(
                    'Password',
                    style: GoogleFonts.kalam(fontSize: 20, color: Colors.black),
                    textAlign: TextAlign.start,
                  ),
                  newPasswordField,
                  SizedBox(height: 20.0),
                  Text(
                    'Confirm your new password',
                    style: GoogleFonts.kalam(fontSize: 20, color: Colors.black),
                    textAlign: TextAlign.start,
                  ),
                  confirmPasswordField,
                  SizedBox(height: 20.0),
                  createAccountButton,
                  SizedBox(height: 20.0),
                  cancelButton,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
