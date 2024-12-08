import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:projectemailauthdec1/choose.dart';
import 'package:projectemailauthdec1/homepage.dart';
import 'package:projectemailauthdec1/login.dart';
import 'package:projectemailauthdec1/verify.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context,snapshot){
            if(snapshot.hasData)
              {
                print(snapshot.data);
                if(snapshot.data!.emailVerified) //verifief
                  {
                     return Choose();
                  }
                else //not verified
                  {
                      return Verify();
                  }

              }
            else
              {
                return Login();
              }
          }),
    );
  }
}
