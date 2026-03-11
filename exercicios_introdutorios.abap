*&---------------------------------------------------------------------*
*& Report ZGFLORES_01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zpro001.





*& EXERCICIO TRY CATCH
*&---------------------------------------------------------------------*


DATA: acentos_ac    TYPE int4,
      acentos_todos TYPE TABLE OF sflight-seatsmax.

SELECT * FROM sflight INTO TABLE @DATA(voos). "Selecionar toda a table

SELECT SINGLE seatsmax FROM sflight INTO acentos_ac WHERE carrid = 'AC'. "Selecionar apenas um campo da tabela

SELECT seatsmax FROM sflight INTO TABLE acentos_todos.  "Selecionar varias vezes o campo X de uma tabela
TRY.

    DATA: total_resultado TYPE int8.
    DATA(voo_structure) = voos[ carrid = 'AC' ].
    DATA(cap) = voos[ carrid = 'AC' ]-seatsmax.

    LOOP AT voos INTO DATA(voo).
      total_resultado = total_resultado + voo-seatsmax.
    ENDLOOP.
**  WRITE / total_resultado.


  CATCH cx_sy_itab_line_not_found.
    MESSAGE 'NAO ENCONTRADO NENHUM AC' TYPE 'e'.
ENDTRY.

*& EXERCICIO 16
*&---------------------------------------------------------------------*

TYPES: BEGIN OF aluno_tipo,
         matricula        TYPE num6,
         nome_aluno       TYPE char40,
         codigo_graduacao TYPE char3,
       END OF aluno_tipo.

DATA: aluno  TYPE aluno_tipo,
      alunos TYPE TABLE OF aluno_tipo.

aluno-matricula        = '100301'.
aluno-nome_aluno       = 'Vilson Silveira'.
aluno-codigo_graduacao = 'G01'.
APPEND aluno TO alunos.

aluno-matricula        = '100302'.
aluno-nome_aluno       = 'Carlos Barbosa'.
aluno-codigo_graduacao = 'G02'.
APPEND aluno TO alunos.

aluno-matricula        = '100303'.
aluno-nome_aluno       = 'Vinícius dos Santos'.
aluno-codigo_graduacao = 'G03'.
APPEND aluno TO alunos.

aluno-matricula        = '100304'.
aluno-nome_aluno       = 'Guilherme Duarte'.
aluno-codigo_graduacao = 'G04'.
APPEND aluno TO alunos.


TYPES: BEGIN OF graduacao_tipo,
         codigo_graduacao TYPE char3,
         nome_graduacao   TYPE char40,
       END OF graduacao_tipo.

DATA: graduacao  TYPE graduacao_tipo,
      graduacoes TYPE TABLE OF graduacao_tipo.

graduacao-codigo_graduacao = 'G01'.
graduacao-nome_graduacao   = 'Matemática'.
APPEND graduacao TO graduacoes.

graduacao-codigo_graduacao = 'G02'.
graduacao-nome_graduacao   = 'Engenharia'.
APPEND graduacao TO graduacoes.

graduacao-codigo_graduacao = 'G03'.
graduacao-nome_graduacao   = 'Ciência da Programação'.
APPEND graduacao TO graduacoes.

graduacao-codigo_graduacao = 'G04'.
graduacao-nome_graduacao   = 'Arquitetura'.
APPEND graduacao TO graduacoes.


TYPES: BEGIN OF disciplina_tipo,
         codigo_disciplina TYPE char3,
         nome_disciplina   TYPE char40,
       END OF disciplina_tipo.

DATA: disciplina  TYPE disciplina_tipo,
      disciplinas TYPE TABLE OF disciplina_tipo.

disciplina-codigo_disciplina = 'D01'.
disciplina-nome_disciplina   = 'Cálculo I'.
APPEND disciplina TO disciplinas.

disciplina-codigo_disciplina = 'D02'.
disciplina-nome_disciplina   = 'Desenho I'.
APPEND disciplina TO disciplinas.

disciplina-codigo_disciplina = 'D03'.
disciplina-nome_disciplina   = 'Programação I'.
APPEND disciplina TO disciplinas.

disciplina-codigo_disciplina = 'D04'.
disciplina-nome_disciplina   = 'Álgebra I'.
APPEND disciplina TO disciplinas.

disciplina-codigo_disciplina = 'D05'.
disciplina-nome_disciplina   = 'Introdução Arquitetura'.
APPEND disciplina TO disciplinas.

disciplina-codigo_disciplina = 'D06'.
disciplina-nome_disciplina   = 'Física I'.
APPEND disciplina TO disciplinas.


TYPES: BEGIN OF grad_disc_tipo,
         codigo_graduacao  TYPE char3,
         codigo_disciplina TYPE char3,
       END OF grad_disc_tipo.

DATA: grad_disc   TYPE grad_disc_tipo,
      grads_discs TYPE TABLE OF grad_disc_tipo.

grad_disc-codigo_graduacao  = 'G01'.
grad_disc-codigo_disciplina = 'D01'.
APPEND grad_disc TO grads_discs.

grad_disc-codigo_graduacao  = 'G01'.
grad_disc-codigo_disciplina = 'D04'.
APPEND grad_disc TO grads_discs.

grad_disc-codigo_graduacao  = 'G02'.
grad_disc-codigo_disciplina = 'D01'.
APPEND grad_disc TO grads_discs.

