class bridge_virtual_base_seq extends uvm_sequence#(uvm_sequence_item);

	//Factory Registration
	`uvm_object_utils(bridge_virtual_base_seq)

        //Properties
	bridge_ahb_sequencer ahb_seqrh[];
	bridge_apb_sequencer apb_seqrh[];

	bridge_virtual_sequencer vseqrh;

	bridge_env_config env_cfg;

		//------------------------------------------
		// Methods
		//------------------------------------------
		// Standard UVM Methods:
	extern function new(string name="bridge_virtual_base_seq");
	extern task body();

endclass:bridge_virtual_base_seq

		//Constructor-new
function bridge_virtual_base_seq::new(string name="bridge_virtual_base_seq");
	super.new(name);
endfunction:new

//body
task bridge_virtual_base_seq::body;
/*
	if(!uvm_config_db #(bridge_env_config) ::get(null, get_full_name,"bridge_env_config",env_cfg))
		`uvm_fatal("VSEQ","cannot get() env_cfg from uvm_config_db. Have you set() it?")
*/
	if(!uvm_config_db #(bridge_env_config)::get(null,get_full_name(),"bridge_env_config",env_cfg))
                `uvm_fatal("VSEQ","cannot get() env_cfg from uvm_config_db. Have you set it?")

	ahb_seqrh=new[env_cfg.no_of_ahb_agts];
	apb_seqrh=new[env_cfg.no_of_apb_agts];

	assert($cast(vseqrh,m_sequencer)) else begin
    		`uvm_error("VSEQ", "Error in $cast of virtual sequencer")
 	 end
	
	foreach(ahb_seqrh[i])
		ahb_seqrh[i]=vseqrh.ahb_seqrh[i];
	
	foreach(apb_seqrh[i])
		apb_seqrh[i]=vseqrh.apb_seqrh[i];

endtask:body


//-----------------------------------bridge_virtual_single_seqs--------------------------------------//
class bridge_virtual_single_seqs extends bridge_virtual_base_seq;
	            
		//Factory Registration
	`uvm_object_utils(bridge_virtual_single_seqs)

        //Properties
	bridge_ahb_single_seq single_seqh;
	bridge_apb_single_seq apb_seqh;
		
		//------------------------------------------
		// Methods
		//------------------------------------------
		// Standard UVM Methods:
	extern function new(string name="bridge_virtual_single_seqs");
	extern task body();

endclass:bridge_virtual_single_seqs

		//Constructor-new
function bridge_virtual_single_seqs::new(string name="bridge_virtual_single_seqs");
	super.new(name);
endfunction:new

task bridge_virtual_single_seqs::body();
	super.body();
	
	single_seqh= bridge_ahb_single_seq::type_id::create("single_seqh");
	apb_seqh = bridge_apb_single_seq::type_id::create("apb_seqh");

	if(env_cfg.has_ahb_agent)
	begin
		for(int i=0;i<env_cfg.no_of_ahb_agts;i++)
			single_seqh.start(ahb_seqrh[i]);
		$display("single seq started ");
	end

//	#20;
	if(env_cfg.has_apb_agent)
	begin
		for(int i=0; i<env_cfg.no_of_apb_agts; i++)
			apb_seqh.start(apb_seqrh[i]);
		$display("singlep seq started ");
	end

endtask:body


//-----------------------------------bridge_virtual_wrap_incr_seqs--------------------------------------//
class bridge_virtual_wrap_incr_seqs extends bridge_virtual_base_seq;

                //Factory Registration
        `uvm_object_utils(bridge_virtual_wrap_incr_seqs)

        //Properties
        bridge_ahb_wrap_incr_seq wrap_incr_seqh;
	bridge_apb_single_seq apb_seqh1;

                //------------------------------------------
                // Methods
                //------------------------------------------
                // Standard UVM Methods:
        extern function new(string name="bridge_virtual_wrap_incr_seqs");
        extern task body();

endclass:bridge_virtual_wrap_incr_seqs

                //Constructor-new
function bridge_virtual_wrap_incr_seqs::new(string name="bridge_virtual_wrap_incr_seqs");
        super.new(name);
endfunction:new

task bridge_virtual_wrap_incr_seqs::body();
        super.body();

        wrap_incr_seqh= bridge_ahb_wrap_incr_seq::type_id::create("wrap_incr_seqh");
	apb_seqh1 = bridge_apb_single_seq::type_id::create("apb_seqh1");

        if(env_cfg.has_ahb_agent)
        begin
                for(int i=0;i<env_cfg.no_of_ahb_agts;i++)
                        wrap_incr_seqh.start(ahb_seqrh[i]);
                $display("single seq started ");
        end
	
//	#20;
	if(env_cfg.has_apb_agent)
        begin
                for(int i=0; i<env_cfg.no_of_apb_agts; i++)
                        apb_seqh1.start(apb_seqrh[i]);
		$display("singlep seq started ");

        end

endtask:body


//-----------------------------------bridge_virtual_unspec_length_seqs--------------------------------------//
class bridge_virtual_unspec_length_seqs extends bridge_virtual_base_seq;

                //Factory Registration
        `uvm_object_utils(bridge_virtual_unspec_length_seqs)

        //Properties
        bridge_ahb_unspec_length_seq unspec_seqh;
	bridge_apb_single_seq apb_seqh2;

                //------------------------------------------
                // Methods
                //------------------------------------------
                // Standard UVM Methods:
        extern function new(string name="bridge_virtual_unspec_length_seqs");
        extern task body();

endclass:bridge_virtual_unspec_length_seqs

                //Constructor-new
function bridge_virtual_unspec_length_seqs::new(string name="bridge_virtual_unspec_length_seqs");
        super.new(name);
endfunction:new

task bridge_virtual_unspec_length_seqs::body();
        super.body();

        unspec_seqh= bridge_ahb_unspec_length_seq::type_id::create("unspec_seqh");
	apb_seqh2 = bridge_apb_single_seq::type_id::create("apb_seqh2");

        if(env_cfg.has_ahb_agent)
        begin
                for(int i=0;i<env_cfg.no_of_ahb_agts;i++)
                        unspec_seqh.start(ahb_seqrh[i]);
//                $display("single seq started ");
        end
	
//	#20;
	if(env_cfg.has_apb_agent)
        begin
                for(int i=0; i<env_cfg.no_of_apb_agts; i++)
                        apb_seqh2.start(apb_seqrh[i]);
        end

endtask:body

