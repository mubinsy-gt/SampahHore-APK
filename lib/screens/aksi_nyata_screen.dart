
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AksiNyataScreen extends StatefulWidget {
  const AksiNyataScreen({super.key});

  @override
  State<AksiNyataScreen> createState() => _AksiNyataScreenState();
}

class _AksiNyataScreenState extends State<AksiNyataScreen> {
  final Color darkGreen = const Color(0xFF245D34);
  final Color green = const Color(0xFF35A853);

  final List<Map<String, dynamic>> actions = [
    {
      'title': 'Pilah Sampah',
      'subtitle': 'Pisahkan sampah sesuai jenisnya.',
      'icon': Icons.recycling_rounded,
      'emoji': '♻️',
      'color': Color(0xFF65BE45),
      'light': Color(0xFFE5F8D7),
      'description':
          'Ayo biasakan memilah sampah sebelum membuangnya. '
          'Pisahkan sampah organik, anorganik, dan sampah B3 '
          'sesuai tempat atau petunjuk yang tersedia.',
      'steps': [
        'Amati sampah yang akan dibuang.',
        'Kenali jenis sampah tersebut.',
        'Masukkan ke tempat penampungan yang sesuai.',
      ],
    },
    {
      'title': 'Kurangi Sampah',
      'subtitle': 'Bawa botol minum dan kotak makan.',
      'icon': Icons.lunch_dining_rounded,
      'emoji': '🥤',
      'color': Color(0xFF299CE0),
      'light': Color(0xFFDDF3FF),
      'description':
          'Kita bisa mengurangi sampah sekali pakai dengan '
          'membawa botol minum dan kotak makan sendiri saat '
          'pergi ke sekolah atau bepergian.',
      'steps': [
        'Siapkan botol minum yang bisa digunakan kembali.',
        'Bawa kotak makan dari rumah jika memungkinkan.',
        'Gunakan kembali wadah yang masih layak.',
      ],
    },
    {
      'title': 'Bumi Bersih',
      'subtitle': 'Jaga lingkungan tetap bersih dan hijau.',
      'icon': Icons.local_florist_rounded,
      'emoji': '🌱',
      'color': Color(0xFFAA72D8),
      'light': Color(0xFFF0E5FF),
      'description':
          'Lingkungan bersih membuat kita lebih nyaman. '
          'Kamu bisa membantu dengan merapikan area sekitar, '
          'menjaga kebersihan, dan merawat tanaman.',
      'steps': [
        'Pilih area yang aman untuk dirapikan.',
        'Ambil sampah hanya jika aman dilakukan.',
        'Siram tanaman atau bantu merawat taman.',
      ],
    },
  ];

  final Set<int> completed = {};
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

 
Future<void> _loadProgress() async {
  final prefs = await SharedPreferences.getInstance();
  final saved = prefs.getStringList('aksi_nyata_selesai') ?? [];

  final savedCompleted = saved
      .map((value) => int.tryParse(value))
      .whereType<int>()
      .where((value) => value >= 0 && value < actions.length)
      .toSet();

  final allDone = savedCompleted.length == actions.length;

  if (allDone) {
    await prefs.setBool('badge_pahlawan_aksi_nyata', true);
  }

  if (!mounted) return;

  setState(() {
    completed.addAll(savedCompleted);
    loading = false;
  });
}


  
Future<void> _completeAction(int index) async {
  if (completed.contains(index)) return;

  setState(() {
    completed.add(index);
  });

  final prefs = await SharedPreferences.getInstance();

  await prefs.setStringList(
    'aksi_nyata_selesai',
    completed.map((value) => value.toString()).toList(),
  );

  if (completed.length == actions.length) {
    await prefs.setBool('badge_pahlawan_aksi_nyata', true);
  }
}


