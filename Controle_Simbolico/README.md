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
