# Documentação do Modelo Simulink: Problema_BCD

##  Visão Geral

Este repositório contém um modelo desenvolvido em MATLAB/Simulink para a simulação dinâmica de um **sistema térmico com controle de temperatura**, utilizando três malhas independentes (B, C e D) com diferentes perturbações aplicadas.

O objetivo do modelo é comparar a resposta térmica de um sistema a variações de temperatura de entrada (`T0`) e potência de aquecimento (`Q`) com base em uma estrutura modular e reutilizável.

Os scripts são utilizados para:

* Construção automática dos blocos no Simulink;
* Modelagem via equações diferenciais de sistemas térmicos;
* Inserção de degraus em `T0` e `Q`;
* Visualização em `Scope` e exportação para o MATLAB Workspace.

---

##  Fundamento Teórico

A dinâmica de temperatura é modelada com base no balanço de energia para um sistema de volume constante, resultando em uma equação de primeira ordem:

$\tau = \frac{\rho \cdot V}{\dot{m}}, \quad K_{T0} = 1, \quad K_Q = \frac{1}{\dot{m} \cdot C_p}$

O sistema é representado por duas funções de transferência em paralelo:

* Resposta à temperatura de entrada `T0`:  $\frac{K_{T0}}{1 + s\tau}$

* Resposta à potência de aquecimento `Q`:  $\frac{K_Q}{1 + s\tau}$

A saída térmica total é obtida pela soma dessas duas contribuições em relação à temperatura de referência `T_{rp}`.

---

##  Imagem da implementação:

![Simulacao_Tanques](https://github.com/user-attachments/assets/f2ac3b26-f75a-42f4-805f-d5476bf1c4ca)

---

##  Modelo Disponível

### `Problema3_BCD`

> Modelo modular com três malhas de controle térmico (B, C e D).

* Cada malha simula uma combinação diferente de perturbações:
  - **Malha B**: Perturbação apenas em `Q`
  - **Malha C**: Perturbação apenas em `T0`
  - **Malha D**: Perturbação em `T0` e em `Q`
* A estrutura é criada dinamicamente por meio da função `create_loop()`;
* Os blocos são conectados automaticamente via script;
* Os resultados são mostrados individualmente em `Scope_B`, `Scope_C`, `Scope_D`;
* Um `MUX` final consolida as três saídas em `Scope_Final`.

---

##  Requisitos

* MATLAB (testado na R2021b ou superior);
* Toolbox Simulink.

---

##  Como Executar

1. Abra o MATLAB;
2. Execute o script `Problema3_BCD.m`;
3. O modelo Simulink será gerado automaticamente com todas as malhas;
4. Pressione "Run" no Simulink;
5. Visualize os resultados nos blocos `Scope_*` ou acesse as variáveis `T_B`, `T_C`, `T_D` no Workspace.

---

##  Estrutura do Script

* Define os parâmetros térmicos (volume, massa, densidade, calor específico);
* Calcula os ganhos e constantes de tempo;
* Gera automaticamente cada malha com função `create_loop()`:
  - Blocos de degrau (`Step`);
  - Funções de transferência (`Transfer Fcn`);
  - Somadores e referências;
  - Exportação com `To Workspace`.
* Conecta todas as saídas em um `MUX` para visualização comparativa.

---

##  Observações

* O script é altamente reutilizável: basta mudar os parâmetros da função `create_loop`;
* Os degraus são aplicados no instante inicial (`tstep = 0`);
* Os perfis de saída permitem comparar como diferentes perturbações afetam a resposta do sistema térmico.

---

##  Licença

© Orlando Pardini Gardezani - Uso restrito ao autor e colaboradores autorizados.

---

</br>

*Para qualquer dúvida, entre em contato: [orlando.pardini@outlook.com](mailto:orlando.pardini@outlook.com)*

