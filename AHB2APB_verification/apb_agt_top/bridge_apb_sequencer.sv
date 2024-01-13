class bridge_apb_sequencer extends uvm_sequencer #(apb_xtn);

//Factory Registration
	`uvm_component_utils( bridge_apb_sequencer)
		
		//------------------------------------------
		// Methods
		//------------------------------------------
		// Standard UVM Methods:
	extern function new(string name="bridge_apb_sequencer",uvm_component parent);

endclass:bridge_apb_sequencer

		//Constructor-new
function bridge_apb_sequencer::new(string name="bridge_apb_sequencer",uvm_component parent);
	super.new(name,parent);
endfunction:new


