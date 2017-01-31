class Perceptron

  attr_accessor :quando_aprendeu, :pesos

  TAXA_APRENDIZADO = 0.01
  
  # Inicializa atributos
  def initialize
    @limiar = -1
    @pesos = Array.new(4) { rand }
    @quando_aprendeu = 0
  end

  def treinar!
    puts "Treinando..."
    puts "Pesos iniciais: #{@pesos}"
    entradas = ler_arquivo('dados/treinamento/perceptron.txt') # carrega dados de treinamento de arquivo
    entradas.map! { |e| e.insert(0, @limiar) } # insere o limiar, em cada amostra de entrada

    begin # Repete até não existir erro, eu seja, até o número de acertos for igual ao total de amostras de treinamento
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
      end
    end while (acertou != entradas.size)
    puts "Aprendeu em #{@quando_aprendeu} épocas"
    puts "Pesos finais #{@pesos}"
  end

  # classificador
  def classificar
    amostras = ler_arquivo('dados/amostras/perceptron.txt')
    amostras.map! { |e| e.insert(0, @limiar) }

    amostras.each do |amostra|
      u = combinador_linear(amostra)
      y = funcao_ativacao(u)
      puts "Amostra: #{amostra[1..3]} : Saída: #{y}"
    end
  end

  # Função Degrau
  def funcao_ativacao(sinal)
    sinal.negative? ? -1 : 1
  end

  # Combinador linear faz o somatório de todas as entradas(X0..Xn) ponderadas
  def combinador_linear(entradas)
    somatorio = 0
    entradas.each_with_index { |entrada, indice| somatorio += entrada * @pesos[indice] }
    somatorio
  end

  # Função auxiliar para ler arquivo
  def ler_arquivo(arquivo)
    File.foreach(arquivo).map() { |linha| linha.split(' ').map(&:to_f) }
  end

end

# Execução 
p = Perceptron.new
p.treinar!
p.classificar