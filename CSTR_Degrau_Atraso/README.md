# Documentação do Modelo Simulink: CSTR_Degrau_Atraso

##  Visão Geral

Este repositório contém um modelo desenvolvido em MATLAB/Simulink para simulação dinâmica de um reator contínuo CSTR com **aplicação de degraus com atraso**. O modelo permite observar a resposta do sistema frente a perturbações aplicadas em tempo diferente de zero.

A proposta é analisar a resposta dinâmica do sistema linearizado após um atraso programado na entrada de fluxo (`F`) e concentração de alimentação (`CA0`).

---

##  Fundamento Teórico

O modelo é derivado do balanço de massa para um reator contínuo com reação de segunda ordem. Para fins de análise e controle, é utilizado o modelo linearizado ao redor do ponto de operação:

\[
\frac{dC_A}{dt} = \frac{F}{V}(C_{A0} - C_A) - kC_A^2
\]

Este modelo é representado por duas funções de transferência lineares:

- Perturbação em `CA0`:
  \[
  G_2(s) = \frac{K_2}{\tau s + 1}, \quad K_2 = \frac{F}{F + 2kVC_{A_{rp}}}
  \]

- Perturbação em `F`:
  \[
  G_1(s) = \frac{K_1}{\tau s + 1}, \quad K_1 = \frac{CA0_{rp} - C_{A_{rp}}}{F + 2kVC_{A_{rp}}}
  \]

A saída total é dada por:

\[
C_A(s) = G_1(s) \cdot \Delta F(s) + G_2(s) \cdot \Delta CA0(s) + C_{A_{rp}}
\]

---

##  Imagem da implementação:

![Prova_1](https://github.com/user-attachments/assets/08402023-749b-46d7-a504-801b8a65d7da)

---

##  Modelo Disponível

### `CSTR_Degrau_Atraso`

> Modelo com degraus aplicados em `F` e `CA0` após atraso de 5 segundos.

* As funções de transferência `G1` e `G2` são usadas para modelar a resposta linear do sistema;
* A concentração total `CA` é somada ao valor de regime permanente `CArp`;
* O modelo também calcula e plota a entrada real de `CA0` após somar o degrau com o valor de referência `CA0rp`;
* Resultados são exibidos nos escopos `Scope_CA` e `Scope_CA0`, e exportados para `WS_CA` e `WS_CA0` no Workspace.

---

##  Requisitos

* MATLAB (testado na R2021b ou superior);
* Toolbox Simulink.

---

##  Como Executar

1. Abra o MATLAB;
2. Execute o script `CSTR_Degrau_Atraso.m`;
3. O modelo será criado automaticamente no Simulink;
4. Pressione **Run**;
5. Observe os resultados nos escopos:
   - `Scope_CA`: concentração simulada;
   - `Scope_CA0`: entrada real de `CA0`;
6. As variáveis `CA` e `CA0` estarão disponíveis no Workspace para análise adicional.

---

##  Estrutura do Script

* Define parâmetros físicos do reator, ponto de operação e características dos degraus;
* Cria blocos `Step` com atraso (`t_step = 5`);
* Implementa as funções de transferência `G1` e `G2` com suas respectivas conexões;
* Adiciona os valores de referência ao final para obter o valor absoluto da concentração;
* Organiza visualmente os blocos com `set_param()` para clareza estrutural.

---

##  Observações

* A simulação é feita para 101 segundos com passo de 0.01 s;
* Os degraus são aplicados após 5 segundos para simular atraso na resposta;
* É útil para observar o tempo de resposta do sistema e a sensibilidade a diferentes entradas.

---

##  Licença

© Orlando Pardini Gardezani - Uso restrito ao autor e colaboradores autorizados.

---

</br>

*Para qualquer dúvida, entre em contato: [orlando.pardini@outlook.com](mailto:orlando.pardini@outlook.com)*

