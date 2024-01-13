class bridge_ahb_base_seq extends uvm_sequence #(ahb_xtn);

	//Factory Registration
	`uvm_object_utils(bridge_ahb_base_seq)

	logic [31:0]Haddr;
	logic Hwrite;
	logic [2:0]Hburst;
	logic [2:0]Hsize;
		
		//------------------------------------------
		// Methods
		//------------------------------------------
		// Standard UVM Methods:
	extern function new(string name ="bridge_ahb_base_seq");

endclass:bridge_ahb_base_seq

		//Constructor-new
function bridge_ahb_base_seq::new(string name ="bridge_ahb_base_seq");
	super.new(name);
endfunction:new

//--------------------------single transfer sequence---------------------------//

class bridge_ahb_single_seq extends bridge_ahb_base_seq;

	`uvm_object_utils(bridge_ahb_single_seq)

	
	extern function new(string name="bridge_ahb_single_seq");
	extern task body();

endclass:bridge_ahb_single_seq

function bridge_ahb_single_seq::new(string name="bridge_ahb_single_seq");
	super.new(name);
endfunction:new

task bridge_ahb_single_seq::body();
	
	req=ahb_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize() with {htrans==2'b10;
					hburst==3'b0;
					hwrite==1;});

	finish_item(req);

	Haddr=req.haddr;
        Hsize=req.hsize;
        Hwrite=req.hwrite;
        Hburst=req.hburst;

endtask:body

//--------------------------increment transfer sequence-----------------------------//

class bridge_ahb_wrap_incr_seq extends bridge_ahb_base_seq;
	
	`uvm_object_utils(bridge_ahb_wrap_incr_seq)

	extern function new(string name="bridge_ahb_wrap_incr_seq");
	extern task body();

endclass:bridge_ahb_wrap_incr_seq

function bridge_ahb_wrap_incr_seq::new(string name="bridge_ahb_wrap_incr_seq");
	super.new(name);
endfunction:new

task bridge_ahb_wrap_incr_seq::body;


//	repeat(5)
//	begin	
		req=ahb_xtn::type_id::create("req");
					
	 start_item(req);
                assert(req.randomize() with{htrans==2'b10;
                                        hburst inside{[2:7]};
                                        hwrite==1'b1;});

        finish_item(req);

	 Haddr=req.haddr;
        Hburst=req.hburst;
        Hwrite=req.hwrite;
        Hsize=req.hsize;

	
	//incr4
	if(Hburst==3'b011)
	begin
		for(int i=0;i<3;i++)
		begin
			start_item(req);
			if(Hsize==0)
			begin
				assert(req.randomize() with {hsize==Hsize && 
								hwrite==Hwrite &&
								hburst==Hburst&&
								htrans==2'b11&&
								haddr==Haddr+1'b1;});
			end
			if(Hsize==1)
			begin
				assert(req.randomize() with {hsize==Hsize&&
                                                                hwrite==Hwrite&&
                                                                hburst==Hburst&&
                                                                htrans==2'b11&&
                                                                haddr==Haddr+2'b10;});
                        end
			if(Hsize==2)
                        begin
                                assert(req.randomize() with {hsize==Hsize&&
                                                                hwrite==Hwrite&&
                                                                hburst==Hburst&&
                                                                htrans==2'b11&&
                                                                haddr==Haddr+3'b100;});
                        end
			finish_item(req);
			
			Haddr=req.haddr;

		end
	end

	//incr8
	if(Hburst==3'b101)
	begin
		for(int i=0; i<7; i++)
		begin
			 start_item(req);
			if(Hsize==0)
			begin
				assert(req.randomize() with {hsize==Hsize&&
                                                                hwrite==Hwrite&&
                                                                hburst==Hburst&&
                                                                htrans==2'b11&&
                                                                haddr==Haddr+1'b1;});
                        end
				
			if(Hsize==1)
                        begin
                                assert(req.randomize() with {hsize==Hsize&&
                                                                hwrite==Hwrite &&
                                                                hburst==Hburst &&
                                                                htrans==2'b11 &&
                                                                haddr==Haddr+2'b10;});
                        end
                        if(Hsize==2)
                        begin
                                assert(req.randomize() with {hsize==Hsize &&
                                                                hwrite==Hwrite &&
                                                                hburst==Hburst &&
                                                                htrans==2'b11 &&
                                                                haddr == Haddr+3'b100;});
                        end
                        finish_item(req);

                        Haddr=req.haddr;

                end
        end


 //incr16
	if(Hburst==3'b111)
        begin
                for(int i=0; i<15; i++)
                begin
			 start_item(req);
                        if(Hsize==0)
                        begin
                                assert(req.randomize() with {hsize==Hsize &&
                                                                hwrite==Hwrite &&
                                                                hburst==Hburst &&
                                                                htrans==2'b11 &&
                                                                haddr==Haddr+1'b1;});
                        end

                        if(Hsize==1)
                        begin
                                assert(req.randomize() with {hsize==Hsize&&
                                                                hwrite==Hwrite&&
                                                                hburst==Hburst&&
                                                                htrans==2'b11 &&
                                                                haddr==Haddr+2'b10;});
                        end
                        if(Hsize==2)
                        begin
                                assert(req.randomize() with {hsize==Hsize &&
                                                                hwrite==Hwrite &&
                                                                hburst==Hburst &&
                                                                htrans==2'b11 &&
                                                                haddr==Haddr+3'b100;});
                        end
                        finish_item(req);

                        Haddr=req.haddr;

                end
        end


//wrap4
 
	if(Hburst==3'b010)
        begin
                for(int i=0; i<3; i++)
                begin
			 start_item(req);
                        if(Hsize==2'b00)
                        begin
                                assert(req.randomize() with {hsize==Hsize;
                                                                hwrite==Hwrite;
                                                                hburst==Hburst;
                                                                htrans==2'b11;
                                                                haddr=={Haddr[31:2],Haddr[1:0]+1'b1};});
                        end

                        if(Hsize==2'b01)
                        begin
                                assert(req.randomize() with {hsize==Hsize;
                                                                hwrite==Hwrite;
                                                                hburst==Hburst;
                                                                htrans==2'b11;
                                                                haddr=={Haddr[31:3],Haddr[2:0]+2'b10};});
                        end
                        if(Hsize==2'b10)
                        begin
                                assert(req.randomize() with {hsize==Hsize;
                                                                hwrite==Hwrite;
                                                                hburst==Hburst;
                                                                htrans==2'b11;
                                                                haddr=={Haddr[31:4],Haddr[3:0]+3'b100};});
                        end
                        finish_item(req);

                        Haddr=req.haddr;

                end
        end

 //wrap8
	if(Hburst==3'b100)
        begin
                for(int i=0; i<7; i++)
                begin
			 start_item(req);
                        if(Hsize==2'b00)
                        begin
                                assert(req.randomize() with {hsize==Hsize;
                                                                hwrite==Hwrite;
                                                                hburst==Hburst;
                                                                htrans==2'b11;
                                                                haddr=={Haddr[31:3],Haddr[2:0]+1'b1};});
                        end

                        if(Hsize==2'b01)
                        begin
                                assert(req.randomize() with {hsize==Hsize;
                                                                hwrite==Hwrite;
                                                                hburst==Hburst;
                                                                htrans==2'b11;
                                                                haddr=={Haddr[31:4],Haddr[3:0]+2'b10};});
                        end
                        if(Hsize==2'b10)
                        begin
                                assert(req.randomize() with {hsize==Hsize;
                                                                hwrite==Hwrite;
                                                                hburst==Hburst;
                                                                htrans==2'b11;
                                                                haddr=={Haddr[31:5],Haddr[4:0]+3'b100};});
                        end
                        finish_item(req);

                        Haddr=req.haddr;

                end
        end

 //wrap16
	if(Hburst==3'b110)
        begin
                for(int i=0; i<15; i++)
                begin
			 start_item(req);
                        if(Hsize==2'b00)
                        begin
                                assert(req.randomize() with {hsize==Hsize;
                                                                hwrite==Hwrite;
                                                                hburst==Hburst;
                                                                htrans==2'b11;
                                                                haddr=={Haddr[31:4],Haddr[3:0]+1'b1};});
                        end

                        if(Hsize==2'b01)
                        begin
                                assert(req.randomize() with {hsize==Hsize;
                                                                hwrite==Hwrite;
                                                                hburst==Hburst;
                                                                htrans==2'b11;
                                                                haddr=={Haddr[31:5],Haddr[4:0]+2'b10};});
                        end
                        if(Hsize==2'b10)
                        begin
                                assert(req.randomize() with {hsize==Hsize;
                                                                hwrite==Hwrite;
                                                                hburst==Hburst;
                                                                htrans==2'b11;
                                                                haddr=={Haddr[31:6],Haddr[5:0]+3'b100};});
                        end
                        finish_item(req);

                        Haddr=req.haddr;

                end
        end

//	end

endtask


//-----------------------unspecified length-------------------------------------------------//

class  bridge_ahb_unspec_length_seq   extends bridge_ahb_base_seq;

	`uvm_object_utils(bridge_ahb_unspec_length_seq)

	extern function new(string name="bridge_ahb_unspec_length_seq");
	extern task body();

