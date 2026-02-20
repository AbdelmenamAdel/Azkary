import 'package:audioplayers/audioplayers.dart';

class SoundService {
  final AudioPlayer _player;

  SoundService(this._player);

  Future<void> playClick() async {
    await _player.stop();
    await _player.play(AssetSource('sounds/click_sepha.mp3'));
  }

  Future<void> playFull() async {
    await _player.stop();
    await _player.play(AssetSource('sounds/full_sound.mp3'));
  }

  void dispose() {
    _player.dispose();
  }
}
