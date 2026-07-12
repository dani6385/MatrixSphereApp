import 'package:flutter/material.dart';

class HeroBanner extends StatelessWidget {
  final VoidCallback onNavigateToSlides;
  const HeroBanner({super.key, required this.onNavigateToSlides});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onNavigateToSlides,
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: const DecorationImage(
            image: AssetImage('assets/images/img_hero_banner.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [Colors.transparent, const Color(0xCC090D1A)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0.5, 1.0],
            ),
          ),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "SS Seller Sphere",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Real-time Store Intelligence Pro",
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
