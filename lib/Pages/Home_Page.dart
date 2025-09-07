import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_bilimdler/Auth/Login_or_Register.dart';
import 'package:flutter_bilimdler/Themes/Themes_Provider.dart';
import 'package:flutter_bilimdler/l10n/app_localizations.dart';
import 'package:flutter_bilimdler/l10n/language_button.dart';
import 'edit_profile_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginOrRegister()),
      );
    }
  }

  String _shortUid(String uid, {int len = 8}) {
    if (uid.length <= len) return uid.toUpperCase();
    return uid.substring(uid.length - len).toUpperCase();
  }

  void _showAccountSheet(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      backgroundColor: cs.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: docRef.snapshots(),
          builder: (context, snap) {
            final data = snap.data?.data() ?? {};

            final fullName = (data['name'] as String?)?.trim();
            final first = (data['firstName'] as String?)?.trim();
            final last = (data['lastName'] as String?)?.trim();
            final builtName = (fullName?.isNotEmpty == true)
                ? fullName!
                : [first ?? '', last ?? ''].join(' ').trim();

            final isGuest = data['guest'] == true;
            final guestId = data['guestId'] as String?;
            final uid = user.uid;

            final primaryLine = builtName.isNotEmpty
                ? builtName
                : (isGuest && guestId != null)
                ? t.guestIdDisplay(guestId)
                : (user.email ?? '');

            final idText = isGuest && guestId != null
                ? t.guestIdDisplay(guestId)
                : t.userIdDisplay(_shortUid(uid));

            // инициалы для аватарки
            String initials = '';
            if (builtName.isNotEmpty) {
              final parts = builtName.split(RegExp(r'\s+'));
              initials = parts
                  .take(2)
                  .map((p) => p.isNotEmpty ? p[0] : '')
                  .join()
                  .toUpperCase();
            } else if (user.email != null && user.email!.isNotEmpty) {
              initials = user.email![0].toUpperCase();
            } else if (guestId != null && guestId.isNotEmpty) {
              initials = guestId[0].toUpperCase();
            } else {
              initials = '?';
            }

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
                      color: cs.onSurface.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 26,
                        backgroundColor: cs.primaryContainer,
                        child: Text(
                          initials,
                          style: TextStyle(
                            color: cs.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (primaryLine.isNotEmpty)
                              Text(
                                primaryLine,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: cs.onSurface,
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
                                color: cs.onSurfaceVariant,
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
                        Navigator.pop(context); // закрыть лист
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EditProfilePage(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.edit),
                      label: Text(t.profileTitle),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = context.watch<ThemesProvider>();
    final t = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const LoginOrRegister();
    }

    return Scaffold(
      backgroundColor: cs.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          t.brand,
          style: TextStyle(
            color: cs.inversePrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // иконка аккаунта → открывает лист с именем/ID и кнопкой редактирования
          IconButton(
            tooltip: t.profileTitle,
            onPressed: () => _showAccountSheet(context),
            icon: Icon(Icons.account_circle, color: cs.inversePrimary),
          ),
          // переключатель темы
          IconButton(
            tooltip: 'Toggle theme',
            onPressed: appTheme.toggleThemes,
            icon: Icon(
              appTheme.isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
              color: cs.inversePrimary,
            ),
          ),
          // переключатель языка
          const LanguageButton(),
          // выход
          IconButton(
            tooltip: t.signOut,
            onPressed: () => logout(context),
            icon: Icon(Icons.logout, color: cs.inversePrimary),
          ),
        ],
      ),
      // контент не нужен — всё по аккаунту скрыто под иконкой
      body: const SizedBox.shrink(),
    );
  }
}
