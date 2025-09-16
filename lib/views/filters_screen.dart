import 'package:flutter/material.dart';
import '../../../themes/colors.dart'; // import EventHiveColors

class FiltersScreen extends StatefulWidget {
  const FiltersScreen({super.key});

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late AnimationController _scaleController;

  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  String searchText = '';
  bool isSearchFocused = false;

  final List<FilterCategory> categories = [
    FilterCategory(
      name: 'Sports',
      icon: Icons.sports_soccer,
      color: EventHiveColors.accent,
      isSelected: false,
    ),
    FilterCategory(
      name: 'Music',
      icon: Icons.music_note,
      color: EventHiveColors.primaryLight,
      isSelected: false,
    ),
    FilterCategory(
      name: 'Art',
      icon: Icons.palette,
      color: EventHiveColors.secondary,
      isSelected: false,
    ),
    FilterCategory(
      name: 'Food',
      icon: Icons.restaurant,
      color: EventHiveColors.accentLight,
      isSelected: false,
    ),
    FilterCategory(
      name: 'Travel',
      icon: Icons.flight,
      color: EventHiveColors.primary,
      isSelected: false,
    ),
    FilterCategory(
      name: 'Tech',
      icon: Icons.computer,
      color: EventHiveColors.secondaryLight,
      isSelected: false,
    ),
    FilterCategory(
      name: 'Fashion',
      icon: Icons.checkroom,
      color: EventHiveColors.primary,
      isSelected: false,
    ),
    FilterCategory(
      name: 'Books',
      icon: Icons.menu_book,
      color: EventHiveColors.accent,
      isSelected: false,
    ),
  ];

  final List<FilterOption> priceRanges = [
    FilterOption(label: 'Free', isSelected: false),
    FilterOption(label: '\$1 - \$10', isSelected: false),
    FilterOption(label: '\$11 - \$50', isSelected: false),
    FilterOption(label: '\$50+', isSelected: false),
  ];

  double _currentRating = 0;
  RangeValues _distanceRange = const RangeValues(0, 50);

