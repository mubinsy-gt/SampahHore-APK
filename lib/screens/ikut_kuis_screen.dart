
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/audio_manager.dart';

const Color green = Color(0xFF27AE60);
const Color blue = Color(0xFF4385F5);
const Color yellow = Color(0xFFFFC928);
const Color orange = Color(0xFFFF914D);
const Color pink = Color(0xFFFF6FAE);
const Color purple = Color(0xFF9270E8);
const Color darkText = Color(0xFF29415F);

class QuizQuestion {
  final String question;
  final List<String> options;
  final int answer;
  final String explanation;
  final IconData icon;

  const QuizQuestion({
    required this.question,
    required this.options,
    required this.answer,
    required this.explanation,
    required this.icon,
  });
}

const List<List<QuizQuestion>> quizLevels = [
  // LEVEL 1: MUDAH
  [
    QuizQuestion(
      question: 'Apa yang dimaksud dengan sampah?',
      options: [
        'Benda yang sudah tidak digunakan',
        'Semua benda yang masih dipakai',
        'Makanan yang baru dimasak',
        'Barang baru dari toko',
      ],
      answer: 0,
      explanation:
          'Sampah adalah sisa kegiatan atau benda yang sudah tidak digunakan dan perlu dikelola dengan baik.',
      icon: Icons.delete_outline_rounded,
    ),
    QuizQuestion(
      question: 'Di mana kita sebaiknya membuang sampah?',
      options: [
        'Di sungai',
        'Di tempat sampah',
        'Di jalan',
        'Di halaman tetangga',
      ],
      answer: 1,
      explanation:
          'Buanglah sampah pada tempat yang sesuai agar lingkungan tetap bersih.',
      icon: Icons.delete_rounded,
    ),
    QuizQuestion(
      question: 'Apa yang harus dilakukan setelah makan permen?',
      options: [
        'Membuang bungkus ke jalan',
        'Menyelipkan bungkus di meja',
        'Membuang bungkus ke tempat sampah',
        'Meninggalkannya di taman',
      ],
      answer: 2,
      explanation:
          'Bungkus permen harus dibuang ke tempat sampah, bukan ditinggalkan sembarangan.',
      icon: Icons.emoji_food_beverage_rounded,
    ),
    QuizQuestion(
      question: 'Manakah contoh sampah berupa sisa makanan?',
      options: [
        'Batu bersih',
        'Pensil baru',
        'Buku yang masih dipakai',
        'Kulit pisang',
      ],
      answer: 3,
      explanation:
          'Kulit pisang merupakan sisa bahan organik yang dapat dikelola menjadi kompos.',
      icon: Icons.eco_rounded,
    ),
    QuizQuestion(
      question: 'Apa yang membuat lingkungan terlihat bersih?',
      options: [
        'Sampah berserakan',
        'Sampah dibuang dengan benar',
        'Sampah menumpuk di selokan',
        'Sampah dilempar ke sungai',
      ],
      answer: 1,
      explanation:
          'Membuang dan mengelola sampah dengan benar membantu menjaga kebersihan lingkungan.',
      icon: Icons.cleaning_services_rounded,
    ),
    QuizQuestion(
      question: 'Saat melihat sampah di meja setelah makan, kita sebaiknya...',
      options: [
        'Membiarkannya',
        'Mendorongnya ke lantai',
        'Membersihkannya dan membuangnya dengan benar',
        'Menyembunyikannya',
      ],
      answer: 2,
      explanation:
          'Membersihkan sisa sampah setelah makan adalah kebiasaan baik.',
      icon: Icons.restaurant_rounded,
    ),
    QuizQuestion(
      question: 'Sampah yang menumpuk sebaiknya...',
      options: [
        'Dibiarkan terus',
        'Ditutup dengan kertas',
        'Dipindahkan ke sungai',
        'Dikelola dengan tepat',
      ],
      answer: 3,
      explanation:
          'Sampah perlu dikelola agar tidak mengganggu kebersihan dan kesehatan.',
      icon: Icons.recycling_rounded,
    ),
    QuizQuestion(
      question: 'Siapa yang bertanggung jawab menjaga kebersihan?',
      options: [
        'Semua orang',
        'Petugas kebersihan saja',
        'Guru saja',
        'Orang tua saja',
      ],
      answer: 0,
      explanation:
          'Semua orang dapat ikut menjaga kebersihan, termasuk anak-anak.',
      icon: Icons.people_alt_rounded,
    ),
    QuizQuestion(
      question: 'Apa yang sebaiknya dilakukan terhadap botol minum yang masih bisa dipakai?',
      options: [
        'Langsung dibuang',
        'Digunakan kembali',
        'Dilempar ke jalan',
        'Ditinggalkan di taman',
      ],
      answer: 1,
      explanation:
          'Menggunakan kembali barang yang masih layak dapat membantu mengurangi sampah.',
      icon: Icons.local_drink_rounded,
    ),
    QuizQuestion(
      question: 'Apa julukan yang cocok untuk anak yang rajin menjaga kebersihan?',
      options: [
        'Raja Sampah',
        'Pembuang Sampah',
        'Penjaga Bumi',
        'Pengotor Lingkungan',
      ],
      answer: 2,
      explanation:
          'Penjaga Bumi adalah anak yang peduli terhadap kebersihan dan lingkungan.',
      icon: Icons.public_rounded,
    ),
  ],

  // LEVEL 2: SEDANG
  [
    QuizQuestion(
      question: 'Mengapa sampah tidak boleh dibuang ke sungai?',
      options: [
        'Agar sungai penuh sampah',
        'Agar air berubah warna',
        'Agar ikan sulit berenang',
        'Karena dapat mencemari air dan menyumbat aliran',
      ],
      answer: 3,
      explanation:
          'Sampah di sungai dapat mencemari air dan menghambat aliran air.',
      icon: Icons.water_rounded,
    ),
    QuizQuestion(
      question: 'Apa manfaat memilah sampah?',
      options: [
        'Memudahkan sampah dikelola sesuai jenisnya',
        'Membuat semua sampah tercampur',
        'Menambah sampah di jalan',
        'Membuat lingkungan kotor',
      ],
      answer: 0,
      explanation:
          'Pemilahan membantu menentukan cara pengelolaan yang sesuai untuk setiap jenis sampah.',
      icon: Icons.category_rounded,
    ),
    QuizQuestion(
      question: 'Kulit buah dan sisa sayuran umumnya termasuk sampah...',
      options: [
        'Logam',
        'Organik',
        'Kaca',
        'Elektronik',
      ],
      answer: 1,
      explanation:
          'Sisa buah dan sayuran merupakan sampah organik yang berasal dari makhluk hidup.',
      icon: Icons.eco_rounded,
    ),
    QuizQuestion(
      question: 'Botol plastik yang masih layak sebaiknya...',
      options: [
        'Dibuang ke sungai',
        'Dibakar sembarangan',
        'Digunakan kembali atau disalurkan untuk didaur ulang',
        'Ditinggalkan di taman',
      ],
      answer: 2,
      explanation:
          'Botol yang masih layak dapat digunakan kembali, atau dipilah untuk proses daur ulang.',
      icon: Icons.recycling_rounded,
    ),
    QuizQuestion(
      question: 'Apa dampak sampah yang menyumbat saluran air?',
      options: [
        'Air selalu lebih bersih',
        'Taman menjadi lebih luas',
        'Udara menjadi lebih sejuk',
        'Air dapat meluap dan menyebabkan banjir',
      ],
      answer: 3,
      explanation:
          'Saluran yang tersumbat sampah dapat menghambat aliran air dan meningkatkan risiko banjir.',
      icon: Icons.water_damage_rounded,
    ),
    QuizQuestion(
      question: 'Mengapa kita sebaiknya membawa botol minum sendiri?',
      options: [
        'Mengurangi penggunaan botol sekali pakai',
        'Agar dapat membeli lebih banyak botol',
        'Supaya botol bisa ditinggalkan',
        'Agar sampah bertambah',
      ],
      answer: 0,
      explanation:
          'Botol minum yang digunakan berulang kali dapat mengurangi kebutuhan botol sekali pakai.',
      icon: Icons.local_drink_rounded,
    ),
    QuizQuestion(
      question: 'Apa yang bisa terjadi jika sampah menumpuk dan tidak dikelola?',
      options: [
        'Lingkungan selalu harum',
        'Muncul bau tidak sedap dan mengundang hama',
        'Air sungai selalu jernih',
        'Tanaman pasti tumbuh subur',
      ],
      answer: 1,
      explanation:
          'Tumpukan sampah dapat menimbulkan bau dan menjadi tempat berkembangnya hama.',
      icon: Icons.warning_amber_rounded,
    ),
    QuizQuestion(
      question: 'Manakah contoh mengurangi sampah plastik?',
      options: [
        'Memakai banyak kantong sekali pakai',
        'Membuang botol ke selokan',
        'Membawa tas belanja yang dapat digunakan kembali',
        'Membeli barang berbungkus berlebihan',
      ],
      answer: 2,
      explanation:
          'Tas belanja pakai ulang membantu mengurangi penggunaan kantong plastik sekali pakai.',
      icon: Icons.shopping_bag_rounded,
    ),
    QuizQuestion(
      question: 'Mengapa sampah perlu dikelola dengan benar?',
      options: [
        'Agar sampah semakin menumpuk',
        'Agar semua sampah masuk ke sungai',
        'Agar lingkungan tidak terawat',
        'Untuk menjaga kebersihan dan mengurangi dampak buruknya',
      ],
      answer: 3,
      explanation:
          'Pengelolaan yang tepat membantu menjaga lingkungan dan mengurangi dampak sampah.',
      icon: Icons.health_and_safety_rounded,
    ),
    QuizQuestion(
      question: 'Apa yang sebaiknya dilakukan terhadap kertas bekas yang masih dapat didaur ulang?',
      options: [
        'Dipilah untuk didaur ulang',
        'Dibuang ke sungai',
        'Ditinggalkan di jalan',
        'Dicampur dengan sisa makanan',
      ],
      answer: 0,
      explanation:
          'Kertas bekas yang sesuai dapat dikumpulkan dan disalurkan untuk didaur ulang.',
      icon: Icons.description_rounded,
    ),
  ],

  // LEVEL 3: SULIT
  [
    QuizQuestion(
      question: 'Kamu melihat teman membuang bungkus makanan ke halaman. Apa tindakan terbaik?',
      options: [
        'Ikut membuang sampah',
        'Mengingatkan dengan sopan dan mengajak membuangnya dengan benar',
        'Membiarkannya selalu',
        'Melempar sampah itu ke halaman lain',
      ],
      answer: 1,
      explanation:
          'Mengingatkan dengan sopan dapat membantu teman membiasakan diri menjaga kebersihan.',
      icon: Icons.diversity_3_rounded,
    ),
    QuizQuestion(
      question: 'Setelah piknik, ada banyak sampah tertinggal. Apa yang sebaiknya dilakukan?',
      options: [
        'Meninggalkannya untuk orang lain',
        'Mendorongnya ke semak-semak',
        'Mengumpulkan dan memilah sampah sebelum pulang',
        'Membuangnya ke sungai',
      ],
      answer: 2,
      explanation:
          'Mengumpulkan dan memilah sampah setelah piknik membantu menjaga tempat tetap bersih.',
      icon: Icons.park_rounded,
    ),
    QuizQuestion(
      question: 'Tempat sampah di kelas sudah penuh. Apa langkah yang tepat?',
      options: [
        'Menumpuk sampah di lantai',
        'Mendorong sampah hingga berserakan',
        'Menyelipkan sampah di bawah meja',
        'Memberi tahu guru dan mengikuti cara pembuangan yang tersedia',
      ],
      answer: 3,
      explanation:
          'Beri tahu guru agar sampah ditangani dengan aman dan sesuai fasilitas yang tersedia.',
      icon: Icons.school_rounded,
    ),
    QuizQuestion(
      question: 'Kamu ingin mengurangi sampah saat membawa bekal. Pilihan terbaik adalah...',
      options: [
        'Menggunakan wadah makan dan botol minum pakai ulang',
        'Membungkus semua makanan dengan banyak plastik',
        'Membuang bungkus bekal di jalan',
        'Meninggalkan wadah makan di sekolah',
      ],
      answer: 0,
      explanation:
          'Wadah dan botol pakai ulang mengurangi kebutuhan kemasan sekali pakai.',
      icon: Icons.lunch_dining_rounded,
    ),
    QuizQuestion(
      question: 'Kamu menemukan kulit pisang dan botol plastik. Bagaimana cara memilahnya?',
      options: [
        'Mencampur semuanya dengan sampah lain',
        'Memisahkan sisa organik dari botol plastik',
        'Membuang keduanya ke sungai',
        'Meninggalkannya di taman',
      ],
      answer: 1,
      explanation:
          'Kulit pisang termasuk sampah organik, sedangkan botol plastik perlu dipilah sesuai fasilitas setempat.',
      icon: Icons.recycling_rounded,
    ),
    QuizQuestion(
      question: 'Selokan dekat rumah dipenuhi sampah. Apa yang paling tepat dilakukan anak?',
      options: [
        'Masuk ke selokan untuk membersihkannya sendiri',
        'Mendorong sampah ke saluran yang lebih jauh',
        'Memberi tahu orang dewasa dan tidak membersihkannya sendiri jika berbahaya',
        'Menambah sampah agar terlihat penuh',
      ],
      answer: 2,
      explanation:
          'Selokan bisa berbahaya. Mintalah bantuan orang dewasa untuk menanganinya dengan aman.',
      icon: Icons.health_and_safety_rounded,
    ),
    QuizQuestion(
      question: 'Kantin sekolah menggunakan banyak gelas sekali pakai. Ide yang baik untuk mengurangi sampah adalah...',
      options: [
        'Membuang gelas ke halaman',
        'Membakar gelas setiap hari',
        'Menyembunyikan gelas bekas',
        'Mengajak warga sekolah membawa wadah atau gelas pakai ulang',
      ],
      answer: 3,
      explanation:
          'Wadah pakai ulang dapat mengurangi jumlah gelas sekali pakai yang menjadi sampah.',
      icon: Icons.local_cafe_rounded,
    ),
    QuizQuestion(
      question: 'Mengapa membakar sampah plastik sembarangan bukan solusi yang baik?',
      options: [
        'Asapnya dapat mencemari udara dan membahayakan kesehatan',
        'Karena membuat plastik berubah menjadi makanan',
        'Karena membuat sampah hilang tanpa dampak',
        'Karena selalu membuat udara lebih bersih',
      ],
      answer: 0,
      explanation:
          'Pembakaran plastik sembarangan dapat menghasilkan asap dan zat berbahaya.',
      icon: Icons.air_rounded,
    ),
    QuizQuestion(
      question: 'Kamu melihat kertas bekas yang masih memiliki sisi kosong. Apa yang bisa dilakukan?',
      options: [
        'Langsung membuang semua kertas',
        'Memakai sisi kosongnya untuk menulis atau menggambar',
        'Membuangnya ke sungai',
        'Menyobeknya lalu menyebarkannya',
      ],
      answer: 1,
      explanation:
          'Menggunakan kembali sisi kertas yang kosong dapat mengurangi pemakaian kertas baru.',
      icon: Icons.draw_rounded,
    ),
    QuizQuestion(
      question: 'Temanmu ingin membuang sampah sembarangan karena tidak ada tempat sampah di dekatnya. Apa saran terbaik?',
      options: [
        'Buang saja di tempat itu',
        'Sembunyikan di balik pohon',
        'Simpan sementara sampai menemukan tempat sampah yang sesuai',
        'Lempar ke selokan',
      ],
      answer: 2,
      explanation:
          'Jika tempat sampah belum tersedia, simpan sampah sementara dan buang saat menemukan tempat yang sesuai.',
      icon: Icons.volunteer_activism_rounded,
    ),
  ],
];

