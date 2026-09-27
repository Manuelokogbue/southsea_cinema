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
          const Text('ANNABELLE (2018) (18+)',textAlign: TextAlign.left, style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 170,
                height: 200,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(8)
                ),
                child: Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSuJHd2AqJObsvlsWjqUJ64PXY1Z1ue9_ge0NWnUT6GmYfZTGsgmd98_kU&s=10',width: 200, height: 200, alignment: Alignment.center,),
            ),
            const SizedBox(width: 10,),
            const Text('Screen 7 \nMonday 26th October, 2026',style: TextStyle(fontSize: 16),
            ),
            ],
          ),
          const SizedBox(height: 6),
          const Text('After a young couple loses their child, paranormal happenings begin to plague their home. \n2hrs 45mins | Horror | IMDB Rating: 4.67',textAlign: TextAlign.left, style: TextStyle(fontSize: 16, height: 2, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2)
      ],)
    );
  }
}