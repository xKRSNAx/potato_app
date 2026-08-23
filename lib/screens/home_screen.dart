import 'package:flutter/material.dart';
import '../models/variety.dart';
import '../services/database_service.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseService _dbService = DatabaseService();
  List<PotatoVariety> _allVarieties = [];
  List<PotatoVariety> _filteredVarieties = [];
  bool _isLoading = true;
  String _searchQuery = '';

  // Наборы для мультивыбора фильтров
  final Set<String> _selectedMaturation = {};
  final Set<String> _selectedSkinColor = {};
  final Set<String> _selectedFleshColor = {};
  final Set<String> _selectedPurpose = {};
  final Set<String> _selectedCulinaryType = {};

  @override
  void initState() {
    super.initState();
    _loadVarieties();
  }

  Future<void> _loadVarieties() async {
    final varieties = await _dbService.getAllVarieties();
    setState(() {
      _allVarieties = varieties;
      _filteredVarieties = varieties;
      _isLoading = false;
    });
  }

  // ==========================================
  // УМНАЯ ЛОГИКА ФИЛЬТРАЦИИ
  // ==========================================
  void _applyFilters() {
    setState(() {
      _filteredVarieties = _allVarieties.where((v) {
        // Вспомогательная функция: проверяет, содержит ли целевая строка хотя бы одно из выбранных ключевых слов
        bool checkFilter(Set<String> selectedKeywords, String targetString) {
          if (selectedKeywords.isEmpty) return true; // Если фильтр не выбран, пропускаем всё
          final lowerTarget = targetString.toLowerCase();
          return selectedKeywords.any((keyword) => lowerTarget.contains(keyword.toLowerCase()));
        }

        // Проверяем все активные фильтры (логика И между категориями, ИЛИ внутри категории)
        return checkFilter(_selectedMaturation, v.maturationPeriod) &&
               checkFilter(_selectedSkinColor, v.skinColor) &&
               checkFilter(_selectedFleshColor, v.fleshColor) &&
               checkFilter(_selectedPurpose, v.purpose) &&
               checkFilter(_selectedCulinaryType, v.culinaryType) &&
               (_searchQuery.isEmpty || v.name.toLowerCase().contains(_searchQuery.toLowerCase()));
      }).toList();
    });
  }

  void _clearAllFilters() {
    setState(() {
      _selectedMaturation.clear();
      _selectedSkinColor.clear();
      _selectedFleshColor.clear();
      _selectedPurpose.clear();
      _selectedCulinaryType.clear();
      _searchQuery = '';
      _applyFilters();
    });
  }

  int get _activeFiltersCount {
    return _selectedMaturation.length +
        _selectedSkinColor.length +
        _selectedFleshColor.length +
        _selectedPurpose.length +
        _selectedCulinaryType.length;
  }

  // ==========================================
  // ИНТЕРФЕЙС ФИЛЬТРОВ (BOTTOM SHEET)
  // ==========================================
  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(20),
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.8,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Заголовок
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Фильтры', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      TextButton.icon(
                        onPressed: () {
                          setModalState(() {
                            _selectedMaturation.clear();
                            _selectedSkinColor.clear();
                            _selectedFleshColor.clear();
                            _selectedPurpose.clear();
                            _selectedCulinaryType.clear();
                          });
                        },
                        icon: const Icon(Icons.clear_all, size: 18),
                        label: const Text('Сбросить'),
                      ),
                    ],
                  ),
                  const Divider(),
                  
                  // Список фильтров
                  Expanded(
                    child: ListView(
                      children: [
                        _buildFilterSection(
                          'Срок созревания',
                          ['Ранний', 'Среднеранний', 'Среднеспелый', 'Среднепоздний', 'Поздний'],
                          _selectedMaturation,
                          (val) => setModalState(() {
                            _selectedMaturation.contains(val) 
                                ? _selectedMaturation.remove(val) 
                                : _selectedMaturation.add(val);
                          }),
                        ),
                        _buildFilterSection(
                          'Цвет кожуры',
                          ['Бел', 'Желт', 'Розов', 'Красн', 'Син', 'Фиолет'],
                          _selectedSkinColor,
                          (val) => setModalState(() {
                            _selectedSkinColor.contains(val) 
                                ? _selectedSkinColor.remove(val) 
                                : _selectedSkinColor.add(val);
                          }),
                        ),
                        _buildFilterSection(
                          'Цвет мякоти',
                          ['Бел', 'Желт', 'Крем', 'Син', 'Фиолет', 'Красн'],
                          _selectedFleshColor,
                          (val) => setModalState(() {
                            _selectedFleshColor.contains(val) 
                                ? _selectedFleshColor.remove(val) 
                                : _selectedFleshColor.add(val);
                          }),
                        ),
                        _buildFilterSection(
                          'Назначение',
                          ['Столов', 'Технич', 'Универс', 'Кормов'],
                          _selectedPurpose,
                          (val) => setModalState(() {
                            _selectedPurpose.contains(val) 
                                ? _selectedPurpose.remove(val) 
                                : _selectedPurpose.add(val);
                          }),
                        ),
                        _buildFilterSection(
                          'Кулинарный тип',
                          ['A', 'B', 'C', 'D'],
                          _selectedCulinaryType,
                          (val) => setModalState(() {
                            _selectedCulinaryType.contains(val) 
                                ? _selectedCulinaryType.remove(val) 
                                : _selectedCulinaryType.add(val);
                          }),
                        ),
                      ],
                    ),
                  ),
                  
                  // Кнопка применения
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _applyFilters();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        'Применить (${_filteredVarieties.length} сортов)',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFilterSection(
    String title,
    List<String> options,
    Set<String> selectedSet,
    Function(String) onToggle,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.grey)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: options.map((option) {
              final isSelected = selectedSet.contains(option);
              return FilterChip(
                label: Text(option),
                selected: isSelected,
                onSelected: (_) => onToggle(option),
                backgroundColor: Colors.grey.shade100,
                selectedColor: Colors.green.shade100,
                checkmarkColor: Colors.green.shade800,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.green.shade900 : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // ГЛАВНЫЙ ЭКРАН
  // ==========================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🥔 Сорта картофеля', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        actions: [
          if (_activeFiltersCount > 0 || _searchQuery.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              tooltip: 'Очистить все фильтры',
              onPressed: _clearAllFilters,
            ),
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.filter_list),
                if (_activeFiltersCount > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                      child: Text(
                        '$_activeFiltersCount',
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            tooltip: 'Фильтры',
            onPressed: _showFilterSheet,
          ),
        ],
      ),
      body: Column(
        children: [
          // Поле поиска
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                  _applyFilters();
                });
              },
              decoration: InputDecoration(
                hintText: 'Поиск по названию сорта...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          
          // Список сортов
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredVarieties.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off, size: 64, color: Colors.grey.shade400),
                            const SizedBox(height: 16),
                            Text(
                              'Сорта не найдены',
                              style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                            ),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: _clearAllFilters,
                              child: const Text('Сбросить фильтры'),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        itemCount: _filteredVarieties.length,
                        itemBuilder: (context, index) {
                          final variety = _filteredVarieties[index];
                          return _VarietyCard(
                            variety: variety,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailScreen(variety: variety),
                                ),
                              );
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

// =============================================
// КАРТОЧКА СОРТА В СПИСКЕ
// =============================================
class _VarietyCard extends StatelessWidget {
  final PotatoVariety variety;
  final VoidCallback onTap;

  const _VarietyCard({required this.variety, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.eco, size: 28, color: Colors.green.shade700),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      variety.name,
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black87),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        if (variety.maturationPeriod.isNotEmpty)
                          _InfoChip(icon: Icons.timer, label: variety.maturationPeriod.split(' ').first),
                        if (variety.purpose.isNotEmpty)
                          _InfoChip(icon: Icons.restaurant, label: variety.purpose),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey, size: 28),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.green.shade100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.green.shade700),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              style: TextStyle(fontSize: 11, color: Colors.green.shade800, fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}