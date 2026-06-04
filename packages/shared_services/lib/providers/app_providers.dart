import 'package:provider/provider.dart';
import 'package:shared_services/shared_services.dart'; // Jika RealTime ada di shared_services
import 'package:provider/single_child_widget.dart';
// Atau import dari lokasi lokal Anda

List<SingleChildWidget> getGlobalProviders() {
  return [
    ChangeNotifierProvider(create: (_) => RealTime()),
    // Tambahkan provider lain di sini
  ];
}