grad_disc-codigo_graduacao  = 'G02'.
grad_disc-codigo_disciplina = 'D06'.
APPEND grad_disc TO grads_discs.

grad_disc-codigo_graduacao  = 'G03'.
grad_disc-codigo_disciplina = 'D01'.
APPEND grad_disc TO grads_discs.

grad_disc-codigo_graduacao  = 'G03'.
grad_disc-codigo_disciplina = 'D03'.
APPEND grad_disc TO grads_discs.

grad_disc-codigo_graduacao  = 'G04'.
grad_disc-codigo_disciplina = 'D05'.
APPEND grad_disc TO grads_discs.

grad_disc-codigo_graduacao  = 'G04'.
grad_disc-codigo_disciplina = 'D02'.
APPEND grad_disc TO grads_discs.



*& EXERCICIO 19
*&---------------------------------------------------------------------*
*PARAMETERS: p_discip(10) TYPE c.
* Selecionar apenas um campo da tabela

*LOOP AT grads_discs INTO grad_disc WHERE codigo_disciplina = p_discip.
*  LOOP AT alunos INTO aluno WHERE codigo_graduacao = grad_disc-codigo_graduacao.
*    WRITE: / |{ aluno-matricula }, { aluno-nome_aluno } |.
*  ENDLOOP.
*ENDLOOP.


*& EXERCICIO 20
*&---------------------------------------------------------------------*
*SELECT-OPTIONS: s_grad FOR grad_disc-codigo_graduacao.


*DATA: nome_disc TYPE char40.
*
*LOOP AT grads_discs INTO grad_disc WHERE codigo_graduacao IN s_grad.
*
*
*  READ TABLE disciplinas INTO disciplina WITH KEY codigo_disciplina = grad_disc-codigo_disciplina.
*
*  IF sy-subrc = 0.
*    nome_disc = disciplina-nome_disciplina.
*  ELSE.
*    nome_disc = 'Disciplina não encontrada'.
*  ENDIF.
*
*  WRITE: / grad_disc-codigo_graduacao,
*           grad_disc-codigo_disciplina,
*           nome_disc.
*ENDLOOP.



FIELD-SYMBOLS <aluno_fs16> TYPE aluno_tipo.


*& EXERCICIO 17
*&---------------------------------------------------------------------*

*LOOP AT alunos ASSIGNING <aluno_fs16>.
*
*
*  READ TABLE graduacoes INTO graduacao  WITH KEY codigo_graduacao = <aluno_fs16>-codigo_graduacao.
*  IF sy-subrc <> 0.
*    CLEAR graduacao-nome_graduacao.
*  ENDIF.
*  WRITE: / |{ <aluno_fs16>-matricula }, { <aluno_fs16>-nome_aluno }, { graduacao-codigo_graduacao } ,{ graduacao-nome_graduacao } |.
*  LOOP AT grads_discs INTO grad_disc WHERE codigo_graduacao = graduacao-codigo_graduacao.
*
*    READ TABLE disciplinas INTO disciplina WITH KEY codigo_disciplina = grad_disc-codigo_disciplina.
*    IF sy-subrc <> 0.
*      CLEAR disciplina-nome_disciplina.
*    ENDIF.
**    WRITE: / | -{ disciplina-nome_disciplina } |.
*  ENDLOOP.
*
*ENDLOOP.

*& EXERCICIO 16
*&---------------------------------------------------------------------*

LOOP AT alunos ASSIGNING <aluno_fs16>.


  READ TABLE graduacoes INTO graduacao  WITH KEY codigo_graduacao = <aluno_fs16>-codigo_graduacao.
  IF sy-subrc <> 0.
    CLEAR graduacao-nome_graduacao.
  ENDIF.

  LOOP AT grads_discs INTO grad_disc WHERE codigo_graduacao = graduacao-codigo_graduacao.

    READ TABLE disciplinas INTO disciplina WITH KEY codigo_disciplina = grad_disc-codigo_disciplina.
    IF sy-subrc <> 0.
      CLEAR disciplina-nome_disciplina.
    ENDIF.
    WRITE: / |{ <aluno_fs16>-matricula }, { <aluno_fs16>-nome_aluno }, { graduacao-codigo_graduacao }, { graduacao-nome_graduacao }, { disciplina-nome_disciplina } |.
  ENDLOOP.

ENDLOOP.



*& EXERCICIO 14 - 15 - 18
*&---------------------------------------------------------------------*

TYPES: BEGIN OF veiculo_tipo,
         placa         TYPE char7,
         codigo_marca  TYPE char1,
         codigo_modelo TYPE numc1,
       END OF veiculo_tipo.

DATA: veiculo  TYPE veiculo_tipo,
      veiculos TYPE TABLE OF veiculo_tipo.

veiculo-placa = 'IXK4059'.
veiculo-codigo_marca = 'A'.
veiculo-codigo_modelo = '1'.
APPEND veiculo TO veiculos.

veiculo-placa = 'ISK3910'.
veiculo-codigo_marca = 'B'.
veiculo-codigo_modelo = '1'.
APPEND veiculo TO veiculos.

veiculo-placa = 'IHS0193'.
veiculo-codigo_marca = 'C'.
veiculo-codigo_modelo = '2'.
APPEND veiculo TO veiculos.

