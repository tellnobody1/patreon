import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

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

class Creator {
  String account;
  String? patrons;
  String? earnings;
  String? img;
  String? name;
  Creator({required this.account, this.patrons, this.earnings, this.img, this.name});
  
  Creator.fromJson(Map<String, dynamic> json)
      : account = json['account'],
        patrons = json['patrons'],
        earnings = json['earnings'],
        img = json['img'],
        name = json['name'];

  Map<String, dynamic> toJson() => {
        'account': account,
        'patrons': patrons,
        'earnings': earnings,
        'img': img,
        'name': name,
      };
}

class _MyHomePageState extends State<MyHomePage> {
  final List<String> accounts = <String>['Lykhovii', 'tokar', 'propohody', 'viewua', 'CikavaNauka', 'skrypinua', 'rationalist', 'AdrianZP', 'PlayUA', 'Geek_Journal', 'annika_blog', 'imtgsh', 'chaplinskyvlog', 'familybudgetcomua', 'torontotv'];
  
  Future<Creator> fetchFor(String account) {
    return SharedPreferences.getInstance().then((prefs) {
      Creator? info = null;
      var json = prefs.getString(account);
      if (json != null)
        info = Creator.fromJson(jsonDecode(json));
      if (info != null)
        return info;
      else {
        print('http');
        return http.Client().get(Uri.parse('https://www.patreon.com/$account/posts')).then((r) {
          var document = parse(r.body);
          var patrons = document.querySelector('div[data-tag=CampaignPatronEarningStats-patron-count]')?.firstChild?.text;
          var earnings = document.querySelector('div[data-tag=CampaignPatronEarningStats-earnings]')?.firstChild?.text;
          var img = document.querySelector('div[data-tag=CampaignInfoCard-social-links]')?.previousElementSibling?.previousElementSibling?.previousElementSibling?.firstChild?.attributes["src"];
          var name = document.querySelector('div[data-tag=CampaignInfoCard-social-links]')?.previousElementSibling?.previousElementSibling?.text;
          var creator = Creator(account: account, patrons: patrons, earnings: earnings, img: img, name: name);
          return prefs.setString(account, jsonEncode(creator)).then((x) {
            return creator;
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Патреон"),
      ),
      body: FutureBuilder<List<Creator>>(
        future: Future.wait(accounts.map(fetchFor)).then((xs) {
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
          return xs;
        }),
        builder: (BuildContext context, AsyncSnapshot<List<Creator>> s) {
          Widget w;
          if (s.hasData) {
            var xs = s.data!;
            w = ListView.builder(
              itemCount: xs.length,
              itemBuilder: (BuildContext context, int index) {
                var x = xs[index];
                Widget image = SizedBox.shrink();
                if (x.img != null) {
                  image = Image(image: NetworkImage(x.img!), width: 100);
                }
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      image,
                      Column(children: [
                        Text(x.name ?? ""),
                        Text(x.account),
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
                );
              }
            );
          } else if (s.hasError) {
            w = Text(s.error.toString());
          } else {
            w = Text('Loading');
          }
          return w;
        }
      ),
    );
  }
}
