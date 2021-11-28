import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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

    return Stack(
      children: [
        MainPageStateWidget(),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 12),
          child: SearchWidget(),
        ),
      ],
    );
  }
}

class SearchWidget extends StatefulWidget {
  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance?.addPostFrameCallback((timeStamp) {
      final MainBloc bloc = Provider.of<MainBloc>(context, listen: false);
      controller.addListener(
        () => bloc.updateText(controller.text),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final MainBloc bloc = Provider.of<MainBloc>(context, listen: false);
    return TextField(
      controller: controller,
      style: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 20,
        color: SuperheroesColors.text,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: SuperheroesColors.indigo75,
        isDense: true,
        prefixIcon: Icon(
          Icons.search,
          color: SuperheroesColors.white54,
          size: 24,
        ),
        suffix: GestureDetector(
          onTap: () => controller.clear(),
          child: Icon(
            Icons.clear,
            color: SuperheroesColors.text,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: SuperheroesColors.white24),
        ),
      ),
    );
  }
}

class MainPageStateWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MainBloc bloc = Provider.of<MainBloc>(context, listen: false);
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
          case MainPageState.minSymbols:
            return MinSymbolsWidget();
          case MainPageState.noFavorites:
            return NoFavoritesWidget();
          case MainPageState.favorites:
            return SuperheroesList(
              title: 'Your favorites',
              stream: bloc.observeSearchedSuperheroes(),
            );
          case MainPageState.searchResults:
            return SuperheroesList(
              title: 'Search results',
              stream: bloc.observeFavoriteSuperheroes(),
            );
          case MainPageState.nothingFound:
            return NothingFoundWidget();
          case MainPageState.loadingError:
            return LoadingErrorWidget();


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
  const NothingFoundWidget({Key? key}) : super(key: key);

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
        imageHeight: 106,
      ),
    );
  }
}



class SuperheroesList extends StatelessWidget {
  final String title;
  final Stream<List<SuperheroInfo>> stream;

  const SuperheroesList({
    Key? key,
    required this.title,
    required this.stream,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<SuperheroInfo>>(
        stream: stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return const SizedBox.shrink();
          }
          final List<SuperheroInfo> superheroes = snapshot.data!;
          return ListView.separated(
            itemCount: superheroes.length + 1,
                 //  название списка положим в список - будет скролится - в противном случае статичен
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return Padding(
                   padding: const EdgeInsets.only(left: 16, right: 16, top: 90, bottom: 12),
                  child: Text(
                    title,
                    // textAlign: TextAlign.start,
                    style: TextStyle(
                      color: SuperheroesColors.text,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                );
              }
              final SuperheroInfo item = superheroes[index - 1];
              return Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: SuperheroCard(
                  name: item.name,
                  realName: item.realName,
                  imageUrl: item.imageUrl,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (conext) => SuperheroPage(name: item.name, onTap: () {  },), // !!!!!!!!!
                      ),
                    );
                  },
                ),
              );
            }, separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(height: 8);
          },
          );
        });
  }
}

