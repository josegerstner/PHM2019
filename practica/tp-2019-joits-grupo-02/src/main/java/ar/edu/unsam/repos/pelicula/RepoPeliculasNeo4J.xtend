package ar.edu.unsam.repos.pelicula

import ar.edu.unsam.domain.pelicula.Pelicula
import ar.edu.unsam.repos.RepoDefaultNeo4J
import java.util.HashMap
import java.util.List
import java.util.Map
import org.neo4j.ogm.cypher.ComparisonOperator
import org.neo4j.ogm.cypher.Filter

class RepoPeliculasNeo4J extends RepoDefaultNeo4J<Pelicula> {

	def Pelicula searchPeliculaByTitle(String title) {
		session.loadAll(Pelicula, new Filter("titulo", ComparisonOperator.EQUALS,title), PROFUNDIDAD_BUSQUEDA_LISTA).get(0)
	}

	def List<Pelicula> getPeliculasRecomendadas(String nombreUsuario) {
		val query = String.format("MATCH (peliUsuario:Pelicula)<-[:MOVIES_SEEING]-(usuario:Usuario)-[FRIENDS_WITH]->(amigo:Usuario)-[:MOVIES_SEEING]->(peliAmigo:Pelicula)
					WHERE  usuario.name = '%s' 
					AND NOT (amigo)-[:MOVIES_SEEING]->()<-[:MOVIES_SEEING]-(usuario)
					RETURN peliAmigo LIMIT 5",nombreUsuario)
		val Map<String, String > params = new HashMap(1);
        params.put ("name", nombreUsuario);
		return session.query(Pelicula, query, params).toList
	}
	
	override delete() {
		session.deleteAll(Pelicula)
	}

}
