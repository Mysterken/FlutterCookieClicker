import 'package:audioplayers/audioplayers.dart';

class SoundService {
  final AudioPlayer _audioPlayer;

  SoundService() : _audioPlayer = AudioPlayer();

  // Play a specific sound file
  Future<void> playSound(String soundPath) async {
    final audioPlayer = AudioPlayer();
    await audioPlayer.play(AssetSource(soundPath));
  }

  // Stop any currently playing sound
  Future<void> stopSound() async {
    await _audioPlayer.stop();
  }

  // Play achievement unlocked sound
  Future<void> playAchievementSound() async {
    await playSound('sounds/upgrade.mp3');
  }

  // Play cookie click sound
  Future<void> playClickSound() async {
    await playSound('sounds/boop.mp3');
  }

  // Dispose the audio player
  void dispose() {
    _audioPlayer.dispose();
  }
}