veiculo-placa = 'FHD1839'.
veiculo-codigo_marca = 'C'.
veiculo-codigo_modelo = '1'.
APPEND veiculo TO veiculos.

veiculo-placa = 'ITH0231'.
veiculo-codigo_marca = 'A'.
veiculo-codigo_modelo = '2'.
APPEND veiculo TO veiculos.

veiculo-placa = 'GHD4913'.
veiculo-codigo_marca = 'D'.
veiculo-codigo_modelo = '1'.
APPEND veiculo TO veiculos.

veiculo-placa = 'URY0031'.
veiculo-codigo_marca = 'B'.
veiculo-codigo_modelo = '1'.
APPEND veiculo TO veiculos.

veiculo-placa = 'HDU1394'.
veiculo-codigo_marca = 'B'.
veiculo-codigo_modelo = '2'.
APPEND veiculo TO veiculos.

veiculo-placa = 'GKD9983'.
veiculo-codigo_marca = 'A'.
veiculo-codigo_modelo = '2'.
APPEND veiculo TO veiculos.

TYPES: BEGIN OF marca_tipo,
         codigo_marca TYPE char1,
         nome_marca   TYPE char10,
       END OF marca_tipo.

DATA: marca  TYPE marca_tipo,
      marcas TYPE TABLE OF marca_tipo.

marca-codigo_marca = 'A'.
marca-nome_marca = 'CHEVROLET'.
APPEND marca TO marcas.

marca-codigo_marca = 'B'.
marca-nome_marca = 'VOLKSWAGEN'.
APPEND marca TO marcas.

marca-codigo_marca = 'C'.
marca-nome_marca = 'FIAT'.
APPEND marca TO marcas.

marca-codigo_marca = 'D'.
marca-nome_marca = 'FORD'.
APPEND marca TO marcas.

TYPES: BEGIN OF modelo_tipo,
         codigo_marca  TYPE char1,
         codigo_modelo TYPE numc1,
         nome_modelo   TYPE char10,
       END OF modelo_tipo.

DATA: modelo  TYPE modelo_tipo,
      modelos TYPE TABLE OF modelo_tipo.

modelo-codigo_marca = 'A'.
modelo-codigo_modelo = '1'.
modelo-nome_modelo = 'ONIX'.
APPEND modelo TO modelos.

modelo-codigo_marca = 'A'.
modelo-codigo_modelo = '2'.
modelo-nome_modelo = 'S-10'.
APPEND modelo TO modelos.

modelo-codigo_marca = 'B'.
modelo-codigo_modelo = '1'.
modelo-nome_modelo = 'SAVEIRO'.
APPEND modelo TO modelos.

modelo-codigo_marca = 'B'.
modelo-codigo_modelo = '2'.
modelo-nome_modelo = 'GOL'.
APPEND modelo TO modelos.

modelo-codigo_marca = 'C'.
modelo-codigo_modelo = '1'.
modelo-nome_modelo = 'TORO'.
APPEND modelo TO modelos.

modelo-codigo_marca = 'C'.
modelo-codigo_modelo = '2'.
modelo-nome_modelo = 'UNO'.
APPEND modelo TO modelos.

modelo-codigo_marca = 'D'.
modelo-codigo_modelo = '1'.
modelo-nome_modelo = 'KA'.
APPEND modelo TO modelos.

*& EXERCICIO 18
*&---------------------------------------------------------------------*

*PARAMETERS: p_placa(10) TYPE c.
*"Selecionar apenas um campo da tabela
*
*TRY.
*    veiculo = veiculos[ placa = p_placa ].
*
*    READ TABLE marcas INTO marca  WITH KEY codigo_marca = veiculo-codigo_marca.
*    IF sy-subrc <> 0.
*      CLEAR marca-nome_marca.
*    ENDIF.
*
*    READ TABLE modelos INTO modelo  WITH KEY codigo_marca = veiculo-codigo_marca
*                                              codigo_modelo = veiculo-codigo_modelo.
*    IF sy-subrc <> 0.
*      CLEAR modelo-nome_modelo.
*    ENDIF.
*
*    WRITE: / | { veiculo-placa }, { marca-nome_marca }, { modelo-nome_modelo } |.
*  CATCH cx_sy_itab_line_not_found.
*    MESSAGE 'NAO ENCONTRADO NENHUMA PLACA' TYPE 'E'.
*ENDTRY.
*
** SE QUISER USAR READ TABLE NAO PODEMOS USAR TRY CATCH
*READ TABLE marcas INTO marca WITH KEY codigo_marca = p_placa.
*
*IF sy-subrc <> 0.
*  MESSAGE 'NAO ENCONTRADO NENHUMA PLACA' TYPE 'E'.
*ENDIF.
*

FIELD-SYMBOLS <carros_fs13> TYPE veiculo_tipo.


LOOP AT veiculos ASSIGNING <carros_fs13>.

  READ TABLE marcas INTO marca  WITH KEY codigo_marca = <carros_fs13>-codigo_marca.
  IF sy-subrc <> 0.
    CLEAR marca-nome_marca.
  ENDIF.

  READ TABLE modelos INTO modelo  WITH KEY codigo_marca = <carros_fs13>-codigo_marca
                                            codigo_modelo = <carros_fs13>-codigo_modelo.
  IF sy-subrc <> 0.
    CLEAR modelo-nome_modelo.
  ENDIF.

