import 'dart:developer';

import 'package:bloc_implementation/constants/enums.dart';
import 'package:bloc_implementation/cubit/counter_cubit.dart';
import 'package:bloc_implementation/cubit/internet_cubit.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(MyApp(
    connectivity: Connectivity(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, @required this.connectivity}) : super(key: key);
  final Connectivity? connectivity;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<InternetCubit>(
          create: (context) => InternetCubit(connectivity: connectivity),
        ),
        BlocProvider<CounterCubit>(
          create: (context) => CounterCubit(
              internetCubit: BlocProvider.of<InternetCubit>(context)),
        ),
      ],
      child: MaterialApp(
        title: 'Bloc & Cubit Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(title: 'Bloc & Cubit Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          BlocBuilder<InternetCubit, InternetState>(builder: (context, state) {
            if (state is InternetConnected &&
                state.connectionType == ConnectionType.wifi) {
              return Text("WIFI");
            } else if (state is InternetConnected &&
                state.connectionType == ConnectionType.mobile) {
              return Text("Mobile");
            } else if (state is InternetDisconnected) {
              return Text("Disconnected");
            }
            return CircularProgressIndicator();
          }),
          BlocListener<CounterCubit, CounterState>(
            listener: (context, state) {
              // TODO: implement listener
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: state.wasIncremented
                      ? Text("Incremented")
                      : Text("decremnted")));
            },
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'You have pushed the button this many times:',
                  ),
                  BlocBuilder<CounterCubit, CounterState>(
                    builder: (context, state) {
                      return Text(
                        '${state.counterValue}',
                        style: Theme.of(context).textTheme.headline4,
                      );
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FloatingActionButton(
                        onPressed: () {
                          BlocProvider.of<CounterCubit>(context).decrement();
                        },
                        tooltip: 'Decrement',
                        child: const Icon(Icons.remove),
                      ),
                      FloatingActionButton(
                        onPressed: () {
                          BlocProvider.of<CounterCubit>(context).increment();
                        },
                        tooltip: 'Increment',
                        child: const Icon(Icons.add),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
