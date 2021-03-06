--------------- SQL ---------------

CREATE OR REPLACE FUNCTION param.ft_concepto_ingas_det_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:        Parametros Generales
 FUNCION:         param.ft_concepto_ingas_det_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'param.tconcepto_ingas_det'
 AUTOR:          (admin)
 FECHA:            22-07-2019 14:37:28
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
  ISSUE            AUTHOR            FECHA                DESCRIPCION
  #39 ETR        EGS                31/07/2019            Creacion #
  #48           EGS             14/08/2019          Se Agrego columnas dinamicas relacionadas a otros sistemas(proyectos)
 ***************************************************************************/

DECLARE

    v_nro_requerimiento         integer;
    v_parametros                record;
    v_id_requerimiento          integer;
    v_resp                      varchar;
    v_nombre_funcion            text;
    v_mensaje_error             text;
    v_id_concepto_ingas_det     integer;
    v_id_columna                integer;
    v_columna                   record;
    v_consulta                  varchar;
    v_valor                     varchar;
    v_id_columna_concepto_ingas_det integer;
    v_record_columna            record;
    v_record                    record;
BEGIN

    v_nombre_funcion = 'param.ft_concepto_ingas_det_ime';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************
     #TRANSACCION:  'PM_COIND_INS'
     #DESCRIPCION:    Insercion de registros
     #AUTOR:        admin
     #FECHA:        22-07-2019 14:37:28
    ***********************************/

    if(p_transaccion='PM_COIND_INS')then

        begin

            --Sentencia de la insercion
            insert into param.tconcepto_ingas_det(
            estado_reg,
            nombre,
            descripcion,
            id_concepto_ingas,
            id_usuario_reg,
            fecha_reg,
            id_usuario_ai,
            usuario_ai,
            id_usuario_mod,
            fecha_mod,
            agrupador,
            id_concepto_ingas_det_fk
              ) values(
            'activo',
            v_parametros.nombre,
            v_parametros.descripcion,
            v_parametros.id_concepto_ingas,
            p_id_usuario,
            now(),
            v_parametros._id_usuario_ai,
            v_parametros._nombre_usuario_ai,
            null,
            null,
            v_parametros.agrupador,
            v_parametros.id_concepto_ingas_det_fk

            )RETURNING id_concepto_ingas_det into v_id_concepto_ingas_det;
            --#48 Recuperamos las columna dinamicas si existen
           FOR v_columna IN(
               SELECT
                    cl.nombre_columna,
                    cl.tipo_dato
               FROM param.tcolumna cl
               order by cl.nombre_columna asc
           )LOOP
                IF pxp.f_existe_parametro(p_tabla,v_columna.nombre_columna) THEN
                    SELECT
                        cl.id_columna
                    INTO
                        v_id_columna
                    FROM param.tcolumna cl
                    WHERE lower(cl.nombre_columna) = lower(v_columna.nombre_columna) ;
                    v_consulta = 'select '||v_columna.nombre_columna||' from '||p_tabla||' limit 1';
                    execute v_consulta into v_valor;


                    IF v_columna.tipo_dato = 'varchar' or v_columna.tipo_dato = 'text' or v_columna.tipo_dato = 'date' or v_columna.tipo_dato = 'timestamp'  THEN
                            v_valor = COALESCE(''''||v_valor::VARCHAR||'''','null');
                    ELSE
                            v_valor = COALESCE(v_valor::VARCHAR,'null');

                        if (v_valor ~ '^[0-9]*.?[0-9]*$') then
                            --RAISE EXCEPTION 'es numero';
                        else
                            --RAISE EXCEPTION 'No es numero';
                        end if;
                    END IF;

                    v_consulta = 'INSERT INTO param.tcolumna_concepto_ingas_det(
                            id_usuario_reg,
                            id_concepto_ingas_det,
                            id_columna,
                            valor

                         ) values(
                         '||p_id_usuario||',
                         '||v_id_concepto_ingas_det||',
                         '||v_id_columna||',
                         '||v_valor||'
                         )';
                     EXECUTE(v_consulta);
                END IF;
           END LOOP;

            --RAISE EXCEPTION 'v_id_columna %',v_id_columna;
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Concepto Ingreso/gasto Detalle almacenado(a) con exito (id_concepto_ingas_det'||v_id_concepto_ingas_det||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_concepto_ingas_det',v_id_concepto_ingas_det::varchar);

            --Devuelve la respuesta
            return v_resp;

        end;

    /*********************************
     #TRANSACCION:  'PM_COIND_MOD'
     #DESCRIPCION:    Modificacion de registros
     #AUTOR:        admin
     #FECHA:        22-07-2019 14:37:28
    ***********************************/

    elsif(p_transaccion='PM_COIND_MOD')then

        begin
            --Sentencia de la modificacion
            update param.tconcepto_ingas_det set
            nombre = v_parametros.nombre,
            descripcion = v_parametros.descripcion,
            id_concepto_ingas = v_parametros.id_concepto_ingas,
            id_usuario_mod = p_id_usuario,
            fecha_mod = now(),
            id_usuario_ai = v_parametros._id_usuario_ai,
            usuario_ai = v_parametros._nombre_usuario_ai,
            agrupador =v_parametros.agrupador,
            id_concepto_ingas_det_fk = v_parametros.id_concepto_ingas_det_fk
            where id_concepto_ingas_det=v_parametros.id_concepto_ingas_det;
           --#48 recuperamos las columnas dinamicas si existen
          FOR v_columna IN(
               SELECT
                    cl.nombre_columna,
                    cl.tipo_dato
               FROM param.tcolumna cl
               order by cl.nombre_columna asc
           )LOOP
                RAISE notice 'v_consulta %',v_columna.nombre_columna;
                IF pxp.f_existe_parametro(p_tabla,v_columna.nombre_columna) THEN

                    SELECT
                        cl.id_columna,
                        LOWER(cl.tipo_dato) as tipo_dato
                    INTO
                        v_record_columna
                    FROM param.tcolumna cl
                    WHERE lower(cl.nombre_columna) = lower(v_columna.nombre_columna) ;

                    v_consulta = 'select '||v_columna.nombre_columna||' from '||p_tabla||' limit 1';

                    EXECUTE v_consulta into v_valor;

                    SELECT
                        cld.id_columna_concepto_ingas_det
                    INTO
                        v_id_columna_concepto_ingas_det
                    FROM param.tcolumna_concepto_ingas_det cld
                    WHERE cld.id_concepto_ingas_det = v_parametros.id_concepto_ingas_det and cld.id_columna = v_record_columna.id_columna ;

                    IF v_record_columna.tipo_dato = 'varchar' or v_record_columna.tipo_dato = 'text' or v_columna.tipo_dato = 'date' or v_columna.tipo_dato = 'timestamp' THEN
                            v_valor = COALESCE(''''||v_valor::VARCHAR||'''','null');
                    ELSE
                            v_valor = COALESCE(v_valor::VARCHAR,'null');
                    END IF;

                    IF v_id_columna_concepto_ingas_det is not null THEN

                        v_consulta=' UPDATE param.tcolumna_concepto_ingas_det SET
                                     valor = '||v_valor||'
                                     WHERE id_columna_concepto_ingas_det = '||v_id_columna_concepto_ingas_det;
                        Execute v_consulta;

                    ELSE
                     v_consulta = 'INSERT INTO param.tcolumna_concepto_ingas_det(
                            id_usuario_reg,
                            id_concepto_ingas_det,
                            id_columna,
                            valor

                         ) values(
                         '||p_id_usuario||',
                         '||v_id_concepto_ingas_det||',
                         '||v_id_columna||',
                         '||v_valor||'
                         )';
                     --EXECUTE(v_consulta);

                    END IF;


                END IF;
           END LOOP;



            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Concepto Ingreso/gasto Detalle modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_concepto_ingas_det',v_parametros.id_concepto_ingas_det::varchar);

            --Devuelve la respuesta
            return v_resp;

        end;

    /*********************************
     #TRANSACCION:  'PM_COIND_ELI'
     #DESCRIPCION:    Eliminacion de registros
     #AUTOR:        admin
     #FECHA:        22-07-2019 14:37:28
    ***********************************/

    elsif(p_transaccion='PM_COIND_ELI')then

        begin
             --eliminamos los valores de las columnas dinamicas
             FOR v_record IN(
              SELECT
                  c.id_columna_concepto_ingas_det
              FROM param.tcolumna_concepto_ingas_det c
              WHERE c.id_concepto_ingas_det = v_parametros.id_concepto_ingas_det
              )LOOP
                DELETE FROM param.tcolumna_concepto_ingas_det
                WHERE id_columna_concepto_ingas_det = v_record.id_columna_concepto_ingas_det;
             END LOOP;
            --Sentencia de la eliminacion
            delete from param.tconcepto_ingas_det
            where id_concepto_ingas_det=v_parametros.id_concepto_ingas_det;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Concepto Ingreso/gasto Detalle eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_concepto_ingas_det',v_parametros.id_concepto_ingas_det::varchar);

            --Devuelve la respuesta
            return v_resp;

        end;

    else

        raise exception 'Transaccion inexistente: %',p_transaccion;

    end if;

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
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;