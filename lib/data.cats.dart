final Map<String, Set<String>> cats = {
  'Всі': {},
  'Авто': {'autogeek'},
  'Архітектура': {'chaplinskyvlog', 'merezhyvo', 'ukrmod'},
  'Військове': {'AngryUA', 'informnapalm', 'Lykhovii', 'milinua'},
  'Готування': {'besahy'},
  'Гроші': {'costua', 'diypodcast', 'familybudgetcomua', 'goalsonfire', 'vovkst'},
  'Гумор': {'AniUA', 'dostupno2020', 'dovkolabotanika', 'horobyna', 'hotperevod', 'kartofanchyk', 'kolegistudio', 'ninaukraine', 'pereozvuchka_ua', 'shobsho', 'TA_studio', 'taytake', 'torontotv', 'uareview', 'verumT'},
  'Дизайн': {'telegrafdesign'},
  'Дітям': {'KhmarynkaUA', 'oum_spadshchyna', 'PaniVchytelka', 'pershosvit', 'user?u=28899940'},
  'Допомога': {'aiesechouseua', 'donorua', 'dostupno2020', 'heroyika', 'prytula', 'rsukraine_org_ua', 'serhiyzhadan', 'uanimals', 'ubmdr'},
  'Екологія': {'NowasteUkraine'},
  'Ігри': {'DITHOM', 'gamer_fm', 'gamestreetua', 'Geek_Informator', 'oldboiua', 'pad0n', 'PlayUA', 'PSUkraine', 'rendarosua', 'Tayemna_kimnata', 'teoriyagry', 'TheAsya', 'vertigoUA', 'WBG'},
  'Історія': {'docult', 'historyUA', 'historywall', 'imtgsh', 'kgbfiles', 'kozak_media', 'svitlotin', 'wildfoxfilm'},
  'Кіно': {'animeK', 'asambleyA', 'Geek_Informator', 'Geek_Journal', 'mangua', 'mariamblog', 'miketvua', 'pankarpan', 'Salertino', 'takflix', 'vertigoUA', 'zagin'},
  'Книги': {'23daphnia', 'annika_blog', 'asambleyA', 'beautyandgloom', 'chtyvo', 'chytomo', 'diasporiana', 'enma_and_books', 'GulbanuBibicheva', 'kliusmarichka', 'knyzhkova_dylerka', 'kultpodcast', 'kuznetsovalife', 'liubovgoknyg', 'mangua', 'mariamblog', 'paralel3', 'svitlana', 'symonenko', 'TheAsya', 'vertigoUA', 'vrajennya', 'vyshnevyjcvit'},
  'Культура': {'raguli', 'undergroundhumanities', 'vmistozher'},
  'Містознавство': {'chaplinskyvlog', 'dostupno2020', 'office_transformation', 'StopTheMoose'},
  'Музей': {'odesafineartsmuseum'},
  'Музика': {'bbproject', 'dailymetal_radiogarta', 'eileena', 'fromfaraway', 'liroom', 'LvivNationalPhilharmonic', 'mefreel', 'musetang', 'neformat', 'otvinta', 'palindrom', 'pivpodcast', 'slukh', 'uaestrada', 'ukrainedancing', 'UkrainianLiveClassic', 'vovazilvova', 'wszystko_band', 'zhadanisobaki'},
  'Навчання': {'blogmayster', 'dustanciyka', 'inforules', 'nareshticlub', 'need_science', 'vlad_storyteller', 'volyasovich'},
  'Наука': {'CikavaNauka', 'dovkolabotanika', 'enjoythescience', 'fazugenealogy', 'naukaua', 'pityatko', 'rationalist', 'uagenealogy', 'VorobieiBohdan', 'vsesvit_ua', 'vsesvitua'},
  'Переклад': {'amanogawa', 'anitubeinua', 'cikavaideya', 'fvua', 'gwean_maslinka', 'JBPetersonUkraine', 'sbt_localization', 'strugachka'},
  'Подорожі': {'dvokolisni_hroniky', 'findwayua', 'lowcostua', 'nebolviv', 'ukrainer', 'user?u=44661751'},
  'Політика': {'bihusinfo', 'Bykvu', 'EuropeanPravda', 'informnapalm', 'islndtv', 'mokrec', 'nestorvolya', 'omtvua', 'portnikov', 'raguli', 'skrypinua', 'slidstvo_info', 'sternenko', 'svidomi', 'textyorgua', 'torontotv', 'UA_direct_democracy', 'ukrainianweek', 'valerii', 'vatashow', 'zvedeno'},
  'Природа': {'propohody', 'user?u=44661751'},
  'Професійне': {'bazilikmedia', 'itguildukraine', 'loyer', 'oleksandr_ant', 'olesyabobruyko', 'rist_center', 'user?u=50286152'},
  'Радіо': {'BlogerFM', 'Hromadske_Radio', 'radioaristocrats', 'radioskovoroda', 'RockRadioUA'},
  'Спорт': {'belkininovak', 'MaksPodzigun', 'tatotake'},
  'Творчість': {'AdrianZP', 'bez_mezh_studios', 'comixua', 'nicopogarskiy', 'prihodnik', 'Shablyk', 'uacomix', 'user?u=16774315'},
  'Театр': {'les_kurbas_theatre', 'wild_theatre'},
  'Телеканал': {'ATR_UA'},
  'Texнології': {'itpassions', 'jarvis_net_ua', 'manifestplatform', 'naukaua', 'nonamepodcast', 'Pingvins', 'tokar', 'viewua'},
  'Різне': {'balytska', 'behindthenews', 'ChasIstoriy', 'inshe', 'itworksonmypc', 'iyura', 'krutoznavstvo', 'liganet', 'lustrum', 'manifestplatform', 'obrazpublicua', 'ppidcast', 'radiopodil', 'radioskorbota', 'shitiknowlive', 'soblya', 'tatysho', 'techtoloka', 'totem_publisher', 'zasnovnyky'},
  'Регіональне': {'berehtyIF', 'cukr', 'konotopcity', 'lyukmedia', 'razvelibardak', 'volynonline', 'zhyteli_kyieva'},
  'Иншомовні': {'5HT', 'allyourhtml', 'bellatrixaiden', 'Did_Oles_Falcon_UA', 'faideyren', 'happypaw', 'letslearnukrainian', 'mukha', 'rudnyi', 'sershenzaritskaya', 'tanyacroft', 'thealphacentauri', 'vatatv', 'vidminniotsinky', 'yanina'},
};
