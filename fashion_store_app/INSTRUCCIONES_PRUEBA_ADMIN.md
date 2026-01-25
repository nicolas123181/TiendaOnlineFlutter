# 🚀 INSTRUCCIONES PARA PROBAR EL PANEL DE ADMIN

## ✅ PASO 1: Configurar Cloudinary (REQUERIDO)

Para poder subir imágenes de productos, necesitas configurar un Upload Preset en Cloudinary:

### 1.1 Acceder a tu Dashboard de Cloudinary
```
URL: https://console.cloudinary.com/
Credenciales ya configuradas en .env:
- Cloud Name: dh3m9a9ky
- API Key: 722157182966475
```

### 1.2 Crear Upload Preset
1. Ve a **Settings** (⚙️ en la barra lateral)
2. Selecciona **Upload**
3. Scroll hasta la sección **Upload presets**
4. Click en **Add upload preset**
5. Configura:
   - **Preset name**: `vantage_products` (o el nombre que prefieras)
   - **Signing Mode**: Selecciona **Unsigned**
   - **Folder**: `productos` (opcional, para organizar)
   - **Use filename**: ON (mantener nombres originales)
   - **Unique filename**: ON (evitar duplicados)
6. Click **Save**

### 1.3 Actualizar .env
Abre el archivo `.env` en la raíz del proyecto Flutter y actualiza:
```env
CLOUDINARY_UPLOAD_PRESET=vantage_products
```

> **NOTA**: Si no quieres crear un preset nuevo, puedes usar `ml_default` que es el preset por defecto de Cloudinary (ya está configurado en .env).

---

## ✅ PASO 2: Verificar Instalación de Dependencias

Asegúrate de que todas las dependencias están instaladas:

```bash
cd "c:\Users\prats\OneDrive\Escritorio\Proyecto\Flutter tienda\vantage_fashion_app\fashion_store_app"
flutter pub get
```

**Dependencias críticas agregadas**:
- ✅ `http: ^1.2.2` (para upload a Cloudinary)
- ✅ `image_picker: ^1.2.1` (para seleccionar imágenes)
- ✅ `fl_chart: ^1.1.1` (para gráficos del dashboard)

---

## ✅ PASO 3: Verificar Estructura de Archivos

Asegúrate de que estos archivos existen:

```
fashion_store_app/
├── lib/
│   ├── shared/
│   │   └── services/
│   │       └── cloudinary_service.dart ✅ NUEVO
│   ├── features/
│   │   └── admin/
│   │       ├── presentation/
│   │       │   ├── providers/
│   │       │   │   └── products_provider.dart ✅ NUEVO
│   │       │   └── screens/
│   │       │       ├── admin_screens.dart ✅ ACTUALIZADO
│   │       │       └── admin_product_form_screen.dart ✅ NUEVO
│   │       └── ...
│   └── config/
│       ├── constants/
│       │   └── app_constants.dart ✅ ACTUALIZADO
│       └── router/
│           └── app_router.dart ✅ ACTUALIZADO
├── .env ✅ ACTUALIZADO
└── pubspec.yaml ✅ ACTUALIZADO
```

---

## ✅ PASO 4: Compilar y Ejecutar la App

### Opción 1: Chrome (Recomendado para pruebas)
```bash
flutter run -d chrome
```

### Opción 2: Android Emulator
```bash
flutter run -d emulator-5554
```

### Opción 3: Dispositivo físico
```bash
flutter run
```

---

## 🎯 PASO 5: Probar el CRUD de Productos

### 5.1 Navegar al Panel de Admin
1. Inicia sesión con una cuenta de administrador
2. Ve a la sección **Admin Panel**
3. Click en **Productos**

### 5.2 Crear un Nuevo Producto
1. Click en el botón **+** (esquina superior derecha)
2. Llena el formulario:
   - **Nombre**: Ej. "Camisa Oxford Premium"
   - **Descripción**: Descripción detallada
   - **Precio**: Ej. 59.99 (se guardará como 5999 céntimos)
   - **Stock**: Cantidad disponible
   - **Categoría**: Selecciona una categoría
   
3. **Subir imágenes** (hasta 5):
   - Click en el botón "Seleccionar imágenes"
   - Elige hasta 5 imágenes
   - Las imágenes se mostrarán en preview
   - Puedes eliminar imágenes con el icono X

4. **Ofertas** (opcional):
   - Activa "Producto en oferta"
   - Ingresa el precio rebajado
   - Selecciona fecha de fin de oferta

5. **Stock por tallas**:
   - Ingresa cantidades para cada talla (XS, S, M, L, XL, XXL)
   - El stock total se calcula automáticamente

