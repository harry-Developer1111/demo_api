import 'package:demo_api_app/main.dart';
import 'package:demo_api_app/models/products_model/products_model.dart';
import 'package:demo_api_app/screens/home/home_screen.dart';
import 'package:demo_api_app/screens/login/login_page.dart';
import 'package:demo_api_app/screens/profile/profile.dart';
import 'package:demo_api_app/screens/register_page/register_page.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/product_detail_page/product_detail_page.dart';

final GoRouter router = GoRouter(
    initialLocation: '/register',

    redirect: (context,state)async{

      final pref=await SharedPreferences.getInstance();
      final isLogin=pref.getBool("isLogin")??false;

      final signUpPage=state.matchedLocation=='/register';
      final loginPage=state.matchedLocation=='/login';

      if(isLogin && (signUpPage||loginPage)){
        return'/home';
      }

      if(!isLogin && state.matchedLocation=='/home'){
        return'/login';
      }
      return null;
    },
    routes: [
  GoRoute(
    path: '/home',
    builder: (context, state) => const MyHomePage(),
  ),
  GoRoute(
    path: '/register',
    builder: (context, state) => const RegisterPage(),
  ),
  GoRoute(
    path: '/login',
    builder: (context, state) => const LoginPage(),
  ),
      GoRoute(path: '/profile',
      builder: (context,state)=>const ProfileScreen()
      ),

      // Product Detail
      GoRoute(
        path: '/product-detail/:id',

        builder: (context, state) {
           //final product=state.extra as ProductModel; use extra simple way

          final id = state.pathParameters['id']!;

          final category = state.uri.queryParameters['category']!;

          return ProductDetailPage(
            id: id,
            category: category,
          );
        },
      ),

]);
