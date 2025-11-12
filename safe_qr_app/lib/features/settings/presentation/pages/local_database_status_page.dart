import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalDatabaseStatusPage extends StatefulWidget {
  const LocalDatabaseStatusPage({super.key});

  @override
  State<LocalDatabaseStatusPage> createState() => _LocalDatabaseStatusPageState();
}

class _LocalDatabaseStatusPageState extends State<LocalDatabaseStatusPage> {
  late Future<List<_LocalDatabaseEntry>> _statusFuture;
  bool _isClearing = false;

  @override
  void initState() {
    super.initState();
    _statusFuture = _loadStatus();
  }

  Future<List<_LocalDatabaseEntry>> _loadStatus() async {
    final prefs = GetIt.I<SharedPreferences>();
    final keys = prefs.getKeys().toList()..sort();

    return keys
        .map(
          (key) => _LocalDatabaseEntry(
            key: key,
            value: prefs.get(key),
          ),
        )
        .toList();
  }

  Future<void> _refresh() async {
    final refreshed = await _loadStatus();
    if (!mounted) return;
    setState(() {
      _statusFuture = Future.value(refreshed);
    });
  }

  Future<void> _clearDatabase() async {
    if (_isClearing) return;
    setState(() {
      _isClearing = true;
    });

    String message;

    try {
      final prefs = GetIt.I<SharedPreferences>();
      final cleared = await prefs.clear();
      await _refresh();
      message = cleared ? 'Banco de dados local limpo com sucesso.' : 'Não foi possível limpar o banco de dados local.';
    } catch (error) {
      message = 'Erro ao limpar o banco local: $error';
    }

    if (!mounted) return;

    setState(() {
      _isClearing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Status do Banco Local'),
      ),
      body: FutureBuilder<List<_LocalDatabaseEntry>>(
        future: _statusFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48),
                    const SizedBox(height: 16),
                    Text(
                      'Não foi possível carregar o status do banco local.',
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      snapshot.error.toString(),
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => setState(() {
                        _statusFuture = _loadStatus();
                      }),
                      child: const Text('Tentar novamente'),
                    ),
                  ],
                ),
              ),
            );
          }

          final entries = snapshot.data ?? const [];

          final typeCounts = <String, int>{};
          for (final entry in entries) {
            typeCounts.update(entry.typeLabel, (value) => value + 1, ifAbsent: () => 1);
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              padding: const EdgeInsets.all(16),
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Resumo',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _InfoChip(
                              icon: Icons.storage_outlined,
                              label: 'Total de chaves',
                              value: entries.length.toString(),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: typeCounts.entries
                                    .map(
                                      (entry) => _InfoChip(
                                        icon: _iconForTypeLabel(entry.key),
                                        label: entry.key,
                                        value: entry.value.toString(),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (entries.isEmpty)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inbox_outlined,
                            size: 48,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Nenhum dado armazenado no momento.',
                            style: Theme.of(context).textTheme.bodyLarge,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'A área será atualizada automaticamente sempre que novos dados forem salvos.',
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ...entries.map(
                    (entry) => Card(
                      child: ListTile(
                        leading: Icon(_iconForTypeLabel(entry.typeLabel)),
                        title: Text(entry.key),
                        subtitle: Text(entry.displayValue),
                        trailing: Text(
                          entry.typeLabel,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: _isClearing ? null : _clearDatabase,
                  icon: _isClearing
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.delete_forever_outlined),
                  label: Text(_isClearing ? 'Limpando...' : 'Limpar banco local'),
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _LocalDatabaseEntry {
  _LocalDatabaseEntry({
    required this.key,
    required this.value,
  });

  final String key;
  final Object? value;

  String get displayValue {
    if (value == null) {
      return 'null';
    }
    if (value is List<String>) {
      return (value as List<String>).join(', ');
    }
    return value.toString();
  }

  String get typeLabel {
    final currentValue = value;
    if (currentValue == null) {
      return 'Vazio';
    }
    if (currentValue is bool) return 'Booleano';
    if (currentValue is int) return 'Inteiro';
    if (currentValue is double) return 'Decimal';
    if (currentValue is List) return 'Lista';
    return 'Texto';
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}

IconData _iconForTypeLabel(String typeLabel) {
  switch (typeLabel) {
    case 'Booleano':
      return Icons.toggle_on;
    case 'Inteiro':
      return Icons.confirmation_number_outlined;
    case 'Decimal':
      return Icons.numbers;
    case 'Lista':
      return Icons.list_alt_outlined;
    case 'Vazio':
      return Icons.not_interested_outlined;
    default:
      return Icons.text_snippet_outlined;
  }
}

