import 'package:brightside_feed/model/category_tree_non_tech.dart';
import 'package:brightside_feed/model/category_tree_tech.dart';
import 'package:brightside_feed/model/item_data.dart';

class BasicTestUrls {
  static const String items_stored_string = 'number_of_items_stored';

  static List<String> testURLs = [
  'https://www.spiegel.de/politik/ausland/recep-tayyip-erdogan-tuerkei-nimmt-zehn-pensionierte-admirale-nach-kritik-am-kanal-istanbul-fest-a-166bdd33-6227-4fe9-92aa-94e12626d9be',
  'https://www.tagesschau.de/wirtschaft/verbraucher/bgh-influencer-101.html',
  'https://www.tagesschau.de/wirtschaft/technologie/intel-halbleiter-deutschland-gelsinger-101.html',
  'https://www.tagesschau.de/wirtschaft/unternehmen/exporte-materialmangel-101.html',
  'https://www.tagesschau.de/inland/btw21/klimaschutz-plaene-101.html',
  'https://www.tagesschau.de/wirtschaft/unternehmen/ueberbrueckungshilfe-verlaengert-101.html',
  'https://www.tagesschau.de/inland/ueberbrueckungshilfe-105.html',
  'https://open.spotify.com/episode/7hNGXd8kzHGvqMPRGTYLNa?si=ciC8dMxhRUqUpy4p0I3GPQ&dl_branch=1',
  'https://open.spotify.com/episode/2iduSsJK5zFAocRZ2JYZ5i?si=9iKGcg3jQZOB1wbSSYcGoQ&dl_branch=1',
  'https://open.spotify.com/episode/5okmrHZfc4ZJyAVfFQnUTr?si=hWvBVOLCRtSWibU9Wihpzw&dl_branch=1',
  'https://open.spotify.com/track/7abZZqdxmt369pf6VSHiy7?si=y2NdAmC_QW6MrhjVtgAjrA&utm_source=whatsapp',
  'https://twitter.com/elonmusk/status/1381273076709478403',
  'https://twitter.com/elonmusk/status/1423830326665650179?s=20',
  'https://twitter.com/ABaerbock/status/1434155555300466689?s=20',
  'https://twitter.com/ABaerbock/status/1433017064227328001?s=20',
  'https://www.youtube.com/watch?v=pb7_YJp9bVA',
  'https://www.youtube.com/watch?v=sVPYIRF9RCQ',
  'https://www.youtube.com/watch?v=SqGRnlXplx0',
  'https://www.youtube.com/watch?v=bfvyJ40HW60',
  ];

