package ar.edu.unsam.arena.view

import ar.edu.unsam.arena.model.FinalizarCompraModel
import ar.edu.unsam.domain.entrada.Entrada
import java.awt.Color
import org.uqbar.arena.bindings.NotNullObservable
import org.uqbar.arena.layout.HorizontalLayout
import org.uqbar.arena.layout.VerticalLayout
import org.uqbar.arena.widgets.Button
import org.uqbar.arena.widgets.Label
import org.uqbar.arena.widgets.Panel
import org.uqbar.arena.widgets.tables.Column
import org.uqbar.arena.widgets.tables.Table
import org.uqbar.arena.windows.Window
import org.uqbar.arena.windows.WindowOwner
import org.uqbar.commons.model.exceptions.UserException

import static extension org.uqbar.arena.xtend.ArenaXtendExtensions.*
import org.uqbar.commons.model.utils.ObservableUtils

class FinalizarCompraView extends Window<FinalizarCompraModel> {

	new(WindowOwner owner, FinalizarCompraModel model) {
		super(owner, model)
		this.title = "Joits - Finalizar Compra"
	}

	override createContents(Panel mainPanel) {
		mainPanel => [
			layout = new VerticalLayout
			new Label(it) => [
				text = "Pelis en el carrito"
				alignLeft
			]
			agregarListaCarrito

			new Panel(it) => [
				layout = new HorizontalLayout
				new Button(it) => [
					caption = "Eliminar Item"
					onClick [
						sacarDelCarrito
						actualizarPantallaDeCompra
					]
					bindEnabled(new NotNullObservable("seleccionado"))
				]
				new Label(it) => [
					width = 390
				]
				new Label(it) => [
					text = "Total: $"
				]
				new Label(it) => [
					value <=> "totalPrecioCarrito"
				]

			]

			new Panel(it) => [
				layout = new HorizontalLayout
				new Button(it) => [
					caption = "Limpiar carrito"
					onClick [
						limpiarCarrito
						actualizarPantallaDeCompra
					]
				]
				new Label(it) => [
					width = 320
				]
				new Button(it) => [
					caption = "Comprar"
					onClick [
						comprar
						actualizarPantallaDeCompra
					]
					enabled <=> "validarComprar"
				]
				new Button(it) => [
					caption = "Volver atrás"
					onClick [this.close]
				]
			]

			new Label(it) => [
				foreground = Color.RED
				value <=> "mensajeError"
			]

		]
	}

	private def void sacarDelCarrito() {
		this.modelObject.sacarDelCarrito()
	}

	private def void limpiarCarrito() {
		this.modelObject.limpiarCarrito()
	}

	private def void comprar() {
		try {
			this.modelObject.comprar()
			this.close
		} catch (UserException exception) {
			this.modelObject.mensajeError = exception.message;
		}
	}

	def agregarListaCarrito(Panel panel) {
		new Panel(panel) => [
			layout = new VerticalLayout
			new Table<Entrada>(it, typeof(Entrada)) => [
				items <=> "carrito"
				value <=> "seleccionado"
				numberVisibleRows = 6

				new Column<Entrada>(it) => [
					title = "Nombre"
					bindContentsToProperty("tituloPelicula")
					fixedSize = 200
				]
				new Column<Entrada>(it) => [
					title = "Fecha y Hora"
					bindContentsToProperty("fechaHoraFormatted")
					fixedSize = 120
				]
				new Column<Entrada>(it) => [
					title = "Precio"
					bindContentsToProperty("precio")
					fixedSize = 60
				]
			]

		]
	}

	private def actualizarPantallaDeCompra() {
		ObservableUtils.firePropertyChanged((owner as CompraDeTicketsView).modelObject, "cantidadItems")
	}

}
