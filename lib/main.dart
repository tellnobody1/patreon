import 'dart:math';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'cats.dart';
import 'data.dart';
import 'data2.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Українські творці з Patreon',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String activeCat = 'Всі';
  bool expanded = false;
  final scrollController = ScrollController();
  final random = new Random();

  @override
  Widget build(BuildContext context) {
    Set<String> accounts;
    if (activeCat == 'Всі') accounts = cats.keys.where((x) => x != 'Иншомовні' && x != 'Регіональне').expand((x) => cats[x]!).toSet();
    else accounts = cats[activeCat]!;
    var xs = accounts.map((a) => data[a]!).toList();
    xs.sort((a, b) {
      var x = a.patrons?.replaceFirst(RegExp(","), "") ?? "0";
      var y = b.patrons?.replaceFirst(RegExp(","), "") ?? "0";
      if (x == "0" && y != "0") return 1;
      else if (x != "0" && y == "0") return -1;
      else {
        if (x != y) return int.parse(x).compareTo(int.parse(y));
        else {
          var x = a.earnings?.replaceFirst(",", "").replaceFirst('€', '').replaceFirst('\$', '').replaceFirst('£', '') ?? "0";
          var y = b.earnings?.replaceFirst(",", "").replaceFirst('€', '').replaceFirst('\$', '').replaceFirst('£', '') ?? "0";
          if (x == y) return random.nextInt(3) - 1;
          else if (x == "0") return 1;
          else if (y == "0") return -1;
          else return int.parse(x).compareTo(int.parse(y));
        }
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: Text("Патреон"),
        actions: [
          PopupMenuButton(
            itemBuilder: (_) => [
              PopupMenuItem(value: "https://t.me/uaapps", child: Text("Пропозиції")),
              PopupMenuItem(value: "https://github.com/uaapps/patreon/releases/download/1.0/app-release.apk", child: Text("Android APK")),
              PopupMenuItem(value: "https://github.com/uaapps/patreon", child: Text("Джерельний код")),
            ],
            onSelected: (route) => launch('$route'),
            icon: Icon(Icons.more_vert),
          ),
        ],
      ),
      body:
        Column(children: [
          if (expanded)
            Wrap(
              children: cats.keys.map((key) =>
                Container(
                  margin: EdgeInsets.symmetric(vertical: 3, horizontal: 2),
                  child: 
                ChoiceChip(
                  label: Text(key),
                  selected: key == activeCat,
                  onSelected: (_) {
                    setState(() {
                      activeCat = key;
                      expanded = false;
                    });
                    scrollController.jumpTo(scrollController.position.minScrollExtent);
                  }
                )
                )
              ).toList()
            )
          else
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => setState(() => expanded = true),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(child: ChoiceChip(label: Text(activeCat), selected: true), margin: EdgeInsets.symmetric(vertical: 3, horizontal: 5)),
                  Container(child: Icon(Icons.expand_more, color: Colors.pink), margin: EdgeInsets.symmetric(vertical: 3, horizontal: 7)),
                ]
              )
            ),
          Expanded(child: ListView.separated(
            controller: scrollController,
            itemCount: xs.length,
            itemBuilder: (_, index) {
              final x = xs[index];
              final y = data2[x.account];
              Widget image = y?.img != null ?
                Container(
                  width: 100, 
                  height: 100, 
                  decoration: BoxDecoration(
                    shape: BoxShape.circle, 
                    image: DecorationImage(
                      image: NetworkImage(y!.img!), 
                      fit: BoxFit.cover
                    )
                  )
                )
                :
                SizedBox(width: 100);
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => launch('https://www.patreon.com/${x.account}'),
                child: Row(children: [
                  Container(child: image, margin: EdgeInsets.symmetric(horizontal: 5)),
                  Expanded(child: RichText(text: TextSpan(children: [
                    TextSpan(text: y?.name, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                    TextSpan(text: ' '),
                    TextSpan(text: y?.about, style: TextStyle(color: Colors.black)),
                  ]))),
                  Container(child: Column(
                    children: (x.patrons == null && x.earnings == null) ? [ Text('сховали') ] : x.patrons == '0' ? [ Text('0') ] : [
                      Text(x.patrons ?? 'сховали'),
                      Divider(),
                      Text(x.earnings ?? 'сховали'),
                    ], mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center
                  ), width: 70, height: 100),
                ])
              );
            },
            separatorBuilder: (x, y) => Divider(),
          )),
        ]),
    );
  }
}