  void _openAction(int index) {
    final action = actions[index];
    final isDone = completed.contains(index);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(sheetContext).size.height * 0.85,
        ),
        padding: const EdgeInsets.fromLTRB(24, 14, 24, 26),
        decoration: const BoxDecoration(
          color: Color(0xFFFFFEF5),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: action['light'] as Color,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    action['emoji'] as String,
                    style: const TextStyle(fontSize: 52),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  action['title'] as String,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.fredoka(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    color: darkGreen,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  action['description'] as String,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                    fontSize: 15,
                    height: 1.55,
                    color: const Color(0xFF4F6251),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: action['light'] as Color,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Yuk, lakukan langkah ini!',
                        style: GoogleFonts.fredoka(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: darkGreen,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...(action['steps'] as List<String>)
                          .asMap()
                          .entries
                          .map(
                        (entry) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 27,
                                height: 27,
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  '${entry.key + 1}',
                                  style: TextStyle(
                                    color: action['color'] as Color,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  entry.value,
                                  style: GoogleFonts.nunito(
                                    fontSize: 14,
                                    height: 1.4,
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
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: isDone
                        ? null
                        : () async {
                            Navigator.pop(sheetContext);
                            await _completeAction(index);

                            if (!mounted) return;

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  completed.length == actions.length
                                      ? '🏅 Hebat! Semua aksi sudah ditandai selesai!'
                                      : '🌱 Aksi berhasil ditandai selesai!',
                                ),
                                backgroundColor: darkGreen,
                              ),
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: green,
                      disabledBackgroundColor: Colors.grey.shade400,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: Text(
                      isDone
                          ? 'Aksi Sudah Selesai ✓'
                          : 'Aku Sudah Melakukannya!',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.fredoka(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tekan tombol setelah kamu benar-benar mencoba aksi ini.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                    fontSize: 11,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = completed.length / actions.length;
    final allDone = completed.length == actions.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F9E9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0F9E9),
        foregroundColor: darkGreen,
        elevation: 0,
        title: Text(
          'Aksi Nyata',
          style: GoogleFonts.fredoka(
            fontSize: 23,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF53B85C),
                          Color(0xFF299B58),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('🌍💚🌱',
                            style: TextStyle(fontSize: 38)),
                        const SizedBox(height: 10),
                        Text(
                          'Saatnya Beraksi!',
                          style: GoogleFonts.fredoka(
                            fontSize: 27,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Aksi kecilmu bisa membantu menjaga bumi. '
                          'Pilih kegiatan dan coba lakukan di rumah '
                          'atau sekolah!',
                          style: GoogleFonts.nunito(
                            fontSize: 15,
                            height: 1.45,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: LinearProgressIndicator(
                                  value: progress,
                                  minHeight: 11,
                                  backgroundColor: Colors.white38,
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                    Color(0xFFFFD54F),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '${completed.length}/${actions.length}',
                              style: GoogleFonts.fredoka(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Aksi yang sudah dilakukan',
                          style: GoogleFonts.nunito(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Pilih Aksimu',
                    style: GoogleFonts.fredoka(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: darkGreen,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Ketuk kartu untuk melihat panduan aksinya.',
                    style: GoogleFonts.nunito(
                      fontSize: 14,
                      color: const Color(0xFF617461),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...List.generate(actions.length, (index) {
                    final action = actions[index];
                    final done = completed.contains(index);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Material(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        child: InkWell(
                          onTap: () => _openAction(index),
                          borderRadius: BorderRadius.circular(22),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(22),
                              border: Border.all(
                                color: done
                                    ? action['color'] as Color
                                    : Colors.white,
                                width: 2,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 64,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    color: action['light'] as Color,
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: Icon(
                                    action['icon'] as IconData,
                                    color: action['color'] as Color,
                                    size: 34,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        action['title'] as String,
                                        style: GoogleFonts.fredoka(
                                          fontSize: 19,
                                          fontWeight: FontWeight.w600,
                                          color: darkGreen,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        action['subtitle'] as String,
                                        style: GoogleFonts.nunito(
                                          fontSize: 13,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        done ? 'SELESAI ✓' : 'MULAI AKSI →',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11,
                                          color: action['color'] as Color,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  done
                                      ? Icons.check_circle_rounded
                                      : Icons.arrow_forward_ios_rounded,
                                  color: done
                                      ? action['color'] as Color
                                      : Colors.black38,
                                  size: done ? 27 : 17,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: allDone
                          ? const Color(0xFFFFF0B8)
                          : const Color(0xFFDDF3FF),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: allDone
                            ? const Color(0xFFFFC83D)
                            : const Color(0xFF9BD9F7),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          allDone ? '🏅' : '🌟',
                          style: const TextStyle(fontSize: 48),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          allDone
                              ? 'Pahlawan Aksi Nyata!'
                              : 'Lencana Pahlawan Aksi Nyata',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.fredoka(
                            fontSize: 23,
                            color: darkGreen,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          allDone
                              ? 'Hebat! Kamu sudah menandai semua aksi. '
                                  'Terus lakukan kebiasaan baik untuk bumi!'
                              : 'Coba lakukan ketiga aksi untuk '
                                  'mendapatkan lencana spesial.',
                          textAlign: TextAlign.center,
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
    );
  }
}
