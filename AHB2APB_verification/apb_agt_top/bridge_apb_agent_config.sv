class bridge_apb_agent_config extends uvm_object;

	//Factory Registration
	`uvm_object_utils(bridge_apb_agent_config)

        //Properties
	virtual apb_if pvif;

	uvm_active_passive_enum is_active=UVM_ACTIVE;


	static int apb_drv_data_count=0;
	 int apb_mon_data_count=0;
		
		//------------------------------------------
		// Methods
		//------------------------------------------
		// Standard UVM Methods:
	extern function new(string name="bridge_apb_agent_config");

endclass:bridge_apb_agent_config

		//Constructor-new
function bridge_apb_agent_config::new(string name="bridge_apb_agent_config");
	super.new(name);
endfunction:new





