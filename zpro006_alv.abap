*&---------------------------------------------------------------------*
*& Report ZPRO006
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zpro006.

TABLES: ekko, ekpo.

DATA: alv_grid TYPE REF TO cl_gui_alv_grid.

DATA: result TYPE TABLE OF zgflores_alv1 WITH EMPTY KEY.

DATA: lt_ekko TYPE STANDARD TABLE OF ekko,
      lt_ekpo TYPE STANDARD TABLE OF ekpo,
      lt_makt TYPE STANDARD TABLE OF makt,
      lt_lfa1 TYPE STANDARD TABLE OF lfa1.

DATA ok_code TYPE sy-ucomm.

SELECTION-SCREEN: BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.

  SELECT-OPTIONS: s_emp FOR ekko-bukrs NO INTERVALS,
                  s_forn FOR ekko-lifnr NO INTERVALS,
                  s_dt_cri FOR ekko-aedat,
                  s_mat FOR ekpo-matnr.
SELECTION-SCREEN: END OF BLOCK b1.


INITIALIZATION.
  FREE MEMORY.

START-OF-SELECTION.
  PERFORM get_data.
  PERFORM build_data.

  IF result IS INITIAL.

  ELSE.
    CALL SCREEN 9001.
  ENDIF.
*&---------------------------------------------------------------------*
*& Form get_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data .

  CLEAR: lt_ekko, lt_makt, lt_lfa1.

**Busca pedidos de acordo com parametros
  SELECT * INTO TABLE lt_ekko FROM ekko WHERE bukrs IN s_emp
                                          AND lifnr IN s_forn
                                          AND aedat IN s_dt_cri.

  IF sy-subrc = 0.
**busca Itens de cada pedido encontrado
    SELECT * INTO TABLE lt_ekpo  FROM ekpo FOR ALL ENTRIES IN  lt_ekko WHERE ebeln = lt_ekko-ebeln
                                                                         AND matnr IN s_mat.
    IF sy-subrc = 0.
