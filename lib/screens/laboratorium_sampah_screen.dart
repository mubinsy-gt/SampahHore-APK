
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LaboratoriumSampahScreen extends StatefulWidget {
  const LaboratoriumSampahScreen({super.key});

  @override
  State<LaboratoriumSampahScreen> createState() =>
      _LaboratoriumSampahScreenState();
}

class _LaboratoriumSampahScreenState
    extends State<LaboratoriumSampahScreen> {
  static const green = Color(0xFF35A853);
  static const darkGreen = Color(0xFF245D34);

  final Set<String> explored = {};
  bool badgeEarned = false;
  Future<void> _saveExploredProgress() async {
  final prefs = await SharedPreferences.getInstance();

  await prefs.setStringList(
    'laboratorium_sampah_dipelajari',
    explored.toList(),
  );

  if (explored.length == items.length) {
    await prefs.setBool('badge_ilmuwan_sampah', true);

    if (mounted) {
      setState(() {
        badgeEarned = true;
      });
    }
  }
}
  final items = const [
    {
      'id': 'banana',
      'name': 'Kulit Pisang',
      'emoji': '🍌',
      'zone': 'organik',
      'description':
          'Kulit pisang termasuk sampah organik. Dalam kondisi yang sesuai, bahan organik dapat terurai dan diolah menjadi kompos.',
      'fact': 'Sisa makanan dan daun juga bisa dimanfaatkan menjadi kompos!',
      'color': Color(0xFF65BE45),
    },
    {
      'id': 'leaves',
      'name': 'Daun Kering',
      'emoji': '🍂',
      'zone': 'organik',
      'description':
          'Daun kering dapat dikumpulkan bersama bahan organik lainnya untuk proses pengomposan.',
      'fact': 'Daun kering masih bisa memiliki manfaat bagi tanaman.',
      'color': Color(0xFF65BE45),
    },
    {
      'id': 'bottle',
      'name': 'Botol Plastik',
      'emoji': '🧴',
      'zone': 'daur ulang',
      'description':
          'Botol plastik yang sesuai jenis bahannya dapat dikumpulkan, dipilah, lalu dikirim ke fasilitas daur ulang.',
      'fact':
          'Botol perlu dikosongkan dan dipilah sesuai aturan pengumpulan setempat.',
      'color': Color(0xFF2295E2),
    },
    {
      'id': 'can',
      'name': 'Kaleng Minuman',
      'emoji': '🥫',
      'zone': 'daur ulang',
      'description':
          'Kaleng logam dapat memiliki nilai daur ulang dan perlu dikumpulkan melalui jalur yang sesuai.',
      'fact': 'Pemilahan membantu bahan yang masih berguna tidak tercampur.',
      'color': Color(0xFF2295E2),
    },
    {
      'id': 'battery',
      'name': 'Baterai Bekas',
      'emoji': '🔋',
      'zone': 'berbahaya',
      'description':
          'Baterai bekas perlu dipisahkan dari sampah rumah tangga biasa. Simpan dengan aman dan cari layanan pengumpulan limbah khusus.',
      'fact':
          'Jangan membongkar, membakar, atau membuang baterai ke sungai.',
      'color': Color(0xFFEF5650),
    },
    {
      'id': 'bulb',
      'name': 'Lampu Bekas',
      'emoji': '💡',
      'zone': 'berbahaya',
      'description':
          'Jenis lampu tertentu, seperti lampu fluoresen, mungkin mengandung bahan berbahaya. Tangani dengan hati-hati.',
      'fact':
          'Jika lampu pecah, beri tahu orang dewasa dan jangan menyentuh pecahannya dengan tangan kosong.',
      'color': Color(0xFFEF5650),
    },
  ];

  Future<void> openItem(Map<String, dynamic> item) async {
    final itemId = item['id'] as String;

if (!explored.contains(itemId)) {
  setState(() {
    explored.add(itemId);
  });

  await _saveExploredProgress();
}

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        final color = item['color'] as Color;

        return Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(28)),
          ),
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      item['emoji'] as String,
                      style: const TextStyle(fontSize: 55),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    item['name'] as String,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.fredoka(
                      fontSize: 26,
                      color: darkGreen,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    item['description'] as String,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Text(
                      '🌟 Tahukah kamu?\n${item['fact']}',
                      style: GoogleFonts.nunito(
                        fontWeight: FontWeight.w700,
                        color: darkGreen,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(sheetContext),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: Text(
                        'Lanjut Jelajahi!',
                        style: GoogleFonts.nunito(
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    if (!mounted || explored.length != items.length || badgeEarned) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('badge_ilmuwan_sampah', true);

    if (!mounted) return;
    setState(() => badgeEarned = true);

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🏅', style: TextStyle(fontSize: 75)),
            Text(
              'Ilmuwan Sampah!',
              style: GoogleFonts.fredoka(
                fontSize: 25,
                color: darkGreen,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Hebat! Kamu sudah menjelajahi semua benda di laboratorium.',
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(),
            ),
          ],
        ),
        actions: [
          Center(
            child: TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Asyik!'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    loadBadge();
  }

  Future<void> loadBadge() async {
  final prefs = await SharedPreferences.getInstance();

  final savedExplored =
      prefs.getStringList('laboratorium_sampah_dipelajari') ?? [];

  final validIds = items
      .map((item) => item['id'] as String)
      .toSet();

  if (!mounted) return;

  setState(() {
    explored.addAll(
      savedExplored.where((id) => validIds.contains(id)),
    );

    badgeEarned =
        prefs.getBool('badge_ilmuwan_sampah') ?? false;
  });

  if (explored.length == items.length && !badgeEarned) {
    await prefs.setBool('badge_ilmuwan_sampah', true);

    if (!mounted) return;

    setState(() {
      badgeEarned = true;
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F9E9),
      appBar: AppBar(
        backgroundColor: green,
        foregroundColor: Colors.white,
        title: Text(
          'Laboratorium Sampah',
          style: GoogleFonts.fredoka(fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6BCB63), Color(0xFF279B59)],
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  children: [
                    const Text('🌎', style: TextStyle(fontSize: 55)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Halo, Penjelajah!',
                            style: GoogleFonts.fredoka(
                              color: Colors.white,
                              fontSize: 23,
                            ),
                          ),
                          Text(
                            'Ketuk benda di laboratorium untuk mengetahui kisahnya!',
                            style: GoogleFonts.nunito(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Progres Penjelajahan',
                      style: GoogleFonts.fredoka(
                        fontSize: 20,
                        color: darkGreen,
                      ),
                    ),
                  ),
                  Text(
                    '${explored.length}/${items.length}',
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.w800,
                      color: darkGreen,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: LinearProgressIndicator(
                  value: explored.length / items.length,
                  minHeight: 10,
                  backgroundColor: Colors.white,
                  color: green,
                ),
              ),
              const SizedBox(height: 22),
              zone(
                'Mesin Pengurai Organik',
                'Temukan manfaat sisa alami',
                Icons.eco_rounded,
                const Color(0xFF65BE45),
                'organik',
              ),
              const SizedBox(height: 18),
              zone(
                'Pabrik Daur Ulang',
                'Lihat bahan yang bisa diolah kembali',
                Icons.recycling_rounded,
                const Color(0xFF2295E2),
                'daur ulang',
              ),
              const SizedBox(height: 18),
              zone(
                'Zona Sampah Berbahaya',
                'Pelajari cara menanganinya dengan aman',
                Icons.warning_rounded,
                const Color(0xFFEF5650),
                'berbahaya',
              ),
              const SizedBox(height: 22),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Row(
                  children: [
                    Text(
                      badgeEarned ? '🏅' : '🔒',
                      style: const TextStyle(fontSize: 42),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Lencana Ilmuwan Sampah',
                            style: GoogleFonts.fredoka(
                              color: darkGreen,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            badgeEarned
                                ? 'Lencana sudah kamu dapatkan!'
                                : 'Jelajahi semua 6 benda untuk membukanya.',
                            style: GoogleFonts.nunito(fontSize: 13),
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
    );
  }

  Widget zone(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    String zoneName,
  ) {
    final zoneItems = items
        .where((item) => item['zone'] == zoneName)
        .toList();

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(23),
        boxShadow: const [
          BoxShadow(
            color: Color(0x103C713B),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: color, size: 27),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.fredoka(
                        fontSize: 18,
                        color: darkGreen,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: GoogleFonts.nunito(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          GridView.builder(
            itemCount: zoneItems.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.05,
            ),
            itemBuilder: (context, index) {
              final item = zoneItems[index];
              final visited = explored.contains(item['id']);

              return Material(
                color: color.withValues(alpha: 0.09),
                borderRadius: BorderRadius.circular(17),
                child: InkWell(
                  borderRadius: BorderRadius.circular(17),
                  onTap: () => openItem(item),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(17),
                      border: Border.all(
                        color: visited ? color : color.withValues(alpha: 0.2),
                        width: visited ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          item['emoji'] as String,
                          style: const TextStyle(fontSize: 42),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          item['name'] as String,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.nunito(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: darkGreen,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          visited ? '✓ Dipelajari' : 'Ketuk untuk tahu',
                          style: GoogleFonts.nunito(
                            fontSize: 10,
                            color: visited ? color : Colors.black54,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
