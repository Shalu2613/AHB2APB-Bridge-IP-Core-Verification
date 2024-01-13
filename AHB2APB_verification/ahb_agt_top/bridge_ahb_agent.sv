class bridge_ahb_agent extends uvm_agent;

//Factory Registration
	`uvm_component_utils(bridge_ahb_agent)

        //Properties
	bridge_ahb_agent_config ahb_cfg;		
	
	bridge_ahb_driver drvh;
	bridge_ahb_monitor monh;
	bridge_ahb_sequencer seqrh;

		//------------------------------------------
		// Methods
		//------------------------------------------
		// Standard UVM Methods:
	extern function new(string name="bridge_ahb_agent",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);

endclass:bridge_ahb_agent

		//Constructor-new
function bridge_ahb_agent::new(string name="bridge_ahb_agent",uvm_component parent);
	super.new(name,parent);
endfunction:new
		 
        //Build phase
function void bridge_ahb_agent::build_phase(uvm_phase phase);
	if(! uvm_config_db #(bridge_ahb_agent_config)::get(this,"","bridge_ahb_agent_config",ahb_cfg))
		`uvm_fatal("AHB_AGENT","cannot get()interface ahb_cfg from uvm_config_db. Have you set() it?")

	super.build_phase(phase);
	
	monh=bridge_ahb_monitor::type_id::create("monh",this);

	if(ahb_cfg.is_active==UVM_ACTIVE)
	begin
		drvh=bridge_ahb_driver::type_id::create("drvh",this);
		seqrh=bridge_ahb_sequencer::type_id::create("seqrh",this);
	end

endfunction:build_phase

//connect phase
function void bridge_ahb_agent::connect_phase(uvm_phase phase);
	if(ahb_cfg.is_active)
		drvh.seq_item_port.connect(seqrh.seq_item_export);

endfunction:connect_phase

