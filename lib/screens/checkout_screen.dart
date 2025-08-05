import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/address.dart';
import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';
import '../models/cart_item.dart';
import '../widgets/custom_snackbar.dart';

enum PaymentMethod { creditCard, paypal, cashOnDelivery }

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool _isPlacingOrder = false;
  // --- STATE MANAGEMENT FOR INTERACTIVITY ---
  late Address _shippingAddress;
  PaymentMethod _selectedPaymentMethod = PaymentMethod.creditCard;
  final _addressFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Initialize with a default address
    _shippingAddress = Address(
      street: 'University Road',
      city: 'Bahawalpur',
      country: 'Punjab, Pakistan',
    );
  }

  Future<void> _placeOrder() async {
    if (_selectedPaymentMethod != PaymentMethod.cashOnDelivery) {
      CustomSnackBar.show(
        context: context,
        message: 'Online payment is not yet available.',
        backgroundColor: Colors.amber.shade800,
      );
      return;
    }

    final cart = Provider.of<CartProvider>(context, listen: false);
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);

    if (cart.items.isEmpty) return;

    setState(() => _isPlacingOrder = true);

    await Future.delayed(const Duration(seconds: 2));

    orderProvider.addOrder(cart.items, cart.totalPrice);
    cart.clearCart();

    if (mounted) {
      CustomSnackBar.show(
        context: context,
        message: 'Order placed successfully!',
        backgroundColor: Colors.green.shade600,
      );
      Navigator.pushNamedAndRemoveUntil(context, '/orders', (route) => route.isFirst);
    }
  }

  void _showEditAddressSheet() {
    final streetController = TextEditingController(text: _shippingAddress.street);
    final cityController = TextEditingController(text: _shippingAddress.city);
    final countryController = TextEditingController(text: _shippingAddress.country);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 20,
            left: 20,
            right: 20,
          ),
          child: Form(
            key: _addressFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Edit Shipping Address', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                TextFormField(
                  controller: streetController,
                  decoration: const InputDecoration(labelText: 'Street Address', border: OutlineInputBorder()),
                  validator: (value) => value!.isEmpty ? 'Please enter a street address' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: cityController,
                  decoration: const InputDecoration(labelText: 'City', border: OutlineInputBorder()),
                  validator: (value) => value!.isEmpty ? 'Please enter a city' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: countryController,
                  decoration: const InputDecoration(labelText: 'State/Country', border: OutlineInputBorder()),
                  validator: (value) => value!.isEmpty ? 'Please enter a state/country' : null,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                  onPressed: () {
                    if (_addressFormKey.currentState!.validate()) {
                      setState(() {
                        _shippingAddress = Address(
                          street: streetController.text,
                          city: cityController.text,
                          country: countryController.text,
                        );
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Save Address'),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Checkout', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSectionCard(
              title: 'Shipping Address',
              icon: Icons.local_shipping_outlined,
              child: ListTile(
                leading: const Icon(Icons.home_work_outlined),
                title: Text(_shippingAddress.street, style: const TextStyle(fontWeight: FontWeight.w500)),
                subtitle: Text('${_shippingAddress.city}, ${_shippingAddress.country}'),
                trailing: TextButton(
                  onPressed: _showEditAddressSheet,
                  child: const Text('Change'),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildSectionCard(
              title: 'Payment Method',
              icon: Icons.payment_outlined,
              child: Column(
                children: [
                  _buildPaymentOption(
                    title: 'Credit/Debit Card',
                    icon: Icons.credit_card,
                    value: PaymentMethod.creditCard,
                  ),
                  _buildPaymentOption(
                    title: 'PayPal',
                    icon: Icons.paypal,
                    value: PaymentMethod.paypal,
                  ),
                  _buildPaymentOption(
                    title: 'Cash on Delivery',
                    icon: Icons.money_outlined,
                    value: PaymentMethod.cashOnDelivery,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildSectionCard(
              title: 'Order Summary',
              icon: Icons.shopping_bag_outlined,
              child: _buildOrderSummaryList(cart),
            ),
            const SizedBox(height: 16),
            _buildPriceDetails(cart, theme),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(cart, theme),
    );
  }

  Widget _buildPaymentOption({required String title, required IconData icon, required PaymentMethod value}) {
    bool isSelected = _selectedPaymentMethod == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedPaymentMethod = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          color: isSelected ? Theme.of(context).colorScheme.primary.withOpacity(0.05) : Colors.transparent,
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey[600]),
            const SizedBox(width: 12),
            Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w500))),
            if (isSelected)
              Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required IconData icon, required Widget child}) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.grey[600]),
                const SizedBox(width: 10),
                Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const Divider(height: 24),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummaryList(CartProvider cart) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cart.items.length,
      itemBuilder: (context, index) {
        final item = cart.items[index];
        return AnimatedListItem(
          index: index,
          child: _buildSummaryItem(item),
        );
      },
      separatorBuilder: (context, index) => const Divider(indent: 16, endIndent: 16),
    );
  }

  Widget _buildSummaryItem(CartItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(item.product.image, width: 50, height: 50, fit: BoxFit.contain),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.product.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w500)),
                Text('Qty: ${item.quantity}', style: TextStyle(color: Colors.grey[600])),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text('\$${(item.product.price * item.quantity).toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildPriceDetails(CartProvider cart, ThemeData theme) {
    const double shippingFee = 5.00;
    final double total = cart.totalPrice + shippingFee;

    return Card(
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _priceRow('Subtotal', '\$${cart.totalPrice.toStringAsFixed(2)}'),
            const SizedBox(height: 8),
            _priceRow('Shipping', '\$${shippingFee.toStringAsFixed(2)}'),
            const Divider(height: 24),
            _priceRow('Total', '\$${total.toStringAsFixed(2)}', isTotal: true, theme: theme),
          ],
        ),
      ),
    );
  }

  Widget _priceRow(String label, String value, {bool isTotal = false, ThemeData? theme}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 16, color: isTotal ? theme!.colorScheme.primary : Colors.grey[700], fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
        Text(value, style: TextStyle(fontSize: 16, color: isTotal ? theme!.colorScheme.primary : Colors.black87, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildBottomBar(CartProvider cart, ThemeData theme) {
    const double shippingFee = 5.00;
    final double total = cart.totalPrice + shippingFee;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: cart.items.isEmpty || _isPlacingOrder ? null : _placeOrder,
        child: _isPlacingOrder
            ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
            : Text('Place Order for \$${total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class AnimatedListItem extends StatefulWidget {
  final int index;
  final Widget child;
  const AnimatedListItem({super.key, required this.index, required this.child});

  @override
  State<AnimatedListItem> createState() => _AnimatedListItemState();
}

class _AnimatedListItemState extends State<AnimatedListItem> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.decelerate),
    );

    Future.delayed(Duration(milliseconds: widget.index * 100), () {
      if(mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: widget.child,
      ),
    );
  }
}