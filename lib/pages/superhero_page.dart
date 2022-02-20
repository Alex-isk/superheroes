import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superheroes/blocs/superhero_bloc.dart';
import 'package:superheroes/model/alignment_info.dart';
import 'package:superheroes/model/biography.dart';
import 'package:superheroes/model/powerstats.dart';
import 'package:superheroes/model/server_image.dart';
import 'package:superheroes/model/superhero.dart';
import 'package:superheroes/resources/superheroes_colors.dart';
import 'package:superheroes/resources/superheroes_icons.dart';
import 'package:superheroes/resources/superheroes_images.dart';
import 'package:superheroes/widgets/action_button.dart';
import 'package:http/http.dart' as http;

import 'package:superheroes/widgets/info_with_button.dart';
import 'package:superheroes/widgets/superhero_card.dart';

class SuperheroPage extends StatefulWidget {
  final http.Client? client;
  final String id;

  SuperheroPage({Key? key, this.client, required this.id}) : super(key: key);

  @override
  _SuperheroPageState createState() => _SuperheroPageState();
}

class _SuperheroPageState extends State<SuperheroPage> {
  late SuperheroBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = SuperheroBloc(client: widget.client, id: widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: bloc,
      child: Scaffold(
        backgroundColor: SuperheroesColors.background,
        body: SuperheroContentPage(),
      ),
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}

class SuperheroContentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<SuperheroBloc>(context, listen: false);

    return StreamBuilder<Superhero>(
      stream: bloc.observeSuperhero(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return const SizedBox.shrink();
        }

        final superhero = snapshot.data!;
        print('Cot new superhero: $superhero');

        return CustomScrollView(
          slivers: [
            SuperheroAppBar(superhero: superhero),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  if (superhero.powerstats
                      .isNotNull()) // Conditional Operator — Условный оператор
                    PowerstatsWidget(powerstats: superhero.powerstats),
                  BiographyWidget(biography: superhero.biography),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class SuperheroAppBar extends StatelessWidget {
  const SuperheroAppBar({
    Key? key,
    required this.superhero,
  }) : super(key: key);

  final Superhero superhero;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      // primary: true,    // по умолчанию true, при false стрелка-возврат съезжает все на верх // отображается ли SliverAppBar в верхней части экрана или нет
      stretch: true, // скролл
      pinned: true, // сверху
      floating: true, //при скролле вниз - картинка выезжает,
      expandedHeight: 348, // выезжает по высоте
      actions: [FavoriteButton()],
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
        centerTitle: true, // по центру
        background: CachedNetworkImage(
          imageUrl: superhero.image.url,
          fit: BoxFit.cover,
          placeholder: (context, url) {
            /// передается функция а не виджет поэтому через return
            return ColoredBox(color: SuperheroesColors.indigo75);
          },
          errorWidget: (context, url, error) {
            /// передается функция а не виджет поэтому через return
            return Container(
              alignment: Alignment.center,
              color: SuperheroesColors.indigo75,
              child: Image.asset(
                SuperheroesImages.unknownManBig,
                height: 264,
                width: 85,
              ),
            );
          },
        ),
      ),
    );
  }
}

class FavoriteButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<SuperheroBloc>(context, listen: false);
    return StreamBuilder<SuperheroPageState>(
        stream: bloc.observeSuperheroPageState(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return const SizedBox.shrink();
          }
          final state = snapshot.data!;
          switch (state) {
            case SuperheroPageState.loading:
              return SuperheroLoadingWidget();
            case SuperheroPageState.loaded:
              return SuperheroLoadedWidget();
            case SuperheroPageState.error:
            default:
              return SuperheroErrorWidget();
          }
        },
    );
  }
}

class SuperheroLoadedWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<SuperheroBloc>(context, listen: false);

    return StreamBuilder<bool>(
        stream: bloc.observeIsFavorite(),
        initialData: false,
        builder: (context, snapshot) {
          final favorite =
              !snapshot.hasData || snapshot.data == null || snapshot.data!;
          return GestureDetector(
            onTap: () =>
                favorite ? bloc.removeFromFavorites() : bloc.addToFavorite(),
            child: Container(
              height: 52,
              width: 52,
              alignment: Alignment.center,
              child: Image.asset(
                favorite
                    ? SuperheroesIcons.starFilled
                    : SuperheroesIcons.starEmpty,
                height: 32,
                width: 32,
              ),
            ),
          );
        });
  }
}

class PowerstatsWidget extends StatelessWidget {
  final Powerstats powerstats;

