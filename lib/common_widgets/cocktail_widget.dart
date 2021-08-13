import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cocktails_app/app/cocktail_page.dart';

class Cocktail extends StatelessWidget {
  Cocktail(this.cocktail);
  final cocktail;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15, bottom: 20),
      width: 380,
      child: ElevatedButton(
        child: Column(
          children: [
            Image.network(
              cocktail['strDrinkThumb'],
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null)
                  return child;
                else {
                  print(
                      'LOADING PROGRESS: ${loadingProgress.cumulativeBytesLoaded}');
                  return Container(
                    height: 160,
                    width: 160,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded.toDouble() /
                              loadingProgress.expectedTotalBytes!.toDouble()
                          : null,
                    ),
                  );
                }
              },
            ),
            Container(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                cocktail['strDrink'],
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                    color: Colors.green.shade700),
              ),
            )
          ],
        ),
        onPressed: () {
          print(cocktail['strDrink']);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CocktailRoute(cocktail)),
          );
        },
        style: ElevatedButton.styleFrom(
          primary: Color(0xFFFFFFFF),
          padding: EdgeInsets.symmetric(vertical: 10),
        ),
      ),
    );
  }
}
