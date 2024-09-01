import 'package:flutter/material.dart';

class FlashCardApp extends StatelessWidget {
  const FlashCardApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: FlashCardScreen(),
    );
  }
}

class FlashCardScreen extends StatefulWidget {
  const FlashCardScreen({Key? key}) : super(key: key);

  @override
  FlashCardScreenState createState() => FlashCardScreenState();
}

class FlashCardScreenState extends State<FlashCardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool isFront = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void flipCard() {
    if (isFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    setState(() {
      isFront = !isFront;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<CardItem> cards = [
      CardItem(type: CardType.normal, content: 'Normal Card 1'),
      CardItem(type: CardType.flash, content: 'Flash Card 1'),
      CardItem(type: CardType.normal, content: 'Normal Card 2'),
      CardItem(type: CardType.flash, content: 'Flash Card 2'),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Flash Cards')),
      body: ListView.builder(
        itemCount: cards.length,
        itemBuilder: (context, index) {
          final card = cards[index];
          if (card.type == CardType.flash) {
            return FlashCardWidget(
              content: card.content,
              controller: _controller,
              isFront: isFront,
              onFlip: flipCard,
            );
          } else {
            return NormalCardWidget(content: card.content);
          }
        },
      ),
    );
  }
}

class FlashCardWidget extends StatelessWidget {
  final String content;
  final AnimationController controller;
  final bool isFront;
  final VoidCallback onFlip;

  const FlashCardWidget({
    required this.content,
    required this.controller,
    required this.isFront,
    required this.onFlip,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onFlip,
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          final angle = controller.value * 3.1416;
          return Transform(
            transform: Matrix4.rotationY(angle),
            alignment: Alignment.center,
            child: isFront
                ? const Card(
                    color: Colors.blueAccent,
                    child: SizedBox(
                      height: 150,
                      child: Center(child: Text('Tap to Flip')),
                    ),
                  )
                : Card(
                    color: Colors.orangeAccent,
                    child: SizedBox(
                      height: 150,
                      child: Center(child: Text(content)),
                    ),
                  ),
          );
        },
      ),
    );
  }
}

class NormalCardWidget extends StatelessWidget {
  final String content;

  const NormalCardWidget({required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 150,
        child: Center(child: Text(content)),
      ),
    );
  }
}

enum CardType { normal, flash }

class CardItem {
  final CardType type;
  final String content;

  CardItem({required this.type, required this.content});
}
