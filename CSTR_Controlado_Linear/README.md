# Documentação do Modelo Simulink: CSTR_Controlado_Linear

##  Visão Geral

Este repositório contém um modelo desenvolvido em MATLAB/Simulink para simulação dinâmica de um reator contínuo CSTR com duas abordagens:

1. **Modelo linear sem controle**, avaliando apenas a resposta do sistema a perturbações;
2. **Modelo linear com controle PID**, avaliando o desempenho de uma malha de controle em malha fechada.

O objetivo é comparar a dinâmica do sistema quando operado livremente versus quando regulado por um controlador com atuador (válvula) e sensor (transmissor).

---

##  Fundamento Teórico

### Modelo do Processo

O sistema é baseado na equação de balanço de massa com reação de segunda ordem, linearizada ao redor do ponto de operação:

\frac{dC_A}{dt} = \frac{F}{V}(C_{A0} - C_A) - kC_A^2 \Rightarrow G(s) = \frac{K}{\tau s + 1}

Com ganhos e constantes calculados como:

\tau = \frac{V}{F + 2kVC_{A_{rp}}}, \quad
K_1 = \frac{CA0_{rp} - C_{A_{rp}}}{F + 2kVC_{A_{rp}}}, \quad
K_2 = \frac{F}{F + 2kVC_{A_{rp}}}

### Malha de Controle

A estrutura de controle é composta por:

* **Setpoint**: entrada de referência (servo problema);
* **Transmissor**: modela a dinâmica do sensor;
* **Controlador PID**: com ganhos \(P\), \(I\) e \(D\);
* **Válvula de controle**: com dinâmica de primeira ordem;
* **Processo**: sistema com ganho \(K_1\) e constante de tempo \(\tau\).

---

##  Imagem da implementação:

![Problema_6_Controle_Final](https://github.com/user-attachments/assets/b1b08541-1756-47bf-a2d7-b63d6c3e2b0b)

---

##  Modelo Disponível

### `CSTR_Controlado_Linear`

> Modelo completo com simulação linear e controle PID.

#### Sem Controle:
* Simula a resposta do sistema a degraus em `CA0` e `F`;
* Usa duas funções de transferência (`TF1`, `TF2`);
* Exibe a resposta total da concentração `CA` em `Scope_CAL`.

#### Com Controle:
* Implementa uma malha PID em torno da concentração;
* Inclui transmissor e válvula como elementos de campo;
* Permite testar desempenho de controle servo (rastrear referência);
* Saída controlada é `CA`, exibida em `Scope_CA`.

---

##  Requisitos

* MATLAB (testado na R2021b ou superior);
* Toolbox Simulink;
* Stateflow habilitado (para versões com bloco MATLAB Function, se necessário).

---

##  Como Executar

1. Abra o MATLAB;
2. Execute o script `CSTR_Controlado_Linear.m`;
3. O modelo Simulink será criado automaticamente;
4. Pressione **Run** no Simulink;
5. Visualize os resultados:
   * `Scope_CAL`: resposta sem controle;
   * `Scope_CA`: resposta com controle PID;
   * `CAL_WS` e `CA_WS`: variáveis exportadas para o Workspace.

---

##  Estrutura do Script

* Define parâmetros físicos do reator, ponto de operação e perturbações;
* Calcula ganhos \(K_1, K_2\) e \(\tau\);
* Cria:
  - Funções de transferência para processo, válvula e transmissor;
  - Blocos `Step` para entrada de referência e perturbações;
  - Controlador PID com parâmetros ajustáveis;
* Conecta automaticamente os blocos via `add_line()`;
* Organiza visualmente os blocos com `set_param()`.

---

##  Observações

* A comparação entre os dois blocos permite observar o impacto do controle;
* A simulação cobre 101 segundos, com passo de 1s;
* Parâmetros do controlador podem ser ajustados diretamente no script (`Kc`, `tauI`, `tauD`);
* Pode ser estendido para controle regulatório alterando a malha de referência.

---

##  Licença

© Orlando Pardini Gardezani - Uso restrito ao autor e colaboradores autorizados.

---

</br>

*Para qualquer dúvida, entre em contato: [orlando.pardini@outlook.com](mailto:orlando.pardini@outlook.com)*

