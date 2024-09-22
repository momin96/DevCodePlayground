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

class FlashCardScreenState extends State<FlashCardScreen> {
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
            return IndividualFlashCard(card: card);
          } else {
            return NormalCardWidget(content: card.content);
          }
        },
      ),
    );
  }
}

class IndividualFlashCard extends StatefulWidget {
  final CardItem card;

  const IndividualFlashCard({Key? key, required this.card}) : super(key: key);

  @override
  _IndividualFlashCardState createState() => _IndividualFlashCardState();
}

class _IndividualFlashCardState extends State<IndividualFlashCard>
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

  void _flipCard() {
    if (_controller.isAnimating) return;
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
    return FlashCardWidget(
      content: widget.card.content,
      controller: _controller,
      onTap: _flipCard,
    );
  }
}

class FlashCardWidget extends StatelessWidget {
  final String content;
  final AnimationController controller;
  final VoidCallback onTap;

  const FlashCardWidget({
    Key? key,
    required this.content,
    required this.controller,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          final angle = controller.value * 3.1416;
          final transform = Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(angle);
          return Transform(
            transform: transform,
            alignment: Alignment.center,
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Container(
                height: 150,
                width: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: angle.abs() < 1.57
                        ? [Colors.blue[300]!, Colors.blue[700]!]
                        : [Colors.orange[300]!, Colors.orange[700]!],
                  ),
                ),
                child: Center(
                  child: Text(
                    angle.abs() < 1.57
                        ? 'Front: Drag to flip'
                        : 'Back: $content',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
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
