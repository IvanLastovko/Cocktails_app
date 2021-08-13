import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'cocktail_widget.dart';

class SearchByName extends StatefulWidget {
  const SearchByName({Key? key}) : super(key: key);

  @override
  _SearchByNameState createState() => _SearchByNameState();
}

class _SearchByNameState extends State<SearchByName> {
  final _formKey = GlobalKey<FormState>();
  String textFieldValue = '';
  var cocktails = [];

  void _onTextFieldChange(String text) {
    setState(() {
      textFieldValue = text;
    });
    // print(textFieldValue);
    if (text.length == 0) {
      cocktails = [];
    } else {
      _searchForCocktails();
    }
  }

  Future _searchForCocktails() async {
    final response = await http.get(Uri.parse(
        // 'https://www.thecocktaildb.com/api/json/v1/1/search.php?f=${textFieldValue[0]}'
        'https://www.thecocktaildb.com/api/json/v1/1/search.php?s=$textFieldValue'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      // print('Waiting....');
      if (jsonDecode(response.body)['drinks'] != null) {
        setState(() {
          cocktails = jsonDecode(response.body)['drinks'];
        });

        for (var cocktail in cocktails) {
          print(cocktail['strDrink']);
        }
      } else {
        print('No cocktails found :(');
      }

      if (textFieldValue.length == 0) {
        cocktails = [];
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load');
    }
  }

  @override
  Widget build(BuildContext context) {
    print('!!!!!!!!!!!!!!!!! $_formKey !!!!!!!!!!!!!!!!!');
    return Center(
        child: Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.all(15),
            child: TextFormField(
              onChanged: _onTextFieldChange,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter the name of a cocktail',
              ),
              autofocus: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter the name of a cocktail';
                }
                return null;
              },
            ),
          ),
          // ElevatedButton(
          //   onPressed: () {
          //     // Validate returns true if the form is valid, or false otherwise.
          //     if (_formKey.currentState!.validate()) {
          //       _searchForCocktails();
          //     }
          //   },
          //   child: Text(
          //     'Search for a Cocktail',
          //     style: TextStyle(fontSize: 17),
          //   ),
          // ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 10),
              child: ListView(
                children: cocktails.map((cocktail) {
                  if (cocktail['strDrink']
                      .toLowerCase()
                      .contains(textFieldValue.toLowerCase())) {
                    return Center(
                      child: Cocktail(cocktail),
                    );
                  }
                  return SizedBox.shrink(); // returns empty widget
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