class IkutKuisScreen extends StatefulWidget {
  const IkutKuisScreen({super.key});

  @override
  State<IkutKuisScreen> createState() => _IkutKuisScreenState();
}

class _IkutKuisScreenState extends State<IkutKuisScreen>
    with SingleTickerProviderStateMixin {
  int? selectedLevel;
  int questionIndex = 0;
  int sessionPoints = 0;
  int correctCount = 0;
  int totalPoints = 0;
  bool answered = false;
  bool loadingPoints = true;

  
Future<void> _saveCompletedLevel(int level) async {
  final prefs = await SharedPreferences.getInstance();

  // Simpan level yang selesai (Level 1, 2, atau 3).
  await prefs.setBool(
    'ikut_kuis_level_${level + 1}_selesai',
    true,
  );

  // Periksa apakah ketiga level sudah selesai.
  final allLevelsCompleted = List.generate(
    quizLevels.length,
    (index) => prefs.getBool(
          'ikut_kuis_level_${index + 1}_selesai',
        ) ??
        false,
  ).every((completed) => completed);

  if (allLevelsCompleted) {
    await prefs.setBool('badge_juara_kuis', true);
  }
}

  late final AnimationController _mascotController;
  final Random _random = Random();
  late List<QuizQuestion> questions;

  @override
  void initState() {
    super.initState();
    AudioManager.instance.playBgm(BgmTrack.kuis);
    _mascotController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _loadPoints();
  }

  @override
  void dispose() {
    _mascotController.dispose();
    super.dispose();
  }

  Future<void> _loadPoints() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      totalPoints = prefs.getInt('school_sampah_total_points') ?? 0;
      loadingPoints = false;
    });
  }

  Future<void> _savePoints(int points) async {
    final prefs = await SharedPreferences.getInstance();
    totalPoints += points;
    await prefs.setInt('school_sampah_total_points', totalPoints);
  }

  void _startLevel(int level) {
    AudioManager.instance.playSfx(SfxTrack.buttonMenu);
    // Acak urutan soal untuk setiap sesi.
    questions = List<QuizQuestion>.from(quizLevels[level])
      ..shuffle(_random);

    setState(() {
      selectedLevel = level;
      questionIndex = 0;
      sessionPoints = 0;
      correctCount = 0;
      answered = false;
    });
  }

  Future<void> _chooseAnswer(int index) async {
    if (answered) return;

    final question = questions[questionIndex];
    final isCorrect = index == question.answer;
    final gainedPoints = isCorrect ? 10 : 0;

    AudioManager.instance.playSfx(
    isCorrect ? SfxTrack.correctAnswer : SfxTrack.wrongAnswer,
    );
    setState(() {
      answered = true;
      if (isCorrect) {
        correctCount++;
        sessionPoints += gainedPoints;
      }
    });

    if (isCorrect) {
      await _savePoints(gainedPoints);
      if (!mounted) return;
      setState(() {});
    }

    if (!mounted) return;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => _AnswerFeedbackDialog(
        isCorrect: isCorrect,
        points: gainedPoints,
        explanation: question.explanation,
        onContinue: () => Navigator.of(dialogContext).pop(),
      ),
    );

    if (!mounted) return;
  }

  
