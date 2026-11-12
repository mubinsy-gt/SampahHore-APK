import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/audio_manager.dart';

class MulaiBelajarScreen extends StatefulWidget {
  const MulaiBelajarScreen({super.key});

  @override
  State<MulaiBelajarScreen> createState() =>
      _MulaiBelajarScreenState();
}

class _MulaiBelajarScreenState extends State<MulaiBelajarScreen>
    with TickerProviderStateMixin, RouteAware {
  late AnimationController _floatController;
  late AnimationController _starController;
  late AnimationController _entranceController;

  final List<bool> _completed = List.filled(5, false);

  static const Color navy = Color(0xFF263B66);
  static const Color blue = Color(0xFF6589F5);
  static const Color green = Color(0xFF39B96B);

  Future<void> _loadProgress() async {
  final prefs = await SharedPreferences.getInstance();

  final completed = List.generate(
    _lessons.length,
    (index) => prefs.getBool(
          'mulai_belajar_materi_$index',
        ) ??
        false,
  );

  if (!mounted) return;

  setState(() {
    for (int i = 0; i < completed.length; i++) {
      _completed[i] = completed[i];
    }
  });

  if (completed.every((value) => value)) {
    await prefs.setBool('badge_bintang_pembelajar', true);
  }
}
  // DAFTAR MATERI PEMBELAJARAN
  final List<_Lesson> _lessons = const [
    _Lesson(
      title: 'Apa Itu Sampah?',
      subtitle: 'Yuk, kenali sampah!',
      description: 'Belajar tentang sampah dan asalnya.',
      emoji: '🌍',
      color: Color(0xFF4385F5),
      lightColor: Color(0xFFE2EDFF),
      tag: 'MATERI 1',
      heading: 'Kenalan dengan Sampah',
      content:
          'Sampah adalah sisa dari kegiatan manusia atau proses '
          'alam yang sudah tidak digunakan lagi. Sampah bisa kita '
          'temukan di rumah, sekolah, taman, dan tempat lainnya.',
      examples: [
        '🍌 Kulit pisang',
        '📄 Kertas bekas',
        '🧴 Botol plastik',
      ],
      fact:
          'Sampah yang dibuang sembarangan bisa membuat '
          'lingkungan kotor.',
      tip: 'Buanglah sampah pada tempat yang sesuai!',
    ),
    _Lesson(
      title: 'Mengapa Sampah Harus Dikelola?',
      subtitle: 'Jaga lingkungan kita!',
      description: 'Ketahui alasan sampah perlu ditangani.',
      emoji: '🌱',
      color: Color(0xFF39B96B),
      lightColor: Color(0xFFE1F9E9),
      tag: 'MATERI 2',
      heading: 'Sampah Perlu Dikelola',
      content:
          'Sampah yang menumpuk dapat mengganggu kebersihan '
          'dan kenyamanan. Karena itu, sampah perlu dikurangi, '
          'dipilah, dan ditangani dengan cara yang tepat.',
      examples: [
        '🧹 Menjaga kelas tetap bersih',
        '🗑️ Membuang sampah dengan benar',
        '♻️ Menggunakan kembali barang',
      ],
      fact:
          'Lingkungan bersih membuat kegiatan belajar '
          'lebih nyaman.',
      tip:
          'Biasakan merapikan sampah setelah makan atau bermain.',
    ),
    _Lesson(
      title: 'Dampak Sampah bagi Bumi',
      subtitle: 'Bumi perlu pertolongan!',
      description: 'Kenali akibat sampah yang tidak dikelola.',
      emoji: '🌊',
      color: Color(0xFF16A6B6),
      lightColor: Color(0xFFDDF8FA),
      tag: 'MATERI 3',
      heading: 'Apa Akibatnya?',
      content:
          'Sampah yang dibuang sembarangan dapat mencemari '
          'tanah dan air. Sampah juga bisa menyumbat saluran '
          'air serta membahayakan hewan yang memakannya.',
      examples: [
        '🐟 Air tercemar sampah',
        '🌧️ Saluran air tersumbat',
        '🐢 Hewan terancam bahaya',
      ],
      fact:
          'Sampah plastik yang masuk ke sungai bisa terbawa '
          'hingga laut.',
      tip: 'Jangan membuang sampah ke selokan atau sungai.',
    ),
    _Lesson(
      title: 'Ayo Kurangi Sampah!',
      subtitle: 'Mulai dari kebiasaan kecil',
      description: 'Belajar mengurangi dan menggunakan kembali.',
      emoji: '♻️',
      color: Color(0xFF8B68DB),
      lightColor: Color(0xFFF0E8FF),
      tag: 'MATERI 4',
      heading: 'Kurangi Sampah Setiap Hari',
      content:
          'Kita bisa membantu mengurangi sampah dengan membawa '
          'botol minum sendiri, memakai tas belanja yang bisa '
          'digunakan kembali, dan menggunakan kertas seperlunya.',
      examples: [
        '🥤 Membawa botol minum',
        '🛍️ Menggunakan tas pakai ulang',
        '📄 Memanfaatkan kertas bekas',
      ],
      fact:
          'Barang yang masih layak pakai belum tentu harus dibuang.',
      tip: 'Pikirkan dahulu sebelum membuang barang.',
    ),
    _Lesson(
      title: 'Jadilah Penjaga Bumi!',
      subtitle: 'Kamu bisa membuat perubahan!',
      description: 'Terapkan kebiasaan baik setiap hari.',
      emoji: '💚',
      color: Color(0xFFFF9D35),
      lightColor: Color(0xFFFFEFD9),
      tag: 'MATERI 5',
      heading: 'Aksi Penjaga Bumi',
      content:
          'Menjaga bumi bisa dimulai dari tindakan sederhana. '
          'Kita dapat membersihkan lingkungan, menghemat air, '
          'mengurangi barang sekali pakai, dan mengajak teman '
          'melakukan kebiasaan baik.',
      examples: [
        '🧹 Membersihkan ruang kelas',
        '🌳 Merawat tanaman',
        '🤝 Mengajak teman menjaga kebersihan',
      ],
      fact:
          'Tindakan kecil yang dilakukan bersama bisa '
          'membawa perubahan.',
      tip:
          'Pilih satu kebiasaan baik dan lakukan setiap hari!',
    ),
  ];

  @override
  void initState() {
    super.initState();

    AudioManager.instance.playBgm(BgmTrack.belajar);
    _loadProgress();

    // Animasi ilustrasi bergerak naik dan turun.
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    // Animasi bintang dan dekorasi.
    _starController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();

    // Animasi saat halaman pertama kali muncul.
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
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
    AudioManager.instance.playBgm(BgmTrack.belajar);
  }

  @override
  void dispose() {
    audioRouteObserver.unsubscribe(this);
    _floatController.dispose();
    _starController.dispose();
    _entranceController.dispose();
    super.dispose();
  }

  int get _completedCount =>
      _completed.where((value) => value).length;

  // Membuka halaman detail materi.
  
Future<void> _openLesson(int index) async {
  AudioManager.instance.playSfx(SfxTrack.softPop);
  AudioManager.instance.playSfx(SfxTrack.pageTransitionWhoosh);
  final result = await Navigator.push<List<int>>(
    context,
    MaterialPageRoute(
      builder: (_) => _LessonDetailScreen(
        lessons: _lessons,
        initialIndex: index,
        completedLessons: [
          for (int i = 0; i < _completed.length; i++)
            if (_completed[i]) i,
        ],
      ),
    ),
  );

  if (!mounted || result == null) return;

  final newlyCompleted = result.any(
    (i) =>
        i >= 0 &&
        i < _completed.length &&
        !_completed[i],
  );

  final prefs = await SharedPreferences.getInstance();

  for (final i in result) {
    if (i >= 0 && i < _completed.length) {
      _completed[i] = true;

      await prefs.setBool(
        'mulai_belajar_materi_$i',
        true,
      );
    }
  }

  final allCompleted = _completed.every((value) => value);

  if (allCompleted) {
    await prefs.setBool(
      'badge_bintang_pembelajar',
      true,
    );
  }

  if (!mounted) return;

  setState(() {});

  if (newlyCompleted) {
    _showReward();
  }
}


  // Dialog penghargaan setelah materi selesai.
  void _showReward() {
    AudioManager.instance.playSfx(SfxTrack.sparkle);
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFFFFF8DC),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '🏆',
              style: TextStyle(fontSize: 75),
            ),
            const SizedBox(height: 10),
            const Text(
              'KEREN SEKALI!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: Color(0xFFEF8D19),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Kamu berhasil menyelesaikan materi!\n'
              'Terus belajar menjaga bumi, ya!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                height: 1.5,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: green,
                foregroundColor: Colors.white,
                shape: const StadiumBorder(),
              ),
              onPressed: () {
  AudioManager.instance.playSfx(SfxTrack.buttonMenu);
  Navigator.pop(dialogContext);
},
child: const Text('YEAY! 🎉'),
            ),
          ],
        ),
      ),
    );
  }
    @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FF),
      body: Stack(
        children: [
          Positioned(
            top: -100,
            right: -75,
            child: _bubble(
              230,
              const Color(0xFFDDEAFF),
            ),
          ),
          Positioned(
            top: 300,
            left: -85,
            child: _bubble(
              170,
              const Color(0xFFE3F8E8),
            ),
          ),
          Positioned(
            bottom: -100,
            right: -55,
            child: _bubble(
              220,
              const Color(0xFFFFEED6),
            ),
          ),
          SafeArea(
            child: AnimatedBuilder(
              animation: _entranceController,
              builder: (context, child) {
                return Opacity(
                  opacity: _entranceController.value,
                  child: Transform.translate(
                    offset: Offset(
                      0,
                      25 * (1 - _entranceController.value),
                    ),
                    child: child,
                  ),
                );
              },
              child: Column(
                children: [
                  _buildTopBar(),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(
                        20,
                        8,
                        20,
                        28,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHero(),
                          const SizedBox(height: 25),
                          _buildProgress(),
                          const SizedBox(height: 27),
                          Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  'Pilih Materi Belajarmu!',
                                  style: TextStyle(
                                    fontSize: 21,
                                    fontWeight: FontWeight.w900,
                                    color: navy,
                                  ),
                                ),
                              ),
                              AnimatedBuilder(
                                animation: _starController,
                                builder: (context, child) {
                                  return Transform.rotate(
                                    angle: math.sin(
                                          _starController.value *
                                              2 *
                                              math.pi,
                                        ) *
                                        0.12,
                                    child: child,
                                  );
                                },
                                child: const Text(
                                  '⭐',
                                  style: TextStyle(fontSize: 28),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 7),
                          const Text(
                            'Yuk, belajar menjaga bumi satu per satu!',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF77839B),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 17),

                          // Menampilkan lima kartu materi.
                          ...List.generate(
                            _lessons.length,
                            (index) => Padding(
                              padding: const EdgeInsets.only(
                                bottom: 15,
                              ),
                              child: _buildLessonCard(index),
                            ),
                          ),

                          _buildBottomBanner(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // BAGIAN HEADER ATAS
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 12, 20, 8),
      child: Row(
        children: [
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            elevation: 3,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                AudioManager.instance.playSfx(SfxTrack.pageTransitionWhoosh);
                Navigator.pop(context);
              },
              child: const SizedBox(
                width: 46,
                height: 46,
                child: Icon(
                  Icons.arrow_back_rounded,
                  color: Color(0xFF31558D),
                  size: 25,
                ),
              ),
            ),
          ),
          const SizedBox(width: 13),
          
Expanded(
  child: Text(
    'MISI BELAJAR',
    style: GoogleFonts.fredoka(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.5,
      color: navy,
    ),
  ),
),

          AnimatedBuilder(
            animation: _starController,
            builder: (context, child) {
              return Transform.scale(
                scale: 1 +
                    0.08 *
                        math.sin(
                          _starController.value * 2 * math.pi,
                        ),
                child: child,
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 9,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFFFE8A3),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: const Color(0xFFFFCF53),
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.star_rounded,
                    color: Color(0xFFE9A000),
                    size: 22,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    '$_completedCount/5',
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF9B6800),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // BANNER UTAMA DENGAN ILUSTRASI BERGERAK
  Widget _buildHero() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(19, 20, 19, 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF62C8FF),
            Color(0xFF6589F5),
            Color(0xFF8B76EF),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: blue.withValues(alpha: 0.28),
            blurRadius: 18,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const Positioned(
            top: -7,
            right: 0,
            child: Text(
              '✨',
              style: TextStyle(fontSize: 24),
            ),
          ),
          const Positioned(
            top: 28,
            right: 12,
            child: Text(
              '🌈',
              style: TextStyle(fontSize: 30),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'HALO, PENJAGA BUMI! 🌍',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Ayo Belajar\nSampah Hore!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 29,
                  height: 1.12,
                  fontWeight: FontWeight.w900,
                  shadows: [
                    Shadow(
                      color: Color(0x44304B9B),
                      offset: Offset(1, 3),
                      blurRadius: 3,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Belajar seru, bumi tersenyum! 💚',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Text(
                  'MULAI PETUALANGAN  ➜',
                  style: TextStyle(
                    color: Color(0xFF526BD1),
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: AnimatedBuilder(
                  animation: _floatController,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(
                        0,
                        math.sin(
                              _floatController.value *
                                  math.pi *
                                  2,
                            ) *
                            5,
                      ),
                      child: child,
                    );
                  },

                  // NANTI GANTI EMOJI INI DENGAN ILUSTRASI BUMI.
                  child: const Text(
                    '🌎',
                    style: TextStyle(fontSize: 58),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // PROGRES BELAJAR
  Widget _buildProgress() {
    final progress = _completedCount / _lessons.length;

    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(23),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF64748B).withValues(alpha: 0.07),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF0C9),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.emoji_events_rounded,
                  color: Color(0xFFEAA000),
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Progres Belajarku',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: navy,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$_completedCount dari 5 materi selesai',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF8590A5),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${(progress * 100).round()}%',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: TweenAnimationBuilder<double>(
              tween: Tween(
                begin: 0,
                end: progress,
              ),
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return LinearProgressIndicator(
                  value: value,
                  minHeight: 12,
                  backgroundColor: const Color(0xFFEDF1F7),
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(green),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // KARTU MATERI DENGAN ANIMASI ILUSTRASI
  Widget _buildLessonCard(int index) {
    final item = _lessons[index];
    final completed = _completed[index];

    return AnimatedBuilder(
      animation: _floatController,
      builder: (context, child) {
        final phase =
            _floatController.value * math.pi * 2 + index;

        return Transform.translate(
          offset: Offset(0, math.sin(phase) * 2),
          child: child,
        );
      },
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(25),
          onTap: () => _openLesson(index),
          child: Ink(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: completed ? item.color : item.lightColor,
                width: completed ? 2 : 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: item.color.withValues(alpha: 0.12),
                  blurRadius: 13,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(13),
              child: Row(
                children: [
                  Container(
                    width: 98,
                    height: 112,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          item.lightColor,
                          Colors.white,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(21),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          top: 7,
                          right: 7,
                          child: Text(
                            index.isEven ? '✨' : '⭐',
                            style: const TextStyle(fontSize: 19),
                          ),
                        ),

                        // ILUSTRASI SEMENTARA.
                        // Emoji ini nantinya bisa diganti gambar.
                        AnimatedBuilder(
                          animation: _floatController,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(
                                0,
                                math.sin(
                                      _floatController.value *
                                              math.pi *
                                              2 +
                                          index,
                                    ) *
                                    5,
                              ),
                              child: child,
                            );
                          },
                          child: Text(
                            item.emoji,
                            style: const TextStyle(fontSize: 48),
                          ),
                        ),
                        Positioned(
                          bottom: 5,
                          left: 5,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: item.color,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              item.tag,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
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
                        Text(
                          item.title,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            color: item.color,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          item.subtitle,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF35415B),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          item.description,
                          style: const TextStyle(
                            fontSize: 11,
                            height: 1.35,
                            color: Color(0xFF818BA0),
                          ),
                        ),
                        const SizedBox(height: 9),
                        Row(
                          children: [
                            Icon(
                              completed
                                  ? Icons.check_circle_rounded
                                  : Icons.play_circle_fill_rounded,
                              size: 18,
                              color: item.color,
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                completed
                                    ? 'Sudah dipelajari'
                                    : 'Ayo mulai!',
                                style: TextStyle(
                                  color: item.color,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_rounded,
                              color: item.color,
                              size: 20,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // BANNER PENUTUP
  Widget _buildBottomBanner() {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFFD66B),
            Color(0xFFFFB95E),
          ],
        ),
        borderRadius: BorderRadius.circular(23),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFB95E).withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: const Row(
        children: [
          Text('🌱', style: TextStyle(fontSize: 42)),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pahlawan Bumi!',
                  style: TextStyle(
                    color: Color(0xFF70451B),
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Belajar hari ini, selamatkan bumi esok hari.',
                  style: TextStyle(
                    color: Color(0xFF70451B),
                    fontSize: 12,
                    height: 1.4,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Text('💚', style: TextStyle(fontSize: 28)),
        ],
      ),
    );
  }

  // DEKORASI LINGKARAN LATAR BELAKANG
  Widget _bubble(double size, Color color) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
  }

// MODEL DATA MATERI
class _Lesson {
  final String title;
  final String subtitle;
  final String description;
  final String emoji;
  final Color color;
  final Color lightColor;
  final String tag;
  final String heading;
  final String content;
  final List<String> examples;
  final String fact;
  final String tip;

  const _Lesson({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.emoji,
    required this.color,
    required this.lightColor,
    required this.tag,
    required this.heading,
    required this.content,
    required this.examples,
    required this.fact,
    required this.tip,
  });
}

// HALAMAN DETAIL PEMBELAJARAN
class _LessonDetailScreen extends StatefulWidget {
  final List<_Lesson> lessons;
  final int initialIndex;
  final List<int> completedLessons;

  const _LessonDetailScreen({
    required this.lessons,
    required this.initialIndex,
    required this.completedLessons,
  });

  @override
  State<_LessonDetailScreen> createState() =>
      _LessonDetailScreenState();
}

class _LessonDetailScreenState extends State<_LessonDetailScreen>
    with SingleTickerProviderStateMixin {
  late int _index;
  late AnimationController _animationController;
  late final Set<int> _completed;

  @override
  void initState() {
    super.initState();

    AudioManager.instance.playBgm(BgmTrack.belajar);
    _index = widget.initialIndex;
    _completed = widget.completedLessons.toSet();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Kembali ke daftar materi sambil mengirim progres.
  void _finishAndReturn() {
    AudioManager.instance.playSfx(SfxTrack.buttonMenu);
    Navigator.pop(context, _completed.toList());
  }

  // Membuka materi berikutnya.
  void _next() {
    AudioManager.instance.playSfx(SfxTrack.buttonMenu);
    _completed.add(_index);

    if (_index < widget.lessons.length - 1) {
      setState(() {
        _index++;
      });
    } else {
      AudioManager.instance.playSfx(SfxTrack.sparkle);
      _finishAndReturn();
    }
  }

  @override
  Widget build(BuildContext context) {
    final lesson = widget.lessons[_index];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F8FF),
        elevation: 0,
        leading: IconButton(
          onPressed: _finishAndReturn,
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Color(0xFF31558D),
          ),
        ),
        title: Text(
          'MATERI ${_index + 1} DARI ${widget.lessons.length}',
          style: const TextStyle(
            color: Color(0xFF263B66),
            fontWeight: FontWeight.w900,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // KONTEN DETAIL MATERI
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  20,
                  12,
                  20,
                  20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ILUSTRASI UTAMA MATERI
                    Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            lesson.color,
                            lesson.color.withValues(alpha: 0.72),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Column(
                        children: [
                          // Emoji ini dapat diganti Image.asset().
                          AnimatedBuilder(
                            animation: _animationController,
                            builder: (context, child) {
                              return Transform.translate(
                                offset: Offset(
                                  0,
                                  math.sin(
                                        _animationController.value *
                                            math.pi *
                                            2,
                                      ) *
                                      9,
                                ),
                                child: child,
                              );
                            },
                            child: Text(
                              lesson.emoji,
                              style: const TextStyle(fontSize: 100),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            lesson.heading,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 24,
                              height: 1.2,
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // PENJELASAN MATERI
                    _infoCard(
                      icon: Icons.menu_book_rounded,
                      title: 'Yuk, kita pelajari!',
                      color: lesson.color,
                      
child: Text(
  lesson.content,
  style: GoogleFonts.nunito(
    fontSize: 15,
    height: 1.7,
    fontWeight: FontWeight.w600,
    color: const Color(0xFF46536B),
  ),
),

                    ),

                    const SizedBox(height: 14),

                    // CONTOH SAMPAH
                    _infoCard(
                      icon: Icons.lightbulb_rounded,
                      title: 'Contoh di sekitar kita',
                      color: const Color(0xFFEAA000),
                      child: Column(
                        children: lesson.examples
                            .map(
                              (example) => Container(
                                width: double.infinity,
                                margin: const EdgeInsets.only(
                                  bottom: 8,
                                ),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF5F8FF),
                                  borderRadius:
                                      BorderRadius.circular(14),
                                ),
                                child: Text(
                                  example,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF35415B),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // FAKTA MENARIK
                    _infoCard(
                      icon: Icons.auto_awesome_rounded,
                      title: 'Tahukah kamu?',
                      color: const Color(0xFF8B68DB),
                      child: Text(
                        lesson.fact,
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.6,
                          color: Color(0xFF46536B),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // MISI KECIL
                    Container(
                      padding: const EdgeInsets.all(17),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE1F9E9),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: const Color(0xFFB8EBC9),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '💚',
                            style: TextStyle(fontSize: 29),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Misi kecilmu!',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 16,
                                    color: Color(0xFF21874A),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  lesson.tip,
                                  style: const TextStyle(
                                    height: 1.5,
                                    fontSize: 14,
                                    color: Color(0xFF32644A),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // TOMBOL NAVIGASI AKAN DILANJUTKAN DI BAGIAN 4
                        // TOMBOL NAVIGASI MATERI
            Container(
              padding: const EdgeInsets.fromLTRB(
                20,
                12,
                20,
                18,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x10000000),
                    blurRadius: 12,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  if (_index > 0) ...[
                    OutlinedButton(
                      onPressed: () {
                        AudioManager.instance.playSfx(SfxTrack.buttonMenu);
                        setState(() {
                          _index--;
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF31558D),
                        side: const BorderSide(
                          color: Color(0xFFD5DFF2),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 12,
                        ),
                        shape: const StadiumBorder(),
                      ),
                      child: const Text('Sebelumnya'),
                    ),
                    const SizedBox(width: 10),
                  ],
                  Expanded(
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: lesson.color,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                        shape: const StadiumBorder(),
                      ),
                      onPressed: _next,
                      child: Text(
                        _index == widget.lessons.length - 1
                            ? 'Selesaikan 🎉'
                            : 'Materi Selanjutnya ➜',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // KOMPONEN KARTU INFORMASI
  Widget _infoCard({
    required IconData icon,
    required String title,
    required Color color,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(23),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: color,
                size: 23,
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF263B66),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          child,
        ],
      ),
    );
  }
}