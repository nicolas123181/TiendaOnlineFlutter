# 📱 VANTAGE Fashion App - Manual de Usuario

## 🎯 Descripción General

**VANTAGE Fashion** es una aplicación de comercio electrónico premium especializada en moda masculina. La aplicación ofrece una experiencia de compra completa tanto para clientes como para administradores.

---

## 📋 Índice

1. [Requisitos Previos](#requisitos-previos)
2. [Instalación](#instalación)
3. [Guía del Cliente](#guía-del-cliente)
4. [Panel de Administración](#panel-de-administración)
5. [Arquitectura de la Aplicación](#arquitectura-de-la-aplicación)
6. [Estado Actual del Proyecto](#estado-actual-del-proyecto)

---

## 🔧 Requisitos Previos

- **Flutter SDK**: versión 3.6.0 o superior
- **Dart SDK**: versión 3.0.0 o superior
- **Android Studio** o **VS Code** con extensiones de Flutter
- **Git** para control de versiones
- Cuenta de **Supabase** (ya configurada)
- Cuenta de **Stripe** (modo test configurado)

---

## 📥 Instalación

1. **Clonar/Abrir el proyecto**:
   ```bash
   cd vantage_fashion_app
   ```

2. **Instalar dependencias**:
   ```bash
   flutter pub get
   ```

3. **Ejecutar la aplicación**:
   ```bash
   flutter run
   ```

---

## 👤 Guía del Cliente

### 🏠 Pantalla de Inicio (Home)
- **Carrusel de promociones**: Muestra las últimas ofertas y colecciones destacadas
- **Categorías destacadas**: Acceso rápido a las principales categorías (Trajes, Camisas, Pantalones, Accesorios)
- **Productos destacados**: Selección de productos recomendados
- **Nuevas llegadas**: Los últimos productos añadidos al catálogo

### 🛍️ Catálogo de Productos
- **Navegación por categorías**: Filtra productos por tipo
- **Búsqueda avanzada**: Busca por nombre, descripción o características
- **Filtros disponibles**:
  - Por precio (rango)
  - Por talla (XS, S, M, L, XL, XXL)
  - Por color
  - Por marca
  - En oferta (productos rebajados)
- **Ordenación**: Por precio (menor a mayor, mayor a menor), por novedades, por popularidad

### 📦 Detalle de Producto
- **Galería de imágenes**: Carrusel con zoom
- **Selector de talla**: Muestra disponibilidad por talla
- **Selector de color**: Variantes de color disponibles
- **Información de producto**:
  - Descripción detallada
  - Composición del material
  - Guía de cuidados
  - Guía de tallas
- **Botones de acción**:
  - Añadir al carrito
  - Añadir a la lista de deseos
  - Compartir producto

### 🛒 Carrito de Compras
- **Lista de productos**: Muestra todos los artículos añadidos
- **Gestión de cantidades**: Aumentar/disminuir unidades
- **Eliminar productos**: Quitar artículos del carrito
- **Resumen de pedido**:
  - Subtotal
  - Costes de envío
  - Descuentos aplicados
  - Total final
- **Aplicar cupón**: Campo para introducir código de descuento

### 💳 Proceso de Checkout
1. **Dirección de envío**: Seleccionar o añadir nueva dirección
2. **Método de envío**: Elegir entre las opciones disponibles
   - Estándar (3-5 días laborables)
   - Express (1-2 días laborables)
   - Recogida en tienda
3. **Método de pago**: Integración con Stripe
   - Tarjeta de crédito/débito
   - Apple Pay / Google Pay (según dispositivo)
4. **Confirmación**: Resumen final del pedido

### 📋 Mis Pedidos
- **Historial completo**: Lista de todos los pedidos realizados
- **Estados del pedido**:
  - 🟡 Pendiente
  - 🟢 Pagado
  - 🔵 Preparando
  - 🟣 Enviado
  - ✅ Entregado
  - 🔴 Cancelado
- **Detalle del pedido**: Ver productos, totales y seguimiento
- **Seguimiento de envío**: Tracking del paquete

### ❤️ Lista de Deseos (Wishlist)
- Guardar productos favoritos
- Mover productos al carrito directamente
- Compartir lista de deseos

### 🔄 Devoluciones
- **Solicitar devolución**: Desde el detalle del pedido (hasta 14 días)
- **Seleccionar productos**: Elegir qué artículos devolver
- **Motivo de devolución**: Especificar la razón
- **Estados de devolución**:
  - Solicitada
  - En tránsito
  - Recibida
  - Reembolsada
  - Rechazada

### 👤 Mi Perfil
- **Datos personales**: Nombre, email, teléfono
- **Direcciones guardadas**: Gestionar direcciones de envío
- **Cambiar contraseña**: Actualizar credenciales
- **Preferencias**: Notificaciones, idioma
- **Cerrar sesión**

---

## 🔐 Panel de Administración

### 📊 Dashboard
El dashboard principal muestra:
- **KPIs principales**:
  - Ventas del día/semana/mes
  - Pedidos pendientes
  - Productos con bajo stock
  - Nuevos clientes
- **Gráficos**:
  - Evolución de ventas
  - Productos más vendidos
  - Conversión
- **Acciones rápidas**: Acceso directo a funciones frecuentes

### 📦 Gestión de Productos
- **Listar productos**: Vista de tabla con filtros
- **Crear producto**:
  - Información básica (nombre, descripción, precio)
  - Imágenes (hasta 10)
  - Variantes (tallas, colores)
  - Stock por variante
  - Categoría y etiquetas
  - SEO (slug, meta descripción)
- **Editar producto**: Modificar cualquier campo
- **Eliminar producto**: Con confirmación
- **Gestión de stock**: Actualizar inventario

### 🗂️ Gestión de Categorías
- **Crear categorías**: Nombre, slug, imagen, descripción
- **Jerarquía**: Categorías padre/hijo
- **Ordenar**: Drag & drop para reordenar
- **Activar/desactivar**: Ocultar categorías temporalmente

### 📋 Gestión de Pedidos
- **Lista de pedidos**: Con filtros por estado y fecha
- **Detalle del pedido**: Información completa
- **Cambiar estado**: Actualizar progreso del pedido
- **Generar factura**: PDF automático
- **Notificar cliente**: Enviar email de actualización

### 🔄 Gestión de Devoluciones
- **Solicitudes pendientes**: Revisar nuevas solicitudes
- **Aprobar/rechazar**: Con motivo
- **Procesar reembolso**: Integración con Stripe
- **Historial**: Ver devoluciones procesadas

### 🎟️ Gestión de Cupones
- **Crear cupón**:
  - Código único
  - Tipo de descuento:
    - Porcentaje (%)
    - Monto fijo (€)
    - Envío gratis
  - Condiciones:
    - Compra mínima
    - Productos específicos
    - Categorías específicas
    - Fecha de validez
    - Límite de usos
- **Activar/desactivar**: Control de disponibilidad
- **Estadísticas**: Uso y rendimiento

### 📧 Newsletter
- **Suscriptores**: Lista de emails registrados
- **Campañas**: Crear y programar envíos
- **Estadísticas**: Tasa de apertura, clics
- **Importar/Exportar**: CSV

### 🚚 Configuración de Envíos
- **Métodos de envío**: Crear y editar opciones
- **Zonas de envío**: Definir áreas geográficas
- **Tarifas**: Configurar precios por zona/peso
- **Envío gratis**: Umbral de compra mínima

### ⚙️ Configuración General
- **Información de la tienda**: Nombre, email, teléfono, dirección
- **Moneda y formato**: EUR, formato de fecha
- **Impuestos**: IVA y configuración fiscal
- **Notificaciones**: Emails automáticos
- **Seguridad**: Autenticación de dos factores

---

## 🏗️ Arquitectura de la Aplicación

### Estructura de Carpetas

```
lib/
├── config/                 # Configuraciones globales
│   ├── app_colors.dart     # Paleta de colores
│   ├── app_constants.dart  # Constantes de la app
│   ├── app_routes.dart     # Definición de rutas
│   ├── app_theme.dart      # Temas claro/oscuro
│   └── environment.dart    # Variables de entorno
│
├── core/                   # Núcleo de la aplicación
│   └── services/           # Servicios centrales
│       ├── supabase_service.dart     # API de Supabase
│       ├── stripe_service.dart       # Pagos con Stripe
│       ├── storage_service.dart      # Almacenamiento local
│       ├── pdf_service.dart          # Generación de PDFs
│       └── notification_service.dart # Notificaciones
│
├── data/                   # Capa de datos
│   ├── models/             # Modelos de datos
│   │   ├── product.dart
│   │   ├── category.dart
│   │   ├── cart_item.dart
│   │   ├── order.dart
│   │   ├── user_profile.dart
│   │   └── ...
│   │
│   └── repositories/       # Repositorios (acceso a datos)
│       ├── auth_repository.dart
│       ├── product_repository.dart
│       ├── cart_repository.dart
│       ├── order_repository.dart
│       └── ...
│
└── presentation/           # Capa de presentación
    ├── providers/          # Estado (Riverpod)
    │   ├── auth_provider.dart
    │   ├── cart_provider.dart
    │   ├── product_provider.dart
    │   └── ...
    │
    ├── widgets/            # Widgets reutilizables
    │   └── common/
    │       ├── custom_button.dart
    │       ├── product_card.dart
    │       └── ...
    │
    └── screens/            # Pantallas
        ├── splash/
        ├── auth/
        ├── home/
        ├── products/
        ├── cart/
        ├── orders/
        ├── profile/
        ├── wishlist/
        ├── returns/
        └── admin/
```

### Tecnologías Utilizadas

| Tecnología | Propósito |
|------------|-----------|
| **Flutter** | Framework UI multiplataforma |
| **Riverpod** | Gestión de estado |
| **GoRouter** | Navegación declarativa |
| **Supabase** | Backend (Auth, Database, Storage) |
| **Stripe** | Procesamiento de pagos |
| **SharedPreferences** | Almacenamiento local |
| **Dio** | Cliente HTTP |
| **PDF** | Generación de facturas |

### Patrones de Diseño

- **Repository Pattern**: Abstracción del acceso a datos
- **Provider Pattern**: Inyección de dependencias
- **State Notifier**: Gestión de estado inmutable
- **Clean Architecture**: Separación de responsabilidades

---

## 📊 Estado Actual del Proyecto

### ✅ Completado

- [x] Configuración del proyecto (pubspec.yaml, .env)
- [x] Configuraciones globales (colores, tema, rutas, constantes)
- [x] Modelos de datos (11 modelos)
- [x] Servicios centrales (5 servicios)
- [x] Repositorios (9 repositorios)
- [x] Providers de estado (6 providers)
- [x] Widgets comunes (16 widgets)
- [x] Pantallas de autenticación (3 pantallas)
- [x] Pantallas de inicio (2 pantallas)
- [x] Pantallas de productos (3 pantallas)
- [x] Pantallas de carrito (3 pantallas)
- [x] Pantallas de pedidos (2 pantallas)
- [x] Pantallas de perfil (5 pantallas)
- [x] Pantalla de wishlist (1 pantalla)
- [x] Pantallas de devoluciones (3 pantallas)
- [x] Pantallas de administración (11 pantallas)
- [x] Configuración del router (main.dart)

### ⚠️ Pendiente de Corrección

Hay algunos errores de compilación que necesitan ser corregidos:

1. **app_theme.dart**: Cambiar `CardTheme` por `CardThemeData`, `DialogTheme` por `DialogThemeData`, `TabBarTheme` por `TabBarThemeData`

2. **Servicios**: Algunos métodos necesitan ajustes en los tipos de retorno

3. **Modelos**: Verificar que las propiedades coincidan entre modelos y repositorios

### 🔄 Pasos para Completar

1. Ejecutar `flutter analyze` para ver errores específicos
2. Corregir errores tipo por tipo
3. Ejecutar `flutter run` para probar

---

## 🎨 Guía de Estilo

### Colores Principales

| Color | Código | Uso |
|-------|--------|-----|
| Brand Navy | `#1A2744` | Color principal, headers |
| Brand Gold | `#B8860B` | Acentos, precios en oferta |
| Brand Cream | `#FAF8F5` | Fondos sutiles |
| Success | `#059669` | Confirmaciones |
| Error | `#DC2626` | Errores |

### Tipografía

- **Títulos**: Inter Bold
- **Cuerpo**: Inter Regular
- **Precios**: Inter SemiBold

### Esquinas

- Todas las esquinas son **cuadradas** (borderRadius: 0) siguiendo el estilo premium de la marca

---

## 📞 Soporte

Para reportar problemas o solicitar nuevas funcionalidades, contactar con el equipo de desarrollo.

---

**Versión**: 1.0.0  
**Última actualización**: Enero 2026
