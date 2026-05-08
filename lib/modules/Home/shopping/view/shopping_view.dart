import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../controller/shopping_controller.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';

class ShoppingView extends StatelessWidget {
  ShoppingView({super.key});

  final controller =
      Get.isRegistered<ShoppingController>()
          ? Get.find<ShoppingController>()
          : Get.put<ShoppingController>(ShoppingController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      body: SafeArea(
        child: Obx(() {
          final hasCartItems = controller.cartCount.value > 0;
          return Stack(
            children: [
              CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(16.w, 0.h, 16.w, 10.h),
                      child: _Header(
                        cartCount: controller.cartCount.value,
                        onCartTap: () => Get.toNamed(Routes.shoppingCart),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: _SearchBar(
                        onChanged:
                            (value) => controller.searchQuery.value = value,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: 14.h)),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 38.h,
                      child: ListView.separated(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.categories.length,
                        separatorBuilder: (_, __) => SizedBox(width: 8.w),
                        itemBuilder: (_, index) {
                          final category = controller.categories[index];
                          final isSelected =
                              category == controller.selectedCategory.value;
                          return GestureDetector(
                            onTap:
                                () =>
                                    controller.selectedCategory.value =
                                        category,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 220),
                              padding: EdgeInsets.symmetric(
                                horizontal: 14.w,
                                vertical: 8.h,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    isSelected
                                        ? AppColors.primary
                                        : Colors.white,
                                borderRadius: BorderRadius.circular(20.r),
                                border: Border.all(
                                  color:
                                      isSelected
                                          ? AppColors.primary
                                          : AppColors.textSecondary.withValues(
                                            alpha: 0.16,
                                          ),
                                ),
                              ),
                              child: Text(
                                category.tr,
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color:
                                      isSelected
                                          ? Colors.white
                                          : AppColors.textSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(
                      16.w,
                      16.h,
                      16.w,
                      hasCartItems ? 130.h : 18.h,
                    ),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate((_, index) {
                        final product = controller.filteredProducts[index];
                        return _ProductCard(
                          product: product,
                          quantity: controller.qty(product),
                          onIncrement: () => controller.add(product),
                          onDecrement: () => controller.dec(product),
                        );
                      }, childCount: controller.filteredProducts.length),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            MediaQuery.of(context).size.width >= 700 ? 3 : 2,
                        mainAxisSpacing: 8.h,
                        crossAxisSpacing: 8.w,
                        childAspectRatio:
                            MediaQuery.of(context).size.width < 360
                                ? 0.69
                                : 0.74,
                      ),
                    ),
                  ),
                ],
              ),
              if (hasCartItems)
                Positioned(
                  left: 14.w,
                  right: 14.w,
                  bottom: 16.h,
                  child: _CartSummary(
                    itemCount: controller.cartCount.value,
                    total: controller.cartTotal.value,
                    onTap: () => Get.toNamed(Routes.shoppingCart),
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.cartCount, required this.onCartTap});

  final int cartCount;
  final VoidCallback onCartTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15.h),
              Text(
                'shop_title'.tr,
                style: TextStyle(
                  fontSize: 24.sp,
                  height: 1.1,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF111827),
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'shop_subtitle'.tr,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: onCartTap,
          child: Container(
            width: 44.r,
            height: 44.r,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Stack(
              children: [
                Center(
                  child: Icon(
                    Iconsax.shopping_cart_outline,
                    size: 20.r,
                    color: AppColors.primary,
                  ),
                ),
                if (cartCount > 0)
                  Positioned(
                    right: 6.w,
                    top: 6.h,
                    child: Container(
                      width: 16.r,
                      height: 16.r,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          cartCount > 9 ? '9+' : '$cartCount',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: AppColors.textSecondary.withValues(alpha: 0.15),
        ),
      ),
      child: TextField(
        onChanged: onChanged,
        style: TextStyle(fontSize: 13.sp, color: AppColors.textPrimary),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'shop_search_hint'.tr,
          hintStyle: TextStyle(
            fontSize: 12.sp,
            color: AppColors.textSecondary.withValues(alpha: 0.7),
          ),
          prefixIcon: Icon(
            Iconsax.search_normal_1_outline,
            color: AppColors.textSecondary,
            size: 18.r,
          ),
          contentPadding: EdgeInsets.only(top: 14.h),
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({
    required this.product,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  final ShopProduct product;
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final imageHeight = (constraints.maxHeight * 0.5).clamp(108.0, 148.0);
        return Container(
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.06),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: imageHeight,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14.r),
                  gradient: LinearGradient(
                    colors: [
                      AppColors.secondary.withValues(alpha: 0.18),
                      AppColors.primary.withValues(alpha: 0.1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child:
                    product.imagePath != null
                        ? ClipRRect(
                          borderRadius: BorderRadius.circular(14.r),
                          child: Image.asset(
                            product.imagePath!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        )
                        : Icon(
                          product.icon,
                          color: AppColors.primary,
                          size: 34.r,
                        ),
              ),
              SizedBox(height: 8.h),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.titleKey.tr,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13.sp,
                        height: 1.2,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      product.subtitleKey.tr,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                        height: 1.2,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Text(
                          '\u20B9${product.price.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const Spacer(),
                        if (quantity == 0)
                          GestureDetector(
                            onTap: onIncrement,
                            child: Container(
                              height: 34.r,
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'Add to Cart',
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        else
                          Container(
                            height: 34.r,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF4F7FC),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: onDecrement,
                                  child: Container(
                                    width: 34.r,
                                    height: 34.r,
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.remove_rounded,
                                      color: AppColors.textPrimary,
                                      size: 16.r,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 28.w,
                                  child: Text(
                                    '$quantity',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: onIncrement,
                                  child: Container(
                                    width: 34.r,
                                    height: 34.r,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    child: Icon(
                                      Icons.add_rounded,
                                      color: Colors.white,
                                      size: 16.r,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CartSummary extends StatelessWidget {
  const _CartSummary({
    required this.itemCount,
    required this.total,
    required this.onTap,
  });

  final int itemCount;
  final double total;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 11.h),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.backgroundLight, AppColors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(999.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2A75B6).withValues(alpha: 0.28),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: 111.w,
              top: -20.h,
              child: Container(
                width: 52.r,
                height: 52.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blueAccent.withValues(alpha: 0.08),
                ),
              ),
            ),
            Positioned(
              right: 22.w,
              bottom: -18.h,
              child: Container(
                width: 44.r,
                height: 44.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  width: 42.r,
                  height: 42.r,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.10),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Iconsax.shopping_bag_outline,
                    color: Colors.blueAccent,
                    size: 18.r,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'shop_cart_items'.trParams({'count': '$itemCount'}),
                        style: TextStyle(
                          color: Colors.black.withValues(alpha: 0.88),
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '\u20B9${total.toStringAsFixed(0)}',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                  child: Text(
                    'View Cart',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
