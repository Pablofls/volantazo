import 'package:flutter/material.dart';
import 'services/storage_service.dart';
import 'screens/home.dart';
import 'screens/players.dart';
import 'screens/sessions.dart';
import 'screens/new_session.dart';
import 'screens/session_detail.dart';
import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = StorageService();
  await storage.init();
  runApp(VolantazoApp(storage: storage));
}

class VolantazoApp extends StatelessWidget {
  final StorageService storage;

  const VolantazoApp({super.key, required this.storage});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Volantazo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: MainShell(storage: storage),
      onGenerateRoute: (settings) {
        if (settings.name == '/session') {
          final id = settings.arguments as String;
          return MaterialPageRoute(
            builder: (_) => SessionDetailScreen(storage: storage, sessionId: id),
          );
        }
        if (settings.name == '/new-session') {
          return MaterialPageRoute(
            builder: (_) => NewSessionScreen(storage: storage),
          );
        }
        return null;
      },
    );
  }
}

class MainShell extends StatefulWidget {
  final StorageService storage;

  const MainShell({super.key, required this.storage});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(storage: widget.storage),
      SessionsScreen(storage: widget.storage),
      PlayersScreen(storage: widget.storage),
    ];

    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: const TextSpan(
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: 2),
            children: [
              TextSpan(text: 'VOLANT', style: TextStyle(color: Colors.white)),
              TextSpan(text: 'AZO', style: TextStyle(color: AppTheme.primary)),
            ],
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3),
          child: Container(height: 3, color: AppTheme.primary),
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.emoji_events), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.flag), label: 'Carreras'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Pilotos'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/new-session').then((_) => setState(() {})),
        backgroundColor: AppTheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
