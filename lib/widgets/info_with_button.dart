

import 'package:flutter/material.dart';
import 'package:superheroes/resources/superheroes_colors.dart';

import 'action_button.dart';



class InfoWithButton extends StatelessWidget {
  final String title;  // самый крупный текст
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
      Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: 126, top: 165, right: 126),
            child: Container(
              width: 108,
              height: 108,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(54),
                color: SuperheroesColors.blue,
              ),
            ),
          ),
          Container(
            // alignment: Alignment.center,
            // color: Colors.amber,
            child: Padding(
              padding: EdgeInsets.only(
                  left: 126, top: imageTopPadding, right: 126),
                  // left: 126, top: 174, right: 126),
              child: Image.asset(assetImage,
                // 'assets/images/hulk.png',
                  width: imageWidth,
                  height: imageHeight,
                // width: 108,
                // height: 119,
              ),
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
          title,
          // 'Nothing found',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: SuperheroesColors.text,
            fontSize: 32,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      SizedBox(height: 30),
      Text(subtitle.toUpperCase(),
        // 'Search for something else'.toUpperCase(),
        textAlign: TextAlign.center,
        style: TextStyle(
          color: SuperheroesColors.text,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
      SizedBox(height: 20),
      ActionButton(
        onTap: () {},
        text: buttonText,
        // 'Search',
      ),
    ]);
  }
}





//
// class MainPageStateNothingFound extends StatelessWidget {
//   // final String title;  // самый крупный текст
//   // final String subtitle; // меньше, капсом
//   // final String buttonText; // текст на кнопке
//   // final String assetImage; // адрес до картинки
//   // final double imageHeight; // высота картинки
//   // final double imageWidth; // ширина картинки
//   // final double imageTopPadding; // отступ у картинки сверху в Stack
//
//
//   const MainPageStateNothingFound({
//       Key? key,
//         // required this.title,
//         // required this.subtitle,
//         // required this.buttonText,
//         // required this.assetImage,
//         // required this.imageHeight,
//         // required this.imageWidth,
//         // required this.imageTopPadding,
//       }) : super(key: key);
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
//       Stack(
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(
//                 left: 126, top: 165, right: 126),
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
//               padding: const EdgeInsets.only(
//                   left: 126, top: 174, right: 126),
//               child: Image.asset(
//                 'assets/images/hulk.png',
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
//           'Nothing found',
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
//         'Search for something else'.toUpperCase(),
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
//

//
// class MainPageStateLoadingError extends StatelessWidget {
//   // final String title;  // самый крупный текст
//   // final String subtitle; // меньше, капсом
//   // final String buttonText; // текст на кнопке
//   // final String assetImage; // адрес до картинки
//   // final double imageHeight; // высота картинки
//   // final double imageWidth; // ширина картинки
//   // final double imageTopPadding; // отступ у картинки сверху в Stack
//
//
//   const MainPageStateLoadingError ({
//     Key? key,
//     // required this.title,
//     // required this.subtitle,
//     // required this.buttonText,
//     // required this.assetImage,
//     // required this.imageHeight,
//     // required this.imageWidth,
//     // required this.imageTopPadding,
//   }) : super(key: key);
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
//       Stack(
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(
//                 left: 126, top: 165, right: 126),
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
//               padding: const EdgeInsets.only(
//                   left: 126, top: 174, right: 126),
//               child: Image.asset(
//                 'assets/images/superman.png',
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
//           'Error happened',
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
//         'Please, try again'.toUpperCase(),
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
//         text: 'Retry',
//       ),
//     ]);
//   }
// }