*  WRITE: / | { <carros_fs13>-placa }, { marca-nome_marca }, { modelo-nome_modelo } |.
ENDLOOP.

*& EXERCICIO 15
*&---------------------------------------------------------------------*

DATA(combinacoes) = veiculos.

SORT combinacoes BY codigo_marca codigo_modelo.

DELETE ADJACENT DUPLICATES FROM combinacoes COMPARING codigo_marca codigo_modelo.

LOOP AT combinacoes INTO DATA(combinacao).
  DATA(contador) = 0.
  LOOP AT veiculos INTO veiculo WHERE codigo_marca = combinacao-codigo_marca
                                      AND codigo_modelo = combinacao-codigo_modelo.
    contador = contador + 1.


    READ TABLE marcas INTO marca  WITH KEY codigo_marca = combinacao-codigo_marca.
    IF sy-subrc <> 0.
      CLEAR marca-nome_marca.
    ENDIF.

    READ TABLE modelos INTO modelo  WITH KEY codigo_marca = combinacao-codigo_marca
                                              codigo_modelo = combinacao-codigo_modelo.
    IF sy-subrc <> 0.
      CLEAR modelo-nome_modelo.
    ENDIF.

  ENDLOOP.
**  WRITE: / | { marca-nome_marca }, { modelo-nome_modelo }, { contador }X |.
ENDLOOP.


*& EXERCICIO 13
*&---------------------------------------------------------------------*

TYPES: BEGIN OF vendas13_tipo,
         nr_venda        TYPE numc4,
         codigo_produto  TYPE char4,
         qtd_venda       TYPE int2,
         codigo_vendedor TYPE char1,
         vendedor        TYPE char30,
         total           TYPE p LENGTH 10 DECIMALS 2,
         nome_produto    TYPE char10,
       END OF vendas13_tipo.

TYPES: BEGIN OF produtos13_tipo,
         preco             TYPE p LENGTH 10 DECIMALS 2,
         cod_produto       TYPE char4,
         descricao_produto TYPE char10,
       END OF produtos13_tipo.

TYPES: BEGIN OF vendedor13_tipo,
         codigo_vendedor TYPE char1,
         nome            TYPE char40,
       END OF vendedor13_tipo.

DATA: venda13      TYPE vendas13_tipo,
      vendas13     TYPE TABLE OF vendas13_tipo,
      produto13    TYPE produtos13_tipo,
      produtos13   TYPE TABLE OF produtos13_tipo,
      vendedor13   TYPE vendedor13_tipo,
      vendedores13 TYPE TABLE OF vendedor13_tipo.


CLEAR venda13.
venda13-nr_venda        = '1001'.
venda13-codigo_produto = 'C-01'.
venda13-qtd_venda      = 4.
venda13-codigo_vendedor = 'A'.
APPEND venda13 TO vendas13.

CLEAR venda13.
venda13-nr_venda        = '1002'.
venda13-codigo_produto = 'C-02'.
venda13-qtd_venda      = 3.
venda13-codigo_vendedor = 'B'.
APPEND venda13 TO vendas13.

CLEAR venda13.
venda13-nr_venda        = '1003'.
venda13-codigo_produto = 'C-03'.
venda13-qtd_venda      = 6.
venda13-codigo_vendedor = 'A'.
APPEND venda13 TO vendas13.

CLEAR venda13.
venda13-nr_venda        = '1004'.
venda13-codigo_produto = 'C-01'.
venda13-qtd_venda      = 5.
venda13-codigo_vendedor = 'C'.
APPEND venda13 TO vendas13.

CLEAR venda13.
venda13-nr_venda        = '1005'.
venda13-codigo_produto = 'C-02'.
venda13-qtd_venda      = 4.
venda13-codigo_vendedor = 'D'.
APPEND venda13 TO vendas13.

CLEAR venda13.
venda13-nr_venda        = '1006'.
venda13-codigo_produto = 'C-03'.
venda13-qtd_venda      = 1.
venda13-codigo_vendedor = 'A'.
APPEND venda13 TO vendas13.

CLEAR venda13.
venda13-nr_venda        = '1007'.
venda13-codigo_produto = 'C-02'.
venda13-qtd_venda      = 4.
venda13-codigo_vendedor = 'C'.
APPEND venda13 TO vendas13.

CLEAR venda13.
venda13-nr_venda        = '1008'.
venda13-codigo_produto = 'C-01'.
venda13-qtd_venda      = 5.
venda13-codigo_vendedor = 'D'.
APPEND venda13 TO vendas13.


CLEAR produto13.
produto13-cod_produto        = 'C-01'.
produto13-descricao_produto = 'IPHONE XR'.
produto13-preco      = 3000.
APPEND produto13 TO produtos13.

CLEAR produto13.
produto13-cod_produto        = 'C-02'.
produto13-descricao_produto = 'IPHONE 11'.
produto13-preco      = 4400.
APPEND produto13 TO produtos13.

CLEAR produto13.
produto13-cod_produto        = 'C-03'.
produto13-descricao_produto = 'IPHONE 13 PRO MAX'.
produto13-preco      = 7800.
APPEND produto13 TO produtos13.

