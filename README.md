# Prueba REST API — PetStore con Karate

Pruebas automatizadas de los servicios REST de PetStore (https://petstore.swagger.io/) que cubren los cuatro casos del reto:

1. Agregar una mascota a la tienda.
2. Consultar la mascota ingresada previamente (búsqueda por ID).
3. Actualizar el nombre de la mascota y su estado a `sold`.
4. Consultar la mascota modificada por estado (búsqueda por status).

Implementadas con Karate 2.1.3 sobre JUnit 5, con datos de entrada en JSON, helpers reutilizables y reporte HTML integrado.

> **Solo necesitas Java 21 y conexión a internet.** Maven no hace falta: el repositorio incluye el Maven Wrapper (`mvnw`), que lo descarga solo la primera vez.

## Requisitos

| Requisito | ¿Obligatorio? | Detalle |
| --- | --- | --- |
| Java 21 o superior | Sí | Se verifica con `java -version`. |
| Conexión a internet | Sí | La primera ejecución descarga dependencias y las pruebas llaman a la API pública. |
| Git | No | Solo si vas a clonar. También puedes descargar el ZIP. |
| Maven | No | Usa el wrapper incluido; no lo instales. |
| Karate (JAR o CLI) | No | Alternativa sin Maven si ya lo tienes instalado; ver más abajo. |

## Paso 1 — Instalar Java 21

### Windows

Abre **PowerShell** y pega este comando:

```powershell
winget install EclipseAdoptium.Temurin.21.JDK
```

Si no tienes `winget` o usas otro sistema, descarga el instalador de Java 21 desde <https://adoptium.net/> y sigue el asistente (siguiente, siguiente, finalizar).

### Verificar que quedó bien

Abre una terminal **nueva** (importante: una ya abierta no toma los cambios) y ejecuta:

```bash
java -version
```

Debe mostrar algo como `openjdk version "21.0.x"`. Si dice que `java` no se reconoce, reinstala marcando la opción de agregar Java al PATH.

## Paso 2 — Obtener el repositorio

**Opción A (con Git):**

```bash
git clone <URL_DEL_REPOSITORIO>
cd prueba-rest-api
```

**Opción B (sin Git):** descarga el ZIP del repositorio, descomprímelo y abre una terminal dentro de la carpeta `prueba-rest-api`.

## Paso 3 — Ejecutar las pruebas

Desde la carpeta del proyecto:

**Windows (PowerShell o CMD):**

```powershell
.\mvnw.cmd test
```

**Linux / macOS:**

```bash
./mvnw test
```

La primera ejecución descarga Maven y las dependencias (tarda unos minutos). Las siguientes tardan segundos.

Al terminar debes ver exactamente esto en consola:

```
features:    4 | passed:    4 | all passed
scenarios:   4 | passed:    4 | all passed
```

Si aparece esa línea con `all passed` y `BUILD SUCCESS`, los cuatro casos del reto pasaron.

## Paso 4 — Ver el reporte HTML

El reporte muestra cada escenario con cada petición y respuesta: es la evidencia de la ejecución.

**Windows:**

```powershell
start target\karate-reports\karate-summary.html
```

**Linux:** `xdg-open target/karate-reports/karate-summary.html`  
**macOS:** `open target/karate-reports/karate-summary.html`

## Ejecutar solo una parte de la suite

- Solo los escenarios de gestión de mascotas (`@pets`):

  ```powershell
  .\mvnw.cmd test -Dtest=PetsRunner
  ```

  En Linux/macOS: `./mvnw test -Dtest=PetsRunner`.

- Suite completa: `.\mvnw.cmd test` equivale a `-Dtest=TestRunner`.

## Si ya tienes Karate instalado (JAR o CLI)

Si ya trabajas con Karate, no necesitas Maven para esta suite. Descarga el JAR standalone directamente desde la release: <https://github.com/karatelabs/karate/releases/download/v2.1.3/karate-2.1.3.jar>.

Ejecuta siempre desde la raíz del proyecto, que es donde está `karate-config.js`.

**Con el JAR standalone:**

```powershell
# Suite completa (el reporte queda en target/karate-reports)
java -jar karate-2.1.3.jar features

# Solo los escenarios @pets (en PowerShell, "@pets" va entre comillas)
java -jar karate-2.1.3.jar -t "@pets" features

# El subcomando run es equivalente
java -jar karate-2.1.3.jar run -t "@pets" features
```

**Con el CLI `karate` (v2):**

```bash
karate run features
karate run -t "@pets" features
```

El reporte se genera en el mismo lugar que con Maven (`target/karate-reports/karate-summary.html`), así que el Paso 4 aplica igual.

Y si ya tienes Maven instalado, `mvn test` funciona tal cual, sin el wrapper.

## Problemas comunes

| Síntoma | Solución |
| --- | --- |
| `java` no se reconoce como comando | Java no está instalado o la terminal es vieja. Repite el Paso 1 y abre una terminal nueva. |
| `release version 21 not supported` | Tu `java` es anterior a 21. Instala el JDK 21 y revisa `java -version`. |
| La primera ejecución tarda mucho | Es normal: descarga Maven y todas las dependencias. Déjala terminar. |
| Errores de red o de timeout | Las pruebas llaman a una API pública. Revisa tu conexión o proxy y vuelve a intentar. |
| En Linux/macOS: `Permission denied: ./mvnw` | Ejecuta `chmod +x mvnw` y reintenta. |
| `BUILD FAILURE` con escenarios en rojo | Abre el reporte del Paso 4; el detalle suele indicar red o un dato inesperado de la API pública. |

## Casos cubiertos

| Escenario | Método | Endpoint | Feature |
| --- | --- | --- | --- |
| Agregar una nueva mascota | POST | `/pet` | `features/pets/pets-create.feature` |
| Obtener una mascota por ID | GET | `/pet/{id}` | `features/pets/pets.feature` |
| Actualizar una mascota existente | POST | `/pet/{id}` | `features/pets/pets.feature` |
| Consultar la mascota modificada por estatus | GET | `/pet/findByStatus` | `features/pets/pets.feature` |

## Estructura del proyecto

```
prueba-rest-api/
├── features/
│   └── pets/
│       ├── pets-create.feature        # Caso: crear mascota
│       ├── pets.feature               # Casos: consultar, actualizar, consultar por status
│       └── helpers/
│           ├── create-pet.feature     # Helper @ignore: crea y devuelve la mascota
│           └── update-pet.feature     # Helper @ignore: actualiza nombre y status
├── src/test/java/
│   ├── TestRunner.java                # Runner JUnit: suite completa
│   └── features/pets/PetsRunner.java  # Runner JUnit: solo @pets
├── test-data/pets/valid-pet.json      # Plantilla de mascota
├── karate-config.js                   # Configuración global (baseUrl)
├── mvnw / mvnw.cmd                    # Maven Wrapper: no requiere Maven instalado
├── .mvn/wrapper/                      # Configuración del wrapper (Maven 3.9.9)
└── pom.xml
```

## Detalles de implementación

- Los ID de las mascotas se generan aleatoriamente con `karate.faker.randomInt(100000000, 999999999)` para evitar colisiones con datos de otros usuarios de la API pública.
- Los helpers están marcados con `@ignore` para que no se ejecuten como escenarios independientes; se invocan con `call read(...)` y devuelven la respuesta (incluido el ID creado) a la feature principal.
- La actualización usa el endpoint `POST /pet/{petId}` con `form field` (así lo define PetStore), no `PUT` con JSON.
- La búsqueda por status filtra la respuesta con `karate.filter` por el ID generado, porque `findByStatus` devuelve todas las mascotas de la tienda con ese estado.

## Reportes

- Reporte HTML de Karate: `target/karate-reports/karate-summary.html`.
- Reporte Surefire/JUnit: `target/surefire-reports/`.
- Evidencia versionada: `evidencia/reporte-karate.html` (el mismo reporte en un único archivo autocontenido, listo para abrir sin conexión).

Última ejecución: 4 features, 4 escenarios, todos en verde.
