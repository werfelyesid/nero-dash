# 🎮 PLAN DE DESARROLLO — "ÑERO DASH"

## (Videojuego Geometry-Dash-like, Mobile-First, Godot Engine)

---

## 📋 Resumen del proyecto

| Aspecto            | Decisión                                                     |
| ------------------ | ------------------------------------------------------------ |
| **Mecánica**       | One-tap rítmico (auto-scroll, tap para saltar)               |
| **Estilo**         | Geométrico con variedad de formas (sierras, naves, portales) |
| **Equipo**         | Yesid + Camilo (papá e hijo)                                 |
| **Tiempo**         | 6-12 meses (aprendizaje, sin prisa)                          |
| **Música**         | Libre de derechos (OpenGameArt, Incompetech, Pixabay)        |
| **Monetización**   | Gratis + AdMob (anuncios no intrusivos)                      |
| **Multijugador**   | No en tiempo real. Sí: creador de niveles + compartir online |
| **Plataformas**    | Primero Android, luego PC (Windows/Linux)                    |
| **Motor**          | Godot Engine 4.x                                             |
| **Presupuesto IA** | ~$50 USD (DeepSeek API)                                      |
| **Servidor**       | Minipc Yesid (para backend de niveles)                       |

---

## 🖥️ Recursos técnicos

| Recurso         | Detalle                     | Uso                                                         |
| --------------- | --------------------------- | ----------------------------------------------------------- |
| PC principal    | 32GB RAM, RTX 4060, 1TB SSD | Desarrollo, testing PC, builds                              |
| Portátil        | Core i5, 32GB RAM, sin GPU  | Desarrollo móvil, documentación, código                     |
| Minipc servidor | Yesid                       | Backend niveles online                                      |
| DeepSeek API    | ~$50 USD                    | Generar assets placeholder, debug ayuda, código boilerplate |
| Godot 4.x       | Gratis                      | Motor del juego                                             |
| GIMP / Inkscape | Gratis                      | Crear y editar sprites geométricos                          |

---

# 🗺️ ETAPAS DE DESARROLLO

---

## ═══════════════════════════════════════

## ETAPA 0: FUNDACIÓN 🏗️

## ═══════════════════════════════════════

### Duración: 1-2 semanas

### Objetivo: Tener todo listo para empezar a codificar

### 0.1 — Configuración del proyecto

- [ ] Crear proyecto Godot 4.x vacío (`ñero_dash/`)
- [ ] Estructura de carpetas:
  ```
  ñero_dash/
  ├── assets/
  │   ├── sprites/        (formas geométricas, personajes)
  │   ├── music/          (música de niveles)
  │   ├── sfx/            (efectos de sonido)
  │   ├── backgrounds/    (fondos animados)
  │   └── ui/             (botones, iconos, fuentes)
  ├── scenes/
  │   ├── levels/         (escenas de niveles)
  │   ├── obstacles/      (obstáculos individuales)
  │   ├── ui/             (menús, HUD)
  │   └── editor/         (creador de niveles)
  ├── scripts/
  │   ├── player/         (control del jugador)
  │   ├── obstacles/      (lógica de obstáculos)
  │   ├── level/          (gestión de niveles)
  │   ├── audio/          (sincronización música)
  │   ├── ui/             (interfaz)
  │   └── network/        (compartir niveles)
  ├── shaders/            (efectos visuales)
  └── project.godot
  ```
- [ ] Configurar Git + GitHub
- [ ] Configurar export para Android (SDK, keystore)
- [ ] Configurar Godot para mobile (viewport 720x1280, escalado)

### 0.2 — Investigación y referencia

- [ ] Jugar Geometry Dash 1 hora analizando:
  - Timing del salto
  - Velocidad de scroll
  - Tipos de obstáculos
  - Transiciones entre intentos
  - UI/UX (menús, pausa, game over)
- [ ] Documentar hallazgos en `docs/referencia_gd.md`
- [ ] Buscar 5 canciones libres de derechos en:
  - https://opengameart.org
  - https://incompetech.com/music/royalty-free
  - https://pixabay.com/music

### 0.3 — Diseño del Game Design Document (GDD)

- [ ] Escribir `docs/GDD.md`:
  - Historia (mínima: "un cubo que atraviesa dimensiones geométricas")
  - Mecánicas detalladas
  - Tipos de obstáculos (lista inicial: 8-10)
  - Progresión de dificultad
  - Sistema de puntuación
  - Economía (estrellas, skins desbloqueables)

