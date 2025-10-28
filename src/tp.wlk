class AtaqueFisico {
    const potencia

    method danio(enemigo) = 1.max(enemigo.calcularDanioFisico(potencia))
}

class AtaqueMagico {
    const potencia
    const elemento

    method danio(enemigo) {
        if (enemigo.esDeElemento(elemento)) return 0
        if (enemigo.esDebilContra(elemento)) return potencia * 2
        return potencia
    }
}


class Enemigo {
    var pv
    const elemento

    method pv() = pv
    method elemento() = elemento

    method esDeElemento(unElemento) {
        return elemento == unElemento
    }

    method esDebilContra(unElemento) {
        return elemento.esDebilContra(unElemento)
    }

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


class Elemento {
    method esDebilContra(unElemento) = self.debilidad() == unElemento
    method debilidad()
}
object fuego inherits Elemento {
    override method debilidad() = hielo
}
object hielo inherits Elemento {
    override method debilidad() = fuego
}
object oscuridad inherits Elemento {
    override method debilidad() = luz
}
object luz inherits Elemento {
    override method debilidad() = oscuridad
}

class HechizoException inherits DomainException {}

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
        if (not self.puedeLanzarHechizo(hechizo)) {
            throw new HechizoException(message = "El héroe no tiene suficientes PM para lanzar este hechizo")
        }
        const ataque = new AtaqueMagico(potencia = self.potenciaDeAtaqueMagico(hechizo), elemento = hechizo.elemento())
        enemigo.recibirAtaque(ataque)
        pm = 0.max(pm - hechizo.poderBase())
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

class Equipo {
    const miembros = []

    method necesitanFrenar() = miembros.any{ miembro => miembro.pm() == 0 }

    method emboscar(enemigo) {
        miembros.forEach{ miembro => miembro.atacar(enemigo) }
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

object roxas inherits Heroe(fuerza = 5, pm = 20, espada = llaveDelReino) {
    var modo = tranquilo
    var fisicosConsecutivos = 0
    var magicosConsecutivos = 0

    method modo() = modo

    override method potenciaDeAtaqueFisico() = super() * (1 + modo.adicionalFisico())
    override method potenciaDeAtaqueMagico(hechizo) = super(hechizo) * (1 + modo.adicionalMagico())

    override method atacar(enemigo) {
        super(enemigo)
        fisicosConsecutivos += 1
        magicosConsecutivos = 0
        if (fisicosConsecutivos == 5) {
            modo = valiente
        }
    }

    override method lanzarHechizo(hechizo, enemigo) {
        super(hechizo, enemigo)
        magicosConsecutivos += 1
        fisicosConsecutivos = 0
        if (magicosConsecutivos >= 5) {
            modo = sabio
        }
    }
 }

object tranquilo {
    method adicionalFisico() = 0
    method adicionalMagico() = 0
}
object valiente {
    method adicionalFisico() = 0.5
    method adicionalMagico() = -0.2
}
object sabio {
    method adicionalFisico() = -0.7
    method adicionalMagico() = 2
}