import 'dart:io';

import 'package:agrilo/core/theme/app_colors.dart';
import 'package:agrilo/features/soil/cubit/soil_cubit.dart';
import 'package:agrilo/features/soil/cubit/soil_state.dart';
import 'package:agrilo/features/soil/repository/soil_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class SoilAnalysisPage extends StatelessWidget {
  const SoilAnalysisPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SoilCubit(
        repository: context.read<SoilRepository>(),
      ),
      child: const SoilAnalysisView(),
    );
  }
}

class SoilAnalysisView extends StatefulWidget {
  const SoilAnalysisView({super.key});

  @override
  State<SoilAnalysisView> createState() => _SoilAnalysisViewState();
}

class _SoilAnalysisViewState extends State<SoilAnalysisView> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _analyze() {
    if (_selectedImage != null) {
      context.read<SoilCubit>().analyzeSoil(_selectedImage!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analyze Soil'),
        automaticallyImplyLeading: false,
      ),
      body: BlocConsumer<SoilCubit, SoilState>(
        listener: (context, state) {
          if (state.status == SoilStatus.success) {
            setState(() {
              _selectedImage = null; // Reset on success to invite new scans
            });
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Upload a clear image of your soil to get AI-powered insights and nutrient breakdowns.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                GestureDetector(
                  onTap: () {
                    if (state.status != SoilStatus.loading) {
                      _showPickerOptions(context);
                    }
                  },
                  child: Container(
                    height: 250,
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                        color: _selectedImage != null ? AppColors.primary : AppColors.primary.withAlpha(50),
                        width: 2,
                      ),
                    ),
                    child: _selectedImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Image.file(_selectedImage!, fit: BoxFit.cover),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withAlpha(20),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.add_a_photo_outlined,
                                  color: AppColors.primary,
                                  size: 40,
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Tap to select an image',
                                style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 48),
                ElevatedButton(
                  onPressed: (_selectedImage == null || state.status == SoilStatus.loading) ? null : _analyze,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppColors.primary,
                    disabledBackgroundColor: AppColors.cardBackground,
                  ),
                  child: state.status == SoilStatus.loading
                      ? const CircularProgressIndicator(color: Colors.black)
                      : Text(
                          'Analyze Now',
                          style: TextStyle(
                            fontSize: 18,
                            color: _selectedImage == null ? Colors.grey : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showPickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined, color: Colors.white),
                title: const Text('Take a Photo'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined, color: Colors.white),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
