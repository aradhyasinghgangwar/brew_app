import 'package:firebaseone/models/user.dart' as u;
import 'package:firebaseone/services/database.dart';
import 'package:flutter/material.dart';
import 'package:firebaseone/shared/constants.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';
import '../../shared/loading.dart';

class SettingsForm extends StatefulWidget {
  const SettingsForm({Key? key}) : super(key: key);

  @override
  State<SettingsForm> createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> sugars = ['0', '1', '2', '3', '4'];

  late String _currentName;
  String? _currentSugars;
  int? _currentStrength;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<u.User?>(context);

    return StreamBuilder<UserData?>(
        stream: DatabaseService(uid: user!.uid.toString()).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            u.UserData? userData = snapshot.data;
            return Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text(
                    'Update your brew settings.',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    initialValue: userData?.name,
                    decoration: textInputDecoration,
                    validator: (val) =>
                        val!.isEmpty ? 'Please enter a name' : null,
                    onChanged: (val) => setState(() => _currentName = val),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  //dropdown
                  DropdownButtonFormField<String>(
                    decoration: textInputDecoration,
                    value: _currentSugars ?? userData?.sugars,
                    items: sugars.map((sugar) {
                      return DropdownMenuItem(
                        value: sugar,
                        child: Text('$sugar sugars'),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => _currentSugars = val!),
                  ),

                  //slider
                  Slider(
                    min: 100.0,
                    max: 900.0,
                    activeColor: Colors.brown[_currentStrength ?? 100],
                    inactiveColor: Colors.brown[_currentStrength ?? 100],
                    divisions: 8,
                    value: (_currentStrength ?? userData!.strength).toDouble(),
                    onChanged: (val) =>
                        setState(() => _currentStrength = val.round()),
                  ),

                  TextButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await DatabaseService(uid: user.uid.toString())
                            .updateUserData(
                                _currentSugars ?? userData!.sugars,
                                _currentName ?? userData!.name,
                                _currentStrength ?? userData!.strength);
                        Navigator.pop(context);
                      }
                    },
                    child: const Text(
                      'Update',
                    ),
                  )
                ],
              ),
            );
          } else {
            return Loading();
          }
        });
  }
}
