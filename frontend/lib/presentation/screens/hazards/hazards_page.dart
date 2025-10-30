import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:streetsmart/core/constants/theme_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

class HazardsPage extends StatefulWidget {
  const HazardsPage({super.key});

  @override
  State<HazardsPage> createState() => _HazardsPageState();
}

class _HazardsPageState extends State<HazardsPage> {
  final List<String> _hazards = [];
  final TextEditingController _controller = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;
  static const _prefsKey = 'hazards_list_v1';

  @override
  void initState() {
    super.initState();
    _loadHazards();
  }

  Future<void> _loadHazards() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList(_prefsKey) ?? <String>[];
    setState(() {
      _hazards.clear();
      _hazards.addAll(stored);
    });
  }

  Future<void> _saveHazards() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_prefsKey, _hazards);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85,
      );
      
      if (image != null) {
        setState(() {
          _selectedImage = image;
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAddDialog({int? editIndex}) {
    if (editIndex != null) {
      _controller.text = _hazards[editIndex];
    } else {
      _controller.clear();
      _selectedImage = null;
    }

    showDialog<void>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(editIndex == null ? 'Add a hazard' : 'Edit hazard'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _controller,
                  decoration: const InputDecoration(hintText: 'Describe the hazard...'),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _showImageSourceDialog();
                        // Reopen dialog after image selection
                        Future.delayed(const Duration(milliseconds: 100), () {
                          if (mounted) _showAddDialog(editIndex: editIndex);
                        });
                      },
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Add Photo'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        foregroundColor: Colors.black,
                      ),
                    ),
                  ],
                ),
                if (_selectedImage != null) ...[
                  const SizedBox(height: 12),
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: kIsWeb
                            ? Image.network(
                                _selectedImage!.path,
                                height: 150,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                File(_selectedImage!.path),
                                height: 150,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.black54,
                          ),
                          onPressed: () {
                            setDialogState(() {
                              _selectedImage = null;
                            });
                            setState(() {
                              _selectedImage = null;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Photo attached',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _controller.clear();
                setState(() {
                  _selectedImage = null;
                });
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: ThemeConstants.warningColor),
              onPressed: () async {
                final text = _controller.text.trim();
                // capture navigator to avoid using BuildContext after async gap
                final navigator = Navigator.of(context);
                if (text.isNotEmpty) {
                  // Add hazard text with photo indicator if photo exists
                  final hazardText = _selectedImage != null 
                      ? '$text 📷' 
                      : text;
                  
                  setState(() {
                    if (editIndex == null) {
                      _hazards.add(hazardText);
                    } else {
                      _hazards[editIndex] = hazardText;
                    }
                  });
                  await _saveHazards();
                  
                  // Show confirmation with image info
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          _selectedImage != null 
                              ? 'Hazard added with photo!' 
                              : 'Hazard added!',
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                }
                // avoid referencing context after await
                navigator.pop();
                _controller.clear();
                setState(() {
                  _selectedImage = null;
                });
              },
              child: Text(editIndex == null ? 'Add' : 'Save'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(int index) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete hazard'),
        content: const Text('Are you sure you want to delete this hazard?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: ThemeConstants.warningColor),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (ok == true) {
      if (!mounted) return;
      setState(() {
        _hazards.removeAt(index);
      });
      await _saveHazards();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hazards'),
        backgroundColor: ThemeConstants.warningColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_hazards.isEmpty)
              Expanded(
                child: Center(
                  child: Text(
                    'No hazards detected',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.separated(
                  itemCount: _hazards.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) => ListTile(
                    leading: Icon(Icons.warning, color: ThemeConstants.warningColor),
                    title: Text(_hazards[index]),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _showAddDialog(editIndex: index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _confirmDelete(index),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ElevatedButton.icon(
                onPressed: _showAddDialog,
                icon: const Icon(Icons.add),
                label: const Text('Add a hazard'),
                style: ElevatedButton.styleFrom(backgroundColor: ThemeConstants.warningColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
