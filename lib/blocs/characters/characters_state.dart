part of 'characters_bloc.dart';

abstract class CharactersState extends Equatable {
  @override
  List<Object> get props => [];
}

class CharactersInitLoading extends CharactersState {}

class CharactersLoaded extends CharactersState {
  final List<Character> characters;
  final bool hasReachedMax;

  CharactersLoaded({required this.characters, required this.hasReachedMax});

  @override
  List<Object> get props => [characters, hasReachedMax];
}

class CharactersLoading extends CharactersState {
  final List<Character> characters;
  final bool hasReachedMax;

  CharactersLoading({required this.characters, required this.hasReachedMax});

  @override
  List<Object> get props => [characters, hasReachedMax];
}

class CharactersLoadingError extends CharactersState {
  final String message;
  CharactersLoadingError({required this.message});

  @override
  List<Object> get props => [message];
}
