import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const twentyFiveMinutes = 3 * 1000; // 25분 == 1500초 == 1500 * 1000 밀리초
  int totalMilliSeconds = twentyFiveMinutes;
  int totalPomodoros = 0;
  late DateTime startTime;
  bool isRunning = false;
  late Timer timer;

  void onTick(Timer timer) async {
    int elapsedMilliseconds =
        DateTime.now().difference(startTime).inMilliseconds;
    if (elapsedMilliseconds >= twentyFiveMinutes) {
      // 시간종료!
      setState(() {
        totalPomodoros = totalPomodoros + 1;
        isRunning = false;
        totalMilliSeconds = twentyFiveMinutes;
      });
      await playMusic();
      timer.cancel(); // why not
    } else {
      setState(() {
        totalMilliSeconds = twentyFiveMinutes - elapsedMilliseconds;
      });
    }
  }

  void onPausePressed() {
    timer.cancel();
    setState(() {
      isRunning = false;
    });
  }

  void onStartPressed() {
    startTime = DateTime.now();
    timer = Timer.periodic(const Duration(milliseconds: 10),
        onTick); // 100 milliseconds is more reasonabless

    setState(() {
      isRunning = true;
    });
  }

  void onReset() async {
    setState(() {
      totalMilliSeconds = twentyFiveMinutes;
    });
  }

  playMusic() async {
    print('play music!');
    final player = AudioPlayer();
    await player.setSource(AssetSource('boxing-bell.mp3'));
    await player.resume();
    //await player.play(AssetSource('./boxing-bell.mp3'));

    // await player.play(DeviceFileSource('./boxing-bell.mp3'));
  }

  // pauseMusic() async {
  //   player.pause();
  // }

  // stopMusic() async {
  //   await player.stop();
  // }

  String format(int milliseconds) {
    //var duration = Duration(seconds: seconds);
    var duration = Duration(milliseconds: milliseconds);
    //print(duration.toString());
    // return (duration.toString().substring(2, 10));
    return duration.toString().substring(2, 11);
    return duration.toString().split(".").first.substring(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          Flexible(
            // flexible : 반응형 UI
            flex: 1, // flexible의 비율
            child: Container(
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(),
                  bottom: BorderSide(),
                  left: BorderSide(),
                  right: BorderSide(),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(
                    Icons.sports_mma_outlined,
                    size: 80,
                  ),
                  Text(
                    'PUNCH BOX',
                    style: TextStyle(
                      color: Theme.of(context).cardColor,
                      fontSize: 60,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Icon(
                    Icons.sports_mma_outlined,
                    size: 80,
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            // flexible : 반응형 UI
            flex: 1, // flexible의 비율
            child: Container(
              alignment: Alignment.bottomCenter,
              child: Text(
                format(totalMilliSeconds),
                style: TextStyle(
                  color: Theme.of(context).cardColor,
                  fontSize: 89,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    iconSize: 120,
                    color: Theme.of(context).cardColor,
                    icon: Icon(isRunning
                        ? Icons.pause_circle_outline
                        : Icons.play_circle_outline),
                    onPressed: isRunning ? onPausePressed : onStartPressed,
                  ),
                  IconButton(
                    iconSize: 120,
                    color: Theme.of(context).cardColor,
                    icon: const Icon(Icons.refresh_outlined),
                    onPressed: onReset,
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Theme.of(context).cardColor,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Pomodoros',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color:
                                Theme.of(context).textTheme.displayLarge?.color,
                          ),
                        ),
                        Text(
                          '$totalPomodoros',
                          style: TextStyle(
                            fontSize: 58,
                            fontWeight: FontWeight.w600,
                            color:
                                Theme.of(context).textTheme.displayLarge?.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
