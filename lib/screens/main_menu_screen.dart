import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../services/audio_manager.dart';
import 'waste_category_screen.dart';
import 'misi_pilah_sampah_screen.dart';
import 'mulai_belajar_screen.dart';
import 'ikut_kuis_screen.dart';
import 'kamus_sampah_screen.dart';
import 'penghargaan_screen.dart';
import 'pengaturan_screen.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen>
    with TickerProviderStateMixin, RouteAware {
  late final AnimationController _floatController;
  late final AnimationController _cloudController;

  @override
  void initState() {
    super.initState();

    AudioManager.instance.playBgm(BgmTrack.mainMenu);
    AudioManager.instance.playSfx(SfxTrack.menuAppearChime);

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _cloudController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 24),
    )..repeat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route != null) {
      audioRouteObserver.subscribe(this, route);
    }
  }

  @override
  void didPopNext() {
    AudioManager.instance.playBgm(BgmTrack.mainMenu);
  }

  @override
  void dispose() {
    audioRouteObserver.unsubscribe(this);
    _floatController.dispose();
    _cloudController.dispose();
    super.dispose();
  }

 

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: AnimatedBuilder(
              animation:
                  Listenable.merge([_floatController, _cloudController]),
              builder: (context, _) {
                return CustomPaint(
                  painter: ParkBackgroundPainter(
                    floatValue: _floatController.value,
                    cloudValue: _cloudController.value,
                  ),
                );
              },
            ),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth < 380;

                return SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    compact ? 14 : 20,
                    12,
                    compact ? 14 : 20,
                    24,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 620),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // LOGO DAN PENGATURAN
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 9,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(.96),
                                  borderRadius: BorderRadius.circular(22),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x26336B49),
                                      blurRadius: 12,
                                      offset: Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.recycling_rounded,
                                      color: Color(0xFF239653),
                                      size: 35,
                                    ),
                                    const SizedBox(width: 7),
                                    const Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'SampaHore!',
                                          style: TextStyle(
                                            fontSize: 22,
                                            height: 1,
                                            fontWeight: FontWeight.w900,
                                            color: Color(0xFF176D3B),
                                            letterSpacing: -.6,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'BELAJAR • PILAH • JAGA BUMI',
                                          style: TextStyle(
                                            fontSize: 8.5,
                                            fontWeight: FontWeight.w800,
                                            color: Color(0xFF397B4B),
                                            letterSpacing: .4,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              _RoundIconButton(
                                icon: Icons.settings_rounded,
                                color: const Color(0xFFFF963C),
                                onTap: () {
  AudioManager.instance.playSfx(SfxTrack.buttonMenu);
  AudioManager.instance.playSfx(SfxTrack.pageTransitionWhoosh);

  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => const PengaturanScreen(),
    ),
  );
},
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // EMPAT TOMBOL MENU
                          GridView.count(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: compact ? 1.52 : 1.72,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            children: [      
                              _PlayfulMenuButton(
                                title: 'Mulai\nBelajar',
                                icon: Icons.menu_book_rounded,
                                colors: const [
                                  Color(0xFFFFB52E),
                                  Color(0xFFFF791D),
                                ],
                                onTap: () {
                                  AudioManager.instance.playSfx(SfxTrack.buttonMenu);
                                  AudioManager.instance.playSfx(SfxTrack.pageTransitionWhoosh);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const MulaiBelajarScreen(),
                                    ),
                                  );
                                },
                              ),
                              _PlayfulMenuButton(
                                title: 'Ikut\nKuis',
                                icon: Icons.quiz_rounded,
                                colors: const [
                                  Color(0xFF70D94D),
                                  Color(0xFF20A64D),
                                ],
                                onTap: () {
                                  AudioManager.instance.playSfx(SfxTrack.buttonMenu);
                                  AudioManager.instance.playSfx(SfxTrack.pageTransitionWhoosh);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const IkutKuisScreen(),
                                    ),
                                  );
                                },
                              ),
                              _PlayfulMenuButton(
                                title: 'Kamus\nSampah',
                                icon: Icons.menu_book_rounded,
                                colors: const [
                                  Color(0xFF48C5F3),
                                  Color(0xFF1688D9),
                                ],
                                onTap: () {
                                  AudioManager.instance.playSfx(SfxTrack.buttonMenu);
                                  AudioManager.instance.playSfx(SfxTrack.pageTransitionWhoosh);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const KamusSampahScreen(),
                                    ),
                                  );
                                },
                              ),
                              _PlayfulMenuButton(
                                title: 'Penghargaan',
                                icon: Icons.emoji_events_rounded,
                                colors: const [
                                  Color(0xFFBD75F5),
                                  Color(0xFF8745D9),
                                ],
                                onTap: () {
                                  AudioManager.instance.playSfx(SfxTrack.buttonMenu);
                                  AudioManager.instance.playSfx(SfxTrack.pageTransitionWhoosh);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const PenghargaanScreen(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // KARTU JENIS SAMPAH
                          Container(
                            padding: const EdgeInsets.fromLTRB(
                              14,
                              14,
                              14,
                              16,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(.96),
                              borderRadius: BorderRadius.circular(27),
                              border: Border.all(
                                color: Colors.white,
                                width: 3,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x26316C49),
                                  blurRadius: 14,
                                  offset: Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const Row(
                                  children: [
                                    Icon(
                                      Icons.eco_rounded,
                                      color: Color(0xFF24964E),
                                      size: 27,
                                    ),
                                    SizedBox(width: 7),
                                    Expanded(
                                      child: Text(
                                        'KENALI JENIS SAMPAH',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w900,
                                          color: Color(0xFF21653A),
                                          letterSpacing: .2,
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.auto_awesome_rounded,
                                      color: Color(0xFFFFBE34),
                                      size: 25,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 13),
                                Row(
                                  children: [                            
                                
Expanded(
  child: _WasteTypeCard(
    title: 'Organik',
    subtitle: 'Sisa alami',
    icon: Icons.eco_rounded,
    color: const Color(0xFF65BE45),
    pale: const Color(0xFFE5F8D7),
    onTap: () {
      AudioManager.instance.playSfx(SfxTrack.softPop);
      AudioManager.instance.playSfx(SfxTrack.pageTransitionWhoosh);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const WasteCategoryScreen(
            category: 'Organik',
          ),
        ),
      );
    },
  ),
),
                                    const SizedBox(width: 9),
                                   
Expanded(
  child: _WasteTypeCard(
    title: 'Anorganik',
    subtitle: 'Bisa didaur ulang',
    icon: Icons.recycling_rounded,
    color: const Color(0xFF2295E2),
    pale: const Color(0xFFDDF3FF),
    onTap: () {
      AudioManager.instance.playSfx(SfxTrack.softPop);
      AudioManager.instance.playSfx(SfxTrack.pageTransitionWhoosh);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const WasteCategoryScreen(
            category: 'Anorganik',
          ),
        ),
      );
    },
  ),
),
                                    const SizedBox(width: 9),
                                   
Expanded(
  child: _WasteTypeCard(
    title: 'B3',
    subtitle: 'Berbahaya',
    icon: Icons.warning_amber_rounded,
    color: const Color(0xFFEF5650),
    pale: const Color(0xFFFFE3DF),
    onTap: () {
      AudioManager.instance.playSfx(SfxTrack.softPop);
      AudioManager.instance.playSfx(SfxTrack.pageTransitionWhoosh);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const WasteCategoryScreen(
            category: 'B3',
          ),
        ),
      );
    },
  ),
),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 18),

                          // MASKOT BERGERAK
                          AnimatedBuilder(
                            animation: _floatController,
                            builder: (context, child) {
                              return Transform.translate(
                                offset: Offset(
                                  0,
                                  math.sin(
                                        _floatController.value * math.pi * 2,
                                      ) *
                                      4,
                                ),
                                child: child,
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFFFFF5C9),
                                    Color(0xFFFFFFFF),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 3,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x26316C49),
                                    blurRadius: 12,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: screenWidth < 360 ? 82 : 100,
                                    height: 115,
                                    child: AnimatedBuilder(
                                      animation: _floatController,
                                      builder: (context, _) {
                                        return Transform.rotate(
                                          angle: math.sin(
                                                _floatController.value *
                                                    math.pi *
                                                    2,
                                              ) *
                                              .055,
                                          child: const _TrashMascot(),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Ayo Pilah Sampah!',
                                          style: TextStyle(
                                            fontSize: 21,
                                            fontWeight: FontWeight.w900,
                                            color: Color(0xFF18743E),
                                            height: 1.1,
                                          ),
                                        ),
                                        const SizedBox(height: 7),
                                        const Text(
                                          'Yuk, jadi pahlawan bumi dengan memilah sampah dengan benar!',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF42634A),
                                            height: 1.35,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 11),
                                       
ElevatedButton.icon(
  onPressed: () {
    AudioManager.instance.playSfx(SfxTrack.buttonMenu);
    AudioManager.instance.playSfx(SfxTrack.pageTransitionWhoosh);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const MisiPilahSampahScreen(),
      ),
    );
  },
  icon: const Icon(
    Icons.play_arrow_rounded,
    size: 20,
  ),
  label: const Text(
    'Ayo Mulai!',
    style: TextStyle(
      fontWeight: FontWeight.w900,
    ),
  ),
  style: ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF269B50),
    foregroundColor: Colors.white,
    elevation: 3,
    padding: const EdgeInsets.symmetric(
      horizontal: 14,
      vertical: 9,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
    ),
  ),
),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 14),

                          const Text(
                            'Bumi bersih, hati pun ceria! 🌎',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF246A3B),
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================
// TOMBOL MENU DENGAN ANIMASI SAAT DITEKAN
// =====================================================

