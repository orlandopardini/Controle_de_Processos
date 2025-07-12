# Documentação do Modelo Simulink: Problema_Reservatorio

##  Visão Geral

Este repositório contém um modelo desenvolvido em MATLAB/Simulink para simulação dinâmica de um **reservatório hidráulico** sujeito a uma perturbação na vazão de entrada.

O script compara dois modelos de comportamento do nível do reservatório:

* Um modelo linear baseado em função de transferência de 1ª ordem;
* Um modelo físico com base em balanço de massa e integração direta.

Os scripts são utilizados para:

* Construção automática dos blocos no Simulink;
* Modelagem via equações diferenciais e função de transferência;
* Inserção de degrau na entrada de vazão;
* Visualização em `Scope` e exportação para o MATLAB Workspace.

---

##  Fundamento Teórico

O modelo avalia o comportamento dinâmico do nível de um reservatório frente a variações na vazão de entrada.

### Equações utilizadas:

* Função de transferência equivalente:

  $\tau = \frac{2A\sqrt{h_{rp}}}{k}$  
  $K_p = \frac{2\sqrt{h_{rp}}}{k}$  
  $\Rightarrow \frac{K_p}{1 + s\tau}$

* Modelo físico (integração direta):

  $A \cdot \frac{dh}{dt} = q_{in} - k\sqrt{h}$

---

##  Modelo Disponível

### `Problema_Reservatorio`

> Modelo com comparação entre função de transferência e modelo físico de tanque.

* Simula a resposta a um degrau aplicado à vazão de entrada.
* Plota dois perfis de altura (um por função de transferência e outro por balanço de massa).
* Permite análise da diferença entre abordagem linear e não linear.
* Exporta os dados simulados para `h_out` no MATLAB Workspace.

---

##  Requisitos

* MATLAB (testado na R2021b ou superior);
* Toolbox Simulink.

---

##  Como Executar

1. Abra o MATLAB;
2. Execute o script `Problema3_Reservatorio.m`;
3. O modelo Simulink será gerado e aberto automaticamente;
4. Pressione "Run" no Simulink;
5. Visualize os resultados no `Scope` ou acesse a variável `h_out` no Workspace.

---

##  Estrutura do Script

O script realiza:

* Definição dos parâmetros do reservatório (área, altura, constante de descarga);
* Criação do modelo com `new_system()` e inserção dos blocos;
* Implementação da função de transferência e do modelo físico;
* Soma com valor de referência (`h_{rp}`) para comparação visual;
* Conexão e roteamento dos sinais com `add_line()`;
* Organização visual com `set_param()`.

---

##  Observações

* Os valores de `A`, `k`, `h_rp` e `Forp` podem ser ajustados conforme o sistema a ser estudado;
* A simulação cobre 6 vezes a constante de tempo (`6 * τ`) para capturar a resposta completa;
* A análise conjunta permite verificar a diferença entre o modelo linearizado e o comportamento real esperado.

---

##  Licença

© Orlando Pardini Gardezani - Uso restrito ao autor e colaboradores autorizados.

---

</br>

*Para qualquer dúvida, entre em contato: [orlando.pardini@outlook.com](mailto:orlando.pardini@outlook.com)*

