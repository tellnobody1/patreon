from lxml import html
import urllib.request

cats = {
  'Всі': {},
  'Авто': {'autogeek'},
  'Архітектура': {'chaplinskyvlog', 'merezhyvo', 'ukrmod'},
  'Військове': {'Lykhovii', 'milinua', 'informnapalm', 'AngryUA'},
  'Готування': {'besahy'},
  'Гроші': {'familybudgetcomua', 'costua', 'diypodcast'},
  'Гумор': {'TA_studio', 'torontotv', 'kolegistudio', 'dostupno2020', 'dovkolabotanika', 'ninaukraine', 'verumT', 'uareview', 'pereozvuchka_ua', 'AniUA', 'horobyna', 'hotperevod', 'kartofanchyk', 'shobsho', 'taytake'},
  'Дизайн': {'telegrafdesign', },
  'Дітям': {'user?u=28899940', 'KhmarynkaUA', 'oum_spadshchyna', 'PaniVchytelka', 'pershosvit', },
  'Допомога': {'ubmdr', 'aiesechouseua', 'prytula', 'savelife_in_ua', 'uanimals', 'rsukraine_org_ua', 'serhiyzhadan', 'donorua', 'dostupno2020', 'heroyika', },
  'Екологія': {'NowasteUkraine', },
  'Ігри': {'PlayUA', 'vertigoUA', 'pad0n', 'rendarosua', 'gamer_fm', 'gamestreetua', 'PSUkraine', 'oldboiua', 'WBG', 'teoriyagry', 'TheAsya', 'DITHOM', 'Geek_Informator'},
  'Історія': {'imtgsh', 'historyUA', 'kozak_media', 'kgbfiles', 'docult', 'historywall', 'svitlotin', 'wildfoxfilm'},
  'Кіно': {'Geek_Journal', 'mariamblog', 'vertigoUA', 'pankarpan', 'zagin', 'animeK', 'mangua', 'asambleyA', 'miketvua', 'Salertino', 'Geek_Informator'},
  'Книги': {'kuznetsovalife', '23daphnia', 'annika_blog', 'vyshnevyjcvit', 'mariamblog', 'vertigoUA', 'knyzhkova_dylerka', 'GulbanuBibicheva', 'svitlana', 'robmenus', 'TheAsya', 'enma_and_books', 'kliusmarichka', 'liubovgoknyg', 'mangua', 'asambleyA', 'paralel3', 'kultpodcast', 'diasporiana', 'beautyandgloom', 'chtyvo', 'vrajennya'},
  'Культура': {'undergroundhumanities', 'vmistozher', 'raguli', },
  'Містознавство': {'chaplinskyvlog', 'dostupno2020', 'office_transformation', 'StopTheMoose'},
  'Музей': {'odesafineartsmuseum'},
  'Музика': {'vovazilvova', 'UkrainianLiveClassic', 'zhadanisobaki', 'liroom', 'mefreel', 'slukh', 'uaestrada', 'ukrainedancing', 'bbproject', 'musetang', 'dailymetal_radiogarta', 'eileena', 'fromfaraway', 'LvivNationalPhilharmonic', 'neformat', 'otvinta', 'palindrom', 'pivpodcast', 'wszystko_band'},
  'Навчання': {'need_science', 'volyasovich', 'inforules', 'blogmayster', 'dustanciyka', 'nareshticlub', 'vlad_storyteller'},
  'Наука': {'CikavaNauka', 'rationalist', 'dovkolabotanika', 'pityatko', 'VorobieiBohdan', 'vsesvit_ua', 'naukaua', 'vsesvitua', 'enjoythescience', 'fazugenealogy', 'uagenealogy', 'Lakuna'},
  'Переклад': {'amanogawa', 'anitubeinua', 'sbt_localization', 'gwean_maslinka', 'strugachka', 'cikavaideya', 'fvua', 'JBPetersonUkraine'},
  'Подорожі': {'ukrainer', 'user?u=44661751', 'lowcostua', 'nebolviv', 'dvokolisni_hroniky', 'findwayua'},
  'Політика': {'omtvua', 'skrypinua', 'sternenko', 'vatashow', 'bihusinfo', 'raguli', 'torontotv', 'ukrainianweek', 'textyorgua', 'Bykvu', 'informnapalm', 'slidstvo_info', 'portnikov', 'nestorvolya', 'valerii', 'islndtv', 'mokrec', 'svidomi', 'zvedeno'},
  'Природа': {'propohody', 'user?u=44661751', },
  'Професійне': {'itguildukraine', 'bazilikmedia', 'rist_center', 'loyer', 'oleksandr_ant', 'olesyabobruyko', 'user?u=50286152'},
  'Радіо': {'radioaristocrats', 'radioskovoroda', 'Hromadske_Radio', 'BlogerFM', 'RockRadioUA'},
  'Спорт': {'belkininovak', 'MaksPodzigun', 'tatotake'},
  'Творчість': {'user?u=16774315', 'uacomix', 'comixua', 'nicopogarskiy', 'prihodnik', 'Shablyk', 'bez_mezh_studios', 'AdrianZP'},
  'Театр': {'les_kurbas_theatre', 'wild_theatre'},
  'Телеканал': {'ATR_UA'},
  'Texнології': {'tokar', 'viewua', 'itpassions', 'jarvis_net_ua', 'nonamepodcast', 'Pingvins', 'manifestplatform', 'naukaua', },
  'Різне': {'obrazpublicua', 'shitiknowlive', 'itworksonmypc', 'radioskorbota', 'lustrum', 'manifestplatform', 'balytska', 'kinshov', 'behindthenews', 'iyura', 'radiopodil', 'ChasIstoriy', 'deadlinetalkshow', 'inshe', 'krutoznavstvo', 'liganet', 'ppidcast', 'soblya', 'tatysho', 'techtoloka', 'totem_publisher', 'zasnovnyky'},
  'Регіональне': {'berehtyIF', 'cukr', 'konotopcity', 'lyukmedia', 'razvelibardak', 'volynonline', 'zhyteli_kyieva'},
  'Иншомовні': {'vatatv', 'UA_direct_democracy', 'lee_online', 'happypaw', 'Did_Oles_Falcon_UA', 'thealphacentauri', 'yanina', 'sershenzaritskaya', 'faideyren', 'bellatrixaiden', 'mukha', 'tanyacroft', 'allyourhtml', '5HT', 'rudnyi', 'vidminniotsinky'},
}

