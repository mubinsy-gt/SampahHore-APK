
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/audio_manager.dart';

class PenghargaanScreen extends StatefulWidget {
  const PenghargaanScreen({super.key});

  @override
  State<PenghargaanScreen> createState() => _PenghargaanScreenState();
}

class _PenghargaanScreenState extends State<PenghargaanScreen> {
  bool _loading = true;
  final Set<String> _earnedBadges = {};

  static const List<_BadgeInfo> _badges = [
    _BadgeInfo(
      id: 'badge_bintang_pembelajar',
      title: 'Bintang Pembelajar',
      description: 'Selesaikan semua 5 materi belajar.',
      icon: Icons.menu_book_rounded,
      color: Color(0xFFFFA726),
    ),
    _BadgeInfo(
      id: 'badge_juara_kuis',
      title: 'Juara Kuis',
      description: 'Selesaikan ketiga level kuis.',
      icon: Icons.emoji_events_rounded,
      color: Color(0xFFFFB52E),
    ),
    _BadgeInfo(
      id: 'badge_penjelajah_sampah',
      title: 'Penjelajah Sampah',
      description: 'Selesaikan empat aktivitas Kampus Sampah.',
      icon: Icons.explore_rounded,
      color: Color(0xFF2196F3),
    ),
    _BadgeInfo(
      id: 'badge_ahli_pilah',
      title: 'Kenali Sampah',
      description: 'Pelajari ketiga jenis sampah.',
      icon: Icons.recycling_rounded,
      color: Color(0xFF43A047),
    ),
    _BadgeInfo(
      id: 'badge_jagoan_pilah',
      title: 'Jagoan Pilah Sampah',
      description: 'Jawab minimal 4 dari 5 soal dengan benar.',
      icon: Icons.stars_rounded,
      color: Color(0xFF8E55D9),
    ),
    _BadgeInfo(
      id: 'badge_penjaga_bumi',
      title: 'Penjaga Bumi',
      description: 'Selesaikan misi Kelas Penjaga Bumi.',
      icon: Icons.public_rounded,
      color: Color(0xFF2E9D59),
    ),
    _BadgeInfo(
      id: 'badge_ilmuwan_sampah',
      title: 'Ilmuwan Sampah',
      description: 'Selesaikan misi Laboratorium Sampah.',
      icon: Icons.science_rounded,
      color: Color(0xFF1688D9),
    ),
    _BadgeInfo(
      id: 'badge_sahabat_bumi',
      title: 'Sahabat Bumi',
      description: 'Selesaikan cerita Sahabat Bumi.',
      icon: Icons.favorite_rounded,
      color: Color(0xFFEC6091),
    ),
    _BadgeInfo(
      id: 'badge_pahlawan_aksi_nyata',
      title: 'Pahlawan Aksi Nyata',
      description: 'Selesaikan tiga aksi menjaga bumi.',
      icon: Icons.volunteer_activism_rounded,
      color: Color(0xFFEF6C42),
    ),
  ];

  @override
  void initState() {
    super.initState();
    AudioManager.instance.playBgm(BgmTrack.penghargaan);
    _loadBadges();
  }

  Future<void> _loadBadges() async {
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      _earnedBadges.clear();

      for (final badge in _badges) {
        if (prefs.getBool(badge.id) == true) {
          _earnedBadges.add(badge.id);
        }
      }

      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final earnedCount = _earnedBadges.length;
    final progress = earnedCount / _badges.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Penghargaan',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        backgroundColor: const Color(0xFF239653),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
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
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _loadBadges,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildSummary(earnedCount, progress),
                    const SizedBox(height: 20),
                    const Text(
                      'KOLEKSI LENCANA',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF176D3B),
                      ),
                    ),
                    const SizedBox(height: 10),
                    GridView.builder(
                      shrinkWrap: true,
                      physics:
                          const NeverScrollableScrollPhysics(),
                      itemCount: _badges.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.83,
                      ),
                      itemBuilder: (context, index) {
                        final badge = _badges[index];
                        final earned =
                            _earnedBadges.contains(badge.id);

                        return _BadgeCard(
                          badge: badge,
                          earned: earned,
                        );
                      },
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Terus belajar dan jaga bumi agar semua lencana terbuka!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF356644),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildSummary(int earnedCount, double progress) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22316C49),
            blurRadius: 12,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(
            Icons.emoji_events_rounded,
            color: Color(0xFFFFB52E),
            size: 56,
          ),
          const SizedBox(height: 5),
          const Text(
            'Hebat, Penjaga Bumi!',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Color(0xFF176D3B),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            '$earnedCount dari ${_badges.length} lencana terkumpul',
            style: const TextStyle(
              color: Color(0xFF55715D),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 13,
              backgroundColor: const Color(0xFFE2EDE4),
              valueColor: const AlwaysStoppedAnimation(
                Color(0xFF37B764),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${(progress * 100).round()}% selesai',
            style: const TextStyle(
              color: Color(0xFF239653),
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _BadgeInfo {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  const _BadgeInfo({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}

class _BadgeCard extends StatelessWidget {
  final _BadgeInfo badge;
  final bool earned;

  const _BadgeCard({
    required this.badge,
    required this.earned,
  });

  @override
  Widget build(BuildContext context) {
    final color = earned
        ? badge.color
        : const Color(0xFF9BA7A0);

    return Container(
      padding: const EdgeInsets.fromLTRB(10, 14, 10, 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(earned ? 1 : 0.76),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: earned ? badge.color.withOpacity(0.45) :
              const Color(0xFFD7E0D8),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.12),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.13),
              border: Border.all(
                color: color.withOpacity(0.45),
                width: 3,
              ),
            ),
            child: Icon(
              earned ? badge.icon : Icons.lock_rounded,
              size: 43,
              color: color,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            badge.title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: earned
                  ? const Color(0xFF245D34)
                  : const Color(0xFF78857C),
            ),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: Text(
              earned ? 'Lencana diperoleh!' : badge.description,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                height: 1.3,
                fontWeight: FontWeight.w600,
                color: earned
                    ? const Color(0xFF498357)
                    : const Color(0xFF7E8A81),
              ),
            ),
          ),
          Icon(
            earned ? Icons.check_circle_rounded :
                Icons.lock_outline_rounded,
            size: 20,
            color: earned
                ? const Color(0xFF37B764)
                : const Color(0xFF9BA7A0),
          ),
        ],
      ),
    );
  }
}
