from lxml import html
import urllib.request

cats = {
  'Всі': {},
  'Авто': {'MaksPodzigun', 'autogeek', },
  'Благоустрій': {'chaplinskyvlog', 'dostupno2020' },
  'Військове': {'Lykhovii', 'milinua', 'informnapalm', 'AngryUA'},
  'Гумор': {'torontotv', 'kolegistudio', 'dostupno2020', 'dovkolabotanika', 'ninaukraine', 'verumT', 'uareview', 'pereozvuchka_ua'},
  'Дизайн': {'telegrafdesign', },
  'Дітям': {'user?u=28899940', 'KhmarynkaUA', 'oum_spadshchyna', 'PaniVchytelka', 'pershosvit', },
  'Допомога': {'prytula', 'savelife_in_ua', 'uanimals', 'rsukraine_org_ua', 'serhiyzhadan', 'donorua', 'dostupno2020', 'heroyika', },
  'Екологія': {'NowasteUkraine', },
  'Ігри': {'PlayUA', 'mariamblog', 'vertigoUA', 'pad0n', 'rendarosua', 'gamer_fm', 'gamestreetua', 'PSUkraine', 'oldboiua', 'WBG', 'teoriyagry', },
  'Інвестиції': {'familybudgetcomua'},
  'Історія': {'imtgsh', 'historyUA', 'kozak_media', 'kgbfiles', },
  'Кіно': {'Geek_Journal', 'mariamblog', 'vertigoUA', 'pankarpan', 'zagin', 'animeK', 'mangua', 'asambleyA', 'miketvua', 'Salertino', },
  'Книги': {'annika_blog', 'vyshnevyjcvit', 'mariamblog', 'vertigoUA', 'knyzhkova_dylerka', 'GulbanuBibicheva', 'svitlana', 'robmenus', 'TheAsya', 'enma_and_books', 'kliusmarichka', 'liubovgoknyg', 'mangua', 'asambleyA', 'paralel3', 'kultpodcast', 'diasporiana', 'beautyandgloom'},
  'Культура': {'undergroundhumanities', 'vmistozher', 'raguli', },
  'Музей': {'odesafineartsmuseum'},
  'Музика': {'UkrainianLiveClassic', 'zhadanisobaki', 'liroom', 'mefreel', 'slukh', 'uaestrada', 'ukrainedancing'},
  'Наука': {'CikavaNauka', 'rationalist', 'dovkolabotanika', 'pityatko', 'VorobieiBohdan', 'vsesvit_ua', 'naukaua', 'vsesvitua', },
  'Подорожі': {'ukrainer', 'user?u=44661751', 'lowcostua', 'nebolviv'},
  'Політика': {'skrypinua', 'sternenko', 'vatashow', 'bihusinfo', 'raguli', 'torontotv', 'ukrainianweek', 'textyorgua', 'Bykvu', 'informnapalm', 'slidstvo_info', 'portnikov', 'nestorvolya', 'valerii'},
  'Природа': {'propohody', 'user?u=44661751', },
  'Радіо': {'radioaristocrats', 'radioskovoroda', 'Hromadske_Radio', },
  'Творчість': {'user?u=16774315', 'uacomix', 'nicopogarskiy', 'prihodnik', 'Shablyk', 'bez_mezh_studios', 'sbt_localization', 'AdrianZP', 'gwean_maslinka', 'mariamblog', 'strugachka', 'cikavaideya', 'TheAsya', 'user?u=10599103', 'bbproject', 'fvua', 'JBPetersonUkraine'},
  'Театр': {'les_kurbas_theatre', },
  'Texнології': {'tokar', 'viewua', 'itpassions', 'jarvis_net_ua', 'nonamepodcast', 'Pingvins', 'manifestplatform', 'naukaua', },
  'Різне': {'shitiknowlive', 'itworksonmypc', 'radioskorbota', 'lustrum', 'manifestplatform', 'balytska', 'kinshov', 'rist_center', 'inforules', 'behindthenews', 'iyura', 'musetang', 'radiopodil', 'need_science', 'volyasovich' },
  'Иншомовні': {'thealphacentauri', 'yanina', 'sershenzaritskaya', 'faideyren', 'bellatrixaiden', 'mukha', 'tanyacroft', 'allyourhtml', '5HT'},
}

f = open('lib/data.dart', 'w')
# f = open('lib/data2.dart', 'w')
f.write("import 'creator.dart';\n\nfinal Map<String, Creator> data = {\n")

for account in sorted({x for v in cats.values() for x in v}, key=str.casefold):
# for account in { '' }:

  page = urllib.request.urlopen(f'https://www.patreon.com/{account}').read()
  tree = html.fromstring(page)

  patrons1 = tree.xpath('//div[@data-tag=\'CampaignPatronEarningStats-patron-count\']/h2/text()')
  patrons = f"'{patrons1[0]}'" if patrons1 else 'null'

  earnings1 = tree.xpath('//div[@data-tag=\'CampaignPatronEarningStats-earnings\']/h2/text()')
  dollar = '\\$'
  earnings = f"'{earnings1[0].replace('$', dollar)}'" if earnings1 else 'null'

  img1 = tree.xpath("//div[@data-tag='CampaignPatronEarningStats-patron-count']/../../../../../../../../../*/*/*/*/@src")
  img = f"'{img1[0]}'" if img1 else 'null'

  text = tree.xpath("//div[@data-tag='CampaignPatronEarningStats-patron-count']/../../../../../../preceding-sibling::*/*/*/text()")
  apostrophe1 = "'"
  apostrophe2 = "\\'"
  name = f"'{text[0].replace(apostrophe1, apostrophe2)}'" if len(text) >= 1 else 'null'
  about = f"'{text[1].replace(apostrophe1, apostrophe2)}'" if len(text) >= 2 else 'null'

  f.write(f"  '{account}': Creator(account: '{account}', patrons: {patrons}, earnings: {earnings}, img: {img}, name: {name}, about: {about}),\n")

f.write('};\n')
f.close()

f2 = open('lib/cats.dart', 'w')
f2.write('final Map<String, Set<String>> cats = {\n')

for c in cats.keys():
  xs = '{' + ', '.join(map(lambda x: f"'{x}'", sorted(cats[c], key=str.casefold))) + '},'
  f2.write(f"  '{c}': {xs}\n")

f2.write('};\n')
f2.close()
