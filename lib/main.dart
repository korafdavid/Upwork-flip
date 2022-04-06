import 'package:flip/models.dart';
import 'package:flip/odd_controller.dart';
import 'package:flip/sqflite.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(title: 'COIN FLIP'),
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
  final COINUNIT _coinunit = COINUNIT();
  late DatabaseHelper _dbHelper;
  List<COINUNIT> coinUnitDisplay = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      _dbHelper = DatabaseHelper.instance;
    });
    // _calcTotal();
    _refreshContactList();
  }

  _refreshContactList() async {
    List<COINUNIT> ref = await _dbHelper.fetchCoinUnit();
    setState(() {
      coinUnitDisplay = ref;
    });
  }

  _onSubmit(String value) async {
    late int index;
    if (value == "H") {
      index = await _dbHelper.totalHead();
    } else {
      index = await _dbHelper.totalTail();
    }
    // if (value == 'H') {
    //   index =
    //       (await _dbHelper.totalHead() > 0) ? await _dbHelper.totalHead() : 7;
    // } else {
    //   index =
    //       await _dbHelper.totalTail() > 0 ? await _dbHelper.totalTail() : 10;
    // }

    _coinunit.value = '$value${index + 1}';
    await _dbHelper.insertCoinUnit(_coinunit);
    _refreshContactList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    const Text('TOTAL',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 21)),
                    (StreamBuilder(
                      stream: _dbHelper.calculateTotal(),
                      builder: (context, AsyncSnapshot snapshot) {
                        return snapshot.hasData
                            ? Text(
                                snapshot.data.toString(),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            : const Text(
                                '0',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              );
                      },
                    ))
                  ],
                ),
                Column(
                  children: [
                    const Text('HEAD',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 21)),
                    StreamBuilder(
                      stream: _dbHelper.calculateTotal(),
                      builder: (context, AsyncSnapshot<int> totalsnapshot) {
                        return StreamBuilder(
                          stream: _dbHelper.calculateTotalHead(),
                          builder: (context, AsyncSnapshot<int> headsnapshot) {
                            if (totalsnapshot.data! == 0 ||
                                headsnapshot.data! == 0) {
                              return const Text('0',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold));
                            } else {
                              return headsnapshot.hasData
                                  ? Text(
                                      '${headsnapshot.data}  ${((headsnapshot.data! / totalsnapshot.data!) * 100).round().toString()} %',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )
                                  : const Text('0',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold));
                            }
                          },
                        );
                      },
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text('TAIL',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 21)),
                    StreamBuilder(
                      stream: _dbHelper.calculateTotal(),
                      builder: (context, AsyncSnapshot<int> totalsnapshot) {
                        return StreamBuilder(
                          stream: _dbHelper.calculateTotalTail(),
                          builder: (context, AsyncSnapshot<int> tailnapshot) {
                            if (totalsnapshot.data! == 0 ||
                                tailnapshot.data! == 0) {
                              return const Text('0',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold));
                            } else {
                              return tailnapshot.hasData
                                  ? Text(
                                      '${tailnapshot.data}  ${((tailnapshot.data! / totalsnapshot.data!) * 100).round().toString()} %',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )
                                  : const Text('0',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold));
                            }
                          },
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              separatorBuilder: ((context, index) => const SizedBox(height: 5,)),
                shrinkWrap: true,
                itemCount: coinUnitDisplay.length,
                itemBuilder: ((context, index) {
                  late String odd;

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          width: 90,
                          padding: const EdgeInsets.all(20),
                          color: coinUnitDisplay[index].value!.contains('H')
                              ? Colors.blue
                              : Colors.red,
                          child: Text(
                            coinUnitDisplay[index].value!,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                      // Container(
                      //   width: 90,
                      //   padding: const EdgeInsets.all(20),
                      //   decoration: BoxDecoration(
                      //       border: Border.all(
                      //     color: coinUnitDisplay[index].value!.contains('H')
                      //         ? Colors.blue
                      //         : Colors.red,
                      //   )),
                      //   child: Text(getOdds(coinUnitDisplay[index].value!)!),
                      // )
                    ],
                  );
                })),
          )
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              _onSubmit('H');
            },
            tooltip: 'ADD HEAD',
            child: const Text('H'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
              backgroundColor: Colors.red,
              onPressed: () => _onSubmit('T'),
              tooltip: 'ADD TAIL',
              child: const Text('T'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
              backgroundColor: Colors.orange,
              onPressed: () async {
                if (coinUnitDisplay.isNotEmpty) {
                  await _dbHelper.deleteCoinUnit(coinUnitDisplay.last.id!);
                  _refreshContactList();
                }
              },
              tooltip: 'DELETE FIELD',
              child: const Icon(Icons.delete),
            ),
          ),
          FloatingActionButton(
            backgroundColor: Colors.orange,
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('CLEAR STATS'),
                      content: const Text(
                          'Are you sure you want to delete all your stats?'),
                      actions: [
                        TextButton(
                          onPressed: (() => Navigator.of(context).pop()),
                          child: Text('No'),
                        ),
                        TextButton(
                            onPressed: () async {
                              await _dbHelper.clearCoinUnit();
                              _refreshContactList();
                              Navigator.of(context).pop();
                            },
                            child: Text('YES'))
                      ],
                    );
                  });
            },
            tooltip: 'CLEAR COLUMN',
            child: const Icon(Icons.clear_all),
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
