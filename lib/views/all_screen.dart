import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_api_project/widgets/character_card.dart';

import '../blocs/characters/characters_bloc.dart';

class AllScreen extends StatefulWidget {
  const AllScreen({super.key});

  @override
  _AllScreenState createState() => _AllScreenState();
}

class _AllScreenState extends State<AllScreen> {
  final logoPadding = 6;
  final loadThreshold = 5;
  final circularLoaderPadding = 10.0;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    context.read<CharactersBloc>().add(InitLoad());

    _scrollController.addListener(() {
      if (_scrollController.position.extentAfter <= loadThreshold &&
          !_scrollController.position.outOfRange) {
        if (context.read<CharactersBloc>().state is! CharactersLoading) {
          context.read<CharactersBloc>().add(LoadNextCharacters());
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CharactersBloc, CharactersState>(
      builder: (context, state) {
        if (state is CharactersInitLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is CharactersLoaded || state is CharactersLoading) {
          final characters = state is CharactersLoaded
              ? state.characters
              : (state as CharactersLoading).characters;

          return ListView.builder(
            controller: _scrollController,
            itemCount: characters.length + 1,
            itemBuilder: (context, index) {
              if (index == characters.length) {
                return Center(
                  child: Container(
                    padding: EdgeInsets.only(bottom: circularLoaderPadding),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              final character = characters[index];
              return CharacterCard(
                character: character,
              );
            },
          );
        } else if (state is CharactersLoadingError) {
          return Center(child: Text("Load error"));
        }
        return SizedBox.shrink();
      },
    );
  }
}
