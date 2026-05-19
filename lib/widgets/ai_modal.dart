import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class AIModal extends StatelessWidget {
  const AIModal({super.key});
  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final ctrl = TextEditingController();
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('🤖 LocalGuide AI', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
          ]),
          const Divider(),
          SizedBox(
            height: 200,
            child: ListView.builder(
              reverse: true,
              itemCount: s.chat.length,
              itemBuilder: (_, i) {
                final isUser = i == 0;
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: isUser ? Colors.blue : Colors.grey[200], borderRadius: BorderRadius.circular(10)),
                    child: Text(s.chat.reversed.toList()[i], style: TextStyle(color: isUser ? Colors.white : Colors.black)),
                  ),
                );
              },
            ),
          ),
          Row(children: [
            Expanded(child: TextField(controller: ctrl, decoration: const InputDecoration(hintText: 'Ask about food, views, or hotels...', border: OutlineInputBorder()))),
            IconButton(icon: const Icon(Icons.send), onPressed: () { s.sendMsg(ctrl.text); ctrl.clear(); }),
          ]),
        ]),
      ),
    );
  }
}