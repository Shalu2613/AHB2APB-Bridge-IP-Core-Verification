package bridge_test_pkg;
	
	import uvm_pkg::*;
	
	`include "uvm_macros.svh"
     
        `include "ahb_xtn.sv"
        `include "bridge_ahb_agent_config.sv"
        `include "bridge_apb_agent_config.sv"
        `include "bridge_env_config.sv"
        `include "bridge_ahb_driver.sv"
        `include "bridge_ahb_monitor.sv"
        `include "bridge_ahb_sequencer.sv"
        `include "bridge_ahb_agent.sv"
        `include "bridge_ahb_agt_top.sv"
        `include "bridge_ahb_seqs.sv"

        `include "apb_xtn.sv"
        `include "bridge_apb_monitor.sv"
        `include "bridge_apb_sequencer.sv"
        `include "bridge_apb_seqs.sv"
        `include "bridge_apb_driver.sv"
        `include "bridge_apb_agent.sv"
        `include "bridge_apb_agt_top.sv"

        `include "bridge_virtual_sequencer.sv"
        `include "bridge_virtual_seqs.sv"
        `include "bridge_scoreboard.sv"

        `include "bridge_tb.sv"


        `include "bridge_vtest_lib.sv"
	
endpackage

