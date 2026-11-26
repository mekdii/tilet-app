import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tilet/core/network/api_client.dart';
import 'package:tilet/core/theme/app_theme.dart';
import 'package:tilet/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:tilet/features/auth/presentation/bloc/auth_event.dart';
import 'package:tilet/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:tilet/features/home/presentation/pages/home_page.dart';

class TiletApp extends StatelessWidget {
  const TiletApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CartBloc()),
        BlocProvider(
          create: (_) {
            final authBloc = AuthBloc()..add(const AuthCheckRequested());
            ApiClient.attachAuthInterceptor(
              onSessionExpired: () => authBloc.add(const AuthLogoutRequested()),
            );
            return authBloc;
          },
        ),
      ],
      child: MaterialApp(
        title: 'Tilet',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const HomePage(),
      ),
    );
  }
}
