import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controller/parallax_controller.dart';
import '../service/view/service_view.dart';

class HomeTabContent extends StatelessWidget {
  HomeTabContent({super.key});

  final controller = Get.put(ParallaxController());

  static const Color _bg = Colors.white;
  static const Color _deepBlue = Color(0xFF0D3A66);
  static const Color _midBlue = Color(0xFF14548D);
  static const Color _softCard = Color(0xFFFFF4EE);
  static const Color _red = Color(0xFFE23B3B);

  static String _serviceImageHeroTag(String title) => 'service-image-$title';
  static Tween<Rect?> _heroRectTween(Rect? begin, Rect? end) {
    return MaterialRectCenterArcTween(begin: begin, end: end);
  }

  static Widget _heroChild(BuildContext heroContext) {
    final heroWidget = heroContext.widget;
    return heroWidget is Hero ? heroWidget.child : heroWidget;
  }

  static Widget _serviceImageFlightShuttle(
    BuildContext flightContext,
    Animation<double> animation,
    HeroFlightDirection flightDirection,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) {
    final shuttleAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeInOutCubic,
      reverseCurve: Curves.easeOutCubic,
    );

    final child =
        flightDirection == HeroFlightDirection.push
            ? _heroChild(toHeroContext)
            : _heroChild(fromHeroContext);

