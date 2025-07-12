# Documentação do Modelo Simulink: CSTR_Transfer_Analise

##  Visão Geral

Este repositório contém um modelo desenvolvido em MATLAB/Simulink para simulação da resposta de um reator contínuo CSTR utilizando **funções de transferência lineares**. O modelo avalia o impacto de perturbações em duas variáveis de entrada:

* Vazão de entrada do reator `F`;
* Concentração da alimentação `CA0`.

Os scripts são utilizados para:

* Construção automatizada dos blocos no Simulink;
* Modelagem com equações diferenciais lineares em forma de função de transferência;
* Inserção de perturbações do tipo degrau;
* Visualização em `Scope` e exportação para o MATLAB Workspace.

---

##  Fundamento Teórico

O modelo parte do balanço de massa não linear do CSTR:

\[
\frac{dC_A}{dt} = \frac{F}{V}(C_{A0} - C_A) - kC_A^2
\]

Para simplificação e análise, esse sistema é linearizado ao redor do ponto de operação \((CA0_{rp}, F_{rp}, CA_{rp})\), resultando em duas funções de transferência com entradas independentes:

* Perturbação em `CA0`:  
  \[
  G_2(s) = \frac{K_2}{\tau s + 1}, \quad K_2 = \frac{F_{rp}}{F_{rp} + 2kVC_{A_{rp}}}
  \]

* Perturbação em `F`:  
  \[
  G_1(s) = \frac{K_1}{\tau s + 1}, \quad K_1 = \frac{CA0_{rp} - C_{A_{rp}}}{F_{rp} + 2kVC_{A_{rp}}}
  \]

A saída total é dada por:

\[
C_A(s) = G_1(s) \cdot \Delta F(s) + G_2(s) \cdot \Delta CA0(s) + C_{A_{rp}}
\]

---

##  Imagem da implementação:

![Problema_1_final](https://github.com/user-attachments/assets/f17d19e1-fb04-460d-bd9c-86cdde65a939)

---

##  Modelo Disponível

### `CSTR_Transfer_Analise`

> Modelo com funções de transferência desacopladas para análise de sensibilidade do reator CSTR.

* Simula a resposta a degraus aplicados em `F` e `CA0` separadamente;
* Inclui dois subsistemas com funções de transferência: `G1` e `G2`;
* Soma as contribuições dinâmicas e adiciona o valor de regime permanente `CArp`;
* Exibe a concentração total `CA` em escopo e salva no Workspace;
* Mostra também o valor real de entrada de `CA0` para comparação.

---

## 📖 Requisitos

* MATLAB (testado na R2021b ou superior);
* Toolbox Simulink.

---

##  Como Executar

1. Abra o MATLAB;
2. Execute o script `CSTR_Transfer_Analise.m`;
3. O modelo Simulink será gerado automaticamente;
4. Pressione "Run" no Simulink;
5. Visualize os resultados nos blocos `Scope_CA` e `Scope_CA0`, ou acesse as variáveis `CA` e `CA0` no Workspace.

---

##  Estrutura do Script

* Define os parâmetros operacionais e calcula os ganhos \( K_1, K_2 \) e constante de tempo \( \tau \);
* Cria blocos `Step` para aplicar perturbações em `F` e `CA0`;
* Constrói as funções de transferência `G1` e `G2` no Simulink;
* Soma as contribuições e adiciona a concentração de referência;
* Exporta as saídas do sistema para análise posterior.

---

##  Observações

* As perturbações são aplicadas no instante inicial (`t = 0`);
* Os valores de \( C_{A_{rp}} \), \( CA0_{rp} \), e \( F_{rp} \) devem representar o regime estacionário escolhido;
* Útil para análises de sensibilidade, controle e estudos comparativos com o modelo não linear.

---

##  Licença

© Orlando Pardini Gardezani - Uso restrito ao autor e colaboradores autorizados.

---

</br>

*Para qualquer dúvida, entre em contato: [orlando.pardini@outlook.com](mailto:orlando.pardini@outlook.com)*

