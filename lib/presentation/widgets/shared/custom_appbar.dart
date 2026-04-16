import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final titleStyle = Theme.of(context).textTheme.titleMedium;

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              IconButton(icon: const Icon(Icons.movie_outlined), color: colors.primary, onPressed: () {}),
              Text('Cinemapedia', style: titleStyle!.copyWith(color: colors.primary)),
              const Spacer(),
              IconButton(icon: const Icon(Icons.search), color: colors.primary, onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
