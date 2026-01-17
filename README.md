# VANTAGE - Premium Men's Fashion E-Commerce

Una aplicación móvil de comercio electrónico para moda masculina premium, construida con Flutter y Supabase.

## 🎯 Características

### Tienda
- 📱 Diseño mobile-first elegante y premium
- 🔍 Búsqueda de productos con filtros
- 🏷️ Categorías de productos
- ⚡ Ofertas Flash en tiempo real (controladas desde Supabase)
- 🛒 Carrito de compras persistente
- ❤️ Lista de favoritos

### Autenticación
- 🔐 Login / Registro con email
- 🔑 Recuperación de contraseña
- 👤 Perfil de usuario

### Admin Panel
- 📊 Dashboard básico
- 📦 Gestión de productos
- 📋 Gestión de pedidos
- ⚙️ Configuración (Flash Offers toggle)

## 🛠️ Stack Tecnológico

- **Frontend**: Flutter 3.27+
- **State Management**: Riverpod 3.x
- **Routing**: GoRouter
- **Backend**: Supabase
- **Models**: Freezed + JsonSerializable

## 📁 Estructura del Proyecto

```
fashion_store_app/
├── lib/
│   ├── config/           # Configuración (theme, router, constants)
│   ├── features/         # Features modulares
│   │   ├── auth/         # Autenticación
│   │   ├── cart/         # Carrito
│   │   ├── categories/   # Categorías
│   │   ├── checkout/     # Checkout
│   │   ├── favorites/    # Favoritos
│   │   ├── home/         # Home screen
│   │   ├── orders/       # Pedidos
│   │   ├── products/     # Productos
│   │   ├── profile/      # Perfil
│   │   ├── settings/     # Configuración
│   │   └── admin/        # Panel de admin
│   └── shared/           # Widgets y servicios compartidos
├── android/              # Configuración Android
├── ios/                  # Configuración iOS
└── pubspec.yaml
```

## 🚀 Configuración

### 1. Clonar el repositorio

```bash
cd fashion_store_app
```

### 2. Instalar dependencias

```bash
flutter pub get
```

### 3. Configurar Supabase

Crea un archivo `.env` en la raíz del proyecto con:

```env
SUPABASE_URL=tu_url_de_supabase
SUPABASE_ANON_KEY=tu_anon_key
```

### 4. Ejecutar la base de datos

Ejecuta los scripts SQL en tu proyecto Supabase:
- `supabase-schema.sql` - Schema de la base de datos
- `rls-policies.sql` - Políticas de seguridad

### 5. Generar código Freezed

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 6. Ejecutar la app

```bash
flutter run
```

## 📱 Pantallas Principales

| Screen | Descripción |
|--------|-------------|
| Home | Banner hero, ofertas flash, productos destacados |
| Products | Grid de productos con filtros y búsqueda |
| Product Detail | Detalle con galería, tallas, añadir al carrito |
| Cart | Lista de items, ajuste de cantidad, checkout |
| Profile | Información del usuario, pedidos, favoritos |
| Login/Register | Autenticación con email |

## 🎨 Diseño

La app sigue un diseño **minimalista y sofisticado**:
- Paleta de colores monocromática con acentos dorados
- Tipografía elegante (Inter)
- Micro-animaciones para feedback
- Diseño coherente en toda la aplicación

## 📄 Licencia

Este proyecto es privado.