  static List<ItemData> testItemsRecent = [
    ItemData(
        url: 'https://edition.cnn.com/2021/06/08/europe/bubble-barrier-sea-c2e-spc-intl/index.html',
        title:
            'A \'Bubble Barrier\' is trapping plastic waste before it can get into the sea - CNN',
        description:
            'A stream of bubbles is catching trash in Amsterdam\'s Westerdok canal, preventing it from ultimately flowing into the North Sea.',
        // imageUrl:
            // 'https://cdn.cnn.com/cnnnext/dam/assets/210607120331-03-bubble-barrier-restricted-super-tease.jpg',
        categories: [kTechCategory, recyclingCategory]),
    ItemData(
        url:
            'https://efahrer.chip.de/solaranlagen/autobahnen-als-energiequelle-geniale-erfindung-kombiniert-solar-und-windkraft_105884',
        title:
            'Autobahnen als Energiequelle: Geniale Erfindung kombiniert Solar und Windkraft - EFAHRER.com',
        description:
            'Ein neues Pilotprogramm zur Gewinnung erneuerbarer Energien vereint Photovoltaik und Windkraft. Konkret handelt es sich um Solarbrücken über Autobahnen,...',
        // imageUrl:
        //     'https://im-efahrer.chip.de/files/3caff723-b300-4ffb-bf5a-ef11da859f41.jpg?imPolicy=IfOrientation&width=1200&height=630&color=%23000000&hash=f526d725c5cb7002f1cc7ce3395c6f6facb3e3980eb581228902de8f9af4fff5',
        categories: [kTechCategory, energyCategory, solarCategory, windCategory]),
    ItemData(
        url:
            'https://open.spotify.com/episode/7hNGXd8kzHGvqMPRGTYLNa?si=ciC8dMxhRUqUpy4p0I3GPQ&dl_branch=1',
        title: 'Episode 1: The Two Lands - The History of Egypt Podcast | Podcast on Spotify',
        description:
            'Listen to this episode from The History of Egypt Podcast on Spotify. On the banks of the Nile. Around 3,000 BCE (approximately), centuries of social change produced a unified Kingdom of Egypt...',
        // imageUrl: 'https://i.scdn.co/image/ab6765630000ba8a1c524fd740b3e8801f2cc87b',
    ),
    ItemData(
        url:
            'https://www.tagesschau.de/wirtschaft/unternehmen/ueberbrueckungshilfe-verlaengert-101.html',
        title: 'Noch bis Ende des Jahres: Corona-Überbrückungshilfen verlängert  | tagesschau.de',
        description:
            'Von der Corona-Krise schwer getroffene Unternehmen können auf weitere Unterstützung vom Staat bauen: Die Überbrückungshilfe III Plus wird bis Ende des Jahres verlängert. Auch die Hilfen für Solo-Selbstständige werden verlängert.',
        // imageUrl: 'https://www.tagesschau.de/multimedia/bilder/corona-hilfen-113~_v-original.jpg',
        categories: [kNonTechCategory, socialJusticeCategory]),
    ItemData(
        url: 'https://www.tagesschau.de/inland/ueberbrueckungshilfe-105.html',
        title:
            'Corona-Krise: Zwei-Millionen-Grenze bei Überbrückungshilfe gefallen | tagesschau.de',
        description:
            'Vom Corona-Lockdown betroffene Firmen können nun auch große Hilfsbeträge von mehr als zwei Millionen Euro beantragen. Hintergrund sind neue Vereinbarungen mit der EU-Kommission.',
        // imageUrl:
            // 'https://www.tagesschau.de/multimedia/bilder/ueberbrueckungshilfen-101~_v-original.jpg',
        categories: [kNonTechCategory, socialJusticeCategory]),
    // ItemData( url: 'https://open.spotify.com/track/7abZZqdxmt369pf6VSHiy7?si=y2NdAmC_QW6MrhjVtgAjrA&utm_source=whatsapp',title: 'Jessie\'s Girl - song by Rick Springfield | Spotify',description: 'Rick Springfield · Song · 1998',imageUrl: 'https://i.scdn.co/image/ab67616d0000b273e391545e9e1b5b672524dc70'),
    // ItemData( url: 'https://open.spotify.com/episode/5okmrHZfc4ZJyAVfFQnUTr?si=hWvBVOLCRtSWibU9Wihpzw&dl_branch=1',title: 'Episode 3: Horus vs Seth - The History of Egypt Podcast | Podcast on Spotify',description: 'Listen to this episode from The History of Egypt Podcast on Spotify. The Gods at War. Around 2850 BCE, Egypt\'s "Second Dynasty" began. This was an unstable period, with devastating climate change causing economic pressure and maybe civil war. This shadowy period might have inspired a great myth, a story of two gods battling for the throne (and heart) of Egypt\'s kingdom. In this story the great gods Horus and Seth went head to head... Date c.2850 - 2700 BCE, www.egyptianhistorypodcast.com, Support the Show at www.patreon.com/egyptpodcast, Facebook www.facebook.com/egyptpodcast, Twitter www.twitter.com/egyptianpodcast, Music by Keith Zizza www.keithzizza.com  See acast.com/privacy for privacy and opt-out information.',imageUrl: 'https://i.scdn.co/image/ab6765630000ba8ab93ca7be15b281a05f459450'),
    // ItemData( url: 'https://open.spotify.com/episode/2iduSsJK5zFAocRZ2JYZ5i?si=9iKGcg3jQZOB1wbSSYcGoQ&dl_branch=1',title: 'Episode 2: Horus Takes Flight - The History of Egypt Podcast | Podcast on Spotify',description: 'Listen to this episode from The History of Egypt Podcast on Spotify. Forming the Kingdom. The earliest rulers of Egypt are a curious bunch. Mighty rulers like Aha (possibly the first "true" King of Egypt) and Mer-Neith (the first female king) made their mark on this First Dynasty. They led wars, oversaw trade, and commissioned monuments. Along the way, they achieved historical immortality... Date c. 3000 - 2900 BCE, www.egyptianhistorypodcast.com, Support the Show at www.patreon.com/egyptpodcast, Facebook www.facebook.com/egyptpodcast, Twitter www.twitter.com/egyptianpodcast, Music by Keith Zizza www.keithzizza.com  See acast.com/privacy for privacy and opt-out information.',imageUrl: 'https://i.scdn.co/image/ab6765630000ba8accb8a2255c2dd38dc810a061'),
    // ItemData( url: 'https://twitter.com/ABaerbock/status/1434155555300466689?s=20',title: 'Annalena Baerbock on Twitter',description: 'Ich bewundere die Kraft der Menschen in #Altenahr. Viele von ihnen haben in der #Flutkatastrophe ihre Angehörigen verloren, ihr Zuhause, ihre Existenz. Sie schufften jeden Tag, um ihr Leben wieder aufzubauen. Es ist großartig, wie viele Ehrenamtliche helfen. Ganz großen Dank! pic.twitter.com/PmZ0LXl2vZ',imageUrl: 'https://pbs.twimg.com/media/E-ck33aXMAEWWZl.jpg:large'),
    // ItemData( url: 'https://twitter.com/elonmusk/status/1423830326665650179?s=20',title: 'Elon Musk on Twitter',description: 'pic.twitter.com/T6r96fqlPG',imageUrl: 'https://pbs.twimg.com/media/E8J2IurVcAE0Zrr.jpg:large'),
    ItemData(
        url: 'https://twitter.com/elonmusk/status/1381273076709478403',
        title: 'Elon Musk on Twitter',
        description: 'Love this beautiful shot',
        // imageUrl: 'https://pbs.twimg.com/profile_images/1438003019887611905/MnOz3sOj_400x400.jpg',
        categories: [kTechCategory]),
    // ItemData( url: 'https://twitter.com/ABaerbock/status/1433017064227328001?s=20',title: 'Annalena Baerbock on Twitter',description: 'Kinder sind nur so stark wie ihre Chancen. Dass unser Schulsystem Ungleichheit verstärkt statt behebt, ist ein Armutszeugnis. Eine Bildungsoffensive ist überfällig: stärkere Bundesfinanzierung, v.a. für Schulen in benachteiligten Gebieten & Ganztagsausbau mit Qualität. https://t.co/q9Pl4VedXy',imageUrl: 'https://pbs.twimg.com/profile_images/1426471191338958848/JgcGcBT8_400x400.jpg'),
    ItemData(
        url: 'https://www.youtube.com/watch?v=pb7_YJp9bVA',
        title: 'Make An Impact - Inspirational Video - YouTube',
        description:
            'http://benlionelscott.com/subscribe 👈 𝗗𝗼𝘄𝗻𝗹𝗼𝗮𝗱 𝘁𝗵𝗶𝘀 𝘃𝗶𝗱𝗲𝗼 𝗮𝗻𝗱 𝗮𝘂𝗱𝗶𝗼 𝘃𝗲𝗿𝘀𝗶𝗼𝗻 𝗯𝘆 𝘀𝘂𝗯𝘀𝗰𝗿𝗶𝗯𝗶𝗻𝗴 𝗼𝗻 𝗣𝗮𝘆𝗣𝗮𝗹, ?...',
        // imageUrl: 'https://i.ytimg.com/vi/pb7_YJp9bVA/maxresdefault.jpg',
        categories: [kNonTechCategory, otherNonTechCategory]),
    ItemData(
        url: 'https://www.youtube.com/watch?v=sVPYIRF9RCQ',
        title: 'THE SEED // Inspirational Short Film - YouTube',
        description:
            'THE SEED | Inspirational Short Film“Once the seed of faith takes root, it cannot be blown away, even by the strongest wind – Now that’s a blessing.”— RumiFor...',
        imageUrl: 'https://i.ytimg.com/vi/sVPYIRF9RCQ/maxresdefault.jpg',
        categories: [kNonTechCategory, otherNonTechCategory]),
    ItemData(
        url: 'https://www.youtube.com/watch?v=SqGRnlXplx0',
        title: 'A Valuable Lesson For A Happier Life - YouTube',
        description:
            'This is by far one of the most valuable lessons for a happier life. After reading the story by  Steven Covey I decided to produce this  video to share the me...',
        imageUrl: 'https://i.ytimg.com/vi/SqGRnlXplx0/maxresdefault.jpg',
        categories: [kNonTechCategory, otherNonTechCategory]),
    // ItemData( url: 'https://www.youtube.com/watch?v=bfvyJ40HW60',title: 'BOAT LIFE: Arriving in the Caribbean 🌴🌞 - YouTube',description: 'Grab yourself some swimwear for a good cause! http://www.vagabellaswim.com 🤍If you\'re ever in Antigua & Barbuda and keen to go spearfishing, get in touch wi...',imageUrl: 'https://i.ytimg.com/vi/bfvyJ40HW60/maxresdefault.jpg'),
  ];

