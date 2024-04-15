import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({Key? key});

  @override
  Widget build(BuildContext context) {
    final List<News> news = [
      News(
        title: 'Noticia 1',
        description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin eros augue, volutpat in vestibulum a, porta a ante. Phasellus aliquam mi mauris, quis tincidunt elit rutrum tristique.',
        imageUrl: 'https://via.placeholder.com/150',
      ),
      News(
        title: 'Noticia 2',
        description: 'Praesent feugiat faucibus tempor. Cras id dui in felis malesuada mollis et eget purus. Proin rhoncus nisl metus, eget hendrerit lacus consectetur quis. Sed ac orci gravida, bibendum turpis facilisis, maximus mauris.',
        imageUrl: 'https://via.placeholder.com/150',
      ),
      News(
        title: 'Noticia 3',
        description: 'Aliquam erat volutpat. Nam accumsan rhoncus ligula et pharetra. Mauris finibus interdum magna, vel fringilla nunc sagittis eget. Nullam a augue ac ante euismod vehicula.',
        imageUrl: 'https://via.placeholder.com/150',
      ),
      News(
        title: 'Noticia 4',
        description: 'Aliquam erat volutpat. Nam accumsan rhoncus ligula et pharetra. Mauris finibus interdum magna, vel fringilla nunc sagittis eget. Nullam a augue ac ante euismod vehicula.',
        imageUrl: 'https://via.placeholder.com/150',
      ),
      News(
        title: 'Noticia 5',
        description: 'Aliquam erat volutpat. Nam accumsan rhoncus ligula et pharetra. Mauris finibus interdum magna, vel fringilla nunc sagittis eget. Nullam a augue ac ante euismod vehicula.',
        imageUrl: 'https://via.placeholder.com/150',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Información'),
      ),
      body: ListView.builder(
        itemCount: news.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              leading: Image.network(news[index].imageUrl),
              title: Text(news[index].title),
              subtitle: Text(news[index].description),
            ),
          );
        },
      ),
    );
  }
}

class News {
  final String title;
  final String description;
  final String imageUrl;

  News({required this.title, required this.description, required this.imageUrl});
}
