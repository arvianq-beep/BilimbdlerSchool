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

  InputDecoration _decoration(BuildContext context, String label) {
    final cs = Theme.of(context).colorScheme;
    return InputDecoration(
      labelText: label,
      filled: true,
      // делаем поля «чуть светлее», как ты задал в dark theme
      fillColor: cs.tertiary,
      labelStyle: TextStyle(color: cs.onSurfaceVariant),
      hintStyle: TextStyle(color: cs.onSurfaceVariant),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: cs.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: cs.primary, width: 1.6),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: cs.background, // такой же глубокий фон, как на HomePage
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          t.profileTitle,
          style: TextStyle(
            color: cs.inversePrimary, // как на твоём HomePage
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: cs.inversePrimary),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: firstNameC,
                style: TextStyle(color: cs.onSurface),
                decoration: _decoration(context, t.firstName),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: lastNameC,
                style: TextStyle(color: cs.onSurface),
                decoration: _decoration(context, t.lastName),
                onSubmitted: (_) => _save(),
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
      ),
    );
  }
}
