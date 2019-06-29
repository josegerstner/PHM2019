package ar.edu.unsam.arena.model

import ar.edu.unsam.domain.usuario.Usuario
import ar.edu.unsam.repos.usuario.RepoUsuarios
import java.util.List
import org.apache.commons.lang.StringUtils
import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.commons.model.annotations.Observable
import org.uqbar.commons.model.utils.ObservableUtils

@Observable
@Accessors
class BuscarAmigosModel {

	Usuario usuario
	Usuario seleccionado
	String busquedaIngresada
	String busquedaActual

	new(Usuario usuario) {
		this.usuario = usuario
	}

	def buscar() {
		busquedaActual = busquedaIngresada
		ObservableUtils.firePropertyChanged(this, "listaDeBusqueda")
		ObservableUtils.firePropertyChanged(this, "amigosRecomendados")
	}

	def getListaDeBusqueda() {
		if (StringUtils.isBlank(busquedaActual)) {
			this.listaDePersonas
		} else {
			this.listaDePersonas.filter[tieneValorBuscado(busquedaActual)].toList
		}
	}
	
	private def List<Usuario> getListaDePersonas() {
		repoUsuario.searchingAmigos(usuario)
	}

	def getAmigosRecomendados() {
		repoUsuario.amigosRecomendados(usuario)
	}
	
	def getNoSonAmigos(List<Usuario> usuarios) {
		usuarios.filter(noEsAmigoNiSoyYo).toList
	}
	
	private def (Usuario)=>boolean noEsAmigoNiSoyYo() {
		[!(usuario.esAmigo(it) || it.id == usuario.id)]
	}
	
	def repoUsuario() {
		RepoUsuarios.instance
	}
	
	def agregarAmigo() {
		val amigo = repoUsuario.searchById(this.seleccionado.id)
		this.usuario.amigos.add(amigo)
		ObservableUtils.firePropertyChanged(this, "listaDeBusqueda")
		ObservableUtils.firePropertyChanged(this, "amigosRecomendados")
	}

}
