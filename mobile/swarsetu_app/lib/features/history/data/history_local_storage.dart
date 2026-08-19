import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/entities/history_entry.dart';

class HistoryLocalStorage {
  static const _key = 'translation_history';
  static const _maxEntries = 100;

  Future<List<HistoryEntry>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    return raw
        .map(
          (e) => HistoryEntry.fromJson(jsonDecode(e) as Map<String, dynamic>),
        )
        .toList()
        .reversed
        .toList();
  }

  Future<void> add(HistoryEntry entry) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    raw.add(jsonEncode(entry.toJson()));
    final trimmed = raw.length > _maxEntries
        ? raw.sublist(raw.length - _maxEntries)
        : raw;
    await prefs.setStringList(_key, trimmed);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
