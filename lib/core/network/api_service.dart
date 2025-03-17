import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/character.dart';

class ApiService {
  static const String baseUrl = 'https://rickandmortyapi.com/api/character';

  static Future<List<Character>> fetchCharactersById(int initId, int amount) async {
    List<int> ids = [for (int id = initId; id < initId + amount; ++id) id];
    final response = await http.get(Uri.parse('$baseUrl/${ids.join(",")}'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      List<Character> characters = data.map((e) => Character.fromJson(e)).toList();

      return characters;
    } else {
      throw Exception('Error loading');
    }
  }

  static Future<String?> downloadImage(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return base64Encode(response.bodyBytes);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
