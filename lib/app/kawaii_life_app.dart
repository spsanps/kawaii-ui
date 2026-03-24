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
  int _tabIndex = 0;
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    // Build screens ONCE — IndexedStack keeps them alive across tab switches
    _screens = [
      HomeScreen(store: _store, onNavigateToTab: _goToTab),
      TasksScreen(store: _store),
      MoodScreen(store: _store),
      GoalsScreen(store: _store),
    ];
  }

  void _goToTab(int index) => setState(() => _tabIndex = index);

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _store,
      builder: (context, _) {
        final incompleteTasks = _store.tasks.where((t) => !t.done).length;
        return Scaffold(
          extendBodyBehindAppBar: true,
          body: Container(
            decoration: const BoxDecoration(gradient: LinearGradient(
              begin: Alignment.topCenter, end: Alignment.bottomCenter,
              colors: [KawaiiColors.bgTop, KawaiiColors.bgMid, KawaiiColors.bgBottom])),
            child: KawaiiSparkleField(
              count: 10,
              child: SafeArea(
                bottom: false,
                child: IndexedStack(
                  index: _tabIndex,
                  children: _screens,
                ),
              ),
            ),
          ),
          bottomNavigationBar: KawaiiBottomNavBar(
            currentIndex: _tabIndex,
            onTap: _goToTab,
            items: [
              KawaiiNavItem(icon: kawaiiIcon(HeartPainter(), size: 22), label: 'Home'),
              KawaiiNavItem(icon: kawaiiIcon(CheckPainter(color: KawaiiColors.pinkBottom), size: 22),
                label: 'Tasks', badge: incompleteTasks > 0 ? incompleteTasks : null),
              KawaiiNavItem(icon: kawaiiIcon(MoonPainter(), size: 22), label: 'Mood'),
              KawaiiNavItem(icon: kawaiiIcon(Star4Painter(), size: 22), label: 'Goals'),
            ],
          ),
        );
      },
    );
  }
}
