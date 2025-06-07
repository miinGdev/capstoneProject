import 'package:flutter/material.dart';

class EmojiSelector extends StatelessWidget {
  final Function(String) onEmojiSelected;

   EmojiSelector({super.key, required this.onEmojiSelected});

  final List<String> emojis = [
    "😀", "😢", "😡", "😱", "😍", "🥳", "😴", "🤔", "😭", "😆"
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 200,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
        ),
        itemCount: emojis.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              onEmojiSelected(emojis[index]);
              Navigator.pop(context);
            },
            child: Center(
              child: Text(
                emojis[index],
                style: const TextStyle(fontSize: 32),
              ),
            ),
          );
        },
      ),
    );
  }
}
