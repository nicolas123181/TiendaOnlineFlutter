import 'package:flutter/material.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';

/// Pantalla de Sobre Nosotros
class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sobre Nosotros'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero section
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
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Text(
                    'VANTAGE',
                    style: AppTextStyles.h1.copyWith(
                      color: Colors.white,
                      letterSpacing: 4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Elegancia en cada detalle',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Nuestra Historia
            _buildSection(
              title: 'Nuestra Historia',
              icon: Icons.auto_stories,
              content:
                  'Vantage nació en 2024 con una visión clara: ofrecer moda de calidad '
                  'a precios accesibles sin comprometer el estilo ni la sostenibilidad. '
                  'Desde nuestros inicios, nos hemos enfocado en crear prendas que combinan '
                  'elegancia atemporal con las últimas tendencias.',
            ),

            const SizedBox(height: 24),

            // Nuestra Filosofía
            _buildSection(
              title: 'Nuestra Filosofía',
              icon: Icons.lightbulb_outline,
              content:
                  'Creemos que la moda debe ser accesible, sostenible y, sobre todo, '
                  'una expresión de quien eres. Cada prenda que diseñamos está pensada para '
                  'durar, tanto en calidad como en estilo. Trabajamos con materiales de primera '
                  'calidad y procesos responsables con el medio ambiente.',
            ),

            const SizedBox(height: 24),

            // Valores
            Text('Nuestros Valores', style: AppTextStyles.h3),
            const SizedBox(height: 16),

            _buildValueCard(
              icon: Icons.eco,
              title: 'Sostenibilidad',
              description: 'Compromiso con el medio ambiente en cada proceso',
              color: Colors.green,
            ),
            const SizedBox(height: 12),
            _buildValueCard(
              icon: Icons.verified,
              title: 'Calidad',
              description: 'Materiales premium y acabados impecables',
              color: Colors.blue,
            ),
            const SizedBox(height: 12),
            _buildValueCard(
              icon: Icons.favorite,
              title: 'Pasión',
              description: 'Amor por la moda y atención al detalle',
              color: Colors.red,
            ),
            const SizedBox(height: 12),
            _buildValueCard(
              icon: Icons.people,
              title: 'Comunidad',
              description:
                  'Construyendo relaciones duraderas con nuestros clientes',
              color: Colors.purple,
            ),

            const SizedBox(height: 32),

            // Contacto
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.email_outlined,
                    size: 40,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 12),
                  Text('¿Tienes alguna pregunta?', style: AppTextStyles.h4),
                  const SizedBox(height: 8),
                  Text(
                    'Contáctanos en info@vantage.com',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required String content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 24),
            const SizedBox(width: 12),
            Text(title, style: AppTextStyles.h3),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          content,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildValueCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.labelLarge),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
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

/// Pantalla de Envíos y Devoluciones
class ShippingReturnsScreen extends StatelessWidget {
  const ShippingReturnsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Envíos y Devoluciones'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Envíos
            _buildSectionHeader(
              icon: Icons.local_shipping,
              title: 'Información de Envío',
              color: Colors.blue,
            ),
            const SizedBox(height: 16),

