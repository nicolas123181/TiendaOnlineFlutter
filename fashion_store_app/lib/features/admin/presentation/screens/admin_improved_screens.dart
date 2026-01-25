// Pantallas mejoradas de admin - Categorías y Pedidos

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../config/theme/app_text_styles.dart';
import '../../../categories/presentation/providers/categories_provider.dart';
import '../providers/categories_admin_provider.dart';
import '../providers/orders_admin_provider.dart';

/// Pantalla mejorada de gestión de categorías con CRUD completo
class AdminCategoriesScreenImproved extends ConsumerWidget {
  const AdminCategoriesScreenImproved({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorías'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCategoryDialog(context, ref),
          ),
        ],
      ),
      body: categoriesAsync.when(
        data: (categories) {
          if (categories.isEmpty) {
            return const Center(child: Text('No hay categorías'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text(category.name, style: AppTextStyles.labelLarge),
                  subtitle: Text(category.description ?? ''),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showCategoryDialog(
                          context,
                          ref,
                          category: category,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Eliminar categoría'),
                              content: const Text(
                                '¿Estás seguro? Esta acción no se puede deshacer.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text('Cancelar'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.red,
                                  ),
                                  child: const Text('Eliminar'),
                                ),
                              ],
                            ),
                          );

                          if (confirmed == true && context.mounted) {
                            try {
                              final deleted = await ref
                                  .read(categoryActionsProvider)
                                  .deleteCategory(category.id);

                              if (!deleted && context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'No se puede eliminar: hay productos en esta categoría',
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              } else {
                                ref.invalidate(categoriesProvider);
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Categoría eliminada'),
                                    ),
                                  );
                                }
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error: $e'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  void _showCategoryDialog(
    BuildContext context,
    WidgetRef ref, {
    dynamic category,
  }) {
    final isEdit = category != null;
    final nameController = TextEditingController(
      text: isEdit ? category.name : '',
    );
    final descriptionController = TextEditingController(
      text: isEdit ? category.description ?? '' : '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEdit ? 'Editar Categoría' : 'Nueva Categoría'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('El nombre es requerido')),
                );
                return;
              }

              try {
                if (isEdit) {
                  await ref
                      .read(categoryActionsProvider)
                      .updateCategory(
                        categoryId: category.id,
                        name: nameController.text.trim(),
                        description: descriptionController.text.trim(),
                      );
                } else {
                  await ref
                      .read(categoryActionsProvider)
                      .createCategory(
                        name: nameController.text.trim(),
                        description: descriptionController.text.trim(),
                      );
                }

                ref.invalidate(categoriesProvider);
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isEdit ? 'Categoría actualizada' : 'Categoría creada',
                      ),
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: Text(isEdit ? 'Actualizar' : 'Crear'),
          ),
        ],
      ),
    );
  }
}

/// Pantalla mejorada de gestión de pedidos con cambios de estado
class AdminOrdersScreenImproved extends ConsumerStatefulWidget {
  const AdminOrdersScreenImproved({super.key});

  @override
  ConsumerState<AdminOrdersScreenImproved> createState() =>
      _AdminOrdersScreenImprovedState();
}