CLEAR vendedor13.
vendedor13-codigo_vendedor        = 'A'.
vendedor13-nome = 'Marcos Silva'.
APPEND vendedor13 TO vendedores13.

CLEAR vendedor13.
vendedor13-codigo_vendedor        = 'B'.
vendedor13-nome = 'João Alberto'.
APPEND vendedor13 TO vendedores13.

CLEAR vendedor13.
vendedor13-codigo_vendedor        = 'C'.
vendedor13-nome = 'Mario Miranda'.
APPEND vendedor13 TO vendedores13.

CLEAR vendedor13.
vendedor13-codigo_vendedor        = 'D'.
vendedor13-nome = 'Luiz Carlos'.
APPEND vendedor13 TO vendedores13.


FIELD-SYMBOLS <venda_fs13> TYPE vendas13_tipo.

LOOP AT vendas13 ASSIGNING <venda_fs13>.

  READ TABLE produtos13 INTO produto13 WITH KEY cod_produto = <venda_fs13>-codigo_produto.
  IF sy-subrc = 0.
    <venda_fs13>-nome_produto = produto13-descricao_produto.
    <venda_fs13>-total = <venda_fs13>-qtd_venda * produto13-preco.
  ENDIF.

  READ TABLE vendedores13 INTO vendedor13 WITH KEY codigo_vendedor = <venda_fs13>-codigo_vendedor.
  IF sy-subrc = 0.
    <venda_fs13>-vendedor = vendedor13-nome.
  ENDIF.

ENDLOOP.


LOOP AT vendas13 INTO venda13.
*  WRITE: / | { venda13-nr_venda }, { venda13-codigo_produto }, { venda13-nome_produto }, { venda13-qtd_venda }, { venda13-total }, { venda13-vendedor } |.
ENDLOOP.














*& EXERCICIO 12
*&---------------------------------------------------------------------*
TYPES: BEGIN OF vendax_tipo,
         nr_venda       TYPE numc4,
         codigo_produto TYPE char1,
         valor_venda    TYPE p LENGTH 10 DECIMALS 0,
         moeda          TYPE char3,
         descricao      TYPE char10,
       END OF vendax_tipo.

DATA: venda  TYPE vendax_tipo,
      vendas TYPE TABLE OF vendax_tipo.

venda-nr_venda = '1001'.
venda-codigo_produto = 'A'.
venda-valor_venda = '3000'.
venda-moeda = 'BRL'.
APPEND venda TO vendas.

venda-nr_venda = '1002'.
venda-codigo_produto = 'B'.
venda-valor_venda = '4400'.
venda-moeda = 'BRL'.
APPEND venda TO vendas.

venda-nr_venda = '1003'.
venda-codigo_produto = 'C'.
venda-valor_venda = '7800'.
venda-moeda = 'BRL'.
APPEND venda TO vendas.

venda-nr_venda = '1004'.
venda-codigo_produto = 'A'.
venda-valor_venda = '3000'.
venda-moeda = 'BRL'.
APPEND venda TO vendas.

venda-nr_venda = '1005'.
venda-codigo_produto = 'B'.
venda-valor_venda = '4400'.
venda-moeda = 'BRL'.
APPEND venda TO vendas.

venda-nr_venda = '1006'.
venda-codigo_produto = 'C'.
venda-valor_venda = '7800'.
venda-moeda = 'BRL'.
APPEND venda TO vendas.

venda-nr_venda = '1007'.
venda-codigo_produto = 'B'.
venda-valor_venda = '4400'.
venda-moeda = 'BRL'.
APPEND venda TO vendas.

venda-nr_venda = '1008'.
venda-codigo_produto = 'A'.
venda-valor_venda = '3000'.
venda-moeda = 'BRL'.
APPEND venda TO vendas.


TYPES: BEGIN OF produdosx_tipo,
         descricao_produto TYPE char20,
         cod_produto       TYPE char1,
       END OF produdosx_tipo.

DATA: produtox  TYPE produdosx_tipo,
      produtosx TYPE TABLE OF produdosx_tipo.

produtox-descricao_produto = 'IPHONE XR'.
produtox-cod_produto = 'A'.
APPEND produtox TO produtosx.

produtox-descricao_produto = 'IPHONE 11'.
produtox-cod_produto = 'B'.
APPEND produtox TO produtosx.

produtox-descricao_produto = 'IPHONE 13 PRO MAX'.
produtox-cod_produto = 'C'.
APPEND produtox TO produtosx.

FIELD-SYMBOLS <venda_fs2> TYPE vendax_tipo.

LOOP AT vendas ASSIGNING <venda_fs2>.

  READ TABLE produtosx INTO produtox WITH KEY cod_produto = <venda_fs2>-codigo_produto.
  IF sy-subrc = 0.
    <venda_fs2>-descricao = produtox-descricao_produto.
  ENDIF.

ENDLOOP.


**cl_demo_output=>display_data( vendas ).




*LOOP AT produtos_unicos ASSIGNING FIELD-SYMBOL(<produto_unico>).
*
*  LOOP AT vendas INTO venda WHERE produto = <produto_unico>-produto.
*
*    <produto_unico>-valor_x = <produto_unico>-valor_x + venda-valor_venda.
*
*  ENDLOOP.
***  WRITE: / | { <produto_unico>-produto }, { <produto_unico>-valor_x }|.
*ENDLOOP.

