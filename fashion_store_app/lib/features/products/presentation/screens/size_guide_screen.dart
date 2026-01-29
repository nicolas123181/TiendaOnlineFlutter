import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../shared/widgets/custom_app_bar.dart';

/// Pantalla de guía de tallas
class SizeGuideScreen extends ConsumerStatefulWidget {
  const SizeGuideScreen({super.key});

  @override
  ConsumerState<SizeGuideScreen> createState() => _SizeGuideScreenState();
}

class _SizeGuideScreenState extends ConsumerState<SizeGuideScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'GUÍA DE TALLAS', showCart: false),
      body: Column(
        children: [
          // Información de cómo medir
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.primary.withValues(alpha: 0.05),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: AppColors.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Para obtener la mejor medida, usa una cinta métrica flexible',
                    style: AppTextStyles.bodySmall,
                  ),
                ),
              ],
            ),
          ),

          // Tabs
          Container(
            color: AppColors.surface,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorColor: AppColors.primary,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondary,
              tabs: const [
                Tab(text: 'Camisas'),
                Tab(text: 'Camisetas'),
                Tab(text: 'Pantalones'),
                Tab(text: 'Trajes'),
              ],
            ),
          ),

          // Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildShirtsGuide(),
                _buildTShirtsGuide(),
                _buildPantsGuide(),
                _buildSuitsGuide(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShirtsGuide() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Camisas', style: AppTextStyles.h3),
          const SizedBox(height: 16),

          // Cómo medir
          _buildMeasurementInstructions([
            'Contorno de cuello: Mide alrededor del cuello donde normalmente se abrocha el botón',
            'Contorno de pecho: Mide la parte más ancha del pecho',
            'Largo de manga: Desde el hombro hasta la muñeca con el brazo ligeramente doblado',
          ]),

          const SizedBox(height: 24),

          // Tabla de tallas
          _buildSizeTable(
            headers: ['Talla', 'Cuello (cm)', 'Pecho (cm)', 'Manga (cm)'],
            rows: [
              ['S', '37-38', '92-96', '59-60'],
              ['M', '39-40', '97-101', '61-62'],
              ['L', '41-42', '102-106', '63-64'],
              ['XL', '43-44', '107-112', '65-66'],
              ['XXL', '45-46', '113-118', '67-68'],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTShirtsGuide() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Camisetas', style: AppTextStyles.h3),
          const SizedBox(height: 16),

          _buildMeasurementInstructions([
            'Contorno de pecho: Mide la parte más ancha del pecho',
            'Largo: Desde el hombro hasta la cadera',
          ]),

          const SizedBox(height: 24),

          _buildSizeTable(
            headers: ['Talla', 'Pecho (cm)', 'Largo (cm)'],
            rows: [
              ['S', '92-96', '68-70'],
              ['M', '97-101', '71-73'],
              ['L', '102-106', '74-76'],
              ['XL', '107-112', '77-79'],
              ['XXL', '113-118', '80-82'],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPantsGuide() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Pantalones', style: AppTextStyles.h3),
          const SizedBox(height: 16),

          _buildMeasurementInstructions([
            'Cintura: Mide alrededor de tu cintura natural',
            'Cadera: Mide la parte más ancha de las caderas',
            'Largo: Desde la cintura hasta el tobillo',
          ]),

          const SizedBox(height: 24),

          _buildSizeTable(
            headers: ['Talla', 'Cintura (cm)', 'Cadera (cm)', 'Largo (cm)'],
            rows: [
              ['38', '76-79', '92-95', '102-104'],
              ['40', '80-83', '96-99', '104-106'],
              ['42', '84-87', '100-103', '106-108'],
              ['44', '88-91', '104-107', '108-110'],
              ['46', '92-96', '108-112', '110-112'],
              ['48', '97-101', '113-117', '112-114'],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSuitsGuide() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Trajes', style: AppTextStyles.h3),
          const SizedBox(height: 16),

          _buildMeasurementInstructions([
            'Contorno de pecho: Mide la parte más ancha del pecho',
            'Contorno de cintura: Mide alrededor de la cintura natural',
            'Largo de chaqueta: Desde el cuello hasta donde deseas que termine',
            'Largo de manga: Desde el hombro hasta la muñeca',
          ]),

          const SizedBox(height: 24),

          _buildSizeTable(
            headers: ['Talla', 'Pecho (cm)', 'Cintura (cm)', 'Altura'],
            rows: [
              ['46', '92-96', '76-80', '170-178'],
              ['48', '97-101', '81-85', '172-180'],
              ['50', '102-106', '86-90', '174-182'],
              ['52', '107-111', '91-95', '176-184'],
              ['54', '112-117', '96-101', '178-186'],
              ['56', '118-123', '102-107', '180-188'],
            ],
          ),

          const SizedBox(height: 24),

          // Nota sobre ajuste personalizado
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.star, color: Colors.amber.shade700),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Para un ajuste perfecto en trajes, recomendamos nuestro servicio de ajuste personalizado',
                    style: AppTextStyles.bodySmall,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMeasurementInstructions(List<String> instructions) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.straighten, color: AppColors.primary),
                const SizedBox(width: 8),
                Text('Cómo medir', style: AppTextStyles.labelLarge),
              ],
            ),
            const SizedBox(height: 12),
            ...instructions.map(
              (instruction) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('• ', style: AppTextStyles.bodyMedium),
                    Expanded(
                      child: Text(instruction, style: AppTextStyles.bodyMedium),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSizeTable({
    required List<String> headers,
    required List<List<String>> rows,
  }) {
    return Card(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(
            AppColors.primary.withValues(alpha: 0.1),
          ),
          columns: headers
              .map(
                (header) => DataColumn(
                  label: Text(header, style: AppTextStyles.labelMedium),
                ),
              )
              .toList(),
          rows: rows
              .map(
                (row) => DataRow(
                  cells: row
                      .map(
                        (cell) => DataCell(
                          Text(cell, style: AppTextStyles.bodyMedium),
                        ),
                      )
                      .toList(),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
