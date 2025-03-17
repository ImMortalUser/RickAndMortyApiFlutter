import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/theme/theme_block.dart';
import 'blocs/theme/theme_state.dart';
import 'views/main_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return MaterialApp(
          theme: themeState.theme == AppTheme.light
              ? ThemeData.light()
              : ThemeData.dark(),
          home: MainScreen(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
