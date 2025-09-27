import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/theme_entity.dart';
import '../../domain/entities/theme_mode.dart';
import '../../domain/usecases/get_theme.dart';
import '../../domain/usecases/save_theme.dart';
import '../../../logger/logger.dart';
import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final GetTheme _getTheme;
  final SaveTheme _saveTheme;

  ThemeBloc({
    required GetTheme getTheme,
    required SaveTheme saveTheme,
  })  : _getTheme = getTheme,
        _saveTheme = saveTheme,
        super(const ThemeInitial()) {
    on<ThemeLoadRequested>(_onThemeLoadRequested);
    on<ThemeModeChanged>(_onThemeModeChanged);
  }

  Future<void> _onThemeLoadRequested(
    ThemeLoadRequested event,
    Emitter<ThemeState> emit,
  ) async {
    emit(const ThemeLoading());
    
    try {
      await Logger.info('Carregando tema da aplicação', tag: 'THEME');
      final theme = await _getTheme();
      emit(ThemeLoaded(theme));
      
      await Logger.success(
        'Tema carregado com sucesso',
        tag: 'THEME',
        metadata: {
          'mode': theme.mode.name,
          'isDark': theme.isDark,
        },
      );
    } catch (e) {
      await Logger.errorWithException('Erro ao carregar tema', e, tag: 'THEME');
      emit(ThemeError(e.toString()));
    }
  }

  Future<void> _onThemeModeChanged(
    ThemeModeChanged event,
    Emitter<ThemeState> emit,
  ) async {
    try {
      await Logger.info(
        'Mudando tema da aplicação',
        tag: 'THEME',
        metadata: {
          'newMode': event.mode.name,
        },
      );
      
      final newTheme = ThemeEntity(mode: event.mode);
      await _saveTheme(newTheme);
      emit(ThemeLoaded(newTheme));
      
      await Logger.success(
        'Tema alterado com sucesso',
        tag: 'THEME',
        metadata: {
          'mode': newTheme.mode.name,
          'isDark': newTheme.isDark,
        },
      );
    } catch (e) {
      await Logger.errorWithException('Erro ao alterar tema', e, tag: 'THEME');
      emit(ThemeError(e.toString()));
    }
  }
}
