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
      body: Annabelle(5),
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

          const Text('ANNABELLE (2018) (18+)',textAlign: TextAlign.left, style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold, color: cinemaFontWhite)),

          LayoutBuilder(builder: (context, constraints) {
            if (constraints.maxWidth > 600) {
              return Row(
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
            const SizedBox(width: 15,),
            const Expanded (child: Text('Screen 7 \nShowing from Monday 26th Oct - Friday 30th Oct, 2026.',style: TextStyle(fontSize: 16,color: cinemaFontWhite)),
            ),
            ],
          );
          } else {
            return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
            const SizedBox(width: 15,),
            const Text('Screen 7 \nShowing from Monday 26th Oct - Friday 30th Oct, 2026.',style: TextStyle(color: cinemaFontWhite, fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          );
          }
        }),

          const SizedBox(height: 6),
          const Text('After a young couple loses their child, paranormal happenings begin to plague their home. \n2hrs 45mins | Horror | IMDB Rating: 4.67',textAlign: TextAlign.left, style: TextStyle(fontSize: 16, height: 2, fontWeight: FontWeight.bold, color: cinemaFontWhite)),
          const SizedBox(height: 10),
          const Order()
        ],
      )
    );
  }
}

class Order extends StatefulWidget{
  
  const Order({super.key});

  @override
  State<Order> createState() {
    return _Orders();
  }
}

class _Orders extends State<Order> {
  int maxTickets = 1 ;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:[
        Row(children: [DropdownMenu<int>(
          initialSelection: maxTickets,
          onSelected: (int? value) {
            if (value != null) {
              setState(() {
                maxTickets = value;
                });
              }
            },
            dropdownMenuEntries: const [
            DropdownMenuEntry(value: 1, label: '1'),
            DropdownMenuEntry(value: 2, label: '2'),
            DropdownMenuEntry(value: 3, label: '3'),
            DropdownMenuEntry(value: 4, label: '4'),
            DropdownMenuEntry(value: 5, label: '5'),
            ]),
            const SizedBox(width: 8),
            const Text('Adult (£7.50)'),
            const SizedBox(width: 5),
            const Text('*Discounts will be applied at checkout.',style: TextStyle(fontSize: 9))
          ]
        ),
      SizedBox(height: 10),
      ElevatedButton(onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Added $maxTickets ticket(s) to cart!')));},
        child: const Text('Add to order')),
      ] 
    );
  }
}
