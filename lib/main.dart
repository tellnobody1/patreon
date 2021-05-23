import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'cats.dart';
import 'creator.dart';
import 'data.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Патреон',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: MyHomePage(),
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
  
  Creator fetchFor(String account) {
    return data[account]!;
  }

  @override
  Widget build(BuildContext context) {
    Set<String> accounts;
    if (activeCat == 'Всі') accounts = cats.keys.where((x) => x != 'Иншомовні').expand((x) => cats[x]!).toSet();
    else accounts = cats[activeCat]!;
    var xs = accounts.map((a) => data[a]!).toList();
    xs.sort((a, b) {
      if (a.patrons == null && b.patrons == null) {
        if (a.earnings == null && b.earnings == null)
          return (a.name ?? "").compareTo(b.name ?? "");
        else if (a.earnings == null)
          return 1;
        else if (b.earnings == null)
          return -1;
        else
          return int.parse(a.earnings!.replaceFirst(RegExp(","), "")).compareTo(int.parse(b.earnings!.replaceFirst(RegExp(","), "")));
      } else if (a.patrons == null)
        return 1;
      else if (b.patrons == null)
        return -1;
      else
        return int.parse(a.patrons!.replaceFirst(RegExp(","), "")).compareTo(int.parse(b.patrons!.replaceFirst(RegExp(","), "")));
    });
    return Scaffold(
      appBar: AppBar(title: Text("Патреон")),
      body:
        Column(children: [
          if (expanded)
            Wrap(
              children: cats.keys.map((key) =>
                ChoiceChip(
                  label: Text(key),
                  selected: key == activeCat,
                  onSelected: (_) {
                    setState(() {
                      activeCat = key;
                      expanded = false;
                    });
                  }
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
                  ChoiceChip(label: Text(activeCat), selected: true),
                  Icon(Icons.expand_more, color: Colors.pink),
                ]
              )
            ),
          Expanded(child: ListView.builder(
            itemCount: xs.length,
            itemBuilder: (BuildContext context, int index) {
              var x = xs[index];
              Widget image = SizedBox(width: 100);
              if (x.img != null) {
                image = Image.network(x.img!, width: 100, errorBuilder: (context, exception, stackTrace) {
                  print(exception);
                  return SizedBox(width: 100);
                });
              }
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => launch('https://www.patreon.com/${x.account}'), 
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      image,
                      Column(children: [
                        Text(x.name ?? x.account),
                        Text(x.about?.replaceFirst('is creating', 'створює').replaceFirst('are creating', 'створюють') ?? ""),
                      ]),
                    ]),
                    Row(children: [
                      Column(children: [
                        Text('${x.patrons}'),
                        Text('патронів'),
                      ]),
                      Column(children: [
                        Text('${x.earnings}'),
                        Text('на місяць'),
                      ]),
                    ]),
                  ]
                )
              );
            }
          )),
        ]),
    );
  }
}
