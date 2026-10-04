# Caso 1 del reto: agregar una mascota a la tienda.
#
# Toma la plantilla `valid-pet.json`, le asigna ID y nombre aleatorios para no
# chocar con datos de otros usuarios de la API pública, y valida que el POST
# devuelva exactamente la mascota enviada.
Feature: Crear una nueva mascota

  @pets
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
