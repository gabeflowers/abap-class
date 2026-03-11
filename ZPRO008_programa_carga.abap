*&---------------------------------------------------------------------*
*& Report ZPRO008
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zpro008.

*---------------------------------------------------
CONSTANTS: c_path(3) VALUE 'C:\'.

TYPES: BEGIN OF type_uploaded_data,
         material(18),
         plant(4),
         message(300),
       END OF type_uploaded_data.

DATA: dir            TYPE string,
      uploaded_data  TYPE TABLE OF type_uploaded_data,
      gt_error       TYPE TABLE OF type_uploaded_data,
      gt_ok          TYPE TABLE OF type_uploaded_data,
      uploaded_line  TYPE type_uploaded_data,
      gt_bdc         TYPE TABLE OF bdcdata,
      gt_bdc_msg     TYPE TABLE OF bdcmsgcoll,
      gt_bapi_return TYPE TABLE OF bapiret2,
      gv_error       TYPE i,
      gv_ok          TYPE i.


*----------------------------------------------------
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_load     LIKE rlgrap-filename,
              p_log      LIKE rlgrap-filename  DEFAULT c_path,
              p_mode(20) TYPE c AS LISTBOX VISIBLE LENGTH 15 DEFAULT 'N' OBLIGATORY.

SELECTION-SCREEN END OF BLOCK b1.

AT SELECTION-SCREEN OUTPUT.
  DATA(list) = VALUE vrm_values( ( key = 'A' text = 'Sempre visivel')
                                 ( key = 'N' text = 'Nunca visivel' )
                                 ( key = 'E' text = 'Apenas erros'  ) ).
  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      id              = 'P_MODE'
      values          = list
    EXCEPTIONS
      id_illegal_name = 1
      OTHERS          = 2.
  .
  IF sy-subrc <> 0.
*   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*     WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_load.

  CALL FUNCTION 'KD_GET_FILENAME_ON_F4'
    CHANGING
      file_name = p_load.

  IF sy-subrc <> 0.
    MESSAGE e000(fipr) WITH TEXT-002.
  ENDIF.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_log.

  dir = p_log.

  CALL METHOD cl_gui_frontend_services=>directory_browse
    EXPORTING
      window_title         = 'Selecione o diretório para gravar arquivos de log'
      initial_folder       = dir
    CHANGING
      selected_folder      = dir
    EXCEPTIONS
      cntl_error           = 1
      error_no_gui         = 2
      not_supported_by_gui = 3
      OTHERS               = 4.
  p_log = dir.

AT SELECTION-SCREEN.
  IF p_load IS INITIAL.
    MESSAGE TEXT-002 TYPE 'E'.
    STOP.
  ENDIF.


START-OF-SELECTION.

  PERFORM upload.
  PERFORM execute.
  PERFORM report.
*&---------------------------------------------------------------------*
*& Form upload
*& Esse bloco lê o arquivo do computador. CALL METHOD cl_gui_frontend_services=>gui_upload
*& Ele pega o arquivo escolhido em p_load e coloca o conteúdo dentro da tabela uploaded_data.
*& “Ler o arquivo e transformar em tabelinha dentro do SAP.”
*& Form upload
*&---------------------------------------------------------------------*
FORM upload .

  DATA lv_arq TYPE string.

  lv_arq = p_load.

  CALL METHOD cl_gui_frontend_services=>gui_upload
    EXPORTING
      filename                = lv_arq
      filetype                = 'ASC'
      has_field_separator     = 'X'
      replacement             = ' '
    CHANGING
      data_tab                = uploaded_data
    EXCEPTIONS
      file_open_error         = 1
      file_read_error         = 2
      no_batch                = 3
      gui_refuse_filetransfer = 4
      invalid_type            = 5
      no_authority            = 6
      unknown_error           = 7
      bad_data_format         = 8
      header_not_allowed      = 9
      separator_not_allowed   = 10
      header_too_long         = 11
      unknown_dp_error        = 12
      access_denied           = 13
      dp_out_of_memory        = 14
      disk_full               = 15
      dp_timeout              = 16
      not_supported_by_gui    = 17
      error_no_gui            = 18
      OTHERS                  = 19.
  IF sy-subrc <> 0.
*   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*     WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form execute
*&---------------------------------------------------------------------*
FORM execute .

  LOOP AT uploaded_data INTO uploaded_line.

    CLEAR: gt_bdc,
           gt_bdc_msg,
           gt_bapi_return.

    PERFORM ser_bdc USING:
          'X' 'SAPMM03G' '0100',
          ' ' 'BDC_OKCODE' '=/00',
          ' ' 'RM03G-MATNR' uploaded_line-material.
