import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/constants/app_constants.dart';
import 'core/constants/app_theme.dart';
import 'data/repositories/user_repository.dart';
import 'data/repositories/user_repository_interface.dart';
import 'presentation/providers/user_provider.dart';
import 'presentation/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  // Crear repositorio
  final IUserRepository userRepository = UserRepository(prefs);

  runApp(MyApp(userRepository: userRepository));
}

/// Aplicación principal
/// Implementa SOLID: Dependency Injection
class MyApp extends StatelessWidget {
  final IUserRepository userRepository;

  const MyApp({
    Key? key,
    required this.userRepository,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserProvider(userRepository),
      child: MaterialApp(
        title: AppConstants.appTitle,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const HomeScreen(),
      ),
    );
  }
}
