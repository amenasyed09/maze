import 'package:flutter/material.dart';
import 'maze_builder_screen.dart';
import '../utils/constants.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Title
            Image.asset('assets/title.png',width: 150,),

              SizedBox(height: 10),

              Text(
                'Watch AI algorithms race to solve mazes!',
                style: TextStyle(fontSize: 16, color: Colors.brown,fontWeight: FontWeight.w900),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 20),


              // Start button
              GestureDetector(

onTap: (){
  Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => MazeBuilderScreen(),
  ));
},
                child: Image.asset('assets/start.png',width: 150,),
              ),


            ],
          ),
        ),
      ),
    );
  }

}