class _AdminOrdersScreenImprovedState
    extends ConsumerState<AdminOrdersScreenImproved> {
  String _filterStatus = 'all';

  @override
  Widget build(BuildContext context) {
    final ordersAsync = ref.watch(ordersListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Gestión de Pedidos')),
      body: Column(
        children: [
          // Filtros de estado
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                FilterChip(
                  label: const Text('Todos'),
                  selected: _filterStatus == 'all',
                  onSelected: (selected) {
                    if (selected) setState(() => _filterStatus = 'all');
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Pagados'),
                  selected: _filterStatus == 'paid',
                  onSelected: (selected) {
                    if (selected) setState(() => _filterStatus = 'paid');
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Listos'),
                  selected: _filterStatus == 'ready_for_pickup',
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => _filterStatus = 'ready_for_pickup');
                    }
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Enviados'),
                  selected: _filterStatus == 'shipped',
                  onSelected: (selected) {
                    if (selected) setState(() => _filterStatus = 'shipped');
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Entregados'),
                  selected: _filterStatus == 'delivered',
                  onSelected: (selected) {
                    if (selected) setState(() => _filterStatus = 'delivered');
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Lista de pedidos
          Expanded(
            child: ordersAsync.when(
              data: (orders) {
                // Filtrar por estado
                var filteredOrders = orders.where((o) {
                  if (_filterStatus == 'all') return true;
                  return o['status'] == _filterStatus;
                }).toList();

                if (filteredOrders.isEmpty) {
                  return const Center(child: Text('No hay pedidos'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredOrders.length,
                  itemBuilder: (context, index) {
                    final order = filteredOrders[index];
                    final total = (order['total'] ?? 0) / 100.0;
                    final status = order['status'] ?? '';
                    final orderId = order['order_id'] ?? '';

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ExpansionTile(
                        leading: _getStatusIcon(status),
                        title: Text(
                          'Pedido #$orderId',
                          style: AppTextStyles.labelLarge,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text('\$${total.toStringAsFixed(2)}'),
                            const SizedBox(height: 4),
                            Text(
                              DateFormat(
                                'dd/MM/yyyy HH:mm',
                              ).format(DateTime.parse(order['created_at'])),
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        trailing: _getStatusChip(status),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Botones de acción
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    if (status == 'paid')
                                      ElevatedButton.icon(
                                        onPressed: () => _updateStatus(
                                          order['id'],
                                          'ready_for_pickup',
                                          'Pedido marcado como listo',
                                        ),
                                        icon: const Icon(
                                          Icons.check_circle,
                                          size: 18,
                                        ),
                                        label: const Text('Marcar Listo'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue,
                                          foregroundColor: Colors.white,
                                        ),
                                      ),
                                    if (status == 'ready_for_pickup')
                                      ElevatedButton.icon(
                                        onPressed: () => _updateStatus(
                                          order['id'],
                                          'shipped',
                                          'Pedido marcado como enviado',
                                        ),
                                        icon: const Icon(
                                          Icons.local_shipping,
                                          size: 18,
                                        ),
                                        label: const Text('Marcar Enviado'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.orange,
                                          foregroundColor: Colors.white,
                                        ),
                                      ),
                                    if (status == 'shipped')
                                      ElevatedButton.icon(
                                        onPressed: () async {
                                          await ref
                                              .read(orderActionsProvider)
                                              .markAsDelivered(order['id']);
                                          _showSuccess(
                                            'Pedido marcado como entregado',
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.done_all,
                                          size: 18,
                                        ),
                                        label: const Text('Marcar Entregado'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          foregroundColor: Colors.white,
                                        ),
                                      ),
                                    if (status != 'cancelled' &&
                                        status != 'delivered')
                                      ElevatedButton.icon(
                                        onPressed: () =>
                                            _cancelOrder(order['id']),
                                        icon: const Icon(
                                          Icons.cancel,
                                          size: 18,
                                        ),
                                        label: const Text('Cancelar'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          foregroundColor: Colors.white,
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _updateStatus(
    int orderId,
    String newStatus,
    String message,
  ) async {
    await ref
        .read(orderActionsProvider)
        .updateOrderStatus(orderId: orderId, newStatus: newStatus);
    _showSuccess(message);
  }

  Future<void> _cancelOrder(int orderId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancelar pedido'),
        content: const Text('¿Estás seguro de cancelar este pedido?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sí, cancelar'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await ref
          .read(orderActionsProvider)
          .cancelOrder(orderId: orderId, reason: 'Cancelado por admin');
      _showSuccess('Pedido cancelado');
    }
  }

  void _showSuccess(String message) {
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  Widget _getStatusIcon(String status) {
    switch (status) {
      case 'paid':
        return const Icon(Icons.payment, color: Colors.blue);
      case 'ready_for_pickup':
        return const Icon(Icons.inventory, color: Colors.orange);
      case 'shipped':
        return const Icon(Icons.local_shipping, color: Colors.purple);
      case 'delivered':
        return const Icon(Icons.check_circle, color: Colors.green);
      case 'cancelled':
        return const Icon(Icons.cancel, color: Colors.red);
      default:
        return const Icon(Icons.shopping_bag);
    }
  }

  Widget _getStatusChip(String status) {
    Color color;
    String label;

    switch (status) {
      case 'paid':
        color = Colors.blue;
        label = 'Pagado';
        break;
      case 'ready_for_pickup':
        color = Colors.orange;
        label = 'Listo';
        break;
      case 'shipped':
        color = Colors.purple;
        label = 'Enviado';
        break;
      case 'delivered':
        color = Colors.green;
        label = 'Entregado';
        break;
      case 'cancelled':
        color = Colors.red;
        label = 'Cancelado';
        break;
      default:
        color = Colors.grey;
        label = 'Pendiente';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
