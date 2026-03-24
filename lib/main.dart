import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'kawaii_ui.dart';
import 'app/kawaii_life_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark));
  // Switch between showcase and app:
  // runApp(const KawaiiShowcaseApp());
  runApp(const KawaiiLifeApp());
}

class KawaiiShowcaseApp extends StatelessWidget {
  const KawaiiShowcaseApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Kawaii Showcase v3', debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: KawaiiColors.pinkBottom),
      textTheme: GoogleFonts.nunitoTextTheme()),
    home: const ShowcaseScreen(),
  );
}

// ━━━ Character → icon mapping (keeps theme.dart free of painter imports) ━━━
Widget _charIcon(KawaiiCharacter c, {double size = 22}) {
  final painter = switch (c.name) {
    'Mika' => DressPainter() as CustomPainter,
    'Ren'  => DumbbellPainter(),
    'Sora' => MoonPainter(),
    'Hana' => PenPainter(),
    'Kira' => MusicNotePainter(),
    'Mei'  => SearchIconPainter(color: c.primary),
    _      => Star4Painter(),
  };
  return kawaiiIcon(painter, size: size);
}

KawaiiAvatar _charAvatar(KawaiiCharacter c, {double size = 52}) => KawaiiAvatar(
  icon: _charIcon(c, size: size * 0.42),
  color: c.primary, accent: c.accent, name: c.name,
  status: c.online, size: size);

// Total number of section items in the ListView.builder
const _sectionCount = 18;

class ShowcaseScreen extends StatelessWidget {
  const ShowcaseScreen({super.key});

  Widget _ico(CustomPainter p, {double s = 16}) => kawaiiIcon(p, size: s);

