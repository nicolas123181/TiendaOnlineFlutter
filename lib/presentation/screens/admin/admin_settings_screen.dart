import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../config/app_colors.dart';
import '../../providers/flash_offers_provider.dart';

/// Pantalla de configuración general del admin
class AdminSettingsScreen extends ConsumerStatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  ConsumerState<AdminSettingsScreen> createState() =>
      _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends ConsumerState<AdminSettingsScreen> {
  // Configuración general
  String _storeName = 'VANTAGE Fashion';
  String _storeEmail = 'info@vantagefashion.com';
  String _storePhone = '+34 912 345 678';
  String _storeAddress = 'Calle Gran Vía 45, 28013 Madrid, España';
  String _currency = 'EUR';
  String _language = 'es';

  // Configuración de pedidos
  bool _autoConfirmOrders = false;
  bool _notifyNewOrders = true;
  bool _notifyLowStock = true;
  int _lowStockThreshold = 5;

  // Configuración de inventario
  bool _trackInventory = true;
  bool _allowBackorders = false;
  bool _hideOutOfStock = false;

  // Configuración de impuestos
  bool _includeTaxInPrices = true;
  double _defaultTaxRate = 21.0;

  // Configuración de notificaciones
  bool _emailOrderConfirmation = true;
  bool _emailShippingNotification = true;
  bool _emailDeliveryNotification = true;
  bool _smsNotifications = false;

  // Configuración de seguridad
  bool _twoFactorAuth = false;
  bool _autoLogout = true;
  int _sessionTimeout = 30;

  // Ofertas Flash - estado real-time
  bool _flashOffersEnabled = false;
  bool _flashOffersLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFlashOffersState();
  }

  Future<void> _loadFlashOffersState() async {
    final enabled = await FlashOffersService().isFlashOffersEnabled();
    if (mounted) {
      setState(() {
        _flashOffersEnabled = enabled;
        _flashOffersLoading = false;
      });
    }
  }

  Future<void> _toggleFlashOffers(bool value) async {
    setState(() => _flashOffersLoading = true);
    final success = await FlashOffersService().toggleFlashOffers(value);
    if (success) {
      setState(() {
        _flashOffersEnabled = value;
        _flashOffersLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              value ? 'Ofertas Flash activadas' : 'Ofertas Flash desactivadas',
            ),
            backgroundColor: value ? Colors.green : AppColors.textSecondary,
          ),
        );
      }
    } else {
      setState(() => _flashOffersLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al actualizar ofertas flash'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveSettings,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              title: 'Información de la tienda',
              icon: Icons.store,
              children: [
                _buildTextField(
                  label: 'Nombre de la tienda',
                  value: _storeName,
                  onChanged: (value) => setState(() => _storeName = value),
                ),
                _buildTextField(
                  label: 'Email de contacto',
                  value: _storeEmail,
                  onChanged: (value) => setState(() => _storeEmail = value),
                  keyboardType: TextInputType.emailAddress,
                ),
                _buildTextField(
                  label: 'Teléfono',
                  value: _storePhone,
                  onChanged: (value) => setState(() => _storePhone = value),
                  keyboardType: TextInputType.phone,
                ),
                _buildTextField(
                  label: 'Dirección',
                  value: _storeAddress,
                  onChanged: (value) => setState(() => _storeAddress = value),
                  maxLines: 2,
                ),
                _buildDropdown(
                  label: 'Moneda',
                  value: _currency,
                  items: const [
                    DropdownMenuItem(value: 'EUR', child: Text('Euro (€)')),
                    DropdownMenuItem(value: 'USD', child: Text('Dólar (\$)')),
                    DropdownMenuItem(value: 'GBP', child: Text('Libra (£)')),
                  ],
                  onChanged: (value) =>
                      setState(() => _currency = value ?? 'EUR'),
                ),
                _buildDropdown(
                  label: 'Idioma',
                  value: _language,
                  items: const [
                    DropdownMenuItem(value: 'es', child: Text('Español')),
                    DropdownMenuItem(value: 'en', child: Text('English')),
                    DropdownMenuItem(value: 'fr', child: Text('Français')),
                  ],
                  onChanged: (value) =>
                      setState(() => _language = value ?? 'es'),
                ),
              ],
            ),
            // ===== OFERTAS FLASH (REAL-TIME) =====
            _buildSection(
              title: '⚡ Ofertas Flash',
              icon: Icons.flash_on,
              children: [
                _flashOffersLoading
                    ? const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : _buildSwitch(
                        title: 'Activar Ofertas Flash',
                        subtitle:
                            'Muestra la sección de ofertas flash en la app. Los cambios se aplican en tiempo real a todos los usuarios.',
                        value: _flashOffersEnabled,
                        onChanged: _toggleFlashOffers,
                      ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _flashOffersEnabled
                          ? Colors.green.withOpacity(0.1)
                          : AppColors.textSecondary.withOpacity(0.1),
                      border: Border.all(
                        color: _flashOffersEnabled
                            ? Colors.green.withOpacity(0.3)
                            : AppColors.border,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _flashOffersEnabled
                              ? Icons.check_circle
                              : Icons.info_outline,
                          color: _flashOffersEnabled
                              ? Colors.green
                              : AppColors.textSecondary,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _flashOffersEnabled
                                ? 'Las ofertas flash se están mostrando a todos los clientes'
                                : 'Las ofertas flash están ocultas para los clientes',
                            style: TextStyle(
                              fontSize: 13,
                              color: _flashOffersEnabled
                                  ? Colors.green.shade700
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            _buildSection(
              title: 'Pedidos',
              icon: Icons.shopping_bag,
              children: [
                _buildSwitch(
                  title: 'Confirmar pedidos automáticamente',
                  subtitle: 'Los pedidos se confirman sin intervención manual',
                  value: _autoConfirmOrders,
                  onChanged: (value) =>
                      setState(() => _autoConfirmOrders = value),
                ),
                _buildSwitch(
                  title: 'Notificar nuevos pedidos',
                  subtitle: 'Recibir notificaciones al recibir un pedido',
                  value: _notifyNewOrders,
                  onChanged: (value) =>
                      setState(() => _notifyNewOrders = value),
                ),
                _buildSwitch(
                  title: 'Alerta de stock bajo',
                  subtitle: 'Notificar cuando un producto tenga poco stock',
                  value: _notifyLowStock,
                  onChanged: (value) => setState(() => _notifyLowStock = value),
                ),
                if (_notifyLowStock)
                  _buildSlider(
                    label: 'Umbral de stock bajo',
                    value: _lowStockThreshold.toDouble(),
                    min: 1,
                    max: 20,
                    divisions: 19,
                    onChanged: (value) =>
                        setState(() => _lowStockThreshold = value.toInt()),
                    suffix: ' unidades',
                  ),
              ],
            ),
            _buildSection(
              title: 'Inventario',
              icon: Icons.inventory,
              children: [
                _buildSwitch(
                  title: 'Seguimiento de inventario',
                  subtitle: 'Gestionar automáticamente el stock de productos',
                  value: _trackInventory,
                  onChanged: (value) => setState(() => _trackInventory = value),
                ),
                _buildSwitch(
                  title: 'Permitir reservas',
                  subtitle: 'Permitir comprar productos sin stock',
                  value: _allowBackorders,
                  onChanged: (value) =>
                      setState(() => _allowBackorders = value),
                ),
                _buildSwitch(
                  title: 'Ocultar productos sin stock',
                  subtitle: 'No mostrar productos agotados en la tienda',
                  value: _hideOutOfStock,
                  onChanged: (value) => setState(() => _hideOutOfStock = value),
                ),
              ],
            ),
            _buildSection(
              title: 'Impuestos',
              icon: Icons.receipt,
              children: [
                _buildSwitch(
                  title: 'IVA incluido en precios',
                  subtitle: 'Los precios mostrados incluyen impuestos',
                  value: _includeTaxInPrices,
                  onChanged: (value) =>
                      setState(() => _includeTaxInPrices = value),
                ),
                _buildSlider(
                  label: 'Tasa de IVA por defecto',
                  value: _defaultTaxRate,
                  min: 0,
                  max: 25,
                  divisions: 25,
                  onChanged: (value) => setState(() => _defaultTaxRate = value),
                  suffix: '%',
                ),
              ],
            ),
            _buildSection(
              title: 'Notificaciones al cliente',
              icon: Icons.notifications,
              children: [
                _buildSwitch(
                  title: 'Confirmación de pedido',
                  subtitle: 'Enviar email al confirmar un pedido',
                  value: _emailOrderConfirmation,
                  onChanged: (value) =>
                      setState(() => _emailOrderConfirmation = value),
                ),
                _buildSwitch(
                  title: 'Notificación de envío',
                  subtitle: 'Enviar email cuando el pedido se envía',
                  value: _emailShippingNotification,
                  onChanged: (value) =>
                      setState(() => _emailShippingNotification = value),
                ),
                _buildSwitch(
                  title: 'Notificación de entrega',
                  subtitle: 'Enviar email cuando el pedido se entrega',
                  value: _emailDeliveryNotification,
                  onChanged: (value) =>
                      setState(() => _emailDeliveryNotification = value),
                ),
                _buildSwitch(
                  title: 'Notificaciones SMS',
                  subtitle: 'Enviar SMS además de emails',
                  value: _smsNotifications,
                  onChanged: (value) =>
                      setState(() => _smsNotifications = value),
                ),
              ],
            ),
            _buildSection(
              title: 'Seguridad',
              icon: Icons.security,
              children: [
                _buildSwitch(
                  title: 'Autenticación de dos factores',
                  subtitle: 'Requerir código adicional al iniciar sesión',
                  value: _twoFactorAuth,
                  onChanged: (value) => setState(() => _twoFactorAuth = value),
                ),
                _buildSwitch(
                  title: 'Cierre de sesión automático',
                  subtitle: 'Cerrar sesión por inactividad',
                  value: _autoLogout,
                  onChanged: (value) => setState(() => _autoLogout = value),
                ),
                if (_autoLogout)
                  _buildSlider(
                    label: 'Tiempo de inactividad',
                    value: _sessionTimeout.toDouble(),
                    min: 5,
                    max: 120,
                    divisions: 23,
                    onChanged: (value) =>
                        setState(() => _sessionTimeout = value.toInt()),
                    suffix: ' minutos',
                  ),
              ],
            ),
            _buildSection(
              title: 'Acciones',
              icon: Icons.build,
              children: [
                _buildActionTile(
                  title: 'Exportar datos',
                  subtitle: 'Descargar todos los datos de la tienda',
                  icon: Icons.download,
                  onTap: _exportData,
                ),
                _buildActionTile(
                  title: 'Importar datos',
                  subtitle: 'Cargar datos desde un archivo',
                  icon: Icons.upload,
                  onTap: _importData,
                ),
                _buildActionTile(
                  title: 'Limpiar caché',
                  subtitle: 'Eliminar datos temporales',
                  icon: Icons.cleaning_services,
                  onTap: _clearCache,
                ),
                _buildActionTile(
                  title: 'Resetear configuración',
                  subtitle: 'Restaurar valores por defecto',
                  icon: Icons.restore,
                  onTap: _resetSettings,
                  isDestructive: true,
                ),
              ],
            ),
            _buildSection(
              title: 'Información del sistema',
              icon: Icons.info,
              children: [
                _buildInfoTile('Versión de la app', '1.0.0'),
                _buildInfoTile('Última actualización', '15/01/2024'),
                _buildInfoTile('Base de datos', 'Supabase'),
                _buildInfoTile('Pasarela de pago', 'Stripe'),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saveSettings,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brandNavy,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              child: const Text('Guardar configuración'),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Row(
            children: [
              Icon(icon, size: 20, color: AppColors.brandNavy),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.brandNavy,
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: children
                .expand((widget) => [
                      widget,
                      if (widget != children.last)
                        const Divider(height: 1, indent: 16, endIndent: 16),
                    ])
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required String value,
    required ValueChanged<String> onChanged,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: 4),
          TextFormField(
            initialValue: value,
            decoration: const InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.zero),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            keyboardType: keyboardType,
            maxLines: maxLines,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: 4),
          DropdownButtonFormField<String>(
            value: value,
            decoration: const InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.zero),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            items: items,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildSwitch({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: AppColors.brandNavy,
    );
  }

  Widget _buildSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required ValueChanged<double> onChanged,
    required String suffix,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                color: AppColors.brandNavy.withValues(alpha: 0.1),
                child: Text(
                  '${value.toInt()}$suffix',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.brandNavy,
                  ),
                ),
              ),
            ],
          ),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
            activeColor: AppColors.brandNavy,
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? AppColors.error : AppColors.brandNavy,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? AppColors.error : null,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  void _saveSettings() {
    // TODO: Guardar configuración en Supabase
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Configuración guardada')),
    );
  }

  void _exportData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Exportando datos...')),
    );
  }

  void _importData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Función de importación próximamente')),
    );
  }

  void _clearCache() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: const Text('Limpiar caché'),
        content: const Text('¿Eliminar todos los datos temporales?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Caché limpiada')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.brandNavy,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            child: const Text('Limpiar'),
          ),
        ],
      ),
    );
  }

  void _resetSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: const Text('Resetear configuración'),
        content: const Text(
          '¿Restaurar todos los valores a su configuración por defecto? Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Resetear valores
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Configuración restaurada')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            child: const Text('Resetear'),
          ),
        ],
      ),
    );
  }
}
