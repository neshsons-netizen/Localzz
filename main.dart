
import 'package:flutter/material.dart';

void main() => runApp(const LocalzApp());

class Product {
  final String name, unit, emoji;
  final double price;
  Product(this.name, this.unit, this.emoji, this.price);
}

final products = <Product>[
  Product('Fresh Bananas', '1 kg', '🍌', 49),
  Product('Amul Taaza Milk', '1 L', '🥛', 62),
  Product('Aashirvaad Atta', '5 kg', '🌾', 289),
  Product('Lay’s Classic', '50 g', '🥔', 20),
  Product('Tata Salt', '1 kg', '🧂', 28),
  Product('Coca-Cola', '750 ml', '🥤', 45),
  Product('Fresh Tomatoes', '1 kg', '🍅', 55),
  Product('Fortune Oil', '1 L', '🫗', 139),
];

class LocalzApp extends StatelessWidget {
  const LocalzApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Localz',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF16A34A)),
        scaffoldBackgroundColor: const Color(0xFFF7FAF7),
        fontFamily: 'sans',
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override State<SplashScreen> createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {
  @override void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeShell()));
    });
  }
  @override Widget build(BuildContext context) => Scaffold(
    body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(width: 86, height: 86, decoration: BoxDecoration(color: const Color(0xFF16A34A), borderRadius: BorderRadius.circular(26)),
        child: const Icon(Icons.local_mall_rounded, color: Colors.white, size: 48)),
      const SizedBox(height: 18),
      const Text('LOCALZ', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900, letterSpacing: 2)),
      const SizedBox(height: 5),
      const Text('Your local. Delivered fast.', style: TextStyle(color: Colors.black54)),
    ]));
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});
  @override State<HomeShell> createState() => _HomeShellState();
}
class _HomeShellState extends State<HomeShell> {
  int tab = 0;
  final cart = <Product>[];
  void add(Product p) => setState(() => cart.add(p));
  @override Widget build(BuildContext context) {
    final pages = [
      HomePage(cart: cart, add: add),
      ExplorePage(cart: cart, add: add),
      CartPage(cart: cart, onRemove: (p) => setState(() => cart.remove(p)), onCheckout: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CheckoutPage(cart: cart)))),
      const OrdersPage(),
      const AccountPage(),
    ];
    return Scaffold(
      body: pages[tab],
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        onDestinationSelected: (i) => setState(() => tab = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.grid_view_outlined), selectedIcon: Icon(Icons.grid_view), label: 'Explore'),
          NavigationDestination(icon: Icon(Icons.shopping_cart_outlined), selectedIcon: Icon(Icons.shopping_cart), label: 'Cart'),
          NavigationDestination(icon: Icon(Icons.receipt_long_outlined), selectedIcon: Icon(Icons.receipt_long), label: 'Orders'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Account'),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final List<Product> cart; final void Function(Product) add;
  const HomePage({super.key, required this.cart, required this.add});
  @override Widget build(BuildContext context) => SafeArea(child: ListView(padding: const EdgeInsets.all(16), children: [
    Row(children: [
      const Icon(Icons.location_on, color: Color(0xFF16A34A)),
      const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Deliver to', style: TextStyle(fontSize: 12, color: Colors.black54)),
        Text('Your current location', style: TextStyle(fontWeight: FontWeight.bold))
      ])),
      CircleAvatar(backgroundColor: Colors.white, child: IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none)))
    ]),
    const SizedBox(height: 14),
    TextField(decoration: InputDecoration(hintText: 'Search groceries, snacks, daily needs', prefixIcon: const Icon(Icons.search), filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none))),
    const SizedBox(height: 16),
    Container(height: 145, padding: const EdgeInsets.all(20), decoration: BoxDecoration(borderRadius: BorderRadius.circular(24), color: const Color(0xFFDCFCE7)), child: Row(children: [
      const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
        Text('Fresh essentials', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
        SizedBox(height: 5), Text('Fast delivery from local stores'), SizedBox(height: 12),
        Text('SHOP NOW →', style: TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF15803D)))
      ]),
      const Text('🛒', style: TextStyle(fontSize: 65))
    ])),
    const SizedBox(height: 20),
    const Text('Shop by category', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
    const SizedBox(height: 12),
    SizedBox(height: 92, child: ListView(scrollDirection: Axis.horizontal, children: ['🥦 Groceries','🥛 Dairy','🍪 Snacks','🥤 Drinks','🧴 Care','🏠 Home'].map((x) => Container(width: 90, margin: const EdgeInsets.only(right: 10), padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)), child: Center(child: Text(x, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)))).toList())),
    const SizedBox(height: 20),
    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Popular near you', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)), TextButton(onPressed: () {}, child: const Text('See all'))]),
    GridView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: 6, gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: .76, crossAxisSpacing: 12, mainAxisSpacing: 12), itemBuilder: (_, i) => ProductCard(product: products[i], add: add)),
  ]));
}

