import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

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
  final Map<String, Set<String>> cats = {
    'Всі': {},
    'Авто': {'MaksPodzigun', 'autogeek', },
    'Благоустрій': {'chaplinskyvlog', 'dostupno2020', 'stop_goose', },
    'Військове': {'Lykhovii', 'milinua', 'informnapalm', },
    'Гумор': {'torontotv', 'kolegistudio', 'dostupno2020', 'dovkolabotanika', 'ninaukraine', 'verumT', 'uareview', },
    'Дизайн': {'telegrafdesign', },
    'Дітям': {'user?u=28899940', 'learningtogetherua', 'KhmarynkaUA', 'oum_spadshchyna', 'PaniVchytelka', 'pershosvit', },
    'Допомога': {'prytula', 'savelife_in_ua', 'uanimals', 'rsukraine_org_ua', 'serhiyzhadan', 'donorua', 'dostupno2020', 'heroyika', },
    'Екологія': {'NowasteUkraine', },
    'Ігри': {'PlayUA', 'mariamblog', 'vertigoUA', 'pad0n', 'rendarosua', 'gamer_fm', 'gamestreetua', 'PSUkraine', 'oldboiua', 'WBG', 'teoriyagry', },
    'Інвестиції': {'familybudgetcomua'},
    'Історія': {'imtgsh', 'historyUA', 'kozak_media', 'kgbfiles', },
    'Кіно': {'Geek_Journal', 'mariamblog', 'vertigoUA', 'pankarpan', 'zagin', 'animeK', 'mangua', 'asambleyA', 'miketvua', 'Salertino', },
    'Книги': {'annika_blog', 'vyshnevyjcvit', 'mariamblog', 'vertigoUA', 'knyzhkova_dylerka', 'GulbanuBibicheva', 'svitlana', 'robmenus', 'TheAsya', 'enma_and_books', 'kliusmarichka', 'liubovgoknyg', 'mangua', 'asambleyA', 'paralel3', 'kultpodcast', 'diasporiana', },
    'Культура': {'undergroundhumanities', 'vmistozher', 'raguli', },
    'Музика': {'UkrainianLiveClassic', 'zhadanisobaki', 'liroom', 'mefreel', },
    'Наука': {'CikavaNauka', 'rationalist', 'dovkolabotanika', 'pityatko', 'VorobieiBohdan', 'vsesvit_ua', 'naukaua', 'vsesvitua', },
    'Подорожі': {'ukrainer', 'user?u=44661751', 'lowcostua', },
    'Політика': {'skrypinua', 'sternenko', 'vatashow', 'bihusinfo', 'raguli', 'torontotv', 'ukrainianweek', 'textyorgua', 'Bykvu', 'informnapalm', 'slidstvo_info', 'portnikov', 'nestorvolya', },
    'Природа': {'propohody', 'user?u=44661751', },
    'Радіо': {'radioaristocrats', 'radioskovoroda', 'Hromadske_Radio', },
    'Творчість': {'user?u=16774315', 'uacomix', 'nicopogarskiy', 'prihodnik', 'Shablyk', 'bez_mezh_studios', 'sbt_localization', 'AdrianZP', 'gwean_maslinka', 'mariamblog', 'strugachka', 'cikavaideya', 'TheAsya', 'user?u=10599103', 'bbproject', 'fvua'},
    'Театр': {'les_kurbas_theatre', },
    'Texнології': {'tokar', 'viewua', 'itpassions', 'jarvis_net_ua', 'nonamepodcast', 'Pingvins', 'manifestplatform', 'naukaua', },
    'Різне': {'shitiknowlive', 'itworksonmypc', 'radioskorbota', 'lustrum', 'manifestplatform', 'balytska', 'kinshov', 'rist_center', 'inforules', 'behindthenews', 'iyura', 'musetang', 'radiopodil', 'need_science', },
    'Иншомовні': {'thealphacentauri', 'yanina', 'sershenzaritskaya', 'faideyren', 'bellatrixaiden', 'mukha', 'tanyacroft'},
  };
  String activeCat = 'Всі';
  bool expanded = false;
  
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
        var url = 'https://www.patreon.com/$account';
        var fullPage = !account.startsWith('user?u=');
        if (fullPage) url += '/posts';
        return http.Client().get(Uri.parse(url)).then((r) {
          var document = parse(r.body);
          var patrons = document.querySelector('div[data-tag=CampaignPatronEarningStats-patron-count]')?.firstChild?.text;
          var earnings = document.querySelector('div[data-tag=CampaignPatronEarningStats-earnings]')?.firstChild?.text;
          String? img;
          if (fullPage) img = document.querySelector('div[data-tag=CampaignInfoCard-social-links]')?.previousElementSibling?.previousElementSibling?.previousElementSibling?.firstChild?.attributes["src"];
          else img = document.querySelector('div[data-tag=CampaignPatronEarningStats-patron-count]')?.parent?.parent?.parent?.parent?.parent?.parent?.parent?.parent?.parent?.firstChild?.firstChild?.firstChild?.firstChild?.attributes["src"];
          String? name;
          if (fullPage) name = document.querySelector('div[data-tag=CampaignInfoCard-social-links]')?.previousElementSibling?.previousElementSibling?.text;
          else name = document.querySelector('div[data-tag=CampaignPatronEarningStats-patron-count]')?.parent?.parent?.parent?.parent?.parent?.parent?.previousElementSibling?.firstChild?.firstChild?.text;
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
    Set<String> accounts;
    if (activeCat == 'Всі') accounts = cats.keys.where((x) => x != 'Иншомовні').expand((x) => cats[x]!).toSet();
    else accounts = cats[activeCat]!;
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
            w = Column(children: [
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
                          Text(x.name ?? x.account),
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
            ]);
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
