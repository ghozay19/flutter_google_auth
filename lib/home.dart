import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_google_auth/api.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;


  Future<FirebaseUser> _handleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user = await _auth.signInWithCredential(credential);
    daftar(user.email, user.displayName);


    print("signed in " + user.email );
    return user;
  }

  String password = "apaaja";
  daftar(String email, String nama) async {
    final response = await http.post(BaseUrl.daftar, body: {
      "username": email,
      "password": password,
      "nama": nama,
    });
    final data = jsonDecode(response.body);
    int value = data['value'];
    String message = data['message'];
    if (value == 1) {
      print(message);
    } else {
      print(message);
    }
  }


  signOut() {
    _googleSignIn.signOut();
    _auth.signOut();
    print("signed out ");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Material(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(10.0),
                child: MaterialButton(
                  onPressed: _handleSignIn,
                  child: Text(
                    "Google Sign In",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Material(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(10.0),
                child: MaterialButton(
                  onPressed: signOut,
                  child: Text(
                    "Sign Out",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}