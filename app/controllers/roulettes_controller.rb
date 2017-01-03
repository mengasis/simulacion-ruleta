class RoulettesController < ApplicationController
    def index
        @roulettes = Roulette.all
    end

    def playManual
        @gamers = Gamer.all

        @gamers.each do |gamer|

            # Evalua las condiciones para la apuesta
            apuesta = apuesta(gamer.saldo, getTemperatura)
            gamer.update(saldo: gamer.saldo - apuesta)

            resultado = play(apuesta)
            puts '**Jugador: ' + gamer.inspect

            # Si lo apostado es igual a lo ganado, entonces perdio
            if resultado == apuesta
                Roulette.create(gamer: gamer, fecha: Date.current.to_s, apuesta: apuesta, resultado: 0)
            else
                Roulette.create(gamer: gamer, fecha: Date.current.to_s, apuesta: apuesta, resultado: 1)

                gamer.update(saldo: gamer.saldo + resultado)
            end
        end

        redirect_to action: 'index'
    end

    # Verifica si la temperatura de los proximos 7 dias es mayor a 32˚C
    def getTemperatura
        apikey = 'addcc19d518e0e9e0be78415f09bebb2'

        actual = Date.today

        for day in 0..7

            epoch = actual.to_time.to_i.to_s

            url = 'https://api.darksky.net/forecast/' + apikey + '/-33.4378,-70.6504,' + epoch

            darksky = JSON.parse(HTTP.get(url))

            temperatura = darksky['daily']['data'][0]['temperatureMax']
            # 32˚C son 89.6 ˚Fahrenheit
            return true if temperatura > 89.6

            actual += 1
        end

        false
    end

    def apuesta(dinero, temperatura)
        if dinero <= 1000 && dinero > 0
            dinero
        elsif temperatura
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
