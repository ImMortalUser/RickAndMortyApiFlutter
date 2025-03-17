import 'dart:convert';
import 'dart:typed_data';

class Character {
  final int id;
  final String name;
  final String status;
  final String species;
  final String image;
  String? base64Image;

  Character({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.image,
    this.base64Image,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'],
      name: json['name'],
      status: json['status'],
      species: json['species'],
      image: json['image'],
      base64Image: json['base64Image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'species': species,
      'image': image,
      'base64Image': base64Image,
    };
  }

  static List<Character> fromJsonList(String str) {
    final jsonData = json.decode(str);
    return List<Character>.from(jsonData.map((x) => Character.fromJson(x)));
  }

  Uint8List? getImageBytes() {
    if (base64Image != null) {
      return base64Decode(base64Image!);
    } else {
      return null;
    }
  }
}
