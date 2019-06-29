package ar.edu.unsam.repos.pelicula

import ar.edu.unsam.domain.pelicula.Pelicula
import ar.edu.unsam.repos.RepoDefault
import org.bson.types.ObjectId

class RepoPeliculas implements RepoDefault<Pelicula> {
	
	static RepoPeliculas instance
	RepoPeliculasMongoDB repoPeliculasMongoDB
	RepoPeliculasNeo4J repoPeliculasNeo4J

	private new() {
		this.repoPeliculasNeo4J = new RepoPeliculasNeo4J
		this.repoPeliculasMongoDB = new RepoPeliculasMongoDB
	}

	def static getInstance() {
		if (instance === null) {
			instance = new RepoPeliculas
		} else {
			instance
		}
	}
	
	override allInstances() {
		this.repoPeliculasMongoDB.allInstances
	}
	
	override searchByExample(Pelicula t) {
		this.repoPeliculasMongoDB.searchByExample(t)
	}
	
	override create(Pelicula t) {
		this.repoPeliculasNeo4J.create(t)
		val idNeo = this.repoPeliculasNeo4J.searchPeliculaByTitle(t.titulo).idNeo
		t.idNeo = idNeo 
		this.repoPeliculasMongoDB.createIfNotExists(t)
	}
	
	override update(Pelicula t) {
		this.repoPeliculasNeo4J.update(t)
		this.repoPeliculasMongoDB.update(t)
	}
	
	override searchById(long _id) {
		this.repoPeliculasMongoDB.searchById(_id)
	}
	
	def searchByObjectId(ObjectId _id) {
		this.repoPeliculasMongoDB.searchByObjectId(_id)
	}
	
	def getPeliculasRecomendadas(String nombreUsuario) {
		this.repoPeliculasNeo4J.getPeliculasRecomendadas(nombreUsuario)
	}
	
	def delete() {
		this.repoPeliculasMongoDB.deleteDocuments
		this.repoPeliculasNeo4J.delete
	}
	
}