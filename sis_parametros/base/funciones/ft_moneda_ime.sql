CREATE OR REPLACE FUNCTION param.ft_moneda_ime (
  par_administrador integer,
  par_id_usuario integer,
  par_tabla character varying,
  par_transaccion character varying
)
RETURNS varchar
AS 
$body$
/**************************************************************************
 FUNCION: 		param.ft_moneda_ime
 DESCRIPCIÓN:   modificaciones de funciones
 AUTOR: 		KPLIAN
 FECHA:	        
 COMENTARIOS:	
***************************************************************************
 HISTORIA DE MODIFICACIONES:

 DESCRIPCION:	
 AUTOR:		
 FECHA:		18-01-2011
 ***************************************************************************/
DECLARE


v_parametros                record;
v_resp                      varchar;
v_nombre_funcion            text;
v_mensaje_error             text;

v_id_funcion  				integer;

BEGIN

     v_nombre_funcion:='param.ft_moneda_ime';
     v_parametros:=pxp.f_get_record(par_tabla);
     
     
 /*******************************    
 #TRANSACCION:   PM_MONEDA_INS
 #DESCRIPCION:	Inserta Funciones
 #AUTOR:		KPLIAN	
 #FECHA:		18-01-2011	
***********************************/
     if(par_transaccion='PM_MONEDA_INS')then

        
          BEGIN
          
          --insercion de nueva funcion
               INSERT INTO param.tmoneda(codigo,moneda, estado_reg,fecha_reg, id_usuario_reg)
               values(v_parametros.codigo,v_parametros.moneda,'activo',now()::date, par_id_usuario);
              

               v_resp = pxp.f_agrega_clave(v_resp,'mensaje','moneda insertada con exito '||v_parametros.moneda);
               v_resp = pxp.f_agrega_clave(v_resp,'id_moneda',v_id_funcion::varchar);


         END;
 /*******************************    
 #TRANSACCION:  PM_MONEDA_MOD
 #DESCRIPCION:	Modifica la moneda seleccionada
 #AUTOR:		KPLIAN	
 #FECHA:		18-01-2011
***********************************/
     elsif(par_transaccion='PM_MONEDA_MOD')then

          
          BEGIN

          
               if exists (select 1 from param.tmoneda where estado_reg='activo' and tipo_moneda='base' and id_moneda!=v_parametros.id_moneda and v_parametros.tipo_moneda='on') then
                  raise exception 'Modificacion no realizada. Ya existe una moneda base';
               end if;
               --modificacion de moneda
               update param.tmoneda set
               codigo=v_parametros.codigo,
               moneda=v_parametros.moneda,
               fecha_mod=now()::date,
               id_usuario_mod=par_id_usuario,
               tipo_moneda=pxp.f_iif(v_parametros.tipo_moneda='on','base', null)
               
               where id_moneda=v_parametros.id_moneda;

               v_resp = pxp.f_agrega_clave(v_resp,'mensaje','moneda modificada con exito '||v_parametros.id_moneda);
               v_resp = pxp.f_agrega_clave(v_resp,'id_moneda',v_parametros.id_moneda::varchar);
          END;
          
/*******************************    
 #TRANSACCION:  PM_MONEDA_ELI
 #DESCRIPCION:	Inactiva la moneda selecionada
 #AUTOR:		KPLIAN	
 #FECHA:		18-01-2011
***********************************/

    elsif(par_transaccion='PM_MONEDA_ELI')then
        BEGIN
        
         --inactivacion de la moneda
               update param.tmoneda set estado_reg='eliminado'
               where id_moneda=v_parametros.id_moneda;
               return 'moneda eliminado con exito';
               
               v_resp = pxp.f_agrega_clave(v_resp,'mensaje','moneda eliminada con exito '||v_parametros.id_moneda);
               v_resp = pxp.f_agrega_clave(v_resp,'id_moneda',v_parametros.id_moneda::varchar);

        END;
        
   
    else

         raise exception 'No existe la transaccion: %',par_transaccion;
    end if;
    
 return v_resp;  

EXCEPTION

      WHEN OTHERS THEN
    	v_resp='';
		v_resp = pxp.f_agrega_clave(v_resp,'mensaje',SQLERRM);
    	v_resp = pxp.f_agrega_clave(v_resp,'codigo_error',SQLSTATE);
  		v_resp = pxp.f_agrega_clave(v_resp,'procedimientos',v_nombre_funcion);
		raise exception '%',v_resp;


END;
$body$
    LANGUAGE plpgsql;
--
-- Definition for function ft_moneda_sel (OID = 304042) : 
--