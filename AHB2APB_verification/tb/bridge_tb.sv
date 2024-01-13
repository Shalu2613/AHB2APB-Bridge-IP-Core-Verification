class bridge_tb extends uvm_env;

		//Factory Registration
	`uvm_component_utils(bridge_tb)

        //Properties
	bridge_ahb_agt_top hagt_top;		
	bridge_apb_agt_top pagt_top;

	bridge_env_config env_cfg;
	
	bridge_scoreboard sb_h;

	bridge_virtual_sequencer vseqrh;

		//------------------------------------------
		// Methods
		//------------------------------------------
		// Standard UVM Methods:
	extern function new(string name="bridge_tb",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);

endclass:bridge_tb

		//Constructor-new
function bridge_tb::new(string name="bridge_tb",uvm_component parent);		 
	super.new(name,parent);
endfunction:new

        //Build phase
function void bridge_tb::build_phase(uvm_phase phase);
	if(!uvm_config_db #(bridge_env_config)::get(this,"","bridge_env_config",env_cfg))
		`uvm_fatal("CONFIG","cannot get() env_cfg from uvm_config_db. Have you set() it?")

	if(env_cfg.has_ahb_agent)
	begin
		hagt_top=bridge_ahb_agt_top::type_id::create("hagt_top",this);
	end

	if(env_cfg.has_apb_agent)
	begin
		pagt_top=bridge_apb_agt_top::type_id::create("pagt_top",this);
	end

	super.build_phase(phase);

	if(env_cfg.has_scoreboard)
		sb_h=bridge_scoreboard::type_id::create("sb_h",this);

	if(env_cfg.has_virtual_sequencer)
		vseqrh=bridge_virtual_sequencer::type_id::create("vseqrh",this);

endfunction:build_phase
		
		//Connect phase
function void bridge_tb::connect_phase(uvm_phase phase);

	if(env_cfg.has_virtual_sequencer)
                begin
            if(env_cfg.has_ahb_agent)
		begin
                              /*  foreach(env_cfg.no_of_ahb_agts)
                                begin
                                       vseqrh.ahb_seqrh[i] = hagt_top.agnth[i].seqrh;               
                                end */
			vseqrh.ahb_seqrh[0]=hagt_top.agnth[0].seqrh;
		end

		if(env_cfg.has_apb_agent)
                                begin
                                 //       foreach(pagt_top.agnth[i])
                                   //             vseqrh.apb_seqrh[i] = pagt_top.agnth[i].seqrh;
               				vseqrh.apb_seqrh[0]=pagt_top.agnth[0].seqrh;
				 end

                      end

	if(env_cfg.has_scoreboard)
	begin
		if(env_cfg.has_ahb_agent)
		begin
			foreach(env_cfg.ahb_cfg[i])
			begin
				hagt_top.agnth[i].monh.monitor_port.connect(sb_h.fifo_ahb[i].analysis_export);
			end
		end

		if(env_cfg.has_apb_agent)
		begin
			foreach(env_cfg.apb_cfg[i])
			begin
				pagt_top.agnth[i].monh.monitor_port.connect(sb_h.fifo_apb[i].analysis_export);
			end
		end
	end

endfunction:connect_phase










