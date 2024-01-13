module top;

	import uvm_pkg::*;
	import bridge_test_pkg::*;

	bit clk;

	always
		#10 clk=~clk;

	ahb_if in0(clk);
	apb_if in1(clk);

	//design
	rtl_top  DUV( .Hclk(clk),
              .Hresetn(in0.hresetn), .Htrans(in0.htrans),
              .Hsize(in0.hsize), .Hreadyin(in0.hready_in),
              .Hwdata(in0.hwdata), .Haddr(in0.haddr),
              .Hwrite(in0.hwrite), .Prdata(in1.prdata),
              .Hrdata(in0.hrdata), .Hresp(in0.hresp),
              .Hreadyout(in0.hready_out), .Pselx(in1.pselx),
              .Pwrite(in1.pwrite), .Penable(in1.penable),
			  .Paddr(in1.paddr), .Pwdata(in1.pwdata)) ;	

	initial
	begin

		uvm_config_db #(virtual ahb_if)::set(null,"*","hvif",in0);
		uvm_config_db #(virtual apb_if)::set(null, "*", "pvif", in1);

		run_test();
	end

endmodule

