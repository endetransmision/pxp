<?php
/**
*@package pXP
*@file gen-Aprobador.php
*@author  (admin)
*@date 09-01-2013 23:03:33
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.Aprobador=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.Aprobador.superclass.constructor.call(this,config);
		this.init();
		this.load({params:{start:0, limit:50}})
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_aprobador'
			},
			type:'Field',
			form:true 
		},
		{
			config:{
				name:'id_subsistema',
				fieldLabel:'Subsistema',
				allowBlank:false,
				emptyText:'Subsistema...',
				store: new Ext.data.JsonStore({
					url: '../../sis_seguridad/control/Subsistema/listarSubsistema',
					id: 'id_subsistema',
					root: 'datos',
					sortInfo:{
						field: 'nombre',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_subsistema','nombre','codigo'],
					// turn on remote sorting
					remoteSort: true,
					baseParams:{par_filtro:'nombre'}
				}),
				valueField: 'id_subsistema',
				displayField: 'codigo',
				gdisplayField:'desc_subsistema',
				hiddenName: 'id_subsistema',
				forceSelection:true,
				typeAhead: true,
    			triggerAction: 'all',
    			lazyRender:true,
				mode:'remote',
				pageSize:50,
				queryDelay:500,
				width:210,
				gwidth:220,
				minChars:2,
				minListWidth:'100%',
				renderer: function (value, p, record){
					return String.format('{0}', record.data['desc_subsistema']
					)}
			},
			type:'ComboBox',
			id_grupo:0,
			filters:{	
		        pfiltro:'subsis.nombre',
				type:'string'
			},
			
			grid:true,
			form:true
		},
		 {
		   			config:{
		       		    name:'id_funcionario',
		   				origen:'FUNCIONARIO',
		   				fieldLabel:'Funcionario',
		   				allowBlank:false,
		                gwidth:200,
		   				valueField: 'id_funcionario',
		   			    gdisplayField: 'desc_funcionario',
		      			renderer:function(value, p, record){return String.format('{0}', record.data['desc_funcionario']);}
		       	     },
		   			type:'ComboRec',//ComboRec
		   			id_grupo:0,
		   			filters:{pfiltro:'funcio.desc_funcionario1',type:'string'},
		   		    grid:true,
		   			form:true
		 },
				{
			config:{
				name: 'id_centro_costo',
				fieldLabel: 'Centro de Costos',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
			type:'NumberField',
			filters:{pfiltro:'apro.id_centro_costo',type:'numeric'},
			id_grupo:1,
			grid:true,
			form:true
		},
		 {
	   		config:{
	   				name:'id_uo',
	   				origen:'UO',
	   				fieldLabel:'Unidad',
	   				allowBlank:false,
	   				gdisplayField:'desc_uo',//mapea al store del grid
	   			    gwidth:200,
	   			    baseParams:{gerencia:'si'},
	      			renderer:function (value, p, record){return String.format('{0}', record.data['desc_uo']);}
	      		},
   			type:'ComboRec',
   			id_grupo:0,
   			filters:{pfiltro:'nombre_unidad',type:'string'},
   		    grid:true,
   			form:true
	    },
		{
			config:{
				name: 'monto_min',
				fieldLabel: 'monto_min',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:1245184
			},
			type:'NumberField',
			filters:{pfiltro:'apro.monto_min',type:'numeric'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'monto_max',
				fieldLabel: 'monto_max',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:1245184
			},
			type:'NumberField',
			filters:{pfiltro:'apro.monto_max',type:'numeric'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'fecha_ini',
				fieldLabel: 'fecha_ini',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
						format: 'd/m/Y', 
						renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
			type:'DateField',
			filters:{pfiltro:'apro.fecha_ini',type:'date'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'fecha_fin',
				fieldLabel: 'fecha_fin',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
						format: 'd/m/Y', 
						renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
			type:'DateField',
			filters:{pfiltro:'apro.fecha_fin',type:'date'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'obs',
				fieldLabel: 'obs',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:255
			},
			type:'TextField',
			filters:{pfiltro:'apro.obs',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'estado_reg',
				fieldLabel: 'Estado Reg.',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:10
			},
			type:'TextField',
			filters:{pfiltro:'apro.estado_reg',type:'string'},
			id_grupo:1,
			grid:true,
			form:false
		}
		,
		{
			config:{
				name: 'fecha_reg',
				fieldLabel: 'Fecha creación',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
						format: 'd/m/Y', 
						renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
			type:'DateField',
			filters:{pfiltro:'apro.fecha_reg',type:'date'},
			id_grupo:1,
			grid:true,
			form:false
		},
		{
			config:{
				name: 'usr_reg',
				fieldLabel: 'Creado por',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
			type:'NumberField',
			filters:{pfiltro:'usu1.cuenta',type:'string'},
			id_grupo:1,
			grid:true,
			form:false
		},
		{
			config:{
				name: 'fecha_mod',
				fieldLabel: 'Fecha Modif.',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
						format: 'd/m/Y', 
						renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
			type:'DateField',
			filters:{pfiltro:'apro.fecha_mod',type:'date'},
			id_grupo:1,
			grid:true,
			form:false
		},
		{
			config:{
				name: 'usr_mod',
				fieldLabel: 'Modificado por',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
			type:'NumberField',
			filters:{pfiltro:'usu2.cuenta',type:'string'},
			id_grupo:1,
			grid:true,
			form:false
		}
	],
	
	title:'Aprobador',
	ActSave:'../../sis_parametros/control/Aprobador/insertarAprobador',
	ActDel:'../../sis_parametros/control/Aprobador/eliminarAprobador',
	ActList:'../../sis_parametros/control/Aprobador/listarAprobador',
	id_store:'id_aprobador',
	fields: [
		{name:'id_aprobador', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'id_centro_costo', type: 'numeric'},
		{name:'monto_min', type: 'numeric'},
		{name:'id_funcionario', type: 'numeric'},
		{name:'obs', type: 'string'},
		{name:'id_uo', type: 'numeric'},
		{name:'fecha_ini', type: 'date',dateFormat:'Y-m-d'},
		{name:'monto_max', type: 'numeric'},
		{name:'fecha_fin', type: 'date',dateFormat:'Y-m-d'},
		{name:'id_subsistema', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		
	],
	sortInfo:{
		field: 'id_aprobador',
		direction: 'ASC'
	},
	bdel:true,
	bsave:true
	}
)
</script>
		
		