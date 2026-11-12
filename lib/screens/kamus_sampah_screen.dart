
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/audio_manager.dart';
import 'laboratorium_sampah_screen.dart';
import 'kelas_penjaga_bumi_screen.dart';
import 'cerita_sahabat_bumi_screen.dart';
import 'aksi_nyata_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';


class KamusSampahScreen extends StatefulWidget {
  const KamusSampahScreen({super.key});

  @override
  State<KamusSampahScreen> createState() =>
      _KamusSampahScreenState();
}

class _KamusSampahScreenState extends State<KamusSampahScreen>
    with TickerProviderStateMixin, RouteAware {
  late final AnimationController _floatController;
  late final AnimationController _cloudController;
  late final AnimationController _sunController;

  @override
  void initState() {
    super.initState();

    AudioManager.instance.playBgm(BgmTrack.kamus);

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    _cloudController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat();

    _sunController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);
    _checkExplorerBadge();
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
    AudioManager.instance.playBgm(BgmTrack.kamus);
  }

  @override
  void dispose() {
    audioRouteObserver.unsubscribe(this);
    _floatController.dispose();
    _cloudController.dispose();
    _sunController.dispose();
    super.dispose();
  }

  static const Color darkGreen = Color(0xFF24643D);
  static const Color green = Color(0xFF49B95B);
 
 
