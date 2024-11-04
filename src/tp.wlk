// Parte 1 --------------------------------------------------------------------------------------

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


// Parte 2 --------------------------------------------------------------------------------------


class Heroe {
    const fuerza
    var pm
    var espada

    method pm() = pm
    method espada() = espada

    method atacar(enemigo) {
        const ataque = new AtaqueFisico(potencia = self.potenciaDeAtaqueFisico())
        enemigo.recibirAtaque(ataque)
    }

    method lanzarHechizo(hechizo, enemigo) {
        if (self.puedeLanzarHechizo(hechizo)) {    
            const ataque = new AtaqueMagico(potencia = self.potenciaDeAtaqueMagico(hechizo), elemento = hechizo.elemento())
            enemigo.recibirAtaque(ataque)
            pm = 0.max(pm - hechizo.poderBase())
        }
    }

    method potenciaDeAtaqueFisico() = fuerza + espada.poderFisico()
    method potenciaDeAtaqueMagico(hechizo) = hechizo.poderBase() * espada.poderMagico()

    method puedeLanzarHechizo(hechizo) = pm >= hechizo.poderBase()

    method descansar() {
        pm = 30.max(pm)
    }

    method equiparLlaveEspada(nuevaEspada) {
        espada = nuevaEspada
    }

    method leEsUtilCambiarDeEspada(nuevaEspada) = self.variacionDePoderFisicoDeEspadaRespectoAOtra(nuevaEspada) > 0

    method variacionDePoderFisicoDeEspadaRespectoAOtra(otraEspada) = otraEspada.poderFisico() - espada.poderFisico()
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



// Parte 3 --------------------------------------------------------------------------------------


class Equipo {
    const miembros = []

    method necesitanFrenar() = miembros.any{ miembro => miembro.pm() == 0 }

    method emboscar(enemigo) {
        miembros.forEach{
            miembro =>
            miembro.atacar(enemigo)
        }
    }

    method aQuienesLesEsUtilCambiarDeEspada(nuevaEspada) = miembros.filter{ miembro => miembro.leEsUtilCambiarDeEspada(nuevaEspada) }

    method legarLlaveEspada(nuevaEspada) {
        const masBeneficiado = miembros.max{miembro => miembro.variacionDePoderFisicoDeEspadaRespectoAOtra(nuevaEspada)}
        if (masBeneficiado.leEsUtilCambiarDeEspada(nuevaEspada)) {
            masBeneficiado.equiparLlaveEspada(nuevaEspada)
        }
    }
}




// Parte 4 --------------------------------------------------------------------------------------


object ventus inherits Heroe(fuerza = 8, pm = 7, espada = brisaDescarada) {
    override method potenciaDeAtaqueFisico() = fuerza + espada.poderMagico()
    override method potenciaDeAtaqueMagico(hechizo) = hechizo.poderBase() * espada.poderFisico()
}
