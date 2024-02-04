import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/provider/categories_provider.dart';
import 'package:todo_app/provider/tasks_provider.dart';
import 'package:todo_app/view/pages/home.dart';

void main(List<String> args) {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ),
  );

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  runApp(const ToDoApp());
}

class ToDoApp extends StatelessWidget {
  const ToDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TasksProvider()),
        ChangeNotifierProvider(create: (context) => CategoriesProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "ToDoApp",
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.orange,
          ),
        ),
        home: const HomePage(),
      ),
    );
  }
}
