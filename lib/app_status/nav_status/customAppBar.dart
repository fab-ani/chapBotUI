import 'package:flutter/material.dart';

class CustomScrollAppBar extends StatefulWidget {
  const CustomScrollAppBar({Key? key}) : super(key: key);

  @override
  State<CustomScrollAppBar> createState() => _CustomScrollAppBarState();
}

class _CustomScrollAppBarState extends State<CustomScrollAppBar> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          expandedHeight: 100.0,
          floating: false,
          flexibleSpace: FlexibleSpaceBar(
            title: const FittedBox(
              child: Center(
                child: Text(
                  'Recommendations',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            background: Container(
              decoration: const BoxDecoration(color: Color(0xff0541bd)),
            ),
          ),
        )
      ],
    );
  }
}
