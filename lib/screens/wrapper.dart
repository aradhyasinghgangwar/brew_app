import 'package:firebaseone/screens/authenticate/authenticate.dart';
import 'package:firebaseone/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebaseone/models/user.dart' as u;

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<u.User?>(context);

    //return Home or Authenticate widget
    if (user == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}
