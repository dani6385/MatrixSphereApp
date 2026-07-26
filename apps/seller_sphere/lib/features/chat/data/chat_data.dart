import 'package:shared_ui/shared_ui.dart';

// Data mentah untuk daftar percakapan
final List<Map<String, dynamic>> initialConversations = [
  {
    'id': 'chat_1',
    'name': 'Andi (Pembeli)',
    'lastMessage': 'Kak, apakah barang ini masih ready stock?',
    'time': '14:20',
    'unreadCount': 2,
    'color': kBrandPrimary,
  },
  {
    'id': 'chat_2',
    'name': 'Santi (Seller Support)',
    'lastMessage': 'Sama-sama kak, senang bisa membantu Anda!',
    'time': '11:05',
    'unreadCount': 0,
    'color': kSoftTeal,
  },
  {
    'id': 'chat_3',
    'name': 'Budi (Pembeli)',
    'lastMessage': 'Saya sudah transfer ya kak, tolong segera diproses.',
    'time': 'Kemarin',
    'unreadCount': 1,
    'color': kWarmOrange,
  },
  {
    'id': 'chat_4',
    'name': 'Roni (Kurir)',
    'lastMessage': 'Paket sedang diantar ke alamat tujuan Anda.',
    'time': '02 Jul',
    'unreadCount': 0,
    'color': kCyanPrimary,
  },
];

// Data mentah untuk detail pesan di setiap percakapan
final Map<String, List<Map<String, dynamic>>> initialChatDetails = {
  'chat_1': [
    {'sender': 'Andi', 'text': 'Kak, apakah barang ini masih ready stock?'},
    {'sender': 'Me', 'text': 'Ready kak, silahkan diorder ya :)'},
    {'sender': 'Andi', 'text': 'Oke, saya pesan 2 ya.'},
  ],
  'chat_2': [
    {'sender': 'Santi', 'text': 'Ada yang bisa kami bantu?'},
  ],
  'chat_3': [
    {'sender': 'Budi', 'text': 'Saya sudah transfer ya kak, tolong segera diproses.'},
  ],
  'chat_4': [
    {'sender': 'Roni', 'text': 'Paket sedang diantar ke alamat tujuan Anda.'},
  ],
};