  @override
  Widget build(BuildContext context) {
    final mika = KawaiiCharacter.mika;
    final mikaAva = KawaiiAvatar(
      icon: _ico(DressPainter(), s: 20),
      color: mika.primary, accent: mika.accent, size: 34,
      interactive: false);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(
          begin: Alignment.topCenter, end: Alignment.bottomCenter,
          colors: [KawaiiColors.bgTop, KawaiiColors.bgMid, KawaiiColors.bgBottom])),
        child: KawaiiSparkleField(
          count: 10,
          child: SafeArea(child: ListView.builder(
            padding: EdgeInsets.symmetric(
              horizontal: KawaiiSpacing.xl, vertical: KawaiiSpacing.page),
            itemCount: _sectionCount,
            itemBuilder: (context, index) =>
                _buildSection(context, index, mika, mikaAva),
          )),
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, int index, KawaiiCharacter mika, KawaiiAvatar mikaAva) {
    // Each item is a section + trailing gap. Entrance delay is based on index
    // to preserve the original stagger animation timing.
    final delay = Duration(milliseconds: 150 * index);
    Widget entrance(Widget child) =>
        KawaiiEntrance(delay: delay, slideOffset: 40, child: child);

    final gap = SizedBox(height: KawaiiSpacing.sectionGap);

    switch (index) {
      // ═══ HEADER ═══
      case 0:
        return Column(children: [
          entrance(Center(child: Column(children: [
            Row(mainAxisSize: MainAxisSize.min, children: [
              const SparkleWidget(size: 16),
              const SizedBox(width: KawaiiSpacing.md),
              Text('Kawaii Skeuomorphic', style: kHeading(size: 24)),
              const SizedBox(width: KawaiiSpacing.md),
              const SparkleWidget(size: 14, fill: KawaiiColors.pinkBottom,
                stroke: KawaiiColors.pinkStroke, duration: Duration(milliseconds: 2500)),
            ]),
            const SizedBox(height: 3),
            Text('Component showcase — tap everything, sound on!',
              style: kBody(size: 11, weight: FontWeight.w800, color: KawaiiColors.muted)),
          ]))),
          gap,
        ]);

      // ═══ BUTTONS ═══
      case 1:
        return Column(children: [
          entrance(RepaintBoundary(child: KawaiiCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SectionLabel('Buttons'),
            Wrap(spacing: KawaiiSpacing.wrapSpacing, runSpacing: KawaiiSpacing.wrapRunSpacing, children: [
              KawaiiButton.pink('Pink'), KawaiiButton.violet('Violet'),
              KawaiiButton.green('Green'), KawaiiButton.gold('Gold'), KawaiiButton.blue('Blue'),
            ]),
            const SizedBox(height: 10),
            Wrap(spacing: KawaiiSpacing.wrapSpacing, runSpacing: KawaiiSpacing.wrapRunSpacing, children: [
              KawaiiButton.pink('Icon', i: _ico(HeartPainter(fill: KawaiiColors.pinkText, stroke: KawaiiColors.pinkText), s: 13)),
              KawaiiButton.violet('Next', i: _ico(ArrowPainter(), s: 12)),
              KawaiiButton.pink('Small', small: true),
              KawaiiButton.green('Tiny', small: true),
              KawaiiButton.blue('Done', small: true, i: _ico(CheckPainter(), s: 10)),
            ]),
            const SizedBox(height: 10),
            Wrap(spacing: 10, runSpacing: KawaiiSpacing.wrapRunSpacing, children: [
              KawaiiButton(label: 'Hero CTA', hero: true,
                colors: const KawaiiButtonColors(top: KawaiiColors.pinkTop, bottom: KawaiiColors.pinkBottom,
                  stroke: Color(0xFFC45882), text: KawaiiColors.pinkText, shadow: Color(0x47C45882)),
                icon: _ico(HeartPainter(fill: KawaiiColors.pinkText, stroke: KawaiiColors.pinkText), s: 14)),
              KawaiiButton(label: 'Action', hero: true,
                colors: const KawaiiButtonColors(top: Color(0xFFB3A0D8), bottom: Color(0xFF7E57C2),
                  stroke: Color(0xFF512DA8), text: Color(0xFFFFFFFF), shadow: Color(0x47512DA8)),
                icon: _ico(ArrowPainter(), s: 14)),
            ]),
          ])))),
          gap,
        ]);

      // ═══ CHAT ═══
      case 2:
        return Column(children: [
          entrance(RepaintBoundary(child: KawaiiCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SectionLabel('Chat'),
            ChatMessage(text: "okay babe I saw your outfit pic. we need to talk.",
              name: "Mika", time: "2:34 PM", color: mika.primary, avatar: mikaAva),
            const SizedBox(height: KawaiiSpacing.chatGap),
            const ChatMessage(text: "it's just errands??", isMe: true, time: "2:35 PM", read: true),
            const SizedBox(height: KawaiiSpacing.chatGap),
            ChatMessage(text: "errands are STILL public. hold on let me fix this.",
              name: "Mika", time: "2:35 PM", color: mika.primary, avatar: mikaAva),
            const SizedBox(height: KawaiiSpacing.chatGap),
            ChatMessage(text: "black midi skirt, white crop tank, gold hoops. done. served. you're welcome.",
              time: "2:36 PM", color: mika.primary, avatar: mikaAva),
            const SizedBox(height: KawaiiSpacing.chatGap),
            Row(children: [mikaAva, const SizedBox(width: KawaiiSpacing.md),
              TypingIndicator(color: mika.primary)]),
            const SizedBox(height: KawaiiSpacing.sectionLabelBot),
            KawaiiInput(placeholder: 'Type a message...', btnLabel: 'Send',
              icon: _ico(ChatBubblePainter(color: const Color(0xFFD0688A)), s: 14)),
          ])))),
          gap,
        ]);

      // ═══ NOTIFICATIONS ═══
      case 3:
        return Column(children: [
          entrance(RepaintBoundary(child: KawaiiCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SectionLabel('Notifications'),
            RepaintBoundary(child: KawaiiNotification(title: mika.name, text: 'Your outfit for tomorrow is ready',
              color: mika.primary, icon: _ico(DressPainter(), s: 16), time: '2m')),
            SizedBox(height: KawaiiSpacing.notifGap),
            RepaintBoundary(child: KawaiiNotification(title: KawaiiCharacter.ren.name,
              text: "You missed today's workout! No excuses.",
              color: KawaiiCharacter.ren.primary, icon: _ico(DumbbellPainter(), s: 16), time: '1h')),
            SizedBox(height: KawaiiSpacing.notifGap),
            RepaintBoundary(child: KawaiiNotification(title: KawaiiCharacter.sora.name,
              text: 'Mercury retrograde starts in 3 days.',
              color: KawaiiCharacter.sora.primary, icon: _ico(MoonPainter(), s: 16), time: '4h')),
          ])))),
          gap,
        ]);

      // ═══ AVATARS ═══
      case 4:
        return Column(children: [
          entrance(RepaintBoundary(child: KawaiiCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SectionLabel('Avatars'),
            Wrap(spacing: 14, runSpacing: 10, children: [
              for (final c in KawaiiCharacter.all) _charAvatar(c),
            ]),
          ])))),
          gap,
        ]);

      // ═══ STATS ═══
      case 5:
        return Column(children: [
          entrance(RepaintBoundary(child: KawaiiCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SectionLabel('Stats'),
            Wrap(spacing: 14, runSpacing: 10, alignment: WrapAlignment.start, children: [
              KawaiiStat(value: 48, label: 'Projects', color: mika.primary),
              KawaiiStat(value: 12, label: 'Awards', color: KawaiiColors.goldStroke),
              KawaiiStat(value: 99, label: 'Happy', color: KawaiiCharacter.ren.primary),
              KawaiiStat(value: 7, label: 'Stars', color: KawaiiCharacter.sora.primary),
            ]),
          ])))),
          gap,
        ]);

      // ═══ TAGS & BADGES ═══
      case 6:
        return Column(children: [
          entrance(RepaintBoundary(child: KawaiiCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SectionLabel('Tags & Badges'),
            Wrap(spacing: KawaiiSpacing.iconGap, runSpacing: KawaiiSpacing.iconGap, children: [
              const KawaiiTag('glossy', interactive: true),
              KawaiiTag('tactile', color: KawaiiCharacter.sora.primary, interactive: true),
              KawaiiTag('joyful', color: KawaiiCharacter.ren.primary, interactive: true),
              KawaiiTag('solid', color: KawaiiColors.goldStroke, interactive: true),
              KawaiiTag('bouncy', color: KawaiiCharacter.mei.primary, interactive: true),
              KawaiiTag('kawaii', color: mika.primary, interactive: true),
            ]),
            const SizedBox(height: KawaiiSpacing.lg),
            Wrap(spacing: 10, runSpacing: KawaiiSpacing.wrapRunSpacing, children: [
              KawaiiBadge(interactive: true, child: _ico(HeartPainter(), s: 18)),
              KawaiiBadge(interactive: true, bg: const Color(0xFFF0E8FF), border: KawaiiColors.violetTop,
                child: _ico(BellPainter(color: KawaiiCharacter.sora.primary), s: 18)),
              KawaiiBadge(interactive: true, bg: const Color(0xFFE8F5E9), border: KawaiiColors.greenTop,
                child: _ico(CheckPainter(color: KawaiiColors.greenStroke), s: 18)),
              KawaiiBadge(interactive: true, bg: const Color(0xFFFFF8E1), border: KawaiiColors.goldBottom,
                child: const Star4Icon(size: 16)),
              KawaiiBadge(interactive: true, bg: const Color(0xFFE3F2FD), border: KawaiiColors.blueTop,
                child: _ico(SendPainter(color: KawaiiColors.blueStroke), s: 16)),
            ]),
          ])))),
          gap,
        ]);

      // ═══ PROGRESS ═══
      case 7:
        return Column(children: [
          entrance(RepaintBoundary(child: KawaiiCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SectionLabel('Progress'),
            KawaiiProgress(pct: 78, color: mika.primary, label: 'Style Points'),
            const SizedBox(height: 11),
            KawaiiProgress(pct: 45, color: KawaiiCharacter.sora.primary, label: 'Cosmic Energy',
              delay: const Duration(milliseconds: 200)),
            const SizedBox(height: 11),
            KawaiiProgress(pct: 92, color: KawaiiCharacter.ren.primary, label: 'Fitness Level',
              delay: const Duration(milliseconds: 400)),
          ])))),
          gap,
        ]);

      // ═══ TOGGLES ═══
      case 8:
        return Column(children: [
          entrance(RepaintBoundary(child: KawaiiCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SectionLabel('Toggles'),
            KawaiiToggle(label: 'Notifications', color: mika.primary),
            const SizedBox(height: 11),
            KawaiiToggle(label: 'Sound Effects', color: KawaiiCharacter.sora.primary),
            const SizedBox(height: 11),
            KawaiiToggle(label: 'Dark Mode', color: KawaiiCharacter.ren.primary),
          ])))),
          gap,
        ]);

      // ═══ INPUTS ═══
      case 9:
        return Column(children: [
          entrance(RepaintBoundary(child: KawaiiCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SectionLabel('Inputs'),
            KawaiiInput(placeholder: 'Search companions...', btnLabel: 'Go',
              icon: _ico(SearchIconPainter(), s: 14)),
            const SizedBox(height: 10),
            KawaiiInput(placeholder: 'Enter your email...', btnLabel: 'Join',
              color: KawaiiColors.violetTop,
              icon: _ico(HeartPainter(fill: KawaiiCharacter.kira.primary,
                stroke: KawaiiCharacter.kira.primary), s: 13)),
          ])))),
          gap,
        ]);

      // ═══ CONTENT CARD ═══
      case 10:
        return Column(children: [
          entrance(RepaintBoundary(child: KawaiiCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SectionLabel('Content Card'),
            Container(
              padding: const EdgeInsets.all(KawaiiSpacing.xl),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(KawaiiBorderRadius.lg),
                gradient: LinearGradient(begin: const Alignment(-0.5, -0.5), end: const Alignment(0.5, 0.5),
                  colors: [mika.primary.withValues(alpha: 0.08),
                           KawaiiCharacter.sora.primary.withValues(alpha: 0.05)]),
                border: Border.all(color: mika.primary.withValues(alpha: 0.14), width: KawaiiBorderWidth.light)),
              child: Stack(children: [
                Positioned.fill(child: Container(margin: const EdgeInsets.all(3),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(13),
                    border: Border.all(color: const Color(0x66FFFFFF), width: KawaiiBorderWidth.thin)))),
                const Positioned(top: 10, right: 10, child: SparkleWidget(size: 8)),
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  KawaiiAvatar(icon: _ico(DressPainter(), s: 22),
                    color: mika.primary, accent: mika.accent, size: 46),
                  const SizedBox(width: KawaiiSpacing.lg),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Text(mika.name, style: kHeading(size: 15)),
                      const SizedBox(width: KawaiiSpacing.md),
                      KawaiiTag(mika.tagline!, color: mika.primary),
                    ]),
                    const SizedBox(height: KawaiiSpacing.sm),
                    Text(mika.description!,
                      style: kBody(size: 12.5).copyWith(height: 1.6)),
                    const SizedBox(height: 10),
                    KawaiiButton.pink('Chat', small: true,
                      i: _ico(ArrowPainter(color: KawaiiColors.pinkText), s: 11)),
                  ])),
                ]),
              ]),
            ),
          ])))),
          gap,
        ]);

      // ═══ NAVIGATION ═══
      case 11:
        return Column(children: [
          entrance(RepaintBoundary(child: KawaiiCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SectionLabel('Navigation'),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: KawaiiSpacing.xl, vertical: KawaiiSpacing.md),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(KawaiiBorderRadius.xl),
                gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
                  colors: [Color(0xE6FFFFFF), Color(0xCCFFF8FC)]),
                border: Border.all(color: KawaiiColors.cardBorder, width: KawaiiBorderWidth.medium),
                boxShadow: [KawaiiShadows.medium(KawaiiColors.cardBorder)]),
              child: Stack(children: [
                Positioned.fill(child: Container(margin: const EdgeInsets.all(3),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(KawaiiBorderRadius.md),
                    border: Border.all(color: const Color(0x80FFFFFF), width: KawaiiBorderWidth.thin)))),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('anison', style: kHeading(size: 15)),
                  Row(children: [
                    ...['Home', 'Browse'].map((t) => Padding(
                      padding: const EdgeInsets.only(right: KawaiiSpacing.lg),
                      child: GestureDetector(
                        onTap: () => KawaiiSoundEngine().play(KawaiiSound.tick),
                        child: Text(t, style: kBody(size: 11, weight: FontWeight.w800, color: KawaiiColors.muted))))),
                    KawaiiButton.pink('Sign Up', small: true),
                  ]),
                ]),
              ]),
            ),
          ])))),
          gap,
        ]);

      // ═══ SELECTION CONTROLS ═══
      case 12:
        return Column(children: [
          entrance(RepaintBoundary(child: KawaiiCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SectionLabel('Selection Controls'),
            _SelectionDemo(color: mika.primary),
          ])))),
          gap,
        ]);

      // ═══ SLIDER ═══
      case 13:
        return Column(children: [
          entrance(RepaintBoundary(child: KawaiiCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SectionLabel('Slider'),
            _SliderDemo(color: mika.primary),
            const SizedBox(height: KawaiiSpacing.lg),
            _SliderDemo(color: KawaiiCharacter.sora.primary),
          ])))),
          gap,
        ]);

      // ═══ TABS ═══
      case 14:
        return Column(children: [
          entrance(RepaintBoundary(child: KawaiiCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SectionLabel('Tabs'),
            _TabDemo(color: mika.primary),
          ])))),
          gap,
        ]);

      // ═══ LIST TILES ═══
      case 15:
        return Column(children: [
          entrance(RepaintBoundary(child: KawaiiCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SectionLabel('List Tiles'),
            KawaiiListTile(
              leading: KawaiiBadge(size: 36, interactive: false,
                bg: mika.primary.withValues(alpha: KawaiiOpacity.hint),
                border: mika.primary.withValues(alpha: KawaiiOpacity.muted),
                child: _ico(HeartPainter(), s: 16)),
              title: 'Favorites',
              subtitle: '24 items saved',
              trailing: KawaiiTag('New', color: mika.primary, interactive: false),
              onTap: () {}),
            const KawaiiDivider(),
            KawaiiListTile(
              leading: KawaiiBadge(size: 36, interactive: false,
                bg: KawaiiCharacter.sora.primary.withValues(alpha: KawaiiOpacity.hint),
                border: KawaiiCharacter.sora.primary.withValues(alpha: KawaiiOpacity.muted),
                child: _ico(MoonPainter(), s: 16)),
              title: 'Horoscope',
              subtitle: 'Mercury in retrograde',
              onTap: () {}),
            const KawaiiDivider(),
            KawaiiListTile(
              leading: KawaiiBadge(size: 36, interactive: false,
                bg: KawaiiCharacter.ren.primary.withValues(alpha: KawaiiOpacity.hint),
                border: KawaiiCharacter.ren.primary.withValues(alpha: KawaiiOpacity.muted),
                child: _ico(DumbbellPainter(), s: 16)),
              title: 'Workout Plan',
              subtitle: '3 sessions this week',
              onTap: () {}),
          ])))),
          gap,
        ]);

      // ═══ OVERLAYS ═══
      case 16:
        return Column(children: [
          entrance(RepaintBoundary(child: KawaiiCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SectionLabel('Overlays'),
            Wrap(spacing: KawaiiSpacing.wrapSpacing, runSpacing: KawaiiSpacing.wrapRunSpacing, children: [
              KawaiiButton.pink('Dialog', small: true,
                i: _ico(ChatBubblePainter(color: KawaiiColors.pinkText), s: 11),
                onTap: () => showKawaiiDialog(
                  context: context, title: 'Hello!',
                  content: Text('This is a kawaii dialog with glass treatment.',
                    style: kBody(size: 13, color: KawaiiColors.body).copyWith(height: 1.5)),
                  actions: [
                    KawaiiButton.green('Cancel', small: true,
                      onTap: () => Navigator.of(context).pop()),
                    KawaiiButton.pink('OK',
                      onTap: () => Navigator.of(context).pop()),
                  ])),
              KawaiiButton.violet('Bottom Sheet', small: true,
                onTap: () => showKawaiiBottomSheet(
                  context: context,
                  builder: (_) => SizedBox(height: 200,
                    child: Padding(padding: const EdgeInsets.all(KawaiiSpacing.xxl),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Bottom Sheet', style: kHeading(size: 18)),
                        const SizedBox(height: KawaiiSpacing.md),
                        Text('Drag down to dismiss.', style: kBody(color: KawaiiColors.muted)),
                      ]))))),
              KawaiiButton.green('Snackbar', small: true,
                onTap: () => showKawaiiSnackbar(
                  context: context, message: 'Outfit saved!',
                  type: KawaiiSnackbarType.success)),
            ]),
          ])))),
          gap,
        ]);

      // ═══ SOUND PALETTE ═══
      case 17:
        return Column(children: [
          entrance(RepaintBoundary(child: KawaiiCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SectionLabel('Sound Palette'),
            Text('Every sound is synthesized from detuned oscillator clusters (body) + sine harmonics (shimmer). Tap each to hear — tap the same one 3x fast to hear the micro-variation.',
              style: kBody(size: 12, color: KawaiiColors.muted).copyWith(height: 1.6)),
            const SizedBox(height: KawaiiSpacing.xl),
            ..._soundItems.map((s) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: RepaintBoundary(child: SoundCard(label: s.label, id: s.id, desc: s.desc,
                color: s.color, accent: s.accent, sound: s.sound)))),
            const SizedBox(height: 6),
            const Row(children: [
              SoundPrinciple(title: 'Pitch down', desc: 'press/settle', color: Color(0xFFF08CAE)),
              SizedBox(width: KawaiiSpacing.md),
              SoundPrinciple(title: 'Pitch up', desc: 'success/reward', color: Color(0xFF66BB6A)),
            ]),
            const SizedBox(height: KawaiiSpacing.md),
            const Row(children: [
              SoundPrinciple(title: 'Micro-variation', desc: 'every tap differs', color: Color(0xFF7C4DFF)),
              SizedBox(width: KawaiiSpacing.md),
              SoundPrinciple(title: 'No sub-bass', desc: 'light, not heavy', color: Color(0xFFFFB74D)),
            ]),
          ])))),
          SizedBox(height: KawaiiSpacing.huge),
        ]);

      default:
        return const SizedBox.shrink();
    }
  }
}

