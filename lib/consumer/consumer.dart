import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

// Per a aquest exemple farem un comptador molt senzill
class Counter extends ChangeNotifier {
  int _count = 0;

  // Fixau-vos amb el waring que ens dóna al principi quan hem declarat els
  // setters i getters "unnecessary"
  int get count => _count;

  // ObserverPattern: Utilitzam una classe que té una llista d'observadors,
  // i aquesta classe, quan hi ha algun canvi envia una notificació als observadors
  set count(int value) {
    _count = value;
    notifyListeners();
  }

  void reset() {
    _count = 0;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // El ChangeNotifierProvider ens permetrà que quan estam emprant
    // provider en algun Widget del nostre arbre, el contexte (que és l'element
    // associat al widget) rebrà l'ordre de rebuild (notificació de que hi ha
    // hagut canvis) i es cridarà el mètode build del mateix contexte.
    // Una forma de no escoltar els canvis, és posar listen: false

    return ChangeNotifierProvider<Counter>(
      create: (_) => Counter(),
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: PageScreen()),
    );
  }
}

class PageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final counter = Provider.of<Counter>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Notifier'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              //Provider.of<Counter>(context, listen: false).reset();
              counter.reset();
            },
          )
        ],
      ),
      body: Center(
        // En aquest punt, no utilitzarem un Widget apart, el consumer,
        // ens asegura que si canvia el valor, es tornarà a executar el
        // build d'aquest contexte
        child: Consumer<Counter>(
          builder: (_, counter, __) =>
              Text('${counter.count}', style: TextStyle(fontSize: 50)),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          // Ojo, aquí listen ha d'estar a false!
          // També es pot arreglar declarant-ho fora del onPressed.

          //Provider.of<Counter>(context, listen: false).count++;
          counter.count++;
        },
      ),
    );
  }
}
