import 'package:chatbot/helper/global.dart';
import 'package:flutter/material.dart';

class WrapperElement extends StatelessWidget {
  final Function(String) onPromptSelected;
  const WrapperElement({
    super.key, required this.onPromptSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: mq.width * 0.05,
        vertical: mq.height * 0.03,
      ),
      child: Wrap(
        spacing: mq.width * 0.03,
        runSpacing: mq.height * 0.01,
        children: [
          ElevatedButton(
            onPressed: () => onPromptSelected("Abstarct below Text"),
            child: const Text("Abstarct below Text"),
          ),
          ElevatedButton(
            onPressed: ()=>onPromptSelected("Good Night Stories"),
            child: const Text("Good Night Stories"),
          ),
          ElevatedButton(
            onPressed:  ()=>onPromptSelected("Tell me Joke"),
            child: const Text("Tell me Joke"),
          ),
          ElevatedButton(
            onPressed: ()=>onPromptSelected("code"),
            child: const Text("code"),
          ),
          ElevatedButton(
            onPressed: ()=>onPromptSelected("Tell me About"),
            child: const Text("Tell me About"),
          ),
          ElevatedButton(
            onPressed: ()=>onPromptSelected("History of"),
            child: const Text("History of"),
          ),
        ],
      ),
    );
  }
}
