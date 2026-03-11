*&---------------------------------------------------------------------*
*& Report ZPRO007
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZPRO007.

PARAMETERS: p_ebeln TYPE ebeln OBLIGATORY,
            p_qtd   TYPE int4  OBLIGATORY.

DATA: ls_erro TYPE bapiret2.

START-OF-SELECTION.

  CALL FUNCTION 'ZFM_PRO_PRINT'
    EXPORTING
      iv_ebeln    = p_ebeln
      iv_qtd_etiq = p_qtd
    IMPORTING
      es_erro     = ls_erro.

  IF ls_erro-type = 'E'.
    MESSAGE ls_erro-message TYPE 'S' DISPLAY LIKE 'E'.
    RETURN.
  ENDIF.

  MESSAGE 'Etiquetas geradas com sucesso.' TYPE 'S'.