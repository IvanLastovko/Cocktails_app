import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CocktailRoute extends StatefulWidget {
  CocktailRoute(this.cocktail);
  final cocktail;

  @override
  _CocktailRouteState createState() => _CocktailRouteState();
}

class _CocktailRouteState extends State<CocktailRoute> {
  var isFav = false;
  var numberOfIngredients = 0;
  var ingredientsStrings = [];

  List<String>? favouritesIDs = [];

  void _getSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      favouritesIDs = prefs.getStringList('favID');
      if (favouritesIDs!.contains(widget.cocktail['idDrink'])) {
        isFav = true;
      }
    });
    print('aaa');
    print(favouritesIDs);
  }

  void _updateSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (!favouritesIDs!.contains(widget.cocktail['idDrink'])) {
        favouritesIDs = prefs.getStringList('favID');
        favouritesIDs!.add(widget.cocktail['idDrink']);
        prefs.setStringList('favID', favouritesIDs!);
        isFav = true;
      } else {
        favouritesIDs = prefs.getStringList('favID');
        favouritesIDs!.remove(widget.cocktail['idDrink']);
        prefs.setStringList('favID', favouritesIDs!);
        isFav = false;
      }
    });
    print(favouritesIDs);
  }

  @override
  void initState() {
    numberOfIngredients = 0;
    ingredientsStrings = [];
    super.initState();
    _getSharedPrefs();
    for (var i = 1; i < 15; i++) {
      if (widget.cocktail['strIngredient$i'] != null &&
          widget.cocktail['strIngredient$i'] != '') {
        numberOfIngredients = i;
        ingredientsStrings.add("${widget.cocktail['strIngredient$i']} " +
            "${widget.cocktail['strMeasure$i']}");
        print(ingredientsStrings[i - 1]);
      } else {
        print('Cocktail has $numberOfIngredients ingredients');
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print('object');
    return Scaffold(
      appBar: AppBar(
        title: Text("\'${widget.cocktail['strDrink']}\'"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _updateSharedPrefs();
        },
        elevation: 0,
        highlightElevation: 0,
        child: Icon(
          isFav ? Icons.favorite : Icons.favorite_border,
          color: Colors.green.shade600,
          size: 50,
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Center(
                  child: Container(
                    padding: EdgeInsets.only(
                      top: 15,
                      left: 20,
                      right: 20,
                    ),
                    child: Column(
                      children: [
                            Image.network(widget.cocktail['strDrinkThumb']),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(top: 10, bottom: 7),
                                  child: Text(
                                    "Ingredients",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                )),
                          ] +
                          ingredientsStrings
                              .map((ingredient) => Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      ' - ' + ingredient,
                                    ),
                                  ))
                              .toList() +
                          [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(top: 20, bottom: 20),
                                child: Text(
                                  widget.cocktail['strInstructions'],
                                  // textAlign: TextAlign.justify,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            )
                          ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