endclass:bridge_ahb_unspec_length_seq

function bridge_ahb_unspec_length_seq::new(string name="bridge_ahb_unspec_length_seq");
	super.new(name);
endfunction:new

task bridge_ahb_unspec_length_seq::body();

//	repeat(5)
//	begin
		 req=ahb_xtn::type_id::create("req");
	        start_item(req);
	        assert(req.randomize() with{htrans==2'b10;
                                //        hburst inside{0,1};
                                  	hburst==1;
					      hwrite==1'b1;
					});

		finish_item(req);
	Haddr=req.haddr;
	Hsize=req.hsize;
	Hwrite=req.hwrite;
	Hburst=req.hburst;

	//incr-unspecified length
	if(Hburst==3'b001)
        begin
                for(int i=0;i<req.length;i++)
                begin
                        start_item(req);
                        if(Hsize==2'b00)
                        begin
                                assert(req.randomize() with {hsize==Hsize;
                                                                hwrite==Hwrite;
                                                                hburst==Hburst;
                                                                htrans==2'b11;
                                                                haddr==Haddr+1'b1;});
                        end
                        if(Hsize==2'b01)
                        begin
                                assert(req.randomize() with {hsize==Hsize;
                                                                hwrite==Hwrite;
                                                                hburst==Hburst;
                                                                htrans==2'b11;
                                                                haddr==Haddr+2'b10;});
                        end
                        if(Hsize==2'b10)
                        begin
                                assert(req.randomize() with {hsize==Hsize;
                                                                hwrite==Hwrite;
                                                                hburst==Hburst;
                                                                htrans==2'b11;
                                                                haddr==Haddr+3'b100;});
                        end
                        finish_item(req);

                        Haddr=req.haddr;

                end
        end

//	end


endtask:body
