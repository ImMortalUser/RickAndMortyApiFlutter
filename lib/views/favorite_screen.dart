import 'package:flutter/material.dart';
import 'package:rick_and_morty_api_project/widgets/character_card.dart';
import '../core/storage/local_storage.dart';
import '../models/character.dart';

class FavoriteScreen extends StatefulWidget {
  final int sortOption;

  const FavoriteScreen({super.key, required this.sortOption});

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<Character> _favoriteCharacters = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavoriteCharacters();
  }

  @override
  void didUpdateWidget(covariant FavoriteScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.sortOption != widget.sortOption) {
      _sortFavoriteCharacters();
    }
  }

  void removeFromListList(Character character) {
    setState(() {
      _favoriteCharacters.remove(character);
    });
  }

  Future<void> _loadFavoriteCharacters() async {
    List<Character> favoriteCharacters = await CharacterRepository().getFavoriteCharacters();

    setState(() {
      _favoriteCharacters = favoriteCharacters;
      _sortFavoriteCharacters();
      _isLoading = false;
    });
  }

  void _sortFavoriteCharacters() {
    switch (widget.sortOption) {
      case 0:
        _favoriteCharacters.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 1:
        _favoriteCharacters.sort((a, b) => a.species.compareTo(b.species));
        break;
      case 2:
        _favoriteCharacters.sort((a, b) => a.status.compareTo(b.status));
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
      itemCount: _favoriteCharacters.length,
      itemBuilder: (context, index) {
        final character = _favoriteCharacters[index];
        return CharacterCard(
          character: character,
          callBack: removeFromListList,
        );
      },
    );
  }
}
