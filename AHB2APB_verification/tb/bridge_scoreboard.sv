class bridge_scoreboard extends uvm_scoreboard;

	//Factory Registration
	`uvm_component_utils(bridge_scoreboard)

        //Properties
	//fifo for storing transfer
	uvm_tlm_analysis_fifo #(ahb_xtn)fifo_ahb[];
	uvm_tlm_analysis_fifo #(apb_xtn)fifo_apb[];
		
	//xtn handle 
	ahb_xtn ahb_data;
	apb_xtn apb_data;

	//handles for coverage data	
	ahb_xtn ahb_cov_data;
	apb_xtn apb_cov_data;

	//env config
	bridge_env_config env_cfg;

	//variables to track comparison	
	static int data_verified=0;
	static int data_dropped=0;
	static int ahb_data_count=0;
	static int apb_data_count=0;

	//queue for address latch concept
	ahb_xtn q[$];

	//covergroup
	covergroup cg_ahb_cov;
                option.per_instance=1;

		WRITE: coverpoint ahb_cov_data.hwrite;
                ADDR: coverpoint ahb_cov_data.haddr{ bins slave1 = {[32'h8000_0000 : 32'h8000_03ff]};
                                                     bins slave2 = {[32'h8400_0000 : 32'h8400_03ff]};
                                                    bins  slave3 = {[32'h8800_0000 : 32'h8800_03ff]};
                                                     bins slave4 = {[32'h8c00_0000 : 32'h8c00_03ff]};}
                SIZE: coverpoint ahb_cov_data.hsize{bins size1[] = {[0:2]};}
                TRANS: coverpoint ahb_cov_data.htrans { bins b1[] = {[2:3]};}
                WDATA: coverpoint ahb_cov_data.hwdata { bins small_data = {[0:32'h8c00_03ff]};
                                                        bins large_data = {[32'h8c00_03ff:32'hffff_ffff]};}
                RDATA: coverpoint ahb_cov_data.hrdata {bins data1 = {[0:32'hffff_ffff]};}
                HREADY_OUT : coverpoint ahb_cov_data.hready_out;
             //   HREADY_IN : coverpoint ahb_cov_data.hready_in;

		sizexwrite : cross SIZE,WRITE;
				
        endgroup:cg_ahb_cov

        covergroup cg_apb_cov;
                option.per_instance=1;

                PSELX: coverpoint apb_cov_data.pselx { bins s2 = {[0:3]};}
                PENABLE: coverpoint apb_cov_data.penable;
                PWRITE: coverpoint apb_cov_data.pwrite;
                PADDR: coverpoint apb_cov_data.paddr{ bins slave_1 = {[32'h8000_0000 : 32'h8000_03ff]};
                                                     bins slave_2 = {[32'h8400_0000 : 32'h8400_03ff]};
                                                    bins  slave_3 = {[32'h8800_0000 : 32'h8800_03ff]};
                                                     bins slave_4 = {[32'h8c00_0000 : 32'h8c00_03ff]};}
                PWDATA: coverpoint apb_cov_data.pwdata { bins small_pkt = {[0:32'h8c00_03ff]};
                                                        bins large_pkt = {[32'h8c00_03ff:32'hffff_ffff]};}
		PRDATA: coverpoint apb_cov_data.prdata { bins data2 = {[0:32'hffff_ffff]};}
				
		pwritexpsel : cross PWRITE,PSELX;
				
	endgroup:cg_apb_cov

		//------------------------------------------
		// Methods
		//------------------------------------------
		// Standard UVM Methods:
	extern function new(string name="bridge_scoreboard",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task compare_data(int hdata,int pdata, int Haddr, int Paddr);
	extern task ref_model(apb_xtn xtn);
	extern function void report_phase(uvm_phase phase);

endclass:bridge_scoreboard

		//Constructor-new
function bridge_scoreboard::new(string name="bridge_scoreboard",uvm_component parent);
	super.new(name,parent);
	ahb_cov_data=new();
	apb_cov_data = new();
	cg_ahb_cov = new();
	cg_apb_cov = new();
endfunction:new

//build phase
function void bridge_scoreboard::build_phase(uvm_phase phase);
	
	if(!uvm_config_db #(bridge_env_config)::get(this,"","bridge_env_config",env_cfg))
		`uvm_fatal("SB","env_config is not get")

	super.build_phase(phase);

	fifo_ahb=new[env_cfg.no_of_ahb_agts];
	fifo_apb=new[env_cfg.no_of_apb_agts];

	foreach(fifo_ahb[i])
		fifo_ahb[i]=new($sformatf("fifo_ahb[%0d]",i),this);
	
	foreach(fifo_apb[i])
		fifo_apb[i]=new($sformatf("fifo_apb[%0d]",i),this);

endfunction:build_phase

