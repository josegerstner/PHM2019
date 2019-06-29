package ar.edu.unsam.arena.runnable

import ar.edu.unsam.domain.entrada.Entrada
import ar.edu.unsam.domain.funcion.Funcion
import ar.edu.unsam.domain.pelicula.Pelicula
import ar.edu.unsam.domain.pelicula.Saga
import ar.edu.unsam.domain.usuario.Usuario
import ar.edu.unsam.repos.pelicula.RepoPeliculas
import ar.edu.unsam.repos.usuario.RepoUsuarios
import java.time.LocalDateTime
import java.util.Random
import java.util.Set
import org.uqbar.arena.bootstrap.CollectionBasedBootstrap

class JoitsBootstrap extends CollectionBasedBootstrap {
	
	override run() {
		
		RepoPeliculas.instance.delete
		
		val padrino = new Pelicula(1972, "The Godfather", 9.2f, "Crime, Drama", this.getFuncionesRandom())
		val padrino2 = new Pelicula(1974, "The Godfather: Part II", 9.0f, "Crime, Drama", this.getFuncionesRandom())
		val clubDeLaPelea = new Pelicula(1999, "Fight Club", 8.8f, "Drama", this.getFuncionesRandom())
		val forrestGump = new Pelicula(1994, "Forrest Gump", 8.8f, "Drama, Romance", this.getFuncionesRandom())
		val inception = new Pelicula(2010, "Inception", 8.8f, "Action, Adventure, Sci-Fi", this.getFuncionesRandom())
		val matrix = new Pelicula(1999, "Matrix", 8.7f, "Action, Sci-Fi ", this.getFuncionesRandom())
		val interestellar = new Pelicula(2014, "Interstellar", 8.6f, "Adventure, Drama, Sci-Fi", this.getFuncionesRandom())
		val capitanaMarvel = new Pelicula(2019, "Captain Marvel", 7.1f, "Action, Adventure, Sci-Fi", this.getFuncionesRandom())
		
		RepoPeliculas.instance.create(padrino)
		RepoPeliculas.instance.create(padrino2)
		val padrinoMongo = RepoPeliculas.instance.searchByExample(padrino).get(0)
		val padrino2Mongo = RepoPeliculas.instance.searchByExample(padrino2).get(0)
		val sagaPadrino = new Saga(#[padrinoMongo,padrino2Mongo].toSet,"The Godfather Collection", 2000, 9.2f, "Crime, Drama", 9, this.getFuncionesRandom())
		
		RepoPeliculas.instance => [
			create(clubDeLaPelea)
			create(forrestGump)
			create(inception)
			create(matrix)
			create(interestellar)
			create(capitanaMarvel)
			create(sagaPadrino)
		
		]

		RepoUsuarios.instance => [
			create(new Usuario("a", "Nombre", "Apeliido", 30, "") => [
				saldo = 1000
				entradas = #[entradaRandom, entradaRandom].toSet
				amigos = #{}
			])
			create(new Usuario("cgarcia", "Carlos", "García", 25, "1234") => [
				saldo = 1000
				entradas = #[entradaRandom, entradaRandom].toSet
				amigos = #{}
			])
			create(new Usuario("osc", "Óscar", "Alvarez", 30, "1234") => [
				saldo = 1000
				entradas = #[entradaRandom, entradaRandom].toSet
				amigos = #{}
			])
			create(new Usuario("rub", "Rubén", "Carmona", 30, "1234") => [
				saldo = 1000
				entradas = #[entradaRandom, entradaRandom].toSet
				amigos = #{}
			])
			create(new Usuario("hug", "Hugo", "Ferrer", 30, "1234") => [
				saldo = 1000
				entradas = #[entradaRandom, entradaRandom].toSet
				amigos = #{}
			])
			create(new Usuario("mar", "Marcos", "Guerrero", 30, "1234") => [
				saldo = 1000
				entradas = #[entradaRandom, entradaRandom].toSet
				amigos = #{}
			])
			create(new Usuario("rau", "Raúl", "Romero", 30, "1234") => [
				saldo = 1000
				entradas = #[entradaRandom, entradaRandom].toSet
				amigos = #{}
			])
			create(new Usuario("san", "Santiago", "Vargas", 30, "1234") => [
				saldo = 1000
				entradas = #[entradaRandom, entradaRandom].toSet
				amigos = #{}
			])

		]

		val usuario = RepoUsuarios.instance.searchById(RepoUsuarios.instance.allInstances.get(1).id)
		val amigoAux = RepoUsuarios.instance.allInstances.get(0)
		val amigo = RepoUsuarios.instance.searchById(amigoAux.id)
		amigo.entradas.forEach[entrada | Entrada.searchPeliculaById(entrada.idPelicula)]
		usuario.amigos = #[RepoUsuarios.instance.searchById(amigo.id)].toSet
		RepoUsuarios.instance.update(usuario)
		
	}
	
	private def Entrada getEntradaRandom(Usuario usuario) {
		val peliculas = RepoPeliculas.instance.allInstances
		val peliculaAux = peliculas.get(new Random().nextInt(peliculas.size))
		val pelicula = RepoPeliculas.instance.searchByObjectId(peliculaAux.id)
		val funciones = pelicula.funciones
		val funcion = funciones.get(new Random().nextInt(funciones.size))
		new Entrada(pelicula, funcion, usuario)
	}
	
	private def Set<Funcion> getFuncionesRandom() {
		val salas = newHashSet("A", "B", "C", "Premium")
		val iFun = new Random().nextInt(12) + 3
		var Set<Funcion> funciones = newHashSet
		for (var i = 0; i < iFun; i++) {
			val hours = new Random().nextInt(64) + -6
			funciones.add(
				new Funcion(LocalDateTime.now.plusHours(hours),
					"Sala " + salas.get(new Random().nextInt(salas.size))))
		}
		funciones
	}
	
	override isPending(){
		RepoUsuarios.instance.allInstances.isEmpty
	}
	
}
