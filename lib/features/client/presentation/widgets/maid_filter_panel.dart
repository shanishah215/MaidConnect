import 'package:flutter/material.dart';

import '../../domain/entities/client_portal_models.dart';

class MaidFilterPanel extends StatefulWidget {
  const MaidFilterPanel({
    super.key,
    required this.filter,
    required this.allSkills,
    required this.allLanguages,
    required this.onFilterChanged,
  });

  final MaidFilter filter;
  final List<String> allSkills;
  final List<String> allLanguages;
  final ValueChanged<MaidFilter> onFilterChanged;

  @override
  State<MaidFilterPanel> createState() => _MaidFilterPanelState();
}

class _MaidFilterPanelState extends State<MaidFilterPanel> {
  late final TextEditingController _minAgeController;
  late final TextEditingController _maxAgeController;
  late final TextEditingController _minExperienceController;

  @override
  void initState() {
    super.initState();
    _minAgeController = TextEditingController(
      text: widget.filter.minAge?.toString() ?? '',
    );
    _maxAgeController = TextEditingController(
      text: widget.filter.maxAge?.toString() ?? '',
    );
    _minExperienceController = TextEditingController(
      text: widget.filter.minExperience?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _minAgeController.dispose();
    _maxAgeController.dispose();
    _minExperienceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Advanced filters',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _minAgeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Min age'),
              onChanged: (value) {
                widget.onFilterChanged(
                  widget.filter.copyWith(minAge: int.tryParse(value)),
                );
              },
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _maxAgeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Max age'),
              onChanged: (value) {
                widget.onFilterChanged(
                  widget.filter.copyWith(maxAge: int.tryParse(value)),
                );
              },
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _minExperienceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Min experience (years)',
              ),
              onChanged: (value) {
                widget.onFilterChanged(
                  widget.filter.copyWith(minExperience: int.tryParse(value)),
                );
              },
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String?>(
              initialValue: widget.filter.skill,
              decoration: const InputDecoration(labelText: 'Skill'),
              items: <DropdownMenuItem<String?>>[
                const DropdownMenuItem<String?>(
                  value: null,
                  child: Text('Any'),
                ),
                ...widget.allSkills.map(
                  (skill) => DropdownMenuItem<String?>(
                    value: skill,
                    child: Text(skill),
                  ),
                ),
              ],
              onChanged: (value) {
                widget.onFilterChanged(
                  widget.filter.copyWith(
                    skill: value,
                    clearSkill: value == null,
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String?>(
              initialValue: widget.filter.language,
              decoration: const InputDecoration(labelText: 'Language'),
              items: <DropdownMenuItem<String?>>[
                const DropdownMenuItem<String?>(
                  value: null,
                  child: Text('Any'),
                ),
                ...widget.allLanguages.map(
                  (lang) =>
                      DropdownMenuItem<String?>(value: lang, child: Text(lang)),
                ),
              ],
              onChanged: (value) {
                widget.onFilterChanged(
                  widget.filter.copyWith(
                    language: value,
                    clearLanguage: value == null,
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<MaidAvailability?>(
              initialValue: widget.filter.availability,
              decoration: const InputDecoration(labelText: 'Availability'),
              items: const <DropdownMenuItem<MaidAvailability?>>[
                DropdownMenuItem<MaidAvailability?>(
                  value: null,
                  child: Text('Any'),
                ),
                DropdownMenuItem<MaidAvailability?>(
                  value: MaidAvailability.immediate,
                  child: Text('Immediate'),
                ),
                DropdownMenuItem<MaidAvailability?>(
                  value: MaidAvailability.thisWeek,
                  child: Text('This week'),
                ),
                DropdownMenuItem<MaidAvailability?>(
                  value: MaidAvailability.thisMonth,
                  child: Text('This month'),
                ),
              ],
              onChanged: (value) {
                widget.onFilterChanged(
                  widget.filter.copyWith(
                    availability: value,
                    clearAvailability: value == null,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
