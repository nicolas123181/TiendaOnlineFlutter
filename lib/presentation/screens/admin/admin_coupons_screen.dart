import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../config/app_colors.dart';

/// Pantalla de gestión de cupones del admin
class AdminCouponsScreen extends ConsumerStatefulWidget {
  const AdminCouponsScreen({super.key});

  @override
  ConsumerState<AdminCouponsScreen> createState() => _AdminCouponsScreenState();
}

class _AdminCouponsScreenState extends ConsumerState<AdminCouponsScreen> {
  final _searchController = TextEditingController();
  String _filterStatus = 'all';

  // Datos de ejemplo
  final List<_CouponData> _coupons = [
    _CouponData(
      id: 'CPN-001',
      code: 'VANTAGE10',
      description: '10% de descuento en toda la tienda',
      type: 'percentage',
      value: 10,
      minPurchase: 50,
      maxUses: 100,
      usedCount: 45,
      startDate: DateTime.now().subtract(const Duration(days: 30)),
      endDate: DateTime.now().add(const Duration(days: 30)),
      isActive: true,
    ),
    _CouponData(
      id: 'CPN-002',
      code: 'WELCOME20',
      description: '20€ de descuento para nuevos clientes',
      type: 'fixed',
      value: 20,
      minPurchase: 100,
      maxUses: 500,
      usedCount: 123,
      startDate: DateTime.now().subtract(const Duration(days: 60)),
      endDate: DateTime.now().add(const Duration(days: 60)),
      isActive: true,
      isFirstPurchaseOnly: true,
    ),
    _CouponData(
      id: 'CPN-003',
      code: 'FREESHIP',
      description: 'Envío gratis',
      type: 'free_shipping',
      value: 0,
      minPurchase: 30,
      maxUses: null,
      usedCount: 256,
      startDate: DateTime.now().subtract(const Duration(days: 90)),
      endDate: null,
      isActive: true,
    ),
    _CouponData(
      id: 'CPN-004',
      code: 'SUMMER25',
      description: '25% de descuento de verano',
      type: 'percentage',
      value: 25,
      minPurchase: 75,
      maxUses: 200,
      usedCount: 200,
      startDate: DateTime.now().subtract(const Duration(days: 60)),
      endDate: DateTime.now().subtract(const Duration(days: 10)),
      isActive: false,
    ),
    _CouponData(
      id: 'CPN-005',
      code: 'BLACK50',
      description: '50% Black Friday',
      type: 'percentage',
      value: 50,
      minPurchase: 100,
      maxUses: 50,
      usedCount: 0,
      startDate: DateTime.now().add(const Duration(days: 30)),
      endDate: DateTime.now().add(const Duration(days: 33)),
      isActive: false,
      isScheduled: true,
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cupones'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCouponForm(null),
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de búsqueda y filtros
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.surface,
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Buscar cupones...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                          )
                        : null,
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _FilterChip(
                        label: 'Todos',
                        isSelected: _filterStatus == 'all',
                        onSelected: () => setState(() => _filterStatus = 'all'),
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: 'Activos',
                        isSelected: _filterStatus == 'active',
                        onSelected: () =>
                            setState(() => _filterStatus = 'active'),
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: 'Programados',
                        isSelected: _filterStatus == 'scheduled',
                        onSelected: () =>
                            setState(() => _filterStatus = 'scheduled'),
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: 'Expirados',
                        isSelected: _filterStatus == 'expired',
                        onSelected: () =>
                            setState(() => _filterStatus = 'expired'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Estadísticas rápidas
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _StatBox(
                  label: 'Activos',
                  value:
                      '${_coupons.where((c) => c.isActive && !c.isScheduled).length}',
                  color: AppColors.success,
                ),
                const SizedBox(width: 12),
                _StatBox(
                  label: 'Usos totales',
                  value: '${_coupons.fold(0, (sum, c) => sum + c.usedCount)}',
                  color: AppColors.brandNavy,
                ),
                const SizedBox(width: 12),
                _StatBox(
                  label: 'Programados',
                  value: '${_coupons.where((c) => c.isScheduled).length}',
                  color: AppColors.info,
                ),
              ],
            ),
          ),

