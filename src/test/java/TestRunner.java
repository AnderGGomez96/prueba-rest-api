import io.karatelabs.core.Runner;
import io.karatelabs.core.SuiteResult;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertTrue;

/**
 * Runner de la suite completa de pruebas REST de PetStore.
 *
 * Ejecuta todos los features de la carpeta {@code features} (creación y
 * gestión de mascotas) y genera el reporte HTML en
 * {@code target/karate-reports}.
 */
class TestRunner {

    /**
     * Corre la suite completa y falla si algún escenario no pasa.
     *
     * <p>Se ejecuta en un solo hilo ({@code parallel(1)}) para no saturar la
     * API pública compartida.
     */
    @Test
    void testAll() {
        SuiteResult result = Runner.path("features")
                .outputHtmlReport(true)
                .parallel(1);
        assertTrue(result.isPassed());
    }
}
