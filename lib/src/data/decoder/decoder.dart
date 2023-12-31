import 'dart:io';

import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_session.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:wav/wav.dart';

///
///
/// [Decoder]
///
/// {@tool snippet}
/// Example :
/// ```dart
///   //TODO
///```
/// {@end-tool}
class Decoder {
  /// Local Path
  final String path;

  Decoder({required this.path});

  Future<List<double>> extract() async {
    String wavPath = path.replaceRange(path.length - 3, path.length, "wav");
    bool fileExist = await File(wavPath).exists();
    bool canGetWave = fileExist;

    if (!fileExist) {
      FFmpegSession session = await FFmpegKit.executeAsync(
          '-i $path -vn -acodec pcm_s16le -ar 44100 -ac 2 $wavPath');
      canGetWave = ReturnCode.isSuccess(await session.getReturnCode());
      if (!canGetWave) {
        throw "Error: ${await session.getLogsAsString()}";
      }
    }

    ///creating the wave
    if (canGetWave) {
      Wav wav = await Wav.readFile(wavPath);
      return (wav.channels.toList())
          .expand((element) => element)
          .map((e) => e.toDouble())
          .toList();
    }
    return [];
  }
}
