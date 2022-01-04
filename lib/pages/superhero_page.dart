import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:superheroes/model/biography.dart';
import 'package:superheroes/model/powerstats.dart';
import 'package:superheroes/model/server_image.dart';
import 'package:superheroes/model/superhero.dart';
import 'package:superheroes/resources/superheroes_colors.dart';
import 'package:superheroes/widgets/action_button.dart';

class SuperheroPage extends StatelessWidget {
  final String id;

  const SuperheroPage({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final superhero = Superhero(
      id: id,
      name: 'Batman',
      biography: Biography(
        fullName: 'Batman Anatoevich',
        alignment: 'good',
        aliases: ['Batmanovich', 'Protector of the Realm'],
        placeOfBirth: 'Russia, St. Peterburg',
      ),
      image: ServerImage(
          'https://www.superherodb.com/pictures2/portraits/10/100/639.jpg'),
      powerstats: Powerstats(
        intelligence: '90',
        strength: '80',
        speed: '15',
        durability: '45',
        power: '100',
        combat: '0',
      ),
    );

    return Scaffold(
      backgroundColor: SuperheroesColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            stretch: true, // скролл
            pinned: true, // сверху
            floating: true, //при скролле вниз - картинка выезжает,
            expandedHeight: 348, // выезжает по высоте
            backgroundColor: SuperheroesColors.background, //цвет задника
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                superhero.name,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: SuperheroesColors.text,
                  fontSize: 22,
                ),
              ),
              centerTitle: true,  // по центру
              background: CachedNetworkImage(
                imageUrl: superhero.image.url,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverAppBar(
            stretch: true, // скролл
            pinned: true, // сверху
            floating: true, //при скролле вниз - картинка выезжает,
            expandedHeight: 348, // выезжает по высоте
            backgroundColor: SuperheroesColors.background, //цвет задника
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                superhero.name,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: SuperheroesColors.text,
                  fontSize: 22,
                ),
              ),
              centerTitle: true,  // по центру
              background: CachedNetworkImage(
                imageUrl: superhero.image.url,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
    /* or
                                                              onTap: () {
                                                              Navigator.of(context).push(MaterialPageRoute(
                                                              builder: (context) => MainPage(),
                                                                         */
  }
}
