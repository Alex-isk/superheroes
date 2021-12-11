import 'package:flutter/material.dart';
import 'package:superheroes/resources/superheroes_colors.dart';

import 'action_button.dart';

class InfoWithButton extends StatelessWidget {
  final String title; // самый крупный текст
  final String subtitle; // меньше, капсом
  final String buttonText; // текст на кнопке
  final String assetImage; // адрес до картинки
  final double imageHeight; // высота картинки
  final double imageWidth; // ширина картинки
  final double imageTopPadding; // отступ у картинки сверху в Stack

  const InfoWithButton({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.assetImage,
    required this.imageHeight,
    required this.imageWidth,
    required this.imageTopPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        // crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.topCenter,
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
              Padding(
                padding: EdgeInsets.only(
                  top: imageTopPadding,
                ),
                child: Image.asset(
                  assetImage,
                  // 'assets/images/hulk.png',
                  width: imageWidth,
                  height: imageHeight,
                  // width: 108,
                  // height: 119,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            title,
            // 'Nothing found',
            // textAlign: TextAlign.center,
            style: TextStyle(
              color: SuperheroesColors.text,
              fontSize: 32,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            subtitle.toUpperCase(),
            // 'Search for something else'.toUpperCase(),
            // textAlign: TextAlign.center,
            style: TextStyle(
              color: SuperheroesColors.text,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 30),
          ActionButton(
            onTap: () {},
            text: buttonText,
            // 'Search',
          ),
        ]);
  }
}
