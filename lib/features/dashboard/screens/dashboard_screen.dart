import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sustainai_flutter/core/theme/app_theme.dart';
import 'package:sustainai_flutter/features/auth/providers/auth_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentNavIndex = 0;

  final List<Map<String, dynamic>> _categories = [
    {
      'name': 'Consumption',
      'icon': Icons.shopping_cart,
      'color': const Color(0xFF0f9f57),
      'route': '/consumption',
      'isActive': true,
    },
    {
      'name': 'Integrity',
      'icon': Icons.verified_user,
      'color': const Color(0xFF1A73E8),
      'route': '/financial-integrity',
      'isActive': true,
    },
    {
      'name': 'Wellbeing',
      'icon': Icons.favorite,
      'color': const Color(0xFFec4899),
      'route': '/wellbeing',
      'isActive': false,
    },
    {
      'name': 'Resilience',
      'icon': Icons.thunderstorm,
      'color': const Color(0xFFf59e0b),
      'route': '/disaster',
      'isActive': true,
    },
    {
      'name': 'Predictive',
      'icon': Icons.trending_up,
      'color': const Color(0xFF6366f1),
      'route': '/esg-analysis',
      'isActive': true,
    },
    {
      'name': 'Monitor',
      'icon': Icons.monitor_heart,
      'color': const Color(0xFF10b981),
      'route': '/sustainability-monitor',
      'isActive': true,
    },
  ];

  final List<Map<String, dynamic>> _modules = [
    {
      'title': 'Sustainable Consumption',
      'description':
          'Analyze environmental impact of daily habits with high-impact AI analysis.',
      'badge': 'HIGH IMPACT',
      'badgeIcon': Icons.energy_savings_leaf,
      'badgeColor': const Color(0xFF0f9f57),
      'imageUrl': 'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800',
      'route': '/consumption',
    },
    {
      'title': 'Financial Integrity',
      'description':
          'Transparent tracking of ethical investments and sustainable funding.',
      'badge': 'SECURED',
      'badgeIcon': Icons.shield,
      'badgeColor': const Color(0xFF1A73E8),
      'imageUrl': 'https://images.unsplash.com/photo-1639762681485-074b7f938ba0?w=800',
      'route': '/financial-integrity',
    },
    {
      'title': 'Sustainability Monitor',
      'description':
          'Real-time tracking of carbon footprint and ESG performance metrics.',
      'badge': 'REAL-TIME',
      'badgeIcon': Icons.query_stats,
      'badgeColor': const Color(0xFF10b981),
      'imageUrl': 'https://images.unsplash.com/photo-1518531933037-91b2f5f229cc?w=800',
      'route': '/sustainability-monitor',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final userInitials = authProvider.profile?.initials ?? 'U';

    return Scaffold(
      backgroundColor: const Color(0xFFf6f8f7),
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar
            _buildTopAppBar(userInitials),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hero Section
                    _buildHeroSection(),

                    // Category Icons
                    _buildCategoryIcons(),

                    // Active Modules Header
                    _buildSectionHeader(),

                    // Module Cards
                    _buildModuleCards(),

                    // Platform Overview
                    _buildPlatformOverview(),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildTopAppBar(String userInitials) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        border: const Border(
          bottom: BorderSide(color: Color(0xFFe5e7eb), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Eco Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF0f9f57).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.eco,
              color: Color(0xFF0f9f57),
              size: 24,
            ),
          ),

          // Title
          const Text(
            'SUSTAINAI',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111814),
              letterSpacing: 0.5,
            ),
          ),

          // Avatar
          CircleAvatar(
            radius: 20,
            backgroundColor: const Color(0xFFe5e7eb),
            child: Icon(
              Icons.account_circle,
              color: Colors.grey[600],
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Column(
        children: [
          const Text(
            'AI-Powered Sustainability & Wellbeing Platform',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111814),
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Intelligent insights for a greener future',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryIcons() {
    return SizedBox(
      height: 140, // Increased to prevent overflow
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isActive = category['isActive'] as bool;

          return GestureDetector(
            onTap: () {
              if (category['route'] != null) {
                Navigator.pushNamed(context, category['route'] as String);
              }
            },
            child: Container(
              margin: const EdgeInsets.only(right: 24),
              width: 72,
              child: Column(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: isActive
                          ? category['color'] as Color
                          : Colors.white,
                      border: isActive
                          ? null
                          : Border.all(color: const Color(0xFFe5e7eb)),
                      borderRadius: BorderRadius.circular(36),
                      boxShadow: isActive
                          ? [
                              BoxShadow(
                                color: (category['color'] as Color)
                                    .withOpacity(0.2),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : [],
                    ),
                    child: Icon(
                      category['icon'] as IconData,
                      color: isActive ? Colors.white : category['color'] as Color,
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    category['name'] as String,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF111814),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Active Modules',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111814),
            ),
          ),
          Text(
            'View All',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF0f9f57),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModuleCards() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _modules.length,
      itemBuilder: (context, index) {
        final module = _modules[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFe5e7eb)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Header with Badge
              Stack(
                children: [
                  // Image
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                    child: Container(
                      height: 160,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            (module['badgeColor'] as Color).withOpacity(0.3),
                            (module['badgeColor'] as Color).withOpacity(0.1),
                          ],
                        ),
                      ),
                      child: Icon(
                        Icons.eco,
                        size: 80,
                        color: (module['badgeColor'] as Color).withOpacity(0.2),
                      ),
                    ),
                  ),

                  // Gradient Overlay
                  Container(
                    height: 160,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.6),
                        ],
                      ),
                    ),
                  ),

                  // Badge
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: module['badgeColor'] as Color,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            module['badgeIcon'] as IconData,
                            color: Colors.white,
                            size: 14,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            module['badge'] as String,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      module['title'] as String,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111814),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      module['description'] as String,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // CTA Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (module['route'] != null) {
                            Navigator.pushNamed(
                                context, module['route'] as String);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0f9f57),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Open Module',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPlatformOverview() {
    final metrics = [
      {'label': 'TOTAL MODULES', 'value': '6', 'color': const Color(0xFF0f9f57)},
      {
        'label': 'ACTIVE ANALYSES',
        'value': '12',
        'color': const Color(0xFF1A73E8)
      },
      {
        'label': 'SUSTAINABILITY SCORE',
        'value': '88',
        'suffix': ' / 100',
        'color': const Color(0xFF0f9f57)
      },
      {
        'label': 'ALERTS GENERATED',
        'value': '3',
        'color': const Color(0xFFf59e0b)
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Platform Overview',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111814),
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.5,
            ),
            itemCount: metrics.length,
            itemBuilder: (context, index) {
              final metric = metrics[index];
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFe5e7eb)),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      metric['label'] as String,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          metric['value'] as String,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: metric['color'] as Color,
                          ),
                        ),
                        if (metric['suffix'] != null)
                          Text(
                            metric['suffix'] as String,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[400],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    final navItems = [
      {'icon': Icons.dashboard, 'label': 'Home'},
      {'icon': Icons.analytics, 'label': 'Insights'},
      {'icon': Icons.notifications, 'label': 'Alerts'},
      {'icon': Icons.settings, 'label': 'Settings'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        border: const Border(
          top: BorderSide(color: Color(0xFFe5e7eb), width: 1),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(navItems.length, (index) {
              final isActive = _currentNavIndex == index;
              final item = navItems[index];

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _currentNavIndex = index;
                  });
                  if (index == 3) {
                    Navigator.pushNamed(context, '/settings');
                  }
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      item['icon'] as IconData,
                      color: isActive
                          ? const Color(0xFF0f9f57)
                          : Colors.grey[400],
                      size: 24,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item['label'] as String,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                        color: isActive
                            ? const Color(0xFF0f9f57)
                            : Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
