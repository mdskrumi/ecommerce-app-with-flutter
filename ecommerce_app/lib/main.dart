import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/order_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/product_overview_screen.dart';
import './screens/user_product_screen.dart';
import './screens/cart_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';

import './providers/products.dart';
import './providers/cart.dart';
import './providers/order.dart';
import './providers/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (_) => Products(),
          update: (_, auth, previousProductData) => Products()
            ..setAuth(auth.token, auth.userId, previousProductData.items),
        ),
        ChangeNotifierProxyProvider<Auth, Cart>(
          create: (_) => Cart(),
          update: (_, auth, previousCartData) =>
              Cart()..setAuth(auth.token, auth.userId, previousCartData.items),
        ),
        ChangeNotifierProxyProvider<Auth, Order>(
          create: (_) => Order(),
          update: (_, auth, previousOrderData) => Order()
            ..setAuth(auth.token, auth.userId, previousOrderData.orders),
        )
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.red,
            accentColor: Colors.orange,
            fontFamily: "Lato",
          ),
          //initialRoute: '/',
          home: auth.isAuth()
              ? ProductOverviewScreen()
              : FutureBuilder(
                  future: auth.autoLogIn(),
                  builder: (ctx, dataSnapshot) =>
                      dataSnapshot.connectionState == ConnectionState.waiting
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : AuthScreen()),
          routes: {
            //'/': (ctx) => AuthScreen(),
            ProductOverviewScreen.routeName: (ctx) => ProductOverviewScreen(),
            ProductOverviewScreen.routeName: (ctx) => ProductOverviewScreen(),
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrderScreen.routeName: (ctx) => OrderScreen(),
            UserProductScreen.routeName: (ctx) => UserProductScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