            _buildInfoCard(
              title: 'Envío Estándar',
              items: [
                'Entrega en 3-5 días laborables',
                'Coste: 4,95€',
                'Gratis en pedidos superiores a 50€',
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoCard(
              title: 'Envío Express',
              items: [
                'Entrega en 24-48 horas',
                'Coste: 7,95€',
                'Disponible en península',
              ],
            ),

            const SizedBox(height: 32),

            // Devoluciones
            _buildSectionHeader(
              icon: Icons.replay,
              title: 'Política de Devoluciones',
              color: Colors.orange,
            ),
            const SizedBox(height: 16),

            _buildStepCard(
              number: '1',
              title: 'Plazo de 30 días',
              description:
                  'Tienes 30 días desde la recepción para solicitar una devolución.',
            ),
            const SizedBox(height: 12),
            _buildStepCard(
              number: '2',
              title: 'Estado original',
              description:
                  'Los productos deben estar sin usar, con etiquetas y en su embalaje original.',
            ),
            const SizedBox(height: 12),
            _buildStepCard(
              number: '3',
              title: 'Solicita desde tu perfil',
              description:
                  'Accede a "Mis Pedidos" y selecciona "Solicitar devolución" en el pedido correspondiente.',
            ),
            const SizedBox(height: 12),
            _buildStepCard(
              number: '4',
              title: 'Etiqueta gratuita',
              description:
                  'Te enviaremos una etiqueta de envío prepagada a tu email.',
            ),
            const SizedBox(height: 12),
            _buildStepCard(
              number: '5',
              title: 'Reembolso',
              description:
                  'Una vez recibido y verificado, reembolsaremos el importe en 5-7 días laborables.',
            ),

            const SizedBox(height: 32),

            // Excepciones
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.warning.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.warning_amber, color: AppColors.warning),
                      const SizedBox(width: 8),
                      Text('Excepciones', style: AppTextStyles.labelLarge),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '• Ropa interior y bañadores no admiten devolución por motivos higiénicos\n'
                    '• Productos personalizados no son reembolsables\n'
                    '• Artículos en rebajas finales tienen cambios limitados',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 12),
        Text(title, style: AppTextStyles.h3),
      ],
    );
  }

  Widget _buildInfoCard({required String title, required List<String> items}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.labelLarge),
          const SizedBox(height: 12),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Icon(Icons.check_circle, size: 18, color: AppColors.success),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepCard({
    required String number,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                number,
                style: AppTextStyles.labelLarge.copyWith(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.labelLarge),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
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

/// Pantalla de Política de Privacidad
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Política de Privacidad'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Última actualización: Enero 2026',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),

            _buildLegalSection(
              title: '1. Responsable del tratamiento',
              content:
                  'VANTAGE FASHION S.L. con domicilio en Calle Gran Vía 42, 28013 Madrid, '
                  'es responsable del tratamiento de los datos personales del Usuario.',
            ),

            _buildLegalSection(
              title: '2. Datos que recopilamos',
              content:
                  '• Datos identificativos (nombre, apellidos, email)\n'
                  '• Datos de contacto (dirección, teléfono)\n'
                  '• Datos de transacciones (historial de compras)\n'
                  '• Datos de navegación (cookies, preferencias)',
            ),

            _buildLegalSection(
              title: '3. Finalidad del tratamiento',
              content:
                  '• Gestión de pedidos y envíos\n'
                  '• Atención al cliente\n'
                  '• Envío de comunicaciones comerciales (con consentimiento)\n'
                  '• Mejora de nuestros servicios\n'
                  '• Cumplimiento de obligaciones legales',
            ),

            _buildLegalSection(
              title: '4. Conservación de datos',
              content:
                  'Conservamos sus datos durante el tiempo necesario para la finalidad '
                  'para la que fueron recabados y para determinar las posibles responsabilidades. '
                  'Los datos de facturación se conservan durante el plazo legalmente establecido.',
            ),

            _buildLegalSection(
              title: '5. Derechos del usuario',
              content:
                  'Puede ejercer sus derechos de acceso, rectificación, supresión, '
                  'oposición, limitación del tratamiento y portabilidad enviando un email a '
                  'privacidad@vantage.com junto con una copia de su DNI.',
            ),

            _buildLegalSection(
              title: '6. Seguridad',
              content:
                  'Implementamos medidas técnicas y organizativas para proteger sus datos '
                  'contra accesos no autorizados, pérdidas o destrucción. Utilizamos cifrado SSL '
                  'en todas las comunicaciones y almacenamiento seguro.',
            ),

            _buildLegalSection(
              title: '7. Cookies',
              content:
                  'Utilizamos cookies propias y de terceros para mejorar su experiencia, '
                  'analizar el uso de la web y personalizar contenido. Puede gestionar sus '
                  'preferencias de cookies en la configuración de la aplicación.',
            ),

            const SizedBox(height: 32),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.info.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.email_outlined, color: AppColors.info),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '¿Dudas sobre privacidad?',
                          style: AppTextStyles.labelMedium,
                        ),
                        Text(
                          'Contáctanos: privacidad@vantage.com',
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

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildLegalSection({required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.h4),
          const SizedBox(height: 8),
          Text(
            content,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

/// Pantalla de Términos y Condiciones
class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Términos y Condiciones'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Última actualización: Enero 2026',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),

            _buildTermsSection(
              title: '1. Identificación',
              content:
                  'Este sitio web es propiedad de VANTAGE FASHION S.L., con CIF B-12345678, '
                  'inscrita en el Registro Mercantil de Madrid.',
            ),

            _buildTermsSection(
              title: '2. Objeto',
              content:
                  'Las presentes condiciones regulan el uso de la aplicación móvil y '
                  'el proceso de compra de productos. El acceso y uso implica la aceptación '
                  'de estos términos.',
            ),

            _buildTermsSection(
              title: '3. Productos y precios',
              content:
                  '• Los precios incluyen IVA y se muestran en Euros\n'
                  '• Los gastos de envío se calcularán antes de confirmar el pedido\n'
                  '• Nos reservamos el derecho de modificar precios sin previo aviso\n'
                  '• Las ofertas son válidas mientras se muestren disponibles',
            ),

            _buildTermsSection(
              title: '4. Proceso de compra',
              content:
                  '• Selección de productos y tallas\n'
                  '• Revisión del carrito\n'
                  '• Introducción de datos de envío\n'
                  '• Selección de método de pago\n'
                  '• Confirmación y pago seguro',
            ),

            _buildTermsSection(
              title: '5. Formas de pago',
              content:
                  'Aceptamos tarjetas de crédito/débito (Visa, Mastercard, American Express) '
                  'a través de la pasarela segura Stripe. Todos los pagos están protegidos con '
                  'cifrado SSL de 256 bits.',
            ),

            _buildTermsSection(
              title: '6. Entrega',
              content:
                  '• Enviamos a toda España peninsular e islas\n'
                  '• Los plazos de entrega son estimativos\n'
                  '• El cliente debe verificar el estado del paquete en la entrega\n'
                  '• En caso de ausencia, se realizarán hasta 2 intentos de entrega',
            ),

            _buildTermsSection(
              title: '7. Desistimiento y devoluciones',
              content:
                  'El cliente dispone de 30 días naturales para ejercer su derecho de '
                  'desistimiento. Los productos deben devolverse en estado original. '
                  'Consulte nuestra política de devoluciones para más detalles.',
            ),

            _buildTermsSection(
              title: '8. Garantías',
              content:
                  'Todos los productos tienen una garantía de 2 años conforme a la '
                  'legislación vigente. En caso de defecto, contacte con atención al cliente.',
            ),

            _buildTermsSection(
              title: '9. Propiedad intelectual',
              content:
                  'Todos los contenidos (textos, imágenes, logos, diseños) son propiedad '
                  'de VANTAGE FASHION S.L. y están protegidos por derechos de autor.',
            ),

            _buildTermsSection(
              title: '10. Jurisdicción',
              content:
                  'Cualquier controversia se someterá a los Juzgados y Tribunales de Madrid, '
                  'con renuncia expresa a cualquier otro fuero.',
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildTermsSection({required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.h4),
          const SizedBox(height: 8),
          Text(
            content,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
