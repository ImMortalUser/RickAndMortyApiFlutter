import 'package:flutter/material.dart';
import 'package:rick_and_morty_api_project/core/network/api_service.dart';
import '../core/storage/local_storage.dart';
import '../models/character.dart';
import 'favorite_button.dart';

class CharacterCard extends StatefulWidget {
  final Character character;
  final callBack;

  const CharacterCard({
    super.key,
    required this.character,
    this.callBack,
  });

  @override
  _CharacterCardState createState() => _CharacterCardState();
}

class _CharacterCardState extends State<CharacterCard> {
  final marginHorizontal = 16.0;
  final marginVertical = 8.0;
  final padding = 8.0;
  final borderRadius = 8.0;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    if (widget.character.base64Image == null) {
      String? base64Image =
          await ApiService.downloadImage(widget.character.image);
      if (base64Image != null) {
        widget.character.base64Image = base64Image;
        CharacterRepository().saveCharacter(widget.character);
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
          horizontal: marginHorizontal, vertical: marginVertical),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: EdgeInsets.all(padding),
        leading: widget.character.base64Image != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(borderRadius),
                child: Image.memory(widget.character.getImageBytes()!,
                    fit: BoxFit.cover),
              )
            : Icon(Icons.circle_outlined),
        title: Text(widget.character.name,
            style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle:
            Text('${widget.character.status} - ${widget.character.species}'),
        trailing: FavoriteButton(
          character: widget.character,
          callBack: widget.callBack,
        ),
      ),
    );
  }
}
