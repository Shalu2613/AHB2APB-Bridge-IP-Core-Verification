class bridge_ahb_driver extends uvm_driver#(ahb_xtn);

	//Factory Registration
	`uvm_component_utils(bridge_ahb_driver)

        //Properties
	bridge_ahb_agent_config ahb_cfg;
	
	virtual ahb_if.AHB_DRV_MP vif;
	
	ahb_xtn xtn;
	
		//------------------------------------------
		// Methods
		//------------------------------------------
		// Standard UVM Methods:
	extern function new(string name="bridge_ahb_driver",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task drive_data(ahb_xtn xtn);
	extern function void report_phase(uvm_phase phase);

endclass:bridge_ahb_driver

		//Constructor-new
function bridge_ahb_driver::new(string name="bridge_ahb_driver",uvm_component parent);
		 super.new(name,parent);
endfunction:new

        //Build phase
function void bridge_ahb_driver::build_phase(uvm_phase phase);
	if(!uvm_config_db #(bridge_ahb_agent_config)::get(this,"","bridge_ahb_agent_config",ahb_cfg))
		`uvm_fatal("AHB_DRIVER","ahb_cfg is not get")

	super.build_phase (phase);
endfunction:build_phase

// connect_phase
function void bridge_ahb_driver::connect_phase(uvm_phase phase);
	vif=ahb_cfg.hvif;
endfunction:connect_phase

//run phase
task bridge_ahb_driver::run_phase(uvm_phase phase);
	@(vif.ahb_drv_cb);
		vif.ahb_drv_cb.hresetn<=0;
	
	@(vif.ahb_drv_cb);
		vif.ahb_drv_cb.hresetn<=1;

	forever
	begin
		seq_item_port.get_next_item(req);
		drive_data(req);
		seq_item_port.item_done();
	end
endtask:run_phase

//drive data
task bridge_ahb_driver::drive_data(ahb_xtn xtn);
	
	vif.ahb_drv_cb.htrans<=xtn.htrans;
	vif.ahb_drv_cb.hwrite<=xtn.hwrite;
	vif.ahb_drv_cb.haddr<=xtn.haddr;
	vif.ahb_drv_cb.hready_in<=1'b1;
	vif.ahb_drv_cb.hsize <= xtn.hsize;
	vif.ahb_drv_cb.hburst <= xtn.hburst;

//	@(vif.ahb_drv_cb);
	@(vif.ahb_drv_cb);
	while(! vif.ahb_drv_cb.hready_out)
		@(vif.ahb_drv_cb);

	if(xtn.hwrite== 1)
		vif.ahb_drv_cb.hwdata<=xtn.hwdata;
	else
		vif.ahb_drv_cb.hwdata<=0;

	@(vif.ahb_drv_cb);

	`uvm_info("AHB DRIVER",$sformatf("printing from driver \n %s", xtn.sprint()),UVM_LOW)
	
	ahb_cfg.ahb_drv_data_count++;

endtask:drive_data

//report phase
function void bridge_ahb_driver::report_phase(uvm_phase phase);
	`uvm_info("AHB DRIVER",$sformatf("Report_phase: ahb driver data count: %0d",ahb_cfg.ahb_drv_data_count),UVM_LOW)

endfunction:report_phase








