import 'package:Harvesty/Pages/PlantInfoPage.dart';
import 'package:Harvesty/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlantCard extends StatelessWidget {
  final String name;
  final String category;
  final int difficulty;
  final List<String> sowMonths;
  final List<String> harvestMonths;
  final String notes;
  final int plantid;

  const PlantCard({
    super.key,
    required this.name,
    required this.category,
    required this.difficulty,
    required this.sowMonths,
    required this.harvestMonths,
    required this.notes,
    required this.plantid,
  });

  static const List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  String monthToLetter(String month) {
    return month.substring(0, 1);
  }

  Widget buildSeeds() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        difficulty,
        (index) => const Padding(
          padding: EdgeInsets.only(left: 2),
          child: Icon(Icons.spa, size: 16, color: Colors.green),
        ),
      ),
    );
  }

  Widget buildMonthIndicators(BuildContext context, List<String> activeMonths) {
    final activeSet = activeMonths.map((m) => m.trim().toLowerCase()).toSet();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: months.map((month) {
        final isActive = activeSet.contains(month.toLowerCase());
        final themeProvider = Provider.of<ThemeProvider>(context);
        return Container(
          width: 22,
          height: 22,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isActive
                ? themeProvider.themeMode == ThemeMode.dark
                      ? Colors.green
                      : Colors.green
                : themeProvider.themeMode == ThemeMode.dark
                ? Colors.grey.shade700
                : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            monthToLetter(month),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: isActive
                  ? Colors.white
                  : themeProvider.themeMode == ThemeMode.dark
                  ? Colors.grey.shade300
                  : Colors.grey.shade600,
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () {
        showModalBottomSheet(
          context: context,
          useSafeArea: true,
          isScrollControlled: true,
          builder: ((context) {
            return Plantinfopage(title: name, plantid: plantid);
          }),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  buildSeeds(),
                ],
              ),

              const SizedBox(height: 4),

              Text(
                category,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),

              const SizedBox(height: 14),

              const Text("Sow", style: TextStyle(fontWeight: FontWeight.w600)),

              const SizedBox(height: 6),

              buildMonthIndicators(context, sowMonths),

              const SizedBox(height: 12),

              const Text(
                "Harvest",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 6),

              buildMonthIndicators(context, harvestMonths),

              const SizedBox(height: 12),

              const Text(
                "Notes",
                style: TextStyle(fontWeight: FontWeight.w800),
              ),

              Text(notes, style: TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }
}
