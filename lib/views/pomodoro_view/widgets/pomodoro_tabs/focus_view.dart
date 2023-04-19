import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pomotodo/core/providers/pomodoro_provider.dart';
import 'package:pomotodo/core/providers/spotify_provider.dart';
import 'package:pomotodo/core/service/notification_controller.dart';
import 'package:pomotodo/l10n/app_l10n.dart';
import 'package:pomotodo/views/common/widgets/custom_elevated_button.dart';
import 'package:pomotodo/views/pomodoro_view/widgets/pomodoro_timer/pomodoro_timer.dart';
import 'package:pomotodo/views/pomodoro_view/widgets/pomodoro_widget.dart';
import 'package:pomotodo/views/pomodoro_view/widgets/spotify_build_player_state.dart';
import 'package:pomotodo/views/pomodoro_view/widgets/task_info_list_tile.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FocusView extends StatefulWidget {
  const FocusView({
    Key? key,
    required this.widget,
    required this.controller,
    required this.tabController,
  }) : super(key: key);

  final PomodoroWidget widget;
  final CountDownController controller;
  final TabController tabController;

  @override
  State<FocusView> createState() => _FocusViewState();
}

class _FocusViewState extends State<FocusView> with WidgetsBindingObserver {
  late DateTime firstDateTime;
  late DateTime secondDateTime;
  late PageUpdate pageUpdateProvider;

