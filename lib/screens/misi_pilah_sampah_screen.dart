
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/audio_manager.dart';

class MisiPilahSampahScreen extends StatefulWidget {
  const MisiPilahSampahScreen({super.key});

  @override
  State<MisiPilahSampahScreen> createState() =>
      _MisiPilahSampahScreenState();
}

class _MisiPilahSampahScreenState
    extends State<MisiPilahSampahScreen>
    with TickerProviderStateMixin {
  static const Color green = Color(0xFF35A853);
  static const Color darkGreen = Color(0xFF245D34);
  static const Color background = Color(0xFFF0F9E9);
  static const Color orange = Color(0xFFFFB52E);
  static const Color red = Color(0xFFEF5650);

  static const int totalQuestions = 5;

  static String? _lastFirstQuestionName;

  final Random _random = Random();

  late final AnimationController _floatController;
  late final AnimationController _feedbackController;
  late final AnimationController _shakeController;
  late final AnimationController _resultController;
  late final AnimationController _confettiController;

  List<_WasteQuestion> _questions = [];

  int _currentIndex = 0;
  int _score = 0;
  int? _selectedIndex;

  bool _answered = false;
  bool _finished = false;

  @override
  void initState() {
    super.initState();
    
    AudioManager.instance.playBgm(BgmTrack.misiPilahSampah);


    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    )..repeat(reverse: true);

    _feedbackController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _resultController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    );

    _startGame();
  }

  @override
  void dispose() {
    _floatController.dispose();
    _feedbackController.dispose();
    _shakeController.dispose();
    _resultController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  final List<_WasteQuestion> _allQuestions = const [
    _WasteQuestion(
      name: 'Kulit Pisang',
      description: 'Kulit buah dapat membusuk secara alami '
          'dan dapat diolah menjadi kompos.',
      icon: Icons.spa_rounded,
      color: Color(0xFFFFB52E),
      category: 'Organik',
    ),
    _WasteQuestion(
      name: 'Daun Kering',
      description: 'Daun yang gugur dapat dikumpulkan '
          'untuk membantu membuat kompos.',
      icon: Icons.eco_rounded,
      color: Color(0xFF65BE45),
      category: 'Organik',
    ),
    _WasteQuestion(
      name: 'Sisa Nasi',
      description: 'Sisa makanan termasuk sampah organik '
          'dan dapat diolah dengan cara yang tepat.',
      icon: Icons.dinner_dining_rounded,
      color: Color(0xFFFFA45B),
      category: 'Organik',
    ),
    _WasteQuestion(
      name: 'Cangkang Telur',
      description: 'Cangkang telur termasuk sampah organik '
          'yang dapat dimanfaatkan untuk kompos.',
      icon: Icons.egg_alt_rounded,
      color: Color(0xFF8DAB68),
      category: 'Organik',
    ),
    _WasteQuestion(
      name: 'Botol Plastik',
      description: 'Botol plastik yang sudah kosong dapat '
          'dikumpulkan untuk didaur ulang.',
      icon: Icons.local_drink_rounded,
      color: Color(0xFF42A5F5),
      category: 'Anorganik',
    ),
    _WasteQuestion(
      name: 'Kaleng Minuman',
      description: 'Kaleng logam dapat dikumpulkan '
          'dan didaur ulang.',
      icon: Icons.recycling_rounded,
      color: Color(0xFF78909C),
      category: 'Anorganik',
    ),
    _WasteQuestion(
      name: 'Kardus Bekas',
      description: 'Kardus yang bersih dan kering '
          'dapat dikumpulkan untuk didaur ulang.',
      icon: Icons.inventory_2_rounded,
      color: Color(0xFFB7895B),
      category: 'Anorganik',
    ),
    _WasteQuestion(
      name: 'Kertas Bekas',
      description: 'Kertas yang bersih dapat dikumpulkan '
          'untuk didaur ulang.',
      icon: Icons.description_rounded,
      color: Color(0xFF26A69A),
      category: 'Anorganik',
    ),
    _WasteQuestion(
      name: 'Baterai Bekas',
      description: 'Baterai dapat mengandung bahan berbahaya. '
          'Jangan buang ke tempat sampah biasa; '
          'serahkan ke tempat pengumpulan khusus.',
      icon: Icons.battery_alert_rounded,
      color: Color(0xFFEF5650),
      category: 'B3',
    ),
    _WasteQuestion(
      name: 'Lampu Fluoresen',
      description: 'Lampu jenis tertentu dapat mengandung '
          'bahan berbahaya. Jangan dipecahkan dan '
          'serahkan ke tempat pengumpulan yang sesuai.',
      icon: Icons.lightbulb_rounded,
      color: Color(0xFFFFB74D),
      category: 'B3',
    ),
    _WasteQuestion(
      name: 'Sisa Cat',
      description: 'Cat tertentu dapat mengandung bahan '
          'berbahaya dan perlu dibuang sesuai petunjuk '
          'pengelolaan limbah setempat.',
      icon: Icons.format_paint_rounded,
      color: Color(0xFFAB75CE),
      category: 'B3',
    ),
    _WasteQuestion(
      name: 'Obat Kedaluwarsa',
      description: 'Obat kedaluwarsa perlu ditangani '
          'dengan aman. Jangan membuangnya sembarangan.',
      icon: Icons.medication_rounded,
      color: Color(0xFFEC7295),
      category: 'B3',
    ),
  ];

  final List<_WasteCategory> _categories = const [
    _WasteCategory(
      name: 'Organik',
      subtitle: 'Sisa dari makhluk hidup',
      icon: Icons.eco_rounded,
      color: Color(0xFF65BE45),
      pale: Color(0xFFE5F8D7),
    ),
    _WasteCategory(
      name: 'Anorganik',
      subtitle: 'Sebagian bisa didaur ulang',
      icon: Icons.recycling_rounded,
      color: Color(0xFF2295E2),
      pale: Color(0xFFDDF3FF),
    ),
    _WasteCategory(
      name: 'B3',
      subtitle: 'Perlu penanganan khusus',
      icon: Icons.warning_amber_rounded,
      color: Color(0xFFEF5650),
      pale: Color(0xFFFFE3DF),
    ),
  ];

  _WasteQuestion get _currentQuestion =>
      _questions[_currentIndex];


  void _startGame() {
    final shuffled = List<_WasteQuestion>.from(_allQuestions)
      ..shuffle(_random);

    final selected = shuffled.take(totalQuestions).toList();

    if (_lastFirstQuestionName != null &&
        selected.first.name == _lastFirstQuestionName) {
      final swapIndex = 1 + _random.nextInt(selected.length - 1);
      final first = selected[0];

      selected[0] = selected[swapIndex];
      selected[swapIndex] = first;
    }

    _questions = selected;
    _lastFirstQuestionName = _questions.first.name;

    _currentIndex = 0;
    _score = 0;
    _selectedIndex = null;
    _answered = false;
    _finished = false;

    _feedbackController.reset();
    _shakeController.reset();
    _resultController.reset();
    _confettiController.reset();
  }

  void _checkAnswer(int index) {
    if (_answered || _finished) return;

    final correct =
        _categories[index].name == _currentQuestion.category;
    
    // SFX jawaban benar atau salah
  AudioManager.instance.playSfx(
    correct ? SfxTrack.correctAnswer : SfxTrack.wrongAnswer,
  );
    setState(() {
      _selectedIndex = index;
      _answered = true;

      if (correct) {
        _score++;
      }
    });

    _feedbackController.forward(from: 0);

    if (correct) {
      HapticFeedback.lightImpact();
    } else {
      _shakeController.forward(from: 0);
      HapticFeedback.mediumImpact();
    }

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      builder: (dialogContext) {
        return _AnswerPopup(
          correct: correct,
          question: _currentQuestion,
          onContinue: () {
            Navigator.of(dialogContext).pop();
            _nextQuestion();
          },
          isLastQuestion:
              _currentIndex == _questions.length - 1,
        );
      },
    );
  }

  
