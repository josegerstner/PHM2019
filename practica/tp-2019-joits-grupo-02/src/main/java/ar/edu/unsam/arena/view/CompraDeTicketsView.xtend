package ar.edu.unsam.arena.view

import ar.edu.unsam.arena.model.CompraDeTicketsModel
import ar.edu.unsam.arena.model.FinalizarCompraModel
import ar.edu.unsam.arena.runnable.JoitsApplication
import ar.edu.unsam.domain.funcion.Funcion
import ar.edu.unsam.domain.pelicula.Pelicula
import java.awt.Color
import org.uqbar.arena.layout.HorizontalLayout
import org.uqbar.arena.layout.VerticalLayout
import org.uqbar.arena.widgets.Button
import org.uqbar.arena.widgets.Label
import org.uqbar.arena.widgets.Panel
import org.uqbar.arena.widgets.TextBox
import org.uqbar.arena.widgets.tables.Column
import org.uqbar.arena.widgets.tables.Table
import org.uqbar.arena.windows.Window
import org.uqbar.arena.windows.WindowOwner
import org.uqbar.commons.model.exceptions.UserException

import static extension org.uqbar.arena.xtend.ArenaXtendExtensions.*

class CompraDeTicketsView extends Window<CompraDeTicketsModel> {

	new(WindowOwner owner, CompraDeTicketsModel model) {
		super(owner, model)
		this.title = "Joits - Compra de Tickets"
	}

	override createContents(Panel mainPanel) {
		mainPanel => [
			layout = new VerticalLayout
			new Panel(it) => [
				layout = new HorizontalLayout
				new Label(it) => [
					text = "Usuario Logueado: "
					alignLeft
				]
				new Label(it) => [
					value <=> "usuario.nombreUsuario"
					width = 280
					alignLeft
				]
				new Label(it) => [
					text = "Fecha "
					alignRight
					width = 300
				]
				new Label(it) => [
					value <=> "fechaActual"
				]
			]
			new Panel(it) => [
				layout = new HorizontalLayout
				agregarPanelPeliculas()
				agregarPanelFunciones()
			]
			new Panel(it) => [
				layout = new HorizontalLayout
				new Button(it) => [
					caption = "Finalizar compra"
					onClick [this.finalizarCompra]
//					enabled <=> "validarCarrito"
				]
				new Label(it) => [
					width = 540
				]
				new Button(it) => [
					caption = "Panel de Control"
					onClick [this.panelDeControl]
				]
			]
			new Label(it) => [
				foreground = Color.RED
				value <=> "mensajeError"
			]

		]
	}

	def void agregarPanelPeliculas(Panel panel) {
		new Panel(panel) => [
			layout = new VerticalLayout
			agregarBuscador()
			agregarListaPeliculas("peliculas")
			new Label(it) => [
				text = "Pelis recomendadas"
				width = 100
				alignLeft
			]
			agregarListaPeliculas("recomendadas")
		]
	}

	def void agregarPanelFunciones(Panel panel) {
		new Panel(panel) => [
			layout = new VerticalLayout
			new Label(it) => [
				text = "Funciones"
				width = 100
				alignLeft
			]
			agregarListaFunciones()
			new Panel(it) => [
				layout = new HorizontalLayout
				new Label(it) => [
					text = "Importe de la entrada seleccionada: $"
				]
				new Label(it) => [
					value <=> "funcionSeleccionada.precio"
				]
			]

			new Button(it) => [
				caption = "Agregar al carrito"
				onClick [this.modelObject.agregarAlCarrito]
				enabled <=> "validarFuncion"
			]
			new Panel(it) => [
				layout = new HorizontalLayout
				new Label(it) => [
					text = "Items en carrito: "
				]
				new Label(it) => [
					value <=> "cantidadItems"
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

	def agregarListaPeliculas(Panel panel, String lista) {
		new Panel(panel) => [
			layout = new VerticalLayout
			new Table<Pelicula>(it, typeof(Pelicula)) => [
				items <=> lista
				value <=> "peliculaSeleccionado"
				numberVisibleRows = 6

				new Column<Pelicula>(it) => [
					title = "Nombre"
					bindContentsToProperty("titulo")
					fixedSize = 190
				]
				new Column<Pelicula>(it) => [
					title = "Fecha"
					bindContentsToProperty("anio")
					fixedSize = 50
				]
				new Column<Pelicula>(it) => [
					title = "Rating"
					bindContentsToProperty("puntaje")
					fixedSize = 50
				]
				new Column<Pelicula>(it) => [
					title = "Género"
					bindContentsToProperty("genero")
					fixedSize = 150
				]
			]

		]
	}

	def agregarListaFunciones(Panel panel) {
		new Panel(panel) => [
			layout = new VerticalLayout
			new Table<Funcion>(it, typeof(Funcion)) => [
				items <=> "peliculaSeleccionado.funciones"
				value <=> "funcionSeleccionada"
				numberVisibleRows = 9
				new Column<Funcion>(it) => [
					title = "Fecha"
					bindContentsToProperty("fecha")
					fixedSize = 100
				]
				new Column<Funcion>(it) => [
					title = "Hora"
					bindContentsToProperty("hora")
					fixedSize = 50
				]

				new Column<Funcion>(it) => [
					title = "Sala"
					bindContentsToProperty("nombreSala")
					fixedSize = 100
				]
			]

		]
	}

	def finalizarCompra() {
		try {
			this.modelObject.validarCarrito
			new FinalizarCompraView(this, new FinalizarCompraModel(this.modelObject.usuario)).open
		} catch (UserException exception) {
			this.modelObject.mensajeError = exception.message;
		}
	}

	def panelDeControl() {
		(owner as JoitsApplication).panelDeControl(this)
	}
	
	def actualizarListas() {
		this.modelObject.actualizarListas
	}
	
}
