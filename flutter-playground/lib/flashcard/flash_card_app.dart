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
  final double maxDragDistance = 200.0;

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
      bool isDraggingRightToLeft = details.delta.dx < 0;

      if (isFront) {
        if (isDraggingRightToLeft) {
          _dragPosition -= details.delta.dx;
        } else {
          _dragPosition += details.delta.dx;
        }
      } else {
        if (isDraggingRightToLeft) {
          _dragPosition += details.delta.dx;
        } else {
          _dragPosition -= details.delta.dx;
        }
      }

      _controller.value =
          (_dragPosition / maxDragDistance).clamp(0.0, 1.0).abs();

      print(
          "Dragging ${isDraggingRightToLeft ? 'RTL' : 'LTR'} dx ${details.delta.dx} value ${_controller.value} dragPosition ${_dragPosition}");
    });
  }

  void onDragEnd(DragEndDetails details) {
    if (_controller.value > 0.5) {
      _controller.forward(from: _controller.value);
      setState(() {
        isFront = false;
        _dragPosition = maxDragDistance * _controller.value;
      });
    } else {
      _controller.reverse(from: _controller.value);
      setState(() {
        isFront = true;
        _dragPosition = maxDragDistance * _controller.value;
      });
    }
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
              dragPosition: _dragPosition,
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
  final double dragPosition;

  const FlashCardWidget({
    required this.content,
    required this.controller,
    required this.isFront,
    required this.onDragUpdate,
    required this.onDragEnd,
    required this.dragPosition,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: onDragUpdate,
      onHorizontalDragEnd: onDragEnd,
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          final angle = (controller.value * 3.1416) * dragPosition.sign;
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
