import 'package:flutter/material.dart';

import '../../app/app_controller.dart';
import '../../app/aurae_app.dart';
import '../../app/aurae_theme.dart';
import '../../core/widgets/aurae_widgets.dart';
import '../moodboard/moodboard_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.onOpenProfile});

  final VoidCallback onOpenProfile;

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context);
    final strings = AppStrings(controller.isIndonesian);
    final Indonesian = controller.isIndonesian;
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 110),
            sliver: SliverList.list(
              children: [
                Row(
                  children: [
                    const Icon(Icons.menu),
                    const Expanded(
                      child: Center(child: AuraeBrand(compact: true)),
                    ),
                    InkWell(
                      onTap: onOpenProfile,
                      borderRadius: BorderRadius.circular(30),
                      child: const CircleAvatar(
                        radius: 18,
                        backgroundColor: AuraeColors.rose,
                        child: Icon(
                          Icons.person_outline,
                          color: AuraeColors.ink,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Text(
                  Indonesian ? 'Selamat pagi, Dira' : 'Good morning, Dira',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 8),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Chip(
                    avatar: Icon(Icons.location_on_outlined, size: 17),
                    label: Text('Jakarta, 28°C · Sunny'),
                    backgroundColor: AuraeColors.rose,
                  ),
                ),
                const SizedBox(height: 28),
                _HeroOutfit(Indonesian: Indonesian),
                const SizedBox(height: 38),
                SectionHeader(
                  title: strings.savedLooks,
                  action: strings.viewAll,
                ),
                const SizedBox(height: 14),
                SizedBox(
                  height: 168,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: const [
                      _SavedLookCard(
                        title: 'Brunch in SCBD',
                        imageUrl:
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuA66shTpIm3hl_E2sTORU9gQzODgqX9oLBTrkjCmoHGIdhEaRdui1tjkZTHZIpn6cbwtkSf7-taCp3W2KWJ3LqKezQ-niEJeWsOp47nLbEC4q_I43wPAvn09wjI0QcZi8XpJ3pBoZSaTnx1H9BrtA_cZUuQzpn3V13jjGAUEdUni9bwlhMfG9625s5viHbNcIcLn2vfyLBHbr6mV8_mscC1qlPDIoDeeLXD3md6SIfQrvfjzdsYBjYeTM7Iuwk0Rm7rgkTjosVfEhU',
                      ),
                      _SavedLookCard(
                        title: 'Gallery Visit',
                        imageUrl:
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuCSHMr0EdqcbTYs_msZP5qbXsOvPyemcaLkHIL7y6Ya-puLq425oaYEbMCIqPKK5V1H20tXCc-_KlGyvpIShc8DJgEIgfKjWvFWuRTZo8mXI48EOtiS9Bx1WuUx4Ub4j61aCwm_M1zeTAG3sezWrN34vJCYnfPe2kdfkHWatQ2pvFMaUZHmpIhUUNceLy73BlGxn142Hv5SqfvveeIaC6ioFDBVLQ__nvsoAndIWcxrJXsZGdhspBddS5Pk108VlMAhl8Be1BdB92k',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 34),
                SectionHeader(
                  title: Indonesian
                      ? 'Inspirasi hari ini'
                      : 'Today\'s inspiration',
                ),
                const SizedBox(height: 14),
                _AestheticCard(
                  title: 'Quiet Luxury',
                  color: const Color(0xFF6B513C),
                  onTap: () =>
                      Navigator.pushNamed(context, MoodboardScreen.routeName),
                ),
                const SizedBox(height: 14),
                _AestheticCard(
                  title: 'Coastal Grandma',
                  color: const Color(0xFF9EBCC6),
                  onTap: () =>
                      Navigator.pushNamed(context, MoodboardScreen.routeName),
                ),
                const SizedBox(height: 28),
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: AuraeColors.sage,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Indonesian
                            ? 'Pertajam seleramu.'
                            : 'Refine your taste.',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        Indonesian
                            ? 'Ambil kuis visual dua menit agar rekomendasi semakin personal.'
                            : 'Take a two-minute visual quiz to make recommendations more personal.',
                      ),
                      const SizedBox(height: 18),
                      FilledButton(
                        onPressed: () {},
                        child: Text(
                          Indonesian ? 'Mulai kuis gaya' : 'Start style quiz',
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
    );
  }
}

class _HeroOutfit extends StatelessWidget {
  const _HeroOutfit({required this.Indonesian});
  final bool Indonesian;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: .84,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          fit: StackFit.expand,
          children: [
            const FashionImage(
              borderRadius: 0,
              url:
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuAPaaHJgfpzOusxXqqwTF7sSE1bygevNBSSU-Rqs1wE-76nfqf2rkGkYWS7E4xxYK3AIMOKVjw4qLAxOsdISEM7KrbmTrPw7RBJ6-X74kQ1X3cUxlDasv0_lRUKpA_LrQq-QRg9bgw9MHNmbuoa4p8JR8hl2NfUKmMiocyes4RVCaq7onsiX9POZdm5KuL1Q2mihbDvX8Vyzek5yiWSv0QG-pLAbxJ_rOBo_busb1mU2FL1qK-eOBLspvgMZZZ874mkXfN6Q7TDoYc',
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Color(0xAA1D1B1B)],
                ),
              ),
            ),
            Positioned(
              left: 22,
              right: 22,
              bottom: 20,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Indonesian ? 'DIPILIH UNTUKMU' : 'CURATED FOR YOU',
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(
                                color: Colors.white,
                                letterSpacing: 1.5,
                              ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          Indonesian ? 'Outfit Hari Ini' : 'Today\'s Outfit',
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  IconButton.filled(
                    onPressed: () {},
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AuraeColors.ink,
                    ),
                    icon: const Icon(Icons.arrow_forward),
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

class _SavedLookCard extends StatelessWidget {
  const _SavedLookCard({required this.title, required this.imageUrl});
  final String title;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 138,
      margin: const EdgeInsets.only(right: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: FashionImage(url: imageUrl)),
          const SizedBox(height: 8),
          Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}

class _AestheticCard extends StatelessWidget {
  const _AestheticCard({
    required this.title,
    required this.color,
    required this.onTap,
  });
  final String title;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Ink(
        height: 170,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(22),
          gradient: LinearGradient(
            colors: [color.withValues(alpha: .65), color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
