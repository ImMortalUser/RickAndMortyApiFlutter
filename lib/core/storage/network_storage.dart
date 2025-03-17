import 'package:rick_and_morty_api_project/core/network/api_service.dart';
import 'package:rick_and_morty_api_project/models/character.dart';

class NetworkStorage {
  Future<List<Character>> getCharacters(int startId, int amount) async {
    return ApiService.fetchCharactersById(startId, amount);
  }
}
