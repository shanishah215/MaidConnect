import 'package:flutter/material.dart';
import '../widgets/admin_form_section.dart';
import '../widgets/admin_file_upload_area.dart';
import '../widgets/admin_dialog.dart';

class BulkUploadPage extends StatefulWidget {
  const BulkUploadPage({super.key});

  @override
  State<BulkUploadPage> createState() => _BulkUploadPageState();
}

class _BulkUploadPageState extends State<BulkUploadPage> {
  List<String> _uploadedFiles = [];
  bool _isProcessing = false;
  double _progress = 0.0;

  void _onUpload() {
    setState(() {
      _uploadedFiles.add('Maids_Import_Q2_${_uploadedFiles.length + 1}.xlsx');
    });
  }

  void _process() async {
    if (_uploadedFiles.isEmpty) return;
    
    setState(() {
      _isProcessing = true;
      _progress = 0.0;
    });

    // Mock progress
    for (int i = 0; i <= 10; i++) {
      await Future.delayed(const Duration(milliseconds: 300));
      if (!mounted) return;
      setState(() => _progress = i / 10);
    }

    setState(() {
      _isProcessing = false;
      _uploadedFiles.clear();
    });

    if (mounted) AdminDialog.showSnack(context, 'Successfully imported 42 maid profiles.');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Bulk Import Maids',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () => AdminDialog.showSnack(context, 'Mock: Downloaded Excel Template.'),
                icon: const Icon(Icons.download),
                label: const Text('Download Template'),
              ),
            ],
          ),
          const SizedBox(height: 32),

          AdminFormSection(
            title: 'Import CSV/Excel',
            description: 'Upload your maid profiles in bulk. Ensure files follow the required template.',
            child: Column(
              children: [
                AdminFileUploadArea(
                  label: 'Drag & Drop your file here',
                  hint: 'Supports .xlsx, .csv (Max 20MB)',
                  icon: Icons.upload_file,
                  acceptedFormats: '.xlsx, .csv',
                  uploadedFileNames: _uploadedFiles,
                  onTap: _isProcessing ? null : _onUpload,
                  onRemove: _isProcessing ? null : (i) => setState(() => _uploadedFiles.removeAt(i)),
                ),
                if (_isProcessing) ...[
                  const SizedBox(height: 24),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Processing profiles...', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                          Text('${(_progress * 100).round()}%', style: const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: _progress,
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: (_uploadedFiles.isEmpty || _isProcessing) ? null : _process,
                    child: Text(_isProcessing ? 'Processing...' : 'Import Data'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          AdminFormSection(
            title: 'Instructions',
            description: 'Help for bulk importing data.',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                _Step(num: '1', text: 'Download the official Excel/CSV template.'),
                SizedBox(height: 12),
                _Step(num: '2', text: 'Fill in all mandatory fields like Name, Age, and Experience.'),
                SizedBox(height: 12),
                _Step(num: '3', text: 'Upload the completed file using the zone above.'),
                SizedBox(height: 12),
                _Step(num: '4', text: 'Review any errors if processing fails.'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({required this.num, required this.text});
  final String num;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: const Color(0xFF6366F1).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(num, style: const TextStyle(color: Color(0xFF6366F1), fontWeight: FontWeight.bold, fontSize: 11)),
          ),
        ),
        const SizedBox(width: 12),
        Text(text, style: const TextStyle(color: Color(0xFF475569), fontSize: 13)),
      ],
    );
  }
}
