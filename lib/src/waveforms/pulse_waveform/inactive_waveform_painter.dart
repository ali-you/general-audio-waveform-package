// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:general_audio_waveforms/src/core/waveform_painters_ab.dart';
import 'package:general_audio_waveforms/src/util/waveform_alignment.dart';

///InActiveWaveformPainter for the [PulseWaveform].
class PulseInActiveWaveformPainter extends InActiveWaveformPainter {
  PulseInActiveWaveformPainter({
    super.color = Colors.white,
    super.gradient,
    required super.samples,
    required super.waveformAlignment,
    required super.sampleWidth,
    required super.borderColor,
    required super.borderWidth,
    required this.isRoundedRectangle,
    super.style = PaintingStyle.fill,
  });

  final bool isRoundedRectangle;
  late double heightt ;
  @override
  void paint(Canvas canvas, Size size) {
    heightt = size.height/2;
    final paint = Paint()
      ..style = style
      ..color = color
      ..shader = gradient?.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );
    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = borderColor
      ..strokeWidth = borderWidth;
    //Gets the [alignPosition] depending on [waveformAlignment]
    final alignPosition = waveformAlignment.getAlignPosition(size.height);

    if (isRoundedRectangle) {
      drawRoundedRectangles(
        canvas,
        alignPosition,
        paint,
        borderPaint,
        waveformAlignment,
      );
    } else {
      drawRegularRectangles(
        canvas,
        alignPosition,
        paint,
        borderPaint,
        waveformAlignment,
      );
    }
  }

  // ignore: long-parameter-list
  void drawRegularRectangles(
    Canvas canvas,
    double alignPosition,
    Paint paint,
    Paint borderPaint,
    WaveformAlignment waveformAlignment,
  ) {
    for (var i = 0; i < samples.length; i++) {
      final x = sampleWidth * i;
      final y = samples[i];
      final positionFromTop =alignPosition;
      final rectangle = Rect.fromLTWH(x, positionFromTop , sampleWidth, y + heightt);

      //Draws the filled rectangles of the waveform.
      canvas
        ..drawRect(
          rectangle,
          paint,
        )
        //Draws the border for the rectangles of the waveform.
        ..drawRect(
          rectangle,
          borderPaint,
        );
    }
  }

  // ignore: long-parameter-list
  void drawRoundedRectangles(
    Canvas canvas,
    double alignPosition,
    Paint paint,
    Paint borderPaint,
    WaveformAlignment waveformAlignment,
  ) {
    final radius = Radius.circular(sampleWidth);
    for (var i = 0; i < samples.length; i++) {
      if (i.isEven) {
        final x = sampleWidth * i;
        final y =  samples[i] ;
        final positionFromTop =  alignPosition - y / 2;
        final rectangle = Rect.fromLTWH(x, positionFromTop, sampleWidth, y);
        //Draws the filled rectangles of the waveform.
        canvas
          ..drawRRect(
            RRect.fromRectAndRadius(
              rectangle,
              radius,
            ),
            paint,
          )
          //Draws the border for the rectangles of the waveform.
          ..drawRRect(
            RRect.fromRectAndRadius(
              rectangle,
              radius,
            ),
            borderPaint,
          );
      }
    }
  }

  @override
  bool shouldRepaint(covariant PulseInActiveWaveformPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return getShouldRepaintValue(oldDelegate) ||
        isRoundedRectangle != oldDelegate.isRoundedRectangle ;
  }
}