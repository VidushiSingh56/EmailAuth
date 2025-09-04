import 'package:flutter/material.dart';

class Strokes extends StatelessWidget {
  const Strokes({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top:15, bottom: 15),
      child: Align(
        alignment: Alignment.center,
        child: Container(
          width: MediaQuery.of(context).size.width * .8,
          decoration: const ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1,  // Stroke width
                strokeAlign: BorderSide.strokeAlignCenter,  // Stroke alignment inside the border
                color: Color(0xFFBFBFBF),  // Grey color for the stroke
              ),
            ),
          ),
        ),
      ),
    );
  }
}
