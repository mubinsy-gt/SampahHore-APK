
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KelasPenjagaBumiScreen extends StatefulWidget {
  const KelasPenjagaBumiScreen({super.key});

  @override
  State<KelasPenjagaBumiScreen> createState() =>
      _KelasPenjagaBumiScreenState();
}

class _KelasPenjagaBumiScreenState
    extends State<KelasPenjagaBumiScreen> {
  final Color green = const Color(0xFF35A853);
  final Color darkGreen = const Color(0xFF245D34);

  final List<Map<String, dynamic>> missions = [
    {
      'title': 'Taman Bersih',
      'subtitle': 'Jaga taman agar bebas sampah!',
      'icon': Icons.cleaning_services_rounded,
      'color': Color(0xFF65BE45),
      'light': Color(0xFFE5F8D7),
      'factTitle': 'Ayo Bersihkan Taman!',
      'fact':
          'Sampah yang berserakan bisa membuat taman kotor '
          'dan mengganggu hewan serta tumbuhan.',
      'action': 'Aku akan membuang sampah pada tempatnya.',
      'emoji': '🧹',
    },
    {
      'title': 'Sahabat Tanaman',
      'subtitle': 'Rawat tanaman di sekitar kita!',
      'icon': Icons.local_florist_rounded,
      'color': Color(0xFF299CE0),
      'light': Color(0xFFDDF3FF),
      'factTitle': 'Sayangi Tanaman!',
      'fact':
          'Tanaman membutuhkan air, sinar matahari, dan '
          'perawatan agar bisa tumbuh dengan baik.',
      'action': 'Aku akan ikut merawat tanaman.',
      'emoji': '🌱',
    },
    {
      'title': 'Hemat Sumber Daya',
      'subtitle': 'Gunakan air dan listrik secukupnya!',
      'icon': Icons.water_drop_rounded,
      'color': Color(0xFFEF9B35),
      'light': Color(0xFFFFEACD),
      'factTitle': 'Ayo Hidup Hemat!',
      'fact':
          'Mematikan keran setelah digunakan dan mematikan '
          'lampu saat tidak diperlukan membantu menghemat sumber daya.',
      'action': 'Aku akan menghemat air dan listrik.',
      'emoji': '💧',
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
    final saved = prefs.getStringList('kelas_penjaga_bumi_selesai') ?? [];
    final completedMissions = saved
    .map((value) => int.tryParse(value))
    .whereType<int>()
    .where((value) => value >= 0 && value < missions.length)
    .toSet();

if (completedMissions.length == missions.length) {
  await prefs.setBool('badge_penjaga_bumi', true);
}
    if (!mounted) return;

    setState(() {
      completed.addAll(completedMissions);
      loading = false;
    });
  }

  Future<void> _completeMission(int index) async {
    if (completed.contains(index)) return;

    setState(() {
      completed.add(index);
    });

    final prefs = await SharedPreferences.getInstance();

    await prefs.setStringList(
      'kelas_penjaga_bumi_selesai',
      completed.map((value) => value.toString()).toList(),
    );

    if (completed.length == missions.length) {
      await prefs.setBool('badge_penjaga_bumi', true);
    }
  }

  void _openMission(int index) {
    final mission = missions[index];
    final alreadyDone = completed.contains(index);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) => Container(
        padding: const EdgeInsets.fromLTRB(24, 14, 24, 28),
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
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 22),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: mission['light'] as Color,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  mission['emoji'] as String,
                  style: const TextStyle(fontSize: 54),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                mission['factTitle'] as String,
                textAlign: TextAlign.center,
                style: GoogleFonts.fredoka(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  color: darkGreen,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                mission['fact'] as String,
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  height: 1.5,
                  color: const Color(0xFF4F6251),
                ),
              ),
              const SizedBox(height: 18),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: mission['light'] as Color,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  children: [
                    const Text(
                      '🌟 JANJI PENJAGA BUMI',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      mission['action'] as String,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(sheetContext);
                    await _completeMission(index);

                    if (!mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          completed.length == missions.length
                              ? '🏅 Hebat! Lencana Penjaga Bumi berhasil didapat!'
                              : '🌱 Misi selesai! Ayo lanjutkan misi lainnya!',
                        ),
                        backgroundColor: darkGreen,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: alreadyDone
                        ? Colors.grey
                        : green,
                    foregroundColor: Colors.white,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: Text(
                    alreadyDone ? 'Misi Sudah Selesai ✓' : 'Misi Selesai!',
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
    final progress = completed.length / missions.length;
    final allDone = completed.length == missions.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F9E9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0F9E9),
        foregroundColor: darkGreen,
        elevation: 0,
        title: Text(
          'Kelas Penjaga Bumi',
          style: GoogleFonts.fredoka(
            fontSize: 22,
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
                          Color(0xFF65BE45),
                          Color(0xFF299B58),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('🌍🌳🌱',
                            style: TextStyle(fontSize: 38)),
                        const SizedBox(height: 10),
                        Text(
                          'Halo, Penjaga Bumi!',
                          style: GoogleFonts.fredoka(
                            fontSize: 26,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Jelajahi semua misi dan lakukan '
                          'hal kecil untuk menjaga bumi kita!',
                          style: GoogleFonts.nunito(
                            fontSize: 15,
                            color: Colors.white,
                            height: 1.4,
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
                              '${completed.length}/${missions.length}',
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
                          'Misi telah diselesaikan',
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
                    'Pilih Misi Petualangan',
                    style: GoogleFonts.fredoka(
                      fontSize: 23,
                      fontWeight: FontWeight.w600,
                      color: darkGreen,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Ketuk setiap misi untuk menemukan hal baru.',
                    style: GoogleFonts.nunito(
                      fontSize: 14,
                      color: const Color(0xFF617461),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...List.generate(missions.length, (index) {
                    final mission = missions[index];
                    final done = completed.contains(index);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Material(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        child: InkWell(
                          onTap: () => _openMission(index),
                          borderRadius: BorderRadius.circular(22),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(22),
                              border: Border.all(
                                color: done
                                    ? mission['color'] as Color
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
                                    color: mission['light'] as Color,
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: Icon(
                                    mission['icon'] as IconData,
                                    color: mission['color'] as Color,
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
                                        mission['title'] as String,
                                        style: GoogleFonts.fredoka(
                                          fontSize: 19,
                                          fontWeight: FontWeight.w600,
                                          color: darkGreen,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        mission['subtitle'] as String,
                                        style: GoogleFonts.nunito(
                                          fontSize: 13,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        done ? 'SELESAI ✓' : 'JELAJAHI →',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11,
                                          color: mission['color'] as Color,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (done)
                                  Icon(
                                    Icons.check_circle_rounded,
                                    color: mission['color'] as Color,
                                    size: 27,
                                  )
                                else
                                  const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 17,
                                    color: Colors.black38,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 8),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
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
                          allDone ? '🏅' : '🎖️',
                          style: const TextStyle(fontSize: 48),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          allDone
                              ? 'Penjaga Bumi Hebat!'
                              : 'Lencana Penjaga Bumi',
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
                              ? 'Kamu sudah menyelesaikan semua misi. '
                                  'Terus jaga bumi setiap hari!'
                              : 'Selesaikan ketiga misi untuk '
                                  'mendapatkan lencana spesial ini.',
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
