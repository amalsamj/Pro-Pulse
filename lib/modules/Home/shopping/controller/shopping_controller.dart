import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';

class ShopProduct {
  const ShopProduct({
    required this.titleKey,
    required this.categoryKey,
    required this.price,
    required this.subtitleKey,
    required this.icon,
    this.imagePath,
  });

  final String titleKey;
  final String categoryKey;
  final double price;
  final String subtitleKey;
  final IconData icon;
  final String? imagePath;
}

class ShoppingController extends GetxController {
  final searchQuery = ''.obs;
  final selectedCategory = 'shop_cat_all'.obs;
  final cartCount = 0.obs;
  final cartTotal = 0.0.obs;
  final quantities = <String, int>{}.obs;
  final appliedCoupon = ''.obs;
  final discountAmount = 0.0.obs;

  final categories = const [
    'shop_cat_all',
    'shop_cat_monitoring',
    'shop_cat_mobility',
    'shop_cat_respiratory',
    'shop_cat_care',
  ];

  final products = const [
    ShopProduct(
      titleKey: 'shop_p_bp_monitor',
      categoryKey: 'shop_cat_monitoring',
      price: 89.0,
      subtitleKey: 'Digital Blood Pressure Monitor',
      icon: Iconsax.health_outline,
      imagePath: 'assets/images/2.png',
    ),
    ShopProduct(
      titleKey: 'Digital Thermometer',
      categoryKey: 'shop_cat_monitoring',
      price: 49.0,
      subtitleKey: 'Non-contact temperature measurement',
      icon: Iconsax.activity_outline,
      imagePath: 'assets/images/1.png',
    ),
    ShopProduct(
      titleKey: 'Suction Machine',
      categoryKey: 'shop_cat_mobility',
      price: 899.0,
      subtitleKey: 'Medical suction machine with catheter',
      icon: Iconsax.activity_outline,
      imagePath: 'assets/images/6.jpeg',
    ),
    ShopProduct(
      titleKey: 'Medical Bed',
      categoryKey: 'shop_cat_respiratory',
      price: 129.0,
      subtitleKey: 'Adjustable bed for patient comfort.',
      icon: Iconsax.activity_outline,
      imagePath: 'assets/images/5.jpeg',
    ),
    ShopProduct(
      titleKey: 'CPAP Machine',
      categoryKey: 'shop_cat_care',
      price: 25.0,
      subtitleKey: 'CPAP machine for sleep apnea.',
      icon: Iconsax.activity_outline,
      imagePath: 'assets/images/3.jpeg',
    ),
    ShopProduct(
      titleKey: 'Oxygen Concentrator',
      categoryKey: 'shop_cat_monitoring',
      price: 69.0,
      subtitleKey: 'Respiratory oxygen therapy device.',
      icon: Iconsax.activity_outline,
      imagePath: 'assets/images/7.jpeg',
    ),
  ];

  List<ShopProduct> get filteredProducts {
    return products.where((product) {
      final byCategory =
          selectedCategory.value == 'shop_cat_all' ||
          product.categoryKey == selectedCategory.value;
      final byQuery = product.titleKey.toLowerCase().contains(
        searchQuery.value.toLowerCase().trim(),
      );
      return byCategory && byQuery;
    }).toList();
  }

  int qty(ShopProduct p) => quantities[p.titleKey] ?? 0;

  List<ShopProduct> get cartProducts =>
      products.where((p) => qty(p) > 0).toList();

  double get payableTotal =>
      (cartTotal.value - discountAmount.value).clamp(0.0, 999999.0);

  void add(ShopProduct p) {
    cartCount.value += 1;
    cartTotal.value += p.price;
    quantities[p.titleKey] = qty(p) + 1;
    _recalc();
  }

  void dec(ShopProduct p) {
    final q = qty(p);
    if (q <= 0) return;
    if (q == 1) {
      quantities.remove(p.titleKey);
    } else {
      quantities[p.titleKey] = q - 1;
    }
    cartCount.value = (cartCount.value - 1).clamp(0, 9999);
    cartTotal.value = (cartTotal.value - p.price).clamp(0.0, 999999.0);
    _recalc();
  }

  void remove(ShopProduct p) {
    final q = qty(p);
    if (q <= 0) return;
    quantities.remove(p.titleKey);
    cartCount.value = (cartCount.value - q).clamp(0, 9999);
    cartTotal.value = (cartTotal.value - (p.price * q)).clamp(0.0, 999999.0);
    _recalc();
  }

  bool applyCoupon(String code) {
    final c = code.trim().toUpperCase();
    if (c == 'SAVE10' || c == 'HEAL50') {
      appliedCoupon.value = c;
      _recalc();
      return true;
    }
    return false;
  }

  void _recalc() {
    if (appliedCoupon.value == 'SAVE10') {
      discountAmount.value = cartTotal.value * 0.10;
    } else if (appliedCoupon.value == 'HEAL50') {
      discountAmount.value = cartTotal.value >= 500 ? 50 : 0;
    } else {
      discountAmount.value = 0;
    }
  }
}
