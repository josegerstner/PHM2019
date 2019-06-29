import ar.edu.unsam.domain.funcion.Funcion
import ar.edu.unsam.domain.pelicula.Pelicula
import ar.edu.unsam.domain.pelicula.Saga
import java.time.LocalDateTime
import org.junit.Assert
import org.junit.Test
import java.sql.Connection
import java.sql.DriverManager
import java.sql.PreparedStatement
import java.sql.ResultSet

class TestRodaje {
	
	var elPadrino = new Pelicula(1972, "The Godfather", 9.2f, "Crime, Drama")
	var elPadrino2 = new Pelicula(1974, "The Godfather: Part II", 9.0f, "Crime, Drama")
	var clubDeLaPelea = new Pelicula(1999, "Fight Club", 8.8f, "Drama")
//	var correForrest = new Pelicula(1994, "Forrest Gump", 8.8f, "Drama, Romance")
//	var inception = new Pelicula(2010, "Inception", 8.8f, "Action, Adventure, Sci-Fi")
//	var matrix = new Pelicula(1999, "Matrix", 8.7f, "Action, Sci-Fi ")
//	var interestelar = new Pelicula(2014, "Interstellar", 8.6f, "Adventure, Drama, Sci-Fi")
//	var capitanaMarvel = new Pelicula(2019, "Captain Marvel", 7.1f, "Action, Adventure, Sci-Fi")
	var sagaElPadrino = new Saga(#[elPadrino, elPadrino2].toSet, "The Godfather Saga",2000, 9.4f, "Crime, Drama", 6)	
		
	def static getElPadrino() {
		new Pelicula(1972, "The Godfather", 9.2f, "Crime, Drama")
	}
	
	def static Connection miConexion() {
		DriverManager.getConnection("jdbc:mysql://localhost:3306/joits", "root", "root");
	}
	
	/*** PELIS DE ACCION ***/
	def static PreparedStatement consultoPorPelisDeAccion() {
		 miConexion.prepareStatement(
		 	"SELECT titulo, anio, puntaje FROM Pelicula
				WHERE genero LIKE '%Action%';");
	}
	
	def static ResultSet resultadoPelisDeAccion() {
		consultoPorPelisDeAccion.executeQuery();
	}
	
	def pelisDeAccion() {
		var pelis = newArrayList
		if(resultadoPelisDeAccion.next){
			pelis.add(resultadoPelisDeAccion.getString("titulo"))
		}
	}
	
	/************ --------------------------------- **************/
	
	/*** PELIS CON 3 ENTRADAS O MAS ***/
	
	def static PreparedStatement consultoPorRodajesConTresOMasEntradas() {
		 miConexion.prepareStatement(
		 	"SELECT E.pelicula_id, P.titulo, COUNT(1) AS cantidad
				FROM Entrada E 
				INNER JOIN Pelicula P ON P.id = E.pelicula_id
				GROUP BY E.pelicula_id
				HAVING cantidad >= 3
				ORDER BY P.id;");
	}
	
	def static ResultSet resultadoPelisCon3OMasEntradas() {
		consultoPorRodajesConTresOMasEntradas.executeQuery();
	}
	
	def pelisCon3Entradas() {
		var pelis = newArrayList
		if(resultadoPelisCon3OMasEntradas.next){
			pelis.add(resultadoPelisCon3OMasEntradas.getString("titulo"))
		}
	}
	
	/************ --------------------------------- **************/
	
	@Test
	def void probarClubDeLaPelea(){
		Assert.assertEquals(30, clubDeLaPelea.precioEntrada, 0.1)
	}
	
	@Test
	def void probarSagaElPadrino(){
		sagaElPadrino.funciones = #[new Funcion(sagaElPadrino, LocalDateTime.now, "Hoyts El Padrino")].toSet
		Assert.assertEquals(120, sagaElPadrino.precioEntrada, 0.1)
	}
	
	@Test
	def void traerPeliculasDeAccion(){
		var pelisDeAccionTest = newArrayList
		pelisDeAccionTest.add("Inception")
		pelisDeAccionTest.add("Matrix")
		pelisDeAccionTest.add("Captain Marvel")
		
		try{
			Assert.assertEquals(pelisDeAccionTest, pelisDeAccion)
		}catch(Exception e){
			e.printStackTrace
		}finally{
			miConexion.close
		}
	}
	
	@Test
	def void traerRodajesCon3EntradasOMas(){
		var pelisCon3EntradasTest = newArrayList
		pelisCon3EntradasTest.add("Fight Club")
		pelisCon3EntradasTest.add("Interstellar")
		
		try{
			Assert.assertEquals(pelisCon3EntradasTest, pelisCon3Entradas)
		}catch(Exception e){
			e.printStackTrace
		}finally{
			miConexion.close
		}
	}
	
}