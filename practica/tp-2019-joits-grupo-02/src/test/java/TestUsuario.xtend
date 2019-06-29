import ar.edu.unsam.domain.entrada.Entrada
import ar.edu.unsam.domain.funcion.Funcion
import ar.edu.unsam.domain.usuario.Usuario
import java.time.LocalDateTime
import org.junit.Assert
import org.junit.Test

class TestUsuario {
	
	var carlos = new Usuario("a","Carlos", "García", 25, "1234")
	var david = new Usuario("b","David", "Lebón", 25, "1234")
	var rodolfo = new Usuario("c","Rodolfo", "Páez", 20, "1234")
	
	@Test
	def void coincideSaldoUsuario(){
		carlos.saldo = 100
		Assert.assertEquals(100, carlos.saldo, 0.1)
	}

	def void noCoincideSaldoUsuario(){
		carlos.saldo = 100
		Assert.assertNotEquals(200, carlos.saldo)
	}
	
	@Test
	def void sonAmigos(){
		carlos.amigos.add(david)
		Assert.assertTrue(carlos.esAmigo(david))
	}
	
	@Test
	def void noSonAmigos(){
		rodolfo.amigos.add(carlos)
		Assert.assertFalse(carlos.esAmigo(rodolfo))
	}
	
	@Test
	def void encuentroUsuario(){
		Assert.assertTrue(carlos.tieneValorBuscado("gAR"))
	}

	@Test
	def void carlosCompraEntrada() {
		Assert.assertEquals(0, carlos.entradas.size)
		carlos.comprarEntrada(new Entrada(TestRodaje.elPadrino, new Funcion(TestRodaje.elPadrino, LocalDateTime.now, "Sala A")))
		Assert.assertEquals(1, carlos.entradas.size)
	}
	
	@Test
	def void noEncuentroUsuario(){
		Assert.assertFalse(carlos.tieneValorBuscado("Páez"))
	}
}