          // Lista de cupones
          Expanded(
            child: _getFilteredCoupons().isEmpty
                ? _buildEmptyState()
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _getFilteredCoupons().length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final coupon = _getFilteredCoupons()[index];
                      return _CouponCard(
                        coupon: coupon,
                        onTap: () => _showCouponForm(coupon),
                        onToggle: () => _toggleCoupon(coupon),
                        onDelete: () => _confirmDelete(coupon),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCouponForm(null),
        backgroundColor: AppColors.brandNavy,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  List<_CouponData> _getFilteredCoupons() {
    return _coupons.where((coupon) {
      // Filtrar por búsqueda
      if (_searchController.text.isNotEmpty) {
        final query = _searchController.text.toLowerCase();
        if (!coupon.code.toLowerCase().contains(query) &&
            !coupon.description.toLowerCase().contains(query)) {
          return false;
        }
      }

      // Filtrar por estado
      switch (_filterStatus) {
        case 'active':
          return coupon.isActive && !coupon.isScheduled;
        case 'scheduled':
          return coupon.isScheduled;
        case 'expired':
          return !coupon.isActive && !coupon.isScheduled;
        default:
          return true;
      }
    }).toList();
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.local_offer_outlined,
            size: 64,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: 16),
          Text(
            'No hay cupones',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => _showCouponForm(null),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.brandNavy,
              shape:
                  const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            ),
            child: const Text('Crear cupón'),
          ),
        ],
      ),
    );
  }

  void _showCouponForm(_CouponData? coupon) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      builder: (context) => _CouponFormSheet(
        coupon: coupon,
        onSave: (newCoupon) {
          setState(() {
            if (coupon != null) {
              final index = _coupons.indexWhere((c) => c.id == coupon.id);
              if (index != -1) {
                _coupons[index] = newCoupon;
              }
            } else {
              _coupons.insert(0, newCoupon);
            }
          });
        },
      ),
    );
  }

  void _toggleCoupon(_CouponData coupon) {
    setState(() {
      final index = _coupons.indexWhere((c) => c.id == coupon.id);
      if (index != -1) {
        _coupons[index] = _CouponData(
          id: coupon.id,
          code: coupon.code,
          description: coupon.description,
          type: coupon.type,
          value: coupon.value,
          minPurchase: coupon.minPurchase,
          maxUses: coupon.maxUses,
          usedCount: coupon.usedCount,
          startDate: coupon.startDate,
          endDate: coupon.endDate,
          isActive: !coupon.isActive,
          isFirstPurchaseOnly: coupon.isFirstPurchaseOnly,
          isScheduled: coupon.isScheduled,
        );
      }
    });
  }

  void _confirmDelete(_CouponData coupon) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: const Text('Eliminar cupón'),
        content: Text('¿Eliminar el cupón "${coupon.code}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _coupons.removeWhere((c) => c.id == coupon.id);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cupón eliminado')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}

// Modelo de datos
class _CouponData {
  final String id;
  final String code;
  final String description;
  final String type; // 'percentage', 'fixed', 'free_shipping'
  final double value;
  final double? minPurchase;
  final int? maxUses;
  final int usedCount;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isActive;
  final bool isFirstPurchaseOnly;
  final bool isScheduled;

  _CouponData({
    required this.id,
    required this.code,
    required this.description,
    required this.type,
    required this.value,
    this.minPurchase,
    this.maxUses,
    required this.usedCount,
    required this.startDate,
    this.endDate,
    required this.isActive,
    this.isFirstPurchaseOnly = false,
    this.isScheduled = false,
  });
}

