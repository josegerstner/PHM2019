package ar.edu.unsam.repos

import ar.edu.unsam.domain.entrada.Entrada
import ar.edu.unsam.domain.usuario.Usuario
import com.fasterxml.jackson.databind.DeserializationFeature
import com.fasterxml.jackson.databind.ObjectMapper
import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.commons.model.annotations.Observable
import redis.clients.jedis.Jedis

@Observable
@Accessors
class CarritoRedis {
	val objectMapper = new ObjectMapper().configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false)
	var Jedis jedis
	static CarritoRedis instance = null

	private new() {
		jedis = new Jedis(Constants.LOCALHOST)
	}

	static def getInstance() {
		if (instance === null) {
			instance = new CarritoRedis
		}
		instance
	}

	def carritoKey(Usuario usuario) {
		println("carrito!")
		Constants.CARRITO + Constants.SEPARADOR + usuario.nombreUsuario
	}

	def entradas(Usuario usuario) {
		jedis.lrange(carritoKey(usuario), 0, -1).map[objectMapper.readValue(it, Entrada)]
	}

	def agregar(Usuario usuario, Entrada entrada) {
		jedis.rpush(carritoKey(usuario), objectMapper.writeValueAsString(entrada))
	}

	def eliminar(Usuario usuario, Entrada entrada) {
		jedis.lrem(carritoKey(usuario), 1, objectMapper.writeValueAsString(entrada))
	}

	def limpiar(Usuario usuario) {
		jedis.del(carritoKey(usuario))
	}

	def cantidadItems(Usuario usuario) {
		jedis.llen(carritoKey(usuario))
	}
}
