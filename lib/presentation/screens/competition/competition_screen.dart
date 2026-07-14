import 'package:flutter/material.dart';
import 'matches_screen.dart';
import 'evaluations_screen.dart';
import '../../../theme/app_colors.dart';

class CompetitionScreen extends StatelessWidget {
  const CompetitionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0, // Ocultamos el título del AppBar para usar solo los Tabs
          bottom: const TabBar(
            indicatorColor: AppColors.gold,
            labelColor: AppColors.gold,
            unselectedLabelColor: Colors.white54,
            tabs: [
              Tab(icon: Icon(Icons.sports_soccer), text: 'Partidos'),
              Tab(icon: Icon(Icons.analytics_outlined), text: 'Evaluaciones'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            MatchesScreen(),
            EvaluationsScreen(),
          ],
        ),
      ),
    );
  }
}