---

## ═══════════════════════════════════════

## ETAPA 1: PROTOTIPO JUGABLE 🔧

## ═══════════════════════════════════════

### Duración: 4-6 semanas

### Objetivo: Un cubo que avanza, salta y muere

### 1.1 — Personaje (Semana 1-2)

- [ ] Crear `player.gd`:
  - Auto-scroll horizontal (velocidad constante, ~400 px/s)
  - Salto con tap/click (fuerza fija, no variable)
  - Gravedad simulada (caída después del salto)
  - El jugador está en el suelo por defecto
  - Colisión = muerte instantánea + reinicio rápido
- [ ] Crear sprite del cubo (32x32, color vibrante)
- [ ] Rotación del cubo al saltar (efecto visual)

### 1.2 — Suelo y cámara (Semana 1-2)

- [ ] Suelo infinito (TileMap o script que reposiciona)
- [ ] Cámara que sigue al jugador (Camera2D)
- [ ] Fondo de color sólido con gradiente

### 1.3 — Primer obstáculo (Semana 2-3)

- [ ] Crear escena `obstacle_block.tscn`:
  - Triángulo/pincho que aparece desde el suelo
  - Colisión con Area2D
  - Señal `body_entered` → muerte
- [ ] Sistema de spawn de obstáculos:
  - `level_manager.gd` que genera obstáculos con timing
  - Dificultad progresiva (más rápido, más juntos)

### 1.4 — Muerte y reinicio (Semana 3-4)

- [ ] Al morir:
  - Efecto de explosión geométrica (partículas)
  - Sonido de muerte
  - Botón "Reintentar" aparece tras 0.5s
  - Reinicio instantáneo (sin loading screen)
- [ ] Contador de intentos

### 1.5 — Prueba de concepto (Semana 4-6)

- [ ] 30 segundos de nivel con 1 canción
- [ ] 2 tipos de obstáculos (pincho bajo, pincho alto)
- [ ] Test en móvil Android
- [ ] Ajustar sensibilidad del tap
- [ ] **HITO 1**: El juego es jugable. Cubo salta, muere, reinicia. ✅

---

## ═══════════════════════════════════════

## ETAPA 2: VARIEDAD DE OBSTÁCULOS 🚧

## ═══════════════════════════════════════

### Duración: 3-4 semanas

### Objetivo: 8+ tipos de obstáculos diferentes

### 2.1 — Obstáculos básicos

- [ ] **Pincho simple** (triángulo en suelo) ✅ Ya existe
- [ ] **Pincho doble** (dos triángulos)
- [ ] **Pincho de techo** (triángulo invertido colgando)
- [ ] **Bloque flotante** (cuadrado en el aire → saltar o agacharse)
- [ ] **Sierra circular** (gira, se mueve en patrón)

### 2.2 — Obstáculos avanzados

- [ ] **Portal de gravedad** (invierte gravedad temporalmente)
- [ ] **Plataforma móvil** (se mueve vertical/horizontal)
- [ ] **Láser intermitente** (aparece/desaparece con ritmo)
- [ ] **Túnel estrecho** (forzar timing preciso)
- [ ] **Nave/modo vuelo** (el jugador cambia a nave que vuela)

### 2.3 — Sistema de obstáculos modular

- [ ] Todos los obstáculos heredan de `obstacle_base.gd`
- [ ] Cada obstáculo tiene: `speed`, `damage`, `animation`, `sound`
- [ ] Factory pattern para crear obstáculos desde datos (pensando en el editor futuro)

---

## ═══════════════════════════════════════

## ETAPA 3: SINCRONIZACIÓN MUSICAL 🎵

## ═══════════════════════════════════════

### Duración: 3-4 semanas

### Objetivo: Obstáculos sincronizados con la música

### 3.1 — Análisis de audio

- [ ] Cargar música con AudioStreamPlayer
- [ ] Detectar BPM (beats por minuto) de cada canción
- [ ] Sistema de beats: cada beat = una "unidad de tiempo"
- [ ] Los obstáculos se colocan en beats específicos

### 3.2 — Editor de timeline (precursor del creador de niveles)

