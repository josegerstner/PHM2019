package ar.edu.unsam.domain.pelicula

import ar.edu.unsam.domain.funcion.Funcion
import java.util.Set
import javax.persistence.Inheritance
import javax.persistence.InheritanceType
import org.apache.commons.lang.StringUtils
import org.bson.types.ObjectId
import org.eclipse.xtend.lib.annotations.Accessors
import org.mongodb.morphia.annotations.Entity
import org.mongodb.morphia.annotations.Id
import org.neo4j.ogm.annotation.GeneratedValue
import org.neo4j.ogm.annotation.NodeEntity
import org.neo4j.ogm.annotation.Property
import org.neo4j.ogm.annotation.Transient
import org.uqbar.commons.model.annotations.Observable

@NodeEntity(label="Pelicula")
@Entity
@Observable
@Inheritance(strategy=InheritanceType.JOINED)
@Accessors
class Pelicula {

	@Id
	ObjectId id
	
	@org.neo4j.ogm.annotation.Id @GeneratedValue
	Long idNeo
	
	@Property(name="titulo")
	String titulo
	
	@Transient
	float puntaje
	
	@Property
	String genero
	
	@Transient
	Set<Funcion> funciones = newHashSet
	
	@Transient
	double precioBase = 30.00 //contemplar bigdecimal
	
	@Property
	int anio

	new() {		}

	new(int anio,String titulo, float puntaje, String genero) {
		this.titulo = titulo
		this.anio = anio
		this.puntaje = puntaje
		this.genero = genero
		this.precioBase = 30.00
	}
	
	new(int anio,String titulo, float puntaje, String genero, Set<Funcion> funciones) {
		this.titulo = titulo
		this.anio = anio
		this.puntaje = puntaje
		this.genero = genero
		this.funciones = funciones
		this.precioBase = 30.00
	}
	
	def double getPrecioEntrada() {
		this.precioBase
	}

	def tieneValorBuscado(String valorBusqueda) {
		return StringUtils.containsIgnoreCase(titulo, valorBusqueda)
	}
}
