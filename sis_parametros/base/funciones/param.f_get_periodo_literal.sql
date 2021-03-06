CREATE OR REPLACE FUNCTION param.f_get_periodo_literal (
  p_id_periodo integer
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:   	Parámetros
 FUNCION:     	param.f_get_periodo_literal
 DESCRIPCION:   Devuelve el literal del periodo MES y AÑO
 AUTOR:      	RCM
 FECHA:         08/03/2018
 COMENTARIOS: 
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION: 
 AUTOR:     
 FECHA:   
***************************************************************************/
DECLARE

	v_nombre_funcion    text;
    v_resp              varchar;
    v_periodo			varchar;
    v_rec				record;
    v_mes				varchar;

BEGIN

	v_nombre_funcion = 'cd.ft_cuenta_doc_sel';
    
    if not exists(select 1 from param.tperiodo
    			where id_periodo = p_id_periodo) then
    	return 'Periodo no Encontrado';
    end if;
    
    select per.id_periodo, per.fecha_ini, per.fecha_fin, per.periodo, ges.gestion
    into v_rec
    from param.tperiodo per
    inner join param.tgestion ges
    on ges.id_gestion = per.id_gestion
    where per.id_periodo = p_id_periodo;
    
    if v_rec.periodo = 1 then
    	v_mes = 'Enero';
    elsif v_rec.periodo = 2 then
    	v_mes = 'Febrero';
    elsif v_rec.periodo = 3 then
    	v_mes = 'Marzo';
    elsif v_rec.periodo = 4 then
    	v_mes = 'Abril';
    elsif v_rec.periodo = 5 then
    	v_mes = 'Mayo';
    elsif v_rec.periodo = 6 then
    	v_mes = 'Junio';
    elsif v_rec.periodo = 7 then
    	v_mes = 'Julio';
    elsif v_rec.periodo = 8 then
    	v_mes = 'Agosto';
    elsif v_rec.periodo = 9 then
    	v_mes = 'Septiembre';
    elsif v_rec.periodo = 10 then
    	v_mes = 'Octubre';
    elsif v_rec.periodo = 11 then
    	v_mes = 'Noviembre';
    elsif v_rec.periodo = 12 then
    	v_mes = 'Diciembre';
    else
    	v_mes = 'N/D';
    end if;
    
    v_periodo = coalesce(v_mes,'N/D')||' de '||coalesce(v_rec.gestion,0)::varchar;
    
    return v_periodo;
    

EXCEPTION
	WHEN OTHERS THEN
        v_resp='';
        v_resp = pxp.f_agrega_clave(v_resp,'mensaje',SQLERRM);
        v_resp = pxp.f_agrega_clave(v_resp,'codigo_error',SQLSTATE);
        v_resp = pxp.f_agrega_clave(v_resp,'procedimientos',v_nombre_funcion);
        raise exception '%',v_resp;
END;
$body$
LANGUAGE 'plpgsql'
IMMUTABLE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;