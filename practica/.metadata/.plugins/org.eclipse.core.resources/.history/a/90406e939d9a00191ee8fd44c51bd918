package ar.edu.unsam.arena.model

import ar.edu.unsam.domain.entrada.Entrada
import ar.edu.unsam.domain.funcion.Funcion
import ar.edu.unsam.domain.pelicula.Pelicula
import ar.edu.unsam.domain.usuario.Usuario
import ar.edu.unsam.repos.CarritoRedis
import ar.edu.unsam.repos.pelicula.RepoPeliculas
import ar.edu.unsam.repos.pelicula.RepoPeliculasMongoDB
import ar.edu.unsam.repos.usuario.RepoUsuarios
import java.time.LocalDate
import java.time.format.DateTimeFormatter
import java.util.List
import org.apache.commons.lang.StringUtils
import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.commons.model.annotations.Dependencies
import org.uqbar.commons.model.annotations.Observable
import org.uqbar.commons.model.exceptions.UserException
import org.uqbar.commons.model.utils.ObservableUtils

@Accessors
@Observable
class CompraDeTicketsModel {
	val formatterDate = DateTimeFormatter.ofPattern("dd/MM/yyyy")
	
	Usuario usuario
	String busquedaIngresada
	String busquedaActual
	Pelicula peliculaSeleccionado
	Funcion funcionSeleccionada
	CarritoRedis carritoRedis = CarritoRedis.instance
	Funcion funcionCarritoSeleccionada
	Entrada entradaCarritoSeleccionada
	String mensajeError = ""

	new(Usuario usuario) {
		this.usuario = RepoUsuarios.instance.searchById(usuario.id)
	}

	def buscar() {
		busquedaActual = busquedaIngresada
		ObservableUtils.firePropertyChanged(this, "peliculas")
	}

	def List<Pelicula> getPeliculas() {
		if (StringUtils.isBlank(busquedaActual)) {
			repoPeliculas.allInstances
		} else {
			repoPeliculas.allInstances.filter[tieneValorBuscado(busquedaActual)].toList
		}
	}

	def getRecomendadas() {
		return RepoPeliculas.instance.getPeliculasRecomendadas(usuario.nombreUsuario)
	}

	def agregarAlCarrito() {
		carritoRedis.agregar(usuario, newEntrada)
		this.mensajeError = ""
		ObservableUtils.firePropertyChanged(this, "cantidadItems")
	}

	@Dependencies("peliculaSeleccionado", "funcionSeleccionada")
	def getValidarFuncion() {
		peliculaSeleccionado !== null && funcionSeleccionada !== null
	}

	def getCantidadItems() {
		this.carritoRedis.cantidadItems(usuario)
	}

	def getFechaActual() {
		formatterDate.format(LocalDate.now)
	}

	@Dependencies("peliculaSeleccionado", "funcionSeleccionada")
	def getPrecioEntrada() {
		if (validarFuncion) newEntrada.precio else 0
	}

	def newEntrada() {
		new Entrada(peliculaSeleccionado, funcionSeleccionada)
	}

	def getPeliculaSeleccionado() {
		if(this.peliculaSeleccionado !== null){
			repoPeliculas.searchByObjectId(this.peliculaSeleccionado.id)
		}
	}

	def repoPeliculas() {
		RepoPeliculas.instance
	}
	
	def getValidarCarrito() {
		if(cantidadItems < 1)
			throw new UserException("Debe agregar entradas al carrito para avanzar")
	}
	
	def actualizarListas() {
		ObservableUtils.firePropertyChanged(this, "recomendadas")
	}
	
}
