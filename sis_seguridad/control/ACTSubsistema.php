<?php
/***
 Nombre: ACTSubsistema.php
 Proposito: Clase de Control para recibir los parametros enviados por los archivos
 de la Vista para envio y ejecucion de los metodos del Modelo referidas a la tabla tsubsistema
 Autor:	Kplian
 Fecha:	01/07/2010
 */
class ACTSubsistema extends ACTbase{    

	function listarSubsistema(){

		// parametros de ordenacion por defecto
		$this->objParam->defecto('ordenacion','codigo');
		$this->objParam->defecto('dir_ordenacion','asc');
				
		if ($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte=new Reporte($this->objParam);
			$this->res=$this->objReporte->generarReporteListado('FuncionesSeguridad','listarSubsistema');
		}
		else {
			$this->objFunSeguridad=new FuncionesSeguridad();
			$this->res=$this->objFunSeguridad->listarSubsistema($this->objParam);
		}
		
		//imprime respuesta en formato JSON para enviar lo a la interface (vista)
		$this->res->imprimirRespuesta($this->res->generarJson());
		
		
	}
	
	function guardarSubsistema(){
	
		//crea el objetoFunSeguridad que contiene todos los metodos del sistema de seguridad
		$this->objFunSeguridad=new FuncionesSeguridad();
		
		//preguntamos si se debe insertar o modificar 
		if($this->objParam->insertar('id_subsistema')){

			//ejecuta el metodo de insertar de la clase MODPersona a travez 
			//de la intefaz objetoFunSeguridad 
			$this->res=$this->objFunSeguridad->insertarSubsistema($this->objParam);			
		}
		else{	
			//ejecuta el metodo de modificar persona de la clase MODPersona a travez 
			//de la intefaz objetoFunSeguridad 
			$this->res=$this->objFunSeguridad->modificarSubsistema($this->objParam);
		}
		
		//imprime respuesta en formato JSON
		$this->res->imprimirRespuesta($this->res->generarJson());

	}
			
	function eliminarSubsistema(){
		
		//crea el objetoFunSeguridad que contiene todos los metodos del sistema de seguridad
		$this->objFunSeguridad=new FuncionesSeguridad();	
		$this->res=$this->objFunSeguridad->eliminarSubsistema($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());

	}
	
	function exportarDatosSeguridad(){
		
		//crea el objetoFunSeguridad que contiene todos los metodos del sistema de seguridad
		$this->objFunSeguridad=new FuncionesSeguridad();		
		
		$this->res = $this->objFunSeguridad->exportarDatosSeguridad($this->objParam);
		
		if($this->res->getTipo()=='ERROR'){
			$this->res->imprimirRespuesta($this->res->generarJson());
			exit;
		}
		
		$nombreArchivo = $this->crearArchivoExportacion($this->res);
		
		$this->mensajeExito=new Mensaje();
		$this->mensajeExito->setMensaje('EXITO','Reporte.php','Se genero con exito el sql'.$nombreArchivo,
										'Se genero con exito el sql'.$nombreArchivo,'control');
		$this->mensajeExito->setArchivoGenerado($nombreArchivo);
		
		$this->res->imprimirRespuesta($this->mensajeExito->generarJson());

	}
	
	function crearArchivoExportacion($res) {
		$data = $res -> getDatos();
		$fileName = uniqid(md5(session_id()).'ExportDataSegu').'.sql';
		//create file
		$file = fopen("../../../reportes_generados/$fileName", 'w');
		foreach ($data as $row) {
			if ($row['tipo'] =='funcion' ) {
				fwrite ($file, 
					"select pxp.f_insert_tfuncion ('".
							$row['nombre']."', '" . 
							$row['descripcion']."', '" . 
							$row['subsistema']."');\r\n");
				
			} elseif ($row['tipo'] == 'gui' ) {
				fwrite ($file, 
					"select pxp.f_insert_tgui ('". 
							$row['nombre']."', '" . 
							$row['descripcion']."', '" . 
							$row['codigo_gui']."', '" . 
							$row['visible']."', " . 
							$row['orden_logico'].", '" . 
							$row['ruta_archivo']."', " . 
							$row['nivel'].", '" . 
							$row['icono']."', '" . 
							$row['clase_vista']."', '" . 
							$row['subsistema']."');\r\n");
				
			} elseif ($row['tipo'] == 'gui_rol' ) {
				fwrite ($file, 
					"select pxp.f_insert_tgui_rol ('".
							$row['codigo_gui']."', '" . 
							$row['rol']."');\r\n");
				
			} elseif ($row['tipo'] == 'estructura_gui' ) {
				fwrite ($file, 
					"select pxp.f_insert_testructura_gui ('".
							$row['codigo_gui']."', '" . 
							$row['fk_codigo_gui']."');\r\n");
				
			} elseif ($row['tipo'] == 'procedimiento' ) {
				fwrite ($file, 
					"select pxp.f_insert_tprocedimiento ('".
							$row['codigo']."', '" . 
							$row['descripcion']."', '" . 
							$row['habilita_log']."', '" . 
							$row['autor']."', '" . 
							$row['fecha_creacion']."', '" . 
							$row['funcion']."');\r\n");
				
			} elseif ($row['tipo'] == 'procedimiento_gui' ) {
				fwrite ($file, 
					"select pxp.f_insert_tprocedimiento_gui ('".
							$row['codigo']."', '" . 
							$row['codigo_gui']."', '" . 
							$row['boton']."');\r\n");
				
			} elseif ($row['tipo'] == 'rol_procedimiento_gui' ) {
				fwrite ($file, 
					"select pxp.f_insert_trol_procedimiento_gui ('".
							$row['rol']."', '" . 
							$row['codigo']."', '" . 
							$row['codigo_gui']."');\r\n");
				
			}
		}
		return $fileName;
	}

}

?>