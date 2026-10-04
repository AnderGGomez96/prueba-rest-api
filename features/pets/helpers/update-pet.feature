# Helper reutilizable: actualiza el nombre y el estado de una mascota.
#
# Marcado `@ignore` para que no corra como escenario independiente; los
# escenarios de `pets.feature` lo invocan con `call read(...) updateData`
# después de definir `petId`.
#
# Entradas: `petId` (variable previa) y `name` + `status` (argumento del call).
# Salidas: la respuesta del POST en `response`. PetStore responde solo con un
# `message` que contiene el ID, no con la mascota; por eso la verificación del
# cambio se hace consultando la mascota después.
Feature: Actualizar mascotas helpers

  @ignore
  Scenario: Actualizar una mascota
    Given url baseUrl
    And path '/pet/', petId
    # PetStore actualiza con POST y form fields, no con PUT y JSON.
    And form field name = name
    And form field status =  status
    When method post
    Then status 200
    And match response.message == '#(petId + "")'