*& EXERCICIO 10 e 11
*&---------------------------------------------------------------------*

*TYPES: BEGIN OF venda_tipo,
*         nr_venda    TYPE numc4,
*         produto     TYPE char20,
*         valor_venda TYPE p LENGTH 10 DECIMALS 0,
*         moeda       TYPE char3,
*       END OF venda_tipo.
*
*DATA: venda  TYPE venda_tipo,
*      vendas TYPE TABLE OF venda_tipo.
*
*venda-nr_venda = '1001'.
*venda-produto = 'IPHONE XR'.
*venda-valor_venda = '3000'.
*venda-moeda = 'BRL'.
*APPEND venda TO vendas.
*
*venda-nr_venda = '1002'.
*venda-produto = 'IPHONE 11'.
*venda-valor_venda = '4400'.
*venda-moeda = 'BRL'.
*APPEND venda TO vendas.
*
*venda-nr_venda = '1003'.
*venda-produto = 'IPHONE 13 PRO MAX'.
*venda-valor_venda = '7800'.
*venda-moeda = 'BRL'.
*APPEND venda TO vendas.
*
*venda-nr_venda = '1004'.
*venda-produto = 'IPHONE XR'.
*venda-valor_venda = '3000'.
*venda-moeda = 'BRL'.
*APPEND venda TO vendas.
*
*venda-nr_venda = '1005'.
*venda-produto = 'IPHONE 11'.
*venda-valor_venda = '4400'.
*venda-moeda = 'BRL'.
*APPEND venda TO vendas.
*
*venda-nr_venda = '1006'.
*venda-produto = 'IPHONE 13 PRO MAX'.
*venda-valor_venda = '7800'.
*venda-moeda = 'BRL'.
*APPEND venda TO vendas.
*
*venda-nr_venda = '1007'.
*venda-produto = 'IPHONE 11'.
*venda-valor_venda = '4400'.
*venda-moeda = 'BRL'.
*APPEND venda TO vendas.
*
*venda-nr_venda = '1008'.
*venda-produto = 'IPHONE XR'.
*venda-valor_venda = '3000'.
*venda-moeda = 'BRL'.
*APPEND venda TO vendas.
*
*TYPES: BEGIN OF produto_unico_tipo,
*         produto TYPE char20,
*         valor_x TYPE p LENGTH 10 DECIMALS 0,
*       END OF produto_unico_tipo.
*
*DATA: produto_unico   TYPE produto_unico_tipo,
*      produtos_unicos TYPE TABLE OF produto_unico_tipo.
*
*produto_unico-produto = 'IPHONE XR'.
*APPEND produto_unico TO produtos_unicos.
*
*produto_unico-produto = 'IPHONE 11'.
*APPEND produto_unico TO produtos_unicos.
*
*produto_unico-produto = 'IPHONE 13 PRO MAX'.
*APPEND produto_unico TO produtos_unicos.
*
*FIELD-SYMBOLS <venda_fs> TYPE venda_tipo.
*
*LOOP AT vendas ASSIGNING <venda_fs>.
*
*  <venda_fs>-moeda = 'USD'.
***  WRITE: / | { <produto_unico>-produto }, { <produto_unico>-valor_x }|.
*ENDLOOP.
*
*cl_demo_output=>display_data( vendas ).

*LOOP AT produtos_unicos ASSIGNING FIELD-SYMBOL(<produto_unico>).
*
*  LOOP AT vendas INTO venda WHERE produto = <produto_unico>-produto.
*
*    <produto_unico>-valor_x = <produto_unico>-valor_x + venda-valor_venda.
*
*  ENDLOOP.
***  WRITE: / | { <produto_unico>-produto }, { <produto_unico>-valor_x }|.
*ENDLOOP.


*&EXERCICIO 008 && EXERCICIO 009
*&---------------------------------------------------------------------*
TYPES: BEGIN OF produto_tipo,
         produto     TYPE char30,
         origem      TYPE char10,
         quantidade  TYPE i,
         unidade     TYPE ekpo-meins,
         preco_unit  TYPE p LENGTH 10 DECIMALS 2,
         preco_total TYPE p LENGTH 10 DECIMALS 2,
         moeda       TYPE char3,
       END OF produto_tipo.

DATA: produto              TYPE produto_tipo,
      produtos             TYPE TABLE OF produto_tipo,
      valor_total_produtos TYPE p LENGTH 10 DECIMALS 2.

produto-produto = 'CALÇA JEANS'.
produto-origem = 'NACIONAL'.
produto-quantidade = 100.
produto-unidade = 'ST'.
produto-preco_unit = '79.00'.
produto-preco_total = '7900.00'.
produto-moeda = 'BRL'.
APPEND produto TO produtos.

produto-produto = 'CALÇA MOLETOM'.
produto-origem = 'IMPORTADO'.
produto-quantidade = 340.
produto-unidade = 'ST'.
produto-preco_unit = '56.00'.
produto-preco_total = '19040.00'.
produto-moeda = 'BRL'.
APPEND produto TO produtos.

produto-produto = 'CAMISA BRANCA'.
produto-origem = 'IMPORTADO'.
produto-quantidade = 1000.
produto-unidade = 'ST'.
produto-preco_unit = '123.00'.
produto-preco_total = '123000.00'.
produto-moeda = 'BRL'.
APPEND produto TO produtos.

