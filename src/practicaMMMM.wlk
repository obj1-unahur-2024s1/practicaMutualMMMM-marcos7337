class Viaje {
	const property idiomas = #{}
	
	method esInteresante() = idiomas.size() >= 2
	method esRecomendadaPara(socio) {
		return( self.esInteresante() 
			and socio.leAtrae(self)
			and !socio.actividadesRealizadas().contains(self)
		)
	}
}

class ViajeDePlaya inherits Viaje {
	const property largoDeLaPlaya
	
	method sirveParaBroncearse() = true
	method requiereEsfuerzo() = largoDeLaPlaya > 1200
	method diasDelViaje() = largoDeLaPlaya / 500
}


class ExcursionACiudad inherits Viaje {
	const property cantidadDeAtracciones
	
	method sirveParaBroncearse() = false
	method requiereEsfuerzo() = cantidadDeAtracciones.between(5,8)
	method diasDelViaje() = cantidadDeAtracciones / 2
	override method esInteresante() = super() or cantidadDeAtracciones == 5
}

class ExcursionACiudadTropical inherits ExcursionACiudad {
	override method sirveParaBroncearse() = true
	override method diasDelViaje() = (cantidadDeAtracciones / 2) + 1
}

class SalidaDeTrekking inherits Viaje {
	const property kilometrosDeSendero
	const property diasDeSol
	
	method sirveParaBroncearse() = (diasDeSol > 200) or (diasDeSol.between(100,200) and kilometrosDeSendero > 120)
	method requiereEsfuerzo() = kilometrosDeSendero > 80
	method diasDelViaje() = kilometrosDeSendero / 50
	override method esInteresante() = super() and diasDeSol > 140
}

class ClaseDeGimnasia {
	
	method idiomas() = #{"español"}
	method sirveParaBroncearse() = false
	method requiereEsfuerzo() = true
	method diasDelViaje() = 1
	
	method esRecomendadaPara(socio) = socio.edad().between(20,30)
}

class TallerLiterario {
	const property libros = #{}
	
	method idioma() = libros.map({libro => libro.idioma()})
	method diasDelViaje() = libros.size() + 1
	method sirveParaBroncearse() = false
	method requiereEsfuerzo() {
		return libros.any({libro => libro.cantidadPaginas() > 500})
			or (libros.map({libro => libro.autor()}).asSet().size() == 1 and libros.size() > 1)
	}
	method esRecomendadaPara(socio) = socio.idiomas().size() > 1
//	libros.all({libro => libro.autor() == libros.anyOne().autor()})
}

class Libro {
	const property idioma
	const property cantidadPaginas
	const property autor
}


class Socio {
	const property actividadesRealizadas = #{}
	const property idiomas = #{}
	var property edad
	var property limiteDeActividades
	
	
	method realizarActividad(actividad) {
		if (actividadesRealizadas.size() < limiteDeActividades) {
			actividadesRealizadas.add(actividad)
		} else {
			self.error("Límite de actividades alcanzado")
			throw new Exception(message = "Límite de actividades alcanzado")
		}
	}
	
	method esAdoradorDelSol() = actividadesRealizadas.all({act => act.sirveParaBroncearse()})
	method actividadesEsforzadas() = actividadesRealizadas.filter({act => act.requiereEsfuerzo()})
}

class SocioTranquilo inherits Socio {
	method leAtrae(actividad) = actividad.diasDelViaje() >= 4
}

class SocioCoherente inherits Socio {
	method leAtrae(actividad) {
		return if(self.esAdoradorDelSol()) actividad.sirveParaBroncearse() else actividad.requiereEsfuerzo()
	}
}

class SocioRelajado inherits Socio {
	method leAtrae(actividad) = idiomas.any({i => actividad.idiomas().contains(i)})
}






