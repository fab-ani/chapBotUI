import "package:flutter/material.dart";
import "package:my_tips/Bot/display_products.dart";

class ExpandableCard extends StatefulWidget {
  final String imageUrl;
  final String name;
  final double price;
  final String details;

  const ExpandableCard(
      {Key? key,
      required this.imageUrl,
      required this.name,
      required this.price,
      required this.details})
      : super(key: key);

  @override
  State<ExpandableCard> createState() => _ExpandableCardState();
}

class _ExpandableCardState extends State<ExpandableCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _expanded = false;

  @override
  void initstate() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _expanded = !_expanded;
      if (_expanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleExpanded,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: const Color(0xfffefefe),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const UserDisplayWidget(),
      ),
    );
  }
}
