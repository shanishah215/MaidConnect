import 'package:flutter/material.dart';

import 'public_single_page.dart';

class PublicPages {
  PublicPages._();

  static Widget home() => const PublicSinglePage(
        initialSection: PublicSection.home,
      );

  static Widget about() => const PublicSinglePage(
        initialSection: PublicSection.about,
      );

  static Widget services() => const PublicSinglePage(
        initialSection: PublicSection.services,
      );

  static Widget pricing() => const PublicSinglePage(
        initialSection: PublicSection.pricing,
      );

  static Widget contact() => const PublicSinglePage(
        initialSection: PublicSection.contact,
      );

  static Widget faqs() => const PublicSinglePage(
        initialSection: PublicSection.faqs,
      );
}