produto-produto = 'BONÉ ABA RETA'.
produto-origem = 'NACIONAL'.
produto-quantidade = 302.
produto-unidade = 'ST'.
produto-preco_unit = '45.00'.
produto-preco_total = '13590.00'.
produto-moeda = 'BRL'.
APPEND produto TO produtos.

produto-produto = 'CASACO CORTA VENTO'.
produto-origem = 'NACIONAL'.
produto-quantidade = 200.
produto-unidade = 'ST'.
produto-preco_unit = '250.00'.
produto-preco_total = '50000.00'.
produto-moeda = 'BRL'.
APPEND produto TO produtos.

LOOP AT produtos INTO produto.
*  WRITE: / |{ produto-produto }, { produto-origem }, { produto-quantidade }, { produto-unidade }, { produto-preco_unit }, { produto-preco_total }, { produto-moeda } |.
ENDLOOP.



*LOOP AT produtos INTO produto.
*  valor_total_produtos = valor_total_produtos + produto-preco_total.
*ENDLOOP.

**WRITE: / |VALOR TOTAL DOS PRODUTOS EM ESTOQUE { valor_total_produtos }|.




*&EXERCICIO 007
*&---------------------------------------------------------------------*
**declaracao
*TYPES: BEGIN OF tipo_veiculo,
*         marca     TYPE char10,
*         modelo    TYPE char30,
*         estoque   TYPE int4,
*         preco     TYPE p LENGTH 10 DECIMALS 2,
*         moeda     TYPE ekko-waers,
*         ano       TYPE int4,
*         ult_venda TYPE dats,
*       END OF tipo_veiculo.
*
*
*DATA: veiculos TYPE TABLE OF tipo_veiculo,
*      veiculo  TYPE tipo_veiculo.
*
*veiculo = VALUE #( marca = 'CHEVROLET'
*modelo = 'ONIX TURBO'
*estoque = 27
*preco = 67900
*moeda = 'BRL'
*ano = '2019'
*ult_venda = '20220712'
*).
*
*APPEND veiculo TO veiculos.
*CLEAR veiculo.
*
*veiculo = VALUE #( marca = 'HYUNDAI'
*modelo = 'HB20 S'
*estoque = 27
*preco = 67900
*moeda = 'BRL'
*ano = '2019'
*ult_venda = '20220609'
*).
*
*APPEND veiculo TO veiculos.
*CLEAR veiculo.
*
*veiculo = VALUE #( marca = 'FORD'
*modelo = 'FOCUS SEDAN'
*estoque = 27
*preco = 67900
*moeda = 'BRL'
*ano = '2019'
*ult_venda = '20220629'
*).
*
*APPEND veiculo TO veiculos.
*CLEAR veiculo.
*
*veiculo = VALUE #( marca = 'FORD'
*modelo = 'CIVIC SI'
*estoque = 27
*preco = 67900
*moeda = 'BRL'
*ano = '2019'
*ult_venda = '20210712'
*).
*
*APPEND veiculo TO veiculos.
*CLEAR veiculo.
*
*veiculo = VALUE #( marca = 'HONDA'
*modelo = 'HRV TURBO'
*estoque = 27
*preco = 67900
*moeda = 'BRL'
*ano = '2019'
*ult_venda = ''
*).
*
*APPEND veiculo TO veiculos.
*CLEAR veiculo.
*
*veiculo = VALUE #( marca = 'HONDA'
*modelo = 'HILUX SRX'
*estoque = 27
*preco = 67900
*moeda = 'BRL'
*ano = '2019'
*ult_venda = '20220410'
*).
*
*APPEND veiculo TO veiculos.
*CLEAR veiculo.
*
*veiculo = VALUE #( marca = 'TOYOTA'
*modelo = 'EQUINOX'
*estoque = 27
*preco = 67900
*moeda = 'BRL'
*ano = '2019'
*ult_venda = '20220719'
*).
*
*APPEND veiculo TO veiculos.
*CLEAR veiculo.
*
*APPEND veiculo TO veiculos.
*CLEAR veiculo.
*
*veiculo = VALUE #( marca = 'CHEVROLET'
*modelo = 'ONIX TURBO'
*estoque = 27
*preco = 67900
*moeda = 'BRL'
*ano = '2019'
*ult_venda = '20210719'
*).
*
*APPEND veiculo TO veiculos.
*CLEAR veiculo.
*
*LOOP AT veiculos INTO veiculo WHERE ult_venda CS '2022'.
** WRITE: / veiculo-ult_venda.
*
*ENDLOOP.





*&EXERCICIO 006
*&---------------------------------------------------------------------*
**declaracao
TYPES: BEGIN OF zimobiliaria,
         nr_apartamento TYPE char3,
         nr_dormitorio  TYPE char2,
       END OF zimobiliaria.


DATA: imobiliarias TYPE TABLE OF zimobiliaria,
      imobiliaria  TYPE zimobiliaria.

DO 4 TIMES.
  DATA(imobiliariaV1) = VALUE zimobiliaria( nr_apartamento = sy-index &&'01'
  nr_dormitorio = sy-index ).

  DATA(imobiliariaV2) = VALUE zimobiliaria( nr_apartamento = sy-index &&'02'
    nr_dormitorio = sy-index ).

  APPEND imobiliariaV1 TO imobiliarias.
  APPEND imobiliariaV2 TO imobiliarias.
