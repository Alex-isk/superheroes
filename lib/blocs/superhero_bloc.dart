import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'package:superheroes/exception/api_exception.dart';
import 'package:superheroes/favorite_superheroes_storage.dart';
import 'package:superheroes/model/superhero.dart';




class SuperheroBloc {
  http.Client? client;
  final String id;

  final BehaviorSubject <SuperheroPageState> observeSuperheroPageState = BehaviorSubject<SuperheroPageState>();
  /// 2. создаем переменную _observeSuperheroPageState

  final superheroSubject = BehaviorSubject<Superhero>();

  // final observeSuperheroPageState = BehaviorSubject<SuperheroPageState>();  ///

<<<<<<< HEAD

=======

>>>>>>> b4a1fa6cf4d850f27236af5ec0eca2d7cafb4a6c


  StreamSubscription? getFromFavoritesSubscription;
  StreamSubscription? requestSubscription;
  StreamSubscription? addToFavoriteSubscription;
  StreamSubscription? removeFromFavoriteSubscription;

  // StreamSubscription? observeSuperheroPageState;  ///

  SuperheroBloc({
    this.client,
    required this.id,
  }) {
    getFromFavorites();
  }


  void getFromFavorites() {
    getFromFavoritesSubscription?.cancel();
    getFromFavoritesSubscription =
        FavoriteSuperheroesStorage.getInstance()
            .getSuperhero(id)
            .asStream()
            .listen(
              (superhero) {
            if (superhero != null) {       /// в данном методе указывается - если герой сохранен в избранном
              superheroSubject.add(superhero);
              observeSuperheroPageState.add(SuperheroPageState.loaded);  ///
                                           /// 3. Если сохранен, выдаем состояние SuperheroPageState.loaded
            }
            requestSuperhero();
          },
          onError: (error, stackTrace) =>
              print(
                  'Error happened in removeFromFavorites: $error, $stackTrace'),
        );
  }


  void addToFavorite() {
    final superhero = superheroSubject
        .valueOrNull; // valueOrNull возвращает знаечени если его в Subject нет
    if (superhero == null) {          /// в данном методе указывается - если герой не сохранен в избранном
      print("ERROR: superhero is null while shouldn't be");
      observeSuperheroPageState.add(SuperheroPageState.loading);    ///
                                     /// 4. Если не сохранен, выдаем состояние SuperheroPageState.loading
      return;
    }
    addToFavoriteSubscription?.cancel();
    addToFavoriteSubscription = FavoriteSuperheroesStorage.getInstance()
        .addToFavorites(superhero)
        .asStream()
        .listen(
          (event) {
        print('Added to favorites: $event');
      },
      onError: (error, stackTrace) =>
          print('Error happened in addToFavorite: $error, $stackTrace'),
    );
  }

  void removeFromFavorites() {
    removeFromFavoriteSubscription?.cancel();
    removeFromFavoriteSubscription =
        FavoriteSuperheroesStorage.getInstance()
            .removeFromFavorites(id)
            .asStream()
            .listen(
              (event) {
            print('Remove from favorites: $event');
          },
          onError: (error, stackTrace) =>
              print(
                  'Error happened in removeFromFavorites: $error, $stackTrace'),
        );
  }

  // Stream<bool> observeIsFavorite() => Stream.value(false);

  Stream<bool> observeIsFavorite() =>
      FavoriteSuperheroesStorage.getInstance().observeIsFavorite(id);

  void requestSuperhero() {
    requestSubscription?.cancel();
    requestSubscription = request().asStream().listen((superhero) {
      superheroSubject.add(superhero);
    }, onError: (error, stackTrace) {
      print('Error happened in requestSuperhero: $error, $stackTrace');
      observeSuperheroPageState.add(SuperheroPageState.error); ///
    });
  }
                              /// 5. Если загрузка из сети закончилась с ошибкой, но текущий супергерой не
                              /// доступен нам из избранного, выдаем состояние SuperheroPageState.error.



  Future<Superhero> request() async {
    // await Future.delayed(Duration(seconds: 1));
    final token = dotenv.env['SUPERHERO_TOKEN'];
    final response = await (client ??= http.Client())
        .get(Uri.parse('https://superheroapi.com/api/$token/$id'));
    if (response.statusCode >= 500 && response.statusCode <= 599) {
      throw ApiException('Server error happened');
    }
    if (response.statusCode >= 400 && response.statusCode <= 499) {
      throw ApiException('Client error happened');
    }
    final decoded = json.decode(response.body);
    if (decoded['response'] == 'success') {
      return Superhero.fromJson(decoded);
    } else if (decoded['response'] == 'error') {
      throw ApiException('Client error happened');
    }
    throw Exception('Unknown error happened');
  }

  Stream<Superhero> observeSuperhero() => superheroSubject;

  void dispose() {
    client?.close();

    getFromFavoritesSubscription?.cancel();
    requestSubscription?.cancel();
    addToFavoriteSubscription?.cancel();
    removeFromFavoriteSubscription?.cancel();
    superheroSubject.close();
    observeSuperheroPageState.close();/// закрываем обзор


  }
}



//   Stream<SuperheroPageState> observeSuperheroPageState() async* {     /// добавить метод
//
//     // observeSuperheroPageState?.close();
//     final superhero = superheroSubject
//         .valueOrNull; // valueOrNull возвращает значение если его в Subject нет#
//     if (superhero == null) {         /// если герой не сохранен
//       yield SuperheroPageState.loading;
//     }
//     if (superhero != null) {        /// если герой сохранен
//       yield SuperheroPageState.loaded;
//     }
//       onError: (error, stackTrace) =>
//           print('Error happened in addToFavorite: $error, $stackTrace');
//
//   }
// }

enum SuperheroPageState {   /// 1. Создать enum SuperheroPageState с тремя значениями: loading, loaded, error
  loading,
  loaded,
  error
}










//
// Stream<SuperheroPageState> observeSuperheroPageState() async* {     /// добавить метод
//
//   // observeSuperheroPageState?.cancel();
//   final superhero = superheroSubject
//       .valueOrNull; // valueOrNull возвращает значение если его в Subject нет#
//   if (superhero == null) {         /// если герой не сохранен
//     yield SuperheroPageState.loading;
//   }
//   if (superhero != null) {        /// если герой сохранен
//     yield SuperheroPageState.loaded;
//   }
//   onError: (error, stackTrace) =>
//       print('Error happened in addToFavorite: $error, $stackTrace');
//
// }
// }
//
// enum SuperheroPageState {   /// с тремя состояниями
//   loading,
//   loaded,
//   error
// }


// class SuperheroPageStateWidget extends StatelessWidget {
//   final FocusNode searchFieldFocusNode;
//
//   const SuperheroPageStateWidget({
//     Key? key,
//     required this.searchFieldFocusNode,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final SuperheroBloc bloc = Provider.of<SuperheroBloc>(context, listen: false);
//     return StreamBuilder<SuperheroPageState>(
//       stream: bloc.observeSuperheroPageState(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData || snapshot.data == null) {
//           return SizedBox();
//         }
//         final SuperheroPageState state = snapshot.data!;
//         switch (state) {
//           case SuperheroPageState.loading:
//             return Loading();
//           case SuperheroPageState.loaded:
//             return Loaded();
//           case SuperheroPageState.error:
//             return Error();
//           default:
//             return Center(
//               child: Text(
//                 state.toString(),
//                 style: TextStyle(color: SuperheroesColors.text),
//               ),
//             );
//         }
//       },
//     );
//   }
// }
