# Conclusiones

## De qué iba la prueba

Era probar la API de PetStore, la de mascotas. Cuatro pasos, uno detrás del otro: crear una mascota, buscarla por su ID, cambiarle el nombre y el estado a `sold`, y volver a encontrarla, ahora por estado. El enunciado pedía Karate y evidencia que se pudiera repetir, así que todo quedó dentro del repositorio: las pruebas, los datos de entrada y el reporte.

## Por qué me quedé con Karate

Karate era la opción que pedía el reto, y ya lo conocía, así que la decisión fue fácil. Con REST Assured, el mismo caso termina siendo clases de test, armar el JSON a mano y verificar campo por campo. Acá el escenario se lee casi como la documentación de la API.

Lo que más me sirvió:

- El runner y el reporte vienen de fábrica. Con JUnit fue un archivo que apunta a `features` y nada más.
- `karate.faker` para los datos aleatorios, sin sumar otra dependencia.
- `call read(...)` para usar los mismos helpers en varios escenarios, y `karate.filter` para buscar dentro de una respuesta grande.

## Cómo quedaron las pruebas

Cuatro escenarios en dos features, más dos helpers. Uno crea la mascota con ID y nombre al azar, a partir de `valid-pet.json`, y revisa que la API devuelva exactamente lo que se envió. El otro hace tres cosas: la busca por ID, le cambia el nombre y el estado, y la busca por estado. Los helpers quedaron marcados `@ignore` para que no corran solos, y devuelven la respuesta para encadenar un caso con el siguiente.

Como cada escenario de gestión necesita el mismo ID de principio a fin, cada uno crea su propia mascota en el Background. Así no dependen entre sí y pueden correr en cualquier orden.

## Lo que me costó

Dos detalles de la API. El primero, el update. Uno espera un `PUT` con JSON, y no: PetStore actualiza con `POST /pet/{id}` y campos de formulario. La respuesta tampoco trae la mascota, solo un mensaje con el ID. Tocó leer bien el Swagger y, para verificar el cambio de verdad, consultar la mascota después.

El segundo, `findByStatus`. Devuelve todas las mascotas de la tienda con ese estado, cientos de registros de otros usuarios, y comparar la respuesta completa no tenía sentido. La salida fue filtrar por el ID propio con `karate.filter` y revisar que la encontrada trajera el nombre y el estado nuevos.

## Para cerrar

Los cuatro escenarios pasan y el reporte HTML queda como evidencia lista para revisar. Una cosa más: la creación de la mascota vive en `pets-create.feature` y también en el helper `create-pet.feature`. No es duplicación por descuido, es una decisión. El feature deja el caso del reto legible de principio a fin, tal como lo pide el enunciado, y el helper es el apoyo que usan los demás escenarios. Cada archivo tiene su papel. Por lo demás, el mantenimiento quedó en un par de archivos.
