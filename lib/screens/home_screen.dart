import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const twentyFiveMinutes =
      3 * 1000; // 단위시간(밀리초) 25분 == 1500초 == 1500 * 1000 밀리초
  int totalMilliSeconds = twentyFiveMinutes; // 남은 단위시간
  int totalPomodoros = 0; // 타이머 달성횟수
  late DateTime startTime; // 타이머 시작시각
  bool isRunning = false; // 타이머 동작여부
  late Timer? timer; // ?
  int elapsedTime = 0; // Store elapsed time when the timer is paused.

  void onTick(Timer timer) async {
    if (!isRunning) return;
    // [현재시각 - 시작시각] 밀리초단위
    int elapsedMilliseconds =
        DateTime.now().difference(startTime).inMilliseconds;
    // 경과된 시간이 단위 시간을 넘어섰는지 검사 + 종료처리 2번방지를 위해 isRunning사용
    if (elapsedMilliseconds + elapsedTime >= twentyFiveMinutes) {
      // 시간종료!
      setState(() {
        totalPomodoros = totalPomodoros + 1; // 람다함수로 저장하는게 맞는 방식이지 않나?
        isRunning = false;
        totalMilliSeconds = twentyFiveMinutes;
        elapsedTime = 0;
      });
      await playMusic();
      timer.cancel(); // why not
    } else {
      setState(() {
        totalMilliSeconds =
            twentyFiveMinutes - elapsedMilliseconds - elapsedTime;
      });
    }
  }

  void toggleTimer() {
    setState(() {
      isRunning = !isRunning;

      if (isRunning) {
        // onStartPressed
        startTime = DateTime.now();
        timer = Timer.periodic(const Duration(milliseconds: 1), onTick);
      } else {
        // onPausePressed
        timer?.cancel();
        elapsedTime += DateTime.now().difference(startTime).inMilliseconds;
      }
    });
  }

  void onReset() async {
    setState(() {
      totalMilliSeconds = twentyFiveMinutes;
      isRunning = false;
      elapsedTime = 0;
    });
    timer?.cancel();
  }

  playMusic() async {
    print('play music!');
    final player = AudioPlayer();
    await player.setSource(AssetSource('boxing-bell.mp3'));
    await player.resume();
  }

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
                    //onPressed: isRunning ? onPausePressed : onStartPressed,
                    onPressed: toggleTimer,
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
