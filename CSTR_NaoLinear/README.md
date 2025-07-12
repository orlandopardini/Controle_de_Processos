# Documentação do Modelo Simulink: CSTR_Linear_NaoLinear

##  Visão Geral

Este repositório contém um modelo desenvolvido em MATLAB/Simulink para simulação dinâmica de um reator contínuo do tipo CSTR, comparando a resposta de dois modelos:

* Um modelo **não linear**, baseado na equação original do balanço de massa;
* Um modelo **linearizado**, baseado em uma função de transferência de primeira ordem.

O objetivo é avaliar o comportamento do sistema sob uma perturbação no valor de entrada da concentração de alimentação `CA0`.

Os scripts são utilizados para:

* Construção automática dos blocos no Simulink;
* Modelagem via equações diferenciais (modelo real) e função de transferência (modelo linear);
* Inserção de perturbação do tipo degrau;
* Visualização em `Scope` e exportação para o MATLAB Workspace.

---

##  Fundamento Teórico

### Modelo Não Linear

Baseado no balanço de massa para um reator CSTR com reação de segunda ordem:

$\frac{dC_A}{dt} = \frac{F}{V}(C_{A0} - C_A) - kC_A^2$

### Modelo Linearizado

A versão linearizada, ao redor do ponto de operação, assume uma função de transferência de primeira ordem:

$G(s) = \frac{K_p}{\tau s + 1}$

Com os seguintes parâmetros:

$\tau = \frac{V}{F + 2kVC_{A_{rp}}}, \quad K_p = \frac{F}{F + 2kVC_{A_{rp}}}$

---

##  Imagem da implementação:

![Problema_6_Reator_isotermico](https://github.com/user-attachments/assets/d59baf4f-4e0c-4cff-b7ba-103b62cbfa53)

---

##  Modelo Disponível

### `CSTR_Linear_NaoLinear`

> Modelo comparativo entre CSTR não linear e sua versão linearizada.

* Simula a resposta do sistema a um degrau aplicado em `CA0`;
* O modelo **não linear** utiliza um bloco `MATLAB Function`;
* O modelo **linearizado** utiliza uma `Transfer Function`;
* Ambas as respostas são mostradas em escopos separados (`Scope_NL`, `Scope_L`);
* Os resultados são exportados para o Workspace como `CANL` e `CAL`.

---

##  Requisitos

* MATLAB (testado na R2021b ou superior);
* Toolbox Simulink;
* Stateflow habilitado (para blocos `MATLAB Function`).

---

##  Como Executar

1. Abra o MATLAB;
2. Execute o script `CSTR_Linear_NaoLinear.m`;
3. O modelo Simulink será criado automaticamente;
4. Pressione "Run" no Simulink;
5. Visualize os resultados nos blocos `Scope_L` e `Scope_NL`, ou acesse as variáveis `CANL` e `CAL` no Workspace.

---

##  Estrutura do Script

* Define os parâmetros do sistema (volume, taxa de vazão, constante de reação);
* Calcula os parâmetros da função de transferência (`Kp` e `tau`);
* Gera o modelo **não linear**:
  - Bloco de degrau;
  - Bloco `MATLAB Function` com a equação diferencial;
  - Integrador e visualização.
* Gera o modelo **linearizado**:
  - Degrau em `CA0`;
  - Função de transferência e somador com ponto de operação;
  - Visualização e exportação.
* Organiza visualmente os blocos com `set_param()`.

---

##  Observações

* A simulação cobre um tempo de 101 segundos com passo de 1s;
* O modelo permite visualizar as diferenças de comportamento dinâmico entre a versão linearizada e o sistema real;
* O ponto de operação utilizado é:  
  $C_{A0}^{rp} = 0.925$,  
  $C_{A}^{rp} = 0.236$

---

##  Licença

© Orlando Pardini Gardezani - Uso restrito ao autor e colaboradores autorizados.

---

</br>

*Para qualquer dúvida, entre em contato: [orlando.pardini@outlook.com](mailto:orlando.pardini@outlook.com)*