class _SoundDef {
  final String label, id, desc;
  final Color color, accent;
  final KawaiiSound sound;
  const _SoundDef(this.label, this.id, this.desc, this.color, this.accent, this.sound);
}

const _soundItems = [
  _SoundDef('Boop', 'boop', 'Standard button press. Ceramic egg tap — solid but disappears fast.',
    Color(0xFFF08CAE), Color(0xFFFFC0D8), KawaiiSound.boop),
  _SoundDef('Pop', 'pop', 'Hero CTA. Same material but lower, heavier — more mass to compress.',
    Color(0xFFAB47BC), Color(0xFFCE93D8), KawaiiSound.pop),
  _SoundDef('Tick', 'tick', 'Counter tick, nav hover. Tiniest bead click — body only, no shimmer.',
    Color(0xFF42A5F5), Color(0xFF90CAF9), KawaiiSound.tick),
  _SoundDef('Toggle', 'toggle', 'Switch snap. Slightly crisper — the moment it locks into position.',
    Color(0xFF66BB6A), Color(0xFFA5D6A7), KawaiiSound.toggle),
  _SoundDef('Chime', 'chime', 'Card hover, positive arrival. Warm body + shimmer harmonics cascading in.',
    Color(0xFFFFB74D), Color(0xFFFFE082), KawaiiSound.chime),
  _SoundDef('Send', 'send', 'Message sent. Upward shimmer — something leaving your hands.',
    Color(0xFFF06292), Color(0xFFF8BBD0), KawaiiSound.send),
  _SoundDef('Notification', 'notif', 'Double chime. Two tones staggered — something arriving, asking for attention.',
    Color(0xFF7C4DFF), Color(0xFFD1C4E9), KawaiiSound.notif),
  _SoundDef('Reward', 'reward', 'Ascending cascade. Music-box character — shimmer accumulates and brightens.',
    Color(0xFFD4940C), Color(0xFFFFE082), KawaiiSound.reward),
];

