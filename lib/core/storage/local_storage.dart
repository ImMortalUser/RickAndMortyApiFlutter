import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/character.dart';

class CharacterRepository {
  static const String _favoriteListIdsKey = 'favorite_characters';
  static const String _characterKey = 'character_';

  saveCharacter(Character character) async {
    final prefs = await SharedPreferences.getInstance();
    String characterJson = json.encode(character.toJson());
    await prefs.setString(
        _characterKey + character.id.toString(), characterJson);
  }

  Future<List<Character>> getCharacters(int startId, int amount) async {
    final prefs = await SharedPreferences.getInstance();
    List<Character> characters = [];

    for (int id = startId; id < startId + amount; ++id) {
      String? characterJson = prefs.getString(_characterKey + id.toString());
      if (characterJson != null) {
        characters.add(Character.fromJson(json.decode(characterJson)));
      }
    }
    return characters;
  }

  Future<List<Character>> getFavoriteCharacters() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? ids = prefs.getStringList(_favoriteListIdsKey);

    if (ids != null) {
      List<Character> characters = [];

      for (int index = 0; index < ids.length; ++index) {
        characters.addAll(await getCharacters(int.parse(ids[index]), 1));
      }
      return characters;
    }
    return [];
  }

  toggleFavorite(Character character) async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? ids = prefs.getStringList(_favoriteListIdsKey);
    if (ids != null) {
      if (ids.contains(character.id.toString())) {
        ids.remove(character.id.toString());
      } else {
        ids.add(character.id.toString());
      }
      prefs.setStringList(_favoriteListIdsKey, ids);
    } else {
      prefs.setStringList(_favoriteListIdsKey, [character.id.toString()]);
    }
  }

  Future<bool> isFavorite(Character character) async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? ids = prefs.getStringList(_favoriteListIdsKey);
    if (ids != null) {
      if (ids.contains(character.id.toString())) {
        return true;
      } else {
        return false;
      }
    }
    return false;
  }
}
