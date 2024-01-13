class bridge_apb_monitor extends uvm_monitor;

	//Factory Registration
	`uvm_component_utils(bridge_apb_monitor)

        //Properties
	virtual apb_if.APB_MON_MP vif;

	bridge_apb_agent_config apb_cfg;
	
	apb_xtn xtn;

	uvm_analysis_port#(apb_xtn) monitor_port;
	
		//------------------------------------------
		// Methods
		//------------------------------------------
		// Standard UVM Methods:
	extern function new(string name="bridge_apb_monitor",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase (uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task collect_data();
	extern function void report_phase(uvm_phase phase);

endclass:bridge_apb_monitor

		//Constructor-new
function bridge_apb_monitor::new(string name="bridge_apb_monitor",uvm_component parent);
		super.new(name,parent);
		monitor_port=new("monitor_port",this);
endfunction:new

        //Build phase
function void bridge_apb_monitor::build_phase(uvm_phase phase);
	if(!uvm_config_db#(bridge_apb_agent_config)::get(this,"","bridge_apb_agent_config",apb_cfg))
		`uvm_fatal("APB_MONITOR","apb_cfg is not get")

	super.build_phase(phase);

endfunction:build_phase
		
		//Connect phase
function void bridge_apb_monitor::connect_phase (uvm_phase phase);
	vif=apb_cfg.pvif;
endfunction:connect_phase

//run phase
task bridge_apb_monitor::run_phase(uvm_phase phase);
	forever
	begin
		collect_data();
	
	end

endtask:run_phase

//collect data
task bridge_apb_monitor::collect_data();

	xtn=apb_xtn::type_id::create("xtn");

	wait(vif.apb_mon_cb.penable)
		xtn.paddr = vif.apb_mon_cb.paddr;
		xtn.pwrite = vif.apb_mon_cb.pwrite;
		xtn.pselx = vif.apb_mon_cb.pselx;
		xtn.penable = vif.apb_mon_cb.penable;
		
	if(vif.apb_mon_cb.pwrite==1)
		xtn.pwdata = vif.apb_mon_cb.pwdata;
	else
		xtn.prdata = vif.apb_mon_cb.prdata;

	@(vif.apb_mon_cb);
//	@(vif.apb_mon_cb);
	monitor_port.write(xtn);

	`uvm_info("APB MONITOR",$sformatf("APB  Monitored data \n %s",xtn.sprint()),UVM_MEDIUM)

	apb_cfg.apb_mon_data_count++;

endtask:collect_data

//report phase
function void bridge_apb_monitor::report_phase(uvm_phase phase);
	`uvm_info("APB MONITOR",$sformatf("Report Phase: apb monitor data count:%0d",apb_cfg.apb_mon_data_count),UVM_LOW)

endfunction:report_phase
	

