


import 'package:flutter/material.dart';
import 'package:superheroes/resources/superheroes_colors.dart';




  class ActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;


    const ActionButton({
    Key? key,
    required this.text,
    required this.onTap,
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        // padding: EdgeInsets.fromLTRB(20, 8, 20, 8), // padding: EdgeInsets.fromLTRB(20, 8, 20, 8),
        decoration: BoxDecoration(
          color: SuperheroesColors.blue,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text.toUpperCase(),
          style: TextStyle(
            fontWeight: FontWeight.w700,
            // letterSpacing: 0.25,            // межбуквенный интервал
            // height: 20,                     // высота строки
            fontSize: 14,
            color: SuperheroesColors.text,
          ),
        ),
      ),
    );
  }
}


 



// line-height: 20px;       высота строки
// letter-spacing: 0.25px;  межбуквенный интервал

// text-align: left; по умолчанию расположение текста
// textAlign: TextAlign.center, по центру


// @override
// Widget build(BuildContext context) {
//   return GestureDetector(
//     onTap: onTap,
//     child: Container(
//       // height: 36, width: 96,
//       decoration: BoxDecoration(
//         color: SuperheroesColors.blue,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Padding(
//         padding: EdgeInsets.fromLTRB(20, 8, 20, 8),
//         child: Text(
//           text.toUpperCase(),
//           style: TextStyle(
//             fontWeight: FontWeight.w700,
//             letterSpacing: 0.25,            // межбуквенный интервал
//             // height: 20,                     // высота строки
//             fontSize: 14,
//             color: SuperheroesColors.text,
//           ),
//         ),
//       ),
//     ),
//   );
// }
// }