*          ' ' 'RM03G-WERKS' uploaded_line-plant.

    PERFORM ser_bdc USING:
          'X' 'SAPMM03G' '0111',
          ' ' 'BDC_OKCODE' '=/00',
          ' ' 'RM03G-LVOMA' abap_true.
*          ' ' 'RM03G-LVOWK' abap_true.

    PERFORM ser_bdc USING:
          'X' 'SAPMM03G' '0111',
          ' ' 'BDC_OKCODE' '=BU',
          ' ' 'RM03G-LVOMA' abap_true.

    DATA(options) = VALUE ctu_params( defsize = abap_true
                                      dismode = p_mode
                                      updmode = 'S' ).

    CALL TRANSACTION 'MM06' USING gt_bdc
                            OPTIONS FROM options
                            MESSAGES INTO gt_bdc_msg.

    PERFORM check_bdc_error.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form report
*&---------------------------------------------------------------------*
FORM report .
  PERFORM create_log.

  WRITE: / 'Resumo do procesamento da carga'(013),
         / 'REGISTROS COM ERROS'(014), AT 23 gv_error,
         / 'REGISTROS COM SUCESSO'(015), AT 23 gv_ok.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form ser_bdc
*&---------------------------------------------------------------------*
FORM ser_bdc  USING  v_tela_init
                     v_nome
                     v_valor.

  IF v_tela_init = abap_true.

    DATA(ls_bdc) = VALUE bdcdata( program = v_nome
                                  dynpro = v_valor
                                  dynbegin = abap_true ).
  ELSE.

    ls_bdc = VALUE bdcdata( fnam = v_nome
                            fval = v_valor ).
  ENDIF.

  APPEND ls_bdc to gt_bdc.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form check_bdc_error
*&---------------------------------------------------------------------*
FORM check_bdc_error .

  CALL FUNCTION 'CONVERT_BDCMSGCOLL_TO_BAPIRET2'
    TABLES
      imt_bdcmsgcoll = gt_bdc_msg
      ext_return     = gt_bapi_return.

    IF line_exists( gt_bapi_return[ type = 'E' ] ).
      DATA(ls_error) = uploaded_line.
      ls_error-message = gt_bapi_return[ type = 'E' ]-message.
      APPEND ls_error to gt_error.
      ADD 1 TO gv_error.
    ELSE.
      DATA(ls_ok) = uploaded_line.
      ls_ok-message = 'Material eliminado com sucesso'.
      APPEND ls_ok to gt_ok.
      ADD 1 TO gv_ok.
    ENDIF.
ENDFORM.

FORM clear.
CLEAR:gt_bdc,
      gt_bdc_msg,
      gt_bapi_return.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form create_log
*&---------------------------------------------------------------------*
FORM create_log .
  IF gv_error IS NOT INITIAL.
    PERFORM download_log USING 'E'.
  ENDIF.

  IF gv_ok IS NOT INITIAL.
    PERFORM download_log USING 'S'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form download_log
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_
*&---------------------------------------------------------------------*
FORM download_log  USING status.

  DATA log_path TYPE string.
  dir = p_log.
  DATA(dir_lenght) = strlen( dir ).



  IF status = 'E'.
    DATA(name) = 'MM06-ERROR.TXT'.
    DATA(lt_log) = gt_error.
  ELSE.
    name = 'MM06-SUCESS.TXT'.
    lt_log = gt_ok.
  ENDIF.

  IF dir_lenght = 3.
    CONCATENATE dir name INTO log_path.
  ELSE.
    CONCATENATE dir '\' name INTO log_path.
  ENDIF.

    CALL METHOD cl_gui_frontend_services=>gui_download
      EXPORTING
        filename                  = log_path
        filetype                  = 'DAT'
      CHANGING
        data_tab                  = lt_log
      EXCEPTIONS
        file_write_error          = 1
        no_batch                  = 2
        gui_refuse_filetransfer   = 3
        invalid_type              = 4
        no_authority              = 5
        unknown_error             = 6
        header_not_allowed        = 7
        separator_not_allowed     = 8
        filesize_not_allowed      = 9
        header_too_long           = 10
        dp_error_create           = 11
        dp_error_send             = 12
        dp_error_write            = 13
        unknown_dp_error          = 14
        access_denied             = 15
        dp_out_of_memory          = 16
        disk_full                 = 17
        dp_timeout                = 18
        file_not_found            = 19
        dataprovider_exception    = 20
        control_flush_error       = 21
        not_supported_by_gui      = 22
        error_no_gui              = 23
        others                    = 24
      .
    IF SY-SUBRC <> 0.
     MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO.
    ENDIF.


ENDFORM.