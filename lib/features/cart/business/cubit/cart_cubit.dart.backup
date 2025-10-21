import 'package:baqalty/core/images_preview/app_assets.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/cart_item_model.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial()) {
    _loadInitialCart();
  }

  // Sample cart data - in real app this would come from a service
  final List<CartItemModel> _cartItems = [
    const CartItemModel(
      id: '1',
      productName: 'chocolate_milk',
      category: 'milk_category',
      productImage: AppAssets.chocolateMilk,
      price: 12.25,
      quantity: 2,
    ),
    const CartItemModel(
      id: '2',
      productName: 'nido_milk',
      category: 'milk_category',
      productImage: AppAssets.alMaraiMilk,
      price: 12.25,
      quantity: 1,
    ),
    const CartItemModel(
      id: '3',
      productName: 'al_marai_milk',
      category: 'milk_category',
      productImage: AppAssets.juhaynaMilk,
      price: 12.25,
      quantity: 1,
    ),
  ];

  bool _isCartSaved = false;

  void _loadInitialCart() {
    emit(CartLoading());
    _updateCartState();
  }

  void updateQuantity(String itemId, int newQuantity) {
    if (newQuantity <= 0) {
      removeItem(itemId);
      return;
    }

    final itemIndex = _cartItems.indexWhere((item) => item.id == itemId);
    if (itemIndex != -1) {
      _cartItems[itemIndex] = _cartItems[itemIndex].copyWith(
        quantity: newQuantity,
      );
      _updateCartState();
    }
  }

  void removeItem(String itemId) {
    _cartItems.removeWhere((item) => item.id == itemId);
    _updateCartState();
  }

  void toggleCartSave() {
    _isCartSaved = !_isCartSaved;
    _updateCartState();
  }

  void _updateCartState() {
    final subTotal = _cartItems.fold<double>(
      0,
      (sum, item) => sum + (item.price * item.quantity),
    );
    const deliveryFee = 10.0;
    const discount = 20.0;
    final total = subTotal + deliveryFee - discount;

    emit(
      CartLoaded(
        cartItems: List.from(_cartItems),
        subTotal: subTotal,
        deliveryFee: deliveryFee,
        discount: discount,
        total: total,
        isCartSaved: _isCartSaved,
      ),
    );
  }
}
