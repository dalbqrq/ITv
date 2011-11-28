version = "1.0.6"
patch = 0


description = [[

<br><br><b> Versão 1.0.6 (12 de junho de 2012) </b>


- Incluido no log (Administrar -> Logs) os eventos relacionados às aplicações (criação, remoção, alteração, etc..).

- Novos comandos de checagem (SPOP3, SSMTP, SIMAP) incluidos. Nome dos omandos de checagem HTTP_2 e POP alterados para HTTP_Hostname e POP3 respectivamente.

- BugFix: Corrigigo o bug que permitia que aplicações de outras entidades pudessem ser visualizadas.

- Agora não é possível criar aplicações com nomes já existentes."

- BugFix: Tela de Aplicações agora é ordenada por entidades+nome da aplicação."

- BugFix: Agora a tela de Objetos da Aplicação aparece com o 'Tipo' de objeto correto."



<br><br><b> Versão 1.0.5 (4 de junho de 2012) </b>


- Corrigida as regras para determinação do status das aplicações e aplicações de entidades.

- Habilitar/Desabilitar passou a ser Ligar/Desligar no sentido de se ligar ou desligar a monitoração de determinado objeto (dispositivo, serviço ou aplicação.

- Nas telas de informação de dispositivo, serviços e aplicações foram colocados links para as aplicações que possuem tal objeto.

- Todos os objetos desativados agora aparecem em todas as telas (árvore, grafo, grade, lista, aplicações e checagem).

- Foram corrigidas todas as telas onde objetos desligados não apareciam como tal.


<br><br><b> Versão 1.0.4 (29 de Maio de 2012) </b>


- As telas Lista, Aplicações e Checagem tiveram sua interfaces alteradas para torna-las mais homogêneas quanto à apresentação e à forma.

- As telas de Relacionamento e Contatos de Aplicações tiveram sua interfaces alteradas para torna-las mais homogêneas quanto à apresentação e à forma.

- BugFix: Inclusão de novos objetos em uma aplicação com erro de Page Not Found.

- Link de inclusão de novasa aplicações com erro na tela de Lista.

- Status nas telas de detalhe de informação tanto de dispositivos quanto de serviços não apresentava o status "DESLIGADO".


<br><br><b> Versão 1.0.3 (25 de Maio de 2012) </b>

- As ações na tela de Checagem agora são simbilizadas por icones. É possivel agora a partir desta tela ligar e desligar as probes. A linha extra na tabela que era usada para criar um serviço associado à um dispositivo não existe mais. Agora a  inclusão de um novo serviço é feito através do icone '+' na mesma linha do comando HOST_ALIVE.

- BugFix: Aplicação desparecia quando destivada. Agora aparece com status correto e de cor laranja.

- BugFix: caixa de seleção de aplicações na tela de Grafo estava com link quebrado.

- Nome do botão "Desligar checagem" da tela de edição de probe alterado para "Desligar alerta".

- Links para CMDB e Status nos balões que se abrem quando o pino do mapa é clicado.

- Aba CMDB e Checagem na visão na tela de detalhamento de um dispositivo ou de um serviço foi substituida por links abaixo da tabela principal.



<br><br><b> Versão 1.0.2 (21 de Maio de 2012) </b>

- Relário é colocado e atualizado somente nas páginas que fazer refresh e apresentam status de aplicações.

- Apresentação da tela de grade montrando todas a entidades de forma recursiva é agora o padrão e não há mais a opção do usuário alterar isso.

- Incluido novo menu Relatórios e mecanismo para o desenvolvimento independente de páginas em php para este fim, com a possibilidade inclusive de se criar entradas no seu respectivo submenu.


<br><br><b> Versão 1.0.1 (11 de Maio de 2012) </b>

- Submenu de Monitor foi reordenado.

- A tela de Lista agora entra com somente as Entidades selecionadas.

- Checkbox na tela de grade para visualizar na mesma tela (recursivamente) todas as aplicações e sub-entidades.

- Mudanças na aparência na tela de grade. Fontes menores e retângulos maiores para aumentas o número de colunas de 4 para 5.

- Link das aplicações e das entidades da tela de Grade passam a apontar para a própria tela de grade. 

- BugFix: Link das aplicações e das entidades da tela de Aplicações passam a apontar para a própria tela de Aplicações. 

- BugFix: A barra de resumo de status de Entidades, Aplicações, Dispositivos e Serviços passa a totalizar somente as respectivas informações para a Entidade corrente selecionada. Antes sempre mostrava o total de todas as entidads.

- A barra de resumo foi colocada em todas as telas do menu Monitor.

- BugFix: Retirado o link para Remover uma entidade que aparecia na lista de objetos de uma aplicação na tela de Aplicações.  Isto porque uma sub-entidade só pode ser retirada de uma entidade pai se ela for totalmente removida do sistema.o

- incluido o relógio ativo na barra de menu.

- Alterada a cor de fundo dos itens de menu ativo para cinza. Era quase branco e não se podia visualizar qual 
  item estava selecionado.

- A tela de ajuda apresenta as notas de release contendo as mudanças e correções executadas.

<br><br>
]]
