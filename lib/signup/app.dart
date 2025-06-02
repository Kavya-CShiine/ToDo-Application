import 'package:flutter/material.dart';

void main() {
  runApp(const BreakfastApp());
}

class BreakfastApp extends StatelessWidget {
  const BreakfastApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Breakfast Recommendation',
      theme: ThemeData(
        fontFamily: 'Inter',
        scaffoldBackgroundColor: Colors.white,
        primarySwatch: Colors.blue,
      ),
      home: const BreakfastPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class BreakfastPage extends StatelessWidget {
  const BreakfastPage({Key? key}) : super(key: key);

  static const honeyPancakeImage =
      'https://storage.googleapis.com/a1aa/image/1d49d67d-c56b-4a16-6aec-363ddf2e7783.jpg';
  static const canaiBreadImage =
      'https://storage.googleapis.com/a1aa/image/c0a937b9-046f-4906-a49b-4379f31c13f7.jpg';
  static const blueberryPancakeImage =
      'https://storage.googleapis.com/a1aa/image/6aeae9c5-5ac2-4758-34b8-6f01900fb5ef.jpg';
  static const salmonNigiriImage =
      'https://storage.googleapis.com/a1aa/image/c368bdab-3eab-48fc-0630-7c02f3105c6b.jpg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          color: Colors.grey[700],
          onPressed: () {},
        ),
        title: const Text(
          'Breakfast',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz),
            color: Colors.grey[700],
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recommendation\nfor Diet',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 180,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _RecommendationCard(
                    backgroundColor: const Color(0xFFD7E8FF),
                    imageUrl: honeyPancakeImage,
                    imageAlt:
                        'Stack of honey pancakes with blueberries and syrup on a plate',
                    title: 'Honey Pancake',
                    subtitle: 'Easy | 30mins | 180kCal',
                    buttonText: 'View',
                    buttonColor: const Color(0xFF9BB9FF),
                    buttonTextColor: Colors.white,
                    onPressed: () {},
                  ),
                  const SizedBox(width: 16),
                  _RecommendationCard(
                    backgroundColor: const Color(0xFFFFE0E6),
                    imageUrl: canaiBreadImage,
                    imageAlt:
                        'Plate with canai bread and a small bowl of dipping sauce',
                    title: 'Canai Bread',
                    subtitle: 'Easy | 20mins | 210kCal',
                    buttonText: 'View',
                    buttonColor: Colors.transparent,
                    buttonTextColor: const Color(0xFFB89AFF),
                    onPressed: () {},
                    isTextButton: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Popular',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                children: [
                  _PopularItem(
                    imageUrl: blueberryPancakeImage,
                    imageAlt:
                        'Small stack of blueberry pancakes with blueberries on a plate',
                    title: 'Blueberry Pancake',
                    subtitle: 'Medium | 30mins | 230kCal',
                  ),
                  const SizedBox(height: 16),
                  _PopularItem(
                    imageUrl: salmonNigiriImage,
                    imageAlt: 'Two pieces of salmon nigiri sushi on a plate',
                    title: 'Salmon Nigiri',
                    subtitle: 'Easy | 20mins | 120kCal',
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

class _RecommendationCard extends StatelessWidget {
  final Color backgroundColor;
  final String imageUrl;
  final String imageAlt;
  final String title;
  final String subtitle;
  final String buttonText;
  final Color buttonColor;
  final Color buttonTextColor;
  final VoidCallback onPressed;
  final bool isTextButton;

  const _RecommendationCard({
    Key? key,
    required this.backgroundColor,
    required this.imageUrl,
    required this.imageAlt,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.buttonColor,
    required this.buttonTextColor,
    required this.onPressed,
    this.isTextButton = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final button = isTextButton
        ? TextButton(
            onPressed: onPressed,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9999),
              ),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              minimumSize: Size.zero,
            ),
            child: Text(
              buttonText,
              style: TextStyle(
                color: buttonTextColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        : ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9999),
              ),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              minimumSize: Size.zero,
              elevation: 0,
            ),
            child: Text(
              buttonText,
              style: TextStyle(
                color: buttonTextColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          );

    return Container(
      width: 144,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Semantics(
            label: imageAlt,
            child: Image.network(
              imageUrl,
              width: 72,
              height: 72,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 11,
              color: Color(0xFF9CA3AF), // gray-400
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          button,
        ],
      ),
    );
  }
}

class _PopularItem extends StatelessWidget {
  final String imageUrl;
  final String imageAlt;
  final String title;
  final String subtitle;

  const _PopularItem({
    Key? key,
    required this.imageUrl,
    required this.imageAlt,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Semantics(
          label: imageAlt,
          child: Image.network(
            imageUrl,
            width: 40,
            height: 40,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 11,
                  color: Color(0xFF9CA3AF), // gray-400
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