class ExplorePage extends StatelessWidget {
  final List<Product> cart; final void Function(Product) add;
  const ExplorePage({super.key, required this.cart, required this.add});
  @override Widget build(BuildContext context) => SafeArea(child: ListView(padding: const EdgeInsets.all(16), children: [
    const Text('Explore', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900)),
    const SizedBox(height: 12),
    TextField(decoration: InputDecoration(hintText: 'Search products', prefixIcon: const Icon(Icons.search), filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none))),
    const SizedBox(height: 18),
    const Text('All products', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
    const SizedBox(height: 10),
    GridView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: products.length, gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: .76, crossAxisSpacing: 12, mainAxisSpacing: 12), itemBuilder: (_, i) => ProductCard(product: products[i], add: add)),
  ]));
}

class ProductCard extends StatelessWidget {
  final Product product; final void Function(Product) add;
  const ProductCard({super.key, required this.product, required this.add});
  @override Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Expanded(child: Center(child: Text(product.emoji, style: const TextStyle(fontSize: 70)))),
    Text(product.name, maxLines: 2, style: const TextStyle(fontWeight: FontWeight.w800)),
    Text(product.unit, style: const TextStyle(color: Colors.black54, fontSize: 12)),
    const SizedBox(height: 6),
    Row(children: [Text('₹${product.price.toStringAsFixed(0)}', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900)), const Spacer(), FilledButton(onPressed: () { add(product); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Added to cart'))); }, child: const Text('ADD'))])
  ]));
}

class CartPage extends StatelessWidget {
  final List<Product> cart; final void Function(Product) onRemove; final VoidCallback onCheckout;
  const CartPage({super.key, required this.cart, required this.onRemove, required this.onCheckout});
  @override Widget build(BuildContext context) {
    final total = cart.fold<double>(0, (s,p) => s+p.price);
    return SafeArea(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Your Cart', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900)),
      const SizedBox(height: 15),
      if (cart.isEmpty) const Expanded(child: Center(child: Text('Your cart is empty', style: TextStyle(fontSize: 18))))
      else Expanded(child: ListView(children: cart.map((p) => Card(child: ListTile(leading: Text(p.emoji, style: const TextStyle(fontSize: 32)), title: Text(p.name), subtitle: Text(p.unit), trailing: Row(mainAxisSize: MainAxisSize.min, children: [Text('₹${p.price.toStringAsFixed(0)}'), IconButton(onPressed: () => onRemove(p), icon: const Icon(Icons.delete_outline))]))).toList())),
      if (cart.isNotEmpty) Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)), child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Total', style: TextStyle(fontWeight: FontWeight.bold)), Text('₹${total.toStringAsFixed(0)}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900))]),
        const SizedBox(height: 12), SizedBox(width: double.infinity, child: FilledButton(onPressed: onCheckout, child: const Text('Proceed to checkout')))
      ]))
    ])));
  }
}

class CheckoutPage extends StatelessWidget {
  final List<Product> cart;
  const CheckoutPage({super.key, required this.cart});
  @override Widget build(BuildContext context) {
    final total = cart.fold<double>(0, (s,p) => s+p.price);
    return Scaffold(appBar: AppBar(title: const Text('Checkout')), body: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
      Card(child: const ListTile(leading: Icon(Icons.location_on, color: Color(0xFF16A34A)), title: Text('Delivery address'), subtitle: Text('Add your home address'))),
      const SizedBox(height: 10), Card(child: const Column(children: [ListTile(leading: Icon(Icons.payments_outlined), title: Text('Cash on Delivery')), ListTile(leading: Icon(Icons.account_balance_wallet_outlined), title: Text('Online payment'))])),
      const Spacer(), Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Payable', style: TextStyle(fontWeight: FontWeight.bold)), Text('₹${total.toStringAsFixed(0)}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900))]),
      const SizedBox(height: 12), SizedBox(width: double.infinity, child: FilledButton(onPressed: () => showDialog(context: context, builder: (_) => AlertDialog(title: const Text('Order placed 🎉'), content: const Text('Your Localz order has been placed successfully.'), actions: [TextButton(onPressed: () { Navigator.pop(context); Navigator.pop(context); }, child: const Text('Done'))])), child: const Text('Place order')))
    ])));
  }
}

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});
  @override Widget build(BuildContext context) => SafeArea(child: ListView(padding: const EdgeInsets.all(16), children: [
    const Text('Orders', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900)), const SizedBox(height: 16),
    Card(child: ListTile(leading: const CircleAvatar(child: Text('🛒')), title: const Text('Localz order'), subtitle: const Text('Delivered • ₹289'), trailing: const Icon(Icons.chevron_right)))
  ]));
}

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});
  @override Widget build(BuildContext context) => SafeArea(child: ListView(padding: const EdgeInsets.all(16), children: [
    const Text('Account', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900)), const SizedBox(height: 18),
    const CircleAvatar(radius: 38, child: Icon(Icons.person, size: 42)), const SizedBox(height: 10),
    const Center(child: Text('Welcome to Localz', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800))),
    const SizedBox(height: 20),
    ...['My addresses','Payment methods','Notifications','Help & support','About Localz'].map((x) => Card(child: ListTile(title: Text(x), trailing: const Icon(Icons.chevron_right))))
  ]));
}