  static List<ItemData> testItemsScrapedIncubator = [
    ItemData( url: 'https://www.tagesschau.de/wirtschaft/unternehmen/ueberbrueckungshilfe-verlaengert-101.html',title: 'Noch bis Ende des Jahres: Corona-Überbrückungshilfen verlängert  | tagesschau.de',description: 'Von der Corona-Krise schwer getroffene Unternehmen können auf weitere Unterstützung vom Staat bauen: Die Überbrückungshilfe III Plus wird bis Ende des Jahres verlängert. Auch die Hilfen für Solo-Selbstständige werden verlängert.',imageUrl: 'https://www.tagesschau.de/multimedia/bilder/corona-hilfen-113~_v-original.jpg'),
    ItemData( url: 'https://www.tagesschau.de/inland/ueberbrueckungshilfe-105.html',title: 'Corona-Krise: Zwei-Millionen-Grenze bei Überbrückungshilfe gefallen | tagesschau.de',description: 'Vom Corona-Lockdown betroffene Firmen können nun auch große Hilfsbeträge von mehr als zwei Millionen Euro beantragen. Hintergrund sind neue Vereinbarungen mit der EU-Kommission.',imageUrl: 'https://www.tagesschau.de/multimedia/bilder/ueberbrueckungshilfen-101~_v-original.jpg'),
  ];

