class bridge_ahb_sequencer extends uvm_sequencer #(ahb_xtn);

	//Factory Registration
	`uvm_component_utils(bridge_ahb_sequencer)
		
		//------------------------------------------
		// Methods
		//------------------------------------------
		// Standard UVM Methods:
	extern function new(string name="bridge_ahb_sequencer",uvm_component parent);

endclass:bridge_ahb_sequencer

		//Constructor-new
function bridge_ahb_sequencer::new(string name="bridge_ahb_sequencer",uvm_component parent);
	super.new(name,parent);
endfunction:new

