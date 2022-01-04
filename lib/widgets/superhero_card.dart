import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:superheroes/blocs/main_bloc.dart';
import 'package:superheroes/resources/superheroes_colors.dart';
import 'package:superheroes/resources/superheroes_images.dart';

class SuperheroCard extends StatelessWidget {
  final SuperheroInfo superheroInfo; // рефакторим - используем аналогичные данные из типа - SuperheroInfo
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
            Container(
                color: Colors.white24,
                height: 70, width: 70,
                child: CachedNetworkImage(
                  imageUrl: superheroInfo.imageUrl,
                  width: 70, height: 70,
                  fit: BoxFit.cover,
                  progressIndicatorBuilder: (context, url, progress) {
                    return Container(alignment: Alignment.center,
                      height: 24, width: 24, color: SuperheroesColors.white24,
                      child: CircularProgressIndicator(color: SuperheroesColors.blue,
                        value: progress.progress,
                      ),
                    );
                    },
                      errorWidget: (context, url, error) {
                    return Center(
                      child: Image.asset(SuperheroesImages.unknownMan, width: 20, height: 62,
                      fit: BoxFit.cover,  ///
                      ),
                    );
                  },
                ),
            ),
            // Image.network(superheroInfo.imageUrl, fit: BoxFit.cover, width: 70, height: 70,),
            const SizedBox(width: 12),
            Expanded(
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
            )
          ],
          // children[
          //
          // ]
        ),
      ),
    );
  }
}

// class SuperheroCard extends StatelessWidget {
//   final String name;
//   final String realName;
//   final String imageUrl;
//   final VoidCallback onTap;
//
//   const SuperheroCard({
//     Key? key,
//     required this.name,
//     required this.realName,
//     required this.imageUrl,
//     required this.onTap,
//   }) : super(key: key);
//
//   // factory SuperheroCard.superheroInfo() => SuperheroCard(name: '', realName: '', imageUrl: '',);
//
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         height: 70,
//         clipBehavior: Clip.antiAlias, // сглаживание углов
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(8), // не сглаживает углы у картинок
//           color: SuperheroesColors.backgroundGrey,
//         ),
//         child: Row(
//           // mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.network(
//               imageUrl,
//               fit: BoxFit.cover,
//               width: 70,
//               height: 70,
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     name.toUpperCase(),
//                     style: TextStyle(
//                         fontWeight: FontWeight.w700,
//                         fontSize: 16,
//                         color: SuperheroesColors.text),
//                   ),
//                   Text(
//                     realName,
//                     style: TextStyle(
//                         fontWeight: FontWeight.w400,
//                         fontSize: 14,
//                         color: SuperheroesColors.text),
//                   ),
//                 ],
//               ),
//             )
//           ],
//           // children[
//           //
//           // ]
//         ),
//       ),
//     );
//   }
// }

// var1 =======================
//
// class SuperheroCard extends StatelessWidget {
//   final String name;
//   final String realName;
//   final String imageUrl;
//   final VoidCallback onTap;
//
//   const SuperheroCard({
//     Key? key,
//     required this.name,
//     required this.realName,
//     required this.imageUrl,
//     required this.onTap,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Text(superheroInfo.toString()),
//     );
//   }
// }

//
//
//
//
// class _SuperheroInfo extends StatelessWidget {
//   const _SuperheroInfo({
//     Key? key,
//     required this.imageUrl,
//     required this.name,
//     required this.realName,
//   }) : super(key: key);
//
//   final String imageUrl;
//   final String name;
//   final String realName;
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 70,
//       clipBehavior: Clip.antiAlias, // сглаживание углов
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(8), // не сглаживает углы у картинок
//         color: SuperheroesColors.backgroundGrey,
//       ),
//       child: Row(
//         // mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Image.network(
//             imageUrl,
//             fit: BoxFit.cover,
//             width: 70,
//             height: 70,
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   name.toUpperCase(),
//                   style: TextStyle(
//                       fontWeight: FontWeight.w700,
//                       fontSize: 16,
//                       color: SuperheroesColors.text),
//                 ),
//                 Text(
//                   realName,
//                   style: TextStyle(
//                       fontWeight: FontWeight.w400,
//                       fontSize: 14,
//                       color: SuperheroesColors.text),
//                 ),
//               ],
//             ),
//           )
//         ],
//         // children[
//         //
//         // ]
//       ),
//     );
//   }
// }