suffix = ''
f = open(f'lib/data{suffix}.dart', 'w')
f_about = open(f'lib/data.about{suffix}.dart', 'w')
f_name = open(f'lib/data.name{suffix}.dart', 'w')
f_img= open(f'lib/data.img{suffix}.dart', 'w')

f.write("import 'creator.dart';\n\nfinal Map<String, Creator> data = {\n")
f_about.write("final Map<String, String> data_about = {\n")
f_name.write("final Map<String, String> data_name = {\n")
f_img.write("final Map<String, String> data_img = {\n")

i = 1
xs = sorted({x for v in cats.values() for x in v}, key=str.casefold)
# xs = {}
n = len(xs)
for account in xs:
  print(f"{i}/{n}", end='\r')
  i = i + 1

  page = urllib.request.urlopen(f'https://www.patreon.com/{account}').read()
  tree = html.fromstring(page)

  patrons1 = tree.xpath("//div[@data-tag='CampaignPatronEarningStats-patron-count']/h2/text()")
  patrons = f"'{patrons1[0]}'" if patrons1 else 'null'

  earnings1 = tree.xpath("//div[@data-tag='CampaignPatronEarningStats-earnings']/h2/text()")
  dollar = '\\$'
  earnings = f"'{earnings1[0].replace('$', dollar)}'" if earnings1 else 'null'

  img_path = tree.xpath("//*[@data-tag='reward-tier-card']/../../../../../../../../../../*/*/*/*/*/@src")
  if img_path:
    img = img_path[0]
  else:
    img_path = tree.xpath("//*[@data-tag='reward-tier-card']/../../../../../../../../../../*/*/*/*/@src")
    if img_path:
      img = img_path[0]
    else:
      img_path = tree.xpath("//div[@data-tag='CampaignPatronEarningStats-patron-count']/../../../../../../../../../*/*/*/*/@src")
      if img_path:
        img = img_path[0]
      else:
        img_path = tree.xpath("//*[@data-tag='creator-page-grid-cta']/../../../../../../*/*/*/*/@src")
        if img_path:
          img = img_path[0]
        else:
          img = ''
    
  ap1 = "'"
  ap2 = "\\'"

  name_path = tree.xpath("//*[@data-tag='reward-tier-card']/../../../../../../../../*/*/*[1]/text()")
  if name_path:
    name = name_path[0].replace(ap1, ap2)
  else:
    name_path = tree.xpath("//div[@data-tag='CampaignPatronEarningStats-patron-count']/../../../../../../../*/*/*[1]/text()")
    if name_path:
      name = name_path[0].replace(ap1, ap2)
    else:
      name_path = tree.xpath("//div[@data-tag='creator-page-grid-cta']/../../../../*/*/*[1]/text()")
      if name_path:
        name = name_path[0].replace(ap1, ap2)
      else:
        name = ''

  about_path = tree.xpath("//*[@data-tag='reward-tier-card']/../../../../../../../../*/*/*[2]/text()")
  if about_path:
    about = about_path[0].replace(ap1, ap2)
  else:
    about_path = tree.xpath("//div[@data-tag='CampaignPatronEarningStats-patron-count']/../../../../../../../*/*/*[2]/text()")
    if about_path:
      about = about_path[0].replace(ap1, ap2)
    else:
      about_path = tree.xpath("//div[@data-tag='creator-page-grid-cta']/../../../../*/*/*[1]/text()")
      if about_path:
        about = about_path[0].replace(ap1, ap2)
      else:
        about = ''

  f.write(f"  '{account}': Creator(account: '{account}', patrons: {patrons}, earnings: {earnings}),\n")
  f_img.write(f"  '{account}': '{img}',\n")
  f_name.write(f"  '{account}': '{name}',\n")
  f_about.write(f"  '{account}': '{about.replace('is creating', 'створює')}',\n")

f.write('};\n')
f_name.write('};\n')
f_about.write('};\n')
f_img.write('};\n')

f.close()
f_name.close()
f_about.close()
f_img.close()

f3 = open('lib/cats.dart', 'w')
f3.write('final Map<String, Set<String>> cats = {\n')

for c in cats.keys():
  xs = '{' + ', '.join(map(lambda x: f"'{x}'", sorted(cats[c], key=str.casefold))) + '},'
  f3.write(f"  '{c}': {xs}\n")

f3.write('};\n')
f3.close()
