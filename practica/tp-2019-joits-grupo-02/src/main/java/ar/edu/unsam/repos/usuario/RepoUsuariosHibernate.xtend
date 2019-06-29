package ar.edu.unsam.repos.usuario

import ar.edu.unsam.domain.usuario.Usuario
import java.util.List
import javax.persistence.EntityManagerFactory
import javax.persistence.Persistence
import javax.persistence.PersistenceException
import javax.persistence.criteria.CriteriaBuilder
import javax.persistence.criteria.CriteriaQuery
import javax.persistence.criteria.JoinType
import javax.persistence.criteria.Root

class RepoUsuariosHibernate {

	static final EntityManagerFactory entityManagerFactory = Persistence.createEntityManagerFactory("Joits")

	def List<Usuario> allInstances() {
		val entityManager = generateEntityManager
		try {
			val criteria = entityManager.criteriaBuilder
			val query = criteria.createQuery(entityType)
			val from = query.from(entityType)
			query.select(from)
			entityManager.createQuery(query).resultList
		} finally {
			entityManager?.close
		}
	}

	def searchById(long _id) {
		val entityManager = generateEntityManager
		try {
			val criteria = entityManager.criteriaBuilder
			val query = criteria.createQuery(entityType)
			val camposUsuario = query.from(entityType)
			camposUsuario.fetch("amigos", JoinType.LEFT)
			camposUsuario.fetch("entradas", JoinType.LEFT)
			query.select(camposUsuario)
			query.where(criteria.equal(camposUsuario.get("id"), _id))
			entityManager.createQuery(query).singleResult
		} finally {
			entityManager?.close
		}
	}
	
	def searchByExample(Usuario usuario) {
		val entityManager = generateEntityManager
		try {
			val criteria = entityManager.criteriaBuilder
			val query = criteria.createQuery(entityType)
			val from = query.from(entityType)
			from.fetch("amigos", JoinType.LEFT)
			from.fetch("entradas", JoinType.LEFT)
			query.select(from)
			generateWhere(criteria, query, from, usuario)
			entityManager.createQuery(query).resultList
		} finally {
			entityManager?.close
		}
	}

	def searchByString(String nombreUsuario) {
		val entityManager = generateEntityManager
        try {
            val criteria = entityManager.criteriaBuilder
            val query = criteria.createQuery(entityType)
            val camposUsuario = query.from(entityType)
            query.select(camposUsuario)
            query.where(criteria.equal(camposUsuario.get("nombreUsuario"), nombreUsuario))
            entityManager.createQuery(query).singleResult
        } finally {
            entityManager?.close
        }
	}

	def amigosRecomendados(Usuario usuario) {
		val entityManager = generateEntityManager
        try {
            val criteria = entityManager.criteriaBuilder
            val query = criteria.createQuery(entityType)
            val camposUsuario = query.from(entityType)
            query.select(camposUsuario)
            query.where(criteria. notEqual(camposUsuario.get("id"), usuario.id))
            query.orderBy(criteria.desc(camposUsuario.get("saldo")))
            val queryResult = entityManager.createQuery(query)
            queryResult.maxResults = 3 
            queryResult.resultList
        } finally {
            entityManager?.close
        }
	}

	def generateWhere(CriteriaBuilder criteria, CriteriaQuery<Usuario> query, Root<Usuario> camposUsuario,
		Usuario t) {
		if (t.nombreUsuario !== null) {
			query.where(criteria.equal(camposUsuario.get("nombreUsuario"), t.nombreUsuario))
		}

	}
	
	def searchingAmigos(Usuario usuario) {
		val entityManager = generateEntityManager
        try {
            val amigos = usuario.amigos
            var ids = amigos.map[id].toList
            ids.add(usuario.id)
            val criteria = entityManager.criteriaBuilder
            val query = criteria.createQuery(entityType)
            val camposUsuario = query.from(entityType)
            query.select(camposUsuario)
            query.where(camposUsuario.get("id").in(ids).not)
            val queryResult = entityManager.createQuery(query)
            queryResult.resultList
        } finally {
            entityManager?.close
        }
	}
	
	def create(Usuario usuario) {
		val entityManager = generateEntityManager
		try {
			entityManager => [
				transaction.begin
				persist(usuario)
				transaction.commit
			]
		} catch (PersistenceException e) {
			e.printStackTrace
			entityManager.transaction.rollback
			throw new RuntimeException("Ocurrió un error, la operación no puede completarse", e)
		} finally {
			entityManager?.close
		}
	}

	def update(Usuario usuario) {
		val entityManager = generateEntityManager
		try {
			entityManager => [
				transaction.begin
				merge(usuario)
				transaction.commit
			]
		} catch (PersistenceException e) {
			e.printStackTrace
			entityManager.transaction.rollback
			throw new RuntimeException("Ocurrió un error, la operación no puede completarse", e)
		} finally {
			entityManager?.close
		}
	}
	
	def generateEntityManager() {
		entityManagerFactory.createEntityManager
	}

	def getEntityType() {
		Usuario
	}
	
}
