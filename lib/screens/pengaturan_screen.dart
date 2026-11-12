
import 'package:flutter/material.dart';
import '../services/audio_manager.dart';

class PengaturanScreen extends StatefulWidget {
  const PengaturanScreen({super.key});

  @override
  State<PengaturanScreen> createState() => _PengaturanScreenState();
}

class _PengaturanScreenState extends State<PengaturanScreen> {
  @override
  void initState() {
    super.initState();

    // Pertahankan musik Main Menu saat membuka Pengaturan.
    AudioManager.instance.playBgm(BgmTrack.mainMenu);
  }

  @override
  Widget build(BuildContext context) {
    final audio = AudioManager.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pengaturan',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        backgroundColor: const Color(0xFF2CA45A),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            audio.playSfx(SfxTrack.pageTransitionWhoosh);
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFB9F2FF),
              Color(0xFFE4FBD8),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 12),
                const Icon(
                  Icons.settings_rounded,
                  size: 65,
                  color: Color(0xFF269B50),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Atur Suara Aplikasi',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF176D3B),
                  ),
                ),
                const SizedBox(height: 7),
                const Text(
                  'Sesuaikan musik dan efek suara sesuai keinginanmu!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF42634A),
                  ),
                ),
                const SizedBox(height: 28),

                // PENGATURAN MUSIK
                _AudioSettingCard(
                  title: 'Musik Latar',
                  subtitle: 'Musik yang menemani selama bermain',
                  icon: Icons.music_note_rounded,
                  color: const Color(0xFF269B50),
                  volumeNotifier: audio.bgmVolumeNotifier,
                  mutedNotifier: audio.bgmMutedNotifier,
                  onVolumeChanged: audio.setBgmVolume,
                  onMuteChanged: audio.setBgmMuted,
                ),

                const SizedBox(height: 18),

                // PENGATURAN EFEK SUARA
                _AudioSettingCard(
                  title: 'Efek Suara',
                  subtitle: 'Suara tombol, jawaban, dan penghargaan',
                  icon: Icons.volume_up_rounded,
                  color: const Color(0xFFFF963C),
                  volumeNotifier: audio.sfxVolumeNotifier,
                  mutedNotifier: audio.sfxMutedNotifier,
                  onVolumeChanged: audio.setSfxVolume,
                  onMuteChanged: audio.setSfxMuted,
                ),

                const SizedBox(height: 30),

                // KEMBALI KE MENU
                ElevatedButton.icon(
                  onPressed: () {
                     AudioManager.instance.playSfx(SfxTrack.buttonMenu);
                    audio.playSfx(SfxTrack.buttonMenu);
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.home_rounded),
                  label: const Text(
                    'Kembali ke Menu',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF269B50),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AudioSettingCard extends StatelessWidget {
  const _AudioSettingCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.volumeNotifier,
    required this.mutedNotifier,
    required this.onVolumeChanged,
    required this.onMuteChanged,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final ValueNotifier<double> volumeNotifier;
  final ValueNotifier<bool> mutedNotifier;
  final Future<void> Function(double) onVolumeChanged;
  final Future<void> Function(bool) onMuteChanged;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: mutedNotifier,
      builder: (context, isMuted, _) {
        return ValueListenableBuilder<double>(
          valueListenable: volumeNotifier,
          builder: (context, volume, _) {
            return Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .96),
                borderRadius: BorderRadius.circular(23),
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x26316C49),
                    blurRadius: 12,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: .14),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Icon(icon, color: color, size: 28),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF21653A),
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              subtitle,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF647568),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
  value: !isMuted,
  activeColor: color,
  onChanged: (enabled) {
    onMuteChanged(!enabled);
  },
),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Volume',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF42634A),
                        ),
                      ),
                      Text(
                        isMuted
                            ? 'Nonaktif'
                            : '${(volume * 100).round()}%',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: volume.clamp(0.0, 1.0),
                    min: 0,
                    max: 1,
                    activeColor: color,
                    inactiveColor: color.withValues(alpha: .18),
                    onChanged: isMuted
                        ? null
                        : (value) {
                            onVolumeChanged(value);
                          },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
