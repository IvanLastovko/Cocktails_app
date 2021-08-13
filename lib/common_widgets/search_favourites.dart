import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cocktails_app/common_widgets/cocktail_by_id.dart';

class SearchByFavourites extends StatefulWidget {
  const SearchByFavourites({Key? key}) : super(key: key);

  @override
  _SearchByFavouritesState createState() => _SearchByFavouritesState();
}

class _SearchByFavouritesState extends State<SearchByFavourites> {
  List<String>? favouritesIDs = [];

  void _getSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      favouritesIDs = prefs.getStringList('favID');
    });
    print(favouritesIDs);
  }

  @override
  void initState() {
    super.initState();
    _getSharedPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: favouritesIDs!.isEmpty
          ? [
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 100),
                  child: Text(
                    'No favorites added yet...',
                    style: TextStyle(fontSize: 30),
                  ),
                ),
              )
            ]
          : favouritesIDs!.map((id) => CocktailByID(id)).toList(),
    );
  }
}
