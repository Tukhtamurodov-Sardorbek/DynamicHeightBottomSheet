import 'package:dynamicbottomsheet/src/wrapper.dart';
import 'package:flutter/material.dart';

List<ScrollController?> controllers = [
  ScrollController(),
  ScrollController(),
  null,
  ScrollController(),
  null,
  ScrollController(),
  null,
  ScrollController(),
];

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

  var icon = Icons.menu;

  @override
  Widget build(BuildContext context) {
    print('');
    print('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
    print('MAIN IS BUILT');
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Example",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(icon),
            onPressed: () {
              setState(() {
                icon = icon == Icons.menu ? Icons.account_circle_outlined : Icons.menu;
              });
            },
          )
        ],
      ),
      body: DynamicBottomSheet(
        heightFactor: 0.6,
        pageController: pageController,
        titles: const ['Title #1', 'Title #2', 'Title #3', 'Title #4', 'Title #5', 'Title #6', 'Title #7', 'Title #8',],
        scrollControllers: controllers,
        scaffoldBody: Background(),
        children: [
          ExpandableList(controller: controllers[0]!),
          MWidget(controller: controllers[1]!),
          Container(height: 150, color: Colors.amberAccent),
          MWidget(controller: controllers[3]!),
          Container(height: 400, color: Colors.greenAccent),
          ExpandableList(controller: controllers[5]!),
          Container(height: 500, color: Colors.teal),
          MWidget(controller: controllers[7]!),
        ],
      ),
    );
  }
}

class ExpandableList extends StatefulWidget {
  final ScrollController controller;

  const ExpandableList({Key? key, required this.controller}) : super(key: key);

  @override
  State<ExpandableList> createState() => _ExpandableListState();
}

class _ExpandableListState extends State<ExpandableList>
    with AutomaticKeepAliveClientMixin {
  int count = 2;
  Color color = Colors.orangeAccent;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView.builder(
      shrinkWrap: true,
      itemCount: count,
      padding: EdgeInsets.zero,
      controller: widget.controller,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              count = count == 22 ? 2 : count += 10;
              color = color == Colors.orangeAccent
                  ? Colors.pinkAccent
                  : Colors.orangeAccent;
            });
          },
          child: Container(
            height: 100,
            color: color,
            margin: const EdgeInsets.only(bottom: 4),
            child: Center(child: Text(index.toString())),
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class FWidget extends StatelessWidget {
  final ScrollController controller;

  const FWidget({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 10,
      padding: EdgeInsets.zero,
      controller: controller,
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
  final ScrollController controller;

  const MWidget({Key? key, required this.controller}) : super(key: key);

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
      controller: widget.controller,
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
