
import 'package:json_annotation/json_annotation.dart';

part 'biography.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab, explicitToJson: true)
class Biography {
  final String fullName;
  final String alignment;

   Biography({
      required this.fullName,
      required this.alignment,
   });
  // Biography(this.fullName, this.alignment);

  factory Biography.fromJson(final Map<String, dynamic> json) => _$BiographyFromJson(json);

  Map<String, dynamic> toJson() => _$BiographyToJson(this);

}




// class Biography {
//   final String fullName;
//
//   Biography(this.fullName);
//
//   factory Biography.fromJson(final Map<String, dynamic> json) => Biography(json['full-name']);
//
//   Map<String, dynamic> toJson() => {'full-name': fullName};
// }