import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taxonomy_method/screens/form_page.dart';

import 'about_page.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List _isHovering = [false, false, false];
  final _formKey = GlobalKey<FormState>();
  final _acceptedKey = "4M0L4ND0 4 M4L4NDR4";
  final _textEditingController = TextEditingController();

  Future<void> _showPassWordDialog() async {
    return await showDialog(
        context: context,
        builder: (context) {
          bool isChecked = false;
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                          obscureText: true,
                          autocorrect: false,
                          enableSuggestions: false,
                          controller: _textEditingController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please Enter a Password";
                            }
                            if (value != _acceptedKey) {
                              return 'Wrong Password';
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(hintText: "Password"),
                          onFieldSubmitted: (value) => _validatePassword()),
                    ],
                  )),
              title: Text('Enter the Password'),
              actions: <Widget>[
                TextButton(
                  child: Text('Confirm   '),
                  onPressed: () => _validatePassword(),
                ),
              ],
            );
          });
        });
  }

  void _validatePassword() {
    if (_formKey.currentState.validate()) {
      // Do something like updating SharedPreferences or User Settings etc.
      Navigator.of(context).pop();
      Navigator.pushNamed(context, FormPage.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(screenSize.width, 1000),
        child: Container(
          color: Colors.green,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Text(
                  'TAXONOMY METHOD',
                  style: TextStyle(color: Colors.white),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {},
                        onHover: (value) {
                          setState(() {
                            _isHovering[1] = value;
                          });
                        },
                        child: Text(
                          'Instructions',
                          style: TextStyle(
                              color:
                                  _isHovering[1] ? Colors.black : Colors.white),
                        ),
                      ),
                      SizedBox(width: screenSize.width / 20),
                      InkWell(
                        onTap: () {},
                        onHover: (value) {
                          setState(() {
                            _isHovering[2] = value;
                          });
                        },
                        child: TextButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, AboutPage.routeName),
                          child: Text(
                            'About Us',
                            style: TextStyle(
                                color: _isHovering[2]
                                    ? Colors.black
                                    : Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      persistentFooterButtons: [
        FittedBox(
          fit: BoxFit.scaleDown,
                  child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: 64,
                child: Image.asset("assets/logos/ime.png"),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:30),
                child: Text(
                  '''
                  "All rights reserved. Non-commercial (academic) use of this software is free.
                  The only thing asked in exchange is to cite this software when the results are used in publications".
                  To cite the software: RODRIGUES, Lorran Santos; SANTOS, Marcos dos; GOMES, Carlos Francisco Simões;Taxonomy Software Web (v.1). 2021.''',
                  textAlign: TextAlign.justify,
                  maxLines: 5,
                ),
              )
            ],
          ),
        ),
      ],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Container(
              child: Text(
                'Start marking your decision here 🧠',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () => _showPassWordDialog(),
              child: Text("start"),
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
                onPrimary: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
