import 'package:flutter/material.dart';

void main() {
  runApp(const LocalzApp());
}

class LocalzApp extends StatelessWidget {
  const LocalzApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Localz',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF16A34A),
        ),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          centerTitle: false,
        ),
      ),
      home: const MainShell(),
    );
  }
}

class Product {
  final String name;
  final String unit;
  final double price;
  final String emoji;

  const Product({
    required this.name,
    required this.unit,
    required this.price,
    required this.emoji,
  });
}

const products = <Product>[
  Product(
    name: 'Fresh Bananas',
    unit: '1 kg',
    price: 49,
    emoji: '🍌',
  ),
  Product(
    name: 'Amul Taaza Milk',
    unit: '1 L',
    price: 62,
    emoji: '🥛',
  ),
  Product(
    name: 'Aashirvaad Atta',
    unit: '5 kg',
    price: 299,
    emoji: '🌾',
  ),
  Product(
    name: "Lay's Classic",
    unit: '50 g',
    price: 20,
    emoji: '🥔',
  ),
  Product(
    name: 'Tata Salt',
    unit: '1 kg',
    price: 28,
    emoji: '🧂',
  ),
  Product(
    name: 'Coca-Cola',
    unit: '750 ml',
    price: 45,
    emoji: '🥤',
  ),
  Product(
    name: 'Fresh Apples',
    unit: '1 kg',
    price: 129,
    emoji: '🍎',
  ),
  Product(
    name: 'Brown Bread',
    unit: '400 g',
    price: 45,
    emoji: '🍞',
  ),
];

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int index = 0;

  final Map<String, int> cart = <String, int>{};

  int get cartCount {
    return cart.values.fold(
      0,
      (int total, int quantity) => total + quantity,
    );
  }

  void add(Product product) {
    setState(() {
      cart[product.name] = (cart[product.name] ?? 0) + 1;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} added to cart'),
        duration: const Duration(milliseconds: 800),
      ),
    );
  }

  void openCart() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => CartPage(
          cart: cart,
          onChanged: () {
            setState(() {});
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = <Widget>[
      HomePage(
        onAdd: add,
        onCart: openCart,
      ),
      ExplorePage(
        onAdd: add,
      ),
      const OrdersPage(),
      const AccountPage(),
    ];

    return Scaffold(
      body: pages[index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (int value) {
          setState(() {
            index = value;
          });
        },
        destinations: <NavigationDestination>[
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          const NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: cartCount > 0,
              label: Text('$cartCount'),
              child: const Icon(Icons.receipt_long_outlined),
            ),
            selectedIcon: Badge(
              isLabelVisible: cartCount > 0,
              label: Text('$cartCount'),
              child: const Icon(Icons.receipt_long),
            ),
            label: 'Orders',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final void Function(Product) onAdd;
  final VoidCallback onCart;

  const HomePage({
    super.key,
    required this.onAdd,
    required this.onCart,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 10),
              child: Row(
                children: <Widget>[
                  const Icon(
                    Icons.location_on,
                    color: Color(0xFF16A34A),
                  ),
                  const SizedBox(width: 6),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Deliver to',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          'Your location',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: onCart,
                    icon: const Icon(
                      Icons.shopping_cart_outlined,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search groceries, snacks and more',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(18),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: const Color(0xFFE9F8EE),
              ),
              child: const Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'FAST DELIVERY',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Groceries at your door in minutes',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Fresh products from local stores.',
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '🛵',
                    style: TextStyle(fontSize: 58),
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(
            child: SectionTitle(
              title: 'Categories',
            ),
          ),

          SliverToBoxAdapter(
            child: SizedBox(
              height: 105,
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18),
                scrollDirection: Axis.horizontal,
                children: const <Widget>[
                  CategoryTile(
                    icon: '🥦',
                    label: 'Fruits & Veg',
                  ),
                  CategoryTile(
                    icon: '🥛',
                    label: 'Dairy',
                  ),
                  CategoryTile(
                    icon: '🍪',
                    label: 'Snacks',
                  ),
                  CategoryTile(
                    icon: '🧹',
                    label: 'Home Care',
                  ),
                  CategoryTile(
                    icon: '🧴',
                    label: 'Personal Care',
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(
            child: SectionTitle(
              title: 'Popular near you',
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              18,
              0,
              18,
              24,
            ),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int i) {
                  return ProductCard(
                    product: products[i],
                    onAdd: () => onAdd(products[i]),
                  );
                },
                childCount: products.length,
              ),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.72,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        18,
        8,
        18,
        12,
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  final String icon;
  final String label;

  const CategoryTile({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 86,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: <Widget>[
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            alignment: Alignment.center,
            child: Text(
              icon,
              style: const TextStyle(fontSize: 30),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onAdd;

  const ProductCard({
    super.key,
    required this.product,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: Colors.grey.shade200,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: Text(
                  product.emoji,
                  style: const TextStyle(fontSize: 56),
                ),
              ),
            ),

            const SizedBox(height: 10),

            Text(
              product.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 3),

            Text(
              product.unit,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),

            const SizedBox(height: 8),

            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    '₹${product.price.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                ),
                FilledButton(
                  onPressed: onAdd,
                  child: const Text('ADD'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ExplorePage extends StatelessWidget {
  final void Function(Product) onAdd;

  const ExplorePage({
    super.key,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(18),
        children: <Widget>[
          const Text(
            'Explore',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 16),

          TextField(
            decoration: InputDecoration(
              hintText: 'Search products',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 18),

          ...products.map(
            (Product p) {
              return ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 5),
                leading: CircleAvatar(
                  radius: 28,
                  child: Text(
                    p.emoji,
                    style: const TextStyle(fontSize: 25),
                  ),
                ),
                title: Text(
                  p.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                subtitle: Text(p.unit),
                trailing: FilledButton(
                  onPressed: () => onAdd(p),
                  child: const Text('ADD'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class CartPage extends StatefulWidget {
  final Map<String, int> cart;
  final VoidCallback onChanged;

  const CartPage({
    super.key,
    required this.cart,
    required this.onChanged,
  });

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  double get total {
    double sum = 0;

    for (final MapEntry<String, int> entry
        in widget.cart.entries) {
      final Product product = products.firstWhere(
        (Product p) => p.name == entry.key,
      );

      sum += product.price * entry.value;
    }

    return sum;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: widget.cart.isEmpty
          ? const Center(
              child: Text('Your cart is empty'),
            )
          : Column(
              children: <Widget>[
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(18),
                    children: widget.cart.entries.map(
                      (MapEntry<String, int> entry) {
                        final Product p = products.firstWhere(
                          (Product x) => x.name == entry.key,
                        );

                        return Card(
                          child: ListTile(
                            leading: Text(
                              p.emoji,
                              style:
                                  const TextStyle(fontSize: 32),
                            ),
                            title: Text(p.name),
                            subtitle: Text(
                              '₹${p.price.toStringAsFixed(0)} × ${entry.value}',
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.remove_circle_outline,
                              ),
                              onPressed: () {
                                setState(() {
                                  if ((widget.cart[p.name] ??
                                          0) >
                                      1) {
                                    widget.cart[p.name] =
                                        widget.cart[p.name]! - 1;
                                  } else {
                                    widget.cart.remove(p.name);
                                  }
                                });

                                widget.onChanged();
                              },
                            ),
                          ),
                        );
                      },
                    ).toList(),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Text(
                            'Total',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '₹${total.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (_) => CheckoutPage(
                                  total: total,
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            'Proceed to checkout',
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

class CheckoutPage extends StatelessWidget {
  final double total;

  const CheckoutPage({
    super.key,
    required this.total,
  });

  void placeOrder(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          'Order placed 🎉',
        ),
        content: Text(
          'Your Localz order of ₹${total.toStringAsFixed(0)} has been placed.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.popUntil(
                context,
                (Route<dynamic> route) => route.isFirst,
              );
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: <Widget>[
          const Text(
            'Delivery address',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 10),

          const Card(
            child: ListTile(
              leading: Icon(Icons.location_on),
              title: Text('Home'),
              subtitle: Text(
                'Add your delivery address',
              ),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Payment',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),

          const Card(
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.money),
                  title: Text('Cash on Delivery'),
                  trailing: Icon(
                    Icons.radio_button_checked,
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.account_balance_wallet_outlined,
                  ),
                  title: Text('Online payment'),
                  trailing: Icon(
                    Icons.radio_button_off,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text(
                'Total',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '₹${total.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => placeOrder(context),
              child: const Text('Place order'),
            ),
          ),
        ],
      ),
    );
  }
}

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(18),
        children: <Widget>[
          const Text(
            'Orders',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 18),

          Card(
            child: ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.check),
              ),
              title: const Text('Sample order'),
              subtitle: const Text(
                'Delivered • ₹0',
              ),
              trailing: const Icon(
                Icons.chevron_right,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(18),
        children: <Widget>[
          const Text(
            'Account',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 18),

          const CircleAvatar(
            radius: 38,
            child: Icon(
              Icons.person,
              size: 42,
            ),
          ),

          const SizedBox(height: 10),

          const Center(
            child: Text(
              'Welcome to Localz',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),

          const SizedBox(height: 20),

          Card(
            child: ListTile(
              leading: const Icon(
                Icons.location_on_outlined,
              ),
              title: const Text('Addresses'),
              trailing: const Icon(
                Icons.chevron_right,
              ),
              onTap: () {},
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(
                Icons.favorite_border,
              ),
              title: const Text('Wishlist'),
              trailing: const Icon(
                Icons.chevron_right,
              ),
              onTap: () {},
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(
                Icons.help_outline,
              ),
              title: const Text('Help & Support'),
              trailing: const Icon(
                Icons.chevron_right,
              ),
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}
