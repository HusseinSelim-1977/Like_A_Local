import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../widgets/ai_modal.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('LikeALocal'),
        actions: [
          TextButton(onPressed: () {}, child: const Text('Menu')),
          TextButton(onPressed: s.logout, child: const Text('Sign In')),
          IconButton(icon: const Icon(Icons.close), onPressed: s.logout),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text.rich(TextSpan(children: [
              TextSpan(text: 'Discover', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              TextSpan(text: '✨The World', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            ])),
            const SizedBox(height: 8),
            const Text('Curated 4K destinations, local insights, and AI-powered recommendations.', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _btn(Icons.mic, () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('🎙️ Voice')))),
                _btn(Icons.arrow_back, () => Navigator.maybePop(context)),
                ElevatedButton.icon(
                  onPressed: () => showDialog(context: context, builder: (_) => const AIModal()),
                  icon: const Icon(Icons.smart_toy), label: const Text('LocalGuide AI'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: s.tabIndex,
        onTap: s.setTab,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
      ),
    );
  }
  Widget _btn(IconData i, VoidCallback f) => IconButton(onPressed: f, icon: Icon(i), style: IconButton.styleFrom(backgroundColor: Colors.grey[200]));
}