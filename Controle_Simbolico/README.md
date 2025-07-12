# Análise e Controle de Processos (ACP)

##  Visão Geral

Este repositório contém dois notebooks desenvolvidos para a disciplina de **Análise e Controle de Processos (ACP)**. O objetivo é estudar a resposta dinâmica de sistemas através da simulação de malhas de controle, análise de funções de transferência e implementação de estratégias clássicas de controle.

Os arquivos incluídos são:

- `ACP.ipynb`: simulação e análise direta do sistema dinâmico.
- `ACP_T.ipynb`: variação do modelo com alterações estruturais ou transposição de sinais (ex: análise em regime transposto ou com controle aplicado de forma alternativa).

---

##  Fundamento Teórico

A Análise e Controle de Processos tem como foco modelar e controlar sistemas físicos representados por equações diferenciais lineares, geralmente expressas em função de transferência:

$G(s) = \frac{K}{\tau s + 1}$

Os notebooks podem abranger os seguintes tópicos:

- Modelagem de sistemas de 1ª e 2ª ordem;
- Aplicação de degraus e análise de resposta transitória;
- Implementação de controladores PID;
- Comparação entre sistemas com e sem controle;
- Cálculo de erros, tempo de acomodação, sobressinal e regime permanente.

---

## Discussão sobre o Cálculo Simbólico vs. Numérico:

<img width="467" height="676" alt="image" src="https://github.com/user-attachments/assets/591267bd-a34a-4eb9-b9d2-6b0ee1c59c0d" />

gráfico ilustra claramente que os erros obtidos utilizando a biblioteca SymPy em Python foram significativamente menores do que aqueles calculados no Scilab com o método de Runge-Kutta de 4ª ordem. Essa diferença ocorre devido à natureza das abordagens utilizadas: a SymPy opera no domínio simbólico, enquanto o Runge-Kutta é um método numérico. A abordagem simbólica permite encontrar soluções exatas para as equações diferenciais, enquanto a abordagem numérica aproxima essas soluções por meio de cálculos iterativos ponto a ponto.
Na abordagem simbólica, como a utilizada pela SymPy, as equações diferenciais são resolvidas analiticamente, gerando expressões matemáticas exatas que descrevem o comportamento do sistema em qualquer instante de tempo. Isso elimina erros de arredondamento e aproximação, pois a manipulação das equações mantém todas as relações matemáticas intactas até a avaliação final. Essa precisão é particularmente útil em sistemas lineares ou onde o teorema do valor final pode ser validado diretamente.
Por outro lado, o método de Runge-Kutta de 4ª ordem, utilizado no Scilab, é uma abordagem numérica que calcula as soluções de forma iterativa em intervalos discretos de tempo (Δt). Embora seja um método robusto e amplamente utilizado, ele introduz erros acumulativos devido às aproximações feitas em cada passo de tempo. A precisão do método depende do tamanho do passo escolhido: passos menores oferecem maior precisão, mas demandam mais recursos computacionais (Chapra, 2014). No gráfico, observa-se que os erros são mais evidentes no início do intervalo, quando as variações do sistema são mais rápidas, enquanto esses erros se reduzem à medida que o sistema se aproxima do regime permanente.
A escolha entre abordagens simbólicas e numéricas depende do contexto. Métodos simbólicos, como o oferecido pela SymPy, são ideais para sistemas que possuem soluções analíticas ou quando é necessário validar resultados com alta precisão. Já os métodos numéricos, como o de Runge-Kutta, são mais indicados para sistemas complexos ou não lineares, onde soluções analíticas não são viáveis. Neste caso, a biblioteca SymPy demonstrou maior eficiência na obtenção de resultados com precisão elevada, enquanto o Scilab, com o método numérico, apresentou pequenos erros que, embora sejam aceitáveis para muitas aplicações práticas, destacam as limitações inerentes aos métodos numéricos.

Referências Bibliográficas:
**Chapra, S. C., & Canale, R. P.** (2014). Métodos Numéricos para Engenheiros: com programação em Python e MATLAB. McGraw-Hill.
SymPy Documentation. (2024). SymPy:

---

##  Estrutura dos Notebooks

### `ACP.ipynb`

> Notebook principal para análise da resposta de sistemas lineares.

- Importa bibliotecas como `numpy`, `matplotlib`, `scipy.signal`;
- Define as equações do sistema no domínio de Laplace;
- Aplica funções de transferência com `scipy.signal.TransferFunction`;
- Plota a resposta do sistema a entradas como degrau ou rampa;
- Pode incluir controle PID ou controle em malha aberta.

### `ACP_T.ipynb`

> Variante com modificação estrutural.

- Pode aplicar controle em malha fechada;
- Pode apresentar a transposição da planta ou do sensor;
- Útil para comparar desempenho entre diferentes estruturas de controle.

---

##  Como Executar

1. Instale as bibliotecas necessárias:

```bash
pip install numpy matplotlib scipy
