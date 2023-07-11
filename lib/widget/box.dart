// ignore_for_file: constant_pattern_never_matches_value_type

import 'package:flutter/material.dart';

import '../utils/box_constants.dart';

class Box extends StatelessWidget {
  final BoxSize size;
  final BoxType type;
  const Box({super.key, required this.size, required this.type});

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case BoxType.VERTICAL:
        switch (size) {
          case BoxSize.EXTRASMALL:
            return const SizedBox(height: 10);
          case BoxSize.SMALL:
            return const SizedBox(height: 20);
          case BoxSize.MEDIUM:
            return const SizedBox(height: 50);
          default: // BIG
            return const SizedBox(height: 80);
        }
      default: // HOR;IZONTAL
        switch (size) {
          case BoxSize.SMALL:
            return const SizedBox(width: 20);
          case BoxSize.MEDIUM:
            return const SizedBox(width: 50);
          default: // BIG
            return const SizedBox(width: 80);
        }
    }
  }
}
