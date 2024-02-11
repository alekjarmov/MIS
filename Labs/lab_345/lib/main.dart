import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lab345/add_exam_screen.dart';
import 'package:lab345/calendar_widget.dart';
import 'package:lab345/exam_list.dart';
import 'package:lab345/signin.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'auth.dart';
import 'package:lab345/notification_service.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.android);
  await NotificationService().init(); 
  runApp(ExamApp());
}

class ExamApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthService>(
      create: (context) => AuthService(),
      child: MaterialApp(
        title: 'FINKI app',
        theme: ThemeData(
          primarySwatch: Colors.green,
          fontFamily: 'Roboto',
        ),
        home: AuthenticationWrapper(),
      ),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authServiceProvider = Provider.of<AuthService>(context);
    return StreamBuilder<User?>(
      stream: authServiceProvider.user,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          return _buildAuthScreen(context, snapshot.data);
        }
        return _buildLoadingScreen();
      },
    );
  }

  Widget _buildAuthScreen(BuildContext context, User? user) {
    return user == null ? AuthenticationHomePage() : ExamHomePage();
  }

  Widget _buildLoadingScreen() {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class ExamHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authServiceProvider = Provider.of<AuthService>(context);
    return Scaffold(
      appBar: _buildAppBar(context, authServiceProvider),
      body: Column(
        children: [
          CalendarWidget(),
          Expanded(
            child: ExamPage(),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, AuthService authServiceProvider) {
    return AppBar(
      title: Text('FINKI app'),
      actions: [
        _buildAddExamButton(context),
        _buildLogoutButton(authServiceProvider),
      ],
    );
  }

  IconButton _buildAddExamButton(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.add),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddExamPage()),
        );
      },
    );
  }

  IconButton _buildLogoutButton(AuthService authServiceProvider) {
    return IconButton(
      icon: Icon(Icons.logout),
      onPressed: () async {
        await authServiceProvider.signOut();
      },
    );
  }
}