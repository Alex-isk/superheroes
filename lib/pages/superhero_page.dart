import 'package:flutter/material.dart';
import 'package:superheroes/resources/superheroes_colors.dart';
import 'package:superheroes/widgets/action_button.dart';


class SuperheroPage extends StatelessWidget {
  // final VoidCallback onTap;
  final String name;
  // final String realName;  // add
  // final String imageUrl;    // add

  const SuperheroPage({
    Key? key,
    // required this.onTap,
    required this.name,
    // required this.realName,    // add
    // required this.imageUrl    // add
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SuperheroesColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child:
                  // Column(
                  //       mainAxisAlignment: MainAxisAlignment.end,
                  //       crossAxisAlignment: CrossAxisAlignment.center,
                  //       children: [
                  Text(
                name,
                style: TextStyle(
                    // передать данные - "name" in text
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: SuperheroesColors.text),
              ),
            ),
            // SizedBox(height: 231),
            // Padding( padding: const EdgeInsets.only(bottom: 30),
            Align(
              alignment: Alignment.bottomCenter,
              child: ActionButton(
                text: 'Back',
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            )
          ],
        ),
      ),
    );
    /* or
                                                              onTap: () {
                                                              Navigator.of(context).push(MaterialPageRoute(
                                                              builder: (context) => MainPage(),
                                                                         */
  }
}
