import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../config/app_colors.dart';

/// Pantalla de configuración de envíos del admin
class AdminShippingScreen extends ConsumerStatefulWidget {
  const AdminShippingScreen({super.key});

  @override
  ConsumerState<AdminShippingScreen> createState() =>
      _AdminShippingScreenState();
}

class _AdminShippingScreenState extends ConsumerState<AdminShippingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Datos de ejemplo
  final List<_ShippingMethodData> _shippingMethods = [
    _ShippingMethodData(
      id: 'SHIP-001',
      name: 'Envío estándar',
      description: 'Entrega en 3-5 días laborables',
      price: 4.95,
      freeFrom: 50,
      minDays: 3,
      maxDays: 5,
      isActive: true,
      isDefault: true,
    ),
    _ShippingMethodData(
      id: 'SHIP-002',
      name: 'Envío express',
      description: 'Entrega en 24-48 horas',
      price: 9.95,
      freeFrom: null,
      minDays: 1,
      maxDays: 2,
      isActive: true,
      isDefault: false,
    ),
    _ShippingMethodData(
      id: 'SHIP-003',
      name: 'Recogida en tienda',
      description: 'Recoge tu pedido en nuestra tienda física',
      price: 0,
      freeFrom: null,
      minDays: 1,
      maxDays: 1,
      isActive: true,
      isDefault: false,
    ),
    _ShippingMethodData(
      id: 'SHIP-004',
      name: 'Envío internacional',
      description: 'Entrega en 7-14 días laborables',
      price: 19.95,
      freeFrom: 150,
      minDays: 7,
      maxDays: 14,
      isActive: false,
      isDefault: false,
    ),
  ];

  final List<_ShippingZoneData> _shippingZones = [
    _ShippingZoneData(
      id: 'ZONE-001',
      name: 'Península',
      countries: ['España (Península)', 'Portugal'],
      methods: ['SHIP-001', 'SHIP-002', 'SHIP-003'],
      isActive: true,
    ),
    _ShippingZoneData(
      id: 'ZONE-002',
      name: 'Baleares',
      countries: ['Islas Baleares'],
      methods: ['SHIP-001', 'SHIP-002'],
      isActive: true,
      priceAdjustment: 2.00,
    ),
    _ShippingZoneData(
      id: 'ZONE-003',
      name: 'Canarias',
      countries: ['Islas Canarias'],
      methods: ['SHIP-001'],
      isActive: true,
      priceAdjustment: 5.00,
    ),
    _ShippingZoneData(
      id: 'ZONE-004',
      name: 'Europa',
      countries: ['Francia', 'Alemania', 'Italia', 'Reino Unido'],
      methods: ['SHIP-004'],
      isActive: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración de envíos'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.brandGold,
          tabs: const [
            Tab(text: 'Métodos de envío'),
            Tab(text: 'Zonas de envío'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMethodsTab(),
          _buildZonesTab(),
        ],
      ),
    );
  }

  Widget _buildMethodsTab() {
    return Column(
      children: [
        // Botón crear método
        Container(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showMethodForm(null),
              icon: const Icon(Icons.add),
              label: const Text('Añadir método de envío'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brandNavy,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
            ),
          ),
        ),

        // Lista de métodos
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _shippingMethods.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final method = _shippingMethods[index];
              return _ShippingMethodCard(
                method: method,
                onTap: () => _showMethodForm(method),
                onToggle: () => _toggleMethod(method),
                onSetDefault: () => _setDefaultMethod(method),
                onDelete: () => _confirmDeleteMethod(method),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildZonesTab() {
    return Column(
      children: [
        // Botón crear zona
        Container(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showZoneForm(null),
              icon: const Icon(Icons.add),
              label: const Text('Añadir zona de envío'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brandNavy,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
            ),
          ),
        ),

        // Lista de zonas
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _shippingZones.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final zone = _shippingZones[index];
              return _ShippingZoneCard(
                zone: zone,
                methods: _shippingMethods,
                onTap: () => _showZoneForm(zone),
                onToggle: () => _toggleZone(zone),
                onDelete: () => _confirmDeleteZone(zone),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showMethodForm(_ShippingMethodData? method) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      builder: (context) => _ShippingMethodFormSheet(
        method: method,
        onSave: (newMethod) {
          setState(() {
            if (method != null) {
              final index =
                  _shippingMethods.indexWhere((m) => m.id == method.id);
              if (index != -1) {
                _shippingMethods[index] = newMethod;
              }
            } else {
              _shippingMethods.add(newMethod);
            }
          });
        },
      ),
    );
  }

  void _toggleMethod(_ShippingMethodData method) {
    setState(() {
      final index = _shippingMethods.indexWhere((m) => m.id == method.id);
      if (index != -1) {
        _shippingMethods[index] = _ShippingMethodData(
          id: method.id,
          name: method.name,
          description: method.description,
          price: method.price,
          freeFrom: method.freeFrom,
          minDays: method.minDays,
          maxDays: method.maxDays,
          isActive: !method.isActive,
          isDefault: method.isDefault,
        );
      }
    });
  }

  void _setDefaultMethod(_ShippingMethodData method) {
    setState(() {
      for (int i = 0; i < _shippingMethods.length; i++) {
        final m = _shippingMethods[i];
        _shippingMethods[i] = _ShippingMethodData(
          id: m.id,
          name: m.name,
          description: m.description,
          price: m.price,
          freeFrom: m.freeFrom,
          minDays: m.minDays,
          maxDays: m.maxDays,
          isActive: m.isActive,
          isDefault: m.id == method.id,
        );
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('"${method.name}" es ahora el método por defecto'),
      ),
    );
  }

  void _confirmDeleteMethod(_ShippingMethodData method) {
    if (method.isDefault) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No puedes eliminar el método por defecto'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: const Text('Eliminar método de envío'),
        content: Text('¿Eliminar "${method.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _shippingMethods.removeWhere((m) => m.id == method.id);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Método eliminado')),
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

  void _showZoneForm(_ShippingZoneData? zone) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      builder: (context) => _ShippingZoneFormSheet(
        zone: zone,
        availableMethods: _shippingMethods,
        onSave: (newZone) {
          setState(() {
            if (zone != null) {
              final index = _shippingZones.indexWhere((z) => z.id == zone.id);
              if (index != -1) {
                _shippingZones[index] = newZone;
              }
            } else {
              _shippingZones.add(newZone);
            }
          });
        },
      ),
    );
  }

  void _toggleZone(_ShippingZoneData zone) {
    setState(() {
      final index = _shippingZones.indexWhere((z) => z.id == zone.id);
      if (index != -1) {
        _shippingZones[index] = _ShippingZoneData(
          id: zone.id,
          name: zone.name,
          countries: zone.countries,
          methods: zone.methods,
          isActive: !zone.isActive,
          priceAdjustment: zone.priceAdjustment,
        );
      }
    });
  }

  void _confirmDeleteZone(_ShippingZoneData zone) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: const Text('Eliminar zona de envío'),
        content: Text('¿Eliminar la zona "${zone.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _shippingZones.removeWhere((z) => z.id == zone.id);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Zona eliminada')),
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

// Modelos de datos
class _ShippingMethodData {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? freeFrom;
  final int minDays;
  final int maxDays;
  final bool isActive;
  final bool isDefault;

  _ShippingMethodData({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.freeFrom,
    required this.minDays,
    required this.maxDays,
    required this.isActive,
    required this.isDefault,
  });
}

class _ShippingZoneData {
  final String id;
  final String name;
  final List<String> countries;
  final List<String> methods;
  final bool isActive;
  final double? priceAdjustment;

  _ShippingZoneData({
    required this.id,
    required this.name,
    required this.countries,
    required this.methods,
    required this.isActive,
    this.priceAdjustment,
  });
}

// Widgets auxiliares
class _ShippingMethodCard extends StatelessWidget {
  final _ShippingMethodData method;
  final VoidCallback onTap;
  final VoidCallback onToggle;
  final VoidCallback onSetDefault;
  final VoidCallback onDelete;

  const _ShippingMethodCard({
    required this.method,
    required this.onTap,
    required this.onToggle,
    required this.onSetDefault,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '€');

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(
            color: method.isDefault ? AppColors.brandGold : AppColors.border,
            width: method.isDefault ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  color: AppColors.brandNavy.withValues(alpha: 0.1),
                  child: const Icon(
                    Icons.local_shipping,
                    color: AppColors.brandNavy,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            method.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          if (method.isDefault) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              color: AppColors.brandGold.withValues(alpha: 0.1),
                              child: const Text(
                                'Por defecto',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.brandGold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      Text(
                        method.description,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  color: method.isActive
                      ? AppColors.success.withValues(alpha: 0.1)
                      : AppColors.error.withValues(alpha: 0.1),
                  child: Text(
                    method.isActive ? 'Activo' : 'Inactivo',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color:
                          method.isActive ? AppColors.success : AppColors.error,
                    ),
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
                // Precio
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Precio',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textTertiary,
                            ),
                      ),
                      Text(
                        method.price == 0
                            ? 'Gratis'
                            : currencyFormat.format(method.price),
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),

                // Gratis desde
                if (method.freeFrom != null)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Gratis desde',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.textTertiary,
                                  ),
                        ),
                        Text(
                          currencyFormat.format(method.freeFrom),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),

                // Tiempo de entrega
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Entrega',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textTertiary,
                            ),
                      ),
                      Text(
                        method.minDays == method.maxDays
                            ? '${method.minDays} día${method.minDays == 1 ? '' : 's'}'
                            : '${method.minDays}-${method.maxDays} días',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Acciones
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (!method.isDefault)
                  TextButton(
                    onPressed: onSetDefault,
                    child: const Text('Hacer por defecto'),
                  ),
                IconButton(
                  icon: Icon(
                    method.isActive ? Icons.toggle_on : Icons.toggle_off,
                    color: method.isActive
                        ? AppColors.success
                        : AppColors.textSecondary,
                    size: 32,
                  ),
                  onPressed: onToggle,
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  color: method.isDefault
                      ? AppColors.textTertiary
                      : AppColors.error,
                  onPressed: method.isDefault ? null : onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ShippingZoneCard extends StatelessWidget {
  final _ShippingZoneData zone;
  final List<_ShippingMethodData> methods;
  final VoidCallback onTap;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const _ShippingZoneCard({
    required this.zone,
    required this.methods,
    required this.onTap,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '€');

    final zoneMethods =
        methods.where((m) => zone.methods.contains(m.id)).toList();

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
                  color: AppColors.brandNavy.withValues(alpha: 0.1),
                  child: const Icon(
                    Icons.public,
                    color: AppColors.brandNavy,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    zone.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  color: zone.isActive
                      ? AppColors.success.withValues(alpha: 0.1)
                      : AppColors.error.withValues(alpha: 0.1),
                  child: Text(
                    zone.isActive ? 'Activa' : 'Inactiva',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color:
                          zone.isActive ? AppColors.success : AppColors.error,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Países
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: zone.countries
                  .map(
                    (country) => Chip(
                      label: Text(
                        country,
                        style: const TextStyle(fontSize: 12),
                      ),
                      backgroundColor: AppColors.border.withValues(alpha: 0.3),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      side: BorderSide.none,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    ),
                  )
                  .toList(),
            ),

            if (zone.priceAdjustment != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                color: AppColors.warning.withValues(alpha: 0.1),
                child: Row(
                  children: [
                    const Icon(Icons.add_circle_outline,
                        size: 16, color: AppColors.warning),
                    const SizedBox(width: 8),
                    Text(
                      'Recargo: ${currencyFormat.format(zone.priceAdjustment)}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.warning,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),

            // Métodos disponibles
            Text(
              'Métodos de envío disponibles:',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            const SizedBox(height: 8),
            ...zoneMethods.map(
              (method) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Icon(
                      Icons.check,
                      size: 16,
                      color: method.isActive
                          ? AppColors.success
                          : AppColors.textTertiary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        method.name,
                        style: TextStyle(
                          color: method.isActive
                              ? AppColors.textPrimary
                              : AppColors.textTertiary,
                        ),
                      ),
                    ),
                    Text(
                      method.price == 0
                          ? 'Gratis'
                          : currencyFormat.format(
                              method.price + (zone.priceAdjustment ?? 0)),
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: method.isActive
                            ? AppColors.textPrimary
                            : AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Acciones
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(
                    zone.isActive ? Icons.toggle_on : Icons.toggle_off,
                    color: zone.isActive
                        ? AppColors.success
                        : AppColors.textSecondary,
                    size: 32,
                  ),
                  onPressed: onToggle,
                ),
                IconButton(
                  icon:
                      const Icon(Icons.delete_outline, color: AppColors.error),
                  onPressed: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ShippingMethodFormSheet extends StatefulWidget {
  final _ShippingMethodData? method;
  final Function(_ShippingMethodData) onSave;

  const _ShippingMethodFormSheet({this.method, required this.onSave});

  @override
  State<_ShippingMethodFormSheet> createState() =>
      _ShippingMethodFormSheetState();
}

class _ShippingMethodFormSheetState extends State<_ShippingMethodFormSheet> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _freeFromController;
  late TextEditingController _minDaysController;
  late TextEditingController _maxDaysController;

  bool _hasFreeFrom = false;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    final method = widget.method;

    _nameController = TextEditingController(text: method?.name ?? '');
    _descriptionController =
        TextEditingController(text: method?.description ?? '');
    _priceController = TextEditingController(
        text: method?.price != null ? method!.price.toString() : '');
    _freeFromController = TextEditingController(
        text: method?.freeFrom != null ? method!.freeFrom.toString() : '');
    _minDaysController = TextEditingController(
        text: method?.minDays != null ? method!.minDays.toString() : '');
    _maxDaysController = TextEditingController(
        text: method?.maxDays != null ? method!.maxDays.toString() : '');

    _hasFreeFrom = method?.freeFrom != null;
    _isActive = method?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _freeFromController.dispose();
    _minDaysController.dispose();
    _maxDaysController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.85,
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
                        widget.method != null
                            ? 'Editar método'
                            : 'Nuevo método de envío',
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
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Nombre *',
                            hintText: 'Ej: Envío estándar',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.zero),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'El nombre es obligatorio';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _descriptionController,
                          decoration: const InputDecoration(
                            labelText: 'Descripción',
                            hintText: 'Ej: Entrega en 3-5 días laborables',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.zero),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _priceController,
                          decoration: const InputDecoration(
                            labelText: 'Precio *',
                            prefixText: '€ ',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.zero),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'El precio es obligatorio';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Envío gratis a partir de'),
                          value: _hasFreeFrom,
                          onChanged: (value) =>
                              setState(() => _hasFreeFrom = value),
                        ),
                        if (_hasFreeFrom)
                          TextFormField(
                            controller: _freeFromController,
                            decoration: const InputDecoration(
                              labelText: 'Gratis desde',
                              prefixText: '€ ',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.zero),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        const SizedBox(height: 16),
                        Text(
                          'Tiempo de entrega',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _minDaysController,
                                decoration: const InputDecoration(
                                  labelText: 'Días mín *',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.zero),
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Requerido';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextFormField(
                                controller: _maxDaysController,
                                decoration: const InputDecoration(
                                  labelText: 'Días máx *',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.zero),
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Requerido';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Método activo'),
                          subtitle: const Text(
                              'Los métodos inactivos no se muestran en el checkout'),
                          value: _isActive,
                          onChanged: (value) =>
                              setState(() => _isActive = value),
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
                        onPressed: _saveMethod,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.brandNavy,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        child: Text(
                          widget.method != null
                              ? 'Guardar cambios'
                              : 'Crear método',
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

  void _saveMethod() {
    if (!_formKey.currentState!.validate()) return;

    final method = _ShippingMethodData(
      id: widget.method?.id ??
          'SHIP-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}',
      name: _nameController.text,
      description: _descriptionController.text,
      price: double.tryParse(_priceController.text) ?? 0,
      freeFrom: _hasFreeFrom && _freeFromController.text.isNotEmpty
          ? double.tryParse(_freeFromController.text)
          : null,
      minDays: int.tryParse(_minDaysController.text) ?? 1,
      maxDays: int.tryParse(_maxDaysController.text) ?? 1,
      isActive: _isActive,
      isDefault: widget.method?.isDefault ?? false,
    );

    widget.onSave(method);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.method != null ? 'Método actualizado' : 'Método creado',
        ),
      ),
    );
  }
}

class _ShippingZoneFormSheet extends StatefulWidget {
  final _ShippingZoneData? zone;
  final List<_ShippingMethodData> availableMethods;
  final Function(_ShippingZoneData) onSave;

  const _ShippingZoneFormSheet({
    this.zone,
    required this.availableMethods,
    required this.onSave,
  });

  @override
  State<_ShippingZoneFormSheet> createState() => _ShippingZoneFormSheetState();
}

class _ShippingZoneFormSheetState extends State<_ShippingZoneFormSheet> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _countriesController;
  late TextEditingController _priceAdjustmentController;

  List<String> _selectedMethods = [];
  bool _hasPriceAdjustment = false;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    final zone = widget.zone;

    _nameController = TextEditingController(text: zone?.name ?? '');
    _countriesController =
        TextEditingController(text: zone?.countries.join(', ') ?? '');
    _priceAdjustmentController = TextEditingController(
        text: zone?.priceAdjustment != null
            ? zone!.priceAdjustment.toString()
            : '');

    _selectedMethods = List.from(zone?.methods ?? []);
    _hasPriceAdjustment = zone?.priceAdjustment != null;
    _isActive = zone?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _countriesController.dispose();
    _priceAdjustmentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.85,
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
                        widget.zone != null
                            ? 'Editar zona'
                            : 'Nueva zona de envío',
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
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Nombre de la zona *',
                            hintText: 'Ej: Península',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.zero),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'El nombre es obligatorio';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _countriesController,
                          decoration: const InputDecoration(
                            labelText: 'Países/Regiones *',
                            hintText: 'Separados por coma',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.zero),
                          ),
                          maxLines: 2,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Añade al menos un país o región';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Aplicar recargo'),
                          subtitle: const Text(
                              'Añade un coste extra al precio del envío'),
                          value: _hasPriceAdjustment,
                          onChanged: (value) =>
                              setState(() => _hasPriceAdjustment = value),
                        ),
                        if (_hasPriceAdjustment) ...[
                          TextFormField(
                            controller: _priceAdjustmentController,
                            decoration: const InputDecoration(
                              labelText: 'Recargo',
                              prefixText: '€ ',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.zero),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 16),
                        ],
                        Text(
                          'Métodos de envío disponibles',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        const SizedBox(height: 8),
                        ...widget.availableMethods.map(
                          (method) => CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(method.name),
                            subtitle: Text(
                              method.description,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                            ),
                            value: _selectedMethods.contains(method.id),
                            onChanged: (value) {
                              setState(() {
                                if (value == true) {
                                  _selectedMethods.add(method.id);
                                } else {
                                  _selectedMethods.remove(method.id);
                                }
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Zona activa'),
                          value: _isActive,
                          onChanged: (value) =>
                              setState(() => _isActive = value),
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
                        onPressed: _saveZone,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.brandNavy,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        child: Text(
                          widget.zone != null
                              ? 'Guardar cambios'
                              : 'Crear zona',
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

  void _saveZone() {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedMethods.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecciona al menos un método de envío'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final countries = _countriesController.text
        .split(',')
        .map((c) => c.trim())
        .where((c) => c.isNotEmpty)
        .toList();

    final zone = _ShippingZoneData(
      id: widget.zone?.id ??
          'ZONE-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}',
      name: _nameController.text,
      countries: countries,
      methods: _selectedMethods,
      isActive: _isActive,
      priceAdjustment:
          _hasPriceAdjustment && _priceAdjustmentController.text.isNotEmpty
              ? double.tryParse(_priceAdjustmentController.text)
              : null,
    );

    widget.onSave(zone);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(widget.zone != null ? 'Zona actualizada' : 'Zona creada'),
      ),
    );
  }
}
