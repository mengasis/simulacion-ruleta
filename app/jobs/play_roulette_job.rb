class PlayRouletteJob < ApplicationJob
    queue_as :default

    def perform(*_args)

    end

    def play(dinero)
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
            return dinero * 2 if resultado === 'Negro' || resultado === 'Rojo'

            return dinero * 15 if resultado == 'Verde'

        else
            return dinero
        end
    end
end
