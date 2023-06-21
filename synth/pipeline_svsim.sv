`ifndef SYNTHESIS

//
// This is an automatically generated file from 
// dc_shell Version T-2022.03-SP3 -- Jul 12, 2022
//

// For simulation only. Do not modify.

module pipeline_svsim (

	input         clock,                    	input         reset,                    	input [4-1:0] [32-1:0]Imem2proc_data,   
	input [3:0]   mem2proc_response,        	input [63:0]  mem2proc_data,            	input [3:0]   mem2proc_tag,              	output logic [32-1:0]proc2Imem_addr,
					output logic [32-1:0] proc2mem_addr_out,        output logic [63:0] proc2mem_data_out,        output BUS_COMMAND   proc2mem_command_out,

	output logic [3:0]  pipeline_completed_insts,
	output EXCEPTION_CODE   pipeline_error_status,
	output logic [4-1:0][4:0]  pipeline_commit_wr_idx,
	output logic [4-1:0][32-1:0] pipeline_commit_wr_data,
	output logic  [4-1:0]      pipeline_commit_wr_en,
	output logic [4-1:0][32-1:0] pipeline_commit_NPC,
	
	
				
	output logic [4-1:0][32-1:0] if_NPC_out,
	output logic [4-1:0] [31:0] if_IR_out,
	output logic [4-1:0]       if_valid_inst_out,
	output logic [4-1:0][32-1:0] if_dp_NPC,
	output logic [4-1:0][31:0] if_dp_IR,
	output logic [4-1:0]       if_dp_valid_inst,
	output logic [4-1:0][32-1:0] rs_is_NPC,
	output logic [4-1:0][31:0] rs_is_IR,
	output logic [4-1:0]       rs_is_valid_inst,
	output logic [4-1:0][32-1:0] is_ex_NPC_alu,
	output logic [4-1:0][31:0] is_ex_IR_alu,
	output logic [4-1:0]       is_ex_valid_inst_alu,
	output logic [2-1:0][32-1:0] is_ex_NPC_mul,
	output logic [2-1:0][31:0] is_ex_IR_mul,
	output logic [2-1:0]       is_ex_valid_inst_mul,
	output logic [31:0]is_ex_NPC_load,
	output logic [31:0]is_ex_IR_load,
	output logic is_ex_valid_inst_load,

	output logic [31:0]is_ex_NPC_store,
	output logic [31:0]is_ex_IR_store,
	output logic is_ex_valid_inst_store,
	output logic [4-1:0][32-1:0] ex_com_NPC,
	output logic [4-1:0][31:0] ex_com_IR,
	output logic [4-1:0]       ex_com_valid_inst,
	output logic [4-1:0][32-1:0] retire_NPC,
	output logic [4-1:0][31:0] retire_IR,
	output logic [4-1:0]       retire_valid_inst,


		output RRAT_PACKET [32-1:0]RRAT_table,     output Freelist_PACKET [64-32-1:0]Freelist_table,
    output ROB_PACKET [64-32-1:0]ROB_table,
    output RAT_PACKET RAT_table,

	output rs_table [8-1:0] rs_out_table,
	output Pre_IS_EX_PACKET[8-1:0] test_alu_is,
	output Pre_IS_EX_PACKET[8-1:0] test_mul_is,
	output Pre_IS_EX_PACKET[8-1:0] test_load_is,
	output Pre_IS_EX_PACKET[8-1:0] test_store_is,
	output CDB_OUT_PACKET [4-1:0] cdb_out_packet,

	output logic [64-1:0] [32-1:0] registers,
	output D_CACHE_BLOCK [2-1:0][256/2/8-1:0] d_cache,

	output MSHR_ENTRY[8:1] mshr,
	output I_CACHE_BLOCK [2-1:0][256/2/8-1:0] i_cache,
	output I_MSHR_ENTRY[8-1:0] i_mshr,
	output SQ_PACKET [8-1:0]store_queue,
	output logic [3:0]complete_branch_count,
	output logic [3:0]complete_mis_branch_count

);
	


	
	

  pipeline pipeline( {>>{ clock }}, {>>{ reset }}, {>>{ Imem2proc_data }}, 
        {>>{ mem2proc_response }}, {>>{ mem2proc_data }}, {>>{ mem2proc_tag }}, 
        {>>{ proc2Imem_addr }}, {>>{ proc2mem_addr_out }}, 
        {>>{ proc2mem_data_out }}, {>>{ proc2mem_command_out }}, 
        {>>{ pipeline_completed_insts }}, {>>{ pipeline_error_status }}, 
        {>>{ pipeline_commit_wr_idx }}, {>>{ pipeline_commit_wr_data }}, 
        {>>{ pipeline_commit_wr_en }}, {>>{ pipeline_commit_NPC }}, 
        {>>{ if_NPC_out }}, {>>{ if_IR_out }}, {>>{ if_valid_inst_out }}, 
        {>>{ if_dp_NPC }}, {>>{ if_dp_IR }}, {>>{ if_dp_valid_inst }}, 
        {>>{ rs_is_NPC }}, {>>{ rs_is_IR }}, {>>{ rs_is_valid_inst }}, 
        {>>{ is_ex_NPC_alu }}, {>>{ is_ex_IR_alu }}, 
        {>>{ is_ex_valid_inst_alu }}, {>>{ is_ex_NPC_mul }}, 
        {>>{ is_ex_IR_mul }}, {>>{ is_ex_valid_inst_mul }}, 
        {>>{ is_ex_NPC_load }}, {>>{ is_ex_IR_load }}, 
        {>>{ is_ex_valid_inst_load }}, {>>{ is_ex_NPC_store }}, 
        {>>{ is_ex_IR_store }}, {>>{ is_ex_valid_inst_store }}, 
        {>>{ ex_com_NPC }}, {>>{ ex_com_IR }}, {>>{ ex_com_valid_inst }}, 
        {>>{ retire_NPC }}, {>>{ retire_IR }}, {>>{ retire_valid_inst }}, 
        {>>{ RRAT_table }}, {>>{ Freelist_table }}, {>>{ ROB_table }}, 
        {>>{ RAT_table }}, {>>{ rs_out_table }}, {>>{ test_alu_is }}, 
        {>>{ test_mul_is }}, {>>{ test_load_is }}, {>>{ test_store_is }}, 
        {>>{ cdb_out_packet }}, {>>{ registers }}, {>>{ d_cache }}, 
        {>>{ mshr }}, {>>{ i_cache }}, {>>{ i_mshr }}, {>>{ store_queue }}, 
        {>>{ complete_branch_count }}, {>>{ complete_mis_branch_count }} );
endmodule
`endif