  const PowerstatsWidget({Key? key, required this.powerstats})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: Text(
            'Powerstats'.toUpperCase(),
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: SuperheroesColors.text,
              fontSize: 18,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            const SizedBox(width: 16),
            Expanded(
              child: Center(
                child: PowerstatWidget(
                  name: 'Intelligence',
                  value: powerstats.intelligencePercent,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: PowerstatWidget(
                  name: 'Strengt',
                  value: powerstats.strengthPercent,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: PowerstatWidget(
                  name: 'Speed',
                  value: powerstats.strengthPercent,
                ),
              ),
            ),
            const SizedBox(width: 16),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            const SizedBox(width: 16),
            Expanded(
              child: Center(
                child: PowerstatWidget(
                  name: 'Durability',
                  value: powerstats.durabilityPercent,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: PowerstatWidget(
                  name: 'Power',
                  value: powerstats.powerPercent,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: PowerstatWidget(
                  name: 'Combat',
                  value: powerstats.combatPercent,
                ),
              ),
            ),
            const SizedBox(width: 16),
          ],
        ),
        const SizedBox(height: 36),
      ],
    );
  }
}

class PowerstatWidget extends StatelessWidget {
  final String name;
  final double value;

  const PowerstatWidget({
    Key? key,
    required this.name,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        ArcWidget(value: value, color: calculateColorByValue()),
        Padding(
          padding: const EdgeInsets.only(top: 17),
          child: Text(
            '${(value * 100).toInt()}',
            style: TextStyle(
              color: calculateColorByValue(),
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 44),
          child: Text(
            name.toUpperCase(),
            style: TextStyle(
              color: SuperheroesColors.text,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Color calculateColorByValue() {
    if (value <= 0.5) {
      return Color.lerp(Colors.red, Colors.orangeAccent, value / 0.5)!;
    } else {
      return Color.lerp(
          Colors.orangeAccent, Colors.green, (value - 0.5) / 0.5)!;
    }
  }
}

class ArcWidget extends StatelessWidget {
  final double value;
  final Color color;

  const ArcWidget({Key? key, required this.value, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ArcCustomPainter(value, color),
      size: Size(66, 33),
    );
  }
}

class ArcCustomPainter extends CustomPainter {
  final double value;
  final Color color;

  ArcCustomPainter(this.value, this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(
        0,
        0,
        size.width,
        size.height *
            2); // не меняя размеры CustomPaint Size(66, 33), умножим конкретно для арки на 2

    final backgroundPaint = Paint()
      ..color = SuperheroesColors.white24
      ..style = PaintingStyle.stroke // только граница
      ..strokeCap = StrokeCap.round // окончание границ - закругленные
      ..strokeWidth = 6; // ширина

    final paint = Paint()
      ..color = color // цвет который получили в конструкторе
      ..style = PaintingStyle.stroke // только граница
      ..strokeCap = StrokeCap.round // окончание границ - закругленные
      ..strokeWidth = 6; // ширина

    // canvas.drawArc(rect, startAngle,    sweepAngle,                                                       useCenter,                  paint)
    // canvas.drawArc(rect,   старт-pi,    на сколько повернем-pi*value(умножаем на value которое получили),   false-сектор не заполнен, paint);

    canvas.drawArc(rect, pi, pi, false,
        backgroundPaint); // рисуем от pi до pi    // 1=важна последовательность - накладываются сперва фон
    canvas.drawArc(rect, pi, pi * value, false,
        paint); // 2=важна последовательность - накладываются
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is ArcCustomPainter) {
      return oldDelegate.value != value &&
          oldDelegate.color !=
              color; // если предыдущий CustomPainter такогоже типа ноимеет др значение и цвет - то перерисовываем
    }
    return true;
  }
}

// class BiographyWidget extends StatelessWidget {
//   final Biography biography;
//
//   const BiographyWidget({Key? key, required this.biography}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 300,
//       alignment: Alignment.center,
//       child: Text(biography.toJson().toString(),
//           style: TextStyle(color: Colors.white)),
//     );
//   }
// }

class BiographyWidget extends StatelessWidget {
  final Biography biography;

  const BiographyWidget({Key? key, required this.biography}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: SuperheroesColors.indigo75,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 16, top: 16, right: 16, bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Bio'.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: SuperheroesColors.text,
                  ),
                ),
                const SizedBox(height: 8),
                BiographyField(
                  fieldName: 'Full name',
                  fieldValue: biography.fullName,
                ),
                const SizedBox(height: 20),
                BiographyField(
                  fieldName: 'Aliases',
                  fieldValue: biography.aliases.join(', '),
                ),
                const SizedBox(height: 20),
                BiographyField(
                  fieldName: 'Place of birth',
                  fieldValue: biography.placeOfBirth,
                ),
              ],
            ),
          ),
          if (biography.alignmentInfo != null)
            Align(
                alignment: Alignment.topRight,
                child: AlignmentWidget(
                  alignmentInfo: biography.alignmentInfo!,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),

                    ///  закругления
                    bottomRight: Radius.circular(16),
                  ),
                )),
          // RotatedBox(
          //     quarterTurns: 1,
          //     child: Padding(
          //       padding: const EdgeInsets.only(left: 16),
          //       child: BiographyField(
          //           fieldName: 'GOOD', fieldValue: SuperheroesColors.green),
          //     )),
        ],
      ),
    );
  }
}

class SuperheroLoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(backgroundColor: SuperheroesColors.background,),
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.only(top: 60),
            alignment: Alignment.topCenter,
            height: 44,
            width: 44,
            child: CircularProgressIndicator(
              color: SuperheroesColors.blue,
            ),
          ),
        ),
      ],
    );
  }
}

class SuperheroErrorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<SuperheroBloc>(context, listen: false);
    return CustomScrollView(
      slivers: [
        SliverAppBar(backgroundColor: SuperheroesColors.background,),
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.only(top: 60),
            alignment: Alignment.topCenter,
            child: InfoWithButton(
              title: 'Error happened',
              assetImage: SuperheroesImages.superMan,
              imageTopPadding: 22,
              buttonText: 'Retry',
              subtitle: 'Please, try again',
              imageWidth: 126,
              imageHeight: 106,
              onTap: bloc.retry, // равен  onTap: () => bloc.retry(),
            ),
          ),
        ),
      ],
    );
  }
}

// class BiographyWidget extends StatelessWidget {
//   final Biography biography;
//
//   const BiographyWidget({Key? key, required this.biography}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Stack(
//           children: [
//             Container(
//               // width: 328, height: 261,
//               margin: EdgeInsets.symmetric(horizontal: 16),
//               // color: SuperheroesColors.backgroundGrey,
//               padding: const EdgeInsets.only(
//                   left: 16, top: 16, right: 16, bottom: 24),
//               decoration: BoxDecoration(
//                 color: SuperheroesColors.backgroundGrey,
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   Text(
//                     'Bio'.toUpperCase(),
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontWeight: FontWeight.w700,
//                       fontSize: 18,
//                       color: SuperheroesColors.text,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     'Full name'.toUpperCase(),
//                     textAlign: TextAlign.start,
//                     style: TextStyle(
//                       fontWeight: FontWeight.w700,
//                       fontSize: 12,
//                       color: SuperheroesColors.textGrey,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     biography.fullName,
//                     textAlign: TextAlign.start,
//                     style: TextStyle(
//                       fontWeight: FontWeight.w400,
//                       fontSize: 16,
//                       color: SuperheroesColors.text,
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   Text(
//                     'Aliases'.toUpperCase(),
//                     textAlign: TextAlign.start,
//                     style: TextStyle(
//                       fontWeight: FontWeight.w700,
//                       fontSize: 12,
//                       color: SuperheroesColors.textGrey,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     biography.aliases.join(),
//                     textAlign: TextAlign.start,
//                     style: TextStyle(
//                       fontWeight: FontWeight.w400,
//                       fontSize: 16,
//                       color: SuperheroesColors.text,
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   Text(
//                     'Place of birth'.toUpperCase(),
//                     textAlign: TextAlign.start,
//                     style: TextStyle(
//                       fontWeight: FontWeight.w700,
//                       fontSize: 12,
//                       color: SuperheroesColors.textGrey,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     biography.placeOfBirth,
//                     textAlign: TextAlign.start,
//                     style: TextStyle(
//                       fontWeight: FontWeight.w400,
//                       fontSize: 16,
//                       color: SuperheroesColors.text,
//                     ),
//                   ),
//                   const SizedBox(height: 24),
//                 ],
//               ),
//             ),
//
//             // AlignmentWidget(alignmentInfo: ),
//             RotatedBox(
//                 quarterTurns: 1,
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 16),
//                   child: BiographyAlignment(
//                       text: 'GOOD', color: SuperheroesColors.green),
//                 )),
//           ],
//         ),
//         const SizedBox(height: 36),
//       ],
//     );
//   }
// }

class BiographyField extends StatelessWidget {
  final String fieldName;
  final String fieldValue;

  const BiographyField(
      {Key? key, required this.fieldName, required this.fieldValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            fieldName.toUpperCase(),
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 12,
              color: SuperheroesColors.textGrey,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            fieldValue,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16,
              color: SuperheroesColors.text,
            ),
          ),
        ]);
  }
}



class AlignmentWidget extends StatelessWidget {
  final AlignmentInfo alignmentInfo;
  final BorderRadius borderRadius;
  const AlignmentWidget({Key? key,
    required this.alignmentInfo,
    required this.borderRadius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: 1,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 6),
        height: 24,
        width: 70,

        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: alignmentInfo.color,
          borderRadius: borderRadius,
        ),
        child: Text(
          alignmentInfo.name.toUpperCase(),
          style: TextStyle(
            color: SuperheroesColors.text,
            fontWeight: FontWeight.w700,
            fontSize: 10,
          ),
        ),
      ),
    );
  }
}
