import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:example/miniplayer.dart';
import 'package:example/src/globals.dart' as globals;
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';


void main() => runApp(MyApp());

final _navigatorKey = GlobalKey<NavigatorState>();
final _bottomNavigatorKey=GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Miniplayer example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFFFAFAFA),
      ),
      home: ChangeNotifierProvider<ValueNotifier<bool>>(
        create: (context)=>ValueNotifier<bool>(false),
        child: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int cur_ind=0;
  ListQueue p_state=ListQueue<int>();



  final List<Widget> pages=[FirstScreen(),SecondScreen(),ThirdScreen()];
  Future<bool> _onWill(){
      if (_navigatorKey.currentState.canPop()) {
        _navigatorKey.currentState.pop();
        return Future.value(false);
      }
      // if(_bottomNavigatorKey.currentState.canPop()){
      //   _bottomNavigatorKey.currentState.pop();
      //   return Future.value(false);
      // }



      setState(() {
        cur_ind=p_state.last;
        p_state.removeLast();
        print(cur_ind);
        print(p_state);
      });


    if(p_state.isEmpty){
      return Future.value(true);
    }
    //return Future.value(true);
  }
  @override
  Widget build(BuildContext context) {
    final notifier=Provider.of<ValueNotifier<bool>>(context,listen: false);
    //final mini=ValueNotifier<int>(0);
    return WillPopScope(
      onWillPop: _onWill,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            // pages[cur_ind],
            Navigator(
              key: _navigatorKey,
              onGenerateRoute: (RouteSettings settings) {
                print(_navigatorKey.currentState.toString());
                return MaterialPageRoute(
                  //settings: settings.copyWith(),
                  builder: (BuildContext context) => pages[cur_ind],
                );
              },
            ),
            Consumer<ValueNotifier<bool>>(
              // valueListenable: notifier,
              builder: (_,n,c)=>
              n.value==true?Miniplayer(
                minHeight: 70,
                maxHeight: 800,
                builder: (height, percentage) {
                  return miniplayer();
                },
              ):Container(),
            ),
          ],
        ),
        bottomNavigationBar: cur_ind!=2 ?BottomNavigationBar(
            key: _bottomNavigatorKey,

            onTap: (int index){
                while(_navigatorKey.currentState.canPop()){
                  _navigatorKey.currentState.pop();
                  //return Future.value(false);
                }
                print(notifier.value);
                print("bottom");
                setState(() {
                  if(p_state.isNotEmpty){
                    if(index!=cur_ind){
                      p_state.add(cur_ind);
                    }
                  }
                  else{
                    p_state.add(cur_ind);
                  }
                  cur_ind=index;
                  print(p_state);
                });

            },
            currentIndex: cur_ind,
            fixedColor: Colors.green,

            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                title: Text('Home'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.mail),
                title: Text('Messages'),
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), title: Text('Profile'))
            ],
          ):null,
        ),

    );
  }
}

class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final notifier=Provider.of<ValueNotifier<bool>>(context);
    //final mini=Provider.of<ValueNotifier<int>>(context);
    return WillPopScope(
      onWillPop: (){
        Navigator.pop(context);
      },
      child: Scaffold(
        appBar: AppBar(title: Text('Demo: FirstScreen')),
        body: Container(
          constraints: BoxConstraints.expand(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RaisedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FirstScreen()),
                  );
                },
                child: const Text('Open SecondScreen',
                    style: TextStyle(fontSize: 20)),
              ),
              RaisedButton(
                onPressed: () {
                  print("button");
                  print(notifier.value);
                  notifier.value=true;
                  print(notifier.value);
                  Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(builder: (context) => ThirdScreen()),
                  );
                },
                child: const Text('Open ThirdScreen with root Navigator',
                    style: TextStyle(fontSize: 20)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Demo: SecondScreen')),
      body: Center(child: Text('SecondScreen')),
    );
  }
}

class ThirdScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Demo: ThirdScreen')),
      body: Center(child: Text('ThirdScreen')),
    );
  }
}

class miniplayer extends StatefulWidget {
  @override
  _miniplayerState createState() => _miniplayerState();
}

class _miniplayerState extends State<miniplayer> {
  @override
  Widget build(BuildContext context) {
    final Size data=MediaQuery.of(context).size;
    return Container(
      color: Colors.amber,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SizedBox(height: data.height*0.07,),
              GestureDetector(onTap: (){},child: Container(width:data.width*0.7 ,height: data.height*0.5,color: Colors.blue)),
              //Image(image: AssetImage("assets/home/books/m5.jpg"),height:data.height*0.50,width:data.width*0.70),
              SizedBox(height: data.height*0.05,),
              Container(alignment: Alignment.center,child:Text("Some title",style: TextStyle(fontSize: 22,color: Colors.white),)),
              SizedBox(height: data.height*0.01,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  FlatButton(onPressed:()=>print("pressed"),child: Icon(Icons.ac_unit,color: Colors.black,)),
                  Icon(Icons.refresh,color: Colors.pink,),
                  Icon(Icons.play_arrow,color: Colors.blue,),
                ],
              ),]

        ),
      ),
    );
  }
}

