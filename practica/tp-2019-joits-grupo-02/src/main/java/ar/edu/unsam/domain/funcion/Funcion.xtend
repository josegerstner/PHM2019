package ar.edu.unsam.domain.funcion

import ar.edu.unsam.domain.pelicula.Pelicula
import java.time.LocalDateTime
import java.time.format.DateTimeFormatter
import org.bson.types.ObjectId
import org.eclipse.xtend.lib.annotations.Accessors
import org.mongodb.morphia.annotations.Entity
import org.mongodb.morphia.annotations.Id
import org.neo4j.ogm.annotation.GeneratedValue
import org.neo4j.ogm.annotation.NodeEntity
import org.neo4j.ogm.annotation.Property
import org.uqbar.commons.model.annotations.Observable
import org.neo4j.ogm.annotation.Transient

@NodeEntity(label="Funcion")
@Entity
@Accessors
@Observable
class Funcion {
	
	@Id
	@Transient	
	ObjectId id
	
	@org.neo4j.ogm.annotation.Id @GeneratedValue
	Long id_neo
	
	@Property
	LocalDateTime fechaHora
	
	@Property(name="sala")
	String nombreSala
	
	new() {
		super()
	}

	new(Pelicula rodaje, LocalDateTime fechaHora, String nombreSala) {
		this.fechaHora = fechaHora
		this.nombreSala = nombreSala
	}
	
	new(LocalDateTime fechaHora, String nombreSala) {
		this.fechaHora = fechaHora
		this.nombreSala = nombreSala
	}
	
	def getFecha() {
		val formatterDate = DateTimeFormatter.ofPattern("dd/MM/yyyy")
		formatterDate.format(fechaHora)
	}
	
	def getHora() {
		val formatterTime = DateTimeFormatter.ofPattern("HH:mm")
		formatterTime.format(fechaHora)
	}
	
	def getFechaHora() {
		val formatterDateTime = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")
		formatterDateTime.format(fechaHora)
	}
	
	def getDia() {
		this.fechaHora.dayOfWeek.value
	}
	
	def double getPrecioPorDiaDeFuncion() {
		if(dia > 5) 120.00 else this.getPrecioSiNoEsFinde()
	}
	
	def double getPrecioSiNoEsFinde() {
		if(dia == 3) 50.00 else 80.00
	}
	
	def getPrecio() {
//		rodaje.precioEntrada + 
		this.precioPorDiaDeFuncion
	}
	
}
