import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SearchBar(),
            ),
            const CarouselWithIndicators(),
            const SizedBox(height: 20.0),
            _buildBoxesSection(context, 'الخدمات الحكومية'),
            _buildBoxesSection(context, 'المشاكل'),
            _buildBoxesSection(context, 'طلب الخدمات'),
          ],
        ),
      ),
    );
  }

  Widget _buildBoxesSection(BuildContext context, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            textDirection: TextDirection.rtl,
          ),
        ),
        const SizedBox(height: 10.0),
        SizedBox(
          height: 100.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 6,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ServiceDetailsScreen(
                        serviceName: '$title ${index + 1}'),
                  ),
                ),
                child: ServiceBox(title: '$title ${index + 1}'),
              );
            },
          ),
        ),
        const SizedBox(height: 20.0),
      ],
    );
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search For..?',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(25.0)),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}

class ServiceBox extends StatelessWidget {
  final String title;
  const ServiceBox({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90.0,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 4.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(color: Colors.black87, fontSize: 12.0),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class ServiceDetailsScreen extends StatelessWidget {
  final String serviceName;
  const ServiceDetailsScreen({super.key, required this.serviceName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(serviceName)),
      body: Center(
        child: Text(
          'تفاصيل الخدمة: $serviceName',
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

class CarouselWithIndicators extends StatefulWidget {
  const CarouselWithIndicators({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CarouselWithIndicatorsState createState() => _CarouselWithIndicatorsState();
}

class _CarouselWithIndicatorsState extends State<CarouselWithIndicators> {
  int _currentIndex = 0;
  final List<Map<String, String>> _imageData = const [
    {
      'url': 'https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0',
      'caption': 'محمد رمضان'
    },
    {
      'url': 'https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0',
      'caption': 'المكسيكي'
    },
    {
      'url': 'https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0',
      'caption': 'رابعه حاسبات'
    },
    {
      'url': 'https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0',
      'caption': 'التخرج'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          items: _imageData.map((data) => ImageCard(data: data)).toList(),
          options: CarouselOptions(
            height: 150.0,
            autoPlay: true,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) =>
                setState(() => _currentIndex = index),
          ),
        ),
        const SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_imageData.length,
              (index) => Indicator(isActive: _currentIndex == index)),
        ),
      ],
    );
  }
}

class ImageCard extends StatelessWidget {
  final Map<String, String> data;
  const ImageCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ServiceDetailsScreen(serviceName: data['caption']!),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Stack(
          children: [
            Image.network(data['url']!,
                fit: BoxFit.cover, width: double.infinity),
            Positioned(
              bottom: 20.0,
              left: 10.0,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                // ignore: deprecated_member_use
                color: Colors.black.withOpacity(0.15),
                child: Text(
                  data['caption']!,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Indicator extends StatelessWidget {
  final bool isActive;
  const Indicator({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8.0,
      height: 8.0,
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? Colors.green : Colors.grey,
      ),
    );
  }
}
