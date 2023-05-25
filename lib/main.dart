import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const TimerApp());
}

class TimerApp extends StatelessWidget {
  const TimerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Timer App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TimerScreen(),
    );
  }
}

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> with WidgetsBindingObserver {
  int minutes = 2;
  int seconds = 0;
  bool isRunning = false;
  late Timer timer;


@override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    timer?.cancel();
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
    if (state == AppLifecycleState.resumed) {
      startTimer();
    } else if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      timer.cancel();
    }
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (seconds > 0) {
        setState(() {
          seconds--;
        });
      } else if (minutes > 0) {
        setState(() {
          minutes--;
          seconds = 59;
        });
      } else {
        timer.cancel();
      }
    });
  }

  void stopTimer() {
    timer.cancel();
  }

  void resetTimer() {
    stopTimer();
    setState(() {
      minutes = 2;
      seconds = 0;
      isRunning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timer'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Timer:',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(
              '$minutes:${seconds.toString().padLeft(2, '0')}',
              style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    if (!isRunning && minutes > 0) {
                      setState(() {
                        minutes--;
                      });
                    }
                  },
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    if (!isRunning) {
                      setState(() {
                        minutes++;
                      });
                    }
                  },
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  child: Text(isRunning ? 'Stop' : 'Start'),
                  onPressed: () {
                    setState(() {
                      isRunning = !isRunning;
                      if (isRunning) {
                        startTimer();
                      } else {
                        stopTimer();
                      }
                    });
                  },
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  child: const Text('Reset'),
                  onPressed: () {
                    resetTimer();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}