    return AnimatedBuilder(
      animation: shuttleAnimation,
      child: child,
      builder: (context, shuttleChild) {
        final borderRadius = BorderRadius.lerp(
          flightDirection == HeroFlightDirection.push
              ? BorderRadius.circular(26.r)
              : BorderRadius.zero,
          flightDirection == HeroFlightDirection.push
              ? BorderRadius.zero
              : BorderRadius.circular(26.r),
          shuttleAnimation.value,
        );

        final opacity =
            flightDirection == HeroFlightDirection.pop
                ? Tween<double>(begin: 1, end: 0).transform(
                  Curves.easeOut.transform(
                    shuttleAnimation.value.clamp(0.0, 0.7) / 0.7,
                  ),
                )
                : 1.0;

        return Opacity(
          opacity: opacity,
          child: ClipRRect(
            borderRadius: borderRadius ?? BorderRadius.zero,
            child: shuttleChild,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Container(
        color: _bg,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(0.w, topInset + 10.h, 0.w, 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              // SizedBox(height: 14.h),
              _buildServiceCarousel(),
              SizedBox(height: 14.h),
              _buildProductiveCard(),
              SizedBox(height: 18.h),
              _buildUpcomingBookings(),
              SizedBox(height: 18.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 0.h),
                child: Text(
                  "Today's Schedule",
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                    color: _deepBlue,
                  ),
                ),
              ),

              _buildScheduleGrid(),

              // _buildBottomPreview(),
              SizedBox(height: 80.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: _softCard,
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                  child: Text(
                    'WELCOME BACK',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                      color: _red,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                RichText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w800,
                      height: 1.05,
                      color: _deepBlue,
                    ),
                    children: const [
                      TextSpan(text: 'Care that feels '),
                      TextSpan(text: 'closer', style: TextStyle(color: _red)),
                    ],
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Personalized home health support for your day.',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    height: 1.45,
                    color: _deepBlue.withValues(alpha: 0.64),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 10.w),
          Container(
            height: 42.r,
            width: 42.r,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14.r),
              boxShadow: [
                BoxShadow(
                  color: _deepBlue.withValues(alpha: 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(Icons.notifications, color: _red, size: 20.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCarousel() {
    return SizedBox(
      height: 330.h,
      child: Obx(() {
        final currentPage = controller.currentPage.value;

        return PageView.builder(
          controller: controller.pageController,
          itemCount: controller.virtualItemCount,
          itemBuilder: (context, index) {
            final actualIndex = index % controller.cards.length;
            final offset = index - currentPage;
            final card = controller.cards[actualIndex];
            final double distance = offset.abs().clamp(0.0, 1.2).toDouble();
            final double scale = 1 - (distance * 0.1);
            final double yOffset = distance * 18.h;
            final double opacity =
                (1 - (distance * 0.25)).clamp(0.72, 1.0).toDouble();

            return GestureDetector(
              onTap: () async {
                controller.pauseAutoScroll();
                await Get.to(
                  () => ServiceDetailView(
                    title: card['title']!,
                    subtitle: card['subtitle']!,
                    imagePath: card['image']!,
                  ),
                  transition: Transition.fadeIn,
                  duration: const Duration(milliseconds: 500),
                );
                controller.resumeAutoScroll();
              },
              child: Align(
                alignment: Alignment.center,
                child: Transform.translate(
                  offset: Offset(0, yOffset),
                  child: Transform(
                    transform:
                        Matrix4.identity()
                          ..setEntry(3, 2, 0.0012)
                          ..rotateY(-offset * 0.18),
                    alignment: Alignment.center,
                    child: Opacity(
                      opacity: opacity,
                      child: Transform.scale(
                        scale: scale,
                        child: _HeroParallaxCard(
                          title: card['title']!,
                          subtitle: card['subtitle']!,
                          imagePath: card['image']!,
                          offset: offset,
                          heroTag: _serviceImageHeroTag(card['title']!),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildProductiveCard() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_deepBlue, _midBlue],
          ),
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Great, your today's\nplan almost done",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 20.sp,
                      height: 1.3,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: _red,
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                    child: Text(
                      'View Task',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 90.r,
              height: 90.r,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CircularProgressIndicator(
                    value: 0.8,
                    strokeWidth: 9,
                    backgroundColor: Colors.white24,
                    valueColor: const AlwaysStoppedAnimation(_red),
                  ),
                  Center(
                    child: Text(
                      '80%',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 20.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleGrid() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 0.9,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: const [
          _ScheduleTile(
            title: 'Physiotherapy\nsession',
            time: '07:00 - 08:00',
            background: Colors.white,
            foreground: _deepBlue,
          ),
          _ScheduleTile(
            title: 'Post-op\nwound dressing',
            time: '09:00 - 10:30',
            background: _softCard,
            foreground: _deepBlue,
            iconData: Icons.healing_outlined,
          ),
          _ScheduleTile(
            title: 'Medication &\nvitals check',
            time: '11:00 - 12:00',
            background: _softCard,
            foreground: _deepBlue,
            iconData: Icons.monitor_heart_outlined,
          ),
          _ScheduleTile(
            title: 'Click to\nview more',
            time: '+5 schedule',
            background: _deepBlue,
            foreground: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingBookings() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Upcoming Bookings',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: _deepBlue,
            ),
          ),
          SizedBox(height: 10.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18.r),
              border: Border.all(color: const Color(0xFFE7EEF7)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 46.r,
                  height: 46.r,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F1FB),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.calendar_month_rounded,
                    color: _deepBlue,
                    size: 24.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nursing Visit - Home Care',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color: _deepBlue,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Today, 07:30 PM',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: _red,
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                  child: Text(
                    'View',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
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

class _HeroParallaxCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final double offset;
  final String heroTag;

  const _HeroParallaxCard({
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.offset,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 0.84.sw,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.16),
            blurRadius: 18,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26.r),
        child: Stack(
          children: [
            SizedBox(height: 306.h),
            Positioned.fill(
              child: Transform.translate(
                offset: Offset(offset * 30, 0),
                child: OverflowBox(
                  minWidth: 0,
                  maxWidth: 1.2.sw,
                  alignment: Alignment.center,
                  child: Hero(
                    tag: heroTag,
                    createRectTween: HomeTabContent._heroRectTween,
                    flightShuttleBuilder:
                        HomeTabContent._serviceImageFlightShuttle,
                    placeholderBuilder: (context, heroSize, child) => child,
                    transitionOnUserGestures: true,
                    child: SizedBox(
                      width: 1.2.sw,
                      height: 306.h,
                      child: Image.asset(
                        imagePath,
                        fit: BoxFit.fitWidth,
                        alignment: Alignment.center,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              right: -28.w,
              bottom: 44.h,
              child: Transform.translate(
                offset: Offset(offset * 24, 0),
                child: Container(
                  width: 120.r,
                  height: 120.r,
                  decoration: BoxDecoration(
                    color: const Color(0x33E23B3B),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.5),
                      Colors.black.withValues(alpha: 0.02),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 14.w,
              right: 14.w,
              bottom: 14.h,
              child: Transform.translate(
                offset: Offset(offset * -18, 0),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.11),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 12.5.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScheduleTile extends StatelessWidget {
  final String title;
  final String time;
  final Color background;
  final Color foreground;
  final IconData? iconData;

  const _ScheduleTile({
    required this.title,
    required this.time,
    required this.background,
    required this.foreground,
    this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: foreground,
              fontSize: 17.sp,
              fontWeight: FontWeight.w700,
              height: 1.3,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            time,
            style: TextStyle(
              color: foreground.withValues(alpha: 0.65),
              fontSize: 14.sp,
            ),
          ),
          const Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child:
                iconData != null
                    ? Icon(
                      iconData,
                      color: foreground.withValues(alpha: 0.7),
                      size: 28.sp,
                    )
                    : Icon(
                      Icons.arrow_outward_rounded,
                      color: foreground.withValues(alpha: 0.7),
                      size: 20.sp,
                    ),
          ),
        ],
      ),
    );
  }
}
