import 'package:flutter/material.dart';
import 'package:flux/common/widgets/default_app_bar.dart';

final class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  final _policy = ''' 
Effective Date: February 3, 2026

1. Information Collection Flux collects information that you provide directly to us. This includes your name, email address, and the content of the notes you create. All data is processed and stored through our secure private API services.

2. Use of Information Your data is used exclusively to:

Provide, maintain, and synchronize your notes across your devices.

Manage your personal account and authentication securely.

Ensure a seamless offline-to-online data transition.

3. Data Storage and Security We take data security seriously. Your notes are stored locally on your device for offline access and are synchronized with our dedicated private database. We do not use third-party cloud database providers for your note content, ensuring your data remains within our secure infrastructure.

4. User Authentication Access to your account is protected by industry-standard encryption. You are responsible for maintaining the confidentiality of your login credentials.

5. Data Control and Deletion You have full control over your data. You can update your profile information or delete your account and all associated notes permanently at any time through the settings menu.

6. Contact Us For any questions regarding this Privacy Policy, please contact us at: support@fluxapp.com.
''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar(title: "Privacy Policy"),
      body: SingleChildScrollView(
        padding: const .all(20),
        child: Text(
          _policy,
        ),
      ),
    );
  }
}
