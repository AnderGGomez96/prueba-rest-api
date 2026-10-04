# Helper reutilizable: crea una mascota con datos aleatorios.
#
# Marcado `@ignore` para que no corra como escenario independiente; el
# Background de `pets.feature` lo invoca con `call read(...)`.
#
# Entradas: ninguna (usa `valid-pet.json` y `karate.faker`).
# Salidas: la respuesta del POST queda en `response`, accesible desde el
# llamador como `petResponse.response`.
Feature: Crear mascotas helpers

  @ignore
  Scenario: Agregar una nueva mascota
    # Carga la plantilla y la clona para no mutar el JSON original.
    * def base = read('classpath:test-data/pets/valid-pet.json')
    * copy pet = base
    # Datos aleatorios: ID y nombre únicos por ejecución.
    * def nuevoId = karate.faker.randomInt(100000000, 999999999)
    * def nuevoNombre = karate.faker.firstName()
    * set pet
      | path          | value       |
      | id            | nuevoId     |
      | name          | nuevoNombre |
      | category.name | 'premium'   |
      | tags[0].name  | 'nuevo'     |
    Given url baseUrl
    And path '/pet'
    And request pet
    When method post
    Then status 200
    And match response == pet
    * def petData = response
