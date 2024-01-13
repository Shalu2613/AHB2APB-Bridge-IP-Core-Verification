class bridge_apb_base_seq extends uvm_sequence#(apb_xtn);

		//Factory Registration
	`uvm_object_utils(bridge_apb_base_seq)

       		//------------------------------------------
		// Methods
		//------------------------------------------
		// Standard UVM Methods:
	extern function new(string name="bridge_apb_base_seq");

endclass:bridge_apb_base_seq

		//Constructor-new
function bridge_apb_base_seq::new(string name="bridge_apb_base_seq");
	super.new(name);
endfunction:new

//----------------------------------bridge_apb_single_seq-------------------------------------------//

class bridge_apb_single_seq extends bridge_apb_base_seq;

                //Factory Registration
        `uvm_object_utils(bridge_apb_single_seq)

                //------------------------------------------
                // Methods
                //------------------------------------------
                // Standard UVM Methods:
        extern function new(string name="bridge_apb_single_seq");
	extern task body();

endclass:bridge_apb_single_seq

                //Constructor-new
function  bridge_apb_single_seq::new(string name="bridge_apb_single_seq");
        super.new(name);
endfunction:new

//task body
task bridge_apb_single_seq::body();
//	repeat(2) begin	
		req=apb_xtn::type_id::create("req");		
		start_item(req);
		assert(req.randomize());
		finish_item(req);
//	end

endtask:body	
		 





