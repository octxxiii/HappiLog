import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:happilog/models/daily_record.dart';
import 'package:happilog/screens/avatar_screen.dart';
import 'package:happilog/screens/calendar_screen.dart';
import 'package:happilog/screens/entry_detail_screen.dart';
import 'package:happilog/screens/home_screen.dart';
import 'package:happilog/screens/rank_screen.dart';
import 'package:happilog/screens/record_screen.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return Scaffold(
          body: child,
          bottomNavigationBar: NavigationBar(
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: '홈',
              ),
              NavigationDestination(
                icon: Icon(Icons.calendar_month_outlined),
                selectedIcon: Icon(Icons.calendar_month),
                label: '캘린더',
              ),
              NavigationDestination(
                icon: Icon(Icons.edit_outlined),
                selectedIcon: Icon(Icons.edit),
                label: '기록',
              ),
              NavigationDestination(
                icon: Icon(Icons.face_outlined),
                selectedIcon: Icon(Icons.face),
                label: '아바타',
              ),
              NavigationDestination(
                icon: Icon(Icons.leaderboard_outlined),
                selectedIcon: Icon(Icons.leaderboard),
                label: '랭킹',
              ),
            ],
            onDestinationSelected: (index) {
              switch (index) {
                case 0:
                  context.go('/');
                  break;
                case 1:
                  context.go('/calendar');
                  break;
                case 2:
                  context.go('/record');
                  break;
                case 3:
                  context.go('/avatar');
                  break;
                case 4:
                  context.go('/rank');
                  break;
              }
            },
            selectedIndex: _calculateSelectedIndex(state),
          ),
        );
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/calendar',
          builder: (context, state) => const CalendarScreen(),
        ),
        GoRoute(
          path: '/record',
          builder: (context, state) => const RecordScreen(),
        ),
        GoRoute(
          path: '/avatar',
          builder: (context, state) => const AvatarScreen(),
        ),
        GoRoute(
          path: '/rank',
          builder: (context, state) => const RankScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/entry/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return EntryDetailScreen(recordId: id);
      },
    ),
  ],
);

int _calculateSelectedIndex(GoRouterState state) {
  final String location = state.matchedLocation;
  if (location.startsWith('/')) {
    if (location == '/') return 0;
    if (location.startsWith('/calendar')) return 1;
    if (location.startsWith('/record')) return 2;
    if (location.startsWith('/avatar')) return 3;
    if (location.startsWith('/rank')) return 4;
  }
  return 0;
} 