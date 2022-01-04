import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:superheroes/blocs/main_bloc.dart';
import 'package:superheroes/pages/superhero_page.dart';
import 'package:superheroes/resources/superheroes_colors.dart';
import 'package:superheroes/resources/superheroes_images.dart';
import 'package:superheroes/widgets/action_button.dart';
import 'package:superheroes/widgets/info_with_button.dart';
import 'package:superheroes/widgets/superhero_card.dart';
import 'package:http/http.dart' as http;

class MainPage extends StatefulWidget {
  final http.Client? client;
  MainPage({Key? key, this.client}) : super(key: key);

  @override
  // State<MainPage> createState() => _MainPageState();
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late MainBloc bloc;
@override
  void initState() {
    super.initState();
    bloc = MainBloc(client:  widget.client);
  }

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

class MainPageContent extends StatefulWidget {
  @override
  State<MainPageContent> createState() => _MainPageContentState();
}

class _MainPageContentState extends State<MainPageContent> {
  late FocusNode searchFieldFocusNode;
  @override
  void initState() {
    super.initState();
    searchFieldFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        MainPageStateWidget(searchFieldFocusNode: searchFieldFocusNode,),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 12),
          child: SearchWidget(searchFieldFocusNode: searchFieldFocusNode,),
        ),
      ],
    );
  }
    @override
    void dispose() {       // dispose метод чтобы он потом не перехватывал метод
      searchFieldFocusNode.dispose();
      super.dispose();
    }


}

class SearchWidget extends StatefulWidget {
  final FocusNode searchFieldFocusNode;

  const SearchWidget({Key? key,
    required this.searchFieldFocusNode,
  }) : super(key: key);
  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final TextEditingController controller = TextEditingController();

  bool haveSearchedText = false;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance?.addPostFrameCallback((timeStamp) {
      final MainBloc bloc = Provider.of<MainBloc>(context, listen: false);
      // controller.addListener(() => bloc.updateText(controller.text));

      controller.addListener(() {
        bloc.updateText(controller.text);
        final haveText = controller.text.isNotEmpty;
        if (haveSearchedText != haveText) {
          setState(() {
            haveSearchedText = haveText;
          });
        }
      });
    });
  }

    // Color _color = SuperheroesColors.white54;           // ??????

  @override
  Widget build(BuildContext context) {
    // final MainBloc bloc = Provider.of<MainBloc>(context, listen: false);
    return TextField(
      focusNode: widget.searchFieldFocusNode,
      textCapitalization: TextCapitalization.words, //  заглавные у каждого слова (подходит и name)
      textInputAction: TextInputAction.search, // кнопки клвт - поиск или ок или ...
      // keyboardType: TextInputType.name, // вид клавиатуры
      cursorColor: SuperheroesColors.text,  // цвет курсора
      controller: controller,
      style: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 20,
        color: SuperheroesColors.text,
      ),
      decoration: InputDecoration(
        // hintText: 'Search ',  // текст в поле поиска
        // contentPadding: EdgeInsets.fromLTRB(...),
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
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: haveSearchedText        // при введении будет один текст - если нет6 то др
              ? BorderSide(color: SuperheroesColors.text, width: 2.0) // если есть текст в поиск запросе - цвет и толщина
              : BorderSide(color: SuperheroesColors.white24, width: 2.0), // если нет
          // borderSide: BorderSide(color: SuperheroesColors.white24),
        ),
      ),
    );
  }
}


class MainPageStateWidget extends StatelessWidget {
  final FocusNode searchFieldFocusNode;

  const MainPageStateWidget({Key? key,
    required this.searchFieldFocusNode,
  }) : super(key: key);

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
            return Stack(
              children: [
                NoFavoritesWidget(searchFieldFocusNode: searchFieldFocusNode),
                Align(alignment: Alignment.bottomCenter,
                    child: ActionButton(text: "Remove", onTap: bloc.removeFavorite))     // поскольку в () не принимаются параметры
                // ActionButton(text: "Remove", onTap: () => bloc.removeFavorite())   // идентичен, только др написание
              ],
            );
          case MainPageState.favorites:
            return Stack(
              children: [
                SuperheroesList(
                  title: 'Your favorites',
                  stream: bloc.observeFavoriteSuperheroes(),),
                Align(alignment: Alignment.bottomCenter,
                    child: ActionButton(text: "Remove", onTap: bloc.removeFavorite))     // поскольку в () не принимаются параметры
                // ActionButton(text: "Remove", onTap: () => bloc.removeFavorite())   // идентичен, только др написание
              ],
            );
          case MainPageState.searchResults:
            return SuperheroesList(
              title: 'Search results',
              stream: bloc.observeSearchedSuperheroes(),
            );
          case MainPageState.nothingFound:
            return NothingFoundWidget(searchFieldFocusNode: searchFieldFocusNode,);
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
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,   //Автоматически скрывать клавиатуру при скролле

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
                // padding: const EdgeInsets.only(left: 16, right: 16),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SuperheroCard(

                  superheroInfo: item,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (conext) => SuperheroPage(id: item.id), // ...
                      ),
                    );
                  },
                ),
              );
            }, separatorBuilder: (BuildContext context, int index) {   // разделитель
            return const SizedBox(height: 8);
          },
          );
        });
  }
}


class NoFavoritesWidget extends StatelessWidget {
  // const NoFavoritesWidget({Key? key}) : super(key: key);
final FocusNode searchFieldFocusNode;

  const NoFavoritesWidget({Key? key,
    required this.searchFieldFocusNode,
  }) : super(key: key);


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
        onTap: () => searchFieldFocusNode.requestFocus(),
      ),
    );
  }
}


class NothingFoundWidget extends StatelessWidget {
  // const NothingFoundWidget({Key? key}) : super(key: key);
final FocusNode searchFieldFocusNode;

  const NothingFoundWidget({Key? key, required this.searchFieldFocusNode,
  }) : super(key: key);


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
        onTap: () => searchFieldFocusNode.requestFocus(),
      ),
    );
  }
}



class LoadingErrorWidget extends StatelessWidget {
  // const LoadingErrorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<MainBloc>(context, listen: false);


    return Center(
      child: InfoWithButton(
        title: 'Error happened',
        assetImage: SuperheroesImages.superMan,
        imageTopPadding: 22,
        buttonText: 'Retry',
        subtitle: 'Please, try again',
        imageWidth: 126,
        imageHeight: 106,
        onTap: bloc.retry,   // равен  onTap: () => bloc.retry(),
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
          // textAlign: TextAlign.center,
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












