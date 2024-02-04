import 'package:flutter/material.dart';
import 'package:todo_app/view/components/calendar_view.dart';
import 'package:todo_app/view/components/home_view.dart';
import 'package:todo_app/view/pages/add_task.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _pageController = PageController();
  final _searchController = TextEditingController();
  var _selectedIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: kToolbarHeight * 1.5,
        title: SearchBar(
          hintText: "ToDos",
          leading: const Icon(Icons.search),
          backgroundColor: MaterialStateProperty.all<Color>(
            theme.colorScheme.primaryContainer,
          ),
          padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 16),
          ),
          controller: _searchController,
        ),
      ),
      body: PageView(
        pageSnapping: true,
        onPageChanged: (int index) {
          setState(() => _selectedIndex = index);
        },
        controller: _pageController,
        children: [
          HomeView(prefix: _searchController.text),
          CalendarView(prefix: _searchController.text),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) {
                return const AddTaskPage();
              },
            ),
          );
        },
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() => _selectedIndex = index);
          _pageController.animateToPage(
            _selectedIndex,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOutCubicEmphasized,
          );
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: "Home view",
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: "Calendar view",
          ),
        ],
      ),
    );
  }
}
