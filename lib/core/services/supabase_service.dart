import 'package:supabase_flutter/supabase_flutter.dart';
import '../../config/supabase_config.dart';
import '../../data/models/user_profile.dart';
import '../../data/models/coupon.dart';
import '../../data/models/order.dart';
import '../../data/models/invoice.dart';
import '../../data/models/return_model.dart';
import '../../data/models/cart_item.dart';
import '../../data/models/category.dart';
import '../../data/models/product.dart';
import '../../data/models/shipping_address.dart';
import '../../data/models/shipping_method.dart';
import '../../data/models/wishlist_item.dart';

/// Servicio principal de Supabase
/// Proporciona acceso centralizado a todas las operaciones de base de datos
class SupabaseService {
  SupabaseService._();

  static final SupabaseService _instance = SupabaseService._();
  static SupabaseService get instance => _instance;

  /// Cliente de Supabase
  SupabaseClient get client => SupabaseConfig.client;

  /// Cliente de autenticación
  GoTrueClient get auth => client.auth;

  // ============================================
  // AUTENTICACIÓN
  // ============================================

  /// Registra un nuevo usuario
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    String? fullName,
    String? phone,
  }) async {
    return await auth.signUp(
      email: email,
      password: password,
      data: {
        if (fullName != null) 'name': fullName,
        if (fullName != null) 'full_name': fullName,
        if (phone != null) 'phone': phone,
      },
    );
  }

  /// Inicia sesión con email y contraseña
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  /// Cierra sesión
  Future<void> signOut() async {
    await auth.signOut();
  }

  /// Envía email de recuperación de contraseña
  Future<void> resetPassword(String email) async {
    await auth.resetPasswordForEmail(email);
  }

  /// Actualiza la contraseña del usuario
  Future<UserResponse> updatePassword(String newPassword) async {
    return await auth.updateUser(
      UserAttributes(password: newPassword),
    );
  }

  /// Actualiza los datos del usuario
  Future<UserResponse> updateUser({
    String? name,
    String? phone,
    String? avatarUrl,
  }) async {
    final data = <String, dynamic>{};
    if (name != null) {
      data['name'] = name;
      data['full_name'] = name;
    }
    if (phone != null) data['phone'] = phone;
    if (avatarUrl != null) data['avatar_url'] = avatarUrl;

    return await auth.updateUser(
      UserAttributes(data: data),
    );
  }

  /// Usuario actual
  User? get currentUser => auth.currentUser;

  /// Verifica si hay un usuario autenticado
  bool get isAuthenticated => currentUser != null;

  /// Stream de cambios de autenticación
  Stream<AuthState> get authStateChanges => auth.onAuthStateChange;

  // ============================================
  // PRODUCTOS
  // ============================================

  /// Obtiene todos los productos con filtros y paginación
  Future<Map<String, dynamic>> getProducts({
    int page = 1,
    int limit = 12,
    String? categoryId,
    String? sortBy,
    bool? onSale,
    bool? featured,
    int? minPrice,
    int? maxPrice,
    List<String>? sizes,
    String? searchQuery,
    String? status,
  }) async {
    var query = client.from('products').select('''
      *,
      categories(name, slug),
      product_sizes(*)
    ''');

    if (status != null) {
      query = query.eq('status', status);
    }

    if (categoryId != null) {
      final id = int.tryParse(categoryId);
      if (id != null) {
        query = query.eq('category_id', id);
      }
    }

    if (onSale == true) {
      query = query.eq('is_on_sale', true);
    }

    if (featured == true) {
      query = query.eq('featured', true);
    }

    if (minPrice != null) {
      query = query.gte('price', minPrice);
    }
    if (maxPrice != null) {
      query = query.lte('price', maxPrice);
    }

    if (searchQuery != null && searchQuery.isNotEmpty) {
      query = query.ilike('name', '%$searchQuery%');
    }

    PostgrestTransformBuilder<PostgrestList> transformedQuery = query;

    switch (sortBy) {
      case 'price_asc':
        transformedQuery = transformedQuery.order('price', ascending: true);
        break;
      case 'price_desc':
        transformedQuery = transformedQuery.order('price', ascending: false);
        break;
      case 'newest':
        transformedQuery =
            transformedQuery.order('created_at', ascending: false);
        break;
      case 'oldest':
        transformedQuery =
            transformedQuery.order('created_at', ascending: true);
        break;
      default:
        transformedQuery =
            transformedQuery.order('created_at', ascending: false);
        break;
    }

    final from = (page - 1) * limit;
    final to = from + limit - 1;

    transformedQuery = transformedQuery.range(from, to);

    final response = await transformedQuery;
    final products = List<Map<String, dynamic>>.from(response)
        .map((e) => Product.fromJson(e))
        .toList();

    return {
      'products': products,
      'total': products.length,
      'hasMore': products.length == limit,
    };
  }

  // ============================================
  // PERFIL DE USUARIO
  // ============================================

  /// Obtiene el perfil de un usuario
  Future<UserProfile?> getUserProfile(String userId) async {
    final response =
        await client.from('profiles').select().eq('id', userId).maybeSingle();

    if (response != null) {
      return UserProfile.fromJson(response);
    }

    final user = currentUser;
    if (user == null) return null;
    return UserProfile.fromAuthUser(user.toJson());
  }

  /// Actualiza el perfil del usuario
  Future<void> updateUserProfile({
    required String userId,
    required String fullName,
    String? phone,
    String? avatarUrl,
  }) async {
    await updateUser(
      name: fullName,
      phone: phone,
      avatarUrl: avatarUrl,
    );

    await client.from('profiles').upsert({
      'id': userId,
      'email': currentUser?.email,
      'name': fullName,
      'phone': phone,
      'avatar_url': avatarUrl,
      'updated_at': DateTime.now().toIso8601String(),
    });
  }

  /// Obtiene datos del usuario admin
  Future<AdminUser?> getAdminUser(String email) async {
    final response = await client
        .from('admin_users')
        .select()
        .eq('email', email)
        .maybeSingle();

    if (response == null) return null;
    return AdminUser.fromJson(response);
  }

  // ============================================
  // STOCK
  // ============================================

  /// Verifica stock de un producto por talla
  Future<bool> checkProductStock(
    int productId,
    String size,
    int quantity,
  ) async {
    final sizeRow = await client
        .from('product_sizes')
        .select('stock')
        .eq('product_id', productId)
        .eq('size', size)
        .maybeSingle();

    if (sizeRow != null) {
      final stock = sizeRow['stock'] as int? ?? 0;
      return stock >= quantity;
    }

    final productRow = await client
        .from('products')
        .select('stock')
        .eq('id', productId)
        .maybeSingle();

    final stock = productRow?['stock'] as int? ?? 0;
    return stock >= quantity;
  }

  /// Obtiene un producto por ID
  Future<Product?> getProductById(String id) async {
    final productId = int.tryParse(id);
    if (productId == null) return null;

    final response = await client.from('products').select('''
      *,
      categories(name, slug),
      product_sizes(*)
    ''').eq('id', productId).maybeSingle();

    if (response == null) return null;
    return Product.fromJson(response);
  }

  /// Obtiene un producto por slug
  Future<Product?> getProductBySlug(String slug) async {
    final response = await client.from('products').select('''
      *,
      categories(name, slug),
      product_sizes(*)
    ''').eq('slug', slug).maybeSingle();

    if (response == null) return null;
    return Product.fromJson(response);
  }

  /// Obtiene productos destacados
  Future<List<Product>> getFeaturedProducts({int limit = 8}) async {
    final response = await client
        .from('products')
        .select('''
      *,
      categories(name, slug),
      product_sizes(*)
    ''')
        .eq('featured', true)
        .order('created_at', ascending: false)
        .limit(limit);

    return List<Map<String, dynamic>>.from(response)
        .map((e) => Product.fromJson(e))
        .toList();
  }

  /// Obtiene productos en oferta
  Future<List<Product>> getSaleProducts({int limit = 8}) async {
    final response = await client
        .from('products')
        .select('''
      *,
      categories(name, slug),
      product_sizes(*)
    ''')
        .eq('is_on_sale', true)
        .order('created_at', ascending: false)
        .limit(limit);

    return List<Map<String, dynamic>>.from(response)
        .map((e) => Product.fromJson(e))
        .toList();
  }

  /// Obtiene productos nuevos
  Future<List<Product>> getNewProducts({int limit = 8}) async {
    final response = await client.from('products').select('''
      *,
      categories(name, slug),
      product_sizes(*)
    ''').order('created_at', ascending: false).limit(limit);

    return List<Map<String, dynamic>>.from(response)
        .map((e) => Product.fromJson(e))
        .toList();
  }

  /// Obtiene productos por categoría
  Future<List<Product>> getProductsByCategory(
    String categoryId, {
    int limit = 20,
  }) async {
    final id = int.tryParse(categoryId);
    if (id == null) return [];

    final response = await client
        .from('products')
        .select('''
      *,
      categories(name, slug),
      product_sizes(*)
    ''')
        .eq('category_id', id)
        .order('created_at', ascending: false)
        .limit(limit);

    return List<Map<String, dynamic>>.from(response)
        .map((e) => Product.fromJson(e))
        .toList();
  }

  /// Obtiene productos relacionados (misma categoría)
  Future<List<Product>> getRelatedProducts(
    String productId, {
    int limit = 4,
  }) async {
    final id = int.tryParse(productId);
    if (id == null) return [];

    final product = await getProductById(productId);
    if (product == null || product.categoryId == null) return [];

    final response = await client.from('products').select('''
      *,
      categories(name, slug),
      product_sizes(*)
    ''').eq('category_id', product.categoryId!).neq('id', id).limit(limit);

    return List<Map<String, dynamic>>.from(response)
        .map((e) => Product.fromJson(e))
        .toList();
  }

  /// Busca productos
  Future<List<Product>> searchProducts(String query, {int limit = 20}) async {
    final response = await client
        .from('products')
        .select('''
      *,
      categories(name, slug),
      product_sizes(*)
    ''')
        .ilike('name', '%$query%')
        .order('created_at', ascending: false)
        .limit(limit);

    return List<Map<String, dynamic>>.from(response)
        .map((e) => Product.fromJson(e))
        .toList();
  }

  /// Crea un nuevo producto
  Future<Product?> createProduct(Product product) async {
    final response = await client
        .from('products')
        .insert(product.toJson())
        .select()
        .single();

    return Product.fromJson(response);
  }

  /// Actualiza un producto
  Future<Product?> updateProduct(Product product) async {
    final response = await client
        .from('products')
        .update(product.toJson())
        .eq('id', product.id)
        .select()
        .single();

    return Product.fromJson(response);
  }

  /// Elimina un producto
  Future<void> deleteProduct(String id) async {
    final productId = int.tryParse(id);
    if (productId == null) return;
    await client.from('products').delete().eq('id', productId);
  }

  /// Actualiza el stock de un producto por talla
  Future<void> updateProductStock(
    String productId,
    String size,
    int newStock,
  ) async {
    final id = int.tryParse(productId);
    if (id == null) return;

    await client
        .from('product_sizes')
        .update({'stock': newStock})
        .eq('product_id', id)
        .eq('size', size);
  }

  // ============================================
  // CATEGORÍAS
  // ============================================

  /// Obtiene todas las categorías
  Future<List<Category>> getCategories() async {
    final response =
        await client.from('categories').select().order('name', ascending: true);

    return List<Map<String, dynamic>>.from(response)
        .map((e) => Category.fromJson(e))
        .toList();
  }

  /// Obtiene una categoría por slug
  Future<Category?> getCategoryBySlug(String slug) async {
    final response =
        await client.from('categories').select().eq('slug', slug).maybeSingle();

    if (response == null) return null;
    return Category.fromJson(response);
  }

  /// Obtiene una categoría por ID
  Future<Category?> getCategoryById(String id) async {
    final categoryId = int.tryParse(id);
    if (categoryId == null) return null;

    final response = await client
        .from('categories')
        .select()
        .eq('id', categoryId)
        .maybeSingle();

    if (response == null) return null;
    return Category.fromJson(response);
  }

  /// Crea una nueva categoría
  Future<Category?> createCategory(Category category) async {
    final response = await client
        .from('categories')
        .insert(category.toJson())
        .select()
        .single();

    return Category.fromJson(response);
  }

  /// Actualiza una categoría
  Future<Category?> updateCategory(Category category) async {
    final response = await client
        .from('categories')
        .update(category.toJson())
        .eq('id', category.id)
        .select()
        .single();

    return Category.fromJson(response);
  }

  /// Elimina una categoría
  Future<void> deleteCategory(String id) async {
    final categoryId = int.tryParse(id);
    if (categoryId == null) return;
    await client.from('categories').delete().eq('id', categoryId);
  }

  // ============================================
  // PEDIDOS
  // ============================================

  /// Crea un nuevo pedido
  Future<Order?> createOrder({
    required List<CartItem> items,
    required int shippingAddressId,
    required int shippingMethodId,
    int? couponId,
    required int subtotal,
    required int shippingCost,
    required int discount,
    required int taxAmount,
    required int total,
    String? notes,
  }) async {
    final user = currentUser;
    if (user == null) return null;

    final address = await client
        .from('user_shipping_addresses')
        .select()
        .eq('id', shippingAddressId)
        .maybeSingle();

    if (address == null) return null;

    final orderData = <String, dynamic>{
      'customer_email': user.email ?? '',
      'customer_name': address['full_name'] as String? ?? '',
      'customer_address': address['address'] as String? ?? '',
      'customer_city': address['city'] as String? ?? '',
      'customer_postal_code': address['postal_code'] as String? ?? '',
      'customer_phone': address['phone'] as String?,
      'status': 'pending',
      'subtotal': subtotal,
      'shipping_cost': shippingCost,
      'discount': discount,
      'tax_amount': taxAmount,
      'total': total,
      'shipping_method_id': shippingMethodId,
      if (couponId != null) 'coupon_id': couponId,
      if (notes != null && notes.isNotEmpty) 'notes': notes,
    };

    final createdOrder =
        await client.from('orders').insert(orderData).select().single();

    final orderId = createdOrder['id'] as int;

    final orderItems = items
        .map((item) => {
              'order_id': orderId,
              'product_id': item.productId,
              'product_name': item.productName,
              'product_price': item.currentPrice,
              'quantity': item.quantity,
              'size': item.size,
            })
        .toList();

    if (orderItems.isNotEmpty) {
      await client.from('order_items').insert(orderItems);
    }

    final orderWithItems = await client.from('orders').select('''
      *,
      order_items(*),
      shipping_carriers(name, code, tracking_url_template)
    ''').eq('id', orderId).maybeSingle();

    if (orderWithItems == null) return null;
    return Order.fromJson(orderWithItems);
  }

  /// Crea los items de un pedido
  Future<void> createOrderItems(List<Map<String, dynamic>> items) async {
    await client.from('order_items').insert(items);
  }

  /// Obtiene los pedidos del usuario actual
  Future<List<Order>> getUserOrders({int limit = 20}) async {
    final email = currentUser?.email;
    if (email == null || email.isEmpty) return [];

    final response = await client
        .from('orders')
        .select('''
          *,
          order_items(*),
          shipping_carriers(name, code, tracking_url_template)
        ''')
        .eq('customer_email', email)
        .order('created_at', ascending: false)
        .limit(limit);

    return List<Map<String, dynamic>>.from(response)
        .map((e) => Order.fromJson(e))
        .toList();
  }

  /// Obtiene un pedido por ID
  Future<Order?> getOrderById(String id) async {
    final orderId = int.tryParse(id);
    if (orderId == null) return null;

    final response = await client.from('orders').select('''
      *,
      order_items(*),
      shipping_carriers(name, code, tracking_url_template)
    ''').eq('id', orderId).maybeSingle();

    if (response == null) return null;
    return Order.fromJson(response);
  }

  /// Obtiene un pedido por número
  Future<Order?> getOrderByNumber(String orderNumber) async {
    final response = await client.from('orders').select('''
      *,
      order_items(*),
      shipping_carriers(name, code, tracking_url_template)
    ''').eq('order_number', orderNumber).maybeSingle();

    if (response == null) return null;
    return Order.fromJson(response);
  }

  /// Actualiza el estado de un pedido
  Future<void> updateOrderStatus(
    String orderId,
    String status, {
    String? trackingNumber,
    int? carrierId,
  }) async {
    final parsedId = int.tryParse(orderId);
    if (parsedId == null) return;

    final data = <String, dynamic>{
      'status': status,
      'updated_at': DateTime.now().toIso8601String(),
    };

    if (trackingNumber != null) data['tracking_number'] = trackingNumber;
    if (carrierId != null) data['carrier_id'] = carrierId;

    await client.from('orders').update(data).eq('id', parsedId);
  }

  /// Actualiza el estado del pago de un pedido
  Future<void> updateOrderPaymentStatus(
    String orderId,
    String paymentStatus,
    String? paymentIntentId,
  ) async {
    final parsedId = int.tryParse(orderId);
    if (parsedId == null) return;

    final data = <String, dynamic>{
      'payment_status': paymentStatus,
      if (paymentIntentId != null) 'stripe_payment_intent_id': paymentIntentId,
      'updated_at': DateTime.now().toIso8601String(),
    };

    await client.from('orders').update(data).eq('id', parsedId);
  }

  /// Actualiza tracking de un pedido
  Future<void> updateOrderTracking(
    String orderId,
    String trackingNumber,
    String? trackingUrl,
  ) async {
    final parsedId = int.tryParse(orderId);
    if (parsedId == null) return;

    final data = <String, dynamic>{
      'tracking_number': trackingNumber,
      if (trackingUrl != null) 'tracking_url': trackingUrl,
      'updated_at': DateTime.now().toIso8601String(),
    };

    await client.from('orders').update(data).eq('id', parsedId);
  }

  /// Obtiene todos los pedidos (Admin)
  Future<Map<String, dynamic>> getAllOrders({
    int page = 1,
    int limit = 20,
    String? status,
    String? searchQuery,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    var query = client.from('orders').select('''
      *,
      order_items(*),
      shipping_carriers(name, code, tracking_url_template)
    ''');

    if (status != null && status.isNotEmpty) {
      query = query.eq('status', status);
    }

    if (searchQuery != null && searchQuery.isNotEmpty) {
      query = query.ilike('customer_email', '%$searchQuery%');
    }

    if (startDate != null) {
      query = query.gte('created_at', startDate.toIso8601String());
    }
    if (endDate != null) {
      query = query.lte('created_at', endDate.toIso8601String());
    }

    final from = (page - 1) * limit;
    final to = from + limit - 1;

    final response =
        await query.order('created_at', ascending: false).range(from, to);

    final orders = List<Map<String, dynamic>>.from(response)
        .map((e) => Order.fromJson(e))
        .toList();

    return {
      'orders': orders,
      'total': orders.length,
      'hasMore': orders.length == limit,
    };
  }

  /// Obtiene estadísticas de pedidos (Admin)
  Future<Map<String, dynamic>> getOrderStats({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    var query = client.from('orders').select('status, total');

    if (startDate != null) {
      query = query.gte('created_at', startDate.toIso8601String());
    }
    if (endDate != null) {
      query = query.lte('created_at', endDate.toIso8601String());
    }

    final response = await query;
    final rows = List<Map<String, dynamic>>.from(response);

    final totalOrders = rows.length;
    int pending = 0;
    int processing = 0;
    int shipped = 0;
    int delivered = 0;
    int cancelled = 0;
    int totalRevenue = 0;

    for (final row in rows) {
      final status = row['status'] as String? ?? '';
      final total = row['total'] as int? ?? 0;
      switch (status) {
        case 'pending':
          pending++;
          break;
        case 'processing':
          processing++;
          break;
        case 'shipped':
          shipped++;
          break;
        case 'delivered':
          delivered++;
          break;
        case 'cancelled':
          cancelled++;
          break;
      }
      totalRevenue += total;
    }

    final averageOrderValue =
        totalOrders > 0 ? (totalRevenue / totalOrders).round() : 0;

    return {
      'totalOrders': totalOrders,
      'pendingOrders': pending,
      'processingOrders': processing,
      'shippedOrders': shipped,
      'deliveredOrders': delivered,
      'cancelledOrders': cancelled,
      'totalRevenue': totalRevenue,
      'averageOrderValue': averageOrderValue,
    };
  }

  // ============================================
  // CUPONES
  // ============================================

  /// Obtiene un cupón por código
  Future<Coupon?> getCouponByCode(String code) async {
    final response = await client
        .from('coupons')
        .select()
        .eq('code', code.toUpperCase())
        .maybeSingle();

    if (response == null) return null;
    return Coupon.fromJson(response);
  }

  /// Incrementa el contador de uso de un cupón
  Future<void> incrementCouponUsage(String couponId) async {
    final id = int.tryParse(couponId);
    if (id == null) return;
    await client.rpc('increment_coupon_usage', params: {'coupon_id': id});
  }

  /// Obtiene todos los cupones
  Future<List<Coupon>> getAllCoupons() async {
    final response = await client
        .from('coupons')
        .select()
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response)
        .map((e) => Coupon.fromJson(e))
        .toList();
  }

  /// Obtiene cupones activos
  Future<List<Coupon>> getActiveCoupons() async {
    final response = await client
        .from('coupons')
        .select()
        .eq('is_active', true)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response)
        .map((e) => Coupon.fromJson(e))
        .toList();
  }

  /// Obtiene un cupón por ID
  Future<Coupon?> getCouponById(String id) async {
    final couponId = int.tryParse(id);
    if (couponId == null) return null;

    final response =
        await client.from('coupons').select().eq('id', couponId).maybeSingle();

    if (response == null) return null;
    return Coupon.fromJson(response);
  }

  /// Crea un nuevo cupón
  Future<Coupon?> createCoupon(Coupon coupon) async {
    final response =
        await client.from('coupons').insert(coupon.toJson()).select().single();

    return Coupon.fromJson(response);
  }

  /// Actualiza un cupón
  Future<Coupon?> updateCoupon(Coupon coupon) async {
    final response = await client
        .from('coupons')
        .update(coupon.toJson())
        .eq('id', coupon.id)
        .select()
        .single();

    return Coupon.fromJson(response);
  }

  /// Elimina un cupón
  Future<void> deleteCoupon(String id) async {
    final couponId = int.tryParse(id);
    if (couponId == null) return;
    await client.from('coupons').delete().eq('id', couponId);
  }

  // ============================================
  // MÉTODOS DE ENVÍO
  // ============================================

  /// Obtiene los métodos de envío activos
  Future<List<ShippingMethod>> getShippingMethods() async {
    final response = await client
        .from('shipping_methods')
        .select()
        .eq('is_active', true)
        .order('display_order', ascending: true);

    return List<Map<String, dynamic>>.from(response)
        .map((e) => ShippingMethod.fromJson(e))
        .toList();
  }

  /// Obtiene un método de envío por ID
  Future<ShippingMethod?> getShippingMethodById(String id) async {
    final methodId = int.tryParse(id);
    if (methodId == null) return null;

    final response = await client
        .from('shipping_methods')
        .select()
        .eq('id', methodId)
        .maybeSingle();

    if (response == null) return null;
    return ShippingMethod.fromJson(response);
  }

  /// Obtiene los transportistas activos
  Future<List<ShippingCarrier>> getCarriers() async {
    final response = await client
        .from('shipping_carriers')
        .select()
        .eq('is_active', true)
        .order('display_order', ascending: true);

    return List<Map<String, dynamic>>.from(response)
        .map((e) => ShippingCarrier.fromJson(e))
        .toList();
  }

  /// Obtiene todos los métodos de envío (Admin)
  Future<List<ShippingMethod>> getAllShippingMethods() async {
    final response = await client
        .from('shipping_methods')
        .select()
        .order('display_order', ascending: true);

    return List<Map<String, dynamic>>.from(response)
        .map((e) => ShippingMethod.fromJson(e))
        .toList();
  }

  /// Crea un método de envío (Admin)
  Future<ShippingMethod?> createShippingMethod(ShippingMethod method) async {
    final response = await client
        .from('shipping_methods')
        .insert(method.toJson())
        .select()
        .single();

    return ShippingMethod.fromJson(response);
  }

  /// Actualiza un método de envío (Admin)
  Future<ShippingMethod?> updateShippingMethod(ShippingMethod method) async {
    final response = await client
        .from('shipping_methods')
        .update(method.toJson())
        .eq('id', method.id)
        .select()
        .single();

    return ShippingMethod.fromJson(response);
  }

  /// Elimina un método de envío (Admin)
  Future<void> deleteShippingMethod(String id) async {
    final methodId = int.tryParse(id);
    if (methodId == null) return;
    await client.from('shipping_methods').delete().eq('id', methodId);
  }

  /// Obtiene todos los transportistas (Admin)
  Future<List<ShippingCarrier>> getAllCarriers() async {
    final response = await client
        .from('shipping_carriers')
        .select()
        .order('display_order', ascending: true);

    return List<Map<String, dynamic>>.from(response)
        .map((e) => ShippingCarrier.fromJson(e))
        .toList();
  }

  /// Crea un transportista (Admin)
  Future<ShippingCarrier?> createCarrier(ShippingCarrier carrier) async {
    final response = await client
        .from('shipping_carriers')
        .insert(carrier.toJson())
        .select()
        .single();

    return ShippingCarrier.fromJson(response);
  }

  /// Actualiza un transportista (Admin)
  Future<ShippingCarrier?> updateCarrier(ShippingCarrier carrier) async {
    final response = await client
        .from('shipping_carriers')
        .update(carrier.toJson())
        .eq('id', carrier.id)
        .select()
        .single();

    return ShippingCarrier.fromJson(response);
  }

  /// Elimina un transportista (Admin)
  Future<void> deleteCarrier(String id) async {
    final carrierId = int.tryParse(id);
    if (carrierId == null) return;
    await client.from('shipping_carriers').delete().eq('id', carrierId);
  }

  // ============================================
  // DIRECCIONES
  // ============================================

  /// Obtiene las direcciones del usuario actual
  Future<List<ShippingAddress>> getUserAddresses() async {
    final userId = currentUser?.id;
    if (userId == null) return [];

    final response = await client
        .from('user_shipping_addresses')
        .select()
        .eq('user_id', userId)
        .order('is_default', ascending: false)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response)
        .map((e) => ShippingAddress.fromJson(e))
        .toList();
  }

  /// Obtiene una dirección por ID
  Future<ShippingAddress?> getAddressById(String id) async {
    final addressId = int.tryParse(id);
    if (addressId == null) return null;

    final response = await client
        .from('user_shipping_addresses')
        .select()
        .eq('id', addressId)
        .maybeSingle();

    if (response == null) return null;
    return ShippingAddress.fromJson(response);
  }

  /// Crea una nueva dirección
  Future<ShippingAddress?> createAddress(ShippingAddress address) async {
    final userId = currentUser?.id;
    if (userId == null) return null;

    final response = await client
        .from('user_shipping_addresses')
        .insert({
          ...address.toJson(),
          'user_id': userId,
        })
        .select()
        .single();

    return ShippingAddress.fromJson(response);
  }

  /// Actualiza una dirección
  Future<ShippingAddress?> updateAddress(ShippingAddress address) async {
    final response = await client
        .from('user_shipping_addresses')
        .update(address.toJson())
        .eq('id', address.id)
        .select()
        .single();

    return ShippingAddress.fromJson(response);
  }

  /// Elimina una dirección
  Future<void> deleteAddress(String id) async {
    final addressId = int.tryParse(id);
    if (addressId == null) return;
    await client.from('user_shipping_addresses').delete().eq('id', addressId);
  }

  /// Establece una dirección como predeterminada
  Future<void> setDefaultAddress(String addressId) async {
    final userId = currentUser?.id;
    final id = int.tryParse(addressId);
    if (userId == null || id == null) return;

    // Primero quitar el default de todas las direcciones del usuario
    await client
        .from('user_shipping_addresses')
        .update({'is_default': false}).eq('user_id', userId);

    // Luego establecer la nueva dirección como default
    await client
        .from('user_shipping_addresses')
        .update({'is_default': true}).eq('id', id);
  }

  // ============================================
  // WISHLIST
  // ============================================

  /// Obtiene la wishlist de un usuario
  Future<List<WishlistItem>> getUserWishlist(String userId) async {
    final response = await client.from('wishlist').select('''
      *,
      products(id, name, slug, price, sale_price, is_on_sale, stock, images)
    ''').eq('user_id', userId).order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response)
        .map((e) => WishlistItem.fromJson(e))
        .toList();
  }

  /// Obtiene la wishlist del usuario actual
  Future<List<WishlistItem>> getWishlist() async {
    final userId = currentUser?.id;
    if (userId == null) return [];
    return getUserWishlist(userId);
  }

  /// Agrega un producto a la wishlist
  Future<void> addToWishlist(int productId, {String? size}) async {
    final userId = currentUser?.id;
    if (userId == null) return;

    await client.from('wishlist').insert({
      'user_id': userId,
      'product_id': productId,
      'size': size ?? '',
    });
  }

  /// Elimina un producto de la wishlist
  Future<void> removeFromWishlist(int productId, {String? size}) async {
    final userId = currentUser?.id;
    if (userId == null) return;

    var query = client
        .from('wishlist')
        .delete()
        .eq('user_id', userId)
        .eq('product_id', productId);

    if (size != null) {
      query = query.eq('size', size);
    }

    await query;
  }

  /// Verifica si un producto está en la wishlist
  Future<bool> isInWishlist(int productId, {String? size}) async {
    final userId = currentUser?.id;
    if (userId == null) return false;

    var query = client
        .from('wishlist')
        .select('id')
        .eq('user_id', userId)
        .eq('product_id', productId);

    if (size != null) {
      query = query.eq('size', size);
    }

    final response = await query.maybeSingle();
    return response != null;
  }

  // ============================================
  // FACTURAS
  // ============================================

  /// Crea una factura
  Future<Map<String, dynamic>> createInvoice(Map<String, dynamic> data) async {
    final response =
        await client.from('invoices').insert(data).select().single();

    return response;
  }

  /// Obtiene las facturas de un usuario
  Future<List<Invoice>> getUserInvoices({int limit = 20}) async {
    final email = currentUser?.email;
    if (email == null || email.isEmpty) return [];

    final response = await client
        .from('invoices')
        .select('*, invoice_items(*)')
        .eq('customer_email', email)
        .order('created_at', ascending: false)
        .limit(limit);

    return List<Map<String, dynamic>>.from(response)
        .map((e) => Invoice.fromJson(e))
        .toList();
  }

  /// Obtiene una factura por ID
  Future<Invoice?> getInvoiceById(String id) async {
    final invoiceId = int.tryParse(id);
    if (invoiceId == null) return null;

    final response = await client
        .from('invoices')
        .select('*, invoice_items(*)')
        .eq('id', invoiceId)
        .maybeSingle();

    if (response == null) return null;
    return Invoice.fromJson(response);
  }

  /// Obtiene una factura por número
  Future<Invoice?> getInvoiceByNumber(String invoiceNumber) async {
    final response = await client
        .from('invoices')
        .select('*, invoice_items(*)')
        .eq('invoice_number', invoiceNumber)
        .maybeSingle();

    if (response == null) return null;
    return Invoice.fromJson(response);
  }

  /// Obtiene una factura por ID de pedido
  Future<Invoice?> getInvoiceByOrderId(String orderId) async {
    final parsedId = int.tryParse(orderId);
    if (parsedId == null) return null;

    final response = await client
        .from('invoices')
        .select('*, invoice_items(*)')
        .eq('order_id', parsedId)
        .maybeSingle();

    if (response == null) return null;
    return Invoice.fromJson(response);
  }

  /// Obtiene todas las facturas (Admin)
  Future<Map<String, dynamic>> getAllInvoices({
    int page = 1,
    int limit = 20,
    String? status,
    String? searchQuery,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    var query = client.from('invoices').select('*, invoice_items(*)');

    if (status != null && status.isNotEmpty) {
      query = query.eq('status', status);
    }

    if (searchQuery != null && searchQuery.isNotEmpty) {
      query = query.ilike('customer_email', '%$searchQuery%');
    }

    if (startDate != null) {
      query = query.gte('created_at', startDate.toIso8601String());
    }
    if (endDate != null) {
      query = query.lte('created_at', endDate.toIso8601String());
    }

    final from = (page - 1) * limit;
    final to = from + limit - 1;

    final response =
        await query.order('created_at', ascending: false).range(from, to);

    final invoices = List<Map<String, dynamic>>.from(response)
        .map((e) => Invoice.fromJson(e))
        .toList();

    return {
      'invoices': invoices,
      'total': invoices.length,
      'hasMore': invoices.length == limit,
    };
  }

  /// Crea una factura desde un pedido
  Future<Invoice?> createInvoiceFromOrder(Order order) async {
    final invoiceNumber = await getNextInvoiceNumber();
    final issueDate = DateTime.now();

    final invoiceData = <String, dynamic>{
      'invoice_number': invoiceNumber,
      'order_id': order.id,
      'customer_name': order.customerName,
      'customer_email': order.customerEmail,
      'customer_address': order.customerAddress,
      'customer_city': order.customerCity,
      'customer_postal_code': order.customerPostalCode,
      'customer_phone': order.customerPhone,
      'subtotal': order.subtotal ?? order.total,
      'shipping_cost': order.shippingCost,
      'discount': order.discount,
      'tax_rate': 21.0,
      'tax_amount': order.taxAmount,
      'total': order.total,
      'payment_method': 'Tarjeta de crédito',
      'payment_status': 'paid',
      'issue_date': issueDate.toIso8601String(),
      'status': 'issued',
    };

    final created =
        await client.from('invoices').insert(invoiceData).select().single();

    final invoiceId = created['id'] as int;

    final invoiceItems = order.items
        .map((item) => {
              'invoice_id': invoiceId,
              'product_id': item.productId,
              'product_name': item.productName,
              'product_size': item.size,
              'quantity': item.quantity,
              'unit_price': item.productPrice,
              'discount_percent': 0,
              'line_total': item.totalPrice,
            })
        .toList();

    if (invoiceItems.isNotEmpty) {
      await client.from('invoice_items').insert(invoiceItems);
    }

    final invoiceWithItems = await client
        .from('invoices')
        .select('*, invoice_items(*)')
        .eq('id', invoiceId)
        .maybeSingle();

    if (invoiceWithItems == null) return null;
    return Invoice.fromJson(invoiceWithItems);
  }

  /// Actualiza el estado de una factura
  Future<void> updateInvoiceStatus(String invoiceId, String status) async {
    final id = int.tryParse(invoiceId);
    if (id == null) return;
    await client.from('invoices').update({
      'status': status,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', id);
  }

  /// Obtiene estadísticas de facturación
  Future<Map<String, dynamic>> getInvoiceStats({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    var query = client.from('invoices').select('payment_status, total');

    if (startDate != null) {
      query = query.gte('created_at', startDate.toIso8601String());
    }
    if (endDate != null) {
      query = query.lte('created_at', endDate.toIso8601String());
    }

    final response = await query;
    final rows = List<Map<String, dynamic>>.from(response);

    final totalInvoices = rows.length;
    int paidInvoices = 0;
    int pendingInvoices = 0;
    int totalRevenue = 0;

    for (final row in rows) {
      final status = row['payment_status'] as String? ?? '';
      final total = row['total'] as int? ?? 0;
      if (status == 'paid') {
        paidInvoices++;
      } else {
        pendingInvoices++;
      }
      totalRevenue += total;
    }

    final averageInvoiceValue =
        totalInvoices > 0 ? (totalRevenue / totalInvoices).round() : 0;

    return {
      'totalInvoices': totalInvoices,
      'paidInvoices': paidInvoices,
      'pendingInvoices': pendingInvoices,
      'totalRevenue': totalRevenue,
      'averageInvoiceValue': averageInvoiceValue,
    };
  }

  /// Obtiene el siguiente número de factura
  Future<String> getNextInvoiceNumber() async {
    final response = await client
        .from('invoices')
        .select('invoice_number')
        .order('created_at', ascending: false)
        .limit(1)
        .maybeSingle();

    final year = DateTime.now().year;
    if (response == null) return '$year-0001';

    final lastNumber = response['invoice_number'] as String?;
    if (lastNumber == null || !lastNumber.contains('-')) {
      return '$year-0001';
    }

    final parts = lastNumber.split('-');
    if (parts.length != 2) return '$year-0001';

    final lastYear = int.tryParse(parts[0]) ?? year;
    final lastSeq = int.tryParse(parts[1]) ?? 0;

    final nextSeq = lastYear == year ? lastSeq + 1 : 1;
    final padded = nextSeq.toString().padLeft(4, '0');

    return '$year-$padded';
  }

  // ============================================
  // DEVOLUCIONES
  // ============================================

  /// Crea una devolución
  Future<Return?> createReturn({
    required int orderId,
    required List<ReturnItem> items,
    required String reason,
    String? comments,
    required int refundAmount,
  }) async {
    final order = await getOrderById(orderId.toString());
    if (order == null) return null;

    final data = <String, dynamic>{
      'order_id': orderId,
      'customer_email': order.customerEmail,
      'customer_name': order.customerName,
      'reason': reason,
      'reason_details': comments,
      'items': items.map((e) => e.toJson()).toList(),
      'status': 'pending',
      'refund_amount': refundAmount,
    };

    final response =
        await client.from('returns').insert(data).select().single();

    return Return.fromJson(response);
  }

  /// Obtiene las devoluciones del usuario actual
  Future<List<Return>> getUserReturns({int limit = 20}) async {
    final email = currentUser?.email;
    if (email == null || email.isEmpty) return [];

    final response = await client
        .from('returns')
        .select()
        .eq('customer_email', email)
        .order('created_at', ascending: false)
        .limit(limit);

    return List<Map<String, dynamic>>.from(response)
        .map((e) => Return.fromJson(e))
        .toList();
  }

  /// Obtiene una devolución por ID
  Future<Return?> getReturnById(String id) async {
    final returnId = int.tryParse(id);
    if (returnId == null) return null;

    final response =
        await client.from('returns').select().eq('id', returnId).maybeSingle();

    if (response == null) return null;
    return Return.fromJson(response);
  }

  /// Obtiene una devolución por número
  Future<Return?> getReturnByNumber(String returnNumber) async {
    final response = await client
        .from('returns')
        .select()
        .eq('return_number', returnNumber)
        .maybeSingle();

    if (response == null) return null;
    return Return.fromJson(response);
  }

  /// Actualiza el estado de una devolución
  Future<void> updateReturnStatus(
    String returnId,
    String status, {
    String? adminNotes,
  }) async {
    final id = int.tryParse(returnId);
    if (id == null) return;

    await client.from('returns').update({
      'status': status,
      if (adminNotes != null) 'admin_notes': adminNotes,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', id);
  }

  /// Obtiene todas las devoluciones (Admin)
  Future<Map<String, dynamic>> getAllReturns({
    int page = 1,
    int limit = 20,
    String? status,
    String? searchQuery,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    var query = client.from('returns').select();

    if (status != null && status.isNotEmpty) {
      query = query.eq('status', status);
    }

    if (searchQuery != null && searchQuery.isNotEmpty) {
      query = query.ilike('customer_email', '%$searchQuery%');
    }

    if (startDate != null) {
      query = query.gte('created_at', startDate.toIso8601String());
    }
    if (endDate != null) {
      query = query.lte('created_at', endDate.toIso8601String());
    }

    final from = (page - 1) * limit;
    final to = from + limit - 1;

    final response =
        await query.order('created_at', ascending: false).range(from, to);

    final returns = List<Map<String, dynamic>>.from(response)
        .map((e) => Return.fromJson(e))
        .toList();

    return {
      'returns': returns,
      'total': returns.length,
      'hasMore': returns.length == limit,
    };
  }

  /// Obtiene estadísticas de devoluciones (Admin)
  Future<Map<String, dynamic>> getReturnStats({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    var query = client.from('returns').select('status, refund_amount');

    if (startDate != null) {
      query = query.gte('created_at', startDate.toIso8601String());
    }
    if (endDate != null) {
      query = query.lte('created_at', endDate.toIso8601String());
    }

    final response = await query;
    final rows = List<Map<String, dynamic>>.from(response);

    final totalReturns = rows.length;
    int pending = 0;
    int approved = 0;
    int completed = 0;
    int rejected = 0;
    int totalRefundAmount = 0;

    for (final row in rows) {
      final status = row['status'] as String? ?? '';
      final refundAmount = row['refund_amount'] as int? ?? 0;
      switch (status) {
        case 'pending':
          pending++;
          break;
        case 'approved':
          approved++;
          break;
        case 'refunded':
          completed++;
          break;
        case 'rejected':
          rejected++;
          break;
      }
      totalRefundAmount += refundAmount;
    }

    return {
      'totalReturns': totalReturns,
      'pendingReturns': pending,
      'approvedReturns': approved,
      'completedReturns': completed,
      'rejectedReturns': rejected,
      'totalRefundAmount': totalRefundAmount,
    };
  }

  // ============================================
  // NEWSLETTER
  // ============================================

  /// Suscribe un email al newsletter
  Future<void> subscribeToNewsletter(String email, {String? name}) async {
    await client.from('newsletter_subscribers').upsert({
      'email': email,
      'name': name,
      'is_active': true,
      'subscribed_at': DateTime.now().toIso8601String(),
    });
  }

  /// Desuscribe un email del newsletter
  Future<void> unsubscribeFromNewsletter(String email) async {
    await client.from('newsletter_subscribers').update({
      'is_active': false,
      'unsubscribed_at': DateTime.now().toIso8601String(),
    }).eq('email', email);
  }

  // ============================================
  // ADMIN - VERIFICACIÓN
  // ============================================

  /// Verifica si un email es admin
  Future<bool> isAdmin(String email) async {
    final response = await client
        .from('admin_users')
        .select('id')
        .eq('email', email)
        .maybeSingle();

    return response != null;
  }

  /// Obtiene el rol de admin
  Future<String?> getAdminRole(String email) async {
    final response = await client
        .from('admin_users')
        .select('role')
        .eq('email', email)
        .maybeSingle();

    return response?['role'] as String?;
  }

  // ============================================
  // CONFIGURACIÓN
  // ============================================

  /// Obtiene una configuración por clave
  Future<String?> getSetting(String key) async {
    final response = await client
        .from('app_settings')
        .select('value')
        .eq('key', key)
        .maybeSingle();

    return response?['value'] as String?;
  }

  /// Actualiza o crea una configuración
  Future<void> setSetting(String key, String value) async {
    await client.from('app_settings').upsert({
      'key': key,
      'value': value,
      'updated_at': DateTime.now().toIso8601String(),
    });
  }
}
