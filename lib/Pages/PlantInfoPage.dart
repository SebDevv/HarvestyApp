import 'package:Harvesty/Database/plant_database.dart';
import 'package:flutter/material.dart';

class Plantinfopage extends StatefulWidget {
  const Plantinfopage({super.key, required this.title, required this.plantid});

  final String title;
  final int plantid;

  @override
  State<Plantinfopage> createState() => _PlantinfopageState();
}

class _PlantinfopageState extends State<Plantinfopage> {
  Map<String, dynamic>? plant;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadPlant();
  }

  Future<void> loadPlant() async {
    final data = await DatabaseHelper.instance.getPlantById(widget.plantid);

    if (!mounted) return;

    setState(() {
      plant = data;
      isLoading = false;
    });
  }

  String _difficultyText(dynamic difficulty) {
    if (difficulty == null) return 'Unknown';

    final value = difficulty is int
        ? difficulty
        : int.tryParse(difficulty.toString()) ?? 0;

    switch (value) {
      case 1:
        return 'Easy';
      case 2:
        return 'Medium';
      case 3:
        return 'Hard';
      default:
        return value.toString();
    }
  }

  Widget _infoCard({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Icon(icon, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value.isEmpty ? 'Not set' : value,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _monthChip(String text) {
    return Chip(label: Text(text), visualDensity: VisualDensity.compact);
  }

  List<String> _parseMonths(dynamic value) {
    if (value == null) return [];

    if (value is List<String>) return value;

    if (value is String) {
      return value
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
    }

    return [];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.82,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : plant == null
            ? const Center(child: Text('Plant not found'))
            : SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 42,
                        height: 5,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.outlineVariant,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Text(
                      plant!['name'] ?? widget.title,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        plant!['category'] ?? 'Unknown category',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 2.2,
                      children: [
                        _infoCard(
                          context: context,
                          icon: Icons.wb_sunny_outlined,
                          label: 'Sun',
                          value: (plant!['sun'] ?? '').toString(),
                        ),
                        _infoCard(
                          context: context,
                          icon: Icons.straighten,
                          label: 'Spacing',
                          value:
                              (plant!['spacing_cm'] ?? '').toString() + " cm",
                        ),
                        _infoCard(
                          context: context,
                          icon: Icons.eco_outlined,
                          label: 'Difficulty',
                          value: _difficultyText(plant!['difficulty']),
                        ),
                      ],
                    ),

                    _sectionTitle(context, 'Sowing'),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _parseMonths(
                        plant!['sowIndoors'],
                      ).map(_monthChip).toList(),
                    ),

                    const SizedBox(height: 20),

                    _sectionTitle(context, 'Harvesting'),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _parseMonths(
                        plant!['harvest'],
                      ).map(_monthChip).toList(),
                    ),

                    const SizedBox(height: 20),

                    _sectionTitle(context, 'Notes'),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest
                            .withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Text(
                        (plant!['notes'] ?? 'No notes added').toString(),
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
