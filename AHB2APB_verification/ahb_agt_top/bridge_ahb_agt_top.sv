class bridge_ahb_agt_top extends uvm_env;

	//Factory Registration
	`uvm_component_utils(bridge_ahb_agt_top)

        //Properties
	bridge_ahb_agent agnth[];

	bridge_env_config env_cfg;
			
		//------------------------------------------
		// Methods
		//------------------------------------------
		// Standard UVM Methods:
	extern function new(string name="bridge_ahb_agt_top",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void start_of_simulation_phase(uvm_phase phase);

endclass:bridge_ahb_agt_top

		//Constructor-new
function bridge_ahb_agt_top::new(string name="bridge_ahb_agt_top",uvm_component parent);
	super.new(name,parent);
endfunction:new

        //Build phase
function void bridge_ahb_agt_top::build_phase(uvm_phase phase);
	if(! uvm_config_db #(bridge_env_config)::get(this,"","bridge_env_config",env_cfg))
		`uvm_fatal("AHB_AGT_TOP","cannot get()interface env_cfg from uvm_config_db. Have you set() it?")
	super.build_phase(phase);

	agnth=new[env_cfg.no_of_ahb_agts];

	foreach(agnth[i])
	begin
		agnth[i]=bridge_ahb_agent::type_id::create($sformatf("agnth[%0d]",i),this);
		uvm_config_db #(bridge_ahb_agent_config)::set(this,$sformatf("agnth[%0d]*",i),"bridge_ahb_agent_config",env_cfg.ahb_cfg[i]);
	end

endfunction:build_phase

// start_of_simulation_phase
function void bridge_ahb_agt_top::start_of_simulation_phase(uvm_phase phase);
	uvm_top.print_topology();
endfunction:start_of_simulation_phase








