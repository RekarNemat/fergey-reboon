import 'dart:math';
import 'package:flutter/material.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';
import '../pages/settings_page.dart';

/// Account Tab ("هەژمار") from Voice 2 & Image 2 + HTML Profile/Auth system:
/// - Guest mode: Sign In & Sign Up with password visibility toggle
/// - Logged-in mode: Avatar, progress bar (65%), stats, Edit full name (First/Middle/Last)
///   & Username, Change Password, Change Email with 6-digit verification code, Delete Account ("Delete"), Logout.
class AccountTab extends StatefulWidget {
  final AppState appState;

  const AccountTab({super.key, required this.appState});

  @override
  State<AccountTab> createState() => _AccountTabState();
}

class _AccountTabState extends State<AccountTab> {
  bool _isSignUpMode = false;

  // Sign In controllers
  final _signInEmailCtrl = TextEditingController();
  final _signInPassCtrl = TextEditingController();
  bool _obscureSignIn = true;

  // Sign Up controllers
  final _signUpNameCtrl = TextEditingController();
  final _signUpUsernameCtrl = TextEditingController();
  final _signUpEmailCtrl = TextEditingController();
  final _signUpPassCtrl = TextEditingController();
  final _signUpConfirmCtrl = TextEditingController();
  bool _obscureSignUp1 = true;
  bool _obscureSignUp2 = true;

  // Profile Edit controllers
  final _firstCtrl = TextEditingController();
  final _midCtrl = TextEditingController();
  final _lastCtrl = TextEditingController();
  final _userCtrl = TextEditingController();

  // Password Change controllers
  final _curPassCtrl = TextEditingController();
  final _newPassCtrl = TextEditingController();
  final _confPassCtrl = TextEditingController();

  // Email Verify
  final _newEmailCtrl = TextEditingController();
  final _verifyCodeCtrl = TextEditingController();
  String _generatedCode = '';
  bool _awaitingVerify = false;

