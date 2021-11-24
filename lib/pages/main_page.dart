import 'package:flutter/material.dart';
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
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child:
                ActionButton(onTap: () => bloc.nextState(), text: 'Next state'),
          ),
        ), //

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
            return NoFavoritesWidget();
          case MainPageState.minSymbols:
            return MinSymbolsWidget();
          case MainPageState.nothingFound:
            return NothingFoundWidget();
          case MainPageState.loadingError:
            return LoadingErrorWidget();
          case MainPageState.searchResults:
            return SearchResultsWidget();
          case MainPageState.favorites:
            return FavoritesWidget();
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



class MinSymbolsWidget extends StatelessWidget {
  const MinSymbolsWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(
            top:
                110), // padding: EdgeInsets.only(left: 16, top: 110, right: 16),
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



class NoFavoritesWidget extends StatelessWidget {
  const NoFavoritesWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: InfoWithButton(
        title: 'No favorites yet',
        subtitle: 'Search and add',
        buttonText: 'Search',
        assetImage: SuperheroesImages.ironMan,
        imageHeight: 119,
        imageWidth: 108,
        imageTopPadding: 9,
      ),
    );
  }
}



class NothingFoundWidget extends StatelessWidget {
  const NothingFoundWidget  ({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: InfoWithButton(
        title: 'Nothing found',
        assetImage: SuperheroesImages.hulk,
        imageTopPadding: 16,
        buttonText: 'Search',
        subtitle: 'Search for something else',
        imageWidth: 84,
        imageHeight: 112,
      ),
    );
  }
}


class LoadingErrorWidget extends StatelessWidget {
  const LoadingErrorWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: InfoWithButton(
        title: 'Error happened',
        assetImage: SuperheroesImages.superMan,
        imageTopPadding: 22,
        buttonText: 'Retry',
        subtitle: 'Please, try again',
        imageWidth: 126,
        imageHeight: 106 ,
      ),
    );
  }
}



class FavoritesWidget extends StatelessWidget {
  const FavoritesWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 90),
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal:
                  16), // padding: const EdgeInsets.only(left: 16, right: 16),
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
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal:
                  16), // padding: const EdgeInsets.only(left: 16, right: 16),
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
        const SizedBox(height: 8),
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

class SearchResultsWidget extends StatelessWidget {
  const SearchResultsWidget({Key? key}) : super(key: key);
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
            name: 'Venom',
            realName: 'Eddie Brock',
            imageUrl:
                'https://www.superherodb.com/pictures2/portraits/10/100/22.jpg',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (bulder) => SuperheroPage(
                    onTap: () {},
                    text: 'Venom',
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
