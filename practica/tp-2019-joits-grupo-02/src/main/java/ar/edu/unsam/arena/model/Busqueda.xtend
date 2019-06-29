package ar.edu.unsam.arena.model

import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.commons.model.annotations.Observable
import org.uqbar.commons.model.exceptions.UserException

@Accessors
@Observable
class Busqueda {
	public static String AND = "AND"
	public static String OR = "OR"
	public static String NO_CONECTAR = "NADA"
	
	String valorABuscar = ""
	Integer anioABuscar = null
	String conectorBusqueda = NO_CONECTAR

	def hasAnd() {
		seleccionoConector && conectorBusqueda.equals(AND)
	}
	
	def hasOr() {
		conectorBusqueda !== null && conectorBusqueda.equals(OR)
	}

	def filtraPorValor() {
		valorABuscar !== null && !valorABuscar.trim.equals("")
	}
	
	def filtraPorAnio() {
		anioABuscar !== null && anioABuscar > 0
	}

	def seleccionoConector() {
		conectorBusqueda !== null && !conectorBusqueda.equals(NO_CONECTAR)
	}
		
	def static getConectoresBusqueda() {
		#[AND, OR, NO_CONECTAR]
	}
	
	def void validar() {
		if (filtraPorAnio && filtraPorValor && !seleccionoConector) {
			throw new UserException("Debe seleccionar un criterio para filtrar")
		}
		if (seleccionoUnCriterioSolo && seleccionoConector) {
			throw new UserException("No tiene sentido conectar un solo criterio con AND / OR")
		}
	}
	
	def seleccionoUnCriterioSolo() {
		(!filtraPorAnio && filtraPorValor) || (filtraPorAnio && !filtraPorValor)
	}
	
}
