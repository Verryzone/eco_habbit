import 'dart:async';
import 'package:eco_habbit/models/habbit_model.dart';
import 'package:eco_habbit/models/category_model.dart';
import 'package:eco_habbit/services/habbit_service.dart';
import 'package:eco_habbit/services/category_service.dart';

class DashboardController {
  static final DashboardController _instance = DashboardController._internal();
  factory DashboardController() => _instance;
  DashboardController._internal();

  final HabbitService _habitService = HabbitService();
  final CategoryService _categoryService = CategoryService();

  // Data state
  List<HabbitModel> _habits = [];
  Map<int, String> _categoriesMap = {};
  bool _isInitialized = false;
  bool _isLoading = false;
  String? _error;
  DateTime? _lastRefresh;

  // Cache timeout in minutes
  static const int _cacheTimeoutMinutes = 5;

  // Streams for reactive updates
  final StreamController<List<HabbitModel>> _habitsController = 
      StreamController<List<HabbitModel>>.broadcast();
  final StreamController<Map<int, String>> _categoriesController = 
      StreamController<Map<int, String>>.broadcast();
  final StreamController<bool> _loadingController = 
      StreamController<bool>.broadcast();
  final StreamController<String?> _errorController = 
      StreamController<String?>.broadcast();

  // Getters for streams
  Stream<List<HabbitModel>> get habitsStream => _habitsController.stream;
  Stream<Map<int, String>> get categoriesStream => _categoriesController.stream;
  Stream<bool> get loadingStream => _loadingController.stream;
  Stream<String?> get errorStream => _errorController.stream;

  // Getters for current data
  List<HabbitModel> get habits => _habits;
  Map<int, String> get categoriesMap => _categoriesMap;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    if (_isInitialized && !_isLoading && _isCacheValid()) return;
    
    await _loadData();
    _isInitialized = true;
  }

  bool _isCacheValid() {
    if (_lastRefresh == null) return false;
    return DateTime.now().difference(_lastRefresh!).inMinutes < _cacheTimeoutMinutes;
  }

  Future<void> _loadData() async {
    _setLoading(true);
    _setError(null);

    try {
      // Use concurrency for faster loading
      final results = await Future.wait([
        _habitService.fetchHabbits(),
        _categoryService.fetchCategories(),
      ], eagerError: true);

      _habits = results[0] as List<HabbitModel>;
      final categories = results[1] as List<CategoryModel>;
      _categoriesMap = {for (var cat in categories) cat.id: cat.name};

      // Update cache timestamp
      _lastRefresh = DateTime.now();

      // Update streams
      _habitsController.add(_habits);
      _categoriesController.add(_categoriesMap);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> refreshData() async {
    await _loadData();
  }

  void addHabit(HabbitModel habit) {
    _habits.add(habit);
    _habitsController.add(_habits);
  }

  Future<HabbitModel> createHabit(String name, int categoryId) async {
    try {
      _setLoading(true);
      
      // Create habit in backend
      await _habitService.createHabit(name, categoryId);
      
      // Refresh data efficiently
      final newHabits = await _habitService.fetchHabbits();
      _habits = newHabits;
      _habitsController.add(_habits);
      
      // Return the newly created habit
      final newHabit = _habits.lastWhere((h) => h.name == name && h.categoryId == categoryId);
      return newHabit;
    } catch (e) {
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateHabitInBackend(String habitId, String newName) async {
    HabbitModel? originalHabit;
    try {
      _setLoading(true);
      
      // Optimistic update - update UI immediately
      final index = _habits.indexWhere((h) => h.id == habitId);
      
      if (index != -1) {
        originalHabit = _habits[index];
        _habits[index] = HabbitModel(
          id: _habits[index].id,
          userId: _habits[index].userId,
          name: newName,
          categoryId: _habits[index].categoryId,
          date: _habits[index].date,
          createdAt: _habits[index].createdAt,
        );
        _habitsController.add(_habits);
      }
      
      // Then update backend
      await _habitService.updateHabit(habitId, newName);
    } catch (e) {
      // Rollback on error
      final index = _habits.indexWhere((h) => h.id == habitId);
      if (index != -1 && originalHabit != null) {
        _habits[index] = originalHabit;
        _habitsController.add(_habits);
      }
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateHabitWithCategory(String habitId, String newName, int newCategoryId) async {
    HabbitModel? originalHabit;
    try {
      _setLoading(true);
      
      // Optimistic update - update UI immediately
      final index = _habits.indexWhere((h) => h.id == habitId);
      
      if (index != -1) {
        originalHabit = _habits[index];
        _habits[index] = HabbitModel(
          id: _habits[index].id,
          userId: _habits[index].userId,
          name: newName,
          categoryId: newCategoryId,
          date: _habits[index].date,
          createdAt: _habits[index].createdAt,
        );
        _habitsController.add(_habits);
      }
      
      // Then update backend
      await _habitService.updateHabitWithCategory(habitId, newName, newCategoryId);
    } catch (e) {
      // Rollback on error
      final index = _habits.indexWhere((h) => h.id == habitId);
      if (index != -1 && originalHabit != null) {
        _habits[index] = originalHabit;
        _habitsController.add(_habits);
      }
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  void removeHabit(String habitId) {
    _habits.removeWhere((h) => h.id == habitId);
    _habitsController.add(_habits);
  }

  Future<void> deleteHabit(String habitId) async {
    HabbitModel? deletedHabit;
    int? originalIndex;
    
    try {
      _setLoading(true);
      
      // Optimistic update - remove from UI immediately for faster response
      originalIndex = _habits.indexWhere((h) => h.id == habitId);
      if (originalIndex != -1) {
        deletedHabit = _habits[originalIndex];
        _habits.removeAt(originalIndex);
        _habitsController.add(_habits);
      }
      
      // Then delete from backend
      await _habitService.deleteHabit(habitId);
    } catch (e) {
      // Rollback on error - restore the habit at original position
      if (deletedHabit != null && originalIndex != null) {
        _habits.insert(originalIndex, deletedHabit);
        _habitsController.add(_habits);
      }
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    _loadingController.add(_isLoading);
  }

  void _setError(String? error) {
    _error = error;
    _errorController.add(_error);
  }

  void dispose() {
    _habitsController.close();
    _categoriesController.close();
    _loadingController.close();
    _errorController.close();
  }
}
