
import 'package:flutter/material.dart';
import 'package:superheroes/resources/superheroes_colors.dart';
import 'package:superheroes/widgets/action_button.dart';

import 'package:superheroes/pages/main_page.dart';

class SuperheroPage extends StatelessWidget {
  final VoidCallback onTap;
  final String name;

  const SuperheroPage({Key? key,
    required this.onTap,
    required this.name
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SuperheroesColors.background,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                name, style: TextStyle(    // передать данные - "name" in text
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: SuperheroesColors.text),),
              SizedBox(height: 231),
              Padding( padding: const EdgeInsets.only(bottom: 30),
                child: ActionButton(
                  text: 'Back',
                  onTap: () {Navigator.of(context).pop();},
                                                                      /* or
                                                            onTap: () {
                                                            Navigator.of(context).push(MaterialPageRoute(
                                                            builder: (context) => MainPage(),
                                                                       */
                      ),
              ),
                    ],
                ),
        ),
            ),
        );

  }
}
