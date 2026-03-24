import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kawaii_ui/kawaii_ui.dart';

import 'models/store.dart';
import 'screens/home_screen.dart';
import 'screens/tasks_screen.dart';
import 'screens/mood_screen.dart';
import 'screens/goals_screen.dart';

class KawaiiLifeApp extends StatelessWidget {
  const KawaiiLifeApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark));
    return MaterialApp(
      title: 'Kawaii Life',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: KawaiiColors.pinkBottom),
        textTheme: GoogleFonts.nunitoTextTheme(),
        useMaterial3: true,
      ),
      home: const KawaiiLifeHome(),
    );
  }
}

class KawaiiLifeHome extends StatefulWidget {
  const KawaiiLifeHome({super.key});
  @override
  State<KawaiiLifeHome> createState() => _KawaiiLifeHomeState();
}

class _KawaiiLifeHomeState extends State<KawaiiLifeHome> {
  final AppStore _store = AppStore();
  final _scaffoldKey = GlobalKey<KawaiiScaffoldState>();

  void _goToTab(int index) => _scaffoldKey.currentState?.setPage(index);

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _store,
      builder: (context, _) {
        final incompleteTasks = _store.tasks.where((t) => !t.done).length;
        return KawaiiScaffold(
          key: _scaffoldKey,
          pages: [
            HomeScreen(store: _store, onNavigateToTab: _goToTab),
            TasksScreen(store: _store),
            MoodScreen(store: _store),
            GoalsScreen(store: _store),
          ],
          navItems: [
            KawaiiNavItem(icon: kawaiiIcon(const HeartPainter(), size: 22), label: 'Home'),
            KawaiiNavItem(
              icon: kawaiiIcon(const CheckPainter(color: KawaiiColors.pinkBottom), size: 22),
              label: 'Tasks',
              badge: incompleteTasks > 0 ? incompleteTasks : null),
            KawaiiNavItem(icon: kawaiiIcon(const MoonPainter(), size: 22), label: 'Mood'),
            KawaiiNavItem(icon: kawaiiIcon(const Star4Painter(), size: 22), label: 'Goals'),
          ],
        );
      },
    );
  }
}
