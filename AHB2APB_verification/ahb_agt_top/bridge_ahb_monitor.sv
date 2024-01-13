class bridge_ahb_monitor extends uvm_monitor;

	//Factory Registration
	`uvm_component_utils(bridge_ahb_monitor)

        //Properties
	bridge_ahb_agent_config ahb_cfg;

	virtual ahb_if.AHB_MON_MP vif;

	ahb_xtn xtn;
		
	uvm_analysis_port#(ahb_xtn)monitor_port;

		//------------------------------------------
		// Methods
		//------------------------------------------
		// Standard UVM Methods:
	extern function new(string name="bridge_ahb_monitor",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task collect_data();
	extern function void report_phase(uvm_phase phase);

endclass:bridge_ahb_monitor

		//Constructor-new
function bridge_ahb_monitor::new(string name="bridge_ahb_monitor",uvm_component parent);
	super.new(name,parent);
	monitor_port=new("monitor_port",this);
endfunction:new
		 
        //Build phase
function void bridge_ahb_monitor::build_phase(uvm_phase phase);
	if(!uvm_config_db#(bridge_ahb_agent_config)::get(this,"","bridge_ahb_agent_config",ahb_cfg))
		`uvm_fatal("AHB_MONITOR","ahb_cfg is not get")

	super.build_phase(phase);
endfunction:build_phase


//connect phase
function void bridge_ahb_monitor::connect_phase(uvm_phase phase);
	vif=ahb_cfg.hvif;
endfunction:connect_phase

//run phase
task bridge_ahb_monitor::run_phase(uvm_phase phase);

	forever
	begin
		collect_data();

	end
endtask:run_phase

//collect data
task bridge_ahb_monitor::collect_data;
	
	xtn=ahb_xtn::type_id::create("xtn");
	
	wait(vif.ahb_mon_cb.htrans==2'b10 || vif.ahb_mon_cb.htrans==2'b11)
		xtn.haddr = vif.ahb_mon_cb.haddr;
		xtn.htrans = vif.ahb_mon_cb.htrans;
		xtn.hsize = vif.ahb_mon_cb.hsize;
		xtn.hwrite = vif.ahb_mon_cb.hwrite;
		xtn.hburst = vif.ahb_mon_cb.hburst;
		xtn.hready_out = vif.ahb_mon_cb.hready_out;
		xtn.hready_in = vif.ahb_mon_cb.hready_in;
		xtn.hresp = vif.ahb_mon_cb.hresp;
		xtn.hresetn = vif.ahb_mon_cb.hresetn;

//	@(vif.ahb_mon_cb);
	@(vif.ahb_mon_cb);

	wait(vif.ahb_mon_cb.hready_out)
	if(vif.ahb_mon_cb.hwrite)
	begin
//		while(!vif.ahb_mon_cb.hwdata)
//		@(vif.ahb_mon_cb);

		xtn.hwdata = vif.ahb_mon_cb.hwdata;
	
	end
	else
		xtn.hrdata = vif.ahb_mon_cb.hrdata;

	ahb_cfg.ahb_mon_data_count++;
	
	monitor_port.write(xtn);
		`uvm_info("AHB MONITOR",$sformatf("printing from monitor \n %s", xtn.sprint()),UVM_LOW)

endtask:collect_data

//report phase
function void bridge_ahb_monitor::report_phase(uvm_phase phase);
		`uvm_info("AHB MONITOR",$sformatf("Report_phase: ahb monitor data count: %0d",ahb_cfg.ahb_mon_data_count),UVM_LOW)

endfunction:report_phase