6. **Producto destacado**:
   - Marca el checkbox si quieres que aparezca en destacados

7. Click **Guardar Producto**

### 5.3 Editar un Producto Existente
1. En la lista de productos, click en el ícono **✏️ (editar)**
2. Modifica los campos que desees
3. Puedes agregar/eliminar imágenes
4. Click **Actualizar Producto**

### 5.4 Eliminar un Producto
1. En la lista de productos, click en el ícono **🗑️ (eliminar)**
2. Confirma la eliminación
3. El producto y sus tallas se eliminarán de la base de datos

### 5.5 Buscar y Filtrar Productos
- **Buscar**: Usa la barra de búsqueda para encontrar productos por nombre
- **Filtrar por categoría**: Usa los chips de categorías para filtrar

---

## 🔍 PASO 6: Verificar en Supabase

Puedes verificar que todo funciona correctamente en Supabase:

1. Ve a: https://djzetbvdkdundjyvlgac.supabase.co
2. **Table Editor** → **products**
3. Verifica que tu nuevo producto aparece con:
   - ✅ Nombre, descripción, precio
   - ✅ URLs de imágenes de Cloudinary
   - ✅ Stock correcto
   - ✅ Slug auto-generado

4. **Table Editor** → **product_sizes**
5. Verifica que las tallas tienen:
   - ✅ ID del producto correcto
   - ✅ Cantidades de stock por talla

---

## 🔧 SOLUCIÓN DE PROBLEMAS

### Error: "Upload failed - Invalid credentials"
**Solución**: 
1. Verifica que el `CLOUDINARY_CLOUD_NAME` en `.env` es correcto
2. Verifica que el `CLOUDINARY_UPLOAD_PRESET` existe en tu cuenta
3. Asegúrate de que el preset es **Unsigned**

### Error: "Image picker not working"
**Solución**:
- **Chrome**: Asegúrate de dar permisos de archivos
- **Android**: Agrega permisos en `android/app/src/main/AndroidManifest.xml`:
  ```xml
  <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
  <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
  ```

### Error: "No se encuentra el producto después de crearlo"
**Solución**:
1. Verifica que la función `create_product_with_sizes()` existe en Supabase
2. Revisa los logs de Supabase Functions
3. Asegúrate de tener permisos RLS correctos

### Error de compilación
**Solución**:
```bash
flutter clean
flutter pub get
flutter run
```

### Las imágenes no se suben a Cloudinary
**Solución**:
1. Verifica la conexión a internet
2. Revisa que el Upload Preset es **Unsigned**
3. Verifica que las credenciales en `.env` son correctas
4. Mira los logs en la consola de Flutter para más detalles

---

## 📊 FUNCIONALIDADES IMPLEMENTADAS

### ✅ PRODUCTOS - CRUD COMPLETO
- [x] Crear producto con imágenes (hasta 5)
- [x] Editar producto existente
- [x] Eliminar producto (cascade delete)
- [x] Upload a Cloudinary
- [x] Stock por tallas (XS-XXL)
- [x] Ofertas con fecha de fin
- [x] Productos destacados
- [x] Auto-generación de slug
- [x] Búsqueda por nombre
- [x] Filtros por categoría
- [x] Preview de imágenes

### ✅ DASHBOARD
- [x] Estadísticas de ventas
- [x] Gráfico de ventas últimos 7 días
- [x] Inventario total
- [x] Productos con stock bajo
- [x] Valor del inventario

### ✅ OTROS MÓDULOS (Básicos)
- [x] Cupones (crear, activar/desactivar, eliminar)
- [x] Usuarios (listar, estadísticas)
- [x] Newsletter (suscriptores, exportar CSV)
- [x] Tallas (ver stock bajo, actualizar)
- [x] Facturas (listar, generar)

---

## 🚧 PRÓXIMAS IMPLEMENTACIONES

Según el archivo `IMPLEMENTACION_ADMIN_FLUTTER.md`, faltan:

1. **Categorías CRUD Completo** (~45 min)
2. **Pedidos - Gestión Completa** (~1 hora)
3. **Cupones - Formulario Mejorado** (~30 min)
4. **Configuración del Sistema** (~45 min)
5. **Devoluciones** (~1 hora)

---

## 📞 CONTACTO

Si encuentras algún error o necesitas ayuda:
- Revisa los logs de Flutter: `flutter run --verbose`
- Revisa los logs de Supabase
- Verifica que todas las credenciales en `.env` son correctas

---

**¡Listo para probar! 🎉**

Ejecuta:
```bash
flutter run -d chrome
```

Y navega a **Admin Panel → Productos → + (Crear Producto)**
