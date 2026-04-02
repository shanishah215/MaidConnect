import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/app_routes.dart';
import '../../domain/entities/admin_models.dart';
import '../state/admin_portal_store.dart';
import '../widgets/admin_form_section.dart';
import '../widgets/admin_file_upload_area.dart';
import '../widgets/admin_dialog.dart';
import '../../../../core/services/media_upload_service.dart';

class MaidFormPage extends StatefulWidget {
  const MaidFormPage({super.key, this.maidId});
  final String? maidId;

  @override
  State<MaidFormPage> createState() => _MaidFormPageState();
}

class _MaidFormPageState extends State<MaidFormPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isEdit = false;
  late AdminMaidProfile _maid;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _nationalityController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  AdminMaidAvailability _availability = AdminMaidAvailability.available;
  List<String> _skills = [];
  List<String> _languages = [];
  List<MaidDocument> _documents = [];
  String? _photoUrl;
  bool _isLoading = false;
  bool _isUploadingPhoto = false;
  bool _isUploadingDoc = false;

  @override
  void initState() {
    super.initState();
    _isEdit = widget.maidId != null;
    if (_isEdit) {
      final existingMaid = AdminPortalStore.instance.getMaidById(
        widget.maidId!,
      );
      if (existingMaid != null) {
        _maid = existingMaid;
        _nameController.text = _maid.name;
        _ageController.text = _maid.age.toString();
        _nationalityController.text = _maid.nationality;
        _experienceController.text = _maid.experienceYears.toString();
        _bioController.text = _maid.bio;
        _rateController.text = _maid.monthlyRate.toString();
        _availability = _maid.availabilityStatus;
        _skills = List.from(_maid.skills);
        _languages = List.from(_maid.languages);
        _documents = List.from(_maid.documents);
        _photoUrl = _maid.photoUrl;
      }
    }
  }

  Future<void> _pickAndUploadPhoto() async {
    final xFile = await MediaUploadService.pickImage();
    if (xFile == null) return;

    setState(() => _isUploadingPhoto = true);
    final url = await MediaUploadService.uploadToCloudinary(xFile: xFile);
    setState(() {
      _isUploadingPhoto = false;
      if (url != null) {
        _photoUrl = url;
        AdminDialog.showSnack(context, 'Photo uploaded successfully.');
      } else {
        AdminDialog.showSnack(context, 'Failed to upload photo. Please check your credentials.');
      }
    });
  }

  Future<void> _pickAndUploadDocument() async {
    final doc = await MediaUploadService.pickDocument();
    if (doc == null) return;

    setState(() => _isUploadingDoc = true);
    final url = await MediaUploadService.uploadToCloudinary(platformFile: doc);
    setState(() {
      _isUploadingDoc = false;
      if (url != null) {
        _documents.add(MaidDocument(
          name: doc.name,
          type: AdminMaidDocType.other,
          uploadedAt: DateTime.now(),
          url: url,
        ));
        AdminDialog.showSnack(context, 'Document uploaded successfully.');
      } else {
        AdminDialog.showSnack(context, 'Failed to upload document.');
      }
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final updatedMaid = AdminMaidProfile(
      id: _isEdit ? _maid.id : 'maid-${DateTime.now().millisecondsSinceEpoch}',
      name: _nameController.text,
      age: int.parse(_ageController.text),
      nationality: _nationalityController.text,
      skills: _skills,
      experienceYears: int.parse(_experienceController.text),
      languages: _languages,
      availabilityStatus: _availability,
      bio: _bioController.text,
      monthlyRate: int.parse(_rateController.text),
      createdAt: _isEdit ? _maid.createdAt : DateTime.now(),
      photoUrl: _photoUrl,
      documents: _documents,
    );

    try {
      if (_isEdit) {
        await AdminPortalStore.instance.updateMaid(updatedMaid);
        if (mounted)
          AdminDialog.showSnack(context, 'Profile updated successfully.');
      } else {
        await AdminPortalStore.instance.addMaid(updatedMaid);
        if (mounted)
          AdminDialog.showSnack(context, 'Maid profile created successfully.');
      }
      if (mounted) context.go(AppRoutes.maidProfileManagement);
    } catch (e) {
      if (mounted) AdminDialog.showSnack(context, 'Error saving profile: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 1100;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                IconButton(
                  onPressed: () => context.go(AppRoutes.maidProfileManagement),
                  icon: const Icon(Icons.arrow_back),
                  tooltip: 'Go back',
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _isEdit ? 'Edit Maid Profile' : 'Add New Maid Profile',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (!isMobile) ...[
                  const SizedBox(width: 12),
                  OutlinedButton(
                    onPressed: () =>
                        context.go(AppRoutes.maidProfileManagement),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  if (_isLoading)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  else
                    FilledButton(
                      onPressed: _save,
                      child: const Text('Save Profile'),
                    ),
                ],
              ],
            ),
            if (isMobile) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () =>
                          context.go(AppRoutes.maidProfileManagement),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: _isLoading ? null : _save,
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Save Profile'),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 32),

            // Main Columns / Responsive Layout
            if (isMobile)
              Column(
                children: [
                  _buildInfoSection(),
                  const SizedBox(height: 24),
                  _buildMediaSection(),
                ],
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 3, child: _buildInfoSection()),
                  const SizedBox(width: 32),
                  Expanded(flex: 2, child: _buildMediaSection()),
                ],
              ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection() {
    return Column(
      children: [
        AdminFormSection(
          title: 'Basic Information',
          description:
              'Enter the personal and contact details of the candidate.',
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  hintText: 'Enter full name',
                ),
                validator: (v) => v!.isEmpty ? 'Name is required' : null,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _ageController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Age',
                        hintText: 'Years',
                      ),
                      validator: (v) => v!.isEmpty ? 'Age required' : null,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: TextFormField(
                      controller: _nationalityController,
                      decoration: const InputDecoration(
                        labelText: 'Nationality',
                        hintText: 'e.g. Sri Lankan',
                      ),
                      validator: (v) =>
                          v!.isEmpty ? 'Nationality required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _experienceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Experience',
                        hintText: 'Years',
                      ),
                      validator: (v) =>
                          v!.isEmpty ? 'Experience required' : null,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: TextFormField(
                      controller: _rateController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Monthly Rate',
                        hintText: 'USD / Month',
                      ),
                      validator: (v) => v!.isEmpty ? 'Rate is required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<AdminMaidAvailability>(
                initialValue: _availability,
                decoration: const InputDecoration(
                  labelText: 'Availability Status',
                ),
                items: AdminMaidAvailability.values
                    .map(
                      (v) => DropdownMenuItem(
                        value: v,
                        child: Text(
                          v.name.substring(0, 1).toUpperCase() +
                              v.name.substring(1),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setState(() => _availability = v!),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        AdminFormSection(
          title: 'Professional Bio',
          description: 'Write a brief professional summary of the candidate.',
          child: TextFormField(
            controller: _bioController,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Describe experience, temperament, and strengths...',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(height: 24),
        AdminFormSection(
          title: 'Skills & Languages',
          description: 'Select capabilities and communication skills.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Skills (Comma separated)',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              const SizedBox(height: 8),
              TextFormField(
                initialValue: _skills.join(', '),
                onChanged: (v) => _skills = v
                    .split(',')
                    .map((s) => s.trim())
                    .where((s) => s.isNotEmpty)
                    .toList(),
                decoration: const InputDecoration(
                  hintText: 'e.g. Cooking, Childcare, Cleaning',
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Languages (Comma separated)',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              const SizedBox(height: 8),
              TextFormField(
                initialValue: _languages.join(', '),
                onChanged: (v) => _languages = v
                    .split(',')
                    .map((l) => l.trim())
                    .where((l) => l.isNotEmpty)
                    .toList(),
                decoration: const InputDecoration(
                  hintText: 'e.g. English, Sinhala, Tamil',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMediaSection() {
    return Column(
      children: [
        AdminFormSection(
          title: 'Profile Photo',
          description: 'Upload a clear profile picture.',
          child: Column(
            children: [
              if (_photoUrl != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      _photoUrl!,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              AdminFileUploadArea(
                label: _isUploadingPhoto ? 'Uploading...' : 'Upload Profile Image',
                hint: 'PNG, JPG up to 10MB',
                icon: _isUploadingPhoto ? Icons.sync : Icons.add_a_photo_outlined,
                onTap: _isUploadingPhoto ? null : _pickAndUploadPhoto,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        AdminFormSection(
          title: 'Documents',
          description: 'Upload ID, certificates, and references.',
          child: AdminFileUploadArea(
            label: _isUploadingDoc ? 'Uploading...' : 'Drop files here or click to upload',
            hint: 'PDF, JPG up to 10MB',
            icon: _isUploadingDoc ? Icons.sync : Icons.upload_file,
            uploadedFileNames: _documents.map((d) => d.name).toList(),
            onTap: _isUploadingDoc ? null : _pickAndUploadDocument,
            onRemove: (index) {
              setState(() {
                _documents.removeAt(index);
              });
            },
          ),
        ),
      ],
    );
  }
}
