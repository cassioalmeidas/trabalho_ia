class Perceptron

  attr_accessor :quando_aprendeu, :pesos

  TAXA_APRENDIZADO = 0.01
  

  def initialize()
    @limiar = -1
    @pesos = Array.new(4) { rand }
    @quando_aprendeu = 0
  end

  def treinar()
    entradas = ler_arquivo('dados/treinamento/perceptron.txt')
    entradas.map! { |e| e.insert(0, @limiar) }

    begin 
      acertou = 0
      @quando_aprendeu += 1
      entradas.each do |entrada|
        entrada_preparada = entrada[0..3]
        u = combinador_linear(entrada_preparada)
        y = funcao_ativacao(u)
        @pesos.each_with_index do |w, i| 
          @pesos[i] = w + TAXA_APRENDIZADO * (entrada[4] - y) * entrada[i]
        end
        if y == entrada[4]
          acertou += 1
        end
        puts "u: #{y} certo: #{entrada[4]}"
      end
    end while (acertou != entradas.size)
  end

  def classificar
    amostras = ler_arquivo('dados/amostras/perceptron.txt')
    amostras.each do |amostra|
      u = combinador_linear(amostra)
      y = funcao_ativacao(u)
      puts "#{amostra} : saída: #{y}"
    end
  end

  def funcao_ativacao(sinal)
    # Função Degrau
    sinal.negative? ? -1 : 1
  end

  def combinador_linear(entradas)
    somatorio = 0
    entradas.each_with_index { |entrada, indice| somatorio += entrada * @pesos[indice] }
    somatorio
  end

  def ler_arquivo(arquivo)
    File.foreach(arquivo).map() { |linha| linha.split(' ').map(&:to_f) }
  end

end

# p = Perceptron.new
# p.treinar
# p.classificar