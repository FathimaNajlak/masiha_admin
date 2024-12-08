import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masiha_admin/presentation/widgets/requestPages/approved_requests.dart';
import 'package:masiha_admin/presentation/widgets/requestPages/pending_request.dart';
import 'package:masiha_admin/presentation/widgets/requestPages/rejected_request.dart';
import 'package:masiha_admin/utils/consts/colors.dart';

class AdminPanelPage extends StatefulWidget {
  const AdminPanelPage({super.key});

  @override
  _AdminPanelPageState createState() => _AdminPanelPageState();
}

class _AdminPanelPageState extends State<AdminPanelPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const PendingRequestsPage(),
    const AcceptedRequestsPage(),
    const RejectedRequestsPage(),
  ];

  final List<IconData> _icons = [
    Icons.pending_actions,
    Icons.check_circle,
    Icons.cancel,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkcolor,
        elevation: 2,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pushNamed(context, '/registration'),
        ),
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: 12),
            Text(
              'Admin Panel',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        toolbarHeight: 70,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.lightcolor,
              Colors.white,
            ],
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Enhanced Sidebar
            Card(
              margin: const EdgeInsets.all(16),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 250,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    for (int i = 0; i < 3; i++)
                      _buildSidebarButton(
                        getTitle(i),
                        i,
                        _icons[i],
                      ),
                  ],
                ),
              ),
            ),
            // Main Content with animation
            Expanded(
              child: Card(
                margin: const EdgeInsets.fromLTRB(0, 16, 16, 16),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                  child: _pages[_selectedIndex],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getTitle(int index) {
    switch (index) {
      case 0:
        return 'Pending Requests';
      case 1:
        return 'Accepted Requests';
      case 2:
        return 'Rejected Requests';
      default:
        return '';
    }
  }

  Widget _buildSidebarButton(String title, int index, IconData icon) {
    final isSelected = _selectedIndex == index;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isSelected
              ? Theme.of(context).primaryColor.withOpacity(0.1)
              : AppColors.background,
        ),
        child: ListTile(
          leading: Icon(
            icon,
            color: isSelected
                ? Theme.of(context).primaryColor
                : AppColors.lightcolor,
          ),
          title: Text(
            title,
            style: TextStyle(
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Colors.grey[800],
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          onTap: () => setState(() => _selectedIndex = index),
        ),
      ),
    );
  }
}
