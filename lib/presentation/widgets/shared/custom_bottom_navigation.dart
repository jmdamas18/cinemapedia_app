import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavigation extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavigation({super.key, required this.currentIndex});

  void onItemTapped(BuildContext context, int index) {
    context.go('/home/$index');
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: (index) => onItemTapped(context, index),
      elevation: 0,
      currentIndex: currentIndex,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Inicio'),
        BottomNavigationBarItem(icon: Icon(Icons.list_alt_outlined), label: 'Categorías'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite_outline), label: 'Favoritos'),
      ],
    );
  }
}
