import 'package:flutter_bloc/flutter_bloc.dart';
import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState(theme: AppTheme.light)) {
    on<ToggleThemeEvent>((event, emit) {
      emit(ThemeState(
        theme: state.theme == AppTheme.light ? AppTheme.dark : AppTheme.light,
      ));
    });
  }
}
