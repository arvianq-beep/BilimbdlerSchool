import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_bilimdler/Auth/Login_or_Register.dart';
import 'package:flutter_bilimdler/Themes/Themes_Provider.dart';
import 'package:flutter_bilimdler/l10n/app_localizations.dart';
import 'package:flutter_bilimdler/l10n/language_button.dart';
import 'edit_profile_page.dart';

/// ---------- короткие хелперы ----------
extension BuildX on BuildContext {
  ColorScheme get cs => Theme.of(this).colorScheme;
  AppLocalizations get t => AppLocalizations.of(this)!;
}

DocumentReference<Map<String, dynamic>> _userDoc() => FirebaseFirestore.instance
    .collection('users')
    .doc(FirebaseAuth.instance.currentUser!.uid);

const _subjects = [
  'География',
  'История',
  'Биология',
  'Физика',
  'Химия',
  'Литература',
];
const _subjectKey = {
  'География': 'geo',
  'История': 'hist',
  'Биология': 'bio',
  'Физика': 'phys',
  'Химия': 'chem',
  'Литература': 'lit',
};

/// общий показ **реактивного** скролл-листа (перерисовывается при смене темы)
Future<void> _showSheet(
  BuildContext ctx,
  List<Widget> Function(BuildContext innerCtx) children, {
  double initial = .5,
}) {
  return showModalBottomSheet(
    context: ctx,
    isScrollControlled: true,
    backgroundColor: Colors.transparent, // сам роут прозрачный
    barrierColor: Colors.black54,
    builder: (_) => Consumer<ThemesProvider>(
      builder: (innerCtx, __, ___) {
        final cs = Theme.of(innerCtx).colorScheme;
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: Container(
            color: cs.surface, // фон берём из ТЕКУЩЕЙ темы
            child: DraggableScrollableSheet(
              expand: false,
              initialChildSize: initial,
              minChildSize: .4,
              maxChildSize: .9,
              builder: (c, sc) => ListView(
                controller: sc,
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: cs.onSurface.withOpacity(.2),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  ...children(innerCtx),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}

/// ---------- главный экран ----------
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> _logout(BuildContext c) async {
    await FirebaseAuth.instance.signOut();
    if (c.mounted) {
      Navigator.pushReplacement(
        c,
        MaterialPageRoute(builder: (_) => const LoginOrRegister()),
      );
    }
  }

  void _showAccountSheet(BuildContext c) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final docRef = _userDoc();

    showModalBottomSheet(
      context: c,
      backgroundColor: c.cs.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: docRef.snapshots(),
        builder: (_, snap) {
          final data = snap.data?.data() ?? {};
          final full = (data['name'] as String?)?.trim();
          final first = (data['firstName'] as String?)?.trim();
          final last = (data['lastName'] as String?)?.trim();
          final name = (full?.isNotEmpty == true)
              ? full!
              : [first ?? '', last ?? ''].join(' ').trim();
          final guest = data['guest'] == true;
          final guestId = data['guestId'] as String?;
          final uid = user.uid;
          final primary = name.isNotEmpty
              ? name
              : guest && guestId != null
              ? c.t.guestIdDisplay(guestId)
              : (user.email ?? '');
          final idText = guest && guestId != null
              ? c.t.guestIdDisplay(guestId)
              : c.t.userIdDisplay(uid.substring(uid.length - 8).toUpperCase());

          String initials = name.isNotEmpty
              ? name
                    .split(RegExp(r'\s+'))
                    .take(2)
                    .map((p) => p[0])
                    .join()
                    .toUpperCase()
              : (user.email?.isNotEmpty == true
                    ? user.email![0].toUpperCase()
                    : (guestId?.isNotEmpty == true
                          ? guestId![0].toUpperCase()
                          : '?'));

          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: c.cs.onSurface.withOpacity(.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: c.cs.primaryContainer,
                      child: Text(
                        initials,
                        style: TextStyle(
                          color: c.cs.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (primary.isNotEmpty)
                            Text(
                              primary,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: c.cs.onSurface,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          const SizedBox(height: 4),
                          Text(
                            idText,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: c.cs.onSurfaceVariant,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {
                      Navigator.pop(c);
                      Navigator.push(
                        c,
                        MaterialPageRoute(
                          builder: (_) => const EditProfilePage(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit),
                    label: Text(c.t.profileTitle),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _openSettings(BuildContext c) async {
    final docRef = _userDoc();
    await _showSheet(c, (inner) {
      return [
        Row(
          children: [
            Icon(Icons.settings, color: inner.cs.onSurfaceVariant),
            const SizedBox(width: 8),
            Text(
              inner.t.settings,
              style: TextStyle(
                color: inner.cs.onSurface,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: docRef.snapshots(),
          builder: (_, snap) {
            final m =
                (snap.data?.data()?['settings'] as Map<String, dynamic>?) ?? {};
            final sound = (m['sound'] as bool?) ?? true;
            final vibro = (m['vibration'] as bool?) ?? true;
            return Column(
              children: [
                SwitchListTile(
                  value: sound,
                  onChanged: (v) => docRef.set({
                    'settings': {'sound': v},
                  }, SetOptions(merge: true)),
                  title: Text(inner.t.sound),
                  activeColor: inner.cs.primary,
                  activeTrackColor: inner.cs.primaryContainer,
                  contentPadding: EdgeInsets.zero,
                ),
                SwitchListTile(
                  value: vibro,
                  onChanged: (v) => docRef.set({
                    'settings': {'vibration': v},
                  }, SetOptions(merge: true)),
                  title: Text(inner.t.vibration),
                  activeColor: inner.cs.primary,
                  activeTrackColor: inner.cs.primaryContainer,
                  contentPadding: EdgeInsets.zero,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.dark_mode,
                      color: inner.cs.onSurfaceVariant,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      inner.t.theme,
                      style: TextStyle(color: inner.cs.onSurface),
                    ),
                    const Spacer(),
                    Builder(
                      builder: (ctx) {
                        final appTheme = ctx.read<ThemesProvider>();
                        return Switch(
                          value: appTheme.isDarkMode,
                          onChanged: (_) => appTheme.toggleThemes(),
                          activeColor: inner.cs.primary,
                          activeTrackColor: inner.cs.primaryContainer,
                        );
                      },
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ];
    }, initial: .55);
  }

  Future<void> _openSubjects(BuildContext c) async {
    final docRef = _userDoc();
    await _showSheet(c, (inner) {
      return [
        Text(
          inner.t.chooseSubject,
          style: TextStyle(
            color: inner.cs.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _subjects.map((s) {
            return InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () async {
                await docRef.set({
                  'selectedSubjectKey': _subjectKey[s] ?? s.toLowerCase(),
                  'selectedSubject': s,
                }, SetOptions(merge: true));
                if (c.mounted) {
                  Navigator.pop(c);
                  ScaffoldMessenger.of(c).showSnackBar(
                    SnackBar(content: Text('${inner.t.saved}: $s')),
                  );
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: inner.cs.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: inner.cs.outlineVariant),
                ),
                child: Text(s, style: TextStyle(color: inner.cs.onSurface)),
              ),
            );
          }).toList(),
        ),
      ];
    });
  }

  Future<void> _startGame(BuildContext c) async {
    final snap = await _userDoc().get();
    final data = snap.data() ?? {};
    final key = (data['selectedSubjectKey'] as String?)?.trim();
    final label = (data['selectedSubject'] as String?)?.trim();
    if ((key == null || key.isEmpty) && (label == null || label.isEmpty)) {
      ScaffoldMessenger.of(
        c,
      ).showSnackBar(SnackBar(content: Text(c.t.chooseSubject)));
      return _openSubjects(c);
    }
    _goToSubject(c, key ?? label!, label ?? key!);
  }

  void _goToSubject(BuildContext c, String key, String label) {
    Navigator.push(
      c,
      MaterialPageRoute(builder: (_) => SubjectScreen(title: label)),
    );
  }

  Widget _logoCircle(BuildContext c) => SizedBox(
    width: 190,
    height: 190,
    child: ClipOval(
      child: Image.asset('lib/Images/Logo.png', fit: BoxFit.cover),
    ),
  );

  Widget _rightButtons(BuildContext c) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      SizedBox(
        height: 56,
        child: FilledButton.icon(
          onPressed: () => _startGame(c),
          icon: const Icon(Icons.play_arrow),
          label: Text(c.t.startGame),
        ),
      ),
      const SizedBox(height: 12),
      SizedBox(
        height: 56,
        child: FilledButton.icon(
          onPressed: () => _openSubjects(c),
          icon: const Icon(Icons.menu_book),
          label: Text(c.t.subjects),
        ),
      ),
      const SizedBox(height: 12),
      SizedBox(
        height: 48,
        child: OutlinedButton.icon(
          onPressed: () => _openSettings(c),
          icon: const Icon(Icons.settings),
          label: Text(c.t.settings),
        ),
      ),
    ],
  );

  @override
  Widget build(BuildContext c) {
    final appTheme = c.watch<ThemesProvider>();
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const LoginOrRegister();

    return Scaffold(
      backgroundColor: c.cs.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          c.t.brand,
          style: TextStyle(
            color: c.cs.inversePrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          const LanguageButton(), // язык меняется только здесь
          IconButton(
            tooltip: c.t.profileTitle,
            onPressed: () => _showAccountSheet(c),
            icon: Icon(Icons.account_circle, color: c.cs.inversePrimary),
          ),
          IconButton(
            tooltip: c.t.toggleTheme,
            onPressed: appTheme.toggleThemes,
            icon: Icon(
              appTheme.isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
              color: c.cs.inversePrimary,
            ),
          ),
          IconButton(
            tooltip: c.t.signOut,
            onPressed: () => _logout(c),
            icon: Icon(Icons.logout, color: c.cs.inversePrimary),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _logoCircle(c),
                const SizedBox(width: 16),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: _rightButtons(c),
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

/// простая заглушка экрана предмета (отдельный топ-левел)
class SubjectScreen extends StatelessWidget {
  final String title;
  const SubjectScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          'Coming soon: $title',
          style: TextStyle(color: context.cs.onSurface, fontSize: 18),
        ),
      ),
    );
  }
}
