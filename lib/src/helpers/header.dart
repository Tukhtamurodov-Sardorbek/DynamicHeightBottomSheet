import 'package:dynamicbottomsheet/src/provider/provider.dart';
import 'package:dynamicbottomsheet/src/provider/singleton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InheritedDynamicBottomSheetHeader extends InheritedWidget {
  final TabController tabController;
  final PageController pageController;
  final int childCount;

  const InheritedDynamicBottomSheetHeader({
    Key? key,
    required this.childCount,
    required this.tabController,
    required this.pageController,
    required Widget child,
  }) : super(key: key, child: child);

  static InheritedDynamicBottomSheetHeader of(BuildContext context) {
    final InheritedDynamicBottomSheetHeader? result = context.dependOnInheritedWidgetOfExactType<InheritedDynamicBottomSheetHeader>();
    assert(result != null, 'No SheetHeaderInherited found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(InheritedDynamicBottomSheetHeader oldWidget) {
    return false;
  }
}


class SheetHeader extends StatelessWidget {
  const SheetHeader({super.key});

  @override
  Widget build(BuildContext context) {
    // print('HEADER BUILT');
    return Material(
      elevation: 8.0,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      child: Container(
        height: context.read<DynamicBottomSheetProvider>().headerHeight,
        padding: const EdgeInsets.only(top: 10, bottom: 6),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 4,
              width: 54,
              decoration: BoxDecoration(
                color: SheetData.instance.grabbingColor ?? Colors.grey,
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            const SizedBox(height: 10),
            if(context.read<DynamicBottomSheetProvider>().hasTitles)
              const Flexible(
                child: _SheetTabBar(),
              ),
          ],
        ),
      ),
    );
  }
}

class _SheetTabBar extends StatelessWidget {
  const _SheetTabBar();

  @override
  Widget build(BuildContext context) {
    final data = SheetData.instance;
    final childCount = InheritedDynamicBottomSheetHeader.of(context).childCount;
    final tabController = InheritedDynamicBottomSheetHeader.of(context).tabController;
    final pageController = InheritedDynamicBottomSheetHeader.of(context).pageController;

    return TabBar(
      onTap: (index) {
        pageController.jumpToPage(index);
      },
      controller: tabController,
      isScrollable: childCount > 4,
      physics: childCount > 4 ? const ClampingScrollPhysics() : const NeverScrollableScrollPhysics(),
      // indicatorPadding: const EdgeInsets.symmetric(horizontal: -4),
      padding: EdgeInsets.symmetric(horizontal: data.horizontalPadding ?? 0),
      labelColor: data.selectedTitleColor ?? Colors.white,
      unselectedLabelColor: data.unselectedTitleColor ?? Colors.blueGrey,
      labelStyle: data.titleStyle ?? const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w800,
      ),
      unselectedLabelStyle: data.titleStyle ?? const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w800,
      ),
      indicatorWeight: 0.0,
      indicatorSize: TabBarIndicatorSize.tab,
      indicator: BoxDecoration(
        borderRadius: BorderRadius.circular(20), // Creates border
        color: data.indicatorColor ?? CupertinoColors.activeGreen,
      ),
      tabs: [
        for(int i = 0; i < childCount; i++)
          Tab(
            height: 40,
            text: data.titles![i],
          ),
      ],
    );
  }
}