- [ ] Crear recurso `song_data.tres`:
  - BPM
  - Duración
  - Array de eventos: `[{beat: 4, type: "spike"}, {beat: 8, type: "saw"}]`
- [ ] Herramienta interna para marcar beats (grid al ritmo)
- [ ] Visualización de waveform

### 3.3 — Efectos visuales rítmicos

- [ ] El fondo palpita con el beat
- [ ] Los colores cambian en drops de la canción
- [ ] Partículas sincronizadas

---

## ═══════════════════════════════════════

## ETAPA 4: 5 NIVELES OFICIALES 🎯

## ═══════════════════════════════════════

### Duración: 5-7 semanas

### Objetivo: 5 niveles completos con música y dificultad creciente

### 4.1 — Diseño de niveles

| Nivel | Nombre                | Dificultad | Canción               | Duración | Obstáculos nuevos    |
| ----- | --------------------- | ---------- | --------------------- | -------- | -------------------- |
| 1     | "Primer Salto"        | ⭐ Fácil   | Electrónica suave     | 60s      | Pinchos básicos      |
| 2     | "Sierras"             | ⭐⭐       | Dubstep medio         | 75s      | Sierras + bloques    |
| 3     | "Gravedad Loca"       | ⭐⭐⭐     | Drum & Bass           | 90s      | Portales de gravedad |
| 4     | "Infierno Geométrico" | ⭐⭐⭐⭐   | Metal/Rock            | 90s      | Láseres + túneles    |
| 5     | "Dimensión Ñera"      | ⭐⭐⭐⭐⭐ | Reggaetón/electrónico | 120s     | TODO combinado       |

### 4.2 — Progresión

- [ ] Sistema de desbloqueo: completar nivel N para desbloquear N+1
- [ ] 3 estrellas por nivel (según precisión/intentos)
- [ ] Las estrellas desbloquean skins

### 4.3 — Skins desbloqueables

- [ ] Cubo normal (default)
- [ ] Cubo dorado (10 estrellas)
- [ ] Cubo arcoíris (20 estrellas)
- [ ] Nave geométrica (30 estrellas)

---

## ═══════════════════════════════════════

## ETAPA 5: UI/UX COMPLETA 🎨

## ═══════════════════════════════════════

### Duración: 3-4 semanas

### Objetivo: Interfaz completa y pulida

### 5.1 — Pantallas

- [ ] Splash screen (logo Ñero Dash)
- [ ] Menú principal (animado, con cubo de fondo)
- [ ] Selector de niveles (scroll horizontal)
- [ ] Pantalla de juego (HUD minimalista)
- [ ] Pausa (tap en esquina)
- [ ] Game over (muerte + estadísticas)
- [ ] Victoria (nivel completado + estrellas)
- [ ] Tienda de skins

### 5.2 — Transiciones

- [ ] Fundido a negro entre escenas
- [ ] Animación de entrada/salida de menús
- [ ] El cubo del menú reacciona al tap

### 5.3 — Ajustes

- [ ] Volumen música
- [ ] Volumen SFX
- [ ] Vibración on/off (móvil)
- [ ] Calidad gráfica (baja/media/alta)

---

## ═══════════════════════════════════════

## ETAPA 6: CREADOR DE NIVELES 🏗️

## ═══════════════════════════════════════

### Duración: 5-7 semanas

### Objetivo: Editor visual dentro del juego

### 6.1 — Editor visual

- [ ] Grid al ritmo de la música (eje X = tiempo, Y = posición)
- [ ] Paleta de obstáculos (drag & drop o tap para colocar)
- [ ] Vista previa en tiempo real
- [ ] Línea de tiempo con waveform de audio
- [ ] Botones: Play, Pause, Stop, Guardar, Cargar

### 6.2 — Funcionalidad del editor

- [ ] Colocar/eliminar/mover obstáculos
- [ ] Ajustar BPM y offset de la canción
- [ ] Definir punto de inicio y final del nivel
- [ ] Cambiar fondo y colores
- [ ] Nombre y descripción del nivel
- [ ] Guardar como archivo `.nivel` (JSON o recurso Godot)

### 6.3 — Validación

- [ ] Verificar que el nivel es completable (simulación automática)
- [ ] Advertir si hay secciones imposibles
- [ ] Calcular dificultad estimada automáticamente

---

## ═══════════════════════════════════════

