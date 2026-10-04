/**
 * Configuración global de la suite Karate.
 *
 * Karate invoca esta función al inicio de cada escenario y expone el objeto
 * devuelto como variables disponibles en todos los features, de modo que los
 * escenarios solo declaran el `path` y heredan el `baseUrl`.
 *
 * @returns {object} Objeto de configuración con `baseUrl` de la API bajo prueba.
 */
function fn() {
  var config = {
    baseUrl: 'https://petstore.swagger.io/v2'
  };
  return config;
}