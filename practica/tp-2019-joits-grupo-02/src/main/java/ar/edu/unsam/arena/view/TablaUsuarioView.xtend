package ar.edu.unsam.arena.view

import ar.edu.unsam.domain.usuario.Usuario
import org.uqbar.arena.layout.VerticalLayout
import org.uqbar.arena.widgets.Panel
import org.uqbar.arena.widgets.tables.Column
import org.uqbar.arena.widgets.tables.Table

import static extension org.uqbar.arena.xtend.ArenaXtendExtensions.*

class TablaUsuarioView {

	String lista

	new(String lista) {
		this.lista = lista
	}

	def crearTabla(Panel mainPanel) {
		new Panel(mainPanel) => [
			layout = new VerticalLayout
			new Table<Usuario>(it, typeof(Usuario)) => [
				items <=> lista
				value <=> "seleccionado"
				numberVisibleRows = 6

				new Column<Usuario>(it) => [
					title = "Nombre"
					bindContentsToProperty("nombre")
					fixedSize = 200
				]

				new Column<Usuario>(it) => [
					title = "Apellido"
					bindContentsToProperty("apellido")
					fixedSize = 200
				]

			]
		]
	}

}
