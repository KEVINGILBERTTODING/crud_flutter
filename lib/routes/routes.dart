import 'package:crud_flutter/modules/auth/views/login.dart';
import 'package:crud_flutter/modules/home/home.dart';
import 'package:crud_flutter/modules/products/view/update_product.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String loginScreen = '/login';
  static const String homeScreen = '/home';
  static const String updateProductScreen = '/update_product';
  static final Map<String, WidgetBuilder> routes = {
    loginScreen: (context) => const LoginScreen(),
    homeScreen: (context) => HomeScreen(),
    updateProductScreen: (context) => UpdateProduct()
  };
}
