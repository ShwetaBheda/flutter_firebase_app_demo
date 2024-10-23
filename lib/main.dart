import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task/blocs/auth_bloc.dart';
import 'package:flutter_task/screens/login_screen.dart';
import 'package:flutter_task/screens/post_screen.dart';
import 'package:flutter_task/screens/signup_screen.dart';
import 'package:flutter_task/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    BlocProvider(
      create: (context) => AuthBloc(AuthService()),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/home': (context) =>  HomeScreen(),
      },
    );
  }
}

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Login'),
//         centerTitle: true,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             SizedBox(
//               width: MediaQuery.of(context).size.width / 2,
//               child: TextField(
//                 controller: _emailController,
//                 decoration: const InputDecoration(hintText: 'Email'),
//               ),
//             ),
//             const SizedBox(
//               height: 30.0,
//             ),
//             SizedBox(
//               width: MediaQuery.of(context).size.width / 2,
//               child: TextField(
//                 controller: _passwordController,
//                 obscureText: true,
//                 decoration: const InputDecoration(
//                   hintText: 'Password',
//                 ),
//               ),
//             ),
//             const SizedBox(
//               height: 30.0,
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 final message = await AuthService().login(
//                   email: _emailController.text,
//                   password: _passwordController.text,
//                 );
//                 if (message!.contains('Success')) {
//                   Navigator.of(context).pushReplacement(
//                     MaterialPageRoute(
//                       builder: (context) => const Home(),
//                     ),
//                   );
//                 }
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: Text(message),
//                   ),
//                 );
//               },
//               child: const Text('Login'),
//             ),
//             const SizedBox(
//               height: 30.0,
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).push(
//                   MaterialPageRoute(
//                     builder: (context) => const CreateAccount(),
//                   ),
//                 );
//               },
//               child: const Text('Create Account'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class CreateAccount extends StatefulWidget {
//   const CreateAccount({Key? key}) : super(key: key);

//   @override
//   _CreateAccountState createState() => _CreateAccountState();
// }

// class _CreateAccountState extends State<CreateAccount> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Create Account'),
//         centerTitle: true,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             SizedBox(
//               width: MediaQuery.of(context).size.width / 2,
//               child: TextField(
//                 controller: _emailController,
//                 decoration: const InputDecoration(hintText: 'Email'),
//               ),
//             ),
//             const SizedBox(
//               height: 30.0,
//             ),
//             SizedBox(
//               width: MediaQuery.of(context).size.width / 2,
//               child: TextField(
//                 controller: _passwordController,
//                 obscureText: true,
//                 decoration: const InputDecoration(
//                   hintText: 'Password',
//                 ),
//               ),
//             ),
//             const SizedBox(
//               height: 30.0,
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 final message = await AuthService().registration(
//                   email: _emailController.text,
//                   password: _passwordController.text,
//                 );
//                 if (message!.contains('Success')) {
//                   Navigator.of(context).pushReplacement(
//                       MaterialPageRoute(builder: (context) => const Home()));
//                 }
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: Text(message),
//                   ),
//                 );
//               },
//               child: const Text('Create Account'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class AuthService {
//   Future<String?> registration({
//     required String email,
//     required String password,
//   }) async {
//     try {
//       await FirebaseAuth.instance.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       return 'Success';
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'weak-password') {
//         return 'The password provided is too weak.';
//       } else if (e.code == 'email-already-in-use') {
//         return 'The account already exists for that email.';
//       } else {
//         return e.message;
//       }
//     } catch (e) {
//       return e.toString();
//     }
//   }

//   Future<String?> login({
//     required String email,
//     required String password,
//   }) async {
//     try {
//       await FirebaseAuth.instance.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       return 'Success';
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'user-not-found') {
//         return 'No user found for that email.';
//       } else if (e.code == 'wrong-password') {
//         return 'Wrong password provided for that user.';
//       } else {
//         return e.message;
//       }
//     } catch (e) {
//       return e.toString();
//     }
//   }
// }

// class Home extends StatefulWidget {
//   const Home({super.key});

//   @override
//   State<Home> createState() => _HomeState();
// }

// class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
//   late AnimationController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(vsync: this);
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return const Center(child: Text("Home"));
//   }
// }