// void main() => runApp(MyApp());
//
// final _navigatorKey = GlobalKey();
// bool flag=true;
//
// class MyApp extends StatelessWidget {
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Miniplayer example',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primaryColor: Color(0xFFFAFAFA),
//       ),
//       home: ChangeNotifierProvider<ValueNotifier<int>>(
//           create: (context)=>ValueNotifier<int>(0),
//           child: MyHomePage()
//       ),
//     );
//   }
// }
//
// class MyHomePage extends StatelessWidget {
//
//    final List<Widget> pages=[FirstScreen(),SecondScreen(),ThirdScreen()];
//    // final indexP=0;
//    final indexP=ChangeNotifierProvider<ValueNotifier<int>>(create: (_)=>ValueNotifier<int>(0));
//    //int indexP=0;
//    //bool mini=false;
//
//
//
//   Widget miniplayer(Size data){
//     return Container(
//       color: Colors.amber,
//       child: SingleChildScrollView(
//         physics: const NeverScrollableScrollPhysics(),
//         child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: <Widget>[
//               SizedBox(height: data.height*0.07,),
//               GestureDetector(onTap: (){},child: Container(width:data.width*0.7 ,height: data.height*0.5,color: Colors.blue)),
//               //Image(image: AssetImage("assets/home/books/m5.jpg"),height:data.height*0.50,width:data.width*0.70),
//               SizedBox(height: data.height*0.05,),
//               Container(alignment: Alignment.center,child:Text("Some title",style: TextStyle(fontSize: 22,color: Colors.white),)),
//               SizedBox(height: data.height*0.01,),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: <Widget>[
//                   FlatButton(onPressed:()=>print("pressed"),child: Icon(Icons.ac_unit,color: Colors.black,)),
//                   Icon(Icons.refresh,color: Colors.pink,),
//                   Icon(Icons.play_arrow,color: Colors.blue,),
//                 ],
//               ),]
//
//         ),
//       ),
//     );
//
//   }
//
//
//
//   //bool flag=true;
//   @override
//   Widget build(BuildContext context) {
//    // final mini=Provider.of<ValueNotifier<bool>>(context,listen: false);
//     Size data=MediaQuery.of(context).size;
//     return Scaffold(
//       body: Stack(
//         children: <Widget>[
//           Consumer<ValueNotifier<int>>(
//             builder: (_,indexP,__)=>
//             Navigator(
//               key: _navigatorKey,
//               onGenerateRoute: (RouteSettings settings) {
//                 return MaterialPageRoute(
//                   settings: settings,
//                   builder: (BuildContext context) => pages[indexP.value]//FirstScreen(),
//                 );
//               },
//             ),
//           ),
//           Miniplayer(
//             minHeight: 40,
//             maxHeight: 800,
//             //valueNotifier: playerExpandProgress,
//             builder: (height, percentage) {
//               return miniplayer(data);
//             },
//           ),
//         ],
//       ),
//       bottomNavigationBar: Consumer<ValueNotifier<int>>(
//
//         builder: (_,ind,__)=>
//         BottomNavigationBar(
//           onTap: (int index){
//             ind.value=index;
//             // setState(() {
//             //   print(index);
//             //   indexP=index;
//             // });
//
//             // Navigator.push(
//             //   context,
//             //   MaterialPageRoute(builder: (context) => Fir()),
//             // );
//           },
//           currentIndex: ind.value,
//           fixedColor: Colors.green,
//           items: [
//             BottomNavigationBarItem(
//               icon: Icon(Icons.home),
//               title: Text('Home'),
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.mail),
//               title: Text('Messages'),
//             ),
//             BottomNavigationBarItem(
//                 icon: Icon(Icons.person), title: Text('Profile'))
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class FirstScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Demo: FirstScreen')),
//       body: Container(
//         constraints: BoxConstraints.expand(),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             RaisedButton(
//               onPressed: () {
//                 flag=!flag;
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => SecondScreen()),
//                 );
//               },
//               child: const Text('Open SecondScreen',
//                   style: TextStyle(fontSize: 20)),
//             ),
//             RaisedButton(
//               onPressed: () {
//                 Navigator.of(context,rootNavigator: true).push(
//                   MaterialPageRoute(builder: (context) => ThirdScreen()),
//                 );
//               },
//               child: const Text('Open ThirdScreen with root Navigator',
//                   style: TextStyle(fontSize: 20)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class SecondScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Demo: SecondScreen')),
//       body: Center(child: RaisedButton(
//         onPressed: () {
//           Navigator.of(context,rootNavigator: true).push(
//             MaterialPageRoute(builder: (context) => ThirdScreen()),
//           );
//         },
//         child: const Text('Page to refresh',
//             style: TextStyle(fontSize: 20)),
//       ),),
//     );
//   }
// }
//
// class ThirdScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Demo: ThirdScreen')),
//       body: Center(child: Text('ThirdScreen')),
//     );
//   }
// }