class Adaline

  attr_accessor :quando_aprendeu, :pesos

  TAXA_APRENDIZADO = 0.0025
  PRECISAO = 10 ** (-6)
  
  # Inicializa atributos
  def initialize
    @limiar = -1
    @pesos = Array.new(5) { rand }
    @quando_aprendeu = 0
  end

  def treinar!
    puts "Treinando..."
    puts "Pesos iniciais: #{@pesos}"
    entradas = ler_arquivo('dados/treinamento/adaline.txt') # carrega dados de treinamento de arquivo
    entradas.map! { |e| e.insert(0, @limiar) } # insere o limiar, em cada amostra de entrada

    eqms = Array.new(2) { 0.0 }

    begin # Repete até não existir erro, eu seja, até o número de acertos for igual ao total de amostras de treinamento
      @quando_aprendeu += 1
      eqms[0] = eqms[1]
      entradas.each do |entrada|
        entrada_preparada = entrada[0..4]
        u = combinador_linear(entrada_preparada)
        @pesos.each_with_index do |w, i| 
          @pesos[i] = w + TAXA_APRENDIZADO * (entrada[5] - u) * entrada[i]
        end
      end
      eqms[1] = eqm(entradas)
    end while ( (eqms[0] - eqms[1]).abs > PRECISAO )
    puts "Aprendeu em #{@quando_aprendeu} épocas"
    puts "Pesos finais #{@pesos}"
  end

  # classificador
  def classificar
    amostras = ler_arquivo('dados/amostras/adaline.txt')
    amostras.map! { |e| e.insert(0, @limiar) } # insere o limiar em cada amostra

    amostras.each do |amostra|
      u = combinador_linear(amostra)
      y = funcao_ativacao(u)
      puts "Amostra: #{amostra[1..4]} : Saída: #{y}"
    end
  end

  # Cálculo  do erro quadrático médio
  def eqm(entradas)
    r = 0.0
    entradas.each do |e|  
      u = combinador_linear(e[0..4])
      r += (u - e[4]) ** 2
    end
    r/entradas.size
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
p = Adaline.new
p.treinar!
p.classificar