// ━━━ Stateful demos for new widgets ━━━

class _SelectionDemo extends StatefulWidget {
  final Color color;
  const _SelectionDemo({required this.color});
  @override
  State<_SelectionDemo> createState() => _SelectionDemoState();
}

class _SelectionDemoState extends State<_SelectionDemo> {
  bool _check1 = true, _check2 = false, _check3 = false;
  int _radio = 0;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Checkboxes', style: kBody(size: 12, weight: FontWeight.w800, color: KawaiiColors.muted)),
      const SizedBox(height: KawaiiSpacing.md),
      Row(children: [
        KawaiiCheckbox(value: _check1, color: widget.color,
          onChanged: (v) => setState(() => _check1 = v)),
        const SizedBox(width: KawaiiSpacing.md),
        Text('Notifications', style: kBody(size: 13, color: KawaiiColors.heading)),
        const SizedBox(width: KawaiiSpacing.xxl),
        KawaiiCheckbox(value: _check2, color: KawaiiCharacter.sora.primary,
          onChanged: (v) => setState(() => _check2 = v)),
        const SizedBox(width: KawaiiSpacing.md),
        Text('Sound', style: kBody(size: 13, color: KawaiiColors.heading)),
      ]),
      const SizedBox(height: KawaiiSpacing.md),
      Row(children: [
        KawaiiCheckbox(value: _check3, color: KawaiiCharacter.ren.primary,
          onChanged: (v) => setState(() => _check3 = v)),
        const SizedBox(width: KawaiiSpacing.md),
        Text('Dark Mode', style: kBody(size: 13, color: KawaiiColors.heading)),
      ]),
      const SizedBox(height: KawaiiSpacing.xl),
      Text('Radio Buttons', style: kBody(size: 12, weight: FontWeight.w800, color: KawaiiColors.muted)),
      const SizedBox(height: KawaiiSpacing.md),
      for (final (i, label) in ['Sakura', 'Ocean', 'Forest'].indexed)
        Padding(padding: const EdgeInsets.only(bottom: KawaiiSpacing.md),
          child: Row(children: [
            KawaiiRadio<int>(value: i, groupValue: _radio, color: widget.color,
              onChanged: (v) => setState(() => _radio = v)),
            const SizedBox(width: KawaiiSpacing.md),
            Text(label, style: kBody(size: 13, color: KawaiiColors.heading)),
          ])),
    ]);
  }
}

