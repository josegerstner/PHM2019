package ar.edu.unsam.arena.model

import ar.edu.unsam.domain.usuario.Usuario
import ar.edu.unsam.repos.usuario.RepoUsuarios
import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.commons.model.annotations.Dependencies
import org.uqbar.commons.model.annotations.Observable
import org.uqbar.commons.model.utils.ObservableUtils

@Observable
@Accessors
class PanelDeControlModel {

	Usuario usuario
	Usuario seleccionado

	int edadAnterior
	double saldoAnterior

	double saldoNuevo

	new(Usuario usuario) {
		this.usuario = RepoUsuarios.instance.searchById(usuario.id)
		this.edadAnterior = usuario.edad
		this.saldoAnterior = usuario.saldo
	}

	def cancelarCambios() {
		this.usuario.edad = this.edadAnterior
		this.usuario.saldo = this.saldoAnterior
	}

	def cargarSaldo() {
		this.usuario.saldo = this.usuario.saldo + saldoNuevo
	}

	@Dependencies("saldoNuevo")
	def getValidar() {
		!Double.isNaN(this.saldoNuevo) && this.saldoNuevo > 0
	}

	def aceptar() {
		RepoUsuarios.instance.update(this.usuario)
	}
	
	def actualizar() {
		ObservableUtils.firePropertyChanged(this, "usuario")
	}
	
	def getPeliculasVistas() {
		usuario.entradas.toMap[tituloPelicula].values
	}

}
