import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'data.cats.dart';
import 'data.dart';
import 'data.img.dart';
import 'data.name.dart';
import 'data.about.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Українські творці на Patreon',
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
    var isAll = activeCat == 'Всі';
    if (isAll) accounts = cats.keys.where((x) => x != 'Иншомовні' && x != 'Регіональне').expand((x) => cats[x]!).toSet();
    else accounts = cats[activeCat]!;
    var xs = accounts.map((a) => data[a]!).where((x) => !isAll || !x.limit()).toList();
    xs.sort((a, b) {
      if (a.limit() && b.limit()) return random.nextInt(3) - 1;
      else if (a.limit()) return 1;
      else if (b.limit()) return -1;
      else {
        var ap = a.patrons ?? 0;
        var bp = b.patrons ?? 0;
        if (ap != bp) return ap.compareTo(bp);
        else {
          var ae = a.earnings?.value ?? 0;
          var be = b.earnings?.value ?? 0;
          if (ae != be) return ae.compareTo(be);
          else return random.nextInt(3) - 1;
        }
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: Text("Українські творці на патреоні"),
        actions: [
          PopupMenuButton(
            itemBuilder: (_) => [
              PopupMenuItem(value: "https://github.com/uaapps/patreon/issues", child: Text("Пропозиції")),
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
              final img = data_img[x.account];
              final name = data_name[x.account];
              final about = data_about[x.account];
              Widget image = img != null ?
                ClipOval(child:
                  CachedNetworkImage(
                    imageUrl: img,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    fit: BoxFit.cover,
                    width: 70,
                    height: 70,
                  )
                )
                :
                SizedBox(width: 70);
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => launch('https://www.patreon.com/${x.account}'),
                child: Row(children: [
                  Container(child: image, margin: EdgeInsets.symmetric(horizontal: 5)),
                  Expanded(child: RichText(text: TextSpan(children: [
                    TextSpan(text: name, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                    TextSpan(text: ' '),
                    TextSpan(text: about, style: TextStyle(color: Colors.black)),
                  ]))),
                  Container(child: Column(
                    children: (x.patrons == null && x.earnings == null) ? [ Text('сховали') ] : x.patrons == 0 ? [ Text('0') ] : [
                      Text(x.patrons?.toString() ?? 'сховали'),
                      Divider(),
                      Text(x.earnings != null ? x.earnings!.format() : 'сховали'),
                    ], mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center
                  ), width: 70, height: 70),
                ])
              );
            },
            separatorBuilder: (context, index) => Divider(),
          )),
        ]),
    );
  }
}
