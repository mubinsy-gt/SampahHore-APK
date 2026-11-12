
import 'package:flutter/material.dart';
import '../services/audio_manager.dart';
import 'main_menu_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _titleController;
  late final AnimationController _buttonController;

  late final Animation<double> _titleScale;
  late final Animation<double> _buttonScale;

  @override
  void initState() {
    super.initState();

    AudioManager.instance.playBgm(BgmTrack.splash);

    _titleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _titleScale = CurvedAnimation(
      parent: _titleController,
      curve: Curves.elasticOut,
    );

    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _buttonScale = Tween<double>(
      begin: 0.85,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _buttonController,
        curve: Curves.easeInOut,
      ),
    );

    _titleController.forward();
    _buttonController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  
  void _playGame() {
    AudioManager.instance.playSfx(SfxTrack.playButton);
    AudioManager.instance.playSfx(SfxTrack.pageTransitionWhoosh);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const MainMenuScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF8DE0F0),
              Color(0xFFD9F5C8),
              Color(0xFF74C66A),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Matahari
            Positioned(
              top: 65,
              right: 35,
              child: Container(
                width: 75,
                height: 75,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFD54F),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x55F9A825),
                      blurRadius: 25,
                      spreadRadius: 5,
                    ),
                  ],
                ),
              ),
            ),

            // Awan
            const Positioned(
              top: 85,
              left: 25,
              child: Icon(
                Icons.cloud,
                color: Colors.white,
                size: 75,
              ),
            ),
            const Positioned(
              top: 145,
              right: 25,
              child: Icon(
                Icons.cloud,
                color: Colors.white70,
                size: 55,
              ),
            ),

            // Bukit di bagian bawah
            Positioned(
              bottom: -100,
              left: -80,
              child: Container(
                width: 360,
                height: 250,
                decoration: const BoxDecoration(
                  color: Color(0xFF4CAF50),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: -125,
              right: -100,
              child: Container(
                width: 400,
                height: 270,
                decoration: const BoxDecoration(
                  color: Color(0xFF2E8B57),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            // Isi splash screen
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 20,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),

                      // Judul dengan animasi
                      ScaleTransition(
                        scale: _titleScale,
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Text(
                                  'SampaHore!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 42,
                                    fontWeight: FontWeight.w900,
                                    foreground: Paint()
                                      ..style = PaintingStyle.stroke
                                      ..strokeWidth = 5
                                      ..color = const Color(0xFF245A37),
                                  ),
                                ),
                                const Text(
                                  'SampaHore!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 42,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFFFFE45C),
                                    shadows: [
                                      Shadow(
                                        color: Colors.black26,
                                        offset: Offset(2, 4),
                                        blurRadius: 3,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Belajar memilah sampah jadi seru!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF245A37),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Maskot tempat sampah buatan Flutter
                      const TrashMascot(),

                      const SizedBox(height: 30),

                      // Tombol PLAY dengan animasi
                      ScaleTransition(
                        scale: _buttonScale,
                        child: SizedBox(
                          width: 200,
                          height: 64,
                          child: ElevatedButton(
                            onPressed: _playGame,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFFD54F),
                              foregroundColor: const Color(0xFF245A37),
                              elevation: 8,
                              shadowColor: Colors.black38,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(35),
                                side: const BorderSide(
                                  color: Color(0xFF245A37),
                                  width: 3,
                                ),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.play_arrow_rounded, size: 34),
                                SizedBox(width: 5),
                                Text(
                                  'PLAY',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      const Text(
                        'Ayo jaga bumi kita! 🌱',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF245A37),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Maskot dibuat dari widget Flutter, tanpa gambar eksternal.
class TrashMascot extends StatelessWidget {
  const TrashMascot({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 190,
      height: 220,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          // Tutup tempat sampah
          Positioned(
            top: 20,
            child: Container(
              width: 150,
              height: 22,
              decoration: BoxDecoration(
                color: const Color(0xFF277DA1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0xFF18566F),
                  width: 3,
                ),
              ),
            ),
          ),

          // Badan tempat sampah
          Positioned(
            top: 37,
            child: Container(
              width: 125,
              height: 145,
              decoration: BoxDecoration(
                color: const Color(0xFF43BCCD),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(25),
                  top: Radius.circular(12),
                ),
                border: Border.all(
                  color: const Color(0xFF18566F),
                  width: 4,
                ),
                
boxShadow: [
  BoxShadow(
    color: Colors.black.withOpacity(0.2),
    blurRadius: 8,
    offset: const Offset(0, 5),
  ),
],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Mata
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _MascotEye(),
                      SizedBox(width: 25),
                      _MascotEye(),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Senyum
                  Container(
                    width: 35,
                    height: 17,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0xFF17475B),
                          width: 4,
                        ),
                      ),
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(30),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  const Icon(
                    Icons.recycling_rounded,
                    size: 34,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),

          // Tangan kiri dan kanan
          Positioned(
            top: 85,
            left: 0,
            child: Transform.rotate(
              angle: -0.5,
              child: Container(
                width: 32,
                height: 12,
                decoration: BoxDecoration(
                  color: const Color(0xFF277DA1),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Positioned(
            top: 85,
            right: 0,
            child: Transform.rotate(
              angle: 0.5,
              child: Container(
                width: 32,
                height: 12,
                decoration: BoxDecoration(
                  color: const Color(0xFF277DA1),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),

          // Kaki
          Positioned(
            bottom: 8,
            left: 42,
            child: Container(
              width: 25,
              height: 17,
              decoration: BoxDecoration(
                color: const Color(0xFF18566F),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          Positioned(
            bottom: 8,
            right: 42,
            child: Container(
              width: 25,
              height: 17,
              decoration: BoxDecoration(
                color: const Color(0xFF18566F),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),

          // Bintang hiasan
          const Positioned(
            top: 0,
            left: 12,
            child: Icon(
              Icons.star_rounded,
              color: Color(0xFFFFD54F),
              size: 30,
            ),
          ),
          const Positioned(
            top: 15,
            right: 8,
            child: Icon(
              Icons.auto_awesome,
              color: Colors.white,
              size: 25,
            ),
          ),
        ],
      ),
    );
  }
}

class _MascotEye extends StatelessWidget {
  const _MascotEye();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 21,
      decoration: const BoxDecoration(
        color: Color(0xFF173B4A),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Align(
        alignment: Alignment.topRight,
        child: Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.all(3),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}