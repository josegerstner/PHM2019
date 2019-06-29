package ar.edu.unsam.domain.pelicula

import ar.edu.unsam.domain.funcion.Funcion
import java.util.Set
import org.eclipse.xtend.lib.annotations.Accessors
import org.neo4j.ogm.annotation.NodeEntity
import org.neo4j.ogm.annotation.Relationship
import org.uqbar.commons.model.annotations.Observable

@NodeEntity(label="Saga")
@Accessors
@Observable
class Saga extends Pelicula {

//	@OneToMany(fetch=FetchType.EAGER)
	@Relationship(type = "MOVIE_FROM_SAGA", direction = "OUTGOING")
	Set<Pelicula> peliculas = newHashSet
	
//	@Column
	int nivelDeClasico
	
	val PLUS = 5

	new() {
		super()
		this.precioBase = 10.00
	}

	new(String titulo, int anio, float puntaje, String genero) {
		super(anio, titulo, puntaje, genero)
		this.peliculas = peliculas
		this.precioBase = 10.00
	}

	new(Set<Pelicula> peliculas, String titulo, int anio, float puntaje, String genero, int nivelDeClasico) {
		super(anio, titulo, puntaje, genero)
		this.peliculas = peliculas
		this.nivelDeClasico = nivelDeClasico
		this.precioBase = 10.00
	}
	
	new(Set<Pelicula> peliculas, String titulo, int anio, float puntaje, String genero, int nivelDeClasico, Set<Funcion> funciones) {
		super(anio, titulo, puntaje, genero, funciones)
		this.peliculas = peliculas
		this.nivelDeClasico = nivelDeClasico
		this.funciones = funciones
		this.precioBase = 10.00
	}

	def precioPorFuncion() {
		this.funciones.fold(0.00, [total, funcion|total + funcion.getPrecioPorDiaDeFuncion])
	}

	override getPrecioEntrada() {
		this.precioBase * this.peliculas.size * this.nivelDeClasico
	}

	override tieneValorBuscado(String valorBusqueda) {
		this.peliculas.exists[pelicula|pelicula.tieneValorBuscado(valorBusqueda)]
	}

}
