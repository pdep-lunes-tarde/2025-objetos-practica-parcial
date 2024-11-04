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



class Heroe {
    const fuerza
    var pm
    var property espada

    method pm() = pm

    method atacar(enemigo) {
        const ataque = new AtaqueFisico(potencia = fuerza + espada.poderFisico())
        enemigo.recibirAtaque(ataque)
    }

    method lanzarHechizo(hechizo, enemigo) {
        if (self.puedeLanzarHechizo(hechizo)) {    
            const potenciaAtaque = hechizo.poderBase() * espada.poderMagico()
            const ataque = new AtaqueMagico(potencia = potenciaAtaque, elemento = hechizo.elemento())
            enemigo.recibirAtaque(ataque)
            pm = 0.max(pm - hechizo.poderBase())
        }
    }

    method puedeLanzarHechizo(hechizo) = pm >= hechizo.poderBase()
}

class LlaveEspada {
    const poderFisico
    const poderMagico

    method poderFisico() = poderFisico
    method poderMagico() = poderMagico
}

class Hechizo {
    const elemento
    const poderBase

    method elemento() = elemento
    method poderBase() = poderBase
}

const llaveDelReino = new LlaveEspada(poderFisico = 3, poderMagico = 5)
const exploradorEstelar = new LlaveEspada(poderFisico = 2, poderMagico = 10)
const caminoAlAlba = new LlaveEspada(poderFisico = 5, poderMagico = 3)
const brisaDescarada = new LlaveEspada(poderFisico = 5, poderMagico = 2)

const sora = new Heroe(fuerza = 10, pm = 8, espada = llaveDelReino)
const mickey = new Heroe(fuerza = 5, pm = 13, espada = exploradorEstelar)
const riku = new Heroe(fuerza = 15, pm = 4, espada = caminoAlAlba)

const piro = new Hechizo(elemento = fuego, poderBase = 5)
const chispa = new Hechizo(elemento = luz, poderBase = 1)
const ragnarok = new Hechizo(elemento = luz, poderBase = 30)