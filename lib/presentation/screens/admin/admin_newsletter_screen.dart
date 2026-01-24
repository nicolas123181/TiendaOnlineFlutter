import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../config/app_colors.dart';

/// Pantalla de gestión de newsletter del admin
class AdminNewsletterScreen extends ConsumerStatefulWidget {
  const AdminNewsletterScreen({super.key});

  @override
  ConsumerState<AdminNewsletterScreen> createState() =>
      _AdminNewsletterScreenState();
}

class _AdminNewsletterScreenState extends ConsumerState<AdminNewsletterScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();

  // Datos de ejemplo
  final List<_SubscriberData> _subscribers = [
    _SubscriberData(
      id: 'SUB-001',
      email: 'juan.garcia@email.com',
      name: 'Juan García',
      subscribedAt: DateTime.now().subtract(const Duration(days: 120)),
      source: 'footer',
      isActive: true,
    ),
    _SubscriberData(
      id: 'SUB-002',
      email: 'maria.lopez@email.com',
      name: 'María López',
      subscribedAt: DateTime.now().subtract(const Duration(days: 90)),
      source: 'checkout',
      isActive: true,
    ),
    _SubscriberData(
      id: 'SUB-003',
      email: 'carlos.rodriguez@email.com',
      name: 'Carlos Rodríguez',
      subscribedAt: DateTime.now().subtract(const Duration(days: 60)),
      source: 'popup',
      isActive: true,
    ),
    _SubscriberData(
      id: 'SUB-004',
      email: 'ana.martinez@email.com',
      name: 'Ana Martínez',
      subscribedAt: DateTime.now().subtract(const Duration(days: 45)),
      source: 'register',
      isActive: false,
    ),
    _SubscriberData(
      id: 'SUB-005',
      email: 'pedro.sanchez@email.com',
      name: null,
      subscribedAt: DateTime.now().subtract(const Duration(days: 30)),
      source: 'footer',
      isActive: true,
    ),
  ];

  final List<_CampaignData> _campaigns = [
    _CampaignData(
      id: 'CAMP-001',
      subject: 'Nueva colección Otoño/Invierno 2024',
      status: 'sent',
      sentAt: DateTime.now().subtract(const Duration(days: 7)),
      recipientCount: 1250,
      openRate: 45.2,
      clickRate: 12.5,
    ),
    _CampaignData(
      id: 'CAMP-002',
      subject: '¡Rebajas de verano! Hasta 50% de descuento',
      status: 'sent',
      sentAt: DateTime.now().subtract(const Duration(days: 30)),
      recipientCount: 1180,
      openRate: 52.8,
      clickRate: 18.3,
    ),
    _CampaignData(
      id: 'CAMP-003',
      subject: 'Black Friday: Adelanto exclusivo',
      status: 'draft',
      scheduledAt: DateTime.now().add(const Duration(days: 15)),
      recipientCount: 0,
      openRate: 0,
      clickRate: 0,
    ),
    _CampaignData(
      id: 'CAMP-004',
      subject: 'Tu carrito te espera',
      status: 'scheduled',
      scheduledAt: DateTime.now().add(const Duration(days: 1)),
      recipientCount: 45,
      openRate: 0,
      clickRate: 0,
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
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Newsletter'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.brandGold,
          tabs: [
            Tab(text: 'Suscriptores (${_subscribers.length})'),
            Tab(text: 'Campañas (${_campaigns.length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSubscribersTab(),
          _buildCampaignsTab(),
        ],
      ),
    );
  }

  Widget _buildSubscribersTab() {
    final activeCount = _subscribers.where((s) => s.isActive).length;
    final inactiveCount = _subscribers.where((s) => !s.isActive).length;

    return Column(
      children: [
        // Estadísticas
        Container(
          padding: const EdgeInsets.all(16),
          color: AppColors.surface,
          child: Row(
            children: [
              _StatBox(
                label: 'Total',
                value: '${_subscribers.length}',
                icon: Icons.people,
              ),
              const SizedBox(width: 12),
              _StatBox(
                label: 'Activos',
                value: '$activeCount',
                icon: Icons.check_circle,
                color: AppColors.success,
              ),
              const SizedBox(width: 12),
              _StatBox(
                label: 'Inactivos',
                value: '$inactiveCount',
                icon: Icons.cancel,
                color: AppColors.error,
              ),
            ],
          ),
        ),

        // Búsqueda y acciones
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Buscar suscriptores...',
                    prefixIcon: const Icon(Icons.search),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              const SizedBox(width: 12),
              PopupMenuButton<String>(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                icon: const Icon(Icons.more_vert),
                onSelected: (value) {
                  switch (value) {
                    case 'export':
                      _exportSubscribers();
                      break;
                    case 'import':
                      _importSubscribers();
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'export',
                    child: ListTile(
                      leading: Icon(Icons.file_download),
                      title: Text('Exportar CSV'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'import',
                    child: ListTile(
                      leading: Icon(Icons.file_upload),
                      title: Text('Importar CSV'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Lista de suscriptores
        Expanded(
          child: _getFilteredSubscribers().isEmpty
              ? _buildEmptySubscribers()
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _getFilteredSubscribers().length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final subscriber = _getFilteredSubscribers()[index];
                    return _SubscriberTile(
                      subscriber: subscriber,
                      onToggle: () => _toggleSubscriber(subscriber),
                      onDelete: () => _confirmDeleteSubscriber(subscriber),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildCampaignsTab() {
    return Column(
      children: [
        // Botón crear campaña
        Container(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showCampaignForm(null),
              icon: const Icon(Icons.add),
              label: const Text('Crear nueva campaña'),
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

        // Lista de campañas
        Expanded(
          child: _campaigns.isEmpty
              ? _buildEmptyCampaigns()
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _campaigns.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final campaign = _campaigns[index];
                    return _CampaignCard(
                      campaign: campaign,
                      onTap: () => _showCampaignForm(campaign),
                      onSend: () => _confirmSendCampaign(campaign),
                      onDelete: () => _confirmDeleteCampaign(campaign),
                      onDuplicate: () => _duplicateCampaign(campaign),
                    );
                  },
                ),
        ),
      ],
    );
  }

  List<_SubscriberData> _getFilteredSubscribers() {
    if (_searchController.text.isEmpty) return _subscribers;
    final query = _searchController.text.toLowerCase();
    return _subscribers
        .where((s) =>
            s.email.toLowerCase().contains(query) ||
            (s.name?.toLowerCase().contains(query) ?? false))
        .toList();
  }

  Widget _buildEmptySubscribers() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 64,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: 16),
          Text(
            'No hay suscriptores',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCampaigns() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.mail_outline,
            size: 64,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: 16),
          Text(
            'No hay campañas',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => _showCampaignForm(null),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.brandNavy,
              shape:
                  const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            ),
            child: const Text('Crear campaña'),
          ),
        ],
      ),
    );
  }

  void _toggleSubscriber(_SubscriberData subscriber) {
    setState(() {
      final index = _subscribers.indexWhere((s) => s.id == subscriber.id);
      if (index != -1) {
        _subscribers[index] = _SubscriberData(
          id: subscriber.id,
          email: subscriber.email,
          name: subscriber.name,
          subscribedAt: subscriber.subscribedAt,
          source: subscriber.source,
          isActive: !subscriber.isActive,
        );
      }
    });
  }

  void _confirmDeleteSubscriber(_SubscriberData subscriber) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: const Text('Eliminar suscriptor'),
        content: Text('¿Eliminar a "${subscriber.email}" de la lista?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _subscribers.removeWhere((s) => s.id == subscriber.id);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Suscriptor eliminado')),
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

  void _exportSubscribers() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Exportando suscriptores...')),
    );
  }

  void _importSubscribers() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Función de importación próximamente')),
    );
  }

  void _showCampaignForm(_CampaignData? campaign) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      builder: (context) => _CampaignFormSheet(
        campaign: campaign,
        subscriberCount: _subscribers.where((s) => s.isActive).length,
        onSave: (newCampaign) {
          setState(() {
            if (campaign != null) {
              final index = _campaigns.indexWhere((c) => c.id == campaign.id);
              if (index != -1) {
                _campaigns[index] = newCampaign;
              }
            } else {
              _campaigns.insert(0, newCampaign);
            }
          });
        },
      ),
    );
  }

  void _confirmSendCampaign(_CampaignData campaign) {
    final activeSubscribers = _subscribers.where((s) => s.isActive).length;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: const Text('Enviar campaña'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('¿Enviar "${campaign.subject}"?'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              color: AppColors.info.withValues(alpha: 0.1),
              child: Row(
                children: [
                  const Icon(Icons.info, color: AppColors.info),
                  const SizedBox(width: 8),
                  Text(
                    'Se enviará a $activeSubscribers suscriptores activos',
                    style: const TextStyle(color: AppColors.info),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                final index = _campaigns.indexWhere((c) => c.id == campaign.id);
                if (index != -1) {
                  _campaigns[index] = _CampaignData(
                    id: campaign.id,
                    subject: campaign.subject,
                    status: 'sent',
                    sentAt: DateTime.now(),
                    recipientCount: activeSubscribers,
                    openRate: 0,
                    clickRate: 0,
                  );
                }
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Campaña enviada')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.brandNavy,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            child: const Text('Enviar ahora'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteCampaign(_CampaignData campaign) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: const Text('Eliminar campaña'),
        content: Text('¿Eliminar la campaña "${campaign.subject}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _campaigns.removeWhere((c) => c.id == campaign.id);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Campaña eliminada')),
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

  void _duplicateCampaign(_CampaignData campaign) {
    setState(() {
      _campaigns.insert(
        0,
        _CampaignData(
          id: 'CAMP-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}',
          subject: '${campaign.subject} (copia)',
          status: 'draft',
          recipientCount: 0,
          openRate: 0,
          clickRate: 0,
        ),
      );
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Campaña duplicada')),
    );
  }
}

// Modelos de datos
class _SubscriberData {
  final String id;
  final String email;
  final String? name;
  final DateTime subscribedAt;
  final String source;
  final bool isActive;

  _SubscriberData({
    required this.id,
    required this.email,
    this.name,
    required this.subscribedAt,
    required this.source,
    required this.isActive,
  });
}

class _CampaignData {
  final String id;
  final String subject;
  final String status; // 'draft', 'scheduled', 'sent'
  final DateTime? sentAt;
  final DateTime? scheduledAt;
  final int recipientCount;
  final double openRate;
  final double clickRate;

  _CampaignData({
    required this.id,
    required this.subject,
    required this.status,
    this.sentAt,
    this.scheduledAt,
    required this.recipientCount,
    required this.openRate,
    required this.clickRate,
  });
}

// Widgets auxiliares
class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? color;

  const _StatBox({
    required this.label,
    required this.value,
    required this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final displayColor = color ?? AppColors.brandNavy;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: displayColor.withValues(alpha: 0.1),
          border: Border.all(color: displayColor.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: displayColor, size: 24),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: displayColor,
                    ),
                  ),
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: displayColor,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SubscriberTile extends StatelessWidget {
  final _SubscriberData subscriber;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const _SubscriberTile({
    required this.subscriber,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');

    String sourceText;
    switch (subscriber.source) {
      case 'footer':
        sourceText = 'Footer';
        break;
      case 'checkout':
        sourceText = 'Checkout';
        break;
      case 'popup':
        sourceText = 'Popup';
        break;
      case 'register':
        sourceText = 'Registro';
        break;
      default:
        sourceText = subscriber.source;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            backgroundColor: subscriber.isActive
                ? AppColors.brandNavy.withValues(alpha: 0.1)
                : AppColors.error.withValues(alpha: 0.1),
            child: Text(
              subscriber.email[0].toUpperCase(),
              style: TextStyle(
                color:
                    subscriber.isActive ? AppColors.brandNavy : AppColors.error,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        subscriber.name ?? subscriber.email,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      color: subscriber.isActive
                          ? AppColors.success.withValues(alpha: 0.1)
                          : AppColors.error.withValues(alpha: 0.1),
                      child: Text(
                        subscriber.isActive ? 'Activo' : 'Inactivo',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: subscriber.isActive
                              ? AppColors.success
                              : AppColors.error,
                        ),
                      ),
                    ),
                  ],
                ),
                if (subscriber.name != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subscriber.email,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      dateFormat.format(subscriber.subscribedAt),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textTertiary,
                          ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.textTertiary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      sourceText,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textTertiary,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Acciones
          PopupMenuButton<String>(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
            onSelected: (value) {
              switch (value) {
                case 'toggle':
                  onToggle();
                  break;
                case 'delete':
                  onDelete();
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'toggle',
                child: ListTile(
                  leading: Icon(
                    subscriber.isActive ? Icons.person_off : Icons.person,
                  ),
                  title: Text(subscriber.isActive ? 'Desactivar' : 'Activar'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: ListTile(
                  leading: Icon(Icons.delete, color: AppColors.error),
                  title: Text('Eliminar',
                      style: TextStyle(color: AppColors.error)),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CampaignCard extends StatelessWidget {
  final _CampaignData campaign;
  final VoidCallback onTap;
  final VoidCallback onSend;
  final VoidCallback onDelete;
  final VoidCallback onDuplicate;

  const _CampaignCard({
    required this.campaign,
    required this.onTap,
    required this.onSend,
    required this.onDelete,
    required this.onDuplicate,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (campaign.status) {
      case 'sent':
        statusColor = AppColors.success;
        statusText = 'Enviada';
        statusIcon = Icons.check_circle;
        break;
      case 'scheduled':
        statusColor = AppColors.info;
        statusText = 'Programada';
        statusIcon = Icons.schedule;
        break;
      default:
        statusColor = AppColors.warning;
        statusText = 'Borrador';
        statusIcon = Icons.edit;
    }

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
                Icon(statusIcon, color: statusColor, size: 20),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  color: statusColor.withValues(alpha: 0.1),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ),
                const Spacer(),
                if (campaign.status == 'sent')
                  Text(
                    dateFormat.format(campaign.sentAt!),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  )
                else if (campaign.scheduledAt != null)
                  Text(
                    'Programada: ${dateFormat.format(campaign.scheduledAt!)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
              ],
            ),
            const SizedBox(height: 12),

            // Asunto
            Text(
              campaign.subject,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),

            // Métricas (solo para campañas enviadas)
            if (campaign.status == 'sent') ...[
              Row(
                children: [
                  _MetricBox(
                    label: 'Enviados',
                    value: '${campaign.recipientCount}',
                    icon: Icons.send,
                  ),
                  const SizedBox(width: 12),
                  _MetricBox(
                    label: 'Apertura',
                    value: '${campaign.openRate.toStringAsFixed(1)}%',
                    icon: Icons.visibility,
                  ),
                  const SizedBox(width: 12),
                  _MetricBox(
                    label: 'Clicks',
                    value: '${campaign.clickRate.toStringAsFixed(1)}%',
                    icon: Icons.touch_app,
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],

            // Acciones
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (campaign.status != 'sent')
                  TextButton.icon(
                    onPressed: onSend,
                    icon: const Icon(Icons.send, size: 18),
                    label: const Text('Enviar'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.brandNavy,
                    ),
                  ),
                TextButton.icon(
                  onPressed: onDuplicate,
                  icon: const Icon(Icons.copy, size: 18),
                  label: const Text('Duplicar'),
                ),
                TextButton.icon(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete, size: 18),
                  label: const Text('Eliminar'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.error,
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

class _MetricBox extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _MetricBox({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8),
        color: AppColors.border.withValues(alpha: 0.3),
        child: Column(
          children: [
            Icon(icon, size: 16, color: AppColors.textSecondary),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CampaignFormSheet extends StatefulWidget {
  final _CampaignData? campaign;
  final int subscriberCount;
  final Function(_CampaignData) onSave;

  const _CampaignFormSheet({
    this.campaign,
    required this.subscriberCount,
    required this.onSave,
  });

  @override
  State<_CampaignFormSheet> createState() => _CampaignFormSheetState();
}

class _CampaignFormSheetState extends State<_CampaignFormSheet> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _subjectController;
  late TextEditingController _contentController;
  bool _isScheduled = false;
  DateTime _scheduledDate = DateTime.now().add(const Duration(days: 1));

  @override
  void initState() {
    super.initState();
    final campaign = widget.campaign;

    _subjectController = TextEditingController(text: campaign?.subject ?? '');
    _contentController = TextEditingController();

    if (campaign != null) {
      _isScheduled = campaign.status == 'scheduled';
      if (campaign.scheduledAt != null) {
        _scheduledDate = campaign.scheduledAt!;
      }
    }
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _contentController.dispose();
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
                        widget.campaign != null
                            ? 'Editar campaña'
                            : 'Nueva campaña',
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
                        // Info de destinatarios
                        Container(
                          padding: const EdgeInsets.all(12),
                          color: AppColors.info.withValues(alpha: 0.1),
                          child: Row(
                            children: [
                              const Icon(Icons.people, color: AppColors.info),
                              const SizedBox(width: 8),
                              Text(
                                '${widget.subscriberCount} suscriptores activos recibirán este email',
                                style: const TextStyle(color: AppColors.info),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Asunto
                        TextFormField(
                          controller: _subjectController,
                          decoration: const InputDecoration(
                            labelText: 'Asunto del email *',
                            hintText: 'Ej: ¡Nueva colección disponible!',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.zero),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'El asunto es obligatorio';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Contenido
                        TextFormField(
                          controller: _contentController,
                          decoration: const InputDecoration(
                            labelText: 'Contenido del email',
                            hintText: 'Escribe el contenido de tu campaña...',
                            alignLabelWithHint: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.zero),
                          ),
                          maxLines: 10,
                        ),
                        const SizedBox(height: 16),

                        // Programar envío
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Programar envío'),
                          subtitle: const Text(
                              'Enviar automáticamente en la fecha seleccionada'),
                          value: _isScheduled,
                          onChanged: (value) =>
                              setState(() => _isScheduled = value),
                        ),

                        if (_isScheduled) ...[
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.calendar_today),
                            title: const Text('Fecha y hora de envío'),
                            subtitle: Text(
                              DateFormat('dd/MM/yyyy HH:mm')
                                  .format(_scheduledDate),
                            ),
                            onTap: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: _scheduledDate,
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now()
                                    .add(const Duration(days: 365)),
                              );
                              if (date != null && context.mounted) {
                                final time = await showTimePicker(
                                  context: context,
                                  initialTime:
                                      TimeOfDay.fromDateTime(_scheduledDate),
                                );
                                if (time != null) {
                                  setState(() {
                                    _scheduledDate = DateTime(
                                      date.year,
                                      date.month,
                                      date.day,
                                      time.hour,
                                      time.minute,
                                    );
                                  });
                                }
                              }
                            },
                          ),
                        ],
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
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              if (!_formKey.currentState!.validate()) return;
                              _saveCampaign('draft');
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                            ),
                            child: const Text('Guardar borrador'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (!_formKey.currentState!.validate()) return;
                              _saveCampaign(
                                  _isScheduled ? 'scheduled' : 'draft');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.brandNavy,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                            ),
                            child: Text(_isScheduled ? 'Programar' : 'Guardar'),
                          ),
                        ),
                      ],
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

  void _saveCampaign(String status) {
    final campaign = _CampaignData(
      id: widget.campaign?.id ??
          'CAMP-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}',
      subject: _subjectController.text,
      status: status,
      scheduledAt: _isScheduled ? _scheduledDate : null,
      recipientCount: widget.subscriberCount,
      openRate: 0,
      clickRate: 0,
    );

    widget.onSave(campaign);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.campaign != null
              ? 'Campaña actualizada'
              : status == 'scheduled'
                  ? 'Campaña programada'
                  : 'Campaña guardada como borrador',
        ),
      ),
    );
  }
}
