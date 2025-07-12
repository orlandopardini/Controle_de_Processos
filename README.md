# Documentação dos Modelos Simulink: Reator de Van de Vusse

## 🔹 Visão Geral

Este repositório contém três modelos desenvolvidos em MATLAB/Simulink para simulação dinâmica do **Reator de Van de Vusse**, um sistema clássico de reator CSTR com reações paralelas e em série.

Os scripts são utilizados para:

* Construção automática dos blocos no Simulink;
* Modelagem via equações diferenciais (EDOs);
* Inserção de perturbações (degraus);
* Visualização em `Scope` e exportação para o MATLAB Workspace.

---

## 🎓 Fundamento Teórico

O reator Van de Vusse é modelado considerando as seguintes reações:

* $A \xrightarrow{k_1} B$
* $B \xrightarrow{k_2} C$
* $2A \xrightarrow{k_3} D$

Com balanços de massa levando a duas equações diferenciais principais:

$\frac{dC_A}{dt} = \frac{F}{V}(C_{Af} - C_A) - k_1 C_A - k_3 C_A^2$
$\frac{dC_B}{dt} = -\frac{F}{V} C_B + k_1 C_A - k_2 C_B$

Essas equações são implementadas em blocos `MATLAB Function` dentro do ambiente Simulink.

---

## 🔧 Modelos Disponíveis

### 1. `VanderVusse_FinalScope`

> Modelo base sem perturbações.

* Simula a dinâmica natural do sistema.
* Usa integrais com condições iniciais definidas.
* Exibe saídas $C_A, C_B$ em escopo e salva no Workspace.

### 2. `VanderVusse_Step`

> Modelo com inserção de degraus em **CAf** e **F**.

* Inclui blocos adicionais `MF` e `MCA` para perturbação.
* Permite análise da resposta dinâmica.
* Pode ser usado para teste de controladores ou observadores.

### 3. `VanderVusse_FinalDegrau`

> Versão final com degrau em **CAf**, valores de regime permanente.

* Introduz degrau em CAf e plota comportamento das concentrações.
* Compara com valores esperados de regime permanente.

---

## 📖 Requisitos

* MATLAB (testado na R2021b ou superior);
* Toolbox Simulink;
* Stateflow habilitado (para blocos `MATLAB Function`).

---

## ⚖️ Como Executar

1. Abra o MATLAB;
2. Execute o script desejado (ex: `VanderVusse_FinalScope.m`);
3. O modelo Simulink será aberto automaticamente;
4. Pressione "Run" no Simulink;
5. Visualize os resultados no `Scope` ou acesse variáveis `CA_out` e `CB_out` no Workspace.

---

## 📚 Estrutura dos Scripts

Cada script:

* Define os parâmetros de simulação (tempo, condições iniciais);
* Cria o modelo Simulink do zero com `new_system()`;
* Insere blocos e conecta automaticamente com `add_block()` e `add_line()`;
* Define as equações em blocos `MATLAB Function` via API do Stateflow;
* Organiza visualmente os blocos com `set_param()`.

---

## ⚠️ Observações

* Os valores de CA e CB podem ser ajustados conforme o caso de estudo;
* Os modelos foram desenvolvidos para fins **didáticos** e **profissionais**, podendo ser adaptados para controle de processos, análise de estabilidade, etc.
* Para visualizar a resposta a degraus, altere `MCA` e `MF` nos modelos 2 e 3.

---

## 🌐 Licença

© Orlando Pardini Gardezani - Uso restrito ao autor e colaboradores autorizados.

---

Se desejar, posso gerar os `README.md` separadamente por script com figuras dos modelos gerados, fluxogramas e instruções de uso passo a passo. Basta pedir.

</br>

*Para qualquer dúvida, entre em contato: [orlando.pardini@outlook.com](mailto:orlando.pardini@outlook.com)*