// Widgets auxiliares
class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onSelected;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onSelected(),
      backgroundColor: AppColors.surface,
      selectedColor: AppColors.brandNavy,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : AppColors.textPrimary,
      ),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      side: BorderSide.none,
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatBox({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: color,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CouponCard extends StatelessWidget {
  final _CouponData coupon;
  final VoidCallback onTap;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const _CouponCard({
    required this.coupon,
    required this.onTap,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final currencyFormat = NumberFormat.currency(symbol: '€');

    // Valor del cupón
    String valueText;
    IconData typeIcon;
    Color typeColor;

    switch (coupon.type) {
      case 'percentage':
        valueText = '${coupon.value.toInt()}%';
        typeIcon = Icons.percent;
        typeColor = AppColors.brandGold;
        break;
      case 'fixed':
        valueText = currencyFormat.format(coupon.value);
        typeIcon = Icons.euro;
        typeColor = AppColors.success;
        break;
      case 'free_shipping':
        valueText = 'Envío gratis';
        typeIcon = Icons.local_shipping;
        typeColor = AppColors.info;
        break;
      default:
        valueText = '${coupon.value}';
        typeIcon = Icons.local_offer;
        typeColor = AppColors.textSecondary;
    }

    // Estado
    Color statusColor;
    String statusText;

    if (coupon.isScheduled) {
      statusColor = AppColors.info;
      statusText = 'Programado';
    } else if (coupon.isActive) {
      statusColor = AppColors.success;
      statusText = 'Activo';
    } else {
      statusColor = AppColors.error;
      statusText = 'Inactivo';
    }

    // Progreso de uso
    final useProgress =
        coupon.maxUses != null ? coupon.usedCount / coupon.maxUses! : 0.0;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: typeColor.withValues(alpha: 0.1),
                  ),
                  child: Icon(typeIcon, color: typeColor, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            coupon.code,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            color: statusColor.withValues(alpha: 0.1),
                            child: Text(
                              statusText,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: statusColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        coupon.description,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Text(
                  valueText,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: typeColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),

            // Info
            Row(
              children: [
                // Fechas
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.calendar_today,
                              size: 14, color: AppColors.textSecondary),
                          const SizedBox(width: 4),
                          Text(
                            coupon.endDate != null
                                ? '${dateFormat.format(coupon.startDate)} - ${dateFormat.format(coupon.endDate!)}'
                                : 'Desde ${dateFormat.format(coupon.startDate)}',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                          ),
                        ],
                      ),
                      if (coupon.minPurchase != null) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.shopping_cart,
                                size: 14, color: AppColors.textSecondary),
                            const SizedBox(width: 4),
                            Text(
                              'Mín. ${currencyFormat.format(coupon.minPurchase)}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                // Usos
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      coupon.maxUses != null
                          ? '${coupon.usedCount}/${coupon.maxUses}'
                          : '${coupon.usedCount} usos',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    if (coupon.maxUses != null) ...[
                      const SizedBox(height: 4),
                      SizedBox(
                        width: 80,
                        child: LinearProgressIndicator(
                          value: useProgress,
                          backgroundColor: AppColors.border,
                          valueColor: AlwaysStoppedAnimation(
                            useProgress >= 1
                                ? AppColors.error
                                : AppColors.success,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Acciones
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (coupon.isFirstPurchaseOnly)
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    color: AppColors.brandNavy.withValues(alpha: 0.1),
                    child: const Text(
                      'Primera compra',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.brandNavy,
                      ),
                    ),
                  ),
                const Spacer(),
                IconButton(
                  icon: Icon(
                    coupon.isActive
                        ? Icons.pause_circle_outline
                        : Icons.play_circle_outline,
                    color:
                        coupon.isActive ? AppColors.warning : AppColors.success,
                  ),
                  onPressed: onToggle,
                  tooltip: coupon.isActive ? 'Desactivar' : 'Activar',
                ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: onTap,
                  tooltip: 'Editar',
                ),
                IconButton(
                  icon:
                      const Icon(Icons.delete_outline, color: AppColors.error),
                  onPressed: onDelete,
                  tooltip: 'Eliminar',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CouponFormSheet extends StatefulWidget {
  final _CouponData? coupon;
  final Function(_CouponData) onSave;

  const _CouponFormSheet({this.coupon, required this.onSave});

  @override
  State<_CouponFormSheet> createState() => _CouponFormSheetState();
}

class _CouponFormSheetState extends State<_CouponFormSheet> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _codeController;
  late TextEditingController _descriptionController;
  late TextEditingController _valueController;
  late TextEditingController _minPurchaseController;
  late TextEditingController _maxUsesController;

  String _selectedType = 'percentage';
  DateTime _startDate = DateTime.now();
  DateTime? _endDate;
  bool _isFirstPurchaseOnly = false;
  bool _hasEndDate = false;
  bool _hasMaxUses = false;

  @override
  void initState() {
    super.initState();
    final coupon = widget.coupon;

    _codeController = TextEditingController(text: coupon?.code ?? '');
    _descriptionController =
        TextEditingController(text: coupon?.description ?? '');
    _valueController = TextEditingController(
        text: coupon?.value != null ? coupon!.value.toString() : '');
    _minPurchaseController = TextEditingController(
        text:
            coupon?.minPurchase != null ? coupon!.minPurchase.toString() : '');
    _maxUsesController = TextEditingController(
        text: coupon?.maxUses != null ? coupon!.maxUses.toString() : '');

    if (coupon != null) {
      _selectedType = coupon.type;
      _startDate = coupon.startDate;
      _endDate = coupon.endDate;
      _hasEndDate = coupon.endDate != null;
      _hasMaxUses = coupon.maxUses != null;
      _isFirstPurchaseOnly = coupon.isFirstPurchaseOnly;
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    _descriptionController.dispose();
    _valueController.dispose();
    _minPurchaseController.dispose();
    _maxUsesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Container(
          color: AppColors.background,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Handle
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // Header
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.coupon != null ? 'Editar cupón' : 'Nuevo cupón',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),

                // Form
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Código
                        TextFormField(
                          controller: _codeController,
                          decoration: const InputDecoration(
                            labelText: 'Código del cupón *',
                            hintText: 'Ej: VANTAGE10',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.zero),
                          ),
                          textCapitalization: TextCapitalization.characters,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'El código es obligatorio';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Descripción
                        TextFormField(
                          controller: _descriptionController,
                          decoration: const InputDecoration(
                            labelText: 'Descripción',
                            hintText: 'Descripción del cupón',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.zero),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Tipo de descuento
                        Text(
                          'Tipo de descuento',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _TypeOption(
                              label: 'Porcentaje',
                              icon: Icons.percent,
                              isSelected: _selectedType == 'percentage',
                              onSelected: () =>
                                  setState(() => _selectedType = 'percentage'),
                            ),
                            const SizedBox(width: 8),
                            _TypeOption(
                              label: 'Fijo',
                              icon: Icons.euro,
                              isSelected: _selectedType == 'fixed',
                              onSelected: () =>
                                  setState(() => _selectedType = 'fixed'),
                            ),
                            const SizedBox(width: 8),
                            _TypeOption(
                              label: 'Envío',
                              icon: Icons.local_shipping,
                              isSelected: _selectedType == 'free_shipping',
                              onSelected: () => setState(
                                  () => _selectedType = 'free_shipping'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Valor
                        if (_selectedType != 'free_shipping')
                          TextFormField(
                            controller: _valueController,
                            decoration: InputDecoration(
                              labelText: _selectedType == 'percentage'
                                  ? 'Porcentaje de descuento *'
                                  : 'Cantidad de descuento *',
                              suffixText:
                                  _selectedType == 'percentage' ? '%' : '€',
                              border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.zero),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'El valor es obligatorio';
                              }
                              return null;
                            },
                          ),
                        if (_selectedType != 'free_shipping')
                          const SizedBox(height: 16),

                        // Compra mínima
                        TextFormField(
                          controller: _minPurchaseController,
                          decoration: const InputDecoration(
                            labelText: 'Compra mínima',
                            prefixText: '€ ',
                            hintText: 'Sin mínimo',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.zero),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 16),

                        // Fechas
                        Text(
                          'Vigencia',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        const SizedBox(height: 8),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.calendar_today),
                          title: const Text('Fecha de inicio'),
                          subtitle:
                              Text(DateFormat('dd/MM/yyyy').format(_startDate)),
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: _startDate,
                              firstDate: DateTime.now()
                                  .subtract(const Duration(days: 365)),
                              lastDate:
                                  DateTime.now().add(const Duration(days: 365)),
                            );
                            if (date != null) {
                              setState(() => _startDate = date);
                            }
                          },
                        ),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Establecer fecha de fin'),
                          value: _hasEndDate,
                          onChanged: (value) =>
                              setState(() => _hasEndDate = value),
                        ),
                        if (_hasEndDate)
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.event),
                            title: const Text('Fecha de fin'),
                            subtitle: Text(_endDate != null
                                ? DateFormat('dd/MM/yyyy').format(_endDate!)
                                : 'Seleccionar'),
                            onTap: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: _endDate ??
                                    _startDate.add(const Duration(days: 30)),
                                firstDate: _startDate,
                                lastDate: DateTime.now()
                                    .add(const Duration(days: 365)),
                              );
                              if (date != null) {
                                setState(() => _endDate = date);
                              }
                            },
                          ),
                        const SizedBox(height: 16),

                        // Límites
                        Text(
                          'Límites de uso',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Limitar usos totales'),
                          value: _hasMaxUses,
                          onChanged: (value) =>
                              setState(() => _hasMaxUses = value),
                        ),
                        if (_hasMaxUses)
                          TextFormField(
                            controller: _maxUsesController,
                            decoration: const InputDecoration(
                              labelText: 'Número máximo de usos',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.zero),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Solo primera compra'),
                          subtitle: const Text('Solo para nuevos clientes'),
                          value: _isFirstPurchaseOnly,
                          onChanged: (value) =>
                              setState(() => _isFirstPurchaseOnly = value),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),

                // Bottom bar
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    border: Border(top: BorderSide(color: AppColors.border)),
                  ),
                  child: SafeArea(
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _saveCoupon,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.brandNavy,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        child: Text(
                          widget.coupon != null
                              ? 'Guardar cambios'
                              : 'Crear cupón',
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveCoupon() {
    if (!_formKey.currentState!.validate()) return;

    final coupon = _CouponData(
      id: widget.coupon?.id ??
          'CPN-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}',
      code: _codeController.text.toUpperCase(),
      description: _descriptionController.text,
      type: _selectedType,
      value: double.tryParse(_valueController.text) ?? 0,
      minPurchase: _minPurchaseController.text.isNotEmpty
          ? double.tryParse(_minPurchaseController.text)
          : null,
      maxUses: _hasMaxUses && _maxUsesController.text.isNotEmpty
          ? int.tryParse(_maxUsesController.text)
          : null,
      usedCount: widget.coupon?.usedCount ?? 0,
      startDate: _startDate,
      endDate: _hasEndDate ? _endDate : null,
      isActive: _startDate.isBefore(DateTime.now()) ||
          _startDate.isAtSameMomentAs(DateTime.now()),
      isFirstPurchaseOnly: _isFirstPurchaseOnly,
      isScheduled: _startDate.isAfter(DateTime.now()),
    );

    widget.onSave(coupon);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.coupon != null ? 'Cupón actualizado' : 'Cupón creado',
        ),
      ),
    );
  }
}

class _TypeOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onSelected;

  const _TypeOption({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onSelected,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.brandNavy : AppColors.surface,
            border: Border.all(
              color: isSelected ? AppColors.brandNavy : AppColors.border,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