  @override
  void initState() {
    super.initState();

    _slideController =
        AnimationController(duration: const Duration(milliseconds: 800), vsync: this);

    _fadeController =
        AnimationController(duration: const Duration(milliseconds: 600), vsync: this);

    _scaleController =
        AnimationController(duration: const Duration(milliseconds: 400), vsync: this);

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    // Start animations
    _slideController.forward();
    _fadeController.forward();
    _scaleController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _toggleCategory(int index) {
    setState(() {
      categories[index].isSelected = !categories[index].isSelected;
    });

    _scaleController.reset();
    _scaleController.forward();
  }

  void _togglePriceRange(int index) {
    setState(() {
      priceRanges[index].isSelected = !priceRanges[index].isSelected;
    });
  }

  void _clearAllFilters() {
    setState(() {
      for (var category in categories) {
        category.isSelected = false;
      }
      for (var price in priceRanges) {
        price.isSelected = false;
      }
      searchText = '';
      _currentRating = 0;
      _distanceRange = const RangeValues(0, 50);
    });
  }

  void _applyFilters() {
    final selectedCategories = categories
        .where((category) => category.isSelected)
        .map((category) => category.name)
        .toList();

    final selectedPrices = priceRanges
        .where((price) => price.isSelected)
        .map((price) => price.label)
        .toList();

    Navigator.pop(context, {
      'selectedCategories': selectedCategories,
      'selectedPrices': selectedPrices,
      'searchText': searchText,
      'rating': _currentRating,
      'distanceRange': _distanceRange,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EventHiveColors.background,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              EventHiveColors.primary.withOpacity(0.9),
              EventHiveColors.primary.withOpacity(0.7),
              EventHiveColors.secondary.withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: CircleAvatar(
                          backgroundColor: Colors.white.withOpacity(0.2),
                          child: Icon(Icons.arrow_back_ios, color: EventHiveColors.background, size: 20),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Text(
                          'Smart Filters',
                          style: TextStyle(
                            color: EventHiveColors.background,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: _clearAllFilters,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Clear All',
                            style: TextStyle(
                              color: EventHiveColors.background,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Container(
                    margin: const EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                      color: EventHiveColors.background,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSearchBar(),
                            const SizedBox(height: 32),
                            _buildSectionTitle('Categories', Icons.apps),
                            const SizedBox(height: 16),
                            _buildCategoriesGrid(),
                            const SizedBox(height: 32),
                            _buildSectionTitle('Price Range', Icons.attach_money),
                            const SizedBox(height: 16),
                            _buildPriceFilters(),
                            const SizedBox(height: 32),
                            _buildSectionTitle('Minimum Rating', Icons.star),
                            const SizedBox(height: 16),
                            _buildRatingFilter(),
                            const SizedBox(height: 32),
                            _buildSectionTitle('Distance Range', Icons.location_on),
                            const SizedBox(height: 16),
                            _buildDistanceFilter(),
                            const SizedBox(height: 100),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: MediaQuery.of(context).size.width - 40,
          height: 56,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: FloatingActionButton.extended(
            onPressed: _applyFilters,
            backgroundColor: EventHiveColors.primary,
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            label: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.tune, color: Colors.white),
                const SizedBox(width: 12),
                Text(
                  'Apply Filters (${_getSelectedCount()})',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildSearchBar() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSearchFocused
              ? EventHiveColors.primary.withOpacity(0.5)
              : Colors.grey.withOpacity(0.3),
          width: isSearchFocused ? 2 : 1,
        ),
      ),
      child: TextField(
        onChanged: (value) => setState(() => searchText = value),
        onTap: () => setState(() => isSearchFocused = true),
        onEditingComplete: () => setState(() => isSearchFocused = false),
        style: TextStyle(color: EventHiveColors.text),
        decoration: InputDecoration(
          hintText: 'Search anything...',
          hintStyle: TextStyle(color: EventHiveColors.text.withOpacity(0.5)),
          prefixIcon: Icon(Icons.search, color: EventHiveColors.text.withOpacity(0.6)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: EventHiveColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: EventHiveColors.primary, size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            color: EventHiveColors.text,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoriesGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 2.5,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return GestureDetector(
          onTap: () => _toggleCategory(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: category.isSelected
                  ? category.color
                  : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: category.isSelected
                    ? category.color
                    : Colors.grey.withOpacity(0.3),
                width: category.isSelected ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  category.icon,
                  color: category.isSelected
                      ? Colors.white
                      : EventHiveColors.text.withOpacity(0.7),
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    category.name,
                    style: TextStyle(
                      color: category.isSelected
                          ? Colors.white
                          : EventHiveColors.text,
                      fontSize: 14,
                      fontWeight: category.isSelected
                          ? FontWeight.bold
                          : FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPriceFilters() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: priceRanges.asMap().entries.map((entry) {
        final index = entry.key;
        final price = entry.value;
        return GestureDetector(
          onTap: () => _togglePriceRange(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: price.isSelected
                  ? EventHiveColors.primary
                  : Colors.white,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: price.isSelected
                    ? EventHiveColors.primary
                    : Colors.grey.withOpacity(0.3),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              price.label,
              style: TextStyle(
                color: price.isSelected
                    ? Colors.white
                    : EventHiveColors.text,
                fontWeight: price.isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRatingFilter() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: EventHiveColors.primary,
              inactiveTrackColor: Colors.grey.withOpacity(0.3),
              thumbColor: EventHiveColors.primary,
              overlayColor: EventHiveColors.primary.withOpacity(0.2),
              valueIndicatorColor: EventHiveColors.primary,
              activeTickMarkColor: Colors.white,
            ),
            child: Slider(
              value: _currentRating,
              min: 0,
              max: 5,
              divisions: 5,
              label: _currentRating.toStringAsFixed(1),
              onChanged: (value) => setState(() => _currentRating = value),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Rating: ${_currentRating.toStringAsFixed(1)}',
            style: TextStyle(
              color: EventHiveColors.text,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDistanceFilter() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: EventHiveColors.primary,
              inactiveTrackColor: Colors.grey.withOpacity(0.3),
              thumbColor: EventHiveColors.primary,
              overlayColor: EventHiveColors.primary.withOpacity(0.2),
              rangeThumbShape: RoundRangeSliderThumbShape(enabledThumbRadius: 8),
            ),
            child: RangeSlider(
              values: _distanceRange,
              min: 0,
              max: 100,
              divisions: 20,
              labels: RangeLabels(
                '${_distanceRange.start.round()} km',
                '${_distanceRange.end.round()} km',
              ),
              onChanged: (values) => setState(() => _distanceRange = values),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Distance: ${_distanceRange.start.round()} - ${_distanceRange.end.round()} km',
            style: TextStyle(
              color: EventHiveColors.text,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  int _getSelectedCount() {
    int count = 0;
    count += categories.where((c) => c.isSelected).length;
    count += priceRanges.where((p) => p.isSelected).length;
    if (_currentRating > 0) count++;
    if (_distanceRange.start > 0 || _distanceRange.end < 100) count++;
    return count;
  }
}

class FilterCategory {
  final String name;
  final IconData icon;
  final Color color;
  bool isSelected;

  FilterCategory({
    required this.name,
    required this.icon,
    required this.color,
    required this.isSelected,
  });
}

class FilterOption {
  final String label;
  bool isSelected;

  FilterOption({
    required this.label,
    required this.isSelected,
  });
}