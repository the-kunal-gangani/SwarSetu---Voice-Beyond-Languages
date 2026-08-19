import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/entities/contribution.dart';

class ContributionLocalStorage {
  static const _key = 'user_contributions';

  Future<List<Contribution>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    return raw
        .map(
          (e) => Contribution.fromJson(jsonDecode(e) as Map<String, dynamic>),
        )
        .toList()
        .reversed
        .toList();
  }

  Future<void> add(Contribution contribution) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    raw.add(jsonEncode(contribution.toJson()));
    await prefs.setStringList(_key, raw);
  }
}
