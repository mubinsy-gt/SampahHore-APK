
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CeritaSahabatBumiScreen extends StatefulWidget {
  const CeritaSahabatBumiScreen({super.key});

  @override
  State<CeritaSahabatBumiScreen> createState() =>
      _CeritaSahabatBumiScreenState();
}

class _CeritaSahabatBumiScreenState
    extends State<CeritaSahabatBumiScreen> {
  int currentPage = 0;
  bool badgeSaved = false;

  final Color darkGreen = const Color(0xFF245D34);
  Future<void> _loadBadge() async {
  final prefs = await SharedPreferences.getInstance();

  if (!mounted) return;

  setState(() {
    badgeSaved = prefs.getBool('badge_sahabat_bumi') ?? false;
  });
}
  final List<Map<String, dynamic>> stories = [
    {
      'chapter': 'BAGIAN 1',
      'title': 'Taman yang Kotor',
      'emoji': '🌳🧒🗑️',
      'color': Color(0xFFDDF3FF),
      'text':
          'Pada suatu pagi, Bimo pergi bermain ke taman dekat rumahnya. '
          'Namun, ia terkejut melihat bungkus makanan dan botol plastik '
          'berserakan di mana-mana.\n\n'
          '“Aduh, taman kita jadi kotor! Padahal taman ini tempat '
          'bermain yang menyenangkan,” kata Bimo dengan sedih.\n\n'
          'Bimo pun ingin melakukan sesuatu agar taman kembali bersih.',
      'lesson': 'Perubahan dimulai saat kita peduli.',
    },
    {
      'chapter': 'BAGIAN 2',
      'title': 'Aksi Sahabat Bumi',
      'emoji': '🧒👧♻️',
      'color': Color(0xFFE5F8D7),
      'text':
          'Bimo mengajak teman-temannya, Sasa dan Dodi, untuk '
          'membersihkan taman bersama.\n\n'
          'Mereka mengumpulkan sampah dengan hati-hati. Sampah '
          'dimasukkan ke tempat yang sesuai. Mereka juga mengingatkan '
          'pengunjung agar tidak membuang sampah sembarangan.\n\n'
          '“Kalau kita bekerja sama, taman akan lebih cepat bersih!” '
          'seru Sasa. Semua teman tersenyum dan terus membantu.',
      'lesson': 'Kerja sama membuat pekerjaan lebih mudah.',
    },
    {
      'chapter': 'BAGIAN 3',
      'title': 'Taman Kembali Ceria',
      'emoji': '🌻🦋🌈',
      'color': Color(0xFFFFEACD),
      'text':
          'Tidak lama kemudian, taman terlihat bersih dan rapi. '
          'Bunga-bunga tampak indah, udara terasa segar, dan anak-anak '
          'bisa bermain dengan nyaman.\n\n'
          'Bimo dan teman-temannya sangat bangga. Mereka berjanji '
          'akan terus menjaga kebersihan taman setiap hari.\n\n'
          '“Bumi yang sehat adalah tanggung jawab kita bersama!” '
          'kata Bimo dengan gembira.',
      'lesson': 'Kebiasaan kecil bisa membawa perubahan besar.',
    },
  ];

  @override
void initState() {
  super.initState();
  _loadBadge();
}
  Future<void> _finishStory() async {
   final prefs = await SharedPreferences.getInstance();

  await prefs.setBool('badge_sahabat_bumi', true);

  if (!mounted) return;

  setState(() {
    badgeSaved = true;
  });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFFFFFEF5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(26),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            
            
const SizedBox(height: 10),

// Lencana di bagian atas
const Text(
  '🏅',
  style: TextStyle(fontSize: 76),
),

const SizedBox(height: 12),

// Judul ucapan selamat
Text(
  'Hebat Sekali!',
  textAlign: TextAlign.center,
  style: GoogleFonts.fredoka(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: darkGreen,
  ),
),

const SizedBox(height: 10),

// Keterangan di bawah lencana
Text(
  'Kamu sudah menyelesaikan cerita Bimo!',
  textAlign: TextAlign.center,
  style: GoogleFonts.nunito(
    fontSize: 17,
    fontWeight: FontWeight.w800,
    color: darkGreen,
    height: 1.5,
  ),
),

const SizedBox(height: 6),

Text(
  'Sekarang kamu resmi menjadi Sahabat Bumi. '
  'Yuk, praktikkan kebiasaan baik dalam kehidupan sehari-hari!',
  textAlign: TextAlign.center,
  style: GoogleFonts.nunito(
    fontSize: 15,
    height: 1.5,
  ),
),

            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF35A853),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  'Kembali ke Kamus Sampah',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.fredoka(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _nextPage() {
    if (currentPage < stories.length - 1) {
      setState(() {
        currentPage++;
      });
    } else {
      _finishStory();
    }
  }

  void _previousPage() {
    if (currentPage > 0) {
      setState(() {
        currentPage--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final story = stories[currentPage];
    final progress = (currentPage + 1) / stories.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F9E9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0F9E9),
        foregroundColor: darkGreen,
        elevation: 0,
        title: Text(
          'Cerita Sahabat Bumi',
          style: GoogleFonts.fredoka(
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 8, 22, 16),
              child: Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 9,
                        backgroundColor: Colors.white,
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(
                          Color(0xFF53B85C),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${currentPage + 1}/${stories.length}',
                    style: GoogleFonts.fredoka(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: darkGreen,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 0, 22, 16),
                child: Column(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 350),
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: story['color'] as Color,
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: Column(
                        children: [
                          Text(
                            story['chapter'] as String,
                            style: GoogleFonts.nunito(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2,
                              color: darkGreen,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            story['emoji'] as String,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 54),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            story['title'] as String,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.fredoka(
                              fontSize: 27,
                              fontWeight: FontWeight.w600,
                              color: darkGreen,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withValues(alpha: 0.06),
                            blurRadius: 12,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Text(
                        story['text'] as String,
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                          height: 1.75,
                          color: const Color(0xFF3F5143),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF0B8),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('💡', style: TextStyle(fontSize: 25)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Pesan Cerita',
                                  style: GoogleFonts.fredoka(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    color: darkGreen,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  story['lesson'] as String,
                                  style: GoogleFonts.nunito(
                                    fontSize: 14,
                                    height: 1.4,
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
            Container(
              padding: const EdgeInsets.fromLTRB(22, 12, 22, 18),
              decoration: const BoxDecoration(
                color: Color(0xFFFFFEF5),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(26),
                ),
              ),
              child: Row(
                children: [
                  if (currentPage > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _previousPage,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: darkGreen,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          side: BorderSide(color: greenBorder),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          'Kembali',
                          style: GoogleFonts.fredoka(fontSize: 16),
                        ),
                      ),
                    ),
                  if (currentPage > 0) const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF35A853),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        currentPage == stories.length - 1
                            ? 'Selesaikan Cerita 🏅'
                            : 'Lanjut Cerita →',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.fredoka(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
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

  Color get greenBorder => const Color(0xFF9BCB9B);
}
