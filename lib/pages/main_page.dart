import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superheroes/blocs/main_bloc.dart';
import 'package:superheroes/pages/superhero_page.dart';
import 'package:superheroes/resources/superheroes_colors.dart';
import 'package:superheroes/resources/superheroes_images.dart';
import 'package:superheroes/widgets/action_button.dart';
import 'package:superheroes/widgets/info_with_button.dart';
import 'package:superheroes/widgets/superhero_card.dart';

class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final MainBloc bloc = MainBloc();

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: bloc,
      child: Scaffold(
        backgroundColor: SuperheroesColors.background,
        body: SafeArea(
          child: MainPageContent(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}

class MainPageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MainBloc bloc = Provider.of<MainBloc>(context);
    return Stack(
      children: [
        MainPageStateWidget(),
        Align(alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: ActionButton(onTap: () => bloc.nextState(), text: 'Next state'),
          ),
        ),//

        // Align(
        //   alignment: Alignment.bottomCenter,
        //   child: GestureDetector(
        //     onTap: () => bloc.nextState(),
        //     child: Padding(
        //       padding: const EdgeInsets.only(bottom: 30), // ?
        //       child: Container(
        //         decoration: BoxDecoration(
        //           color: SuperheroesColors.blue,
        //           borderRadius: BorderRadius.circular(8),),
        //         child: Padding(
        //           padding: EdgeInsets.fromLTRB(20, 8, 20, 8),
        //           child: Text(
        //             'Next state'.toUpperCase(),
        //             style: TextStyle(
        //               fontWeight: FontWeight.w700,
        //               letterSpacing: 0.25,                // межбуквенный интервал
        //               // height: 20,                     // высота строки
        //               fontSize: 14,
        //               color: SuperheroesColors.text,
        //             ),
        //           ),
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}

class MainPageStateWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MainBloc bloc = Provider.of<MainBloc>(context);
    return StreamBuilder<MainPageState>(
      stream: bloc.observeMainPageState(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return SizedBox();
        }
        final MainPageState state = snapshot.data!;
        switch (state) {
          case MainPageState.loading:
            return LoadingIndicator();
          case MainPageState.noFavorites:
            return NoFavorites();
          case MainPageState.minSymbols:
            return MinSymbols();
          case MainPageState.nothingFound:
            return InfoWithButton(
              title: 'Error happened',
              assetImage: 'assets/images/hulk.png',
              imageTopPadding: 9,
              buttonText: 'Search',
              subtitle: 'Please, try again',
              imageWidth: 108,
              imageHeight: 119,
            );
          case MainPageState.loadingError:
            return InfoWithButton(
              title: 'Nothing found',
              assetImage: 'assets/images/superman.png',
              imageTopPadding: 9,
              buttonText: 'Retry',
              subtitle: 'Search for something else',
              imageWidth: 108,
              imageHeight: 119,
            );
          case MainPageState.searchResults:
            return SearchResults();
          case MainPageState.favorites:
            return Favorites();
          default:
            return Center(
              child: Text(
                state.toString(),
                style: TextStyle(color: SuperheroesColors.text),
              ),
            );
        }
      },
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(top: 110),
        child: CircularProgressIndicator(
          color: SuperheroesColors.blue,
          strokeWidth: 4,
        ),
      ),
    );
  }
}

class MinSymbols extends StatelessWidget {
  const MinSymbols({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(left: 16, top: 110, right: 16),
        child: Text(
          'Enter at least 3 symbols',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: SuperheroesColors.text,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class NoFavorites extends StatelessWidget {
  const NoFavorites({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              Container(
                width: 108,
                height: 108,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  // borderRadius: BorderRadius.circular(54),
                  color: SuperheroesColors.blue,
                ),
              ),
              Padding(             // color: Colors.amber,
                padding: EdgeInsets.only(top: 9),
                child: Image.asset(
                  'assets/images/ironman.png',
                  width: 108,
                  height: 119,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Text(
              'No favorites yet',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: SuperheroesColors.text,
                fontSize: 32,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Search and add'.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: SuperheroesColors.text,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 30),
          ActionButton(
            onTap: () {},
            text: 'Search',
          ),
        ],
      ),
    );
  }
}

//
//
// class NoFavorites extends StatelessWidget {
//   const NoFavorites({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//       Stack(
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(left: 126, top: 165, right: 126),
//             child: Container(
//               width: 108,
//               height: 108,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(54),
//                 color: SuperheroesColors.blue,
//               ),
//             ),
//           ),
//           Container(
//             // alignment: Alignment.center,
//             // color: Colors.amber,
//             child: Padding(
//               padding: const EdgeInsets.only(left: 126, top: 174, right: 126),
//               child: Image.asset(
//                 'assets/images/ironman.png',
//                 width: 108,
//                 height: 119,
//               ),
//             ),
//           ),
//         ],
//       ),
//       SizedBox(
//         height: 20,
//       ),
//       Align(
//         alignment: Alignment.topCenter,
//         child: Text(
//           'No favorites yet',
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             color: SuperheroesColors.text,
//             fontSize: 32,
//             fontWeight: FontWeight.w800,
//           ),
//         ),
//       ),
//       SizedBox(height: 30),
//       Text(
//         'Search and add'.toUpperCase(),
//         textAlign: TextAlign.center,
//         style: TextStyle(
//           color: SuperheroesColors.text,
//           fontSize: 16,
//           fontWeight: FontWeight.w700,
//         ),
//       ),
//       SizedBox(height: 20),
//       ActionButton(
//         onTap: () {},
//         text: 'Search',
//       ),
//     ]);
//   }
// }

class Favorites extends StatelessWidget {
  const Favorites({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 90),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Text(
            'Your favorites',
            // textAlign: TextAlign.start,
            style: TextStyle(
              color: SuperheroesColors.text,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: SuperheroCard(
            name: 'Batman',
            realName: 'Bruce Wayne',
            imageUrl:
                'https://www.superherodb.com/pictures2/portraits/10/100/639.jpg',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (bulder) => SuperheroPage(
                    onTap: () {},
                    text: 'Batman',
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: SuperheroCard(
            name: 'Ironman',
            realName: 'Tony Stark',
            imageUrl:
                'https://www.superherodb.com/pictures2/portraits/10/100/85.jpg',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (bulder) => SuperheroPage(
                    onTap: () {},
                    text: 'Ironman',
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class SearchResults extends StatelessWidget {
  const SearchResults({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 90),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Text(
            'Search results',
            // textAlign: TextAlign.start,
            style: TextStyle(
              color: SuperheroesColors.text,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: SuperheroCard(
            name: 'Batman'.toUpperCase(),
            realName: 'Bruce Wayne',
            imageUrl:
                'https://www.superherodb.com/pictures2/portraits/10/100/639.jpg',
            onTap: () {},
          ),
        ),
        SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: SuperheroCard(
            name: 'Venom'.toUpperCase(),
            realName: 'Eddie Brock',
            imageUrl:
                'https://www.superherodb.com/pictures2/portraits/10/100/22.jpg',
            onTap: () {},
          ),
        ),
      ],
    );
  }
}
