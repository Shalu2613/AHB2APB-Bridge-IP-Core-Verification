class bridge_apb_agt_top extends uvm_env;

	//Factory Registration
	`uvm_component_utils(bridge_apb_agt_top)

        //Properties
	bridge_apb_agent agnth[];

	bridge_env_config env_cfg;
		
		//------------------------------------------
		// Methods
		//------------------------------------------
		// Standard UVM Methods:
	extern function new(string name="bridge_apb_agt_top",uvm_component parent);
	extern function void build_phase(uvm_phase phase);

endclass:bridge_apb_agt_top

		//Constructor-new
function bridge_apb_agt_top::new(string name="bridge_apb_agt_top",uvm_component parent);
	super.new(name,parent);
endfunction:new

//build phase
function void bridge_apb_agt_top::build_phase(uvm_phase phase);
	if(!uvm_config_db #(bridge_env_config)::get(this,"","bridge_env_config",env_cfg))
		`uvm_fatal("APB_AGT_TOP","env_config is not get")

	super.build_phase(phase);

	agnth=new[env_cfg.no_of_apb_agts];

	foreach(agnth[i])
	begin
		agnth[i]=bridge_apb_agent::type_id::create($sformatf("agnth[%0d]",i),this);
		uvm_config_db #(bridge_apb_agent_config)::set(this,$sformatf("agnth[%0d]*",i),"bridge_apb_agent_config",env_cfg.apb_cfg[i]);
	end

endfunction:build_phase

