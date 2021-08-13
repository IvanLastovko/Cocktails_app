import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:cocktails_app/app/cocktail_page.dart';
import 'dart:convert';

class CocktailByID extends StatefulWidget {
  final String id;
  CocktailByID(this.id);

  @override
  _CocktailByIDState createState() => _CocktailByIDState();
}

class _CocktailByIDState extends State<CocktailByID> {
  var favCocktail = [];
  var isFav = true;

  void _startSearchFavorite() async {
    if (favCocktail.isEmpty) {
      final response = await http.get(Uri.parse(
          'https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=${widget.id}'));
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['drinks'] != null) {
          setState(() {
            favCocktail = jsonDecode(response.body)['drinks'];
          });
        }
      } else {
        throw Exception('Failed to load');
      }
    }
  }

  List<String>? favouritesIDs = [];

  void _getSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      favouritesIDs = prefs.getStringList('favID');
      if (favouritesIDs!.contains(favCocktail[0]['idDrink'])) {
        isFav = true;
      }
    });
    print('aaa');
    print(favouritesIDs);
  }

  void _updateSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (!favouritesIDs!.contains(favCocktail[0]['idDrink'])) {
        favouritesIDs = prefs.getStringList('favID');
        favouritesIDs!.add(favCocktail[0]['idDrink']);
        prefs.setStringList('favID', favouritesIDs!);
        isFav = true;
      } else {
        favouritesIDs = prefs.getStringList('favID');
        favouritesIDs!.remove(favCocktail[0]['idDrink']);
        prefs.setStringList('favID', favouritesIDs!);
        isFav = false;
      }
    });
    print(favouritesIDs);
  }

  @override
  void initState() {
    super.initState();
    _getSharedPrefs();
    _startSearchFavorite();
  }

  @override
  Widget build(BuildContext context) {
    return favCocktail.isEmpty
        ? SizedBox.shrink()
        : Container(
            color: Colors.pink[50],
            margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
            height: 75,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CocktailRoute(favCocktail[0])),
                );
              },
              style: ElevatedButton.styleFrom(primary: Colors.white),
              child: Row(
                children: [
                  Image.network(
                    favCocktail[0]['strDrinkThumb'],
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null)
                        return child;
                      else {
                        print(
                            'LOADING PROGRESS: ${loadingProgress.cumulativeBytesLoaded}');
                        return Container(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded
                                        .toDouble() /
                                    loadingProgress.expectedTotalBytes!
                                        .toDouble()
                                : null,
                          ),
                        );
                      }
                    },
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Text(
                        favCocktail[0]['strDrink'],
                        style: TextStyle(color: Colors.green, fontSize: 20),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(isFav
                        ? Icons.favorite
                        : Icons.favorite_border_outlined),
                    color: Colors.green.shade600,
                    iconSize: 30,
                    onPressed: () {
                      _updateSharedPrefs();
                    },
                    splashRadius: 40,
                    padding: EdgeInsets.all(10),
                  ),
                ],
              ),
            ),
          );
  }
}
