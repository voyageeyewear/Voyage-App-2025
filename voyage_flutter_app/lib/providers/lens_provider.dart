import 'package:flutter/foundation.dart';
import '../models/lens.dart';
import '../services/shopify_service.dart';

class LensProvider extends ChangeNotifier {
  final ShopifyService _shopifyService = ShopifyService();

  // Lens Options
  List<Lens> _antiGlareLenses = [];
  List<Lens> _blueBlockLenses = [];
  List<Lens> _colourLenses = [];
  List<Lens> _allLenses = [];

  // Selection State
  String? _selectedLensType;  // 'power', 'progressive', 'computer', 'zero'
  String? _selectedPowerType;  // 'antiglare', 'blueblock', 'colour'
  Lens? _selectedLens;
  PrescriptionData? _prescriptionData;

  bool _isLoading = false;
  String? _error;

  // Getters
  List<Lens> get antiGlareLenses => _antiGlareLenses;
  List<Lens> get blueBlockLenses => _blueBlockLenses;
  List<Lens> get colourLenses => _colourLenses;
  List<Lens> get allLenses => _allLenses;

  String? get selectedLensType => _selectedLensType;
  String? get selectedPowerType => _selectedPowerType;
  Lens? get selectedLens => _selectedLens;
  PrescriptionData? get prescriptionData => _prescriptionData;

  bool get isLoading => _isLoading;
  String? get error => _error;

  int get currentStep {
    if (_selectedLensType == null) return 0;
    if (_selectedPowerType == null) return 1;
    if (_selectedLens == null) return 2;
    return 3;
  }

  bool get canProceed {
    return _selectedLensType != null && 
           _selectedPowerType != null && 
           _selectedLens != null;
  }

  Future<void> fetchLensOptions() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final lensOptions = await _shopifyService.getLensOptions();
      
      _antiGlareLenses = lensOptions['antiglare'] ?? [];
      _blueBlockLenses = lensOptions['blueblock'] ?? [];
      _colourLenses = lensOptions['colour'] ?? [];
      _allLenses = lensOptions['all'] ?? [];

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  void selectLensType(String type) {
    _selectedLensType = type;
    // Reset subsequent selections
    _selectedPowerType = null;
    _selectedLens = null;
    _prescriptionData = null;
    notifyListeners();
  }

  void selectPowerType(String type) {
    _selectedPowerType = type;
    // Reset subsequent selections
    _selectedLens = null;
    _prescriptionData = null;
    notifyListeners();
  }

  void selectLens(Lens lens) {
    _selectedLens = lens;
    notifyListeners();
  }

  void setPrescriptionData(PrescriptionData data) {
    _prescriptionData = data;
    notifyListeners();
  }

  List<Lens> getFilteredLenses() {
    if (_selectedPowerType == null) return [];

    switch (_selectedPowerType) {
      case 'antiglare':
        return _antiGlareLenses;
      case 'blueblock':
        return _blueBlockLenses;
      case 'colour':
        return _colourLenses;
      default:
        return _allLenses;
    }
  }

  void clearSelection() {
    _selectedLensType = null;
    _selectedPowerType = null;
    _selectedLens = null;
    _prescriptionData = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  bool requiresPrescription() {
    return _selectedLensType == 'power' || _selectedLensType == 'progressive';
  }
}

