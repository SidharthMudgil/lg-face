import 'package:flutter/material.dart';
import 'package:lg_face/core/constant/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatefulWidget {
  static const route = "/about";

  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final _authorEmail = 'smudgil101@gmail.com';
  final _authorGitHub = 'sidharthmudgil';
  final _authorLinkedIn = 'sidharthmudgil';

  final _orgInstagram = '_liquidgalaxy';
  final _orgTwitter = '_liquidgalaxy';
  final _orgGitHub = 'LiquidGalaxyLAB';
  final _orgLinkedIn = 'google-summer-of-code---liquid-galaxy-project';
  final _orgWebsite = 'www.liquidgalaxy.eu';

  void _sendEmail(String email) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri, mode: LaunchMode.externalApplication);
    }
  }

  void _openGitHub(String account) async {
    final Uri ghLaunchUri = Uri.https('github.com', '/$account');

    if (await canLaunchUrl(ghLaunchUri)) {
      await launchUrl(ghLaunchUri, mode: LaunchMode.externalApplication);
    }
  }

  void _openLinkedIn(String account) async {
    final Uri liLaunchUri = Uri.https('linkedin.com', '/$account');

    if (await canLaunchUrl(liLaunchUri)) {
      await launchUrl(liLaunchUri, mode: LaunchMode.externalApplication);
    }
  }

  void _openInstagram(String account) async {
    final Uri liLaunchUri = Uri.https('instagram.com', '/$account');

    if (await canLaunchUrl(liLaunchUri)) {
      await launchUrl(liLaunchUri, mode: LaunchMode.externalApplication);
    }
  }

  void _openTwitter(String account) async {
    final Uri liLaunchUri = Uri.https('twitter.com', '/$account');

    if (await canLaunchUrl(liLaunchUri)) {
      await launchUrl(liLaunchUri, mode: LaunchMode.externalApplication);
    }
  }

  void _openLink(String link) async {
    final Uri liLaunchUri = Uri.parse(link);

    if (await canLaunchUrl(liLaunchUri)) {
      await launchUrl(liLaunchUri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            Image.asset(
              appLogo,
              width: 250,
              height: 250,
              color: const Color.fromARGB(255, 159, 202, 255),
              fit: BoxFit.fitHeight,
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              appName,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 36,
              ),
            ),
            const SizedBox(
              height: 28,
            ),
            const Text(
              'Author',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            const Text(
              'Sidharth Mudgil',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  iconSize: 30,
                  icon: const Icon(
                    Icons.mail_rounded,
                    color: Colors.white,
                  ),
                  splashRadius: 24,
                  tooltip: _authorEmail,
                  onPressed: () {
                    _sendEmail(_authorEmail);
                  },
                ),
                IconButton(
                  iconSize: 30,
                  splashRadius: 24,
                  icon: const Icon(
                    github,
                    color: Colors.white,
                  ),
                  tooltip: _authorGitHub,
                  onPressed: () {
                    _openGitHub(_authorGitHub);
                  },
                ),
                IconButton(
                  iconSize: 30,
                  icon: const Icon(
                    linkedin_in,
                    color: Colors.white,
                  ),
                  splashRadius: 24,
                  tooltip: _authorLinkedIn,
                  onPressed: () {
                    _openLinkedIn('in/$_authorLinkedIn');
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              'Organization Contact/Social',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  iconSize: 30,
                  icon: const Icon(
                    instagram,
                    color: Colors.white,
                  ),
                  splashRadius: 24,
                  tooltip: '@$_orgInstagram',
                  onPressed: () {
                    _openInstagram(_orgInstagram);
                  },
                ),
                IconButton(
                  iconSize: 30,
                  icon: const Icon(
                    twitter,
                    color: Colors.white,
                  ),
                  splashRadius: 24,
                  tooltip: '@$_orgTwitter',
                  onPressed: () {
                    _openTwitter(_orgTwitter);
                  },
                ),
                IconButton(
                  iconSize: 30,
                  splashRadius: 24,
                  icon: const Icon(
                    github,
                    color: Colors.white,
                  ),
                  tooltip: _orgGitHub,
                  onPressed: () {
                    _openGitHub(_orgGitHub);
                  },
                ),
                IconButton(
                  iconSize: 30,
                  icon: const Icon(
                    linkedin_in,
                    color: Colors.white,
                  ),
                  splashRadius: 24,
                  tooltip: 'Liquid Galaxy Project (Google Summer of Code)',
                  onPressed: () {
                    _openLinkedIn('company/$_orgLinkedIn');
                  },
                ),
                IconButton(
                  iconSize: 30,
                  icon: const Icon(
                    Icons.language_rounded,
                    color: Colors.white,
                  ),
                  splashRadius: 24,
                  tooltip: _orgWebsite,
                  onPressed: () {
                    _openLink('https://$_orgWebsite');
                  },
                ),
                IconButton(
                  iconSize: 24,
                  icon: const Icon(
                    google_play,
                    color: Colors.white,
                  ),
                  splashRadius: 24,
                  tooltip: 'Liquid Galaxy LAB',
                  onPressed: () {
                    _openLink(
                        'https://play.google.com/store/apps/developer?id=Liquid+Galaxy+LAB');
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              "Description",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            const Text(
              appDescription,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              height: 28,
            ),
            const Text(
              'Version ${"1.0.0"}',
              style: TextStyle(
                color: Colors.white60,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
