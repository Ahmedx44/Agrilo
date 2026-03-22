import 'package:agrilo/app/app.dart';
import 'package:agrilo/bootstrap.dart';

Future<void> main() async {
  await bootstrap(() => const App());
}
