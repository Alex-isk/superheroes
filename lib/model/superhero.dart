

import 'package:json_annotation/json_annotation.dart';
import 'package:superheroes/model/server_image.dart';

import 'biography.dart';

part 'superhero.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
class Superhero {

  final String name;
  final Biography biography;
  final ServerImage image;

  Superhero(this.name, this.biography, this.image);

  factory Superhero.fromJson(final Map<String, dynamic> json) => _$SuperheroFromJson(json);

  Map<String, dynamic> toJson() => _$SuperheroToJson(this);

}







//
// import 'package:superheroes/model/biography.dart';
// import 'package:superheroes/model/server_image.dart';
//
// class Superhero {
//   final String name;
//   final Biography biography;
//   final ServerImage image;
//
//   Superhero(this.name, this.biography, this.image);
//
//   factory Superhero.fromJson(final Map<String, dynamic> json) => Superhero(
//       json['name'],
//     Biography.fromJson(json['biography']),
//       ServerImage.fromJson(json['image']),
//   );
//
//   Map<String, dynamic> toJson() => {
//     'name': name,
//     'biography': biography.toJson(),
//     'image': image.toJson(),
//   };
// }

