import 'package:flutter/material.dart';
import 'package:pomotodo/core/providers/select_icon_provider.dart';
import 'package:pomotodo/l10n/app_l10n.dart';
import 'package:pomotodo/views/home_view/widgets/add_task_widget.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class FloatingButtons extends StatelessWidget {
  const FloatingButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ChangeNotifierProvider(
        create: (context) => ButtonState(),
        child: ExpandableFab(
          distance: 75.0,
          children: [
            Consumer<ButtonState>(
              builder: (context, value, child) {
                return IgnorePointer(
                  ignoring: !context.watch<ButtonState>().open,
                  child: ActionButton(
                    text: L10n.of(context)!.stats,
                    icon: Icons.stacked_bar_chart,
                    onPressed: () {
                      Navigator.pushNamed(context, '/taskStatistics');
                    },
                  ),
                );
              },
            ),
            Consumer<ButtonState>(
              builder: (context, value, child) {
                return IgnorePointer(
                  ignoring: !context.watch<ButtonState>().open,
                  child: ActionButton(
                    text: L10n.of(context)!.leaderboard,
                    icon: Icons.leaderboard,
                    onPressed: () {
                      Navigator.pushNamed(context, '/leaderboard');
                    },
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

@immutable
class ExpandableFab extends StatefulWidget {
  const ExpandableFab(
      {super.key,
      this.initialOpen,
      required this.distance,
      required this.children});

  final bool? initialOpen;
  final double distance;
  final List<Widget> children;

  @override
  State<ExpandableFab> createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;
  late ButtonState buttonState;

  @override
  void initState() {
    super.initState();
    buttonState = Provider.of<ButtonState>(context, listen: false);

    buttonState.open = widget.initialOpen ?? false;
    _controller = AnimationController(
      value: buttonState.open ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeOutQuad,
      parent: _controller,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    buttonState.changeStateOfButton();
    if (buttonState.open) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.bottomLeft,
        clipBehavior: Clip.none,
        children: [
          _buildTapToCloseFab(),
          ..._buildExpandingActionButtons(),
          _buildTapToOpenFab(),
        ],
      ),
    );
  }

  Widget _buildTapToCloseFab() {
    return SizedBox(
      width: 56.0,
      height: 56.0,
      child: Center(
        child: Material(
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          elevation: 4.0,
          child: InkWell(
            onTap: _toggle,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.close,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildExpandingActionButtons() {
    final children = <Widget>[];
    final count = widget.children.length;
    final step = 90.0 / (count - 1);
    for (var i = 0, angleInDegrees = 0.0;
        i < count;
        i++, angleInDegrees += step) {
      children.add(
        _ExpandingActionButton(
          directionInDegrees: angleInDegrees,
          maxDistance: widget.distance,
          progress: _expandAnimation,
          child: widget.children[i],
        ),
      );
    }
    return children;
  }

  Widget _buildTapToOpenFab() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IgnorePointer(
          ignoring: buttonState.open,
          child: AnimatedContainer(
            transformAlignment: Alignment.center,
            transform: Matrix4.diagonal3Values(
              buttonState.open ? 0.7 : 1.0,
              buttonState.open ? 0.7 : 1.0,
              1.0,
            ),
            duration: const Duration(milliseconds: 250),
            curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
            child: AnimatedOpacity(
              opacity: buttonState.open ? 0.0 : 1.0,
              curve: const Interval(0.25, 1.0, curve: Curves.easeInOut),
              duration: const Duration(milliseconds: 250),
              child: FloatingActionButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                onPressed: _toggle,
                heroTag: "btn1",
                child: const Icon(Icons.show_chart),
              ),
            ),
          ),
        ),
        FloatingActionButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          heroTag: "btn2",
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16))),
              builder: (BuildContext context) {
                return ChangeNotifierProvider(
                    create: (context) => SelectIcon(),
                    child: const AddTaskWidget());
              },
            );
          },
          child: const Icon(Icons.add),
        ),
      ],
    );
  }
}

@immutable
class _ExpandingActionButton extends StatelessWidget {
  const _ExpandingActionButton({
    required this.directionInDegrees,
    required this.maxDistance,
    required this.progress,
    required this.child,
  });

  final double directionInDegrees;
  final double maxDistance;
  final Animation<double> progress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        final offset = Offset.fromDirection(
          directionInDegrees * (math.pi / 180.0),
          progress.value * maxDistance,
        );
        return Positioned(
          left: 4.0 + offset.dx,
          bottom: 4.0 + offset.dy,
          child: Transform.rotate(
            angle: (1.0 - progress.value) * math.pi / 2,
            child: child!,
          ),
        );
      },
      child: FadeTransition(
        opacity: progress,
        child: child,
      ),
    );
  }
}

@immutable
class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    this.onPressed,
    required this.text,
    required this.icon,
  });

  final VoidCallback? onPressed;
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      color: theme.colorScheme.secondary,
      elevation: 4.0,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                icon,
                color: theme.colorScheme.onSecondary,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  text,
                  style: TextStyle(
                    color: theme.colorScheme.onSecondary,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ButtonState extends ChangeNotifier {
  bool open = false;

  changeStateOfButton() {
    open = !open;
    notifyListeners();
  }
}
