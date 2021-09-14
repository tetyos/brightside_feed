import 'package:inspired/components/preview_data_loader.dart';

class BasicTestUrls {
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

  static List<ItemData> testPreviewData = [
    ItemData(url: 'https://www.spiegel.de/politik/ausland/recep-tayyip-erdogan-tuerkei-nimmt-zehn-pensionierte-admirale-nach-kritik-am-kanal-istanbul-fest-a-166bdd33-6227-4fe9-92aa-94e12626d9be',title: 'Türkei: Zehn pensionierte Admirale nach Kritik am Kanal Istanbul festgenommen - DER SPIEGEL',description: 'Präsident Erdoğan plant einen Kanal als Alternative zur engen Durchfahrt am Bosporus. Kritik an seinem Milliardenprojekt sieht er als Verbrechen gegen die staatliche Ordnung. Seine Behörden erlassen Haftbefehle.',imageUrl: 'https://cdn.prod.www.spiegel.de/images/a401715d-0001-0004-0000-000001327322_w1280_r1.77_fpx52_fpy98.jpg'),
    ItemData( url: 'https://www.tagesschau.de/wirtschaft/verbraucher/bgh-influencer-101.html',title: 'Produktbeiträge ohne Werbehinweis: Erfolg für Influencerinnen  | tagesschau.de',description: 'Der Bundesgerichtshof hat entschieden, dass Influencer auf Produkte verweisen dürfen, ohne es als Werbung zu kennzeichnen - jedoch nicht immer. In einem Fall hatte eine Influencerin eine Gegenleistung vom Unternehmen erhalten.',imageUrl: 'https://www.tagesschau.de/multimedia/bilder/hummels-151~_v-original.jpg'),
    ItemData( url: 'https://www.tagesschau.de/inland/btw21/klimaschutz-plaene-101.html',title: 'Klimakonzepte der Parteien: Wie Industrie-Emissionen sinken sollen | tagesschau.de',description: 'Was wollen die Parteien der Industrie auf dem Weg des klimagerechten Umbaus abverlangen? Wie viel staatliche Förderung planen sie - und welche? Martin Polansky vergleicht die Klimaschutz-Konzepte der Parteien für die Industrie.',imageUrl: 'https://www.tagesschau.de/multimedia/bilder/zementwerk-beckum-101~_v-original.jpg'),
    ItemData( url: 'https://www.tagesschau.de/wirtschaft/technologie/intel-halbleiter-deutschland-gelsinger-101.html',title: 'Konzern plant Chipfabrik: Deutschland im Rennen um Intel-Fabrik | tagesschau.de',description: 'Der Chiphersteller Intel will in Europa eine neue Megafabrik bauen. Deutschland ist dabei weiter ein Kandidat für den neuen Standort. Es geht um Milliarden - auch an Subventionen. Den akuten Chipmangel wird das Projekt nicht beheben.',imageUrl: 'https://www.tagesschau.de/multimedia/bilder/intel-119~_v-original.jpg'),
    ItemData( url: 'https://www.tagesschau.de/wirtschaft/unternehmen/exporte-materialmangel-101.html',title: 'Stockende Lieferketten: Materialmangel trifft Exportnation | tagesschau.de',description: 'Die Industrie kämpft mit den Folgen der Pandemie. Zwar ist die Auftragslage vieler Firmen gut. Doch Materialmangel bremst Produktion und Exporte. Das zeigen auch die neuesten Zahlen zum Außenhandel. Von Axel John.',imageUrl: 'https://www.tagesschau.de/multimedia/bilder/produktionshalle-105~_v-original.jpg'),
    ItemData( url: 'https://open.spotify.com/episode/7hNGXd8kzHGvqMPRGTYLNa?si=ciC8dMxhRUqUpy4p0I3GPQ&dl_branch=1',title: 'Episode 1: The Two Lands - The History of Egypt Podcast | Podcast on Spotify',description: 'Listen to this episode from The History of Egypt Podcast on Spotify. On the banks of the Nile. Around 3,000 BCE (approximately), centuries of social change produced a unified Kingdom of Egypt. Its first ruler was probably named Nar-mer. In this episode, we meet Narmer and explore the Nile Valley and its people... Date c.3000 BCE, www.egyptianhistorypodcast.com, Support the Show at www.patreon.com/egyptpodcast, Follow us on social media www.facebook.com/egyptpodcast and www.twitter.com/egyptianpodcast, Music by Keith Zizza www.keithzizza.com  See acast.com/privacy for privacy and opt-out information.',imageUrl: 'https://i.scdn.co/image/ab6765630000ba8a1c524fd740b3e8801f2cc87b'),
    ItemData( url: 'https://www.tagesschau.de/wirtschaft/unternehmen/ueberbrueckungshilfe-verlaengert-101.html',title: 'Noch bis Ende des Jahres: Corona-Überbrückungshilfen verlängert  | tagesschau.de',description: 'Von der Corona-Krise schwer getroffene Unternehmen können auf weitere Unterstützung vom Staat bauen: Die Überbrückungshilfe III Plus wird bis Ende des Jahres verlängert. Auch die Hilfen für Solo-Selbstständige werden verlängert.',imageUrl: 'https://www.tagesschau.de/multimedia/bilder/corona-hilfen-113~_v-original.jpg'),
    ItemData( url: 'https://www.tagesschau.de/inland/ueberbrueckungshilfe-105.html',title: 'Corona-Krise: Zwei-Millionen-Grenze bei Überbrückungshilfe gefallen | tagesschau.de',description: 'Vom Corona-Lockdown betroffene Firmen können nun auch große Hilfsbeträge von mehr als zwei Millionen Euro beantragen. Hintergrund sind neue Vereinbarungen mit der EU-Kommission.',imageUrl: 'https://www.tagesschau.de/multimedia/bilder/ueberbrueckungshilfen-101~_v-original.jpg'),
    ItemData( url: 'https://open.spotify.com/track/7abZZqdxmt369pf6VSHiy7?si=y2NdAmC_QW6MrhjVtgAjrA&utm_source=whatsapp',title: 'Jessie\'s Girl - song by Rick Springfield | Spotify',description: 'Rick Springfield · Song · 1998',imageUrl: 'https://i.scdn.co/image/ab67616d0000b273e391545e9e1b5b672524dc70'),
    ItemData( url: 'https://open.spotify.com/episode/5okmrHZfc4ZJyAVfFQnUTr?si=hWvBVOLCRtSWibU9Wihpzw&dl_branch=1',title: 'Episode 3: Horus vs Seth - The History of Egypt Podcast | Podcast on Spotify',description: 'Listen to this episode from The History of Egypt Podcast on Spotify. The Gods at War. Around 2850 BCE, Egypt\'s "Second Dynasty" began. This was an unstable period, with devastating climate change causing economic pressure and maybe civil war. This shadowy period might have inspired a great myth, a story of two gods battling for the throne (and heart) of Egypt\'s kingdom. In this story the great gods Horus and Seth went head to head... Date c.2850 - 2700 BCE, www.egyptianhistorypodcast.com, Support the Show at www.patreon.com/egyptpodcast, Facebook www.facebook.com/egyptpodcast, Twitter www.twitter.com/egyptianpodcast, Music by Keith Zizza www.keithzizza.com  See acast.com/privacy for privacy and opt-out information.',imageUrl: 'https://i.scdn.co/image/ab6765630000ba8ab93ca7be15b281a05f459450'),
    ItemData( url: 'https://open.spotify.com/episode/2iduSsJK5zFAocRZ2JYZ5i?si=9iKGcg3jQZOB1wbSSYcGoQ&dl_branch=1',title: 'Episode 2: Horus Takes Flight - The History of Egypt Podcast | Podcast on Spotify',description: 'Listen to this episode from The History of Egypt Podcast on Spotify. Forming the Kingdom. The earliest rulers of Egypt are a curious bunch. Mighty rulers like Aha (possibly the first "true" King of Egypt) and Mer-Neith (the first female king) made their mark on this First Dynasty. They led wars, oversaw trade, and commissioned monuments. Along the way, they achieved historical immortality... Date c. 3000 - 2900 BCE, www.egyptianhistorypodcast.com, Support the Show at www.patreon.com/egyptpodcast, Facebook www.facebook.com/egyptpodcast, Twitter www.twitter.com/egyptianpodcast, Music by Keith Zizza www.keithzizza.com  See acast.com/privacy for privacy and opt-out information.',imageUrl: 'https://i.scdn.co/image/ab6765630000ba8accb8a2255c2dd38dc810a061'),
    ItemData( url: 'https://twitter.com/ABaerbock/status/1434155555300466689?s=20',title: 'Annalena Baerbock on Twitter',description: 'Ich bewundere die Kraft der Menschen in #Altenahr. Viele von ihnen haben in der #Flutkatastrophe ihre Angehörigen verloren, ihr Zuhause, ihre Existenz. Sie schufften jeden Tag, um ihr Leben wieder aufzubauen. Es ist großartig, wie viele Ehrenamtliche helfen. Ganz großen Dank! pic.twitter.com/PmZ0LXl2vZ',imageUrl: 'https://pbs.twimg.com/media/E-ck33aXMAEWWZl.jpg:large'),
    ItemData( url: 'https://twitter.com/elonmusk/status/1423830326665650179?s=20',title: 'Elon Musk on Twitter',description: 'pic.twitter.com/T6r96fqlPG',imageUrl: 'https://pbs.twimg.com/media/E8J2IurVcAE0Zrr.jpg:large'),
    ItemData( url: 'https://twitter.com/elonmusk/status/1381273076709478403',title: 'Elon Musk on Twitter',description: 'Love this beautiful shot',imageUrl: 'https://pbs.twimg.com/profile_images/1423663740344406029/l_-QOIHY_400x400.jpg'),
    ItemData( url: 'https://twitter.com/ABaerbock/status/1433017064227328001?s=20',title: 'Annalena Baerbock on Twitter',description: 'Kinder sind nur so stark wie ihre Chancen. Dass unser Schulsystem Ungleichheit verstärkt statt behebt, ist ein Armutszeugnis. Eine Bildungsoffensive ist überfällig: stärkere Bundesfinanzierung, v.a. für Schulen in benachteiligten Gebieten & Ganztagsausbau mit Qualität. https://t.co/q9Pl4VedXy',imageUrl: 'https://pbs.twimg.com/profile_images/1426471191338958848/JgcGcBT8_400x400.jpg'),
    ItemData( url: 'https://www.youtube.com/watch?v=pb7_YJp9bVA',title: 'Make An Impact - Inspirational Video - YouTube',description: 'http://benlionelscott.com/subscribe 👈 𝗗𝗼𝘄𝗻𝗹𝗼𝗮𝗱 𝘁𝗵𝗶𝘀 𝘃𝗶𝗱𝗲𝗼 𝗮𝗻𝗱 𝗮𝘂𝗱𝗶𝗼 𝘃𝗲𝗿𝘀𝗶𝗼𝗻 𝗯𝘆 𝘀𝘂𝗯𝘀𝗰𝗿𝗶𝗯𝗶𝗻𝗴 𝗼𝗻 𝗣𝗮𝘆𝗣𝗮𝗹, ?...',imageUrl: 'https://i.ytimg.com/vi/pb7_YJp9bVA/maxresdefault.jpg'),
    ItemData( url: 'https://www.youtube.com/watch?v=sVPYIRF9RCQ',title: 'THE SEED // Inspirational Short Film - YouTube',description: 'THE SEED | Inspirational Short Film“Once the seed of faith takes root, it cannot be blown away, even by the strongest wind – Now that’s a blessing.”— RumiFor...',imageUrl: 'https://i.ytimg.com/vi/sVPYIRF9RCQ/maxresdefault.jpg'),
    ItemData( url: 'https://www.youtube.com/watch?v=SqGRnlXplx0',title: 'A Valuable Lesson For A Happier Life - YouTube',description: 'This is by far one of the most valuable lessons for a happier life. After reading the story by  Steven Covey I decided to produce this  video to share the me...',imageUrl: 'https://i.ytimg.com/vi/SqGRnlXplx0/maxresdefault.jpg'),
    ItemData( url: 'https://www.youtube.com/watch?v=bfvyJ40HW60',title: 'BOAT LIFE: Arriving in the Caribbean 🌴🌞 - YouTube',description: 'Grab yourself some swimwear for a good cause! http://www.vagabellaswim.com 🤍If you\'re ever in Antigua & Barbuda and keen to go spearfishing, get in touch wi...',imageUrl: 'https://i.ytimg.com/vi/bfvyJ40HW60/maxresdefault.jpg'),
  ];
}