class _PlayfulMenuButton extends StatefulWidget {
  const _PlayfulMenuButton({
    required this.title,
    required this.icon,
    required this.colors,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final List<Color> colors;
  final VoidCallback onTap;

  @override
  State<_PlayfulMenuButton> createState() => _PlayfulMenuButtonState();
}

class _PlayfulMenuButtonState extends State<_PlayfulMenuButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 110),
      lowerBound: .92,
      upperBound: 1,
    )..value = 1;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.reverse(),
      onTapCancel: () => _controller.forward(),
      onTapUp: (_) {
        _controller.forward();
        widget.onTap();
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _controller.value,
            child: child,
          );
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: widget.colors,
            ),
            borderRadius: BorderRadius.circular(23),
            border: Border.all(
              color: widget.colors.first.withOpacity(.9),
              width: 2.5,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.colors.last.withOpacity(.35),
                blurRadius: 0,
                offset: const Offset(0, 5),
              ),
              const BoxShadow(
                color: Color(0x1F24452E),
                blurRadius: 7,
                offset: Offset(0, 7),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: 8,
                top: 6,
                child: Icon(
                  Icons.auto_awesome_rounded,
                  size: 16,
                  color: Colors.white.withOpacity(.55),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 11,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 49,
                      height: 49,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.22),
                        borderRadius: BorderRadius.circular(17),
                        border: Border.all(
                          color: Colors.white.withOpacity(.35),
                          width: 1.5,
                        ),
                      ),
                      child: Icon(
                        widget.icon,
                        size: 32,
                        color: Colors.white,
                        shadows: const [
                          Shadow(
                            color: Color(0x44333333),
                            blurRadius: 3,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 15,
                          height: 1.05,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Color(0x55333333),
                              blurRadius: 3,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: Colors.white,
                      size: 23,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =====================================================
// KARTU JENIS SAMPAH DENGAN ANIMASI
// =====================================================

class _WasteTypeCard extends StatefulWidget {
  const _WasteTypeCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.pale,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Color pale;
  final VoidCallback onTap;

  @override
  State<_WasteTypeCard> createState() => _WasteTypeCardState();
}

class _WasteTypeCardState extends State<_WasteTypeCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 130),
      lowerBound: .94,
      upperBound: 1,
    )..value = 1;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.reverse(),
      onTapCancel: () => _controller.forward(),
      onTapUp: (_) {
        _controller.forward();
        widget.onTap();
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _controller.value,
            child: child,
          );
        },
        child: Container(
          constraints: const BoxConstraints(minHeight: 110),
          padding: const EdgeInsets.symmetric(
            horizontal: 4,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: widget.pale,
            borderRadius: BorderRadius.circular(19),
            border: Border.all(
              color: widget.color.withOpacity(.18),
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 47,
                height: 47,
                decoration: BoxDecoration(
                  color: widget.color,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: widget.color.withOpacity(.22),
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(
                  widget.icon,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(height: 7),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  widget.title,
                  style: TextStyle(
                    color: widget.color,
                    fontWeight: FontWeight.w900,
                    fontSize: 12.5,
                  ),
                ),
              ),
              const SizedBox(height: 3),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  widget.subtitle,
                  style: const TextStyle(
                    color: Color(0xFF53675A),
                    fontWeight: FontWeight.w600,
                    fontSize: 8.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =====================================================
// TOMBOL PENGATURAN
// =====================================================

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      elevation: 4,
      shadowColor: color.withOpacity(.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(
          color: Colors.white,
          width: 2,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: SizedBox(
          width: 47,
          height: 47,
          child: Icon(
            icon,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
    );
  }
}

// =====================================================
// MASKOT TEMPAT SAMPAH KARTUN
// =====================================================

class _TrashMascot extends StatelessWidget {
  const _TrashMascot();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;

        return Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              bottom: 3,
              child: Container(
                width: w * .66,
                height: 9,
                decoration: BoxDecoration(
                  color: const Color(0x33274A2E),
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
            Positioned(
              top: 16,
              child: Container(
                width: w * .72,
                height: 15,
                decoration: BoxDecoration(
                  color: const Color(0xFF078F9C),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFF075F70),
                    width: 2,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 25,
              bottom: 11,
              child: Container(
                width: w * .62,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF42D4DD),
                      Color(0xFF0799AC),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(17),
                    top: Radius.circular(7),
                  ),
                  border: Border.all(
                    color: const Color(0xFF087384),
                    width: 2.5,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 44,
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 12,
                    decoration: BoxDecoration(
                      color: const Color(0xFF173A45),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  SizedBox(width: w * .16),
                  Container(
                    width: 8,
                    height: 12,
                    decoration: BoxDecoration(
                      color: const Color(0xFF173A45),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 56,
              child: Container(
                width: 24,
                height: 12,
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Color(0xFF173A45),
                      width: 3,
                    ),
                  ),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(14),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 71,
              child: Icon(
                Icons.recycling_rounded,
                size: 27,
                color: Colors.white.withOpacity(.95),
              ),
            ),
            Positioned(
              top: 48,
              left: w * .04,
              child: Container(
                width: 8,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFA6A0),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            Positioned(
              top: 48,
              right: w * .04,
              child: Container(
                width: 8,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFA6A0),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            Positioned(
              bottom: 5,
              left: w * .17,
              child: Container(
                width: 15,
                height: 9,
                decoration: BoxDecoration(
                  color: const Color(0xFF087384),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
            Positioned(
              bottom: 5,
              right: w * .17,
              child: Container(
                width: 15,
                height: 9,
                decoration: BoxDecoration(
                  color: const Color(0xFF087384),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
            const Positioned(
              top: 0,
              right: 3,
              child: Icon(
                Icons.star_rounded,
                color: Color(0xFFFFBE35),
                size: 21,
              ),
            ),
          ],
        );
      },
    );
  }
}

// =====================================================
// LATAR TAMAN, LANGIT, MATAHARI, AWAN, DAN BUKIT
// =====================================================

class ParkBackgroundPainter extends CustomPainter {
  ParkBackgroundPainter({
    required this.floatValue,
    required this.cloudValue,
  });

  final double floatValue;
  final double cloudValue;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    final sky = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF55C9F3),
          Color(0xFFB9F2FF),
          Color(0xFFE4FBD8),
        ],
      ).createShader(rect);

    canvas.drawRect(rect, sky);

    // Matahari
    final sunPaint = Paint()..color = const Color(0xFFFFD84D);

    final sunCenter = Offset(
      size.width * .84,
      74 + math.sin(floatValue * math.pi * 2) * 3,
    );

    for (var i = 0; i < 10; i++) {
      final angle = i * math.pi / 5;

      final start = sunCenter +
          Offset(
            math.cos(angle) * 26,
            math.sin(angle) * 26,
          );

      final end = sunCenter +
          Offset(
            math.cos(angle) * 32,
            math.sin(angle) * 32,
          );

      canvas.drawLine(
        start,
        end,
        Paint()
          ..color = const Color(0xFFFFD84D)
          ..strokeWidth = 4
          ..strokeCap = StrokeCap.round,
      );
    }

    canvas.drawCircle(sunCenter, 22, sunPaint);

    // Wajah matahari
    final face = Paint()
      ..color = const Color(0xFF9C6A28)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawArc(
      Rect.fromCenter(
        center: sunCenter + const Offset(-7, 0),
        width: 5,
        height: 7,
      ),
      math.pi,
      math.pi,
      false,
      face,
    );

    canvas.drawArc(
      Rect.fromCenter(
        center: sunCenter + const Offset(7, 0),
        width: 5,
        height: 7,
      ),
      math.pi,
      math.pi,
      false,
      face,
    );

    canvas.drawArc(
      Rect.fromCenter(
        center: sunCenter + const Offset(0, 7),
        width: 13,
        height: 8,
      ),
      0,
      math.pi,
      false,
      face,
    );

    // Awan bergerak
    _drawCloud(
      canvas,
      Offset(size.width * .18 + cloudValue * 38, 100),
      .8,
    );

    _drawCloud(
      canvas,
      Offset(size.width * .58 - cloudValue * 26, 145),
      .62,
    );

    _drawCloud(
      canvas,
      Offset(size.width * .98 - cloudValue * 34, 220),
      .7,
    );

    // Bukit belakang
    final farHill = Path()
      ..moveTo(0, size.height * .45)
      ..quadraticBezierTo(
        size.width * .20,
        size.height * .36,
        size.width * .40,
        size.height * .46,
      )
      ..quadraticBezierTo(
        size.width * .72,
        size.height * .34,
        size.width,
        size.height * .43,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(
      farHill,
      Paint()..color = const Color(0xFF9ADD82),
    );

    // Bukit depan
    final nearHill = Path()
      ..moveTo(0, size.height * .54)
      ..quadraticBezierTo(
        size.width * .25,
        size.height * .44,
        size.width * .53,
        size.height * .56,
      )
      ..quadraticBezierTo(
        size.width * .80,
        size.height * .47,
        size.width,
        size.height * .54,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(
      nearHill,
      Paint()..color = const Color(0xFF62C76B),
    );

    // Rumput dan bunga kecil
    final grass = Paint()
      ..color = const Color(0xFF369D53)
      ..strokeWidth = 2.3
      ..strokeCap = StrokeCap.round;

    for (var i = 0; i < 42; i++) {
      final x = (i * 37.0) % size.width;
      final y = size.height * (.60 + ((i * 13) % 35) / 100);

      canvas.drawLine(
        Offset(x, y),
        Offset(x - 3, y - 7 - (i % 4)),
        grass,
      );

      if (i % 7 == 0) {
        canvas.drawCircle(
          Offset(x + 6, y - 8),
          3.2,
          Paint()..color = const Color(0xFFFFF5BD),
        );

        canvas.drawCircle(
          Offset(x + 6, y - 8),
          1.2,
          Paint()..color = const Color(0xFFFFC83D),
        );
      }
    }

    // Daun dekoratif di sudut
    for (var i = 0; i < 4; i++) {
      canvas.save();

      canvas.translate(
        i.isEven ? 0 : size.width,
        i * 13.0,
      );

      canvas.rotate(i.isEven ? -.35 : math.pi + .35);

      canvas.drawOval(
        Rect.fromLTWH(-5, 0, 20, 10),
        Paint()
          ..color = i.isEven
              ? const Color(0xFF38A95B)
              : const Color(0xFF48B85B),
      );

      canvas.restore();
    }
  }

  void _drawCloud(Canvas canvas, Offset center, double scale) {
    final paint = Paint()..color = Colors.white.withOpacity(.82);

    canvas.drawOval(
      Rect.fromCenter(
        center: center,
        width: 55 * scale,
        height: 19 * scale,
      ),
      paint,
    );

    canvas.drawCircle(
      center + Offset(-13 * scale, -5 * scale),
      12 * scale,
      paint,
    );

    canvas.drawCircle(
      center + Offset(1 * scale, -10 * scale),
      16 * scale,
      paint,
    );

    canvas.drawCircle(
      center + Offset(15 * scale, -3 * scale),
      11 * scale,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant ParkBackgroundPainter oldDelegate) {
    return oldDelegate.floatValue != floatValue ||
        oldDelegate.cloudValue != cloudValue;
  }
}

// =====================================================
// HALAMAN SEMENTARA UNTUK MENU YANG BELUM DIBUAT
// =====================================================

class FeaturePlaceholderScreen extends StatelessWidget {
  const FeaturePlaceholderScreen({
    super.key,
    required this.title,
    required this.detail,
  });

  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFF2CA45A),
        foregroundColor: Colors.white,
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
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 110,
                  height: 120,
                  child: _TrashMascot(),
                ),
                const SizedBox(height: 18),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF176D3B),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  detail,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF365B40),
                  ),
                ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: () {
                    AudioManager.instance.playSfx(SfxTrack.buttonMenu);
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.arrow_back_rounded),
                  label: const Text('Kembali ke Menu'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}