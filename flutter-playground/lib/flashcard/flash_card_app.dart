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
  double _dragPosition = 0.0;

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

  void onDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragPosition += details.delta.dx;
      _controller.value = (_dragPosition / 150).clamp(-1.0, 1.0).abs();
    });
  }

  void onDragEnd(DragEndDetails details) {
    if (_controller.value > 0.5) {
      _controller.animateTo(1.0, duration: Duration(milliseconds: 200));
      setState(() {
        isFront = !isFront;
      });
    } else {
      _controller.animateTo(0.0, duration: Duration(milliseconds: 200));
    }
    setState(() {
      _dragPosition = 0.0;
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
              onDragUpdate: onDragUpdate,
              onDragEnd: onDragEnd,
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
  final Function(DragUpdateDetails) onDragUpdate;
  final Function(DragEndDetails) onDragEnd;

  const FlashCardWidget({
    required this.content,
    required this.controller,
    required this.isFront,
    required this.onDragUpdate,
    required this.onDragEnd,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: onDragUpdate,
      onHorizontalDragEnd: onDragEnd,
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          final angle = controller.value * 3.1416;
          return Transform(
            transform: Matrix4.rotationY(angle),
            alignment: Alignment.center,
            child: Card(
              color:
                  angle.abs() < 1.57 ? Colors.blueAccent : Colors.orangeAccent,
              child: SizedBox(
                height: 150,
                child: Center(
                  child: Text(
                    angle.abs() < 1.57
                        ? 'Front: Drag to flip'
                        : 'Back: $content',
                    style: TextStyle(color: Colors.white),
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
