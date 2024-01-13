class bridge_env_config extends uvm_object;

	//Factory Registration
	`uvm_object_utils(bridge_env_config)

        //Properties
	int has_ahb_agent=1;
        int has_apb_agent=1;
      
	  int no_of_ahb_agts=1;
        int no_of_apb_agts=1;

        int has_virtual_sequencer=1;
	int has_scoreboard=1;

        bridge_ahb_agent_config ahb_cfg[];
        bridge_apb_agent_config apb_cfg[];
		
		//------------------------------------------
		// Methods
		//------------------------------------------
		// Standard UVM Methods:
	extern function new(string name="bridge_env_config");
endclass:bridge_env_config

		//Constructor-new
function bridge_env_config::new(string name="bridge_env_config");
	super.new(name);
endfunction:new