## ETAPA 7: ONLINE — COMPARTIR NIVELES 🌐

## ═══════════════════════════════════════

### Duración: 5-7 semanas

### Objetivo: Subir, buscar y descargar niveles de la comunidad

### 7.1 — Backend (Minipc Yesid)

- [ ] API REST con Python (Flask/FastAPI):
  - `POST /api/levels` — Subir nivel
  - `GET /api/levels` — Listar niveles (paginado, filtros)
  - `GET /api/levels/{id}` — Descargar nivel específico
  - `POST /api/levels/{id}/rate` — Votar nivel (1-5)
  - `GET /api/levels/search?q=` — Buscar por nombre
- [ ] Base de datos SQLite (simple, suficiente para esto)
- [ ] Límite de tamaño por nivel (100KB)
- [ ] Moderación básica (filtro de palabras en nombres)

### 7.2 — Cliente (Godot)

- [ ] HTTPRequest para comunicación con API
- [ ] Pantalla "Niveles de la comunidad":
  - Lista con scroll
  - Filtros: Más jugados, Mejor puntuados, Nuevos
  - Barra de búsqueda
  - Botón descargar
- [ ] Pantalla "Mis niveles" (niveles creados localmente)
- [ ] Botón "Subir" en cada nivel creado
- [ ] Cache local de niveles descargados

### 7.3 — Seguridad básica

- [ ] Rate limiting (10 subidas por hora por IP)
- [ ] Validación de archivos (solo JSON/.nivel, no ejecutables)
- [ ] Sanitización de nombres de nivel

---

## ═══════════════════════════════════════

## ETAPA 8: MONETIZACIÓN 💰

## ═══════════════════════════════════════

### Duración: 2-3 semanas

### Objetivo: Anuncios no intrusivos

### 8.1 — Integrar AdMob

- [ ] Plugin Godot para AdMob (Android)
- [ ] Anuncio intersticial cada 5 muertes (NO cada muerte)
- [ ] Banner pequeño en menú principal (no en juego)
- [ ] Opción "Quitar anuncios" ($1.99 USD, compra única)
- [ ] Anuncio recompensado: "¿Ver anuncio para obtener 5 estrellas extra?"

### 8.2 — Sistema de compras

- [ ] Integrar Godot IAP plugin
- [ ] Producto: `remove_ads` (no consumible)
- [ ] Producto: `star_pack_50` (consumible, 50 estrellas)
- [ ] Restaurar compras (por si cambia de dispositivo)

---

## ═══════════════════════════════════════

## ETAPA 9: POLISH Y OPTIMIZACIÓN ✨

## ═══════════════════════════════════════

### Duración: 3-4 semanas

### Objetivo: Juego pulido y optimizado para móvil

### 9.1 — Efectos visuales

- [ ] Partículas al saltar, morir, completar nivel
- [ ] Shaders para fondos animados (gradientes, ondas)
- [ ] Trail/estela detrás del cubo
- [ ] Screen shake al morir
- [ ] Efecto "slow motion" al completar nivel

### 9.2 — Sonido

- [ ] 10+ efectos de sonido (salto, muerte, estrella, botón, etc.)
- [ ] Normalización de volumen entre canciones
- [ ] Crossfade entre música de menú y nivel

### 9.3 — Optimización móvil

- [ ] Target: 60 FPS en dispositivos gama media
- [ ] Object pooling para obstáculos (no instanciar/destruir)
- [ ] Texturas comprimidas (ETC2 para Android)
- [ ] Reducir draw calls (batched rendering)
- [ ] Test en dispositivo real gama baja

### 9.4 — Accesibilidad

- [ ] Modo daltonismo (paletas de colores alternativas)
- [ ] Tamaño de texto ajustable
- [ ] Zona de tap configurable (izquierda/derecha/ambos)

---

## ═══════════════════════════════════════

## ETAPA 10: TESTING Y LANZAMIENTO 🚀

## ═══════════════════════════════════════

### Duración: 4-6 semanas

### Objetivo: Juego publicado en Play Store

### 10.1 — Testing interno

- [ ] Test en 3+ dispositivos Android distintos
- [ ] Test en PC (Windows y Linux)
- [ ] Pruebas de estrés (muchos obstáculos, partículas)
- [ ] Bug tracking en GitHub Issues

### 10.2 — Beta testing

