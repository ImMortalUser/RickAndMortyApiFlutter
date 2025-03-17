import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_api_project/core/storage/local_storage.dart';
import 'package:rick_and_morty_api_project/core/storage/network_storage.dart';
import '../../models/character.dart';

part 'characters_event.dart';

part 'characters_state.dart';

class CharactersBloc extends Bloc<CharactersEvent, CharactersState> {
  final int _characterPacketSize = 10;
  final int maxCharacters = 826;
  int _packet = 1;
  List<Character> _characters = [];

  CharactersBloc() : super(CharactersInitLoading()) {
    on<InitLoad>(_onLoadCharacters);
    on<LoadNextCharacters>(_onLoadMoreCharacters);
  }

  Future<void> _onLoadCharacters(
      InitLoad event, Emitter<CharactersState> emit) async {
    try {
      _packet = 1;
      emit(CharactersInitLoading());

      _characters = await _loadCharactersFromSource();

      emit(CharactersLoaded(
          characters: _characters,
          hasReachedMax: _packet * _characterPacketSize >= maxCharacters));
    } catch (e) {
      emit(CharactersLoadingError(message: e.toString()));
    }
  }

  Future<void> _onLoadMoreCharacters(
      LoadNextCharacters event, Emitter<CharactersState> emit) async {
    if (_packet * _characterPacketSize >= maxCharacters ||
        state is CharactersLoading) {
      return;
    }

    try {
      emit(CharactersLoading(
          characters: List.of(_characters),
          hasReachedMax: _packet * _characterPacketSize >= maxCharacters));

      _packet++;
      List<Character> newCharacters = await _loadCharactersFromSource();
      _characters.addAll(newCharacters);

      emit(CharactersLoaded(
          characters: List.of(_characters),
          hasReachedMax: _packet * _characterPacketSize >= maxCharacters));
    } catch (e) {
      emit(CharactersLoadingError(message: e.toString()));
    }
  }

  Future<List<Character>> _loadCharactersFromSource() async {
    int start = (_packet - 1) * _characterPacketSize + 1;
    int amount = _characterPacketSize;
    if (start + amount > maxCharacters) amount = maxCharacters - start;

    List<Character> characters = [];
    characters = await CharacterRepository().getCharacters(start, amount);
    if (characters.length == amount) return characters;

    amount = amount - characters.length;
    try {
      List<Character> charactersFromApi = await NetworkStorage()
          .getCharacters(start + characters.length, amount);
      for (Character character in charactersFromApi) {
        CharacterRepository().saveCharacter(character);
      }
      characters.addAll(charactersFromApi);
    } catch (e) {}

    return characters;
  }
}
