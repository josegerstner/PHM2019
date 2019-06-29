package ar.edu.unsam.repos.usuario

import ar.edu.unsam.domain.usuario.Usuario
import ar.edu.unsam.repos.RepoDefaultNeo4J
import java.util.ArrayList
import java.util.HashMap
import java.util.List
import java.util.Map
import org.neo4j.ogm.cypher.ComparisonOperator
import org.neo4j.ogm.cypher.Filter

class RepoUsuariosNeo4J extends RepoDefaultNeo4J<Usuario>{

	def List<Usuario> getNoAmigos(String valor) {
		val filtroPorNombreActor = 
			new Filter("name", ComparisonOperator.MATCHES, "(?i).*" + valor + ".*")
		return new ArrayList(session.loadAll(typeof(Usuario), filtroPorNombreActor, PROFUNDIDAD_BUSQUEDA_LISTA))
	}

	def Usuario getUsuario(Long id) {
		session.load(typeof(Usuario), id, PROFUNDIDAD_BUSQUEDA_CONCRETA)
	}

	def List<Usuario> getAmigosRecomendados(String nombreUsuario) {
		val query = String.format("MATCH (otroUsuario:Usuario)-[:MOVIES_SEEING]->(pelicula:Pelicula)<-[:MOVIES_SEEING]-(usuario:Usuario)
					WHERE  usuario.name = '%s' 
					AND NOT (otroUsuario)<-[:FRIENDS_WITH]-(usuario)
					RETURN otroUsuario LIMIT 5",nombreUsuario)
		val Map<String, String > params = new HashMap(1);
        params.put ("name", nombreUsuario);
		return session.query(Usuario, query, params).toList
	}
	
	override delete() {
		session.deleteAll(Usuario)
	}

}
