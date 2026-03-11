*&---------------------------------------------------------------------*
*& Report ZPRO004
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZPRO004.

PARAMETERS p_brand TYPE zgflores_tveicul-brand_id.

data(vehicle) = NEW zcl_gf_report( p_brand ).

vehicle->GET_DATA( ).

vehicle->DISPLAY_DATA( ).

vehicle->MAP_DATA( ).

BREAK-POINT.