  // Delete Account Prompt
  bool _showDeletePrompt = false;
  final _deleteCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _syncControllersFromState();
  }

  void _syncControllersFromState() {
    final s = widget.appState;
    _firstCtrl.text = s.firstName;
    _midCtrl.text = s.middleName;
    _lastCtrl.text = s.lastName;
    _userCtrl.text = s.username;
  }

  @override
  void dispose() {
    _signInEmailCtrl.dispose();
    _signInPassCtrl.dispose();
    _signUpNameCtrl.dispose();
    _signUpUsernameCtrl.dispose();
    _signUpEmailCtrl.dispose();
    _signUpPassCtrl.dispose();
    _signUpConfirmCtrl.dispose();
    _firstCtrl.dispose();
    _midCtrl.dispose();
    _lastCtrl.dispose();
    _userCtrl.dispose();
    _curPassCtrl.dispose();
    _newPassCtrl.dispose();
    _confPassCtrl.dispose();
    _newEmailCtrl.dispose();
    _verifyCodeCtrl.dispose();
    _deleteCtrl.dispose();
    super.dispose();
  }

  void _handleSignIn() {
    final email = _signInEmailCtrl.text.trim();
    final pass = _signInPassCtrl.text.trim();
    if (email.isEmpty || pass.isEmpty) {
      showReboonToast(context, 'تکایە هەموو خانەکان پڕ بکەوە');
      return;
    }
    widget.appState.signIn(emailInput: email);
    _syncControllersFromState();
    showReboonToast(context, 'بەخێربێیت! بە سەرکەوتوویی چوویتەژوورەوە');
  }

  void _handleSignUp() {
    final name = _signUpNameCtrl.text.trim();
    final user = _signUpUsernameCtrl.text.trim();
    final email = _signUpEmailCtrl.text.trim();
    final pass = _signUpPassCtrl.text.trim();
    final conf = _signUpConfirmCtrl.text.trim();

    if (name.isEmpty || user.isEmpty || email.isEmpty || pass.isEmpty) {
      showReboonToast(context, 'تکایە هەموو خانەکان پڕ بکەوە');
      return;
    }
    if (pass != conf) {
      showReboonToast(context, 'تێپەڕەوشەکان وەک یەک نین!');
      return;
    }

    widget.appState.signUp(
      nameInput: name,
      usernameInput: user,
      emailInput: email,
      passwordInput: pass,
    );
    _syncControllersFromState();
    showReboonToast(context, 'هەژمارەکەت دروست کرا! بەخێربێیت');
  }

  void _saveProfile() {
    if (_firstCtrl.text.trim().isEmpty) {
      showReboonToast(context, 'ناوی یەکەم پێویستە');
      return;
    }
    widget.appState.updateProfile(
      first: _firstCtrl.text.trim(),
      middle: _midCtrl.text.trim(),
      last: _lastCtrl.text.trim(),
      user: _userCtrl.text.trim(),
    );
    showReboonToast(context, 'زانیارییەکانی پڕۆفایل نوێکرانەوە');
  }

  void _changePassword() {
    final cur = _curPassCtrl.text;
    final nw = _newPassCtrl.text;
    final cf = _confPassCtrl.text;

    if (cur.isEmpty || nw.isEmpty || cf.isEmpty) {
      showReboonToast(context, 'هەموو خانەکانی تێپەڕەوشە پڕ بکەوە');
      return;
    }
    if (cur != widget.appState.password) {
      showReboonToast(context, 'تێپەڕەوشەی ئێستا هەڵەیە!');
      return;
    }
    if (nw != cf) {
      showReboonToast(context, 'تێپەڕەوشە نوێیەکان وەک یەک نین!');
      return;
    }
    if (nw.length < 4) {
      showReboonToast(context, 'تێپەڕەوشە دەبێت لانیکەم ٤ پیت بێت');
      return;
    }
    widget.appState.updatePassword(nw);
    _curPassCtrl.clear();
    _newPassCtrl.clear();
    _confPassCtrl.clear();
    showReboonToast(context, 'تێپەڕەوشە بە سەرکەوتوویی گۆڕدرا');
  }

  void _sendVerifyCode() {
    final mail = _newEmailCtrl.text.trim();
    if (mail.isEmpty || !mail.contains('@')) {
      showReboonToast(context, 'تکایە ئیمەیڵێکی دروست بنووسە');
      return;
    }
    final code = (100000 + Random().nextInt(900000)).toString();
    setState(() {
      _generatedCode = code;
      _awaitingVerify = true;
      _verifyCodeCtrl.clear();
    });
    showReboonToast(context, 'کۆدی پشتڕاستکردنەوە نێردرا: $code');
  }

  void _confirmVerifyCode() {
    if (_verifyCodeCtrl.text.trim() != _generatedCode) {
      showReboonToast(context, 'کۆدەکە هەڵەیە! دووبارە هەوڵ بدەوە');
      return;
    }
    widget.appState.updateEmail(_newEmailCtrl.text.trim());
    setState(() {
      _awaitingVerify = false;
      _newEmailCtrl.clear();
      _verifyCodeCtrl.clear();
    });
    showReboonToast(context, 'ئیمەیڵ بە سەرکەوتوویی گۆڕدرا');
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.appState;
    return AnimatedBuilder(
      animation: s,
      builder: (context, _) {
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: s.isLoggedIn
                ? _buildLoggedInAccount(context, s)
                : _buildAuthScreen(context, s),
          ),
        );
      },
    );
  }

  Widget _buildAuthScreen(BuildContext context, AppState s) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.teal800, AppColors.teal900],
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 34,
                backgroundColor: Colors.white24,
                child: Icon(Icons.person_rounded, color: AppColors.gold, size: 36),
              ),
              const SizedBox(height: 12),
              const Text(
                'هەژماری فێرخواز لە فێرگەی ڕێبوون',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'چوونەژوورەوە یان هەژمارێک دروست بکە بۆ پاشەکەوتکردنی وانە و ئیجازەکانت',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontSize: 12.5,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: () => setState(() => _isSignUpMode = false),
                      style: FilledButton.styleFrom(
                        backgroundColor:
                            !_isSignUpMode ? AppColors.gold : Colors.white12,
                        foregroundColor:
                            !_isSignUpMode ? AppColors.teal900 : Colors.white,
                      ),
                      child: const Text('چوونەژوورەوە'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton(
                      onPressed: () => setState(() => _isSignUpMode = true),
                      style: FilledButton.styleFrom(
                        backgroundColor:
                            _isSignUpMode ? AppColors.gold : Colors.white12,
                        foregroundColor:
                            _isSignUpMode ? AppColors.teal900 : Colors.white,
                      ),
                      child: const Text('دروستکردنی هەژمار'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : const Color(0xFFE5E7EB),
            ),
          ),
          child: !_isSignUpMode
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'چوونەژوورەوە بۆ هەژمارەکەت',
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: _signInEmailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      textDirection: TextDirection.ltr,
                      decoration: const InputDecoration(
                        labelText: 'ئیمەیڵ',
                        hintText: 'm.reboon@example.com',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _signInPassCtrl,
                      obscureText: _obscureSignIn,
                      textDirection: TextDirection.ltr,
                      decoration: InputDecoration(
                        labelText: 'تێپەڕەوشە',
                        suffixIcon: IconButton(
                          onPressed: () =>
                              setState(() => _obscureSignIn = !_obscureSignIn),
                          icon: Icon(
                            _obscureSignIn
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: _handleSignIn,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.teal700,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text('چوونەژوورەوە'),
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton(
                      onPressed: () {
                        s.signIn(emailInput: 'm.reboon@example.com');
                        _syncControllersFromState();
                        showReboonToast(
                          context,
                          'بەخێربێیت محەمەد ڕێبوونی!',
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text('تاقیکردنەوەی خێرا وەک فێرخواز (محەمەد ڕێبوونی)'),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'دروستکردنی هەژماری نوێ',
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: _signUpNameCtrl,
                      decoration: const InputDecoration(labelText: 'ناوی تەواو'),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _signUpUsernameCtrl,
                      textDirection: TextDirection.ltr,
                      decoration: const InputDecoration(
                        labelText: 'ناوی بەکارهێنەر (Username)',
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _signUpEmailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      textDirection: TextDirection.ltr,
                      decoration: const InputDecoration(labelText: 'ئیمەیڵ'),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _signUpPassCtrl,
                      obscureText: _obscureSignUp1,
                      textDirection: TextDirection.ltr,
                      decoration: InputDecoration(
                        labelText: 'تێپەڕەوشە',
                        suffixIcon: IconButton(
                          onPressed: () =>
                              setState(() => _obscureSignUp1 = !_obscureSignUp1),
                          icon: Icon(
                            _obscureSignUp1
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _signUpConfirmCtrl,
                      obscureText: _obscureSignUp2,
                      textDirection: TextDirection.ltr,
                      decoration: InputDecoration(
                        labelText: 'دووبارەکردنەوەی تێپەڕەوشە',
                        suffixIcon: IconButton(
                          onPressed: () =>
                              setState(() => _obscureSignUp2 = !_obscureSignUp2),
                          icon: Icon(
                            _obscureSignUp2
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: _handleSignUp,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.teal700,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text('دروستکردنی هەژمار'),
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  Widget _buildLoggedInAccount(BuildContext context, AppState s) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Profile Header Banner matching HTML Profile Dropdown
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.teal700, AppColors.teal900],
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundColor: Colors.white24,
                        child: Text(
                          s.initials,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const Positioned(
                        bottom: 2,
                        left: 2,
                        child: CircleAvatar(
                          radius: 7,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 5,
                            backgroundColor: Color(0xFF22C55E),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          s.fullName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          s.email,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Text(
                            'فێرخوازی چالاک',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SettingsPage(
                          appState: s,
                          onGoToAccount: () {},
                        ),
                      ),
                    ),
                    icon: const Icon(Icons.settings_rounded, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'پێشکەوتنی گشتی',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  Text(
                    '٦٥٪',
                    style: TextStyle(
                      color: AppColors.amber400,
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: const LinearProgressIndicator(
                  value: 0.65,
                  minHeight: 7,
                  backgroundColor: Colors.white24,
                  color: AppColors.gold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _QuickStat(
                    value: toKurdishDigits(s.completedLessonsTotalCount),
                    label: 'وانەی تەواو',
                  ),
                  _QuickStat(value: '٧', label: 'ڕۆژ بەردەوام'),
                  _QuickStat(value: '١', label: 'ئیجازە'),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),

        // Edit Full Name & Username
        _ProfileSectionCard(
          title: '👤 ناوی تەواو و ناوی بەکارهێنەر',
          color: AppColors.teal700,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _firstCtrl,
                      decoration: const InputDecoration(labelText: 'ناوی یەکەم'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _midCtrl,
                      decoration: const InputDecoration(labelText: 'ناوی دووەم'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _lastCtrl,
                      decoration: const InputDecoration(labelText: 'ناوی سێیەم'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _userCtrl,
                textDirection: TextDirection.ltr,
                decoration: const InputDecoration(labelText: 'یوزەرنەیم (@)'),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _saveProfile,
                  style: FilledButton.styleFrom(backgroundColor: AppColors.teal700),
                  child: const Text('پاشەکەوتکردنی زانیارییەکان'),
                ),
              ),
            ],
          ),
        ),

        // Change Password
        _ProfileSectionCard(
          title: '🔒 گۆڕینی تێپەڕەوشە',
          color: AppColors.amber600,
          child: Column(
            children: [
              TextField(
                controller: _curPassCtrl,
                obscureText: true,
                textDirection: TextDirection.ltr,
                decoration: const InputDecoration(labelText: 'تێپەڕەوشەی ئێستا'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _newPassCtrl,
                obscureText: true,
                textDirection: TextDirection.ltr,
                decoration: const InputDecoration(labelText: 'تێپەڕەوشەی نوێ'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _confPassCtrl,
                obscureText: true,
                textDirection: TextDirection.ltr,
                decoration: const InputDecoration(
                  labelText: 'دووبارەکردنەوەی تێپەڕەوشەی نوێ',
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _changePassword,
                  style: FilledButton.styleFrom(backgroundColor: AppColors.amber600),
                  child: const Text('گۆڕینی تێپەڕەوشە'),
                ),
              ),
            ],
          ),
        ),

        // Change Email with 6-digit verification code (from HTML)
        _ProfileSectionCard(
          title: '✉️ گۆڕینی ئیمەیڵ',
          color: AppColors.rose600,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'ئیمەیڵی ئێستا: ${s.email}',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _newEmailCtrl,
                keyboardType: TextInputType.emailAddress,
                textDirection: TextDirection.ltr,
                decoration: const InputDecoration(labelText: 'ئیمەیڵی نوێ'),
              ),
              const SizedBox(height: 10),
              FilledButton(
                onPressed: _sendVerifyCode,
                style: FilledButton.styleFrom(backgroundColor: AppColors.rose600),
                child: const Text('ناردنی کۆدی پشتڕاستکردنەوە'),
              ),
              if (_awaitingVerify) ...[
                const SizedBox(height: 12),
                TextField(
                  controller: _verifyCodeCtrl,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.ltr,
                  decoration: const InputDecoration(
                    labelText: 'کۆدی ٦ ڕەقەم بنووسە',
                    counterText: '',
                  ),
                ),
                const SizedBox(height: 10),
                FilledButton(
                  onPressed: _confirmVerifyCode,
                  style: FilledButton.styleFrom(backgroundColor: AppColors.teal700),
                  child: const Text('پشتڕاستکردنەوە و گۆڕین'),
                ),
              ],
            ],
          ),
        ),

        // Delete Account ("Delete" confirmation from HTML)
        _ProfileSectionCard(
          title: '🗑️ سڕینەوەی هەژمار',
          color: AppColors.rose600,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'ئاگاداربە! ئەم کردارە هەژمارەکەت بە یەکجاری دەسڕێتەوە و ناگەڕێتەوە.',
                style: TextStyle(color: AppColors.rose600, fontSize: 12),
              ),
              const SizedBox(height: 10),
              if (!_showDeletePrompt)
                OutlinedButton(
                  onPressed: () => setState(() => _showDeletePrompt = true),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.rose600,
                    side: const BorderSide(color: AppColors.rose600),
                  ),
                  child: const Text('سڕینەوەی هەژمار'),
                )
              else ...[
                const Text(
                  'بۆ سەلماندن، وشەی Delete بە ئینگلیزی بنووسە:',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _deleteCtrl,
                  textDirection: TextDirection.ltr,
                  decoration: const InputDecoration(hintText: 'Delete'),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          if (_deleteCtrl.text.trim() != 'Delete') {
                            showReboonToast(
                              context,
                              'تکایە وشەی Delete بە دروستی بنووسە!',
                            );
                            return;
                          }
                          s.deleteAccount();
                          setState(() {
                            _showDeletePrompt = false;
                            _deleteCtrl.clear();
                          });
                          showReboonToast(
                            context,
                            'هەژمارەکەت بە سەرکەوتوویی سڕایەوە',
                          );
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.rose600,
                        ),
                        child: const Text('سڕینەوەی یەکجاری'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () =>
                            setState(() => _showDeletePrompt = false),
                        child: const Text('پاشگەزبوونەوە'),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),

        // Logout button
        FilledButton.icon(
          onPressed: () {
            s.logout();
            showReboonToast(context, 'لە هەژمار چوویتە دەرەوە');
          },
          icon: const Icon(Icons.logout_rounded),
          label: const Text('چوونە دەرەوە لە هەژمار'),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.rose600.withValues(alpha: 0.12),
            foregroundColor: AppColors.rose600,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _QuickStat extends StatelessWidget {
  final String value;
  final String label;
  const _QuickStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: AppColors.amber400,
              fontWeight: FontWeight.w900,
              fontSize: 18,
            ),
          ),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _ProfileSectionCard extends StatelessWidget {
  final String title;
  final Color color;
  final Widget child;

  const _ProfileSectionCard({
    required this.title,
    required this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : const Color(0xFFE5E7EB),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

