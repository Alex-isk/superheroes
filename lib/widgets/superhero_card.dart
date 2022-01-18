import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:superheroes/blocs/main_bloc.dart';
import 'package:superheroes/model/alignment_info.dart';
import 'package:superheroes/resources/superheroes_colors.dart';
import 'package:superheroes/resources/superheroes_images.dart';

class SuperheroCard extends StatelessWidget {
  final SuperheroInfo
      superheroInfo; // рефакторим - используем аналогичные данные из типа - SuperheroInfo
  final VoidCallback onTap;

  const SuperheroCard({
    Key? key,
    required this.superheroInfo,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 70,
        clipBehavior: Clip.antiAlias, // сглаживание углов
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(8), // не сглаживает углы у картинок
          color: SuperheroesColors.backgroundGrey,
        ),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _AvatarWidget(superheroInfo: superheroInfo),
            // Image.network(superheroInfo.imageUrl, fit: BoxFit.cover, width: 70, height: 70,),
            const SizedBox(width: 12),
            NameAndRealNameWidget(superheroInfo: superheroInfo),
            if (superheroInfo.alignmentInfo != null)
              AlignmentWidget(alignmentInfo: superheroInfo.alignmentInfo!),
          ],
          // children[
          //
          // ]
        ),
      ),
    );
  }
}

class AlignmentWidget extends StatelessWidget {
  final AlignmentInfo alignmentInfo;

  const AlignmentWidget({Key? key, required this.alignmentInfo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: 1,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 6),
        color: alignmentInfo.color,
        alignment: Alignment.center,
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

class NameAndRealNameWidget extends StatelessWidget {
  const NameAndRealNameWidget({
    Key? key,
    required this.superheroInfo,
  }) : super(key: key);

  final SuperheroInfo superheroInfo;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            superheroInfo.name.toUpperCase(),
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: SuperheroesColors.text),
          ),
          Text(
            superheroInfo.realName,
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: SuperheroesColors.text),
          ),
        ],
      ),
    );
  }
}

class _AvatarWidget extends StatelessWidget {
  const _AvatarWidget({
    Key? key,
    required this.superheroInfo,
  }) : super(key: key);

  final SuperheroInfo superheroInfo;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white24,
      height: 70,
      width: 70,
      child: CachedNetworkImage(
        imageUrl: superheroInfo.imageUrl,
        width: 70,
        height: 70,
        fit: BoxFit.cover,
        progressIndicatorBuilder: (context, url, progress) {
          return Container(
            alignment: Alignment.center,
            height: 24,
            width: 24,
            color: SuperheroesColors.white24,
            child: CircularProgressIndicator(
              color: SuperheroesColors.blue,
              value: progress.progress,
            ),
          );
        },
        errorWidget: (context, url, error) {
          return Center(
            child: Image.asset(
              SuperheroesImages.unknownMan, width: 20, height: 62,
              fit: BoxFit.cover,

            ),
          );
        },
      ),
    );
  }
}
