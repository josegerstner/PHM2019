package ar.edu.unsam.arena.view

import ar.edu.unsam.arena.model.BuscarAmigosModel
import org.uqbar.arena.layout.HorizontalLayout
import org.uqbar.arena.layout.VerticalLayout
import org.uqbar.arena.widgets.Button
import org.uqbar.arena.widgets.Label
import org.uqbar.arena.widgets.Panel
import org.uqbar.arena.widgets.TextBox
import org.uqbar.arena.windows.Window
import org.uqbar.arena.windows.WindowOwner

import static extension org.uqbar.arena.xtend.ArenaXtendExtensions.*

class BuscarAmigosView extends Window<BuscarAmigosModel> {

	new(WindowOwner owner, BuscarAmigosModel model) {
		super(owner, model)
		this.title = "Buscar Amigos!"
	}

	override createContents(Panel mainPanel) {

		mainPanel => [
			layout = new VerticalLayout
			new Label(it) => [
				text = "Buscar Persona"
				alignLeft
			]
			agregarBuscador()
			new TablaUsuarioView("listaDeBusqueda").crearTabla(it)
			new Label(it) => [
				text = "Amigos sugeridos"
				width = 100
				alignLeft
			]
			new TablaUsuarioView("amigosRecomendados").crearTabla(it)

			new Panel(it) => [
				layout = new HorizontalLayout

				new Label(it) => [
					width = 200
				]
				new Button(it) => [
					caption = "Agregar Amigo"
					onClick[agregarAmigo()]
				]
				new Button(it) => [
					caption = "Volver"
					onClick[this.close]
				]
			]
		]
	}

	def void agregarBuscador(Panel panel) {
		new Panel(panel) => [
			layout = new HorizontalLayout
			new TextBox(it) => [
				value <=> "busquedaIngresada"
				width = 250
			]
			new Button(it) => [
				caption = "Buscar"
				onClick[this.modelObject.buscar]
				setAsDefault
			]
		]
	}
	
	private def void agregarAmigo() {
		this.modelObject.agregarAmigo
		this.actualizarOwner
	}
	
	private def void actualizarOwner(){
		(this.owner as PanelDeControlView).actualizarAmigos
	}

}