Future<void> _nextQuestion() async {
  if (!_answered) return;

  if (_currentIndex == _questions.length - 1) {
    // Berikan lencana jika minimal 4 dari 5 soal benar.
    if (_score >= 4) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('badge_jagoan_pilah', true);
    }

    if (!mounted) return;

    AudioManager.instance.playSfx(SfxTrack.levelComplete);

    setState(() {
      _finished = true;
    });

    _resultController.forward(from: 0);
    _confettiController.forward(from: 0);
    return;
  }

  setState(() {
    _currentIndex++;
    _selectedIndex = null;
    _answered = false;
  });

  _feedbackController.reset();
  _shakeController.reset();
}


  void _restartGame() {
    AudioManager.instance.playSfx(SfxTrack.buttonMenu);
    setState(_startGame);
  }

  void _backToMenu() {
    AudioManager.instance.playSfx(SfxTrack.pageTransitionWhoosh);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: green,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Misi Pilah Sampah',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: SafeArea(
        child: _finished ? _buildResult() : _buildQuestion(),
      ),
    );
  }

  Widget _buildQuestion() {
    final question = _currentQuestion;
    final progress = (_currentIndex + 1) / _questions.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildMissionBanner(),
          const SizedBox(height: 20),
          _buildProgress(progress),
          const SizedBox(height: 20),
          _buildWasteCard(question),
          const SizedBox(height: 22),
          const Text(
            'Ke mana sampah ini harus dibuang?',
            style: TextStyle(
              color: darkGreen,
              fontSize: 19,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Ketuk salah satu tempat sampah!',
            style: TextStyle(
              color: Color(0xFF66816A),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 14),
          ...List.generate(
            _categories.length,
            (index) => _buildCategoryCard(index, question),
          ),
          const SizedBox(height: 22),
          const Center(
            child: Text(
              '🌱 Pilah sampah, selamatkan bumi!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: darkGreen,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMissionBanner() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF79D86A),
            Color(0xFF36AD60),
            Color(0xFF159B68),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: const [
          BoxShadow(
            color: Color(0x2535A853),
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.22),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'MISI PENYELAMAT BUMI',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.7,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Jadi Jagoan\nPilah Sampah!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    height: 1.15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Jawab 5 soal dan kumpulkan bintang!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          AnimatedBuilder(
            animation: _floatController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(
                  0,
                  sin(_floatController.value * pi * 2) * 7,
                ),
                child: child,
              );
            },
            child: SizedBox(
              width: 105,
              height: 112,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 92,
                    height: 92,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const Icon(
                    Icons.public_rounded,
                    color: Colors.white,
                    size: 83,
                  ),
                  const Positioned(
                    right: 1,
                    top: 4,
                    child: Icon(
                      Icons.auto_awesome_rounded,
                      color: Color(0xFFFFE082),
                      size: 27,
                    ),
                  ),
                  const Positioned(
                    left: 0,
                    bottom: 8,
                    child: Icon(
                      Icons.eco_rounded,
                      color: Color(0xFFD7FFB8),
                      size: 28,
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

  Widget _buildProgress(double progress) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SOAL ${_currentIndex + 1} DARI ${_questions.length}',
                style: const TextStyle(
                  color: darkGreen,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.6,
                ),
              ),
              const SizedBox(height: 9),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: progress),
                  duration: const Duration(milliseconds: 450),
                  builder: (context, value, child) {
                    return LinearProgressIndicator(
                      value: value,
                      minHeight: 12,
                      backgroundColor: const Color(0xFFD5E9CB),
                      color: green,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 14),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 13,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: const [
              BoxShadow(
                color: Color(0x10000000),
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(
                Icons.star_rounded,
                color: orange,
                size: 25,
              ),
              const SizedBox(width: 4),
              Text(
                '$_score',
                style: const TextStyle(
                  color: darkGreen,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWasteCard(_WasteQuestion question) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 22, 18, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 14,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'KENALI SAMPAHNYA!',
            style: TextStyle(
              color: Color(0xFF66816A),
              fontSize: 12,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 17),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            transitionBuilder: (child, animation) {
              return ScaleTransition(
                scale: CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutBack,
                ),
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              );
            },
            child: Container(
              key: ValueKey(question.name),
              width: 172,
              height: 160,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    question.color.withOpacity(0.12),
                    question.color.withOpacity(0.28),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(35),
                border: Border.all(
                  color: question.color.withOpacity(0.25),
                  width: 2,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    right: 15,
                    top: 12,
                    child: Icon(
                      Icons.auto_awesome_rounded,
                      color: question.color.withOpacity(0.65),
                      size: 25,
                    ),
                  ),
                  Positioned(
                    left: 14,
                    bottom: 12,
                    child: Icon(
                      Icons.circle,
                      color: question.color.withOpacity(0.16),
                      size: 25,
                    ),
                  ),
                  Icon(
                    question.icon,
                    color: question.color,
                    size: 100,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: Text(
              question.name,
              key: ValueKey('${question.name}_title'),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: darkGreen,
                fontSize: 25,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Pilih kategori yang paling tepat',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF66816A),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(
    int index,
    _WasteQuestion question,
  ) {
    final category = _categories[index];
    final isSelected = _selectedIndex == index;
    final isCorrect = category.name == question.category;

    Color cardColor = Colors.white;
    Color borderColor = category.pale;

    if (_answered && isCorrect) {
      cardColor = const Color(0xFFE4F8E3);
      borderColor = green;
    } else if (_answered && isSelected && !isCorrect) {
      cardColor = const Color(0xFFFFE7E5);
      borderColor = red;
    }

    Widget card = AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      margin: const EdgeInsets.only(bottom: 11),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(21),
        border: Border.all(
          color: borderColor,
          width: _answered && (isCorrect || isSelected) ? 2.5 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: category.color.withOpacity(0.07),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: category.pale,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              category.icon,
              color: category.color,
              size: 31,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.name,
                  style: TextStyle(
                    color: category.color,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  category.subtitle,
                  style: const TextStyle(
                    color: Color(0xFF66816A),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          if (_answered && isCorrect)
            const Icon(
              Icons.check_circle_rounded,
              color: green,
              size: 29,
            )
          else if (_answered && isSelected)
            const Icon(
              Icons.cancel_rounded,
              color: red,
              size: 29,
            )
          else
            Icon(
              Icons.touch_app_rounded,
              color: category.color.withOpacity(0.65),
              size: 25,
            ),
        ],
      ),
    );

    if (_answered && isSelected && !isCorrect) {
      card = AnimatedBuilder(
        animation: _shakeController,
        child: card,
        builder: (context, child) {
          final offset =
              sin(_shakeController.value * pi * 8) *
              (1 - _shakeController.value) *
              7;

          return Transform.translate(
            offset: Offset(offset, 0),
            child: child,
          );
        },
      );
    }

    return Semantics(
      button: true,
      label: 'Pilih ${category.name}',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(21),
          onTap: _answered ? null : () => _checkAnswer(index),
          child: card,
        ),
      ),
    );
  }

  Widget _buildResult() {
    final percentage =
        (_score / _questions.length * 100).round();

    final String message;
    final String subtitle;
    final IconData resultIcon;
    final Color resultColor;

    if (_score == 5) {
      message = 'SEMPURNA!';
      subtitle = 'Wah, kamu jagoan lingkungan sejati! '
          'Semua sampah berhasil kamu pilah dengan tepat.';
      resultIcon = Icons.workspace_premium_rounded;
      resultColor = const Color(0xFFFFB52E);
    } else if (_score >= 4) {
      message = 'HEBAT SEKALI!';
      subtitle = 'Kamu sudah pintar memilah sampah. '
          'Terus jaga bumi kita, ya!';
      resultIcon = Icons.emoji_events_rounded;
      resultColor = const Color(0xFFFFB52E);
    } else if (_score >= 3) {
      message = 'KERJA BAGUS!';
      subtitle = 'Kamu sudah mulai mengenali sampah. '
          'Yuk, belajar lagi supaya makin hebat!';
      resultIcon = Icons.military_tech_rounded;
      resultColor = const Color(0xFF65BE45);
    } else {
      message = 'TETAP SEMANGAT!';
      subtitle = 'Tidak perlu menyerah. '
          'Setiap permainan membuatmu belajar hal baru!';
      resultIcon = Icons.eco_rounded;
      resultColor = const Color(0xFF35A853);
    }

    return Stack(
      children: [
        Positioned.fill(
          child: IgnorePointer(
            child: AnimatedBuilder(
              animation: _confettiController,
              builder: (context, child) {
                return CustomPaint(
                  painter: _ConfettiPainter(
                    progress: _confettiController.value,
                  ),
                );
              },
            ),
          ),
        ),
        Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(22),
            child: Column(
              children: [
                AnimatedBuilder(
                  animation: _resultController,
                  builder: (context, child) {
                    final scale = Curves.elasticOut.transform(
                      _resultController.value,
                    );

                    return Transform.scale(
                      scale: scale.clamp(0.0, 1.15),
                      child: child,
                    );
                  },
                  child: Container(
                    width: 145,
                    height: 145,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          resultColor.withOpacity(0.18),
                          resultColor.withOpacity(0.38),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: resultColor.withOpacity(0.35),
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: resultColor.withOpacity(0.15),
                          blurRadius: 25,
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                    child: Icon(
                      resultIcon,
                      color: resultColor,
                      size: 88,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: darkGreen,
                    fontSize: 29,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF526A56),
                    fontSize: 14,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 23),
                _buildScoreCard(percentage),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: green,
                      foregroundColor: Colors.white,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    onPressed: _restartGame,
                    icon: const Icon(Icons.replay_rounded, size: 25),
                    label: const Text(
                      'MAIN LAGI',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: green,
                      side: const BorderSide(
                        color: green,
                        width: 2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    onPressed: _backToMenu,
                    icon: const Icon(Icons.home_rounded),
                    label: const Text(
                      'KEMBALI KE MENU',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  '🌎 Terima kasih sudah membantu bumi!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: darkGreen,
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScoreCard(int percentage) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              final earned = index < _score;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: Icon(
                  earned
                      ? Icons.star_rounded
                      : Icons.star_outline_rounded,
                  color: earned
                      ? orange
                      : const Color(0xFFD5DCCF),
                  size: 39,
                ),
              );
            }),
          ),
          const SizedBox(height: 14),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: _score.toDouble()),
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Text(
                '${value.round()} / ${_questions.length}',
                style: const TextStyle(
                  color: darkGreen,
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                ),
              );
            },
          ),
          const SizedBox(height: 4),
          const Text(
            'Jawaban benar',
            style: TextStyle(
              color: Color(0xFF66816A),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 17),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: _score / _questions.length),
              duration: const Duration(milliseconds: 1000),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return LinearProgressIndicator(
                  value: value,
                  minHeight: 13,
                  backgroundColor: const Color(0xFFD5E9CB),
                  color: green,
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '$percentage%',
            style: const TextStyle(
              color: green,
              fontSize: 25,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _AnswerPopup extends StatefulWidget {
  const _AnswerPopup({
    required this.correct,
    required this.question,
    required this.onContinue,
    required this.isLastQuestion,
  });

  final bool correct;
  final _WasteQuestion question;
  final VoidCallback onContinue;
  final bool isLastQuestion;

  @override
  State<_AnswerPopup> createState() => _AnswerPopupState();
}

class _AnswerPopupState extends State<_AnswerPopup>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  static const Color green = Color(0xFF35A853);
  static const Color darkGreen = Color(0xFF245D34);
  static const Color red = Color(0xFFEF5650);
  static const Color orange = Color(0xFFFFB52E);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );

    _scale = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.correct ? green : red;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 25),
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.82,
          ),
          padding: const EdgeInsets.fromLTRB(22, 28, 22, 22),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FFF4),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: color.withOpacity(0.35),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.2),
                blurRadius: 25,
                spreadRadius: 2,
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.13),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    widget.correct
                        ? Icons.emoji_events_rounded
                        : Icons.sentiment_dissatisfied_rounded,
                    color: color,
                    size: 68,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  widget.correct ? 'HEBAT SEKALI!' : 'YUK, COBA LAGI!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: widget.correct ? darkGreen : red,
                    fontSize: 23,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 9),
                Text(
                  widget.correct
                      ? 'Jawaban kamu benar!'
                      : 'Tidak apa-apa, tetap semangat!',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF526A56),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(19),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        widget.correct
                            ? Icons.star_rounded
                            : Icons.lightbulb_rounded,
                        color: orange,
                        size: 34,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        widget.correct
                            ? '+1 BINTANG'
                            : 'JAWABAN YANG BENAR',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: darkGreen,
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      if (!widget.correct) ...[
                        const SizedBox(height: 6),
                        Text(
                          widget.question.category,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: red,
                            fontSize: 21,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                      const SizedBox(height: 7),
                      Text(
                        widget.question.description,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFF526A56),
                          fontSize: 12,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: FilledButton(
                    onPressed: () {
  AudioManager.instance.playSfx(SfxTrack.buttonMenu);
  widget.onContinue();
},
                    style: FilledButton.styleFrom(
                      backgroundColor: green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            widget.isLastQuestion
                                ? 'LIHAT HASIL MISI'
                                : 'LANJUTKAN',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_rounded),
                      ],
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
}

class _WasteQuestion {
  const _WasteQuestion({
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.category,
  });

  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final String category;
}

class _WasteCategory {
  const _WasteCategory({
    required this.name,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.pale,
  });

  final String name;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Color pale;
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter({required this.progress});

  final double progress;

  static const List<Color> colors = [
    Color(0xFF35A853),
    Color(0xFFFFB52E),
    Color(0xFF2295E2),
    Color(0xFFEF5650),
    Color(0xFFAB75CE),
    Color(0xFF26A69A),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0 || progress >= 1) return;

    final paint = Paint();

    for (int i = 0; i < 48; i++) {
      final seed = i * 37.7;
      final startX = (sin(seed) * 0.5 + 0.5) * size.width;
      final startY = -20.0 - (i % 8) * 25.0;

      final fall = progress * (size.height + 100);
      final x = startX + sin(progress * 8 + seed) * 28;
      final y = (startY + fall + i * 17) % (size.height + 60);

      final opacity = (1 - progress * 0.45).clamp(0.0, 1.0);

      paint.color = colors[i % colors.length].withOpacity(opacity);

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(progress * 8 + seed);

      if (i % 3 == 0) {
        canvas.drawCircle(
          Offset.zero,
          4 + (i % 3).toDouble(),
          paint,
        );
      } else {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: Offset.zero,
              width: 7,
              height: 13,
            ),
            const Radius.circular(2),
          ),
          paint,
        );
      }

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
