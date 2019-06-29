package ar.edu.unsam.repos

import java.util.List

interface RepoDefault<T> {
		
	abstract def List<T> allInstances()

	abstract def List<T> searchByExample(T t)
	
	abstract def void create(T t)

	abstract def void update(T t)

	abstract def T searchById(long _id)
	
}
