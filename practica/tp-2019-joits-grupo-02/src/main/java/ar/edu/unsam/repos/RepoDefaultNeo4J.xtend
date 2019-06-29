package ar.edu.unsam.repos

import org.eclipse.xtend.lib.annotations.Accessors
import org.neo4j.ogm.config.Configuration
import org.neo4j.ogm.session.SessionFactory

@Accessors
abstract class RepoDefaultNeo4J<T> {
	/**
	 * Al buscar muchos elementos, buscaremos por defecto traer solo la información de ese nodo, por eso 0.
	 * Al buscar un nodo concreto, la profundidad será 1 para traer el nodo y sus relaciones
	 */
	public static int PROFUNDIDAD_BUSQUEDA_LISTA = 0
	public static int PROFUNDIDAD_BUSQUEDA_CONCRETA = 1

	/**
	 * http://neo4j.com/docs/ogm-manual/current/reference/
	 * 
	 */
	static Configuration configuration = new Configuration.Builder().uri("bolt://localhost:11005").credentials("neo4j",
		"joits").build()

	public static SessionFactory sessionFactory = new SessionFactory(configuration,
		"ar.edu.unsam.domain")

	protected def getSession() {
		sessionFactory.openSession
	}

	def create(T t) {
		session.save(t)
	}
	
	def update(T t) {
		session.save(t,PROFUNDIDAD_BUSQUEDA_CONCRETA)
	}
	
	abstract def void delete()

}
