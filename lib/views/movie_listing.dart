import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/widgets/nav_drawer.dart';

class MovieListing extends StatelessWidget {
  const MovieListing({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(appTitle, style: cinemaHeaderStyle),
        backgroundColor: cinemaSurface,
        iconTheme: const IconThemeData(color: cinemaBrand),
        elevation: 0,
      ),
      drawer: const NavDrawer(),
      body: Annabelle(20),
    );
  }
}

class Annabelle extends StatelessWidget{
  final int maxTickets;

  const Annabelle(this.maxTickets,{super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(children: [const Text('ANNABELLE (2018) (18+)',textAlign: TextAlign.left, style: TextStyle(fontSize: 28))], 
          ),
          const SizedBox(height: 10),
          const Text('After a young couple loses their child, paranormal happenings begin to plague their home.',textAlign: TextAlign.left, style: TextStyle(fontSize: 16, height: 2)),
          const SizedBox(height: 10),
          
          const Text('2hrs 45mins | Horror | IMDB Rating: 4.67')

      ],)
    );
  }
}