class _SliderDemo extends StatefulWidget {
  final Color color;
  const _SliderDemo({required this.color});
  @override
  State<_SliderDemo> createState() => _SliderDemoState();
}

class _SliderDemoState extends State<_SliderDemo> {
  double _val = 0.6;
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(child: KawaiiSlider(value: _val, color: widget.color,
        onChanged: (v) => setState(() => _val = v))),
      const SizedBox(width: KawaiiSpacing.lg),
      Text('${(_val * 100).toInt()}%', style: kBody(size: 13, weight: FontWeight.w800, color: widget.color)),
    ]);
  }
}

class _TabDemo extends StatefulWidget {
  final Color color;
  const _TabDemo({required this.color});
  @override
  State<_TabDemo> createState() => _TabDemoState();
}

class _TabDemoState extends State<_TabDemo> {
  int _tab = 0;
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      KawaiiTabBar(
        tabs: const ['Style', 'Fitness', 'Astro'],
        selectedIndex: _tab, color: widget.color,
        onChanged: (i) => setState(() => _tab = i)),
      const SizedBox(height: KawaiiSpacing.lg),
      AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: Text(
          ['Mika curates your outfits', 'Ren tracks your gains', 'Sora reads the stars'][_tab],
          key: ValueKey(_tab),
          style: kBody(size: 13, color: KawaiiColors.muted))),
    ]);
  }
}
