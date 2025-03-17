import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/characters/characters_bloc.dart';

import 'app.dart';
import 'blocs/theme/theme_block.dart';

Future<void> main() async {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => CharactersBloc()),
        BlocProvider(create: (context) => ThemeBloc()),
      ],
      child: MyApp(),
    ),
  );
}
