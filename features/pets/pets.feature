# Casos 2 a 4 del reto: consultar por ID, actualizar nombre y estado, y
# consultar la mascota modificada por status.
#
# El Background crea una mascota propia en cada escenario usando el helper
# `create-pet.feature`, de modo que los casos son independientes y pueden
# correr en cualquier orden.
Feature: Gestionar mascotas

  Background:
    * def petResponse = call read('classpath:features/pets/helpers/create-pet.feature')
    * def petData = petResponse.response
    Given url baseUrl

  # Caso 2: la mascota recién creada se recupera intacta por su ID.
  @pets
  Scenario: Obtener una mascota por ID
    And path '/pet/', petData.id
    When method get
    Then status 200
    And match response == petData

  # Caso 3: cambian el nombre y el estado a `sold`; el cambio se verifica
  # consultando la mascota de nuevo, porque el update no devuelve el objeto.
  @pets
  Scenario: Actualizar una mascota existente
    * def updateData = {}
    * set updateData.name = karate.faker.firstName()
    * set updateData.status = 'sold'
    * set petId = petData.id
    * def result = call read('classpath:features/pets/helpers/update-pet.feature') updateData
    And path '/pet/', petData.id
    When method get
    Then status 200
    And match response.name == updateData.name
    And match response.status == updateData.status

  # Caso 4: `findByStatus` devuelve todas las mascotas de la tienda con ese
  # estado, así que se filtra la respuesta por el ID propio antes de validar.
  @pets
  Scenario: Consultar la mascota modificada por estatus de busqueda
    * def updateData = {}
    * set updateData.name = karate.faker.firstName()
    * set updateData.status = 'sold'
    * set petId = petData.id
    * def result = call read('classpath:features/pets/helpers/update-pet.feature') updateData
    And path '/pet/findByStatus'
    And param status = updateData.status
    When method get
    Then status 200
    * def petFound = karate.filter(response, function(x){ return x.id == petData.id })
    And assert petFound.length > 0
    And match petFound[0] contains { name: '#(updateData.name)', status: '#(updateData.status)' }
