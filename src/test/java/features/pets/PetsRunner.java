package features.pets;

import io.karatelabs.core.Runner;
import io.karatelabs.core.SuiteResult;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertTrue;

/**
 * Runner del subconjunto de escenarios de gestión de mascotas.
 *
 * Ejecuta únicamente los features etiquetados con {@code @pets} y genera el
 * reporte HTML en {@code target/karate-reports}. Complementa a
 * {@code TestRunner}, que corre la suite completa.
 */
class PetsRunner {

    /**
     * Corre los escenarios etiquetados {@code @pets} y falla si alguno no pasa.
     *
     * <p>Se ejecuta en un solo hilo ({@code parallel(1)}) para no saturar la
     * API pública compartida.
     */
    @Test
    void testAll() {
        SuiteResult result = Runner.path("features")
        .tags("@pets")
        .outputHtmlReport(true)
        .parallel(1);
        assertTrue(result.isPassed());
    }
}
