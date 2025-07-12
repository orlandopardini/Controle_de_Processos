#  Simulação e Controle de Processos

Este repositório reúne uma série de projetos voltados à análise e simulação de sistemas dinâmicos contínuos, com foco em aplicações de Engenharia Química. Os modelos foram desenvolvidos em **MATLAB/Simulink**, com apoio de ferramentas como **SymPy (Python)** e **Scilab**, e abordam desde reatores contínuos (CSTRs) até sistemas de tanques térmicos.

> **Autor:** Orlando Pardini Gardezani  
> **Contato:** orlando.pardini@outlook.com

---

##  Estrutura do Repositório

| Pasta                         | Descrição                                                                 |
|------------------------------|---------------------------------------------------------------------------|
| `CSTR_Controlado_Linear`     | Simulação de um reator CSTR linear com implementação de controle PID.     |
| `CSTR_Degrau_Atraso`         | Análise da resposta a degraus aplicados na vazão e concentração de entrada. |
| `CSTR_NaoLinear`             | Modelo completo e não linear do CSTR resolvido numericamente.             |
| `CSTR_Transfer_Analise`      | Implementação com funções de transferência para análise de perturbações.  |
| `Controle_Simbolico`         | Soluções simbólicas de ODEs via SymPy, com comparação a métodos numéricos.|
| `Simulacao_Tanques`          | Modelagem de tanques em cascata, com ou sem malha de controle.            |
| `Simulacao_Van_de_Vusse`     | Simulação do reator Van de Vusse (linear vs não linear).                  |
| `Tanques_de_Aquecimento`     | Análise de sistemas térmicos com troca de calor em tanques.               |

---

##  Fundamento Teórico

Cada modelo parte de **equações diferenciais ordinárias** (EDOs), obtidas a partir de balanços de massa e/ou energia. Para fins de controle e análise, os modelos foram linearizados ao redor de um ponto de operação, permitindo a aplicação de funções de transferência e controladores lineares.

Soluções simbólicas (via `SymPy`) são comparadas com métodos numéricos, como o **Runge-Kutta de 4ª ordem**, destacando as diferenças entre abordagens analíticas e aproximadas.

---

##  Objetivos

- Simular e visualizar a dinâmica de processos típicos em Engenharia de Processos.
- Comparar abordagens simbólicas e numéricas para resolução de EDOs.
- Implementar e avaliar malhas de controle PID em sistemas contínuos.
- Consolidar o aprendizado de modelagem dinâmica, controle e instrumentação.

---

##  Requisitos

- MATLAB com Simulink instalado
- (Opcional) Python 3 com `sympy`, `matplotlib`, `numpy`
- (Opcional) Scilab para comparações com métodos numéricos

---

 Para detalhes de cada modelo, consulte o `README.md` presente em cada pasta do repositório.

