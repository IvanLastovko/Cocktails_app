import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common_widgets/search_name.dart';
// import '../common_widgets/search_ingredient.dart';
import '../common_widgets/search_random.dart';
import '../common_widgets/search_favourites.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<Tab> myTabs = <Tab>[
    Tab(
      child: Text(
        'Name',
        style: TextStyle(fontSize: 16),
      ),
    ),
    Tab(
      child: Text(
        'Randomly',
        style: TextStyle(fontSize: 16),
      ),
    ),
    Tab(
      child: Icon(Icons.favorite),
    ),
  ];

  void _getSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (prefs.getStringList('favID') == null) {
        prefs.setStringList('favID', []);
      }
    });
    print(prefs.getStringList('favID'));
  }

  @override
  void initState() {
    super.initState();
    _getSharedPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: myTabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text('iCocktails'),
          bottom: TabBar(
            // isScrollable: true,
            tabs: myTabs,
          ),
        ),
        body: TabBarView(
          children: myTabs.map((Tab tab) {
            if (tab == myTabs[0]) {
              return SearchByName();
              // } else if (tab == myTabs[1]) {
              //   return SearchByIngredient();
            } else if (tab == myTabs[1]) {
              return SearchRandomly();
            }
            return SearchByFavourites();
          }).toList(),
        ),
      ),
    );
  }
}
