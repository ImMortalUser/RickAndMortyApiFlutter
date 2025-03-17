import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../blocs/theme/theme_block.dart';
import '../blocs/theme/theme_event.dart';
import 'all_screen.dart';
import 'favorite_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final LOGO_PADDING = 6;
  final LOAD_THRESHOLD = 5;
  final APPBAR_HEIGHT_PERCENT = 0.06;
  final CIRCULAR_LOADER_PADDING = 10.0;
  final BORDER_WIDTH = 1.0;

  int _sortOption = 0;
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    AllScreen(),
    FavoriteScreen(sortOption: 0),
  ];

  void _onSortSelected(int option) {
    setState(() {
      _sortOption = option;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight:
            MediaQuery.of(context).size.height * APPBAR_HEIGHT_PERCENT,
        leading: IconButton(
            onPressed: () {
              BlocProvider.of<ThemeBloc>(context).add(ToggleThemeEvent());
            },
            icon: Icon(Icons.dark_mode)),
        title: SvgPicture.asset(
          'assets/images/Rick_and_Morty.svg',
          height: MediaQuery.of(context).size.height * APPBAR_HEIGHT_PERCENT -
              LOGO_PADDING,
        ),
        actions: [
          Visibility(
            visible: _selectedIndex == 1,
            child: PopupMenuButton<int>(
              icon: Icon(Icons.keyboard_arrow_down),
              onSelected: (option) {
                _onSortSelected(option);
                setState(() {});
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 0,
                  child: Text("Name"),
                ),
                PopupMenuItem(
                  value: 1,
                  child: Text("Race"),
                ),
                PopupMenuItem(
                  value: 2,
                  child: Text("Status"),
                ),
              ],
            ),
          )
        ],
        centerTitle: true,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(
          color: Colors.grey,
          width: BORDER_WIDTH,
        ))),
        child: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.menu), label: ""),
            BottomNavigationBarItem(
                icon: _selectedIndex == 0
                    ? Icon(Icons.star_border)
                    : Icon(Icons.star),
                label: ""),
          ],
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          showSelectedLabels: false,
          showUnselectedLabels: false,
        ),
      ),
      body: _selectedIndex == 1
          ? FavoriteScreen(sortOption: _sortOption)
          : _screens[_selectedIndex],
    );
  }
}