** Busca descricao dos materiais comprados
      SELECT * INTO TABLE lt_makt  FROM makt FOR ALL ENTRIES IN  lt_ekpo WHERE matnr = lt_ekpo-matnr.

      SELECT * INTO TABLE lt_lfa1  FROM lfa1 FOR ALL ENTRIES IN  lt_ekko WHERE lifnr = lt_ekko-lifnr.

    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form build_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM build_data .


  LOOP AT lt_ekko INTO DATA(ls_ekko).
    TRY.
        DATA(ls_lfa1) = lt_lfa1[ lifnr = ls_ekko-lifnr ].
      CATCH cx_sy_itab_line_not_found.
        CLEAR ls_lfa1.
    ENDTRY.


    LOOP AT lt_ekpo INTO DATA(ls_ekpo) WHERE ebeln = ls_ekko-ebeln.

      TRY.
          DATA(ls_makt) = lt_makt[ matnr = ls_ekpo-matnr ].
        CATCH cx_sy_itab_line_not_found.
          CLEAR ls_makt.
      ENDTRY.


      DATA(workarea) = VALUE zgflores_alv1(
      nr_doc_compras  = ls_ekko-ebeln
      dt_criacao      = ls_ekko-aedat
      fornecedor      = ls_ekko-lifnr
      nome_fornecedor = ls_lfa1-name1
      empresa         = ls_ekko-bukrs
      item            = ls_ekpo-ebelp
      material        = ls_ekpo-matnr
      txt_material    = ls_makt-maktx
      quant           = ls_ekpo-menge
      unid_medida     = ls_ekpo-meins
      preco_uni       = ls_ekpo-netpr
      preco_total     = ls_ekpo-netpr * ls_ekpo-menge
      moeda           = ls_ekko-waers
      ).
      APPEND workarea TO result.


    ENDLOOP.



  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Module STATUS_9001 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_9001 OUTPUT.
  SET PF-STATUS 'PF9001'.
  SET TITLEBAR 'T9001'.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9001  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_9001 INPUT.
  CASE ok_code.
    WHEN 'BACK'.
      CLEAR: ok_code.
      LEAVE TO SCREEN 0.
    WHEN 'REFRESH'.
      CLEAR: ok_code.
      CLEAR: result.
      PERFORM get_data.
      PERFORM build_data.
      IF alv_grid IS BOUND.
        alv_grid->refresh_table_display( ).
      ENDIF.
    WHEN 'PRINT'.
      CLEAR: ok_code.
      PERFORM print_label.
    WHEN 'PRINT2'.
      CLEAR: ok_code.
      PERFORM print_label2.
    WHEN 'PRINT3'.
      CLEAR: ok_code.
      PERFORM print_label3.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module BUILD_ALV OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE build_alv OUTPUT.
  IF alv_grid IS INITIAL.
    alv_grid = NEW #( i_parent = cl_gui_container=>default_screen ).

    DATA(layout) = VALUE lvc_s_layo(
                  cwidth_opt = abap_true
                  zebra      = abap_true
                  sel_mode   = 'A' ).

    CALL METHOD alv_grid->set_table_for_first_display
      EXPORTING
        i_structure_name              = 'ZGFLORES_ALV1'
        is_layout                     = layout
      CHANGING
        it_outtab                     = result
      EXCEPTIONS
        invalid_parameter_combination = 1
        program_error                 = 2
        too_many_lines                = 3
        OTHERS                        = 4.


  ELSE.
    alv_grid->refresh_table_display( ).
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Form print_label
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM print_label .
  DATA: label_data    TYPE TABLE OF zgflores_alv1,
        function_name TYPE rs38l_fnam,
        form_name     TYPE tdsfname VALUE 'ZPRSF006'.

  DATA: user_print_parameter TYPE usr01.

  DATA: job_info TYPE ssfcrescl.

  alv_grid->get_selected_rows( IMPORTING et_index_rows = DATA(rows) ).

  LOOP AT rows INTO DATA(row).
    TRY.
        DATA(line) = result[ row-index ].
        APPEND line TO label_data.
      CATCH cx_sy_itab_line_not_found.
        CONTINUE.
    ENDTRY.
  ENDLOOP.

  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      formname = form_name
    IMPORTING
      fm_name  = function_name.


  CALL FUNCTION 'GET_PRINT_PARAM'
    EXPORTING
      i_bname = sy-uname
    IMPORTING
      e_usr01 = user_print_parameter.

  DATA(composer_parameter) = VALUE ssfcompop(
      tdnewid  = abap_true
      tdarmod  = '1'
      tdimmed  = abap_true
      tdfinal  = abap_true
      tddest   = COND #( WHEN user_print_parameter-spld IS NOT INITIAL
                         THEN user_print_parameter-spld )
      tdnoprint = space ).

  DATA(control_parameter) = VALUE ssfctrlop(
      no_dialog = abap_true
      preview   = abap_true
      langu     = sy-langu
      getotf    = abap_true ).

  IF sy-subrc = 0.


    CALL FUNCTION function_name
      EXPORTING
        control_parameters = control_parameter
        output_options     = composer_parameter
        user_settings      = space
        label_data         = label_data
      IMPORTING
        job_output_info    = job_info
      EXCEPTIONS
        formatting_error   = 1
        internal_error     = 2
        send_error         = 3
        user_canceled      = 4
        OTHERS             = 5.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      RETURN.
    ENDIF.

    "Se não tiver OTF, não tem como gerar PDF preview
    IF job_info-otfdata IS INITIAL.
      MESSAGE 'SmartForm não retornou OTF (verifique GETOTF = X).' TYPE 'S' DISPLAY LIKE 'E'.
      RETURN.
    ENDIF.

    CALL FUNCTION 'SSFCOMP_PDF_PREVIEW'
      EXPORTING
        i_otf                    = job_info-otfdata
      EXCEPTIONS
        convert_otf_to_pdf_error = 1
        cntl_error               = 2
        OTHERS                   = 3.

    IF sy-subrc <> 0.
      MESSAGE 'Erro ao gerar pré-visualização em PDF.' TYPE 'S' DISPLAY LIKE 'E'.
    ENDIF.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form print_label2
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM print_label2 .
  DATA: label_data    TYPE TABLE OF zgflores_alv1,
        function_name TYPE rs38l_fnam,
        form_name     TYPE tdsfname VALUE 'ZPRSF007'.

  DATA: user_print_parameter TYPE usr01.

  DATA: job_info TYPE ssfcrescl.

  alv_grid->get_selected_rows( IMPORTING et_index_rows = DATA(rows) ).

  LOOP AT rows INTO DATA(row).
    TRY.
        DATA(line) = result[ row-index ].
        APPEND line TO label_data.
      CATCH cx_sy_itab_line_not_found.
        CONTINUE.
    ENDTRY.
  ENDLOOP.

  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      formname = form_name
    IMPORTING
      fm_name  = function_name.


  CALL FUNCTION 'GET_PRINT_PARAM'
    EXPORTING
      i_bname = sy-uname
    IMPORTING
      e_usr01 = user_print_parameter.

  DATA(composer_parameter) = VALUE ssfcompop(
      tdnewid  = abap_true
      tdarmod  = '1'
      tdimmed  = abap_true
      tdfinal  = abap_true
      tddest   = COND #( WHEN user_print_parameter-spld IS NOT INITIAL
                         THEN user_print_parameter-spld )
      tdnoprint = space ).

  DATA(control_parameter) = VALUE ssfctrlop(
      no_dialog = abap_true
      preview   = abap_true
      langu     = sy-langu
      getotf    = abap_true ).

  IF sy-subrc = 0.


    CALL FUNCTION function_name
      EXPORTING
        control_parameters = control_parameter
        output_options     = composer_parameter
        user_settings      = space
        label_data         = label_data
      IMPORTING
        job_output_info    = job_info
      EXCEPTIONS
        formatting_error   = 1
        internal_error     = 2
        send_error         = 3
        user_canceled      = 4
        OTHERS             = 5.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      RETURN.
    ENDIF.

    "Se não tiver OTF, não tem como gerar PDF preview
    IF job_info-otfdata IS INITIAL.
      MESSAGE 'SmartForm não retornou OTF (verifique GETOTF = X).' TYPE 'S' DISPLAY LIKE 'E'.
      RETURN.
    ENDIF.

    CALL FUNCTION 'SSFCOMP_PDF_PREVIEW'
      EXPORTING
        i_otf                    = job_info-otfdata
      EXCEPTIONS
        convert_otf_to_pdf_error = 1
        cntl_error               = 2
        OTHERS                   = 3.

    IF sy-subrc <> 0.
      MESSAGE 'Erro ao gerar pré-visualização em PDF.' TYPE 'S' DISPLAY LIKE 'E'.
    ENDIF.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form print_label3
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM print_label3 .

ENDFORM.