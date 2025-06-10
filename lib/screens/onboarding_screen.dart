import 'package:flutter/material.dart';
import 'chat_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with TickerProviderStateMixin {
  final List<String> messages = [];
  final List<String> guideTexts = [
    "On the Record는\n대화형 AI 기록 서비스입니다.",
    "챗봇과 대화를 주고 받으며,\n대화 내용을 요약하고 기록합니다.",
    "나만의 챗봇을 만들어보세요!"
  ];
  int currentIndex = 1; // 첫 번째 메시지를 보여준 상태로 시작
  Set<String> selectedPurpose = {};

  @override
  void initState() {
    super.initState();
    messages.add(guideTexts[0]); // 앱 시작 시 첫 메시지 추가
  }

  void _next() {
    setState(() {
      if (currentIndex < guideTexts.length) {
        messages.add(guideTexts[currentIndex]);
        currentIndex++;
      } else if (currentIndex == guideTexts.length) {
        currentIndex++;
      } else {
        if (selectedPurpose.isNotEmpty) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ChatScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("하나를 선택해주세요.")),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isSelectionStep = currentIndex > guideTexts.length;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...messages.map((text) => AnimatedTextEntry(text: text)).toList(),
              if (isSelectionStep) const SizedBox(height: 32),
              if (isSelectionStep)
                GuideSelection(
                  selectedOptions: selectedPurpose,
                  onSelect: (val) {
                    setState(() => selectedPurpose = val);
                  },
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 48,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _next,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              currentIndex <= guideTexts.length - 1 ? "다음" : "시작하기",
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedTextEntry extends StatefulWidget {
  final String text;
  const AnimatedTextEntry({super.key, required this.text});

  @override
  State<AnimatedTextEntry> createState() => _AnimatedTextEntryState();
}

class _AnimatedTextEntryState extends State<AnimatedTextEntry> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  );

  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: const Offset(0, 0.3),
    end: Offset.zero,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

  @override
  void initState() {
    super.initState();
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(
          widget.text,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class GuideSelection extends StatelessWidget {
  static const List<String> options = ["기록", "일정 관리", "대화"];
  final Set<String> selectedOptions;
  final Function(Set<String>) onSelect;

  const GuideSelection({super.key, required this.selectedOptions, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "On the Record의\n사용 목적을 알려주세요!",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        ...options.map((opt) {
          final isSelected = selectedOptions.contains(opt);
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ElevatedButton(
              onPressed: () {
                final newSelection = Set<String>.from(selectedOptions);
                if (isSelected) {
                  newSelection.remove(opt);
                } else {
                  newSelection.add(opt);
                }
                onSelect(newSelection);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isSelected ? Colors.white : Colors.black87,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: BorderSide(
                  color: Colors.black,
                  width: 2,
                ),
                minimumSize: const Size(double.infinity, 48),
              ),
              child: Text(
                opt,
                style: TextStyle(
                  color: isSelected ? Colors.black : Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}