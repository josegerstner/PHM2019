package ar.edu.unsam.domain.entrada

import ar.edu.unsam.domain.funcion.Funcion
import ar.edu.unsam.domain.pelicula.Pelicula
import ar.edu.unsam.domain.usuario.Usuario
import ar.edu.unsam.repos.pelicula.RepoPeliculas
import com.fasterxml.jackson.annotation.JsonIgnore
import com.fasterxml.jackson.annotation.JsonIgnoreProperties
import com.fasterxml.jackson.annotation.JsonInclude
import com.fasterxml.jackson.annotation.JsonInclude.Include
import com.fasterxml.jackson.databind.annotation.JsonDeserialize
import com.fasterxml.jackson.databind.annotation.JsonSerialize
import com.fasterxml.jackson.datatype.jsr310.deser.LocalDateTimeDeserializer
import com.fasterxml.jackson.datatype.jsr310.ser.LocalDateTimeSerializer
import java.time.LocalDateTime
import java.time.format.DateTimeFormatter
import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.Transient
import org.bson.types.ObjectId
import org.eclipse.xtend.lib.annotations.Accessors
import org.neo4j.ogm.annotation.EndNode
import org.neo4j.ogm.annotation.GeneratedValue
import org.neo4j.ogm.annotation.Property
import org.neo4j.ogm.annotation.RelationshipEntity
import org.neo4j.ogm.annotation.StartNode
import org.uqbar.commons.model.annotations.Observable

@Entity
@Observable
@Accessors
@JsonInclude(Include.NON_NULL)
@JsonIgnoreProperties(value="changeSupport")
@RelationshipEntity(type="MOVIES_SEEING")
class Entrada {

	@Id
	@org.neo4j.ogm.annotation.Id @GeneratedValue
	Long id

	@Property
	@Column
	@JsonSerialize(using=LocalDateTimeSerializer)
	@JsonDeserialize(using=LocalDateTimeDeserializer)
	LocalDateTime fechaHora

	@Property
	@Column
	Double precio

	@Property(name="titulo")
	@Column
	String tituloPelicula

	@Transient
	@JsonIgnore
	@EndNode Pelicula pelicula

	@org.neo4j.ogm.annotation.Transient
	@Column(length=100)
	String idPelicula

	@Transient
	@JsonIgnore
	@StartNode Usuario usuario

	@JsonIgnore
	transient Funcion funcion

	new() {
	}

	new(Pelicula pelicula, Funcion funcion) {
		this.fechaHora = LocalDateTime.now
		this.pelicula = pelicula
		this.funcion = funcion
		this.precio = pelicula.precioEntrada + funcion.precio
		this.tituloPelicula = pelicula.titulo
		this.idPelicula = pelicula.id.toString
	}

	new(Pelicula pelicula, Funcion funcion, Usuario usuario) {
		this.fechaHora = LocalDateTime.now
		this.pelicula = pelicula
		this.funcion = funcion
		this.usuario = usuario
		this.precio = pelicula.precioEntrada + funcion.precio
		this.tituloPelicula = pelicula.titulo
		this.idPelicula = pelicula.id.toString
	}

	@JsonIgnore
	def getFechaHoraFormatted() {
		val formatterDateTime = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")
		formatterDateTime.format(fechaHora)
	}

	static def searchPeliculaById(String id) {
		val objId = new ObjectId(id)
		val pelicula = RepoPeliculas.instance.searchByObjectId(objId)
		pelicula
	}

}
