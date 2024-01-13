class bridge_base_test extends uvm_test;

	//Factory Registration
	`uvm_component_utils(bridge_base_test)

        //Properties
	int has_ahb_agent=1;
	int has_apb_agent=1;
	int no_of_ahb_agts=1;
	int no_of_apb_agts=1;

	int has_virtual_sequencer=1;
	int has_scoreboard=1;

	bridge_ahb_agent_config ahb_cfg[];
	bridge_apb_agent_config apb_cfg[];
	bridge_env_config env_cfg;
	
	bridge_tb env_h;

	uvm_active_passive_enum is_active;
	
		//------------------------------------------
		// Methods
		//------------------------------------------
		// Standard UVM Methods:
	extern function new(string name="bridge_base_test",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void config_bridge();

endclass:bridge_base_test

	//Constructor-new
	function bridge_base_test::new(string name="bridge_base_test",uvm_component parent);
		super.new(name,parent);
	endfunction:new
		 
        //Build phase
	function void bridge_base_test::build_phase(uvm_phase phase);		
		super.build_phase(phase);
	
		env_cfg = bridge_env_config::type_id::create("env_cfg");
	
		if(has_ahb_agent)
		begin
			ahb_cfg=new[no_of_ahb_agts];
			
			foreach(ahb_cfg[i])
				ahb_cfg[i]=bridge_ahb_agent_config::type_id::create($sformatf("ahb_cfg[%0d]",i));
		end

		if(has_apb_agent)
                begin
                        apb_cfg=new[no_of_apb_agts];

                        foreach(apb_cfg[i])
                                apb_cfg[i]=bridge_apb_agent_config::type_id::create($sformatf("apb_cfg[%0d]",i));
                end
		
		config_bridge();

		env_h=bridge_tb::type_id::create("env_h",this);
	endfunction:build_phase

	function void bridge_base_test::config_bridge();
		if(has_ahb_agent)
		begin
			env_cfg.ahb_cfg=new[no_of_ahb_agts];
	
			for(int i=0; i<no_of_ahb_agts; i++)
			begin
				is_active=UVM_ACTIVE;

				if(!uvm_config_db #(virtual ahb_if)::get(this,"","hvif",ahb_cfg[i].hvif))
					`uvm_fatal("VIF CONFIG","cannot get()interface hvif from uvm_config_db. Have you set() it?")
		
				env_cfg.ahb_cfg[i]=ahb_cfg[i];
			end
		end
	
		if(has_apb_agent)
                begin
                        env_cfg.apb_cfg=new[no_of_apb_agts];

                        for(int i=0; i<no_of_apb_agts; i++)
                        begin
                                is_active=UVM_ACTIVE;

                                if(!uvm_config_db #(virtual apb_if)::get(this,"","pvif",apb_cfg[i].pvif))
                                        `uvm_fatal("VIF CONFIG","cannot get()interface pvif from uvm_config_db. Have you set() it?")
                
			env_cfg.apb_cfg[i]=apb_cfg[i];
                	end
		end

		env_cfg.has_ahb_agent=has_ahb_agent;
		env_cfg.has_apb_agent=has_apb_agent;

		env_cfg.no_of_ahb_agts=no_of_ahb_agts;
		env_cfg.no_of_apb_agts=no_of_apb_agts;

		env_cfg.has_virtual_sequencer=has_virtual_sequencer;
		env_cfg.has_scoreboard=has_scoreboard;

		uvm_config_db #(bridge_env_config) ::set(this, "*","bridge_env_config",env_cfg);

	endfunction:config_bridge

//---------------------------bridge_rand_test-----------------------------------------------//
class bridge_rand_test extends bridge_base_test;
	            
		//Factory Registration
	`uvm_component_utils(bridge_rand_test)

        //Properties
	bridge_virtual_single_seqs single_vseqh;
	
		//------------------------------------------
		// Methods
		//------------------------------------------
		// Standard UVM Methods:
	extern function new(string name="bridge_rand_test",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);

endclass:bridge_rand_test

		//Constructor-new
function bridge_rand_test::new(string name="bridge_rand_test",uvm_component parent);
	super.new(name,parent);
endfunction:new

//build phase
function void bridge_rand_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction:build_phase

//run phase
task bridge_rand_test::run_phase(uvm_phase phase);
	
	phase.raise_objection(this);
	
	single_vseqh=bridge_virtual_single_seqs::type_id::create("single_vseqh");
	single_vseqh.start(env_h.vseqrh);
//	vseqh.start(env_h.hagt_top.agnth[0].seqrh);
//	$display("vseq started in vseqr");	
	//#50;
	phase.drop_objection(this);

endtask:run_phase


//---------------------------bridge_medium_test-----------------------------------------------//
class bridge_medium_test extends bridge_base_test;

                //Factory Registration
        `uvm_component_utils(bridge_medium_test)

        //Properties
        bridge_virtual_wrap_incr_seqs wrap_incr_vseqh;

                //------------------------------------------
                // Methods
                //------------------------------------------
                // Standard UVM Methods:
        extern function new(string name="bridge_medium_test",uvm_component parent);
        extern function void build_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);

endclass:bridge_medium_test

                //Constructor-new
function bridge_medium_test::new(string name="bridge_medium_test",uvm_component parent);
        super.new(name,parent);
endfunction:new

//build phase
function void bridge_medium_test::build_phase(uvm_phase phase);
        super.build_phase(phase);
endfunction:build_phase

//run phase
task bridge_medium_test::run_phase(uvm_phase phase);

        phase.raise_objection(this);

        wrap_incr_vseqh=bridge_virtual_wrap_incr_seqs::type_id::create("wrap_incr_vseqh");
        #50;
	wrap_incr_vseqh.start(env_h.vseqrh);
//      vseqh.start(env_h.hagt_top.agnth[0].seqrh);
//        $display("vseq started in vseqr");
        #50;
        phase.drop_objection(this);

endtask:run_phase

//---------------------------bridge_medium_test-----------------------------------------------//
class bridge_big_test extends bridge_base_test;

                //Factory Registration
        `uvm_component_utils(bridge_big_test)

        //Properties
        bridge_virtual_unspec_length_seqs unspec_vseqh;

                //------------------------------------------
                // Methods
                //------------------------------------------
                // Standard UVM Methods:
        extern function new(string name="bridge_big_test",uvm_component parent);
        extern function void build_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);

endclass:bridge_big_test

                //Constructor-new
function bridge_big_test::new(string name="bridge_big_test",uvm_component parent);
        super.new(name,parent);
endfunction:new

//build phase
function void bridge_big_test::build_phase(uvm_phase phase);
        super.build_phase(phase);
endfunction:build_phase

//run phase
task bridge_big_test::run_phase(uvm_phase phase);

        phase.raise_objection(this);

        unspec_vseqh=bridge_virtual_unspec_length_seqs::type_id::create("unspec__vseqh");
	#50;
	$display("befort start of seq");
        unspec_vseqh.start(env_h.vseqrh);
//      vseqh.start(env_h.hagt_top.agnth[0].seqrh);
//        $display("vseq started in vseqr");
        #50;
        phase.drop_objection(this);

endtask:run_phase