Future<void> _checkExplorerBadge() async {
  final prefs = await SharedPreferences.getInstance();
  final alreadyEarned = prefs.getBool('badge_penjelajah_sampah') ?? false;

  final penjagaBumi =
      prefs.getBool('badge_penjaga_bumi') ?? false;
  final ilmuwanSampah =
      prefs.getBool('badge_ilmuwan_sampah') ?? false;
  final sahabatBumi =
      prefs.getBool('badge_sahabat_bumi') ?? false;
  final pahlawanAksiNyata =
      prefs.getBool('badge_pahlawan_aksi_nyata') ?? false;

  final semuaSelesai = penjagaBumi &&
      ilmuwanSampah &&
      sahabatBumi &&
      pahlawanAksiNyata;

  if (semuaSelesai) {
    await prefs.setBool('badge_penjelajah_sampah', true);
    if (!alreadyEarned) {
      AudioManager.instance.playSfx(SfxTrack.sparkle);
    }
  }
}


  void _openActivity({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    Future<void> Function()? onExplore,

  }) {
    AudioManager.instance.playSfx(SfxTrack.menuAppearChime);
    showModalBottomSheet(
  context: context,
  backgroundColor: Colors.transparent,
  isScrollControlled: true,
  builder: (sheetContext) => Container(
    padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
    decoration: const BoxDecoration(
      color: Color(0xFFFFFEF5),
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(30),
      ),
    ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 45,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 22),
              Container(
                width: 86,
                height: 86,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 48),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.fredoka(
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                  color: darkGreen,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                description,
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  fontSize: 15,
                  height: 1.5,
                  color: const Color(0xFF55705D),
                ),
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
  onPressed: () async {
  Navigator.pop(sheetContext);
  await onExplore?.call();

  if (!mounted) return;

  await _checkExplorerBadge();
},
  style: ElevatedButton.styleFrom(
    backgroundColor: green,
    foregroundColor: Colors.white,
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
    ),
  ),
  child: Text(
    'Siap, Ayo Jelajahi!',
    style: GoogleFonts.fredoka(
      fontSize: 17,
      fontWeight: FontWeight.w600,
    ),
  ),
),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2FBEA),
      body: Stack(
        children: [
          // Latar langit
          Container(
            height: 330,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF67C9F8),
                  Color(0xFFB9EDFF),
                  Color(0xFFF2FBEA),
                ],
                stops: [0, 0.65, 1],
              ),
            ),
          ),

          // Awan bergerak
          Positioned(
            top: 70,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _cloudController,
              builder: (context, child) {
                return SizedBox(
                  height: 65,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final width = constraints.maxWidth;
                      final x = _cloudController.value * width;

                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            left: x - 110,
                            top: 8,
                            child: const _Cloud(size: 1),
                          ),
                          Positioned(
                            left: (x + width * 0.45) % (width + 130) - 40,
                            top: 25,
                            child: const _Cloud(size: 0.7),
                          ),
                        ],
                      );
                    },
                  ),
                );
              },
            ),
          ),

          // Isi halaman
          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 8, 18, 0),
                  child: Row(
                    children: [
                      _roundButton(
                        icon: Icons.arrow_back_rounded,
                        onTap: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'KAMUS SAMPAH',
                              style: GoogleFonts.fredoka(
                                color: darkGreen,
                                fontSize: 23,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              'Petualangan seru Penjaga Bumi!',
                              style: GoogleFonts.nunito(
                                color: darkGreen,
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                      AnimatedBuilder(
                        animation: _sunController,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: math.sin(
                                  _sunController.value * math.pi,
                                ) *
                                0.12,
                            child: const Icon(
                              Icons.wb_sunny_rounded,
                              color: Color(0xFFFFB928),
                              size: 39,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // Bagian maskot dan sambutan
                SizedBox(
                  height: 245,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        bottom: 0,
                        left: -20,
                        right: -20,
                        height: 65,
                        child: CustomPaint(
                          painter: _HillPainter(),
                        ),
                      ),
                      Positioned(
                        top: 16,
                        left: 18,
                        child: Transform.rotate(
                          angle: -0.15,
                          child: const Icon(
                            Icons.star_rounded,
                            color: Color(0xFFFFC83D),
                            size: 30,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 22,
                        top: 45,
                        child: const Icon(
                          Icons.auto_awesome_rounded,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                      
Positioned(
  top: 10,
  left: 0,
  right: 0,
  child: Center(
    child: _speechBubble(
      'Halo, Sahabat Bumi!',
    ),
  ),
),

                      Positioned(
                        right: 18,
                        top: 110,
                        child: const Icon(
                          Icons.favorite_rounded,
                          color: Color(0xFFFF7B87),
                          size: 25,
                        ),
                      ),
                      AnimatedBuilder(
                        animation: _floatController,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(
                              0,
                              math.sin(
                                    _floatController.value * math.pi,
                                  ) *
                                  7,
                            ),
                            child: child,
                          );
                        },
                        child: const _EarthMascot(),
                      ),
                      Positioned(
                        bottom: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFD85B),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x223C713B),
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ConstrainedBox(
  constraints: const BoxConstraints(maxWidth: 270),
  child: FittedBox(
    fit: BoxFit.scaleDown,
    child: Text(
      'Belajar sambil bermain! 🌱',
      maxLines: 1,
      style: GoogleFonts.fredoka(
        color: const Color(0xFF72501A),
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
    ),
  ),
),
                        ),
                      ),
                    ],
                  ),
                ),

                // Daftar aktivitas
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(18, 14, 18, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Yuk, Jelajahi!',
                          style: GoogleFonts.fredoka(
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                            color: darkGreen,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Pilih tempat petualanganmu hari ini.',
                          style: GoogleFonts.nunito(
                            color: const Color(0xFF66816B),
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 16),

                        
_activityCard(
  number: '01',
  title: 'Kelas Penjaga Bumi',
  subtitle: 'Belajar jadi pahlawan lingkungan!',
  icon: Icons.school_rounded,
  color: const Color(0xFF53B85C),
  lightColor: const Color(0xFFE1F8D9),
  tag: 'AYO BELAJAR',
  onTap: () => _openActivity(
    title: 'Kelas Penjaga Bumi',
    description:
        'Yuk, selesaikan tiga misi seru! Jaga taman tetap '
        'bersih, rawat tanaman, dan hemat air serta listrik. '
        'Selesaikan semua misi untuk mendapatkan lencana '
        'Penjaga Bumi!',
    icon: Icons.school_rounded,
    color: const Color(0xFF53B85C),
   
onExplore: () async {
  await Navigator.push<void>(
    context,
    MaterialPageRoute<void>(
      builder: (context) =>
          const KelasPenjagaBumiScreen(),
    ),
  );
},

  ),
),

                        const SizedBox(height: 13),

                        
_activityCard(
  number: '02',
  title: 'Laboratorium Sampah',
  subtitle: 'Jelajahi dunia sampah dan temukan fakta menarik.',
  icon: Icons.science_rounded,
  color: const Color(0xFF299CE0),
  lightColor: const Color(0xFFDDF3FF),
  tag: 'JADI ILMUWAN',
  onTap: () => _openActivity(
    title: 'Laboratorium Sampah',
    description:
        'Yuk, jadi ilmuwan cilik! Jelajahi mesin pengurai '
        'organik, pabrik daur ulang, dan zona sampah berbahaya. '
        'Ketuk berbagai benda untuk menemukan fakta menarik '
        'dan kumpulkan lencana Ilmuwan Sampah!',
    icon: Icons.science_rounded,
    color: const Color(0xFF299CE0),
    
onExplore: () async {
  await Navigator.push<void>(
    context,
    MaterialPageRoute<void>(
      builder: (context) =>
          const LaboratoriumSampahScreen(),
    ),
  );
},

  ),
),

                        const SizedBox(height: 13),

                        
_activityCard(
  number: '03',
  title: 'Cerita Sahabat Bumi',
  subtitle: 'Dengarkan kisah seru dari alam.',
  icon: Icons.menu_book_rounded,
  color: const Color(0xFFAA72D8),
  lightColor: const Color(0xFFF0E5FF),
  tag: 'BACA CERITA',
  onTap: () => _openActivity(
    title: 'Cerita Sahabat Bumi',
    description:
        'Ikuti petualangan Bimo dan teman-temannya '
        'menyelamatkan taman. Baca tiga bagian cerita, '
        'temukan pesan baik dari setiap petualangan, '
        'dan dapatkan lencana Sahabat Bumi!',
    icon: Icons.menu_book_rounded,
    color: const Color(0xFFAA72D8),
    
onExplore: () async {
  await Navigator.push<void>(
    context,
    MaterialPageRoute<void>(
      builder: (context) =>
          const CeritaSahabatBumiScreen(),
    ),
  );
},

  ),
),

                        const SizedBox(height: 13),

                        
_activityCard(
  number: '04',
  title: 'Aksi Nyata',
  subtitle: 'Lakukan kebiasaan baik setiap hari.',
  icon: Icons.volunteer_activism_rounded,
  color: const Color(0xFFFF9D37),
  lightColor: const Color(0xFFFFEBD2),
  tag: 'JADI PAHLAWAN',
  onTap: () => _openActivity(
    title: 'Aksi Nyata',
    description:
        'Mulai dari hal kecil, seperti membuang '
        'sampah pada tempatnya dan membawa botol '
        'minum sendiri. Yuk, lakukan tiga aksi '
        'untuk bumi dan dapatkan lencana Pahlawan Aksi Nyata!',
    icon: Icons.volunteer_activism_rounded,
    color: const Color(0xFFFF9D37),
   
onExplore: () async {
  await Navigator.push<void>(
    context,
    MaterialPageRoute<void>(
      builder: (context) => const AksiNyataScreen(),
    ),
  );
},

  ),
),


                        const SizedBox(height: 22),

                        // Papan penyemangat
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF3FAD62),
                                Color(0xFF21834A),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(23),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x22327E49),
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.eco_rounded,
                                color: Color(0xFFFFE477),
                                size: 43,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Bumi Butuh Kamu!',
                                      style: GoogleFonts.fredoka(
                                        color: Colors.white,
                                        fontSize: 19,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      'Langkah kecilmu berarti besar '
                                      'untuk bumi.',
                                      style: GoogleFonts.nunito(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.favorite_rounded,
                                color: Color(0xFFFFA6A6),
                                size: 29,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                        Center(
                          child: Text(
                            '🌼 Bersama, kita jaga bumi! 🌼',
                            style: GoogleFonts.fredoka(
                              color: darkGreen,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _roundButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white.withValues(alpha: 0.9),
      shape: const CircleBorder(),
      elevation: 3,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 43,
          height: 43,
          child: Icon(icon, color: darkGreen, size: 25),
        ),
      ),
    );
  }

  Widget _speechBubble(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F315C46),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        text,
        style: GoogleFonts.fredoka(
          color: darkGreen,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _activityCard({
    required String number,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Color lightColor,
    required String tag,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(23),
      elevation: 3,
      shadowColor: color.withValues(alpha: 0.18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(23),
        child: Padding(
          padding: const EdgeInsets.all(13),
          child: Row(
            children: [
              Container(
                width: 76,
                height: 80,
                decoration: BoxDecoration(
                  color: lightColor,
                  borderRadius: BorderRadius.circular(19),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(icon, color: color, size: 43),
                    Positioned(
                      top: 4,
                      right: 5,
                      child: Icon(
                        Icons.auto_awesome_rounded,
                        color: color.withValues(alpha: 0.65),
                        size: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: lightColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        tag,
                        style: GoogleFonts.nunito(
                          color: color,
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      title,
                      style: GoogleFonts.fredoka(
                        color: const Color(0xFF294B36),
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.nunito(
                        color: const Color(0xFF78877B),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 5),
              Column(
                children: [
                  Text(
                    number,
                    style: GoogleFonts.fredoka(
                      color: color.withValues(alpha: 0.75),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 17,
                    color: color,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Awan kartun dari bentuk-bentuk Flutter
class _Cloud extends StatelessWidget {
  final double size;

  const _Cloud({required this.size});

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: size,
      child: SizedBox(
        width: 110,
        height: 50,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Positioned(
              bottom: 0,
              child: Container(
                width: 105,
                height: 26,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            Positioned(
              bottom: 8,
              left: 15,
              child: _cloudBall(35),
            ),
            Positioned(
              bottom: 12,
              child: _cloudBall(43),
            ),
            Positioned(
              bottom: 5,
              right: 13,
              child: _cloudBall(29),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cloudBall(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        shape: BoxShape.circle,
      ),
    );
  }
}

// Maskot Bumi sementara, tanpa gambar eksternal
class _EarthMascot extends StatelessWidget {
  const _EarthMascot();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 158,
      height: 165,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Badan bumi
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF7CE66D),
                  Color(0xFF27A9E0),
                  Color(0xFF187AC0),
                ],
              ),
              border: Border.all(
                color: Colors.white,
                width: 5,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x33326B78),
                  blurRadius: 12,
                  offset: Offset(0, 7),
                ),
              ],
            ),
          ),

          // Daratan hijau
          Positioned(
            left: 30,
            top: 31,
            child: Transform.rotate(
              angle: -0.4,
              child: Container(
                width: 34,
                height: 43,
                decoration: const BoxDecoration(
                  color: Color(0xFF69D65B),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(12),
                    bottomLeft: Radius.circular(9),
                    bottomRight: Radius.circular(22),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 25,
            bottom: 33,
            child: Transform.rotate(
              angle: 0.5,
              child: Container(
                width: 35,
                height: 25,
                decoration: const BoxDecoration(
                  color: Color(0xFF69D65B),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(17),
                    topRight: Radius.circular(8),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(20),
                  ),
                ),
              ),
            ),
          ),

          // Mata
          Positioned(
            top: 55,
            left: 48,
            child: _eye(),
          ),
          Positioned(
            top: 55,
            right: 48,
            child: _eye(),
          ),

          // Pipi
          const Positioned(
            left: 34,
            top: 76,
            child: _cheek(),
          ),
          const Positioned(
            right: 34,
            top: 76,
            child: _cheek(),
          ),

          // Senyum
          Positioned(
            top: 75,
            child: Container(
              width: 25,
              height: 15,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xFF174F6C),
                    width: 3,
                  ),
                ),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
              ),
            ),
          ),

          // Tangan kecil
          const Positioned(
            left: 0,
            top: 78,
            child: Icon(
              Icons.waving_hand_rounded,
              color: Color(0xFFFFC36C),
              size: 30,
            ),
          ),
          const Positioned(
            right: 0,
            top: 80,
            child: Icon(
              Icons.front_hand_rounded,
              color: Color(0xFFFFC36C),
              size: 27,
            ),
          ),

          const Positioned(
            top: 0,
            right: 20,
            child: Icon(
              Icons.star_rounded,
              color: Color(0xFFFFD64D),
              size: 30,
            ),
          ),
        ],
      ),
    );
  }

  Widget _eye() {
    return Container(
      width: 11,
      height: 15,
      decoration: BoxDecoration(
        color: const Color(0xFF174F6C),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Align(
        alignment: Alignment.topRight,
        child: Container(
          margin: const EdgeInsets.all(2),
          width: 4,
          height: 4,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class _cheek extends StatelessWidget {
  const _cheek();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 17,
      height: 9,
      decoration: BoxDecoration(
        color: const Color(0xFFFFA6A6).withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}

// Bukit hijau di bagian bawah maskot
class _HillPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFF9BDF76);

    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, size.height * 0.65)
      ..quadraticBezierTo(
        size.width * 0.25,
        -size.height * 0.2,
        size.width * 0.52,
        size.height * 0.6,
      )
      ..quadraticBezierTo(
        size.width * 0.78,
        size.height * 1.1,
        size.width,
        size.height * 0.35,
      )
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(path, paint);

    final grassPaint = Paint()
      ..color = const Color(0xFF65BD55)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 28; i++) {
      final x = (i / 28) * size.width;
      final y = size.height * (0.65 + 0.12 * math.sin(i.toDouble()));

      canvas.drawLine(
        Offset(x, y),
        Offset(x - 3, y - 7),
        grassPaint,
      );
      canvas.drawLine(
        Offset(x + 2, y),
        Offset(x + 6, y - 5),
        grassPaint,
      );
    }

    final flowerPaint = Paint()..color = const Color(0xFFFFD65C);
    final flowerCenters = [
      Offset(size.width * 0.15, size.height * 0.65),
      Offset(size.width * 0.83, size.height * 0.54),
    ];

    for (final center in flowerCenters) {
      canvas.drawCircle(center, 4, flowerPaint);
      canvas.drawCircle(
        center + const Offset(0, -5),
        3,
        Paint()..color = Colors.white,
      );
      canvas.drawCircle(
        center + const Offset(5, 0),
        3,
        Paint()..color = Colors.white,
      );
      canvas.drawCircle(
        center + const Offset(-5, 0),
        3,
        Paint()..color = Colors.white,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
