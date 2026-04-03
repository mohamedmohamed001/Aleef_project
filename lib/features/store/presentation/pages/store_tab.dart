import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'details_screen.dart';

class StoreTab extends StatefulWidget {
  const StoreTab({super.key});

  @override
  State<StoreTab> createState() => _StoreTabState();
}

class _StoreTabState extends State<StoreTab> {
  String selectedCategory = 'All';

  final List<String> categories = ['All', 'Dogs', 'Cats', 'Food', 'Toys'];

  final List<Map<String, dynamic>> allProducts = [
    {
      'name': 'Premium Dog food',
      'image': 'assets/images/Premium Dog Food.png',
      'price': '\$45.99',
      'categories': ['Food', 'Dogs'],
    },
    {
      'name': 'Interactive pet Toy',
      'image': 'assets/images/Interactive Pet Toy.png',
      'price': '\$18.50',
      'categories': ['Toys', 'Dogs'],
    },
    {
      'name': 'Adjustable pet collar',
      'image': 'assets/images/Adjustable Pet Collar.png',
      'price': '\$10.00',
      'categories': ['Dogs'],
    },
    {
      'name': 'Dog Chew Treats',
      'image': 'assets/images/Premium Dog Food.png',
      'price': '\$12.50',
      'categories': ['Food', 'Dogs'],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredProducts = selectedCategory == 'All'
        ? allProducts
        : allProducts
              .where(
                (p) => (p['categories'] as List).contains(selectedCategory),
              )
              .toList();

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            _buildSearchBar(),
            const SizedBox(height: 24),
            _buildSectionTitle('Categories'),
            const SizedBox(height: 12),
            _buildCategories(),
            const SizedBox(height: 24),
            _buildSectionTitle('Popular Products'),
            const SizedBox(height: 12),
            _buildProductGrid(filteredProducts),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      toolbarHeight: 80,
      centerTitle: false,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pet Shop',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          const Text(
            'Premium products for your pets',
            style: TextStyle(color: Color(0xFF949494), fontSize: 13),
          ),
        ],
      ),
      actions: [
        _buildIconWithBadge(
          icon: Icons.notifications_none_outlined,
          count: '3',
          badgeColor: const Color(0xFFE57373),
          onTap: () {},
        ),
        _buildIconWithBadge(
          icon: Icons.inventory_2_outlined,
          count: '',
          badgeColor: Colors.transparent,
          onTap: () {},
        ),
        _buildIconWithBadge(
          icon: Icons.shopping_cart_outlined,
          count: '2',
          badgeColor: const Color(0xFF5DB1A3),
          onTap: () {},
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildIconWithBadge({
    required IconData icon,
    required String count,
    required Color badgeColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(icon, color: const Color(0xFF2D3E4E), size: 28),
            if (count.isNotEmpty)
              Positioned(
                right: 0,
                top: 15,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: badgeColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    count,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search products...',
          hintStyle: TextStyle(fontSize: 14, color: AppColors.hint),
          prefixIcon: Icon(Icons.search, color: AppColors.hint),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFF1D1E20),
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildCategories() {
    return SizedBox(
      height: 38,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          bool isSelected = categories[index] == selectedCategory;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedCategory = categories[index];
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.inputFill,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  categories[index],
                  style: TextStyle(
                    color: isSelected ? AppColors.white : AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductGrid(List<Map<String, dynamic>> products) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemBuilder: (context, index) {
        return _buildProductCard(
          products[index]['name']!,
          products[index]['price']!,
          products[index]['image']!,
        );
      },
    );
  }

  Widget _buildProductCard(String name, String price, String imagePath) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                DetailsScreen(name: name, price: price, imagePath: imagePath),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.inputFill,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.pets, size: 40, color: Colors.grey),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: List.generate(
                      5,
                      (index) => const Icon(
                        Icons.star,
                        color: Color(0xFF5DB1A3),
                        size: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        price,
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.add,
                          color: AppColors.white,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