//run phase
task bridge_scoreboard::run_phase(uvm_phase phase);
	fork
	begin
		forever
		begin
			fifo_ahb[0].get(ahb_data);
			q.push_back(ahb_data);
			ahb_data_count++;
			ahb_cov_data = ahb_data;
			cg_ahb_cov.sample();
			$display("AHB coverage=%f",cg_ahb_cov.get_coverage());		
		end
	end

	begin
		forever
		begin
			fifo_apb[0].get(apb_data);
			apb_data_count++;
			ref_model(apb_data);
			apb_cov_data = apb_data;
			cg_apb_cov.sample();
			$display("APB coverage=%f",cg_apb_cov.get_coverage());
		end
	end
	join

endtask:run_phase


//ref model
task bridge_scoreboard::ref_model(apb_xtn xtn);
	
	ahb_data = q.pop_front();

	if(ahb_data.hwrite==1)
	begin
		case(ahb_data.hsize)
			2'b00 : begin
				if(ahb_data.haddr[1:0]==2'b00)
					compare_data(ahb_data.hwdata[7:0],apb_data.pwdata[7:0],ahb_data.haddr,apb_data.paddr);
				if(ahb_data.haddr[1:0]==2'b01)
					compare_data(ahb_data.hwdata[15:8],apb_data.pwdata[7:0],ahb_data.haddr,apb_data.paddr);
				if(ahb_data.haddr[1:0]==2'b10)
					compare_data(ahb_data.hwdata[23:16],apb_data.pwdata[7:0],ahb_data.haddr,apb_data.paddr);
				if(ahb_data.haddr[1:0]==2'b11)
					compare_data(ahb_data.hwdata[31:24],apb_data.pwdata[7:0],ahb_data.haddr,apb_data.paddr);
				end
	
			2'b01: begin
				if(ahb_data.haddr[1:0]==2'b00)
					compare_data(ahb_data.hwdata[15:0],apb_data.pwdata[15:0],ahb_data.haddr,apb_data.paddr);
				if(ahb_data.haddr[1:0]==2'b01)
					compare_data(ahb_data.hwdata[31:16],apb_data.pwdata[15:0],ahb_data.haddr,apb_data.paddr);
				end

			2'b10: begin
				compare_data(ahb_data.hwdata,apb_data.pwdata,ahb_data.haddr,apb_data.paddr);
				end		
		endcase
	end

	else 
	begin
		case(ahb_data.hsize)
			2'b00 :begin
				if(ahb_data.haddr[1:0]==2'b00)
					compare_data(ahb_data.hrdata[7:0],apb_data.prdata[7:0],ahb_data.haddr,apb_data.paddr);
				if(ahb_data.haddr[1:0]==2'b01)
					compare_data(ahb_data.hrdata[7:0],apb_data.prdata[15:8],ahb_data.haddr,apb_data.paddr);
				if(ahb_data.haddr[1:0]==2'b10)
					compare_data(ahb_data.hrdata[7:0],apb_data.prdata[23:16],ahb_data.haddr,apb_data.paddr);
				if(ahb_data.haddr[1:0]==2'b11)
					compare_data(ahb_data.hrdata[7:0],apb_data.prdata[31:24],ahb_data.haddr,apb_data.paddr);
				end

			
			2'b01: begin
				if(ahb_data.haddr[1:0]==2'b00)
					compare_data(ahb_data.hrdata[15:0],apb_data.prdata[15:0],ahb_data.haddr,apb_data.paddr);
				if(ahb_data.haddr[1:0]==2'b01)
					compare_data(ahb_data.hrdata[15:0],apb_data.prdata[15:0],ahb_data.haddr,apb_data.paddr);
				end

			2'b10: begin
				if(ahb_data.haddr[1:0]==2'b00)
					compare_data(ahb_data.hrdata[31:0],apb_data.prdata[31:0],ahb_data.haddr,apb_data.paddr);
				end
		endcase
	end
endtask:ref_model


//compare logic
task bridge_scoreboard::compare_data(int hdata, int pdata, int Haddr, int Paddr);
		
	if(Haddr==Paddr)
	begin
		`uvm_info("SB","Addr is compared successfully",UVM_LOW)
	end
	else
		`uvm_info("SB","Addr not compared successfully",UVM_LOW)
	
	if(hdata==pdata)
	begin
		`uvm_info("SB","Data is compared successfully",UVM_LOW)
		data_verified++;
	end
	else
	begin
		data_dropped++;
		`uvm_info("SB","Data not compared successfully",UVM_LOW)
	end
	//data_verified++;

	$display("\n HDATA=%0h,PDATA=%0h,PADDR=%0h, HADDR=%0h",hdata,pdata,Paddr,Haddr); 

endtask:compare_data

//report phase
function void bridge_scoreboard::report_phase(uvm_phase phase);
	`uvm_info("SB", $sformatf("Report Phase: \n ahb_data_count=%0d \n apb_data_count=%0d \n data_verified=%0d \n data_dropped=%0d",ahb_data_count,apb_data_count,data_verified,data_dropped),UVM_LOW)
endfunction:report_phase

