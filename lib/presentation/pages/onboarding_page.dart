import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

import '../../core/app_initializer.dart';
import '../../core/routes/app_routes.dart';
import '../widgets/dots_indicator.dart';
import '../widgets/buttons.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();
  int _index = 0;

  final List<_OnboardingContent> _pages = const [
    _OnboardingContent(
      icon: IconlyBold.ticket,
      gradient: [Color(0xFF00B3A4), Color(0xFF5AD8C7)],
      titleEn: 'One pass. All gyms.',
      bodyEn: 'Book classes across gyms and stay motivated.',
      titleAr: 'اشتراك واحد. كل الأندية.',
      bodyAr: 'احجز حصصًا من أندية متعددة وابقَ متحمسًا.',
    ),
    _OnboardingContent(
      icon: IconlyBold.graph,
      gradient: [Color(0xFF5170FF), Color(0xFF9BB1FF)],
      titleEn: 'Smart plans via InBody.',
      bodyEn: 'Tailored sessions based on your goals.',
      titleAr: 'خطط ذكية عبر إن بودي.',
      bodyAr: 'جلسات مخصصة بناءً على أهدافك.',
    ),
    _OnboardingContent(
      icon: IconlyBold.chat,
      gradient: [Color(0xFFFD6585), Color(0xFFFCBA4A)],
      titleEn: 'Share your wins.',
      bodyEn: 'Beautiful cards + pass token.',
      titleAr: 'شارك إنجازاتك.',
      bodyAr: 'بطاقات أنيقة + رمز مرور.',
    ),
  ];

  void _next() {
    if (_index == _pages.length - 1) {
      _complete();
    } else {
      _controller.nextPage(duration: 300.ms, curve: Curves.easeOut);
    }
  }

  void _complete() {
    AppInitializer.prefs.setBool('onboarding.completed', true);
    Get.offAllNamed(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: _controller,
              itemCount: _pages.length,
              onPageChanged: (value) => setState(() => _index = value),
              itemBuilder: (context, index) {
                final page = _pages[index];
                final title = isRtl ? page.titleAr : page.titleEn;
                final body = isRtl ? page.bodyAr : page.bodyEn;
                return Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Center(
                          child: _OnboardingIllustration(content: page)
                              .animate(onPlay: (controller) => controller.repeat())
                              .fadeIn(duration: 400.ms)
                              .scaleXY(duration: 3.seconds, begin: 0.95, end: 1.05),
                        ),
                      ),
                      Text(title, style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      Text(body, style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
                      const SizedBox(height: 120),
                    ],
                  ),
                );
              },
            ),
            Positioned(
              top: 16,
              right: isRtl ? null : 16,
              left: isRtl ? 16 : null,
              child: GhostButton(label: 'skip'.tr, onPressed: _complete),
            ),
            Positioned(
              bottom: 120,
              left: 0,
              right: 0,
              child: DotsIndicator(count: _pages.length, index: _index),
            ),
            Positioned(
              bottom: 24,
              left: 24,
              right: 24,
              child: PrimaryButton(
                label: _index == _pages.length - 1 ? 'get_started'.tr : 'next'.tr,
                onPressed: _next,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingContent {
  const _OnboardingContent({
    required this.icon,
    required this.gradient,
    required this.titleEn,
    required this.bodyEn,
    required this.titleAr,
    required this.bodyAr,
  });

  final IconData icon;
  final List<Color> gradient;
  final String titleEn;
  final String bodyEn;
  final String titleAr;
  final String bodyAr;
}

class _OnboardingIllustration extends StatelessWidget {
  const _OnboardingIllustration({required this.content});

  final _OnboardingContent content;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest.shortestSide == double.infinity
            ? 280.0
            : constraints.biggest.shortestSide.clamp(200.0, 320.0);
        return SizedBox(
          width: size,
          height: size,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(size * 0.28),
              gradient: LinearGradient(colors: content.gradient),
              boxShadow: [
                BoxShadow(
                  color: content.gradient.last.withOpacity(0.35),
                  blurRadius: 36,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: size * 0.18,
                  right: size * 0.14,
                  child: _Bubble(color: Colors.white.withOpacity(0.18), size: size * 0.16),
                ),
                Positioned(
                  bottom: size * 0.18,
                  left: size * 0.12,
                  child: _Bubble(color: Colors.white.withOpacity(0.12), size: size * 0.2),
                ),
                Icon(content.icon, color: Colors.white, size: size * 0.42),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}
