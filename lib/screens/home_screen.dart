import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/quiz_data.dart';
import '../providers/quiz_provider.dart';
import 'leaderboard_screen.dart';
import 'quiz_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _nameController = TextEditingController();

  String _avatar = '🧠';
  String? _nameError;

  static const Color blue = Color(0xFF0284C7);
  static const Color purple = Color(0xFF7C3AED);

  final List<Map<String, dynamic>> _categories = [
    {
      'id': 'pengetahuan_umum',
      'name': 'Pengetahuan Umum',
      'description':
          'Wawasan dunia, geografi, sains populer, dan fakta menarik global',
      'icon': Icons.public_rounded,
      'color': Color(0xFF0EA5E9),
    },
    {
      'id': 'biologi',
      'name': 'Biologi',
      'description':
          'Struktur sel, genetika dasar, ekosistem alam, dan anatomi makhluk hidup',
      'icon': Icons.biotech_rounded,
      'color': Color(0xFF10B981),
    },
    {
      'id': 'matematika',
      'name': 'Matematika',
      'description':
          'Aritmatika, aljabar, geometri, logika angka, dan probabilitas',
      'icon': Icons.calculate_rounded,
      'color': Color(0xFFA855F7),
    },
    {
      'id': 'sejarah_dunia',
      'name': 'Sejarah Dunia',
      'description':
          'Peristiwa bersejarah, peradaban kuno, tokoh dunia, dan revolusi penting',
      'icon': Icons.account_balance_rounded,
      'color': Color(0xFFF59E0B),
    },
  ];

  final List<String> _avatars = [
    '👩‍🚀',
    '⚡',
    '🧠',
    '💡',
    '🌟',
    '🎯',
    '🚀',
    '🔥',
  ];

  @override
  void initState() {
    super.initState();
    _nameController.text =
        context.read<QuizProvider>().userName;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _startQuiz() {
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      setState(() {
        _nameError = 'Nama peserta wajib diisi';
      });
      return;
    }

    final provider = context.read<QuizProvider>();

    provider.setUserName(name);
    provider.startQuiz(allQuestions);

    if (provider.activeQuestions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Soal belum tersedia untuk kategori ini.',
          ),
        ),
      );
      return;
    }

    setState(() {
      _nameError = null;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const QuizScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<QuizProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth =
                constraints.maxWidth > 760 ? 680.0 : 560.0;

            return Center(
              child: SizedBox(
                width: maxWidth,
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                          16,
                          12,
                          16,
                          20,
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.stretch,
                          children: [
                            _buildHeader(provider, isDark),
                            const SizedBox(height: 20),
                            _buildHero(),
                            const SizedBox(height: 20),
                            _buildParticipantCard(isDark),
                            const SizedBox(height: 24),
                            _buildSectionTitle(
                              'PILIH KATEGORI KUIS',
                            ),
                            const SizedBox(height: 12),
                            ..._categories.map(
                              (category) => Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 10),
                                child: _buildCategoryCard(
                                  category,
                                  provider,
                                  isDark,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            _buildSettings(provider, isDark),
                            const SizedBox(height: 20),
                            _buildStartButton(),
                            const SizedBox(height: 14),
                            _buildFooter(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(
    QuizProvider provider,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark
              ? const Color(0xFF263449)
              : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF7C3AED), Color(0xFF2563EB)],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.quiz_rounded,
              color: Colors.white,
              size: 25,
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Quiznova',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w900,
                color: Color(0xFF4F46E5),
                letterSpacing: -0.5,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF1E293B)
                  : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(14),
            ),
            child: IconButton(
              tooltip: 'Ganti tema',
              onPressed: provider.toggleTheme,
              icon: Icon(
                isDark
                    ? Icons.light_mode_rounded
                    : Icons.wb_sunny_rounded,
                color: isDark
                    ? const Color(0xFFFBBF24)
                    : const Color(0xFFF59E0B),
              ),
            ),
          ),
          const SizedBox(width: 8),
          PopupMenuButton<String>(
            tooltip: 'Menu',
            onSelected: (value) {
              if (value == 'leaderboard') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LeaderboardScreen(),
                  ),
                );
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'leaderboard',
                child: Row(
                  children: [
                    Icon(Icons.leaderboard_rounded),
                    SizedBox(width: 10),
                    Text('Papan peringkat'),
                  ],
                ),
              ),
            ],
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 13,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF1E293B)
                    : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Row(
                children: [
                  Icon(Icons.menu_rounded, size: 20),
                  SizedBox(width: 6),
                  Text(
                    'Menu',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
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


  Widget _buildHero() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 28,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? const [
                  Color(0xFF151C35),
                  Color(0xFF21183B),
                ]
              : const [
                  Color(0xFFEFF8FF),
                  Color(0xFFF5F3FF),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: isDark
              ? const Color(0xFF37305C)
              : const Color(0xFFE0EDFF),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF1E3355)
                  : const Color(0xFFDBEAFE),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: isDark
                    ? const Color(0xFF334E78)
                    : const Color(0xFFBAE6FD),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.auto_awesome_rounded,
                  color: Color(0xFF38BDF8),
                  size: 17,
                ),
                const SizedBox(width: 7),
                Text(
                  'Interactive Knowledge Challenge',
                  style: TextStyle(
                    color: isDark
                        ? const Color(0xFFBAE6FD)
                        : const Color(0xFF0284C7),
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w900,
                letterSpacing: -1.5,
              ),
              children: [
                TextSpan(
                  text: 'Quiz',
                  style: TextStyle(
                    color: isDark
                        ? const Color(0xFFF1F5F9)
                        : const Color(0xFF0F172A),
                  ),
                ),
                const TextSpan(
                  text: 'nova',
                  style: TextStyle(
                    color: Color(0xFF7C3AED),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '“Let Your Mind Explode with Knowledge.”',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isDark
                  ? const Color(0xFFC4B5FD)
                  : const Color(0xFF3730A3),
              fontSize: 14,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildParticipantCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? const Color(0xFF263449)
              : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.person_outline_rounded,
                color: Color(0xFF0284C7),
                size: 21,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'NAMA PESERTA',
                  style: TextStyle(
                    color: isDark
                        ? Colors.white70
                        : const Color(0xFF64748B),
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.7,
                    fontSize: 13,
                  ),
                ),
              ),
              const Text(
                'Wajib diisi',
                style: TextStyle(
                  color: Color(0xFF0284C7),
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            spacing: 5,
            runSpacing: 8,
            children: _avatars.map((avatar) {
              final selected = _avatar == avatar;

              return InkWell(
                onTap: () {
                  setState(() => _avatar = avatar);
                },
                borderRadius: BorderRadius.circular(30),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  width: 42,
                  height: 42,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected
                        ? const Color(0xFFDBEAFE)
                        : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selected
                          ? const Color(0xFF0284C7)
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Text(
                    avatar,
                    style: const TextStyle(fontSize: 23),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _nameController,
            textCapitalization: TextCapitalization.words,
            onChanged: (_) {
              if (_nameError != null) {
                setState(() => _nameError = null);
              }
            },
            decoration: InputDecoration(
              hintText: 'Contoh: Bella',
              errorText: _nameError,
              prefixIcon: const Icon(Icons.badge_outlined),
              fillColor: isDark
                  ? const Color(0xFF0F172A)
                  : const Color(0xFFF8FAFC),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFF64748B),
        fontWeight: FontWeight.w900,
        fontSize: 13,
        letterSpacing: 0.8,
      ),
    );
  }

  Widget _buildCategoryCard(
    Map<String, dynamic> category,
    QuizProvider provider,
    bool isDark,
  ) {
    final selected = provider.selectedCategory == category['id'];
    final color = category['color'] as Color;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          provider.setCategory(category['id'] as String);
        },
        borderRadius: BorderRadius.circular(22),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: selected
                ? color.withValues(alpha: isDark ? 0.15 : 0.07)
                : Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: selected
                  ? color
                  : isDark
                      ? const Color(0xFF263449)
                      : const Color(0xFFE2E8F0),
              width: selected ? 1.7 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  category['icon'] as IconData,
                  color: color,
                  size: 25,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category['name'] as String,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      category['description'] as String,
                      style: TextStyle(
                        color: isDark
                            ? Colors.white60
                            : const Color(0xFF64748B),
                        height: 1.45,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                selected
                    ? Icons.radio_button_checked_rounded
                    : Icons.radio_button_off_rounded,
                color: selected ? color : Colors.blueGrey.shade200,
                size: 21,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettings(
    QuizProvider provider,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark
              ? const Color(0xFF263449)
              : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Tingkat Kesulitan:',
                  style: TextStyle(
                    color: isDark
                        ? Colors.white70
                        : const Color(0xFF64748B),
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
              ),
              Text(
                provider.selectedDifficulty == 'Semua'
                    ? 'Campuran (Semua Level)'
                    : provider.selectedDifficulty,
                style: const TextStyle(
                  color: Color(0xFF0284C7),
                  fontWeight: FontWeight.w900,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ['Semua', 'Mudah', 'Sedang', 'Sulit']
                .map((difficulty) {
              final selected =
                  provider.selectedDifficulty == difficulty;

              return ChoiceChip(
                label: Text(difficulty),
                selected: selected,
                onSelected: (_) {
                  provider.setDifficulty(difficulty);
                },
                selectedColor: blue,
                backgroundColor: isDark
                    ? const Color(0xFF1E293B)
                    : const Color(0xFFF1F5F9),
                labelStyle: TextStyle(
                  color: selected
                      ? Colors.white
                      : isDark
                          ? Colors.white
                          : const Color(0xFF334155),
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
                side: BorderSide.none,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Jumlah Pertanyaan:',
                  style: TextStyle(
                    color: isDark
                        ? Colors.white70
                        : const Color(0xFF64748B),
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
              ),
              Text(
                '${provider.questionCount} Soal',
                style: const TextStyle(
                  color: Color(0xFFA855F7),
                  fontWeight: FontWeight.w900,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [5, 10, 20].map((count) {
              final selected = provider.questionCount == count;

              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: count == 20 ? 0 : 8,
                  ),
                  child: OutlinedButton(
                    onPressed: () {
                      provider.setQuestionCount(count);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 13,
                      ),
                      backgroundColor: selected
                          ? purple
                          : isDark
                              ? const Color(0xFF1E293B)
                              : const Color(0xFFF1F5F9),
                      foregroundColor:
                          selected ? Colors.white : null,
                      side: BorderSide(
                        color: selected
                            ? purple
                            : Colors.transparent,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      '$count Soal',
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStartButton() {
    return Container(
      height: 58,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0284C7), Color(0xFF4F46E5)],
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: blue.withValues(alpha: 0.20),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: _startQuiz,
        icon: const Icon(Icons.play_arrow_rounded, size: 25),
        label: const Text(
          'Mulai Kuis Sekarang',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 16,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Text(
        'Pilih kategori, siapkan fokusmu, dan tantang dirimu!',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color(0xFF94A3B8),
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
