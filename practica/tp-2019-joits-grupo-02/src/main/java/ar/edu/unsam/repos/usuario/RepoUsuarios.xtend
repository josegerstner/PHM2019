package ar.edu.unsam.repos.usuario

import ar.edu.unsam.domain.entrada.Entrada
import ar.edu.unsam.domain.usuario.Usuario
import ar.edu.unsam.repos.RepoDefault
import java.util.List

class RepoUsuarios implements RepoDefault<Usuario> {

	static RepoUsuarios instance
	RepoUsuariosHibernate repoUsuariosHibernate
	RepoUsuariosNeo4J repoUsuariosNeo4J

	private new() {
		this.repoUsuariosNeo4J = new RepoUsuariosNeo4J
		this.repoUsuariosHibernate = new RepoUsuariosHibernate
	}

	def static getInstance() {
		if (instance === null) {
			instance = new RepoUsuarios
		} else {
			instance
		}
	}
	
	override List<Usuario> allInstances() {
		this.repoUsuariosHibernate.allInstances
	}

	override searchByExample(Usuario usuario) {
		this.repoUsuariosHibernate.searchByExample(usuario)
	}
	
	override create(Usuario usuario) {
		this.repoUsuariosNeo4J.create(usuario)
		this.repoUsuariosHibernate.create(usuario)
	}

	override update(Usuario usuario) {
		this.repoUsuariosNeo4J.update(usuario)
		this.repoUsuariosHibernate.update(usuario)
	}
	

	override searchById(long _id) {
		val usuario = this.repoUsuariosHibernate.searchById(_id)
		val entradas = usuario.entradas
		entradas.forEach[entrada | 
			entrada.pelicula = Entrada.searchPeliculaById(entrada.idPelicula)
			entrada.usuario = usuario
		]
		usuario.entradas = entradas
		usuario
	}

	def searchByString(String nombreUsuario) {
		this.repoUsuariosHibernate.searchByString(nombreUsuario)
	}

	def amigosRecomendados(Usuario usuario) {
		this.repoUsuariosNeo4J.getAmigosRecomendados(usuario.nombreUsuario)
	}

	def searchingAmigos(Usuario usuario) {
		this.repoUsuariosHibernate.searchingAmigos(usuario)
	}
	

}