  @override
  void initState() {
    pageUpdateProvider = Provider.of<PageUpdate>(context, listen: false);
    WidgetsBinding.instance.addObserver(this);
    NotificationController.startListeningNotificationEvents();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (pageUpdateProvider.timerWorking) {
      switch (state) {
        case AppLifecycleState.paused:
          pageUpdateProvider.timerWorking = true;
          context.read<PageUpdate>().startOrStop(
                context.read<SharedPreferences>().getInt("workTimerSelect")! *
                    60,
                widget.controller,
                widget.widget.task,
                widget.tabController,
                context
                    .read<SharedPreferences>()
                    .getInt("longBreakNumberSelect")!,
              );
          firstDateTime = DateTime.now();
          break;
        case AppLifecycleState.resumed:
          secondDateTime = DateTime.now();
          var differenceDateTime = secondDateTime.difference(firstDateTime);

          var newDuration = widget.controller.getTimeInSeconds() -
              differenceDateTime.inSeconds;
          context
              .read<PageUpdate>()
              .restartTimer(widget.controller, newDuration);

          pageUpdateProvider.timerWorking = false;
          break;

        default:
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    
    SpotifyProvider spotifyProvider =
        Provider.of<SpotifyProvider>(context, listen: true);
    int pomodoroCount = widget.widget.task.pomodoroCount;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          TaskInfoListTile(
              taskName: widget.widget.task.taskName,
              taskInfo: widget.widget.task.taskInfo,
              pomodoroCount: widget.widget.task.pomodoroCount),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.50,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RepaintBoundary(
                  child: PomodoroTimer(
                    width: MediaQuery.of(context).size.width * 0.65,
                    isReverse: true,
                    isReverseAnimation: true,
                    onComplete: () async {
                      pageUpdateProvider.startOrStop(
                        context
                                .read<SharedPreferences>()
                                .getInt("workTimerSelect")! *
                            60,
                        widget.controller,
                        widget.widget.task,
                        widget.tabController,
                        context
                            .read<SharedPreferences>()
                            .getInt("longBreakNumberSelect")!,
                      );
                      pageUpdateProvider.floatingActionOnPressed(
                          widget.widget.task, pomodoroCount + 1);
 
                    },
                    duration: context.select((SharedPreferences prefs) =>
                            prefs.getInt("workTimerSelect"))! *
                        60,
                    autoStart: false,
                    controller: widget.controller,
                    isTimerTextShown: true,
                    neumorphicEffect: false,
                    strokeWidth: 20,
                    innerFillColor: Theme.of(context).primaryColor,
                    neonColor: Theme.of(context).primaryColor,
                    backgroudColor: Theme.of(context).focusColor,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomElevatedButton(
                      buttonWidth: MediaQuery.of(context).size.width * 0.5,
                      buttonHeight: MediaQuery.of(context).size.height * 0.06,
                      onPressed: () {
                        pageUpdateProvider.startOrStop(
                          context
                                  .read<SharedPreferences>()
                                  .getInt("workTimerSelect")! *
                              60,
                          widget.controller,
                          widget.widget.task,
                          widget.tabController,
                          context
                              .read<SharedPreferences>()
                              .getInt("longBreakNumberSelect")!,
                        );
                      },
                      child: context.select(
                        (PageUpdate pageNotifier) =>
                            pageNotifier.callText(context),
                      ),
                    ),
                    if (context.select((PageUpdate pageNotifier) =>
                        pageNotifier.skipButtonVisible))
                      IconButton(
                          onPressed: () {
                            pageUpdateProvider.startOrStop(
                              context
                                      .read<SharedPreferences>()
                                      .getInt("workTimerSelect")! *
                                  60,
                              widget.controller,
                              widget.widget.task,
                              widget.tabController,
                              context
                                  .read<SharedPreferences>()
                                  .getInt("longBreakNumberSelect")!,
                            );
                            widget.tabController
                                .animateTo(widget.tabController.index + 1);
                          },
                          icon: const Icon(Icons.skip_next))
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Card(
                    clipBehavior: Clip.hardEdge,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(
                            width: 1, color: Colors.grey.withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(8)),
                    elevation: 10,
                    child: SizedBox(
                      height: kToolbarHeight * 2,
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8)),
                            clipBehavior: Clip.hardEdge,
                            child: SizedBox(
                              height: kToolbarHeight,
                              child: Row(
                                children: [
                                  spotifyProvider.connected
                                      ? Expanded(
                                          child: Wrap(
                                            alignment:
                                                WrapAlignment.spaceBetween,
                                            children: [
                                              Stack(
                                                children: [
                                                  buildPlayerStateWidget(
                                                      context),
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                      : Expanded(
                                          child: Material(
                                            color:
                                                Theme.of(context).primaryColor,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(8),
                                                  topRight: Radius.circular(8)),
                                            ),
                                            child: Stack(
                                              children: [
                                                Visibility(
                                                  visible:
                                                      !spotifyProvider.loading,
                                                  child: SizedBox(
                                                    height: kToolbarHeight,
                                                    child: InkWell(
                                                      onTap: () async {
                                                        try {
                                                          await spotifyProvider
                                                              .connectToSpotifyRemote();
                                                        } on PlatformException {
                                                          QuickAlert.show(
                                                              context: context,
                                                              type:
                                                                  QuickAlertType
                                                                      .error,
                                                              title: L10n.of(
                                                                      context)!
                                                                  .failConnect,
                                                              text: L10n.of(
                                                                      context)!
                                                                  .noSpotify,
                                                              confirmBtnText: L10n
                                                                      .of(context)!
                                                                  .confirmButtonText);
                                                        }
                                                      },
                                                      child: Center(
                                                          child: Text(
                                                        L10n.of(context)!
                                                            .connectSpotify,
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )),
                                                    ),
                                                  ),
                                                ),
                                                Center(
                                                  child: Visibility(
                                                      visible: spotifyProvider
                                                          .loading,
                                                      child:
                                                          const CircularProgressIndicator(
                                                              color: Colors
                                                                  .white)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Material(
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(8))),
                                    color: Colors.green[500],
                                    child: InkWell(
                                      onTap: () {},
                                      child: SizedBox(
                                        //metni görevi tamamlandı olarak işaretle cümlesine benzer bir cümleyle değiştir
                                        child: Center(
                                          child: Wrap(
                                            children: [
                                              Text(
                                                L10n.of(context)!.selectDone,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Material(
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(8))),
                                    color: Colors.red[400],
                                    child: InkWell(
                                      onTap: () {
                                        pageUpdateProvider
                                            .floatingActionOnPressed(
                                                widget.widget.task, 0);
                                      },
                                      child: SizedBox(
                                        child: Center(
                                          child: Wrap(
                                            crossAxisAlignment:
                                                WrapCrossAlignment.center,
                                            direction: Axis.vertical,
                                            children: [
                                              Text(
                                                  L10n.of(context)!
                                                      .resetPomodoro,
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
