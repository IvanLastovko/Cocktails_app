import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:cocktails_app/common_widgets/cocktail_widget.dart';
import 'package:cocktails_app/common_widgets/loader_widget.dart';

class SearchRandomly extends StatefulWidget {
  const SearchRandomly({Key? key}) : super(key: key);

  @override
  _SearchRandomlyState createState() => _SearchRandomlyState();
}

class _SearchRandomlyState extends State<SearchRandomly> {
  // 0 - did not start search; 1 - currently searching; 2 - found(search finished)
  int stageOfSearching = 0;
  var randomCocktail = [];

  Future _startSearchRandomly() async {
    setState(() {
      stageOfSearching = 1;
    });
    final response = await http.get(
        Uri.parse('https://www.thecocktaildb.com/api/json/v1/1/random.php'));
    print('RESPONSE: ${response.body}');
    if (response.statusCode == 200) {
      if (jsonDecode(response.body)['drinks'] != null) {
        setState(() {
          randomCocktail = jsonDecode(response.body)['drinks'];
          stageOfSearching = 2;
        });
      }
    } else {
      stageOfSearching = 0;
      throw Exception('Failed to load');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          stageOfSearching == 2
              ? Container(
                  padding: EdgeInsets.only(top: 20),
                  child: Cocktail(randomCocktail[0]),
                )
              : stageOfSearching == 1
                  ? Loader()
                  : SizedBox.shrink(),
          Expanded(
            child: Align(
              alignment: Alignment.bottomRight,
              child: Container(
                margin: EdgeInsets.only(right: 15, bottom: 15),
                decoration: BoxDecoration(
                  border: Border.all(width: 3, color: Colors.green.shade600),
                  borderRadius: BorderRadius.all(Radius.circular(70.0)),
                ),
                child: IconButton(
                  icon: Icon(Icons.refresh),
                  color: Colors.green.shade600,
                  iconSize: 30,
                  onPressed: () {
                    _startSearchRandomly();
                  },
                  splashRadius: 60,
                  padding: EdgeInsets.all(10),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
