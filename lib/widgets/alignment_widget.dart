import 'package:flutter/material.dart';
import 'package:superheroes/model/alignment_info.dart';
import 'package:superheroes/resources/superheroes_colors.dart';

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

// RotatedBox(
//     quarterTurns: 1,
//     child: Padding(
//       padding: const EdgeInsets.only(left: 16),
//       child: BiographyField(
//           fieldName: 'GOOD', fieldValue: SuperheroesColors.green),
//     )),