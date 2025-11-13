import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../models/lens.dart';
import '../providers/lens_provider.dart';
import '../providers/cart_provider.dart';
import '../utils/navigation_helper.dart';
import '../utils/constants.dart';

class LensSelectorScreen extends StatefulWidget {
  final Product product;

  const LensSelectorScreen({
    super.key,
    required this.product,
  });

  @override
  State<LensSelectorScreen> createState() => _LensSelectorScreenState();
}

class _LensSelectorScreenState extends State<LensSelectorScreen> {
  final _prescriptionFormKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {
    'rightSph': TextEditingController(),
    'rightCyl': TextEditingController(),
    'rightAxis': TextEditingController(),
    'rightAdd': TextEditingController(),
    'leftSph': TextEditingController(),
    'leftCyl': TextEditingController(),
    'leftAxis': TextEditingController(),
    'leftAdd': TextEditingController(),
  };

  @override
  void initState() {
    super.initState();
    _loadLensOptions();
  }

  Future<void> _loadLensOptions() async {
    try {
      await context.read<LensProvider>().fetchLensOptions();
    } catch (e) {
      if (mounted) {
        NavigationHelper.showSnackBar(
          context,
          'Failed to load lens options: $e',
          isError: true,
        );
      }
    }
  }

  Future<void> _addToCart() async {
    final lensProvider = context.read<LensProvider>();
    
    if (!lensProvider.canProceed) {
      NavigationHelper.showSnackBar(
        context,
        'Please complete all steps',
        isError: true,
      );
      return;
    }

    Map<String, String>? prescriptionProps;
    if (lensProvider.requiresPrescription()) {
      if (!_prescriptionFormKey.currentState!.validate()) {
        return;
      }

      prescriptionProps = {
        if (_controllers['rightSph']!.text.isNotEmpty)
          'Right SPH': _controllers['rightSph']!.text,
        if (_controllers['rightCyl']!.text.isNotEmpty)
          'Right CYL': _controllers['rightCyl']!.text,
        if (_controllers['rightAxis']!.text.isNotEmpty)
          'Right Axis': _controllers['rightAxis']!.text,
        if (_controllers['rightAdd']!.text.isNotEmpty)
          'Right ADD': _controllers['rightAdd']!.text,
        if (_controllers['leftSph']!.text.isNotEmpty)
          'Left SPH': _controllers['leftSph']!.text,
        if (_controllers['leftCyl']!.text.isNotEmpty)
          'Left CYL': _controllers['leftCyl']!.text,
        if (_controllers['leftAxis']!.text.isNotEmpty)
          'Left Axis': _controllers['leftAxis']!.text,
        if (_controllers['leftAdd']!.text.isNotEmpty)
          'Left ADD': _controllers['leftAdd']!.text,
      };
    }

    try {
      await context.read<CartProvider>().addFrameWithLens(
            frame: widget.product,
            lens: lensProvider.selectedLens!,
            prescriptionProperties: prescriptionProps,
          );

      if (mounted) {
        lensProvider.clearSelection();
        Navigator.pop(context);
        NavigationHelper.showSnackBar(
          context,
          'Frame and lens added to cart!',
        );
      }
    } catch (e) {
      if (mounted) {
        NavigationHelper.showSnackBar(
          context,
          'Failed to add to cart: $e',
          isError: true,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Lens'),
      ),
      body: Consumer<LensProvider>(
        builder: (context, lensProvider, child) {
          if (lensProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Stepper(
            currentStep: lensProvider.currentStep,
            onStepContinue: () {
              if (lensProvider.currentStep == 3) {
                _addToCart();
              }
            },
            onStepCancel: () {
              if (lensProvider.currentStep > 0) {
                // Navigate back by clearing current selection
                if (lensProvider.currentStep == 3) {
                  lensProvider.selectLens(lensProvider.selectedLens!);
                } else if (lensProvider.currentStep == 2) {
                  lensProvider.selectPowerType(lensProvider.selectedPowerType!);
                } else if (lensProvider.currentStep == 1) {
                  lensProvider.selectLensType(lensProvider.selectedLensType!);
                }
              }
            },
            steps: [
              // Step 1: Lens Type
              Step(
                title: const Text('Lens Type'),
                content: Column(
                  children: [
                    _buildLensTypeOption('power', 'With Power / Single Vision'),
                    _buildLensTypeOption('progressive', 'Progressive'),
                    _buildLensTypeOption('computer', 'Computer Glasses / Blue Cut'),
                    _buildLensTypeOption('zero', 'Zero Power'),
                  ],
                ),
                isActive: lensProvider.currentStep >= 0,
                state: lensProvider.selectedLensType != null
                    ? StepState.complete
                    : StepState.indexed,
              ),

              // Step 2: Power Type
              Step(
                title: const Text('Power Type'),
                content: Column(
                  children: [
                    _buildPowerTypeOption(
                      'antiglare',
                      'Anti-Glare Lenses',
                      lensProvider.antiGlareLenses.length,
                    ),
                    _buildPowerTypeOption(
                      'blueblock',
                      'Blue Block Lenses',
                      lensProvider.blueBlockLenses.length,
                    ),
                    _buildPowerTypeOption(
                      'colour',
                      'Colour Lenses',
                      lensProvider.colourLenses.length,
                    ),
                  ],
                ),
                isActive: lensProvider.currentStep >= 1,
                state: lensProvider.selectedPowerType != null
                    ? StepState.complete
                    : StepState.indexed,
              ),

              // Step 3: Select Lens
              Step(
                title: const Text('Select Lens'),
                content: _buildLensList(lensProvider),
                isActive: lensProvider.currentStep >= 2,
                state: lensProvider.selectedLens != null
                    ? StepState.complete
                    : StepState.indexed,
              ),

              // Step 4: Add Power (Optional)
              Step(
                title: const Text('Add Power (Optional)'),
                content: _buildPrescriptionForm(),
                isActive: lensProvider.currentStep >= 3,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLensTypeOption(String type, String label) {
    return Consumer<LensProvider>(
      builder: (context, lensProvider, child) {
        return RadioListTile<String>(
          title: Text(label),
          value: type,
          groupValue: lensProvider.selectedLensType,
          onChanged: (value) {
            if (value != null) {
              lensProvider.selectLensType(value);
            }
          },
        );
      },
    );
  }

  Widget _buildPowerTypeOption(String type, String label, int count) {
    return Consumer<LensProvider>(
      builder: (context, lensProvider, child) {
        return RadioListTile<String>(
          title: Text(label),
          subtitle: Text('$count options'),
          value: type,
          groupValue: lensProvider.selectedPowerType,
          onChanged: (value) {
            if (value != null) {
              lensProvider.selectPowerType(value);
            }
          },
        );
      },
    );
  }

  Widget _buildLensList(LensProvider lensProvider) {
    final lenses = lensProvider.getFilteredLenses();
    
    if (lenses.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text('No lenses available for this selection'),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: lenses.length,
      itemBuilder: (context, index) {
        final lens = lenses[index];
        final isSelected = lensProvider.selectedLens?.id == lens.id;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          color: isSelected ? AppConstants.primaryColor.withOpacity(0.1) : null,
          child: ListTile(
            title: Text(lens.title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  lens.displayPrice,
                  style: const TextStyle(
                    color: AppConstants.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (lens.features.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  ...lens.features.take(3).map((feature) {
                    return Text(
                      '• $feature',
                      style: const TextStyle(fontSize: 12),
                    );
                  }),
                ],
              ],
            ),
            trailing: isSelected
                ? const Icon(Icons.check_circle, color: AppConstants.primaryColor)
                : null,
            onTap: () {
              lensProvider.selectLens(lens);
            },
          ),
        );
      },
    );
  }

  Widget _buildPrescriptionForm() {
    return Form(
      key: _prescriptionFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Right Eye (OD)',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildTextField('rightSph', 'SPH')),
              const SizedBox(width: 8),
              Expanded(child: _buildTextField('rightCyl', 'CYL')),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _buildTextField('rightAxis', 'Axis', isInt: true)),
              const SizedBox(width: 8),
              Expanded(child: _buildTextField('rightAdd', 'ADD')),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Left Eye (OS)',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildTextField('leftSph', 'SPH')),
              const SizedBox(width: 8),
              Expanded(child: _buildTextField('leftCyl', 'CYL')),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _buildTextField('leftAxis', 'Axis', isInt: true)),
              const SizedBox(width: 8),
              Expanded(child: _buildTextField('leftAdd', 'ADD')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String key, String label, {bool isInt = false}) {
    return TextFormField(
      controller: _controllers[key],
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      keyboardType: isInt
          ? TextInputType.number
          : const TextInputType.numberWithOptions(decimal: true),
    );
  }

  @override
  void dispose() {
    _controllers.forEach((key, controller) => controller.dispose());
    super.dispose();
  }
}