ENDDO.

LOOP AT imobiliarias INTO imobiliaria.
*WRITE: / imobiliaria-nr_apartamento, imobiliaria-nr_dormitorio.
ENDLOOP.


*cl_demo_output=>display_data( imobiliarias ).




*&EXERCICIO 005
*&---------------------------------------------------------------------*

TYPES: BEGIN OF zinfopessoal,
         nome              TYPE char60,
         dataNascimento    TYPE dats,
         horarioNascimento TYPE tims,
         peso              TYPE p LENGTH 10 DECIMALS 3,
         salario           TYPE  p LENGTH 8 DECIMALS 2,
         matricula         TYPE numc4,
       END OF zinfopessoal.

DATA(informacoes_pessoais) = VALUE zinfopessoal( nome = 'Maria'
peso = '78.00'
matricula = '64' ).


*cl_demo_output=>display_data( informacoes_pessoais ).



*&EXERCICIO 004
*&---------------------------------------------------------------------*

TYPES: BEGIN OF tipoFlight2,
         carrid    TYPE sflight-carrid,
         connid    TYPE sflight-connid,
         fldate    TYPE sflight-fldate,
         price     TYPE sflight-price,
         planetype TYPE sflight-planetype,
       END OF tipoFlight2.

DATA flightObj2 TYPE tipoflight2.

DATA flightTable TYPE TABLE OF tipoflight2.

flightObj2-carrid = 'TAM'.
flightObj2-connid = '62'.
flightObj2-fldate = '20251225'.
flightObj2-planetype = 'COMERCIAL'.
flightObj2-price = '5000.00'.

DO 5 TIMES.
  APPEND flightobj2 TO flighttable.
ENDDO.

*cl_demo_output=>display_data( flighttable ).



*&EXERCICIO 003
*&---------------------------------------------------------------------*

TYPES: BEGIN OF tipoFlight,
         carrid    TYPE sflight-carrid,
         connid    TYPE sflight-connid,
         fldate    TYPE sflight-fldate,
         price     TYPE sflight-price,
         planetype TYPE sflight-planetype,
       END OF tipoFlight.

DATA flightObj TYPE tipoflight.

flightobj-carrid = 'TAM'.
flightobj-connid = '62'.
flightobj-fldate = '20251225'.
flightobj-planetype = 'COMERCIAL'.
flightobj-price = '5000.00'.

*cl_demo_output=>display_data( flightobj ).

*&EXERCICIO 002
*&---------------------------------------------------------------------*

TYPES: BEGIN OF tipoPessoa,
         nome              TYPE char60,
         dataNascimento    TYPE dats,
         horarioNascimento TYPE tims,
         peso              TYPE p LENGTH 10 DECIMALS 3,
         salario           TYPE  p LENGTH 8 DECIMALS 2,
         matricula         TYPE numc4,
       END OF tipoPessoa.

DATA  pessoaTeste TYPE tipoPessoa.

pessoaTeste-nome = 'GABRIEL'.
pessoaTeste-datanascimento = '19990716'.
pessoaTeste-horarionascimento = '150200'.
pessoaTeste-peso = 88.
pessoaTeste-salario = '4000.00'.
pessoaTeste-matricula = 555.

*cl_demo_output=>display_data( pessoaTeste ).




*&EXERCICIO 001
*&---------------------------------------------------------------------*

DATA: nome              TYPE char60,
      dataNascimento    TYPE dats,
      horarioNascimento TYPE tims,
      peso              TYPE p LENGTH 10 DECIMALS 3,
      salario           TYPE  p LENGTH 8 DECIMALS 2,
      matricula         TYPE numc4.

nome = 'GABRIEL'.
datanascimento = '19990716'.
horarionascimento = '150200'.
peso = 88.
salario = '4000.00'.
matricula = 555.
**























*&ESTRUTURA
*&---------------------------------------------------------------------*

*cl_demo_output=>display( pessoas ).

*&  CALCULADORA
*&---------------------------------------------------------------------*
*DATA resultado TYPE int4.
*
*PARAMETERS: valor_1 TYPE int4,
*            valor_2 TYPE int4.
*
*PARAMETERS: som  RADIOBUTTON GROUP g1,
*            sub  RADIOBUTTON GROUP g1,
*            mult RADIOBUTTON GROUP g1,
*            div  RADIOBUTTON GROUP g1,
*            sel  RADIOBUTTON GROUP g1.
*
*
*CASE 'X'.
*  WHEN som.
*    resultado = valor_1 + valor_2.
*    WRITE resultado.
*  WHEN sub.
*    resultado = valor_1 - valor_2.
*    WRITE resultado.
*  WHEN mult.
*    resultado = valor_1 * valor_2.
*    WRITE resultado.
*  WHEN div.
*
*    TRY.
*        resultado = valor_1 / valor_2.
*        WRITE resultado.
*      CATCH cx_sy_zerodivide.
*        MESSAGE i000(zcurso) WITH 'erro ao dividir por zero'.
*    ENDTRY.
*
*  WHEN OTHERS.
*    SELECT brand FROM zgflores_vehicle INTO TABLE @DATA(veiculos).
*
*    BREAK-POINT.
*ENDCASE.