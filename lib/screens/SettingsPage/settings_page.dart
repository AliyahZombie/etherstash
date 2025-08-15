
import 'package:etherstash/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _baseUrlController = TextEditingController();
  final TextEditingController _authKeyController = TextEditingController();

  bool _loading = false;
  bool _verifying = false;

  static const String _kBaseUrlKey = 'worker_base_url';
  static const String _kAuthKey = 'worker_auth_key';

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _baseUrlController.text = prefs.getString(_kBaseUrlKey) ?? '';
    _authKeyController.text = prefs.getString(_kAuthKey) ?? '';
    setState(() {});
  }

  String _normalizeBaseUrl(String input) {
    var url = input.trim();
    // Remove trailing slash
    if (url.endsWith('/')) url = url.substring(0, url.length - 1);
    return url;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final base = _normalizeBaseUrl(_baseUrlController.text);
      await prefs.setString(_kBaseUrlKey, base);
      await prefs.setString(_kAuthKey, _authKeyController.text.trim());
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.saved_successfully)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.save_failed)),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _verify() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _verifying = true);
    try {
      final base = _normalizeBaseUrl(_baseUrlController.text);
      final key = _authKeyController.text.trim();
      final uri = Uri.parse('$base/auth');
      final resp = await http
          .get(
            uri,
            headers: {
              'Authorization': 'Bearer $key',
            },
          )
          .timeout(const Duration(seconds: 10));

      if (!mounted) return;
      if (resp.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.connection_verified)),
        );
      } else if (resp.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.unauthorized_invalid_key)),
        );
      } else {
        final t = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(t.failed_http(resp.statusCode))),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.verify_error)),
      );
    } finally {
      if (mounted) setState(() => _verifying = false);
    }
  }

  String? _validateUrl(String? value) {
    final text = (value ?? '').trim();
    final t = AppLocalizations.of(context)!;
    if (text.isEmpty) return t.base_url_required;
    // Basic check for scheme and host
    Uri? uri;
    try {
      uri = Uri.parse(text);
    } catch (_) {
      return t.invalid_url;
    }
    if (!(uri.isScheme('http') || uri.isScheme('https')) || uri.host.isEmpty) {
      return 'Invalid URL';
    }
    return null;
  }

  String? _validateKey(String? value) {
    final t = AppLocalizations.of(context)!;
    if ((value ?? '').trim().isEmpty) return t.auth_key_required;
    return null;
  }

  @override
  void dispose() {
    _baseUrlController.dispose();
    _authKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(t.settings),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
t.worker_settings,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _baseUrlController,
decoration: InputDecoration(
                            labelText: t.base_url,
                            hintText: t.base_url_hint,
                            prefixIcon: const Icon(Icons.link),
                            border: const OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.url,
                          validator: _validateUrl,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _authKeyController,
decoration: InputDecoration(
                            labelText: t.auth_key,
                            hintText: t.auth_key_hint,
                            prefixIcon: const Icon(Icons.vpn_key),
                            border: const OutlineInputBorder(),
                          ),
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          validator: _validateKey,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: FilledButton.icon(
                                onPressed: _loading ? null : _save,
                                icon: _loading
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation(Colors.white),
                                        ),
                                      )
                                    : const Icon(Icons.save),
label: Text(t.save),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: _verifying ? null : _verify,
                                icon: _verifying
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(strokeWidth: 2),
                                      )
                                    : const Icon(Icons.verified),
label: Text(t.verify_connection),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Divider(height: 24),
                        const _HelpSection(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HelpSection extends StatelessWidget {
  const _HelpSection();

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(t.tips),
        const SizedBox(height: 8),
        Text(t.tips_base_url),
        Text(t.tips_auth( t.auth_key_hint)),
        Text(t.tips_content_type),
      ],
    );
  }
}