- [ ] Google Play Internal Testing (5-10 amigos)
- [ ] Recibir feedback estructurado (formulario Google)
- [ ] 2-3 ciclos de arreglos

### 10.3 — Lanzamiento Android

- [ ] Crear ficha en Google Play Console
- [ ] Screenshots y video de gameplay
- [ ] Descripción en español e inglés
- [ ] Icono del juego (diseño geométrico llamativo)
- [ ] Categoría: Arcade / Música
- [ ] Publicar en producción

### 10.4 — Lanzamiento PC

- [ ] Exportar para Windows (.exe) y Linux
- [ ] Publicar en itch.io (gratis con opción de donación)
- [ ] (Opcional futuro) Steam Direct

---

## ═══════════════════════════════════════

## ETAPA 11: POST-LANZAMIENTO 🔄

## ═══════════════════════════════════════

### Duración: Continuo

- [ ] Nuevos niveles oficiales cada 2-4 semanas
- [ ] "Nivel de la semana" (destacado de la comunidad)
- [ ] Eventos temáticos (Halloween, Navidad)
- [ ] Analíticas básicas (cuántos juegan, retención)
- [ ] Responder reviews en Play Store

---

# 📊 CRONOGRAMA VISUAL

```
MES 1    MES 2    MES 3    MES 4    MES 5    MES 6    MES 7    MES 8    MES 9    MES 10   MES 11   MES 12
========|========|========|========|========|========|========|========|========|========|========|========
[ETAPA 0]  FUNDACIÓN
[ ETAPA 1           ]  PROTOTIPO
         [ ETAPA 2   ]  OBSTÁCULOS
                  [ ETAPA 3  ]  MÚSICA
                           [ ETAPA 4                ]  5 NIVELES
                                     [ ETAPA 5  ]  UI/UX
                                                [ ETAPA 6             ]  CREADOR DE NIVELES
                                                           [ ETAPA 7              ]  ONLINE
                                                                              [ETAPA 8]  $
                                                                              [ ETAPA 9  ] POLISH
                                                                                        [ ETAPA 10   ] TEST & LAUNCH 🚀
                                                                                                     [ETAPA 11...] POST
```

---

# 💸 PRESUPUESTO ESTIMADO

| Concepto                              | Costo                      |
| ------------------------------------- | -------------------------- |
| DeepSeek API (12 meses, uso moderado) | ~$50 USD                   |
| Google Play Console (pago único)      | $25 USD                    |
| AdMob                                 | Gratis                     |
| Godot Engine                          | Gratis                     |
| Sonidos/Música                        | Gratis (libre de derechos) |
| Servidor (minipc propio)              | Solo electricidad          |
| **TOTAL**                             | **~$75 USD**               |

---

# 🎓 QUÉ APRENDE CAMILO EN CADA ETAPA

| Etapa | Habilidades                                            |
| ----- | ------------------------------------------------------ |
| 0     | Organización de proyectos, Git, estructura de archivos |
| 1     | Física 2D, inputs, colisiones, game loop               |
| 2     | Herencia, composición, patrones de diseño              |
| 3     | Audio, timing, BPM, sincronización                     |
| 4     | Diseño de niveles, balance, progresión                 |
| 5     | UI/UX, animaciones, transiciones                       |
| 6     | Herramientas, editor visual, UX de creadores           |
| 7     | HTTP, APIs REST, bases de datos, backend               |
| 8     | Monetización, IAP, AdMob, modelo de negocio            |
| 9     | Shaders, partículas, optimización, profiling           |
| 10    | Testing, publicación, marketing básico                 |

---

# 📝 NOTAS IMPORTANTES

1. **Cada etapa produce algo jugable.** No se avanza hasta que funcione.
2. **Camilo debe escribir al menos el 60% del código.** Yesid guía, corrige y explica.
3. **La IA (DeepSeek) se usa para:**
   - Generar placeholders de sprites (formas geométricas)
   - Ayudar con bugs difíciles
   - Sugerir estructuras de código (que Camilo luego implementa)
   - NUNCA para escribir el código final directamente
4. **Iterar rápido:** mejor tener un prototipo feo que funcione a un diseño perfecto en papel.
5. **Divertirse:** si Camilo se frustra, cambiar a tarea más fácil o tomar descanso.

---

_Documento creado el 2026-07-19. Se actualizará según avance el proyecto._