  static List<ItemData> testItemsManualIncubator = [
    ItemData( url: 'https://www.youtube.com/watch?v=sVPYIRF9RCQ',title: 'THE SEED // Inspirational Short Film - YouTube',description: 'THE SEED | Inspirational Short Film“Once the seed of faith takes root, it cannot be blown away, even by the strongest wind – Now that’s a blessing.”— RumiFor...',imageUrl: 'https://i.ytimg.com/vi/sVPYIRF9RCQ/maxresdefault.jpg', categories: [kNonTechCategory, otherNonTechCategory]),
    ItemData( url: 'https://www.youtube.com/watch?v=SqGRnlXplx0',title: 'A Valuable Lesson For A Happier Life - YouTube',description: 'This is by far one of the most valuable lessons for a happier life. After reading the story by  Steven Covey I decided to produce this  video to share the me...',imageUrl: 'https://i.ytimg.com/vi/SqGRnlXplx0/maxresdefault.jpg', categories: [kNonTechCategory, otherNonTechCategory]),
    ItemData( url: 'https://efahrer.chip.de/solaranlagen/autobahnen-als-energiequelle-geniale-erfindung-kombiniert-solar-und-windkraft_105884',title: 'Autobahnen als Energiequelle: Geniale Erfindung kombiniert Solar und Windkraft - EFAHRER.com',description: 'Ein neues Pilotprogramm zur Gewinnung erneuerbarer Energien vereint Photovoltaik und Windkraft. Konkret handelt es sich um Solarbrücken über Autobahnen,...',imageUrl: 'https://im-efahrer.chip.de/files/3caff723-b300-4ffb-bf5a-ef11da859f41.jpg?imPolicy=IfOrientation&width=1200&height=630&color=%23000000&hash=f526d725c5cb7002f1cc7ce3395c6f6facb3e3980eb581228902de8f9af4fff5', categories: [kTechCategory, energyCategory, solarCategory, windCategory]),
    ItemData( url: 'https://open.spotify.com/episode/7hNGXd8kzHGvqMPRGTYLNa?si=ciC8dMxhRUqUpy4p0I3GPQ&dl_branch=1',title: 'Episode 1: The Two Lands - The History of Egypt Podcast | Podcast on Spotify',description: 'Listen to this episode from The History of Egypt Podcast on Spotify. On the banks of the Nile. Around 3,000 BCE (approximately), centuries of social change produced a unified Kingdom of Egypt...',imageUrl: 'https://i.scdn.co/image/ab6765630000ba8a1c524fd740b3e8801f2cc87b'),
  ];
}