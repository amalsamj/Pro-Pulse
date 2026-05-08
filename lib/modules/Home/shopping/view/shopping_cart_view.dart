import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pro_pulse_medical_app/core/widgets/glass_snack_bar.dart';
import 'package:pro_pulse_medical_app/modules/booking/widgets/booking_appbar.dart';
import '../../../../core/constants/app_colors.dart';
import '../controller/shopping_controller.dart';
import 'package:get/get.dart';

class ShoppingCartView extends StatefulWidget {
  const ShoppingCartView({super.key, required this.controller});

  final ShoppingController controller;

  @override
  State<ShoppingCartView> createState() => _ShoppingCartViewState();
}

class _ShoppingCartViewState extends State<ShoppingCartView> {
  final couponController = TextEditingController();

  @override
  void dispose() {
    couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.controller;
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: CustomBackAppBar(
        backgroundColor: const Color(0xFFF6F8FB),
        iconColor: Colors.black54,
        onBack: () => Get.back(),
        title: 'Cart',
        elevation: 0,
      ),
      body: SafeArea(
        child: Obx(() {
          final items = c.cartProducts;
          if (items.isEmpty) {
            return Center(
              child: Text(
                'Your cart is empty',
                style: TextStyle(
                  fontSize: 15.sp,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.fromLTRB(14.w, 10.h, 14.w, 8.h),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => SizedBox(height: 10.h),
                  itemBuilder: (_, i) {
                    final p = items[i];
                    final q = c.qty(p);
                    return Slidable(
                      key: ValueKey(p.titleKey),
                      endActionPane: ActionPane(
                        motion: const DrawerMotion(),
                        dismissible: DismissiblePane(
                          onDismissed: () => c.remove(p),
                        ),
                        children: [
                          SlidableAction(
                            onPressed: (_) => c.remove(p),
                            icon: Icons.delete_sweep_outlined,
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ],
                      ),
                      child: Container(
                        padding: EdgeInsets.all(12.r),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14.r),
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
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10.r),
                              child:
                                  p.imagePath != null
                                      ? Image.asset(
                                        p.imagePath!,
                                        width: 62.w,
                                        height: 62.w,
                                        fit: BoxFit.cover,
                                      )
                                      : Container(
                                        width: 62.w,
                                        height: 62.w,
                                        color: const Color(0xFFF2F6FF),
                                        child: Icon(
                                          p.icon,
                                          color: AppColors.primary,
                                        ),
                                      ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    p.titleKey.tr,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    '\u20B9${p.price.toStringAsFixed(0)}',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 32.h,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF4F7FC),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () => c.dec(p),
                                    child: SizedBox(
                                      width: 28.w,
                                      child: Icon(Icons.remove, size: 16.r),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 26.w,
                                    child: Text(
                                      '$q',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => c.add(p),
                                    child: Container(
                                      width: 28.w,
                                      decoration: BoxDecoration(
                                        // color: AppColors.primary,
                                        borderRadius: BorderRadius.circular(
                                          10.r,
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.add,
                                        size: 16.r,
                                        // color: Colors.white,
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
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(14.w, 2.h, 14.w, 14.h),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 12.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: AppColors.textSecondary.withValues(
                            alpha: 0.12,
                          ),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 14,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: couponController,
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                isDense: true,
                                hintText: 'Coupon (SAVE10 / HEAL50)',
                                hintStyle: TextStyle(
                                  fontSize: 11.sp,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 36.h,
                            child: ElevatedButton(
                              onPressed: () {
                                final ok = c.applyCoupon(couponController.text);
                                Get.snackbar(
                                  ok ? 'Coupon applied' : 'Invalid coupon',
                                  ok
                                      ? 'Discount updated in summary.'
                                      : 'Use SAVE10 or HEAL50',
                                  snackPosition: SnackPosition.TOP,
                                  duration: const Duration(seconds: 2),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 14.w),
                                backgroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                              ),
                              child: Text(
                                'Apply',
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(14.r),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: AppColors.textSecondary.withValues(
                            alpha: 0.12,
                          ),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 14,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Product Summary',
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          _summaryRow('MRP', c.cartTotal.value),
                          SizedBox(height: 6.h),
                          _summaryRow('Discount', c.discountAmount.value),
                          SizedBox(height: 6.h),
                          _summaryRow('Tax (5%)', c.payableTotal * 0.05),
                          Divider(height: 16.h),
                          _summaryRow(
                            'Total',
                            c.payableTotal + (c.payableTotal * 0.05),
                            isBold: true,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h),
                    SizedBox(
                      width: double.infinity,
                      height: 50.h,
                      child: ElevatedButton(
                        onPressed: () {
                          final finalTotal =
                              c.payableTotal + (c.payableTotal * 0.05);
                          // Get.snackbar(
                          //   'Proceeding',
                          //   'Order total: \u20B9${finalTotal.toStringAsFixed(0)}',
                          //   snackPosition: SnackPosition.TOP,
                          //   backgroundColor: Colors.white,
                          //   // colorText: AppColors.textPrimary,
                          //   // borderColor: AppColors.primary,
                          // );
                          showGlassSnack(
                            title: "Proceeding",
                            message:
                                'Order total: \u20B9${finalTotal.toStringAsFixed(0)}',
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'Proceed to Buy',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _summaryRow(String label, double value, {bool isBold = false}) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        const Spacer(),
        Text(
          '\u20B9${value.toStringAsFixed(0)}',
          style: TextStyle(
            fontSize: isBold ? 14.sp : 12.sp,
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
