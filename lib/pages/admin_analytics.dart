import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color _cardBg = Color(0xFF131820);
const Color _accentPrimary = Color(0xFF00D9FF);
const Color _accentSecondary = Color(0xFF1E90FF);
const Color _warningColor = Color(0xFFFF6B35);
const Color _successColor = Color(0xFF00FF88);
const Color _errorColor = Color(0xFFFF3333);
const Color _textPrimary = Color(0xFFE8E8E8);
const Color _textSecondary = Color(0xFF8A8A8A);

class AdminAnalytics extends StatefulWidget {
  const AdminAnalytics({super.key});

  @override
  State<AdminAnalytics> createState() => _AdminAnalyticsState();
}

class _AdminAnalyticsState extends State<AdminAnalytics>
    with TickerProviderStateMixin {
  String _selectedPeriod = 'Monthly';

  // Animation Controllers
  late AnimationController _countUpController;
  late AnimationController _barBuildController;
  late AnimationController _cardFadeController;
  late AnimationController _arcFillController;
  late AnimationController _sectionLoadController;
  
  // Animations
  late Animation<double> _countUpAnimation;
  late Animation<double> _barBuildAnimation;
  late Animation<double> _cardFadeAnimation;
  late Animation<double> _arcFillAnimation;
  late List<Animation<double>> _sectionAnimations = [];
  
  // Hover states
  final Map<String, bool> _hoverStates = {};

  // Mockup Data
  final Map<String, Map<String, dynamic>> _mockupData = {
    'Weekly': {
      'totalCleanings': 127,
      'avgPerformance': 94.5,
      'robotUptime': 98.2,
      'activeAlerts': 3,
      'cleaningData': [45, 52, 38, 61, 55, 48, 42],
      'disposalData': [12, 15, 10, 18, 14, 16, 13],
      'alertData': [2, 1, 3, 2, 1, 2, 1],
      'uptimeData': {'uptime': 98.2, 'downtime': 1.8},
      'userActivity': [120, 135, 145, 160, 150, 140, 155],
    },
    'Monthly': {
      'totalCleanings': 1847,
      'avgPerformance': 96.8,
      'robotUptime': 97.5,
      'activeAlerts': 5,
      'cleaningData': [420, 485, 512, 430],
      'disposalData': [125, 145, 152, 130],
      'alertData': [8, 6, 5, 7],
      'uptimeData': {'uptime': 97.5, 'downtime': 2.5},
      'userActivity': [1850, 1920, 2100, 2050],
    },
    'Yearly': {
      'totalCleanings': 22456,
      'avgPerformance': 95.2,
      'robotUptime': 96.8,
      'activeAlerts': 12,
      'cleaningData': [1850, 1920, 2100, 2050, 2200, 2150, 2300, 2250, 2400, 2350, 2500, 2456],
      'disposalData': [520, 540, 580, 560, 600, 590, 620, 610, 640, 630, 660, 656],
      'alertData': [15, 18, 12, 20, 16, 14, 19, 17, 13, 15, 18, 12],
      'uptimeData': {'uptime': 96.8, 'downtime': 3.2},
      'userActivity': [22000, 22500, 23000, 23500, 24000, 24500, 25000, 25500, 26000, 26500, 27000, 27500],
    },
  };

  Map<String, dynamic> get _currentData => _mockupData[_selectedPeriod]!;

  @override
  void initState() {
    super.initState();
    
    // Count Up Animation (0.8-1.2s)
    _countUpController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _countUpAnimation = CurvedAnimation(
      parent: _countUpController,
      curve: Curves.easeOut,
    );

    // Bar Build Animation (0.3-0.5s)
    _barBuildController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _barBuildAnimation = CurvedAnimation(
      parent: _barBuildController,
      curve: Curves.easeOut,
    );

    // Card Fade-In Animation (0.2-0.4s)
    _cardFadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _cardFadeAnimation = CurvedAnimation(
      parent: _cardFadeController,
      curve: Curves.easeOut,
    );

    // Arc Fill Animation (0.3-0.5s)
    _arcFillController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _arcFillAnimation = CurvedAnimation(
      parent: _arcFillController,
      curve: Curves.easeOut,
    );

    // Section Load Animation (sequential)
    _sectionLoadController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    // Create animations for each section (5 sections)
    for (int i = 0; i < 5; i++) {
      _sectionAnimations.add(
        Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _sectionLoadController,
            curve: Interval(
              i * 0.15,
              (i * 0.15) + 0.3,
              curve: Curves.easeOut,
            ),
          ),
        ),
      );
    }

    // Start animations
    _startAnimations();
  }

  void _startAnimations() {
    // Start count-up immediately
    _countUpController.forward();
    
    // Start bar build with slight delay
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) _barBuildController.forward();
    });
    
    // Start card fade-in
    _cardFadeController.forward();
    
    // Start arc fill with delay
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _arcFillController.forward();
    });
    
    // Start sequential section loading
    _sectionLoadController.forward();
  }

  void _restartAnimations() {
    _countUpController.reset();
    _barBuildController.reset();
    _arcFillController.reset();
    _sectionLoadController.reset();
    _startAnimations();
  }

  @override
  void dispose() {
    _countUpController.dispose();
    _barBuildController.dispose();
    _cardFadeController.dispose();
    _arcFillController.dispose();
    _sectionLoadController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Analytics & Reports',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: _textPrimary,
                  letterSpacing: 0.3,
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: _cardBg,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: _accentPrimary.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: DropdownButton<String>(
                      value: _selectedPeriod,
                      items: ['Weekly', 'Monthly', 'Yearly'].map((period) {
                        return DropdownMenuItem(
                          value: period,
                          child: Text(
                            period,
                            style: GoogleFonts.poppins(
                              color: _textPrimary,
                              fontSize: 12,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _selectedPeriod = value);
                          _restartAnimations();
                        }
                      },
                      underline: const SizedBox(),
                      dropdownColor: _cardBg,
                      style: GoogleFonts.poppins(color: _textPrimary),
                      icon: Icon(
                        Icons.calendar_today,
                        color: _accentPrimary,
                        size: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: () => _showExportDialog(),
                    icon: const Icon(Icons.download),
                    label: Text(
                      'Export',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _accentSecondary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildAnimatedSection(_buildKPICards(), 0),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _buildAnimatedSection(_buildCleaningPerformanceChart(), 1)),
              const SizedBox(width: 16),
              Expanded(child: _buildAnimatedSection(_buildDisposalFrequencyChart(), 1)),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _buildAnimatedSection(_buildAlertTrendChart(), 2)),
              const SizedBox(width: 16),
              Expanded(child: _buildAnimatedSection(_buildRobotUptimeChart(), 2)),
            ],
          ),
          const SizedBox(height: 24),
          _buildAnimatedSection(_buildUserActivityChart(), 3),
          const SizedBox(height: 24),
          _buildAnimatedSection(_buildMonthlyInsights(), 4),
        ],
      ),
    );
  }

  Widget _buildKPICards() {
    final data = _currentData;
    return Row(
      children: [
        Expanded(
          child: _buildKPICard(
            'Total Cleanings',
            '${data['totalCleanings']}',
            Icons.cleaning_services,
            _accentPrimary,
            '+12.5%',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildKPICard(
            'Avg. Performance',
            '${data['avgPerformance']}%',
            Icons.trending_up,
            _successColor,
            '+2.3%',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildKPICard(
            'Robot Uptime',
            '${data['robotUptime']}%',
            Icons.check_circle,
            _successColor,
            'Optimal',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildKPICard(
            'Active Alerts',
            '${data['activeAlerts']}',
            Icons.warning,
            _warningColor,
            '-15%',
          ),
        ),
      ],
    );
  }

  // Animated Section Wrapper
  Widget _buildAnimatedSection(Widget child, int index) {
    if (index >= _sectionAnimations.length) return child;
    
    return AnimatedBuilder(
      animation: _sectionAnimations[index],
      builder: (context, child) {
        return Opacity(
          opacity: _sectionAnimations[index].value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - _sectionAnimations[index].value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  // Animated Count-Up Widget
  Widget _buildAnimatedNumber(String value, TextStyle style) {
    if (value.contains('%')) {
      final numValue = double.tryParse(value.replaceAll('%', '')) ?? 0.0;
      return AnimatedBuilder(
        animation: _countUpAnimation,
        builder: (context, child) {
          final animatedValue = numValue * _countUpAnimation.value;
          return Text(
            '${animatedValue.toStringAsFixed(1)}%',
            style: style,
          );
        },
      );
    } else if (value.contains(',')) {
      final numValue = int.tryParse(value.replaceAll(',', '')) ?? 0;
      return AnimatedBuilder(
        animation: _countUpAnimation,
        builder: (context, child) {
          final animatedValue = (numValue * _countUpAnimation.value).round();
          return Text(
            animatedValue.toString().replaceAllMapped(
              RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
              (Match m) => '${m[1]},',
            ),
            style: style,
          );
        },
      );
    } else {
      final numValue = int.tryParse(value) ?? 0;
      return AnimatedBuilder(
        animation: _countUpAnimation,
        builder: (context, child) {
          final animatedValue = (numValue * _countUpAnimation.value).round();
          return Text(
            animatedValue.toString(),
            style: style,
          );
        },
      );
    }
  }

  Widget _buildKPICard(
    String label,
    String value,
    IconData icon,
    Color color,
    String trend,
  ) {
    return AnimatedBuilder(
      animation: _cardFadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _cardFadeAnimation.value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - _cardFadeAnimation.value)),
            child: MouseRegion(
              onEnter: (_) {
                // Hover effect - subtle glow
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _cardBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.1 * _cardFadeAnimation.value),
                      blurRadius: 8,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(icon, color: color, size: 24),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            trend,
                            style: GoogleFonts.poppins(
                              fontSize: 8,
                              color: color,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildAnimatedNumber(
                      value,
                      GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: _textPrimary,
                      ),
                    ),
                    Text(
                      label,
                      style: GoogleFonts.poppins(fontSize: 11, color: _textSecondary),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCleaningPerformanceChart() {
    final data = _currentData['cleaningData'] as List<int>;
    final labels = _selectedPeriod == 'Weekly'
        ? ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
        : _selectedPeriod == 'Monthly'
            ? ['Week 1', 'Week 2', 'Week 3', 'Week 4']
            : ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final hoverKey = 'cleaning_performance';
    
    return MouseRegion(
      onEnter: (_) => setState(() => _hoverStates[hoverKey] = true),
      onExit: (_) => setState(() => _hoverStates[hoverKey] = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _accentPrimary.withValues(
              alpha: _hoverStates[hoverKey] == true ? 0.5 : 0.2,
            ),
            width: _hoverStates[hoverKey] == true ? 1.5 : 1,
          ),
          boxShadow: _hoverStates[hoverKey] == true
              ? [
                  BoxShadow(
                    color: _accentPrimary.withValues(alpha: 0.2),
                    blurRadius: 12,
                    spreadRadius: 0,
                  ),
                ]
              : [],
        ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Cleaning Performance',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: _textPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _accentPrimary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${data.reduce((a, b) => a + b)} sessions',
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: _accentPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 120,
            child: _buildSimpleBarChart(data, _accentPrimary),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: labels.map((label) {
              return Expanded(
                child: Center(
                  child: Text(
                    label,
                    style: GoogleFonts.poppins(fontSize: 9, color: _textSecondary),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildDisposalFrequencyChart() {
    final data = _currentData['disposalData'] as List<int>;
    final labels = _selectedPeriod == 'Weekly'
        ? ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
        : _selectedPeriod == 'Monthly'
            ? ['Week 1', 'Week 2', 'Week 3', 'Week 4']
            : ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final hoverKey = 'disposal_frequency';
    
    return MouseRegion(
      onEnter: (_) => setState(() => _hoverStates[hoverKey] = true),
      onExit: (_) => setState(() => _hoverStates[hoverKey] = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _accentSecondary.withValues(
              alpha: _hoverStates[hoverKey] == true ? 0.5 : 0.2,
            ),
            width: _hoverStates[hoverKey] == true ? 1.5 : 1,
          ),
          boxShadow: _hoverStates[hoverKey] == true
              ? [
                  BoxShadow(
                    color: _accentSecondary.withValues(alpha: 0.2),
                    blurRadius: 12,
                    spreadRadius: 0,
                  ),
                ]
              : [],
        ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Disposal Frequency',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: _textPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _accentSecondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${data.reduce((a, b) => a + b)} disposals',
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: _accentSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 120,
            child: _buildSimpleBarChart(data, _accentSecondary),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: labels.map((label) {
              return Expanded(
                child: Center(
                  child: Text(
                    label,
                    style: GoogleFonts.poppins(fontSize: 9, color: _textSecondary),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildAlertTrendChart() {
    final data = _currentData['alertData'] as List<int>;
    final labels = _selectedPeriod == 'Weekly'
        ? ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
        : _selectedPeriod == 'Monthly'
            ? ['Week 1', 'Week 2', 'Week 3', 'Week 4']
            : ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _warningColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Alert Trend Statistics',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: _textPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _warningColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${data.reduce((a, b) => a + b)} total',
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: _warningColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 120,
            child: _buildSimpleBarChart(data, _warningColor),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: labels.map((label) {
              return Expanded(
                child: Center(
                  child: Text(
                    label,
                    style: GoogleFonts.poppins(fontSize: 9, color: _textSecondary),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRobotUptimeChart() {
    final uptimeData = _currentData['uptimeData'] as Map<String, double>;
    final uptime = uptimeData['uptime']!;
    final downtime = uptimeData['downtime']!;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _successColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Robot Uptime vs Downtime',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: _textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: AnimatedBuilder(
                        animation: _arcFillAnimation,
                        builder: (context, child) {
                          final animatedUptime = (uptime / 100) * _arcFillAnimation.value;
                          final animatedUptimePercent = uptime * _arcFillAnimation.value;
                          
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: 100,
                                height: 100,
                                child: CircularProgressIndicator(
                                  value: animatedUptime,
                                  strokeWidth: 12,
                                  backgroundColor: _errorColor.withValues(alpha: 0.2),
                                  valueColor: AlwaysStoppedAnimation<Color>(_successColor),
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '${animatedUptimePercent.toStringAsFixed(1)}%',
                                    style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: _successColor,
                                    ),
                                  ),
                                  Text(
                                    'Uptime',
                                    style: GoogleFonts.poppins(
                                      fontSize: 10,
                                      color: _textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildUptimeLegend('Uptime', uptime, _successColor),
                    const SizedBox(height: 12),
                    _buildUptimeLegend('Downtime', downtime, _errorColor),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _successColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: _successColor.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle, color: _successColor, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            'System Healthy',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: _successColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUptimeLegend(String label, double value, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: _textSecondary,
            ),
          ),
        ),
        Text(
          '${value.toStringAsFixed(1)}%',
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildUserActivityChart() {
    final data = _currentData['userActivity'] as List<int>;
    final labels = _selectedPeriod == 'Weekly'
        ? ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
        : _selectedPeriod == 'Monthly'
            ? ['Week 1', 'Week 2', 'Week 3', 'Week 4']
            : ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _accentPrimary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'User Activity Analytics',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: _textPrimary,
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _accentPrimary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Active Users',
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      color: _textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 150,
            child: _buildLineChart(data, _accentPrimary),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: labels.map((label) {
              return Expanded(
                child: Center(
                  child: Text(
                    label,
                    style: GoogleFonts.poppins(fontSize: 9, color: _textSecondary),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLineChart(List<int> values, Color color) {
    if (values.isEmpty) return const SizedBox();
    
    final maxValue = values.reduce((a, b) => a > b ? a : b).toDouble();
    final minValue = values.reduce((a, b) => a < b ? a : b).toDouble();
    final range = maxValue - minValue;
    
    return AnimatedBuilder(
      animation: _barBuildAnimation,
      builder: (context, child) {
        return CustomPaint(
          size: const Size(double.infinity, 150),
          painter: _LineChartPainter(
            values,
            color,
            maxValue,
            minValue,
            range,
            _barBuildAnimation.value,
          ),
        );
      },
    );
  }

  Widget _buildActivityRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 12, color: _textSecondary),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: color, width: 0.5),
          ),
          child: Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMonthlyInsights() {
    final data = _currentData;
    final insights = _selectedPeriod == 'Weekly'
        ? [
            {'label': 'Peak Cleaning Day', 'value': 'Thursday (61 sessions)', 'icon': Icons.calendar_today},
            {'label': 'Avg. Sessions/Day', 'value': '18.1 sessions', 'icon': Icons.trending_up},
            {'label': 'Total Disposals', 'value': '${(data['disposalData'] as List<int>).reduce((a, b) => a + b)} times', 'icon': Icons.delete_outline},
            {'label': 'Efficiency Rate', 'value': '${data['avgPerformance']}%', 'icon': Icons.speed},
          ]
        : _selectedPeriod == 'Monthly'
            ? [
                {'label': 'Best Performing Week', 'value': 'Week 3 (512 sessions)', 'icon': Icons.star},
                {'label': 'Total Cleanings', 'value': '${data['totalCleanings']} sessions', 'icon': Icons.cleaning_services},
                {'label': 'System Reliability', 'value': '${data['robotUptime']}% uptime', 'icon': Icons.verified_user},
                {'label': 'Alert Resolution', 'value': '${(data['alertData'] as List<int>).reduce((a, b) => a + b)} alerts handled', 'icon': Icons.warning_amber},
              ]
            : [
                {'label': 'Annual Cleanings', 'value': '${data['totalCleanings']} total sessions', 'icon': Icons.cleaning_services},
                {'label': 'Peak Month', 'value': 'November (2,500 sessions)', 'icon': Icons.calendar_month},
                {'label': 'System Uptime', 'value': '${data['robotUptime']}% average', 'icon': Icons.cloud_done},
                {'label': 'User Growth', 'value': '+25% from last year', 'icon': Icons.trending_up},
              ];
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _accentPrimary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$_selectedPeriod Cleaning Insights',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: _textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          ...insights.map((insight) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildInsightItem(
                  insight['label'] as String,
                  insight['value'] as String,
                  insight['icon'] as IconData,
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildInsightItem(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: _accentPrimary, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(fontSize: 11, color: _textSecondary),
              ),
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: _textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSimpleBarChart(List<int> values, Color color) {
    if (values.isEmpty) {
      return const SizedBox();
    }
    
    final maxValue = values.reduce((a, b) => a > b ? a : b).toDouble();
    if (maxValue == 0) {
      return const SizedBox();
    }

    return AnimatedBuilder(
      animation: _barBuildAnimation,
      builder: (context, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: values.asMap().entries.map((entry) {
            final index = entry.key;
            final value = entry.value;
            final height = (value / maxValue) * 100;
            // Stagger animation for each bar
            final delay = (index / values.length) * 0.3;
            final barAnimation = (_barBuildAnimation.value - delay).clamp(0.0, 1.0);
            
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 50),
                      width: double.infinity,
                      height: (height.clamp(4.0, 100.0) * barAnimation),
                      curve: Curves.easeOut,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  void _showExportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _cardBg,
        title: Text(
          'Export Analytics Report',
          style: GoogleFonts.poppins(
            color: _textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          'Export $_selectedPeriod analytics as:',
          style: GoogleFonts.poppins(color: _textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(color: _textSecondary),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Report exported as PDF',
                    style: GoogleFonts.poppins(),
                  ),
                  backgroundColor: _successColor,
                ),
              );
            },
            icon: const Icon(Icons.picture_as_pdf),
            label: Text(
              'PDF',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: _accentPrimary,
              foregroundColor: Colors.black,
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Report exported as Excel',
                    style: GoogleFonts.poppins(),
                  ),
                  backgroundColor: _successColor,
                ),
              );
            },
            icon: const Icon(Icons.table_chart),
            label: Text(
              'Excel',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: _accentSecondary,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<int> values;
  final Color color;
  final double maxValue;
  final double minValue;
  final double range;
  final double animationValue;

  _LineChartPainter(
    this.values,
    this.color,
    this.maxValue,
    this.minValue,
    this.range,
    this.animationValue,
  );

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    final stepX = size.width / (values.length - 1);
    final padding = 20.0;

    // Calculate how many points to draw based on animation
    final totalPoints = values.length;
    final pointsToDraw = (totalPoints * animationValue).ceil();

    for (int i = 0; i < pointsToDraw; i++) {
      final x = i * stepX;
      final normalizedValue = range > 0 ? (values[i] - minValue) / range : 0.5;
      final y = size.height - (normalizedValue * (size.height - padding * 2)) - padding;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }

      // Draw point with fade-in effect
      final pointOpacity = i < pointsToDraw - 1 ? 1.0 : (animationValue * totalPoints) % 1.0;
      final animatedPointPaint = Paint()
        ..color = color.withValues(alpha: pointOpacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(x, y), 4, animatedPointPaint);
      canvas.drawCircle(Offset(x, y), 4, Paint()..color = Colors.white..style = PaintingStyle.fill);
      canvas.drawCircle(Offset(x, y), 2, animatedPointPaint);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
