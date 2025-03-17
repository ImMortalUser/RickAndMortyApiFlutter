import 'package:flutter/material.dart';
import 'package:rick_and_morty_api_project/models/character.dart';
import '../core/storage/local_storage.dart';

class FavoriteButton extends StatefulWidget {
  final callBack;

  const FavoriteButton({super.key, required this.character, this.callBack});

  final Character character;

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  void _toggleFavorite() async {
    setState(() {
      isFavorite = !isFavorite;
    });
    widget.callBack(widget.character);
    await CharacterRepository().toggleFavorite(widget.character);

  }

  Future<void> _loadFavoriteStatus() async {
    bool favorite = await CharacterRepository().isFavorite(widget.character);
    setState(() {
      isFavorite = favorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(
          begin: isFavorite ? 1.0 : 1.5, end: isFavorite ? 1.5 : 1.0),
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      builder: (context, double scale, child) {
        return Transform.scale(
          scale: scale,
          child: IconButton(
            icon: Icon(
              isFavorite ? Icons.star : Icons.star_border,
              color: isFavorite ? Colors.amber : Colors.grey,
            ),
            onPressed: () {
              _toggleFavorite();
            },
          ),
        );
      },
    );
  }
}
