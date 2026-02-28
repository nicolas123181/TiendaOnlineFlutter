import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';

/// Pantalla de Recomendador de Tallas Interactivo
class SizeRecommenderScreen extends StatefulWidget {
  const SizeRecommenderScreen({super.key});

  @override
  State<SizeRecommenderScreen> createState() => _SizeRecommenderScreenState();
}

class _SizeRecommenderScreenState extends State<SizeRecommenderScreen> {
  int _currentStep = 0;
  String? _gender;
  String? _garmentType;
  double? _height;
  double? _weight;
  double? _chest;
  double? _waist;
  double? _hip;
  String? _fit;

  String? _recommendedSize;
  bool _showResult = false;

  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _chestController = TextEditingController();
  final _waistController = TextEditingController();
  final _hipController = TextEditingController();

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    _chestController.dispose();
    _waistController.dispose();
    _hipController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 4) {
      setState(() => _currentStep++);
    } else {
      _calculateSize();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  bool _canProceed() {
    switch (_currentStep) {
      case 0:
        return _gender != null;
      case 1:
        return _garmentType != null;
      case 2:
        return _height != null && _weight != null;
      case 3:
        return _chest != null || _waist != null;
      case 4:
        return _fit != null;
      default:
        return false;
    }
  }

  void _calculateSize() {
    // Algoritmo de recomendación basado en medidas
    String size = 'M';

    if (_garmentType == 'top' || _garmentType == 'outerwear') {
      // Para tops, usar principalmente pecho
      final chest = _chest ?? 0;
      if (_gender == 'hombre') {
        if (chest < 90)
          size = 'S';
        else if (chest < 98)
          size = 'M';
        else if (chest < 106)
          size = 'L';
        else if (chest < 114)
          size = 'XL';
        else
          size = 'XXL';
      } else {
        if (chest < 84)
          size = 'XS';
        else if (chest < 88)
          size = 'S';
        else if (chest < 92)
          size = 'M';
        else if (chest < 96)
          size = 'L';
        else if (chest < 100)
          size = 'XL';
        else
          size = 'XXL';
      }
    } else {
      // Para pantalones/faldas, usar cintura y cadera
      final waist = _waist ?? 0;
      final hip = _hip ?? 0;

      if (_gender == 'hombre') {
        if (waist < 78)
          size = 'S';
        else if (waist < 86)
          size = 'M';
        else if (waist < 94)
          size = 'L';
        else if (waist < 102)
          size = 'XL';
        else
          size = 'XXL';
      } else {
        // Para mujer, considerar cadera también
        final avgMeasure = (waist + hip) / 2;
        if (avgMeasure < 82)
          size = 'XS';
        else if (avgMeasure < 86)
          size = 'S';
        else if (avgMeasure < 91)
          size = 'M';
        else if (avgMeasure < 97)
          size = 'L';
        else if (avgMeasure < 103)
          size = 'XL';
        else
          size = 'XXL';
      }
    }

    // Ajustar según preferencia de ajuste
    if (_fit == 'holgado') {
      final sizes = ['XS', 'S', 'M', 'L', 'XL', 'XXL'];
      final idx = sizes.indexOf(size);
      if (idx < sizes.length - 1) size = sizes[idx + 1];
    } else if (_fit == 'ajustado') {
      final sizes = ['XS', 'S', 'M', 'L', 'XL', 'XXL'];
      final idx = sizes.indexOf(size);
      if (idx > 0) size = sizes[idx - 1];
    }

    setState(() {
      _recommendedSize = size;
      _showResult = true;
    });
  }

  void _reset() {
    setState(() {
      _currentStep = 0;
      _gender = null;
      _garmentType = null;
      _height = null;
      _weight = null;
      _chest = null;
      _waist = null;
      _hip = null;
      _fit = null;
      _recommendedSize = null;
      _showResult = false;
      _heightController.clear();
      _weightController.clear();
      _chestController.clear();
      _waistController.clear();
      _hipController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recomendador de Talla'),
        centerTitle: true,
      ),
      body: _showResult ? _buildResultView() : _buildStepsView(),
    );
  }

  Widget _buildStepsView() {
    return Column(
      children: [
        // Progress indicator
        Container(
          padding: const EdgeInsets.all(20),
          color: AppColors.surface,
          child: Column(
            children: [
              Row(
                children: List.generate(5, (index) {
                  final isActive = index == _currentStep;
                  final isCompleted = index < _currentStep;
                  return Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: index < 4 ? 8 : 0),
                      height: 4,
                      decoration: BoxDecoration(
                        color: isCompleted || isActive
                            ? AppColors.primary
                            : AppColors.border,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 12),
              Text(
                _getStepTitle(_currentStep),
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),

        // Step content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: _buildStepContent(_currentStep),
          ),
        ),

        // Navigation buttons
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Row(
              children: [
                if (_currentStep > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _previousStep,
                      child: const Text('Atrás'),
                    ),
                  ),
                if (_currentStep > 0) const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _canProceed() ? _nextStep : null,
                    child: Text(
                      _currentStep < 4 ? 'Siguiente' : 'Ver mi talla',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _getStepTitle(int step) {
    switch (step) {
      case 0:
        return 'Paso 1 de 5: Género';
      case 1:
        return 'Paso 2 de 5: Tipo de prenda';
      case 2:
        return 'Paso 3 de 5: Altura y peso';
      case 3:
        return 'Paso 4 de 5: Medidas';
      case 4:
        return 'Paso 5 de 5: Preferencia de ajuste';
      default:
        return '';
    }
  }

  Widget _buildStepContent(int step) {
    switch (step) {
      case 0:
        return _buildGenderStep();
      case 1:
        return _buildGarmentTypeStep();
      case 2:
        return _buildMeasurementsStep();
      case 3:
        return _buildBodyMeasurementsStep();
      case 4:
        return _buildFitPreferenceStep();
      default:
        return const SizedBox();
    }
  }

  Widget _buildGenderStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('¿Para quién es la prenda?', style: AppTextStyles.h3),
        const SizedBox(height: 8),
        Text(
          'Selecciona el género para obtener una recomendación más precisa.',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 24),
        _buildOptionCard(
          icon: Icons.man,
          title: 'Hombre',
          isSelected: _gender == 'hombre',
          onTap: () => setState(() => _gender = 'hombre'),
        ),
        const SizedBox(height: 12),
        _buildOptionCard(
          icon: Icons.woman,
          title: 'Mujer',
          isSelected: _gender == 'mujer',
          onTap: () => setState(() => _gender = 'mujer'),
        ),
      ],
    );
  }

  Widget _buildGarmentTypeStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('¿Qué tipo de prenda buscas?', style: AppTextStyles.h3),
        const SizedBox(height: 8),
        Text(
          'Las medidas varían según el tipo de prenda.',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 24),
        _buildOptionCard(
          icon: Icons.checkroom,
          title: 'Parte superior',
          subtitle: 'Camisetas, camisas, jerseys',
          isSelected: _garmentType == 'top',
          onTap: () => setState(() => _garmentType = 'top'),
        ),
        const SizedBox(height: 12),
        _buildOptionCard(
          icon: Icons.accessibility_new,
          title: 'Parte inferior',
          subtitle: 'Pantalones, faldas, shorts',
          isSelected: _garmentType == 'bottom',
          onTap: () => setState(() => _garmentType = 'bottom'),
        ),
        const SizedBox(height: 12),
        _buildOptionCard(
          icon: Icons.dry_cleaning,
          title: 'Abrigos y chaquetas',
          subtitle: 'Ropa de abrigo',
          isSelected: _garmentType == 'outerwear',
          onTap: () => setState(() => _garmentType = 'outerwear'),
        ),
      ],
    );
  }

  Widget _buildMeasurementsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tu altura y peso', style: AppTextStyles.h3),
        const SizedBox(height: 8),
        Text(
          'Estos datos nos ayudan a afinar la recomendación.',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 24),
        _buildMeasureInput(
          label: 'Altura',
          suffix: 'cm',
          controller: _heightController,
          icon: Icons.height,
          onChanged: (value) =>
              setState(() => _height = double.tryParse(value)),
        ),
        const SizedBox(height: 16),
        _buildMeasureInput(
          label: 'Peso',
          suffix: 'kg',
          controller: _weightController,
          icon: Icons.monitor_weight_outlined,
          onChanged: (value) =>
              setState(() => _weight = double.tryParse(value)),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.info.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: AppColors.info),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Esta información es solo para calcular tu talla y no se almacena.',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.info,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBodyMeasurementsStep() {
    final bool isTop = _garmentType == 'top' || _garmentType == 'outerwear';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tus medidas corporales', style: AppTextStyles.h3),
        const SizedBox(height: 8),
        Text(
          'Mide con una cinta métrica pegada al cuerpo.',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 24),

        if (isTop) ...[
          _buildMeasureInputWithGuide(
            label: 'Contorno de pecho',
            suffix: 'cm',
            controller: _chestController,
            icon: Icons.straighten,
            guide:
                'Mide la parte más ancha del pecho, por debajo de las axilas.',
            onChanged: (value) =>
                setState(() => _chest = double.tryParse(value)),
          ),
        ] else ...[
          _buildMeasureInputWithGuide(
            label: 'Contorno de cintura',
            suffix: 'cm',
            controller: _waistController,
            icon: Icons.straighten,
            guide: 'Mide la parte más estrecha de la cintura.',
            onChanged: (value) =>
                setState(() => _waist = double.tryParse(value)),
          ),
          const SizedBox(height: 16),
          _buildMeasureInputWithGuide(
            label: 'Contorno de cadera',
            suffix: 'cm',
            controller: _hipController,
            icon: Icons.straighten,
            guide: 'Mide la parte más ancha de las caderas.',
            onChanged: (value) => setState(() => _hip = double.tryParse(value)),
          ),
        ],

        const SizedBox(height: 24),

        // Visual guide
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              Icon(
                isTop ? Icons.person : Icons.accessibility,
                size: 80,
                color: AppColors.primary.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 16),
              Text(
                isTop
                    ? 'Rodea el pecho con la cinta a la altura del busto'
                    : 'Mantén la cinta horizontal y paralela al suelo',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFitPreferenceStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('¿Cómo te gusta que te quede la ropa?', style: AppTextStyles.h3),
        const SizedBox(height: 8),
        Text(
          'Ajustaremos la recomendación según tu preferencia.',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 24),
        _buildOptionCard(
          icon: Icons.compress,
          title: 'Ajustado',
          subtitle: 'Me gusta que la ropa quede ceñida',
          isSelected: _fit == 'ajustado',
          onTap: () => setState(() => _fit = 'ajustado'),
        ),
        const SizedBox(height: 12),
        _buildOptionCard(
          icon: Icons.check_circle_outline,
          title: 'Normal',
          subtitle: 'Ni muy ajustado ni muy holgado',
          isSelected: _fit == 'normal',
          onTap: () => setState(() => _fit = 'normal'),
        ),
        const SizedBox(height: 12),
        _buildOptionCard(
          icon: Icons.expand,
          title: 'Holgado',
          subtitle: 'Prefiero ropa más suelta y cómoda',
          isSelected: _fit == 'holgado',
          onTap: () => setState(() => _fit = 'holgado'),
        ),
      ],
    );
  }

  Widget _buildResultView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 32),

          // Resultado principal
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary,
                  AppColors.primary.withValues(alpha: 0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  'Tu talla recomendada',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      _recommendedSize!,
                      style: AppTextStyles.h1.copyWith(
                        color: AppColors.primary,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  _getSizeDescription(_recommendedSize!),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Resumen de datos ingresados
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Resumen de tu perfil', style: AppTextStyles.h4),
                const SizedBox(height: 16),
                _buildSummaryRow(
                  'Género',
                  _gender == 'hombre' ? 'Hombre' : 'Mujer',
                ),
                _buildSummaryRow('Tipo de prenda', _getGarmentTypeLabel()),
                if (_height != null)
                  _buildSummaryRow('Altura', '${_height!.toInt()} cm'),
                if (_weight != null)
                  _buildSummaryRow('Peso', '${_weight!.toInt()} kg'),
                if (_chest != null)
                  _buildSummaryRow('Pecho', '${_chest!.toInt()} cm'),
                if (_waist != null)
                  _buildSummaryRow('Cintura', '${_waist!.toInt()} cm'),
                if (_hip != null)
                  _buildSummaryRow('Cadera', '${_hip!.toInt()} cm'),
                _buildSummaryRow('Preferencia', _getFitLabel()),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Nota informativa
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.info.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.lightbulb_outline, color: AppColors.info, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Consejo',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.info,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Si estás entre dos tallas, te recomendamos elegir la más grande para mayor comodidad. '
                        'También puedes consultar la guía de tallas de cada producto para medidas específicas.',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Botones de acción
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _reset,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Volver a empezar'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.shopping_bag_outlined),
                  label: const Text('Ir a comprar'),
                ),
              ),
            ],
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildOptionCard({
    required IconData icon,
    required String title,
    String? subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withValues(alpha: 0.2)
                    : AppColors.border.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.labelLarge.copyWith(
                      color: isSelected ? AppColors.primary : AppColors.text,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: AppColors.primary, size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildMeasureInput({
    required String label,
    required String suffix,
    required TextEditingController controller,
    required IconData icon,
    required Function(String) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textSecondary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.labelMedium),
                const SizedBox(height: 8),
                TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    hintText: 'Ingresa tu $label',
                    suffixText: suffix,
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: onChanged,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMeasureInputWithGuide({
    required String label,
    required String suffix,
    required TextEditingController controller,
    required IconData icon,
    required String guide,
    required Function(String) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.textSecondary),
              const SizedBox(width: 12),
              Expanded(child: Text(label, style: AppTextStyles.labelMedium)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            guide,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              hintText: 'ej: 92',
              suffixText: suffix,
              filled: true,
              fillColor: AppColors.background,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          Text(value, style: AppTextStyles.labelMedium),
        ],
      ),
    );
  }

  String _getGarmentTypeLabel() {
    switch (_garmentType) {
      case 'top':
        return 'Parte superior';
      case 'bottom':
        return 'Parte inferior';
      case 'outerwear':
        return 'Abrigos';
      default:
        return '';
    }
  }

  String _getFitLabel() {
    switch (_fit) {
      case 'ajustado':
        return 'Ajustado';
      case 'normal':
        return 'Normal';
      case 'holgado':
        return 'Holgado';
      default:
        return '';
    }
  }

  String _getSizeDescription(String size) {
    switch (size) {
      case 'XS':
        return 'Extra pequeña - Ideal para cuerpos más pequeños';
      case 'S':
        return 'Pequeña - Para complexiones delgadas';
      case 'M':
        return 'Mediana - La talla más común';
      case 'L':
        return 'Grande - Cómoda y con buen espacio';
      case 'XL':
        return 'Extra grande - Amplia y confortable';
      case 'XXL':
        return 'Doble extra grande - Máximo confort';
      default:
        return '';
    }
  }
}
