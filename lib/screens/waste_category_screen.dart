import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';


class WasteCategoryScreen extends StatefulWidget {
  const WasteCategoryScreen({
    super.key,
    this.category = 'Organik',
  });

  final String category;

  @override
  State<WasteCategoryScreen> createState() =>
      _WasteCategoryScreenState();
}

class _WasteCategoryScreenState extends State<WasteCategoryScreen> {
  bool _categorySaved = false;

  String get category => widget.category;

  Future<void> _markCategoryLearned() async {
    if (_categorySaved) return;

    final prefs = await SharedPreferences.getInstance();

    final learned = prefs.getStringList(
          'kategori_sampah_dipelajari',
        ) ??
        <String>[];

    if (!learned.contains(category)) {
      learned.add(category);
    }

    await prefs.setStringList(
      'kategori_sampah_dipelajari',
      learned,
    );

    const requiredCategories = ['Organik', 'Anorganik', 'B3'];

    if (requiredCategories.every(learned.contains)) {
      await prefs.setBool('badge_ahli_pilah', true);
    }

    if (!mounted) return;

    setState(() {
      _categorySaved = true;
    });
  }


  @override
  Widget build(BuildContext context) {
    final isOrganik = category == 'Organik';
    final isAnorganik = category == 'Anorganik';

    final title = isOrganik
        ? 'Sampah Organik'
        : isAnorganik
            ? 'Sampah Anorganik'
            : 'Sampah B3';

    final mainColor = isOrganik
        ? const Color(0xFF35A853)
        : isAnorganik
            ? const Color(0xFF2295E2)
            : const Color(0xFFEF5650);

    final backgroundColor = isOrganik
        ? const Color(0xFFEAF8E3)
        : isAnorganik
            ? const Color(0xFFE7F5FF)
            : const Color(0xFFFFEFED);

    final headingColor = isOrganik
        ? const Color(0xFF245D34)
        : isAnorganik
            ? const Color(0xFF145580)
            : const Color(0xFF8C302B);

    final categoryIcon = isOrganik
        ? Icons.eco_rounded
        : isAnorganik
            ? Icons.recycling_rounded
            : Icons.warning_amber_rounded;

    final description = isOrganik
        ? 'Sampah organik berasal dari makhluk hidup '
            'dan dapat terurai secara alami.'
        : isAnorganik
            ? 'Sampah anorganik seperti plastik, kaca, '
                'dan logam umumnya membutuhkan waktu '
                'lebih lama untuk terurai. Sebagian dapat didaur ulang.'
            : 'Sampah B3 adalah sampah yang mengandung '
                'bahan berbahaya dan beracun sehingga '
                'perlu ditangani secara khusus.';

    final examples = isOrganik
        ? [
            {
              'name': 'Sisa Makanan',
              'description':
                  'Contohnya nasi dan makanan yang tidak habis. '
                  'Sisa makanan tertentu dapat diolah menjadi kompos.',
              'icon': Icons.dinner_dining_rounded,
              'color': const Color(0xFFFFB74D),
            },
            {
              'name': 'Daun Kering',
              'description':
                  'Daun yang jatuh dari pohon dapat dikumpulkan '
                  'dan diolah menjadi kompos.',
              'icon': Icons.eco_rounded,
              'color': const Color(0xFF66BB6A),
            },
            {
              'name': 'Kulit Buah',
              'description':
                  'Contohnya kulit pisang dan kulit jeruk. '
                  'Kulit buah tertentu dapat dijadikan kompos.',
              'icon': Icons.spa_rounded,
              'color': const Color(0xFFFFA726),
            },
            {
              'name': 'Sisa Sayuran',
              'description':
                  'Bagian sayuran yang tidak digunakan, '
                  'seperti batang atau daun yang tidak dimakan.',
              'icon': Icons.grass_rounded,
              'color': const Color(0xFF26A69A),
            },
            {
              'name': 'Cangkang Telur',
              'description':
                  'Cangkang telur yang sudah digunakan dapat '
                  'dikumpulkan untuk bahan kompos.',
              'icon': Icons.egg_alt_rounded,
              'color': const Color(0xFF8DAB68),
            },
            {
              'name': 'Ampas Teh',
              'description':
                  'Ampas teh setelah diseduh termasuk sisa '
                  'organik yang dapat diolah dengan tepat.',
              'icon': Icons.coffee_rounded,
              'color': const Color(0xFF9C7956),
            },
          ]
        : isAnorganik
            ? [
                {
                  'name': 'Botol Plastik',
                  'description':
                      'Botol minuman plastik yang kosong. '
                      'Pisahkan dan bersihkan sebelum disalurkan '
                      'untuk didaur ulang.',
                  'icon': Icons.local_drink_rounded,
                  'color': const Color(0xFF42A5F5),
                },
                {
                  'name': 'Kaleng Minuman',
                  'description':
                      'Kaleng bekas minuman dapat dikumpulkan '
                      'sebagai bahan daur ulang.',
                  'icon': Icons.liquor_rounded,
                  'color': const Color(0xFF78909C),
                },
                {
                  'name': 'Kertas',
                  'description':
                      'Kertas bekas yang bersih dan kering '
                      'dapat dikumpulkan untuk didaur ulang.',
                  'icon': Icons.description_rounded,
                  'color': const Color(0xFF8DAB68),
                },
                {
                  'name': 'Kardus',
                  'description':
                      'Kardus bekas dapat digunakan kembali '
                      'atau disalurkan untuk didaur ulang.',
                  'icon': Icons.inventory_2_rounded,
                  'color': const Color(0xFFB7895B),
                },
                {
                  'name': 'Botol Kaca',
                  'description':
                      'Botol kaca dapat digunakan kembali '
                      'atau didaur ulang. Tangani dengan hati-hati '
                      'agar tidak pecah.',
                  'icon': Icons.wine_bar_rounded,
                  'color': const Color(0xFF26A69A),
                },
                {
                  'name': 'Kemasan Plastik',
                  'description':
                      'Kemasan plastik tertentu dapat didaur '
                      'ulang sesuai jenis bahan dan fasilitas '
                      'daur ulang yang tersedia.',
                  'icon': Icons.shopping_bag_rounded,
                  'color': const Color(0xFF7E7CE8),
                },
              ]
            : [
                {
                  'name': 'Baterai Bekas',
                  'description':
                      'Baterai dapat mengandung bahan berbahaya. '
                      'Jangan dibakar atau dibuang sembarangan. '
                      'Serahkan ke tempat pengumpulan yang sesuai.',
                  'icon': Icons.battery_alert_rounded,
                  'color': const Color(0xFFEF5350),
                },
                {
                  'name': 'Lampu Bekas',
                  'description':
                      'Lampu tertentu, seperti lampu fluoresen, '
                      'dapat mengandung bahan berbahaya. '
                      'Jangan dipecahkan.',
                  'icon': Icons.lightbulb_rounded,
                  'color': const Color(0xFFFFB74D),
                },
                {
                  'name': 'Aerosol',
                  'description':
                      'Kaleng semprot tertentu dapat menyimpan '
                      'tekanan dan sisa bahan kimia. '
                      'Jangan dibakar atau dilubangi.',
                  'icon': Icons.sanitizer_rounded,
                  'color': const Color(0xFF78909C),
                },
                {
                  'name': 'Cat dan Pelarut',
                  'description':
                      'Sisa cat dan pelarut tertentu dapat '
                      'mengandung bahan berbahaya. '
                      'Jangan dibuang ke saluran air.',
                  'icon': Icons.format_paint_rounded,
                  'color': const Color(0xFFAB75CE),
                },
                {
                  'name': 'Obat Kedaluwarsa',
                  'description':
                      'Obat yang sudah tidak digunakan tidak '
                      'boleh dibuang sembarangan. Ikuti petunjuk '
                      'pengembalian atau pembuangan yang aman.',
                  'icon': Icons.medication_rounded,
                  'color': const Color(0xFFEC7295),
                },
                {
                  'name': 'Kemasan Bahan Kimia',
                  'description':
                      'Wadah yang masih mengandung sisa bahan '
                      'kimia berbahaya perlu ditangani sesuai '
                      'petunjuk pada label dan aturan setempat.',
                  'icon': Icons.science_rounded,
                  'color': const Color(0xFFEF5650),
                },
              ];

    final tipTitle = isOrganik
        ? 'Tahukah Kamu?'
        : isAnorganik
            ? 'Ayo Daur Ulang!'
            : 'Ingat, Harus Hati-hati!';

    final tipDescription = isOrganik
        ? 'Sampah organik tertentu bisa diolah menjadi '
            'kompos untuk membantu menyuburkan tanaman.'
        : isAnorganik
            ? 'Sampah anorganik yang bersih dan sesuai jenisnya '
                'dapat digunakan kembali atau didaur ulang.'
            : 'Jangan membakar, membuka, atau mencampur sampah '
                'B3 sembarangan. Minta bantuan orang dewasa '
                'dan gunakan tempat pengumpulan khusus.';

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: mainColor,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER KATEGORI
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      mainColor.withOpacity(0.72),
                      mainColor,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: mainColor.withOpacity(0.20),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      categoryIcon,
                      color: Colors.white,
                      size: 45,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Yuk, Kenali $title!',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Text(
                'Contoh $title',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: headingColor,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Ketuk kotak untuk mengenal lebih dekat!',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF57745C),
                ),
              ),

              const SizedBox(height: 16),

              // KARTU CONTOH SAMPAH
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: examples.length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.83,
                ),
                itemBuilder: (context, index) {
                  final item = examples[index];

                  return _WasteExampleCard(
                    name: item['name'] as String,
                    description: item['description'] as String,
                    icon: item['icon'] as IconData,
                    color: item['color'] as Color,
                    headingColor: headingColor,
                    buttonColor: mainColor,
                    onLearned: _markCategoryLearned,
                  );
                },
              ),

              const SizedBox(height: 20),

              // INFORMASI TAMBAHAN
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: mainColor.withOpacity(0.25),
                    width: 2,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.lightbulb_rounded,
                      color: isOrganik
                          ? const Color(0xFFFFB52E)
                          : mainColor,
                      size: 34,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tipTitle,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                              color: headingColor,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            tipDescription,
                            style: const TextStyle(
                              fontSize: 13,
                              height: 1.5,
                              color: Color(0xFF526A56),
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
    );
  }
}

// KARTU CONTOH SAMPAH
class _WasteExampleCard extends StatelessWidget {
  const _WasteExampleCard({
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.headingColor,
    required this.buttonColor,
    required this.onLearned,
  });

  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final Color headingColor;
  final Color buttonColor;
  final Future<void> Function() onLearned;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          showDialog<void>(
            context: context,
            builder: (dialogContext) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.16),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Icon(
                      icon,
                      size: 65,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: headingColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
              actions: [
                Center(
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: buttonColor,
                    ),
                   onPressed: () async {
  Navigator.pop(dialogContext);
  await onLearned();
},
                    child: const Text('Mengerti!'),
                  ),
                ),
              ],
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.14),
                    borderRadius: BorderRadius.circular(17),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Icon(
                          icon,
                          size: 65,
                          color: color,
                        ),
                      ),
                      const Positioned(
                        right: 6,
                        top: 6,
                        child: Icon(
                          Icons.auto_awesome_rounded,
                          color: Color(0xFFFFC54D),
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  color: headingColor,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Ketuk untuk melihat',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  color: Color(0xFF66816A),
                ),
              ),
              const SizedBox(height: 4),
            ],
          ),
        ),
      ),
    );
  }
}