void _nextQuestion() {
  if (!answered) return;

  if (questionIndex < questions.length - 1) {
    AudioManager.instance.playSfx(SfxTrack.buttonMenu);

    setState(() {
      questionIndex++;
      answered = false;
    });
  } else {
    _finishLevel();
  }
}


  void _showResult() {
    final level = selectedLevel;
    // selectedLevel disimpan sebelum kembali ke menu level.
    final finishedLevel = _lastFinishedLevel ?? level ?? 0;
    _lastFinishedLevel = null;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => _ResultDialog(
        level: finishedLevel,
        correct: correctCount,
        points: sessionPoints,
        onBack: () {
          Navigator.of(dialogContext).pop();
          setState(() {
            selectedLevel = null;
          });
        },
        onReplay: () {
          Navigator.of(dialogContext).pop();
          _startLevel(finishedLevel);
        },
      ),
    );
  }

  int? _lastFinishedLevel;

  
Future<void> _finishLevel() async {
  final finishedLevel = selectedLevel;

  if (finishedLevel == null) return;

  // Simpan progres level dan periksa lencana.
  await _saveCompletedLevel(finishedLevel);

  if (!mounted) return;

  AudioManager.instance.playSfx(SfxTrack.levelComplete);

  _lastFinishedLevel = finishedLevel;

  setState(() {
    selectedLevel = null;
  });

  _showResult();
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F8FF),
      body: SafeArea(
        child: loadingPoints
            ? const Center(child: CircularProgressIndicator())
            : selectedLevel == null
                ? _buildLevelMenu()
                : _buildQuestionScreen(),
      ),
    );
  }

  Widget _buildLevelMenu() {
    final colors = [green, orange, purple];
    final icons = [
      Icons.eco_rounded,
      Icons.lightbulb_rounded,
      Icons.emoji_events_rounded,
    ];
    final subtitles = [
      'Yuk, kenali sampah!',
      'Ayo pahami lingkungan!',
      'Jadilah Penjaga Bumi!',
    ];

    return Column(
      children: [
        _topBar('IKUT KUIS'),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
            children: [
              AnimatedBuilder(
                animation: _mascotController,
                builder: (context, child) => Transform.translate(
                  offset: Offset(0, -5 * _mascotController.value),
                  child: child,
                ),
                child: const Icon(
                  Icons.public_rounded,
                  color: green,
                  size: 94,
                ),
              ),
              Text(
                'Ayo Uji Pengetahuanmu!',
                textAlign: TextAlign.center,
                style: GoogleFonts.fredoka(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: darkText,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                'Pilih level dan kumpulkan bintang!',
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  fontSize: 15,
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [blue, Color(0xFF6DA8FF)],
                  ),
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: blue.withValues(alpha: 0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.stars_rounded,
                      color: yellow,
                      size: 38,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'TOTAL POIN',
                            style: GoogleFonts.nunito(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            '$totalPoints poin',
                            style: GoogleFonts.fredoka(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.emoji_events_rounded,
                      color: yellow,
                      size: 40,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              for (int i = 0; i < 3; i++) ...[
                _levelCard(
                  level: i,
                  color: colors[i],
                  icon: icons[i],
                  subtitle: subtitles[i],
                ),
                const SizedBox(height: 14),
              ],
              Center(
                child: Text(
                  '10 soal • +10 poin untuk setiap jawaban benar',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                    color: Colors.blueGrey,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _levelCard({
    required int level,
    required Color color,
    required IconData icon,
    required String subtitle,
  }) {
    final titles = ['LEVEL 1 • MUDAH', 'LEVEL 2 • SEDANG', 'LEVEL 3 • SULIT'];

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () => _startLevel(level),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: color.withValues(alpha: 0.45), width: 2),
          ),
          child: Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(icon, color: color, size: 34),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titles[level],
                      style: GoogleFonts.fredoka(
                        color: color,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: GoogleFonts.nunito(
                        color: darkText,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '10 soal • Maks. 100 poin',
                      style: GoogleFonts.nunito(
                        color: Colors.blueGrey,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.play_circle_fill_rounded, color: color, size: 36),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionScreen() {
    final question = questions[questionIndex];
    final colors = [blue, orange, green, purple];

    return Column(
      children: [
        _topBar('LEVEL ${selectedLevel! + 1}'),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'SOAL ${questionIndex + 1} DARI ${questions.length}',
                      style: GoogleFonts.fredoka(
                        color: darkText,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const Icon(Icons.stars_rounded, color: orange, size: 25),
                  const SizedBox(width: 4),
                  Text(
                    '$sessionPoints',
                    style: GoogleFonts.fredoka(
                      fontWeight: FontWeight.bold,
                      color: darkText,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: LinearProgressIndicator(
                  value: (questionIndex + 1) / questions.length,
                  minHeight: 12,
                  backgroundColor: const Color(0xFFDCE7F6),
                  valueColor: const AlwaysStoppedAnimation(blue),
                ),
              ),
              const SizedBox(height: 28),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                child: Container(
                  key: ValueKey(questionIndex),
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6FA7FF), blue],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: blue.withValues(alpha: 0.2),
                        blurRadius: 14,
                        offset: const Offset(0, 7),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(question.icon, size: 70, color: Colors.white),
                      const SizedBox(height: 16),
                      Text(
                        question.question,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.fredoka(
                          fontSize: 21,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              for (int i = 0; i < question.options.length; i++) ...[
                _answerButton(
                  label: question.options[i],
                  index: i,
                  color: colors[i],
                  onTap: () => _chooseAnswer(i),
                ),
                const SizedBox(height: 12),
              ],
              const SizedBox(height: 10),
              if (answered)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _nextQuestion,
                    icon: Icon(
                      questionIndex == questions.length - 1
                          ? Icons.emoji_events_rounded
                          : Icons.arrow_forward_rounded,
                    ),
                    label: Text(
                      questionIndex == questions.length - 1
                          ? 'LIHAT HASIL'
                          : 'LANJUT',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 17),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      textStyle: GoogleFonts.fredoka(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _answerButton({
    required String label,
    required int index,
    required Color color,
    required VoidCallback onTap,
  }) {
    return AnimatedScale(
      scale: answered ? 0.99 : 1,
      duration: const Duration(milliseconds: 160),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: answered ? null : onTap,
          borderRadius: BorderRadius.circular(18),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: color.withValues(alpha: 0.65),
                width: 2,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    String.fromCharCode(65 + index),
                    style: GoogleFonts.fredoka(
                      color: color,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: GoogleFonts.nunito(
                      color: darkText,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
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

  Widget _topBar(String title) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 18, 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [blue, Color(0xFF6DA8FF)]),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
  AudioManager.instance.playSfx(
    SfxTrack.pageTransitionWhoosh,
  );

  if (selectedLevel != null) {
    setState(() => selectedLevel = null);
  } else {
    Navigator.of(context).maybePop();
  }
},
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.fredoka(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Icon(Icons.stars_rounded, color: yellow, size: 30),
        ],
      ),
    );
  }
}

class _AnswerFeedbackDialog extends StatelessWidget {
  final bool isCorrect;
  final int points;
  final String explanation;
  final VoidCallback onContinue;

  const _AnswerFeedbackDialog({
    required this.isCorrect,
    required this.points,
    required this.explanation,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final color = isCorrect ? green : orange;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 26),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.65, end: 1),
        duration: const Duration(milliseconds: 350),
        curve: Curves.elasticOut,
        builder: (context, scale, child) =>
            Transform.scale(scale: scale, child: child),
        child: Container(
          padding: const EdgeInsets.fromLTRB(22, 26, 22, 22),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: color, width: 3),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.5, end: 1),
                duration: const Duration(milliseconds: 500),
                builder: (context, scale, child) =>
                    Transform.scale(scale: scale, child: child),
                child: Icon(
                  isCorrect
                      ? Icons.celebration_rounded
                      : Icons.favorite_rounded,
                  size: 76,
                  color: color,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isCorrect ? 'HEBAT SEKALI!' : 'YUK, COBA LAGI!',
                textAlign: TextAlign.center,
                style: GoogleFonts.fredoka(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 27,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  isCorrect ? '+$points POIN ⭐' : '+0 POIN',
                  style: GoogleFonts.fredoka(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 21,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                isCorrect
                    ? 'Jawabanmu benar! Terus semangat!'
                    : 'Tidak apa-apa, belajar itu menyenangkan!',
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  color: darkText,
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                explanation,
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  color: Colors.blueGrey,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 20),
SizedBox(
  width: double.infinity,
  child: ElevatedButton(
    onPressed: () {
      AudioManager.instance.playSfx(SfxTrack.buttonMenu);
      onContinue();
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: color,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
                  child: Text(
                    'LANJUT!',
                    style: GoogleFonts.fredoka(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
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
}

class _ResultDialog extends StatelessWidget {
  final int level;
  final int correct;
  final int points;
  final VoidCallback onBack;
  final VoidCallback onReplay;

  const _ResultDialog({
    required this.level,
    required this.correct,
    required this.points,
    required this.onBack,
    required this.onReplay,
  });

  @override
  Widget build(BuildContext context) {
    final stars = correct >= 8 ? 3 : correct >= 5 ? 2 : 1;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: yellow, width: 3),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.emoji_events_rounded,
              size: 82,
              color: yellow,
            ),
            Text(
              'KUIS SELESAI!',
              style: GoogleFonts.fredoka(
                color: darkText,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (i) => Icon(
                  Icons.star_rounded,
                  size: 42,
                  color: i < stars ? yellow : Colors.grey.shade300,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '$correct dari 10 jawaban benar',
              style: GoogleFonts.nunito(
                color: darkText,
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '+$points poin diperoleh!',
              style: GoogleFonts.fredoka(
                color: green,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Terus belajar dan jadilah Penjaga Bumi!',
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                color: Colors.blueGrey,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
  AudioManager.instance.playSfx(SfxTrack.buttonMenu);
  onReplay();
},
                icon: const Icon(Icons.replay_rounded),
                label: const Text('MAIN LAGI'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  textStyle: GoogleFonts.fredoka(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
  AudioManager.instance.playSfx(SfxTrack.pageTransitionWhoosh);
  onBack();
},
              child: Text(
                'KEMBALI KE LEVEL',
                style: GoogleFonts.nunito(
                  color: darkText,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
