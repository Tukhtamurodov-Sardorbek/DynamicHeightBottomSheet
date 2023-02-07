import 'package:dynamicbottomsheet/src/wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

List keys = List.generate(8, (index) => GlobalKey());

void main() {
  runApp(
    MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Snapping Sheet Examples',
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.grey[700],
            elevation: 0,
            foregroundColor: Colors.white,
            titleTextStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          primarySwatch: Colors.grey,
        ),
        home: const MyApp(),
      ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final PageController pageController = PageController();
  final ScrollController listViewController = ScrollController();

  @override
  Widget build(BuildContext context) {
    print('MAIN BUILT');
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Example",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {},
          )
        ],
      ),
      body: DynamicBottomSheet(
        heightFactor: 0.6,
        pageController: pageController,
        children: [
          FWidget(key: keys[0]),
          MWidget(key: keys[1]),
          Container(key: keys[2], height: 450, color: Colors.amberAccent,),
          MWidget(key: keys[3]),
          Container(key: keys[4], height: 400, color: Colors.greenAccent,),
          MWidget(key: keys[5]),
          Container(key: keys[6], height: 500, color: Colors.teal,),
          MWidget(key: keys[7]),
        ],
        scaffoldBody: Background(),
      ),
    );
  }

  Widget SWidget({required Key key}) {
    return Container(
      key: key,
      height: 180,
      color: Colors.deepPurple,
    );
  }

  Widget list({required Key key}) {
    return ListView(
      children: [
        Container(height: 180, color: Colors.deepPurple),
        Container(height: 180, color: Colors.deepOrange),
        Container(height: 180, color: Colors.deepPurpleAccent),
      ],
    );
  }
}
class FWidget extends StatelessWidget {
  const FWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 10,
      padding: EdgeInsets.zero,
      controller: ScrollController(),
      // physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
          height: 100,
          color: Colors.green[200],
          margin: const EdgeInsets.only(bottom: 4),
          child: Center(child: Text(index.toString())),
        );
      },
    );
  }
}

class MWidget extends StatefulWidget {
  const MWidget({Key? key}) : super(key: key);

  @override
  State<MWidget> createState() => _MWidgetState();
}

class _MWidgetState extends State<MWidget> {
  Color color = Colors.lightGreenAccent;

  @override
  void initState() {
    print('STATE IS CREATED (${widget.key})');
    super.initState();
  }

  @override
  void dispose() {
    print('STATE IS DISPOSED (${widget.key})');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              color = Colors.tealAccent;
            });
          },
          child: Container(
            height: 100,
            color: color,
            margin: const EdgeInsets.only(bottom: 4),
            child: const Center(child: Text('0')),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              color = Colors.tealAccent;
            });
          },
          child: Container(
            height: 100,
            color: color,
            margin: const EdgeInsets.only(bottom: 4),
            child: const Center(child: Text('1')),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              color = Colors.tealAccent;
            });
          },
          child: Container(
            height: 100,
            color: color,
            margin: const EdgeInsets.only(bottom: 4),
            child: const Center(child: Text('2')),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              color = Colors.tealAccent;
            });
          },
          child: Container(
            height: 100,
            color: color,
            margin: const EdgeInsets.only(bottom: 4),
            child: const Center(child: Text('3')),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              color = Colors.tealAccent;
            });
          },
          child: Container(
            height: 100,
            color: color,
            margin: const EdgeInsets.only(bottom: 4),
            child: const Center(child: Text('0')),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              color = Colors.tealAccent;
            });
          },
          child: Container(
            height: 100,
            color: color,
            margin: const EdgeInsets.only(bottom: 4),
            child: const Center(child: Text('1')),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              color = Colors.tealAccent;
            });
          },
          child: Container(
            height: 100,
            color: color,
            margin: const EdgeInsets.only(bottom: 4),
            child: const Center(child: Text('2')),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              color = Colors.tealAccent;
            });
          },
          child: Container(
            height: 100,
            color: color,
            margin: const EdgeInsets.only(bottom: 4),
            child: const Center(child: Text('3')),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
color = Colors.tealAccent;
});
},
child: Container(
height: 100,
color: color,
margin: const EdgeInsets.only(bottom: 4),
child: const Center(child: Text('0')),
),
),
GestureDetector(
onTap: () {
setState(() {
color = Colors.tealAccent;
});
},
child: Container(
height: 100,
color: color,
margin: const EdgeInsets.only(bottom: 4),
child: const Center(child: Text('1')),
),
),
GestureDetector(
onTap: () {
setState(() {
color = Colors.tealAccent;
});
},
child: Container(
height: 100,
color: color,
margin: const EdgeInsets.only(bottom: 4),
child: const Center(child: Text('2')),
),
),
GestureDetector(
onTap: () {
setState(() {
color = Colors.tealAccent;
});
},
child: Container(
height: 100,
color: color,
margin: const EdgeInsets.only(bottom: 4),
child: const Center(child: Text('3')),
),
),
],
);
}
}

class Background extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Placeholder(
      color: Colors.amberAccent,
    );
  }
}

class GrabbingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(blurRadius: 25, color: Colors.black.withOpacity(0.2)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 20),
            width: 100,
            height: 7,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          Container(
            color: Colors.grey[200],
            height: 2,
            margin: const EdgeInsets.all(15).copyWith(top: 0, bottom: 0),
          )
        ],
      ),
    );
  }
}