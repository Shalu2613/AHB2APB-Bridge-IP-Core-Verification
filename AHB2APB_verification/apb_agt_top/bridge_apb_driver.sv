class bridge_apb_driver extends uvm_driver #(apb_xtn);

	//Factory Registration
	`uvm_component_utils(bridge_apb_driver)

        //Properties
	virtual apb_if.APB_DRV_MP vif;
	
	bridge_apb_agent_config apb_cfg;

	apb_xtn xtn;
		
		//------------------------------------------
		// Methods
		//------------------------------------------
		// Standard UVM Methods:
	extern function new(string name="bridge_apb_driver",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task drive_data(apb_xtn xtn);
	extern function void report_phase(uvm_phase phase);

endclass:bridge_apb_driver

		//Constructor-new
function bridge_apb_driver::new(string name="bridge_apb_driver",uvm_component parent);
	super.new(name,parent);
endfunction:new

//build phase
function void bridge_apb_driver::build_phase(uvm_phase phase);
	if(! uvm_config_db #(bridge_apb_agent_config)::get(this,"","bridge_apb_agent_config",apb_cfg))
		`uvm_fatal("APB_DRIVER","apb_cfg is not get")

	super.build_phase(phase);
endfunction:build_phase

//connect phase
function void bridge_apb_driver::connect_phase(uvm_phase phase);
	vif=apb_cfg.pvif;
endfunction:connect_phase

//run phase
task bridge_apb_driver::run_phase(uvm_phase phase);

//	req=apb_xtn::type_id::create("req",this);

//	@(vif.apb_drv_cb);
	forever
	begin
		seq_item_port.get_next_item(req);
		drive_data(req);
		seq_item_port.item_done();
	end

endtask:run_phase

//drive data logic
task bridge_apb_driver::drive_data(apb_xtn xtn);
	$display("before entering apb driver");
	
	xtn.pselx = vif.apb_drv_cb.pselx;	

	wait(vif.apb_drv_cb.pselx !=0)
	//@(vif.apb_drv_cb);
		if(vif.apb_drv_cb.pwrite ==0)
		begin
		     if(vif.apb_drv_cb.penable ==1)
//			vif.apb_drv_cb.prdata <= {$random};
			vif.apb_drv_cb.prdata <= xtn.prdata;
		$display("\n inside apb driver");

		end
		
		xtn.pwrite = vif.apb_drv_cb.pwrite;
		xtn.penable = vif.apb_drv_cb.penable;
		xtn.paddr = vif.apb_drv_cb.paddr;
		xtn.pwdata = vif.apb_drv_cb.pwdata;

	repeat(2)
		@(vif.apb_drv_cb);

	apb_cfg.apb_drv_data_count++;
	
	`uvm_info("APB DRIVER", $sformatf("data drived from apb driver \n %s", xtn.sprint()),UVM_MEDIUM)
	$display("after apb driver");

endtask:drive_data

//report phase
function void bridge_apb_driver::report_phase(uvm_phase phase);
	`uvm_info("APB DRIVER", $sformatf("Report Phase: apb drived data count:%0d",apb_cfg.apb_drv_data_count),UVM_LOW)

endfunction:report_phase	




