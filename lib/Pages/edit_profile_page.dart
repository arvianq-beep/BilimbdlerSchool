import 'package:flutter/material.dart';
import 'package:flutter_bilimdler/Auth/auth_service.dart';
import 'home_page.dart';
import '../l10n/app_localizations.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final firstNameC = TextEditingController();
  final lastNameC = TextEditingController();
  bool saving = false;

  @override
  void initState() {
    super.initState();
    _prefill();
  }

  Future<void> _prefill() async {
    try {
      final data = await AuthService.getCurrentProfile();
      if (!mounted || data == null) return;
      firstNameC.text = (data['firstName'] ?? '') as String;
      lastNameC.text = (data['lastName'] ?? '') as String;
      setState(() {});
    } catch (_) {}
  }

  @override
  void dispose() {
    firstNameC.dispose();
    lastNameC.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (saving) return;
    setState(() => saving = true);
    final t = AppLocalizations.of(context)!;

    try {
      final f = firstNameC.text.trim();
      final l = lastNameC.text.trim();

      if (f.isEmpty && l.isEmpty) {
        setState(() => saving = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(t.enterNameOrSurname)));
        return;
      }

      await AuthService.updateProfile(
        firstName: f.isEmpty ? null : f,
        lastName: l.isEmpty ? null : l,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.saved)));

      // В домашнюю, очищая стек
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
        (route) => false,
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.unknownError)));
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(t.profileTitle)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: firstNameC,
              decoration: InputDecoration(labelText: t.firstName),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: lastNameC,
              decoration: InputDecoration(labelText: t.lastName),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: saving ? null : _save,
                child: Text(saving ? '...' : t.save),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              t.youCanSearchByName,
              style: TextStyle(color: cs.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}
