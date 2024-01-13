class bridge_apb_agent extends uvm_agent;

	//Factory Registration
	`uvm_component_utils(bridge_apb_agent)	

        //Properties
	bridge_apb_driver drvh;
	bridge_apb_monitor monh;
	bridge_apb_sequencer seqrh;

	bridge_apb_agent_config apb_cfg;

		//------------------------------------------
		// Methods
		//------------------------------------------
		// Standard UVM Methods:
	extern function new(string name="bridge_apb_agent",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);

endclass:bridge_apb_agent

		//Constructor-new
function bridge_apb_agent::new(string name="bridge_apb_agent",uvm_component parent);
	super.new(name,parent);
endfunction:new
	
//build phase
function void bridge_apb_agent::build_phase(uvm_phase phase);
	if(!uvm_config_db #(bridge_apb_agent_config)::get(this,"","bridge_apb_agent_config",apb_cfg))
		`uvm_fatal("APB_AGENT","apb_cfg is not get")

	super.build_phase(phase);

	monh=bridge_apb_monitor::type_id::create("monh",this);

	if(apb_cfg.is_active==UVM_ACTIVE)
	begin
		drvh=bridge_apb_driver::type_id::create("drvh",this);
		seqrh=bridge_apb_sequencer::type_id::create("seqrh",this);
	end

endfunction:build_phase

//connect phase
function void bridge_apb_agent::connect_phase(uvm_phase phase);
	if(apb_cfg.is_active)
		drvh.seq_item_port.connect(seqrh.seq_item_export);
	
endfunction:connect_phase



