class bridge_virtual_sequencer extends uvm_sequencer#(uvm_sequence_item);

	//Factory Registration
	`uvm_component_utils(bridge_virtual_sequencer)

        //Properties
	bridge_ahb_sequencer ahb_seqrh[];
	bridge_apb_sequencer apb_seqrh[];

	bridge_env_config env_cfg;
		
		//------------------------------------------
		// Methods
		//------------------------------------------
		// Standard UVM Methods:
	extern function new(string name="bridge_virtual_sequencer",uvm_component parent);
	extern function void build_phase(uvm_phase phase);

endclass:bridge_virtual_sequencer

		//Constructor-new
function bridge_virtual_sequencer::new(string name="bridge_virtual_sequencer",uvm_component parent);
	super.new(name,parent);
endfunction:new

//build phase
function void bridge_virtual_sequencer::build_phase(uvm_phase phase);
	if(!uvm_config_db #(bridge_env_config)::get(this,"","bridge_env_config",env_cfg))
		`uvm_fatal("VSEQR","cannot get() env_cfg from uvm_config_db. Have you set() it?")
    		 super.build_phase(phase);

	ahb_seqrh=new[env_cfg.no_of_ahb_agts];
	apb_seqrh=new[env_cfg.no_of_apb_agts];

endfunction:build_phase

