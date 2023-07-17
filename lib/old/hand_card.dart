import 'package:flutter/material.dart';

import 'models.dart';

class HandCard extends StatefulWidget {
  final Hand hand;

  HandCard(this.hand);

  @override _HandCardState createState() => _HandCardState(hand);
}

class _HandCardState extends State<HandCard> {
  Hand hand;

  _HandCardState(this.hand);

  @override
  Widget build(BuildContext context) {

  }
}