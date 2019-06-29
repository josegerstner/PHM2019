package ar.edu.unsam.arena.view

import ar.edu.unsam.arena.model.LoginModel
import ar.edu.unsam.arena.runnable.JoitsApplication
import org.uqbar.arena.layout.HorizontalLayout
import org.uqbar.arena.layout.VerticalLayout
import org.uqbar.arena.widgets.Button
import org.uqbar.arena.widgets.Label
import org.uqbar.arena.widgets.Panel
import org.uqbar.arena.widgets.PasswordField
import org.uqbar.arena.widgets.TextBox
import org.uqbar.arena.windows.Window
import org.uqbar.arena.windows.WindowOwner

import static extension org.uqbar.arena.xtend.ArenaXtendExtensions.*
import org.uqbar.commons.model.exceptions.UserException

class LoginView extends Window<LoginModel> {

	new(WindowOwner owner, LoginModel model) {
		super(owner, model)
		this.title = "Joits - Loguin"
	}

	override createContents(Panel mainPanel) {
		mainPanel => [
			layout = new VerticalLayout
			new Label(mainPanel) => [
				value <=> "mensaje"
			]
			agregarValorEditable("Usuario", "nombreUsuario")
			agregarValorEditablePassword("Password", "password")
			agregarAcciones
		]
	}

	def void agregarAcciones(Panel panel) {
		new Panel(panel) => [
			layout = new HorizontalLayout
			new Label(it) => [
				width = 70
			]
			new Button(it) => [
				caption = "Aceptar"
				onClick [this.aceptar]
				enabled <=> "validar"
				setAsDefault
			]
			new Button(it) => [
				caption = "Cancelar"
				onClick [this.close]
				height = 26 // workaround no se muestra sin esto por culpa del enabled del aceptar
			]
		]

	}

	def void agregarValorEditable(Panel panel, String descripcion, String valor) {
		new Panel(panel) => [
			layout = new HorizontalLayout
			new Label(it) => [
				text = descripcion
				width = 70
				alignLeft
			]
			new TextBox(it) => [
				value <=> valor
				width = 100
				alignLeft
			]
		]
	}

	def void agregarValorEditablePassword(Panel panel, String descripcion, String valor) {
		new Panel(panel) => [
			layout = new HorizontalLayout
			new Label(it) => [
				text = descripcion
				width = 70
				alignLeft
			]
			new PasswordField(it) => [
				value <=> valor
				width = 100
			]
		]
	}

	def aceptar() {
		try {
			val usuario = this.modelObject.obtenerUsuario()
			(owner as JoitsApplication).logear(this, usuario)
		} catch (UserException exception) {
			this.modelObject.mensaje = exception.message;
		}
	}
}
