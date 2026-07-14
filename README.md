# Fútbol Pulse - Sistema de Gestión Deportiva Premium

**Fútbol Pulse** es una aplicación móvil avanzada construida con **Flutter** siguiendo los principios de **Clean Architecture** y **Riverpod**. Diseñada para clubes profesionales, permite la gestión integral de plantillas, seguimiento de partidos en tiempo real, análisis biométrico y scouting avanzado.

<<<<<<< HEAD
## Características Principales
=======
## 🚀 Características Principales
>>>>>>> 4b9987f (feat(health): define medical and performance testing domain interfaces)

-   **Dashboard Táctico**: Resumen de temporada con métricas de impacto visual.
-   **Pizarra Táctica**: Herramienta visual para diseñar alineaciones (4-4-2, 4-3-3, 3-4-3).
-   **Rastreo en Vivo**: Registro de incidencias (goles, tarjetas) minuto a minuto.
-   **Módulo de Salud**: Seguimiento de lesiones, tests de rendimiento y biometría (IMC, masa muscular).
-   **Scouting Pro**: Wizard de 3 pasos para informes técnicos y valoración económica de mercado.
-   **Sistema de Suscripción**: Control de acceso dinámico para Plan Básico y Premium.

<<<<<<< HEAD
## Requisitos del Sistema
=======
## 🛠️ Requisitos del Sistema
>>>>>>> 4b9987f (feat(health): define medical and performance testing domain interfaces)

-   **Flutter**: SDK v3.22.0 o superior.
-   **Dart**: v3.4.0 o superior.
-   **Android Studio / VS Code**: Con plugins de Flutter y Dart instalados.
-   **Emulador**: Android API 34 o dispositivo físico.
-   **Backend**: API de Fútbol Pulse (Django REST Framework) ejecutándose.

<<<<<<< HEAD
## Instalación y Configuración

1.  **Clonar el repositorio:**
    ```bash
    git clone https://github.com/EdisonLudena/frontend-flutter-futbolpulse.git
=======
## 📥 Instalación y Configuración

1.  **Clonar el repositorio:**
    ```bash
    git clone <url-del-repositorio>
>>>>>>> 4b9987f (feat(health): define medical and performance testing domain interfaces)
    cd Fútbol-Pulse-Frontend
    ```

2.  **Instalar dependencias:**
    ```bash
    flutter pub get
    ```

3.  **Configurar variables de entorno:**
    Crea un archivo `.env` en la raíz del proyecto (basado en `.env.example`):
    ```env
<<<<<<< HEAD
    API_BASE_URL=http://futbol-stats-api.uaeftt-ute.site/api/
=======
    API_BASE_URL=http://10.0.2.2:8000/api/
>>>>>>> 4b9987f (feat(health): define medical and performance testing domain interfaces)
    ```
    *Nota: `10.0.2.2` es la dirección para acceder al localhost de tu PC desde el emulador de Android.*

4.  **Generar archivos de datos (opcional si hay cambios en DTOs):**
    ```bash
    flutter pub run build_runner build --delete-conflicting-outputs
    ```

<<<<<<< HEAD
## Comandos Útiles
=======
## ⚡ Comandos Útiles
>>>>>>> 4b9987f (feat(health): define medical and performance testing domain interfaces)

-   **Ejecutar la aplicación:** `flutter run`
-   **Limpiar caché:** `flutter clean`
-   **Ejecutar tests:** `flutter test`
-   **Compilar APK de lanzamiento:** `flutter build apk --release`

<<<<<<< HEAD
## Conexión a la API y Credenciales
=======
## 🔐 Conexión a la API y Credenciales
>>>>>>> 4b9987f (feat(health): define medical and performance testing domain interfaces)

La aplicación se conecta al backend mediante **Tokens JWT**. Los interceptores de Dio manejan automáticamente la autenticación una vez el usuario inicia sesión.

### Credenciales de Prueba Sugeridas:
| Rol | Email | Password |
| :--- | :--- | :--- |
| **Coach Premium** | `carlos@pulse.com` | `admin123` |
| **Scout Pro** | `scout1@pulse.com` | `admin123` |
| **Usuario Básico** | `proband@pulse.com` | `admin123` |

<<<<<<< HEAD
## Estructura del Proyecto (Clean Architecture)
=======
## 📐 Estructura del Proyecto (Clean Architecture)
>>>>>>> 4b9987f (feat(health): define medical and performance testing domain interfaces)

-   `lib/domain`: Entidades puras y contratos (interfaces) de repositorios.
-   `lib/data`: DTOs, fuentes de datos remotas (API) e implementaciones de repositorios.
-   `lib/presentation`: Gestión de estado (Riverpod), navegación (GoRouter) y UI (Screens/Widgets).
-   `lib/theme`: Identidad visual "White Pitch" (Colores, Tipografías).

---
Desarrollado para el Proyecto Integrador - Cuarto Semestre UTE.
