import 'package:audioplayers/audioplayers.dart';

class SoundHelper {
  static final AudioPlayer _player = AudioPlayer();

  static Future<void> playPetSound(String type) async {
    try {
      await _player.stop();

      if (type.toLowerCase() == 'dog') {
        await _player.play(AssetSource('sounds/dog_pop.mp3'));
      } else if (type.toLowerCase() == 'cat') {
        await _player.play(AssetSource('sounds/meow.wav'));
      }
    } catch (e) {
    }
  }
}