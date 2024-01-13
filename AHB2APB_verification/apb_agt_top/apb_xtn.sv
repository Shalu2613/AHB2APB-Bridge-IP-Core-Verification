class apb_xtn extends uvm_sequence_item;

			//Factory Registration
	`uvm_object_utils(apb_xtn)

        //Properties
	bit [3:0]pselx;
	bit penable;
	bit pwrite;
	rand  bit [31:0]prdata;
	 bit [31:0]pwdata;
	bit [31:0]paddr;
	
//	constraint pselx_count{pselx dist{4'b0001:=4, 4'b0010:=4, 4'b0100:=4, 4'b1000:=4};}
	
		//------------------------------------------
		// Methods
		//------------------------------------------
		// Standard UVM Methods:
	extern function new(string name="apb_xtn");
	extern function void do_print(uvm_printer printer);

endclass:apb_xtn

		//Constructor-new
function apb_xtn::new(string name="apb_xtn");
	super.new(name);
endfunction:new


//do print method 
function void apb_xtn::do_print(uvm_printer printer);
	
	printer.print_field("Pselx",this.pselx,4,UVM_BIN);
	printer.print_field("Pwrite",this.pwrite,1,UVM_BIN);
	printer.print_field("Penable",this.penable,1,UVM_BIN);
	printer.print_field("Prdata", this.prdata, 32, UVM_HEX);
	printer.print_field("Pwdata", this.pwdata, 32, UVM_HEX);
	printer.print_field("Paddr", this.paddr, 32, UVM_HEX);

	super.do_print(printer);

endfunction:do_print


