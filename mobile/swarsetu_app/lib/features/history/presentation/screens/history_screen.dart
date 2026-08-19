import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/history_local_storage.dart';
import '../../domain/entities/history_entry.dart';
import '../widgets/history_card.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final _storage = HistoryLocalStorage();
  List<HistoryEntry> _entries = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final entries = await _storage.getAll();
    if (mounted) {
      setState(() {
        _entries = entries;
        _loading = false;
      });
    }
  }

  Future<void> _clearAll() async {
    await _storage.clear();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deepNavy,
      appBar: AppBar(
        title: Text(AppStrings.recentTranslations, style: AppTextStyles.h3),
        actions: [
          if (_entries.isNotEmpty)
            IconButton(
              icon: const Icon(
                Icons.delete_outline_rounded,
                color: AppColors.error,
              ),
              onPressed: _clearAll,
            ),
        ],
      ),
      body: SafeArea(
        child: _loading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.cyan),
              )
            : _entries.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 80.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.history_rounded,
                        size: AppDimensions.iconXL * 1.5,
                        color: AppColors.cyan.withValues(alpha: 0.3),
                      ),
                      const SizedBox(height: AppDimensions.paddingMD),
                      Text(
                        'No translations yet',
                        style: AppTextStyles.bodyMedium,
                      ),
                    ],
                  ),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(AppDimensions.paddingMD),
                itemCount: _entries.length,
                itemBuilder: (context, index) {
                  return HistoryCard(entry: _entries[index]);
                },
              ),
      ),
    );
  }
}
