import 'package:flutter/material.dart';

class viewpage extends StatefulWidget {
   // viewpage(String? aboutCompany, int index);

  String? aboutCompany;
  int index;

   viewpage(this.aboutCompany, this.index);


  @override
  State<viewpage> createState() => _viewpageState();
}

class _viewpageState extends State<viewpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Expanded(
        child: Container(
          height: 490,
          child: Column(
            children: [
              Container(
                width: 260,
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.all(6),
                child: Text("${widget.aboutCompany}",
                  style:
                  TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// setState(() {speechtotext.isNotListening ? startListening() : stopListening();
//   print(
//       '##@Rspeccchh${speechtotext.isNotListening}');
// });
//
// speechtotext.isNotListening ? Icons.mic_off : Icons.mic,









// showDialog(context: context, builder: (BuildContext){
// return
//
// AlertDialog(
// title: Text("Search"),
// content: Text("Hold to speak"),
// actions: [
// InkWell(onTap: (){
//
// },
// child: Container(
// child: Icon(
// speechtotext.isNotListening ? Icons.mic_off : Icons.mic,
// size: 70,color: Colors.blue,
// ),
// ),
// ),
//
// FlatButton(onPressed: () {
// Navigator.pop(context);
// }, child: Text("Cancel"))
// ],elevation: 35,
// backgroundColor: Colors.white,
// );
//  }
//  );







//
// InkWell(onTap: () {
// setState((){
//
// speechtotext.isNotListening ? startListening() : stopListening();
// print('##@Rspeccchh${speechtotext.isNotListening}');
//
// });
// },
// child: Container(color: Colors.grey,
// child: Icon(
// speechtotext.isNotListening ? Icons.mic_off : Icons.mic,
// size: 33,
// color: Colors.yellow,
// ),
// ),
// ),
