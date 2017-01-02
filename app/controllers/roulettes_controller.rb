class RoulettesController < ApplicationController
    def index
      @roulettes = Roulette.all
    end

    def playManual
      @gamers = Gamer.all

      @gamers.each do |gamer|
        apuesta = apuesta(gamer.saldo, 32)
        resultado = play(apuesta)

        gamer.update(saldo: resultado)

        if(resultado == gamer.saldo)
          resultado = false
        else
          resultado = true
        end

        Roulette.create(gamer: gamer.id, fecha: Date.current.to_s, apuesta:  apuesta, resultado: resultado)
      end

    end

    def apuesta(dinero, temperatura)
        if dinero <= 1000 && dinero > 0
            dinero
        elsif temperatura > 32
            dinero * rand(4..10) / 100
        elsif dinero > 1000
            dinero * rand(8..15) / 100
        end
    end

    def play(apuesta)
        probSeleccion = rand(100)
        probResultado = rand(100)

        # Probabilidad de que seleccione un color
        color = case probSeleccion
                when 0...49 then 'Rojo'
                when 49...98 then 'Negro'
                when 98...100 then 'Verde'
        end

        # Probabilidad de que salga ese color
        resultado = case probResultado
                    when 0...49 then 'Rojo'
                    when 49...98 then 'Negro'
                    when 98...100 then 'Verde'
        end

        # Si el color seleccionado con el resultado son iguales, gana
        if color === resultado
            return apuesta * 2 if resultado === 'Negro' || resultado === 'Rojo'

            return apuesta * 15 if resultado == 'Verde'

        else
            return apuesta
        end
    end
end
