package ar.edu.unsam.domain.usuario

import ar.edu.unsam.domain.entrada.Entrada
import java.util.Set
import javax.persistence.CascadeType
import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.FetchType
import javax.persistence.GeneratedValue
import javax.persistence.Id
import javax.persistence.ManyToMany
import javax.persistence.OneToMany
import org.apache.commons.lang.StringUtils
import org.eclipse.xtend.lib.annotations.Accessors
import org.neo4j.ogm.annotation.NodeEntity
import org.neo4j.ogm.annotation.Property
import org.neo4j.ogm.annotation.Relationship
import org.neo4j.ogm.annotation.Transient
import org.uqbar.commons.model.annotations.Observable
import org.uqbar.commons.model.exceptions.UserException

@NodeEntity(label="Usuario")
@Entity
@Observable
@Accessors
class Usuario {

	@Id
	@org.neo4j.ogm.annotation.Id  @org.neo4j.ogm.annotation.GeneratedValue
	Long id
	
	@Property(name="name")
	@Column(length=100)
	String nombreUsuario
	
	@Column(length=100)
	String nombre
	
	@Column(length=100)
	String apellido
	
	@Column
	@Transient
	int edad
	
	@Relationship(type = "FRIENDS_WITH", direction = "OUTGOING")
	@ManyToMany (fetch=FetchType.LAZY)
	Set<Usuario> amigos = newHashSet
	
	@Column
	@Transient
	double saldo
	
	@Relationship(type = "MOVIES_SEEING", direction = "OUTGOING")
	@OneToMany(fetch=FetchType.LAZY, cascade=CascadeType.ALL)
	Set<Entrada> entradas = newHashSet
	
	@Column(length=100)
	@Transient
	String password

	new() {
	}

	new(String nombreUsuario, String nombre, String apellido, int edad, String password) {
		this.nombreUsuario = nombreUsuario
		this.nombre = nombre
		this.apellido = apellido
		this.edad = edad
		this.password = password
	}

	def validarPassword(String password) {
		if (this.password != StringUtils.defaultString(password)) {
			throw new UserException("La password es incorrecta")
		}
	}

	def esAmigo(Usuario amigo) {
		amigos.exists[ usuario | usuario.id == amigo.id ]
	}

	def comprarEntrada(Entrada entrada) {
		this.reducirSaldo(entrada.precio)
		entrada.usuario = this
		entrada.pelicula = Entrada.searchPeliculaById(entrada.idPelicula)
		println(entrada.idPelicula)
		println(entrada.pelicula)
		entradas.add(entrada)
	}

	def tieneValorBuscado(String valorBusqueda) {
		return StringUtils.containsIgnoreCase(nombre, valorBusqueda) ||
			StringUtils.containsIgnoreCase(apellido, valorBusqueda)
	}
	
	def reducirSaldo(Double valor) {
		this.saldo -= valor
	}
	
}
