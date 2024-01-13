class ahb_xtn extends uvm_sequence_item;

	//Factory Registration
	`uvm_object_utils(ahb_xtn);

        //Properties
	rand bit hwrite;
	rand bit[31:0]haddr;
	rand bit[2:0]hsize;
	rand bit[31:0]hwdata;
	rand bit[1:0]htrans;
	 bit[31:0]hrdata;
	rand bit[2:0]hburst;
	rand bit[9:0]length;
	bit hresetn;
	bit hready_out;
	bit hready_in;
	bit [1:0]hresp;

	//constraints
	constraint valid_hsize{hsize inside{[0:2]};}
	constraint valid_length{(2**hsize)*length <=1024;}
	constraint valid_haddr{hsize==1 -> haddr%2==0;
				hsize==2 -> haddr%4==0;}
	constraint valid_Haddr1 {haddr inside {[32'h8000_0000 : 32'h8000_03ff],
					       [32'h8400_0000 : 32'h8400_03ff],
				       	       [32'h8800_0000 : 32'h8800_03ff],
				       	       [32'h8c00_0000 : 32'h8c00_03ff]};}//4 Slaves 								
	constraint hsize_count{hsize dist{3'b000:=3, 3'b001:=3, 3'b010:=3};}
				
//	constraint hwrite_range{hwrite dist{1:=10,0:=10};}
	
		//------------------------------------------
		// Methods
		//------------------------------------------
		// Standard UVM Methods:
	extern function new(string name="ahb_xtn");
	extern function void do_print(uvm_printer printer);
	
endclass:ahb_xtn

		//Constructor-new
function ahb_xtn::new(string name="ahb_xtn");
	super.new(name);
endfunction:new

function  void ahb_xtn::do_print(uvm_printer printer);
	super.do_print(printer);

	printer.print_field("HADDR", this.haddr,32,UVM_HEX);
	printer.print_field("Hwdata", this.hwdata,32,UVM_HEX);
	printer.print_field("Hwrite", this.hwrite,1,UVM_DEC);
	printer.print_field("Htrans", this.htrans,2,UVM_DEC);
	 printer.print_field("Hsize", this.hsize,2,UVM_DEC);
	 printer.print_field("Hburst", this.hburst,3,UVM_DEC);
	 printer.print_field("Hrdata", this.hrdata,32,UVM_HEX);
	printer.print_field("Hready_out", this.hready_out,1,UVM_DEC);
	printer.print_field("Hready_in", this.hready_in,1,UVM_DEC);
	printer.print_field("Hresetn", this.hresetn,1,UVM_DEC);
	printer.print_field("Hresp", this.hresp,2,UVM_DEC);

endfunction:do_print






