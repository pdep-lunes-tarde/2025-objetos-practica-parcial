class AtaqueFisico {
    const potencia
    method danio(enemigo) = 1.max(enemigo.calcularDanioFisico(potencia))
}

class AtaqueMagico {
    const potencia
    const elemento

    method danio(enemigo) {
        if (enemigo.elemento() == elemento) return 0
        if (enemigo.elemento().debilidad() == elemento) return potencia * 2
        return potencia
    }
}


class Enemigo {
    var pv
    const elemento

    method pv() = pv
    method elemento() = elemento

    method recibirAtaque(ataque) {
        const danio = ataque.danio(self)
        pv = 0.max(pv - danio)
    }

    method calcularDanioFisico(potencia)
}

class Incorporeo inherits Enemigo {
    const defensa

    override method calcularDanioFisico(potencia) = potencia - defensa
}

class Sincorazon inherits Enemigo {
    override method calcularDanioFisico(potencia) = potencia * 0.9
}



object fuego {
    method debilidad() = hielo
}
object hielo {
    method debilidad() = fuego
}
object oscuridad {
    method debilidad() = luz
}
object luz {
    method debilidad() = oscuridad
}