import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/presentation/bloc/theme_bloc.dart';
import '../../../../core/theme/presentation/bloc/theme_state.dart';
import '../../../../core/theme/domain/entities/theme_mode.dart';
import '../../../../core/theme/presentation/widgets/theme_wrapper.dart';

/// Página de exemplo mostrando como usar o sistema de temas
class ThemeExamplePage extends StatelessWidget {
  const ThemeExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Example'),
        actions: [
          // Botão para alternar tema
          BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, state) {
              final isDark = state is ThemeLoaded ? state.theme.isDark : true;
              return IconButton(
                icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                onPressed: () {
                  context.changeThemeMode(
                    isDark ? AppThemeMode.light : AppThemeMode.dark,
                  );
                },
              );
            },
          ),
        ],
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ThemeStatusCard(),
            SizedBox(height: 16),
            _ThemeExampleWidgets(),
          ],
        ),
      ),
    );
  }
}

/// Card mostrando o status atual do tema
class _ThemeStatusCard extends StatelessWidget {
  const _ThemeStatusCard();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        if (state is ThemeLoaded) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tema Atual',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Modo: ${state.theme.mode.name.toUpperCase()}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    'Escuro: ${state.theme.isDark ? "Sim" : "Não"}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          );
        }
        
        return const Card(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Carregando tema...'),
          ),
        );
      },
    );
  }
}

/// Widgets de exemplo usando o tema
class _ThemeExampleWidgets extends StatelessWidget {
  const _ThemeExampleWidgets();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Componentes com Tema',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        
        // Botões
        Wrap(
          spacing: 8,
          children: [
            ElevatedButton(
              onPressed: () {},
              child: const Text('Elevated Button'),
            ),
            FilledButton(
              onPressed: () {},
              child: const Text('Filled Button'),
            ),
            OutlinedButton(
              onPressed: () {},
              child: const Text('Outlined Button'),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Cards
        Card(
          child: ListTile(
            leading: const Icon(Icons.palette),
            title: const Text('Card com tema'),
            subtitle: const Text('Este card usa as cores do tema atual'),
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Textos com diferentes estilos
        Text(
          'Headline Large',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        Text(
          'Headline Medium',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        Text(
          'Body Large',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Text(
          'Body Medium',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
