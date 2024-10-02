import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:your_dictionary/src/presentation/resources/color_manager.dart';

import '../../resources/routes_manager.dart';

class FloatingActionAddButton extends StatefulWidget {
  const FloatingActionAddButton({super.key});

  @override
  State<FloatingActionAddButton> createState() =>
      _FloatingActionAddButtonState();
}

class _FloatingActionAddButtonState extends State<FloatingActionAddButton>
    with SingleTickerProviderStateMixin {
  final _link = LayerLink();
  final GlobalKey widgetKey = GlobalKey();
  final OverlayPortalController _overlayController = OverlayPortalController();

  Offset getActionButtonOffset() {
    BuildContext widgetContext = widgetKey.currentContext!;
    RenderBox box = widgetContext.findRenderObject() as RenderBox;
    final offset = box.localToGlobal(const Offset(32, 90));
    return offset;
  }

  late Animation<double> angleIncrementAnimation;
  late AnimationController animationController;

  void closeActionMenu() {
    animationController.reverse().then((_) => _overlayController.hide());
  }

  void openActionMenu() {
    _overlayController.show();
    animationController.forward();
  }

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    angleIncrementAnimation =
        Tween<double>(begin: 0, end: pi / 4).animate(animationController);

    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OverlayPortal(
      controller: _overlayController,
      overlayChildBuilder: (context) => CompositedTransformFollower(
        link: _link,
        targetAnchor: Alignment.center,
        followerAnchor: Alignment.bottomCenter,
        offset: const Offset(0, 0),
        child: _buildActionMenu(),
      ),
      child: CompositedTransformTarget(
        link: _link,
        child: GestureDetector(
          onTapDown: (details) {
            if (_overlayController.isShowing) {
              closeActionMenu();
            } else {
              openActionMenu();
            }
          },
          child: ActionButtonWidget(
            key: widgetKey,
          ),
        ),
      ),
    );
  }

  _getChildrenOffset(int i, double angleIncrement) {
    double boundRadius = 70;
    double startAngle = (-pi / 2) - ((angleIncrement * (icons.length + 1)) / 2);
    double angle = (i + 1) * angleIncrement + startAngle;
    double x = Offset.zero.dx + boundRadius * cos(angle);
    double y = Offset.zero.dy + boundRadius * sin(angle);

    final offset = Offset(x, y);
    return offset + getActionButtonOffset();
  }

  Widget _buildActionMenu() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height,
      child: Stack(
        children: [
          ...List.generate(
            icons.length,
            (index) => AnimatedBuilder(
              animation: angleIncrementAnimation,
              builder: (context, child) => Positioned.fromRect(
                rect: Rect.fromCircle(
                  center: _getChildrenOffset(
                    index,
                    angleIncrementAnimation.value,
                  ),
                  radius: 20,
                ),
                child: GestureDetector(
                  onTap: () {
                    closeActionMenu();
                    icons[index].onTap(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: ColorManager.primary.withOpacity(.3),
                              blurRadius: 5,
                              offset: const Offset(0, 3))
                        ]),
                    child: Icon(
                      icons[index].icon,
                      size: 25,
                      color: icons[index].color,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MenuButton {
  final IconData icon;
  final Color color;
  final Function(BuildContext) onTap;

  MenuButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });
}

List<MenuButton> icons = [
  MenuButton(
    icon: CupertinoIcons.pen,
    color: ColorManager.primary,
    onTap: (BuildContext context) =>
        Navigator.pushNamed(context, Routes.addEditWordRoute),
  ),
  MenuButton(
    icon: CupertinoIcons.wand_stars_inverse,
    color: ColorManager.primary,
    onTap: (BuildContext context) => print("tapped 2"),
  ),
  MenuButton(
    icon: CupertinoIcons.camera,
    color: ColorManager.primary,
    onTap: (BuildContext context) => Navigator.pushNamed(
      context,
      Routes.scanCameraRoute,
    ),
  ),
];

class ActionButtonWidget extends StatelessWidget {
  const ActionButtonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color.fromARGB(255, 2, 23, 84),
      ),
      height: 65,
      width: 65,
      child: const Icon(
        CupertinoIcons.add,
        size: 30,
        color: Colors.white,
      ),
    );
  }
}
