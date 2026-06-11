import 'package:flutter/material.dart';

import '../../app/aurae_theme.dart';
import '../../core/widgets/aurae_widgets.dart';

class MoodboardScreen extends StatefulWidget {
  const MoodboardScreen({super.key});

  static const routeName = '/moodboard';

  @override
  State<MoodboardScreen> createState() => _MoodboardScreenState();
}

class _MoodboardScreenState extends State<MoodboardScreen> {
  final positions = <Offset>[
    const Offset(25, 120),
    const Offset(190, 55),
    const Offset(45, 390),
    const Offset(180, 560),
  ];

  final images = const [
    'https://lh3.googleusercontent.com/aida-public/AB6AXuBpQXMLal_cV_6OZ7SJQdQh80ixyNtoy8EN2xNNltZUCDxMmCzUsFrgMRqbkVp-NaHf50BZ3h-cv3pY3C9fITgcmpCTVv3yf2mCU6mr-a6GYURrEahDtVpT6aEDIcgSh3VmgYOYDk7zZGR97hyTVcj4DV4TY1G1Br7Bq97yftxC52AW1iCDLcHMhz9bWB-lQD7zoaAnArC_9XFUzY7T_nze93hAM5aVJAY_jcYqZJQ1ysh2D9YSwI7VqKFj0y3ZxSv8KK8rlRApc7Q',
    'https://lh3.googleusercontent.com/aida-public/AB6AXuAuKdnedz-wQNJu4vj5rKlNlUhMZGLtduJl9EoEdOi3iza8vef6atCpG1Xk9lty5_yHsTBhc2l49neyhski-QF2KAu65BOhwHqXVbKBXCPkSovECZkxhtMbaTvx1CtNJL8TVb1GdYOVsUyq6GBaX6FL3p8pj90Vy8TElZxwnw0I4vw_v4tL9K0rwNjKPTmXqz_IX_-HxSIZf5jPQ9P36lM4p7ImhgYovBn5NGUzPrAfh-WrQWb04BxfP5hIi_fxq8SDnIUwUSA3j1o',
    'https://lh3.googleusercontent.com/aida-public/AB6AXuCFoK3eTvvXbk9uf7z2F8sXJt9qKR1EHGlv8_hKmZ_ZURepD6lefQA3xBhkMNZVn36fsAUAA1RPogOxq9IArRPbO_PI5dP-R6jVPJeG18EohhS7oezJVgux7vBIhfvzrm1n_ahXUPM1UtFJP9yIZAbt38GY7lBFLSxEma4y-PhdW0WgENMJEh_gA0ZHnLuSRCnTgKn7-C_d2u38mybuLHM5KnAjL-70_ckoMPJ43oPbQ1gK4zT0Zt_LeQ7u3VBNgFBkbNu2NXdB8zw',
    'https://lh3.googleusercontent.com/aida-public/AB6AXuB6G7f8wnpgtzPHiidLcuRX7xaMD0qPzRUBNRP-YSkTl8w0YPfGbLP6QyiT9msa63TJA-Ga8uzgsNG48vn9nDMkFGEf9SpU6RExnLynavIX3DNZQDsPDSHkuus41weep0SUidVfAcBpMEfga5AKhBmDeUshiioOIKwu-NBeHa7TwoTHpS3i-eS-F8pwRU4Fay8uivI4uts4ofF9bYgEwZ85_a1AKf30rCxaRspaxORDs9BHeDLnZj4ahPalL88v_Xg7dKGtgkWid_M',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Summer in Bali'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.share_outlined)),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Save'),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: ColoredBox(
              color: const Color(0xFFF6F1EB),
              child: CustomPaint(painter: _PaperTexturePainter()),
            ),
          ),
          ...List.generate(images.length, (index) {
            final sizes = [210.0, 145.0, 250.0, 190.0];
            return Positioned(
              left: positions[index].dx,
              top: positions[index].dy,
              width: sizes[index],
              height: sizes[index],
              child: GestureDetector(
                onPanUpdate: (details) =>
                    setState(() => positions[index] += details.delta),
                child: Transform.rotate(
                  angle: index.isEven ? -.07 : .07,
                  child: Material(
                    elevation: 8,
                    color: Colors.transparent,
                    child: FashionImage(url: images[index], borderRadius: 2),
                  ),
                ),
              ),
            );
          }),
          Positioned(
            right: 14,
            top: 310,
            child: Column(
              children: const [
                _ColorDot(Color(0xFFE9DCCB)),
                _ColorDot(Color(0xFFA7C5CF)),
                _ColorDot(Color(0xFFA6B78B)),
                _ColorDot(Color(0xFFF3E6D5)),
                _ColorDot(Color(0xFF734018)),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 92,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: const BoxDecoration(
            color: AuraeColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              _Tool(icon: Icons.add, label: 'Add'),
              _Tool(icon: Icons.text_fields, label: 'Text'),
              _Tool(icon: Icons.palette_outlined, label: 'Color'),
              _Tool(icon: Icons.filter_frames_outlined, label: 'Filter'),
            ],
          ),
        ),
      ),
    );
  }
}

class _ColorDot extends StatelessWidget {
  const _ColorDot(this.color);
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
    );
  }
}

class _Tool extends StatelessWidget {
  const _Tool({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Icon(icon), const SizedBox(height: 5), Text(label)],
    );
  }
}

class _PaperTexturePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0x12000000);
    for (double x = 8; x < size.width; x += 29) {
      for (double y = 12; y < size.height; y += 31) {
        canvas.drawCircle(Offset(x, y), .55, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
