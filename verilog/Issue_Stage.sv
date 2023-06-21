`timescale 1ns/100ps
module Issue_Stage(
///////////input///////////
	input clock,
	input reset,
	input RS_IS_PACKET [`N_way-1:0] rs_is_packet_in,
	input [`ALU_num-1:0]     alu_busy, 
	input [`MUL_num-1:0]     mul_busy,
	input [`N_way-1:0] [`XLEN-1:0] preg1_value,
	input [`N_way-1:0] [`XLEN-1:0] preg2_value,
	////////brat///////////////////
	input   clean_brat_en,              ///  clean_brat_en is 1, delete everything in the pipeline which has that b_mask_bit
	input [$clog2(`width_b_mask)-1:0]   clean_brat_num,  //from brat
	input  [`ALU_num-1:0]clean_bit_brat_en,          /// did not misprediction,we just set all ba_mask[last_b_mask_branch] to be 0
	input	 [`ALU_num-1:0][$clog2(`width_b_mask)-1:0] clean_bit_num_brat_ex,
	////////lsq and mshr/////////
	input stall_IS_MSHR,            //stall issue from MSHR
	input stop_is_en,
	input stop_is_st_en,
	input sq_memsize_stall,
    input [`LOAD_IB_Depth-1:0]ready_issue_lsq,
	output [`LOAD_IB_Depth-1:0][`SQ_LEN:0]load_SQ_tail_to_SQ,
	output [`LOAD_IB_Depth-1:0]load_SQ_tail_to_SQ_valid,
	input [`SQ_LEN:0]retire_head2rs_is,
    input retire_enable2rs_is,
	///////////output///////////
	output logic [`N_way-1:0] [$clog2(`Preg_num)-1:0] preg1_index,
	output logic [`N_way-1:0] [$clog2(`Preg_num)-1:0] preg2_index,
	output  logic[`N_LEN:0]  avail_alu_is_out,
	output Pre_IS_EX_PACKET [`ALU_num-1:0] pre_alu_is_out,
	output Pre_IS_EX_PACKET [`MUL_num-1:0] pre_mul_is_out,
	output  logic[`N_LEN:0 ] avail_mul_is_out,
	output 	Pre_IS_EX_PACKET[`ALU_IB_Detpth-1:0] test_alu_is,
	output 	Pre_IS_EX_PACKET[`MUL_IB_Detpth-1:0] test_mul_is,
	output Pre_IS_EX_PACKET[`LOAD_IB_Depth-1:0] test_load_is,
	output Pre_IS_EX_PACKET[`STORE_IB_Depth-1:0] test_store_is,
	output logic[`N_LEN:0 ] avail_load_is_out,
	output Pre_IS_EX_PACKET pre_load_is_ex_out,
	output Pre_IS_EX_PACKET pre_store_is_ex_out
);

	Pre_IS_EX_PACKET[`N_way-1:0]  rs_alu_is_packet_in;
	Pre_IS_EX_PACKET[`N_way-1:0]  rs_mul_is_packet_in;
	Pre_IS_EX_PACKET [`N_way-1:0] rs_load_is_packet_in;
	Pre_IS_EX_PACKET[`N_way-1:0]  rs_store_is_packet_in;
	logic [`N_LEN:0]  avail_store_is_out;
	
	always_comb begin
		rs_mul_is_packet_in='d0;
		rs_alu_is_packet_in='d0;
		rs_load_is_packet_in = 'd0;
		rs_store_is_packet_in = 'd0;

		preg1_index = 0;
		preg1_index = 0;

		for(int i=0;i< `N_way;i=i+1)begin 
		preg1_index[i] =  rs_is_packet_in[i].prs1_idx;
		preg2_index[i] =  rs_is_packet_in[i].prs2_idx;
		end
		for(int i=0;i< `N_way;i=i+1)begin
			if(rs_is_packet_in[i].if_mul)begin    
			rs_mul_is_packet_in[i].NPC=rs_is_packet_in[i].NPC;   // PC + 4
			rs_mul_is_packet_in[i].PC=rs_is_packet_in[i].PC;    // PC
			rs_mul_is_packet_in[i].prs1_value=preg1_value[i];   // preg A value from physical register file                                 
			rs_mul_is_packet_in[i].prs2_value=preg2_value[i];    // preg B value                                                                                                                  
			rs_mul_is_packet_in[i].opa_select=rs_is_packet_in[i].opa_select; // ALU opa mux select (ALU_OPA_xxx *)
			rs_mul_is_packet_in[i].opb_select=rs_is_packet_in[i].opb_select; // ALU opb mux select (ALU_OPB_xxx *)
			rs_mul_is_packet_in[i].inst=rs_is_packet_in[i].inst;                 // instruction
			rs_mul_is_packet_in[i].p_dest_reg_idx=rs_is_packet_in[i].p_dest_reg_idx;  // destination (writeback) register index      
			rs_mul_is_packet_in[i].alu_func=rs_is_packet_in[i].alu_func;      // ALU function select (ALU_xxx *)
			rs_mul_is_packet_in[i].rd_mem=rs_is_packet_in[i].rd_mem;        // does inst read memory?
			rs_mul_is_packet_in[i]. wr_mem=rs_is_packet_in[i].wr_mem;        // does inst write memory?
			rs_mul_is_packet_in[i].cond_branch=rs_is_packet_in[i].cond_branch;   // is inst a conditional branch?
			rs_mul_is_packet_in[i].uncond_branch=rs_is_packet_in[i].uncond_branch; // is inst an unconditional branch?
			rs_mul_is_packet_in[i].halt=rs_is_packet_in[i].halt;          // is this a halt?
			rs_mul_is_packet_in[i].illegal=rs_is_packet_in[i].illegal;       // is this instruction illegal?
			rs_mul_is_packet_in[i].csr_op=rs_is_packet_in[i].csr_op;        // is this a CSR operation? (we only used this as a cheap way to get return code)
			rs_mul_is_packet_in[i].valid=rs_is_packet_in[i].valid;
			rs_mul_is_packet_in[i].rs_b_mask=rs_is_packet_in[i].is_b_mask;
			rs_mul_is_packet_in[i].if_mul=rs_is_packet_in[i].if_mul;
			rs_mul_is_packet_in[i].is_branch=rs_is_packet_in[i].is_branch; 
			rs_mul_is_packet_in[i].b_mask_bit_branch=rs_is_packet_in[i].b_mask_bit_branch;
			rs_mul_is_packet_in[i].BP_predicted_taken=rs_is_packet_in[i].BP_predicted_taken;
			rs_mul_is_packet_in[i].BP_predicted_target_PC=rs_is_packet_in[i].BP_predicted_target_PC;
			rs_mul_is_packet_in[i].SQ_tail=rs_is_packet_in[i].SQ_tail;
			rs_mul_is_packet_in[i].ROB_tail=rs_is_packet_in[i].ROB_tail;
			rs_mul_is_packet_in[i].load_issue_valid=rs_is_packet_in[i].load_issue_valid;
			end
			else if(rs_is_packet_in[i].rd_mem)begin   
			
			rs_load_is_packet_in[i].NPC=rs_is_packet_in[i].NPC;   // PC + 4
			rs_load_is_packet_in[i].PC=rs_is_packet_in[i].PC;    // PC
			rs_load_is_packet_in[i].prs1_value=preg1_value[i];   // preg A value from physical register file                                 
			rs_load_is_packet_in[i].prs2_value=preg2_value[i];    // preg B value                                                                                                                  
			rs_load_is_packet_in[i].opa_select=rs_is_packet_in[i].opa_select; // ALU opa mux select (ALU_OPA_xxx *)
			rs_load_is_packet_in[i].opb_select=rs_is_packet_in[i].opb_select; // ALU opb mux select (ALU_OPB_xxx *)
			rs_load_is_packet_in[i].inst=rs_is_packet_in[i].inst;                 // instruction
			rs_load_is_packet_in[i].p_dest_reg_idx=rs_is_packet_in[i].p_dest_reg_idx;  // destination (writeback) register index      
			rs_load_is_packet_in[i].alu_func=rs_is_packet_in[i].alu_func;      // ALU function select (ALU_xxx *)
			rs_load_is_packet_in[i].rd_mem=rs_is_packet_in[i].rd_mem;        // does inst read memory?
			rs_load_is_packet_in[i]. wr_mem=rs_is_packet_in[i].wr_mem;        // does inst write memory?
			rs_load_is_packet_in[i].cond_branch=rs_is_packet_in[i].cond_branch;   // is inst a conditional branch?
			rs_load_is_packet_in[i].uncond_branch=rs_is_packet_in[i].uncond_branch; // is inst an unconditional branch?
			rs_load_is_packet_in[i].halt=rs_is_packet_in[i].halt;          // is this a halt?
			rs_load_is_packet_in[i].illegal=rs_is_packet_in[i].illegal;       // is this instruction illegal?
			rs_load_is_packet_in[i].csr_op=rs_is_packet_in[i].csr_op;        // is this a CSR operation? (we only used this as a cheap way to get return code)
			rs_load_is_packet_in[i].valid=rs_is_packet_in[i].valid;
			rs_load_is_packet_in[i].rs_b_mask=rs_is_packet_in[i].is_b_mask;
			rs_load_is_packet_in[i].if_mul=rs_is_packet_in[i].if_mul;
			rs_load_is_packet_in[i].is_branch=rs_is_packet_in[i].is_branch; 
			rs_load_is_packet_in[i].b_mask_bit_branch=rs_is_packet_in[i].b_mask_bit_branch;
			rs_load_is_packet_in[i].BP_predicted_taken=rs_is_packet_in[i].BP_predicted_taken;
			rs_load_is_packet_in[i].BP_predicted_target_PC=rs_is_packet_in[i].BP_predicted_target_PC;
			rs_load_is_packet_in[i].SQ_tail=rs_is_packet_in[i].SQ_tail;
			rs_load_is_packet_in[i].ROB_tail=rs_is_packet_in[i].ROB_tail;
			rs_load_is_packet_in[i].load_issue_valid=rs_is_packet_in[i].load_issue_valid;
			end
			else if(rs_is_packet_in[i].wr_mem)begin    
			rs_store_is_packet_in[i].NPC=rs_is_packet_in[i].NPC;   // PC + 4
			rs_store_is_packet_in[i].PC=rs_is_packet_in[i].PC;    // PC
			rs_store_is_packet_in[i].prs1_value=preg1_value[i];   // preg A value from physical register file                                 
			rs_store_is_packet_in[i].prs2_value=preg2_value[i];    // preg B value                                                                                                                  
			rs_store_is_packet_in[i].opa_select=rs_is_packet_in[i].opa_select; // ALU opa mux select (ALU_OPA_xxx *)
			rs_store_is_packet_in[i].opb_select=rs_is_packet_in[i].opb_select; // ALU opb mux select (ALU_OPB_xxx *)
			rs_store_is_packet_in[i].inst=rs_is_packet_in[i].inst;                 // instruction
			rs_store_is_packet_in[i].p_dest_reg_idx=rs_is_packet_in[i].p_dest_reg_idx;  // destination (writeback) register index      
			rs_store_is_packet_in[i].alu_func=rs_is_packet_in[i].alu_func;      // ALU function select (ALU_xxx *)
			rs_store_is_packet_in[i].rd_mem=rs_is_packet_in[i].rd_mem;        // does inst read memory?
			rs_store_is_packet_in[i]. wr_mem=rs_is_packet_in[i].wr_mem;        // does inst write memory?
			rs_store_is_packet_in[i].cond_branch=rs_is_packet_in[i].cond_branch;   // is inst a conditional branch?
			rs_store_is_packet_in[i].uncond_branch=rs_is_packet_in[i].uncond_branch; // is inst an unconditional branch?
			rs_store_is_packet_in[i].halt=rs_is_packet_in[i].halt;          // is this a halt?
			rs_store_is_packet_in[i].illegal=rs_is_packet_in[i].illegal;       // is this instruction illegal?
			rs_store_is_packet_in[i].csr_op=rs_is_packet_in[i].csr_op;        // is this a CSR operation? (we only used this as a cheap way to get return code)
			rs_store_is_packet_in[i].valid=rs_is_packet_in[i].valid;
			rs_store_is_packet_in[i].rs_b_mask=rs_is_packet_in[i].is_b_mask;
			rs_store_is_packet_in[i].if_mul=rs_is_packet_in[i].if_mul;
			rs_store_is_packet_in[i].is_branch=rs_is_packet_in[i].is_branch; 
			rs_store_is_packet_in[i].b_mask_bit_branch=rs_is_packet_in[i].b_mask_bit_branch;
			rs_store_is_packet_in[i].BP_predicted_taken=rs_is_packet_in[i].BP_predicted_taken;
			rs_store_is_packet_in[i].BP_predicted_target_PC=rs_is_packet_in[i].BP_predicted_target_PC;
			rs_store_is_packet_in[i].SQ_tail=rs_is_packet_in[i].SQ_tail;
			rs_store_is_packet_in[i].ROB_tail=rs_is_packet_in[i].ROB_tail;
			rs_store_is_packet_in[i].load_issue_valid=rs_is_packet_in[i].load_issue_valid;
			end
			else begin
			rs_alu_is_packet_in[i].NPC=rs_is_packet_in[i].NPC;   // PC + 4
			rs_alu_is_packet_in[i].PC=rs_is_packet_in[i].PC;    // PC
			rs_alu_is_packet_in[i].prs1_value=preg1_value[i];   // preg A value from physical register file                                 
			rs_alu_is_packet_in[i].prs2_value=preg2_value[i];    // preg B value                                                                                                               
			rs_alu_is_packet_in[i].opa_select=rs_is_packet_in[i].opa_select; // ALU opa mux select (ALU_OPA_xxx *)
			rs_alu_is_packet_in[i].opb_select=rs_is_packet_in[i].opb_select; // ALU opb mux select (ALU_OPB_xxx *)
			rs_alu_is_packet_in[i].inst=rs_is_packet_in[i].inst;                 // instruction
			rs_alu_is_packet_in[i].p_dest_reg_idx=rs_is_packet_in[i].p_dest_reg_idx;  // destination (writeback) register index      
			rs_alu_is_packet_in[i].alu_func=rs_is_packet_in[i].alu_func;      // ALU function select (ALU_xxx *)
			rs_alu_is_packet_in[i].rd_mem=rs_is_packet_in[i].rd_mem;        // does inst read memory?
			rs_alu_is_packet_in[i]. wr_mem=rs_is_packet_in[i].wr_mem;        // does inst write memory?
			rs_alu_is_packet_in[i].cond_branch=rs_is_packet_in[i].cond_branch;   // is inst a conditional branch?
			rs_alu_is_packet_in[i].uncond_branch=rs_is_packet_in[i].uncond_branch; // is inst an unconditional branch?
			rs_alu_is_packet_in[i].halt=rs_is_packet_in[i].halt;          // is this a halt?
			rs_alu_is_packet_in[i].illegal=rs_is_packet_in[i].illegal;       // is this instruction illegal?
			rs_alu_is_packet_in[i].csr_op=rs_is_packet_in[i].csr_op;        // is this a CSR operation? (we only used this as a cheap way to get return code)
			rs_alu_is_packet_in[i].valid=rs_is_packet_in[i].valid;
			rs_alu_is_packet_in[i].rs_b_mask=rs_is_packet_in[i].is_b_mask;
			rs_alu_is_packet_in[i].if_mul=rs_is_packet_in[i].if_mul;
			rs_alu_is_packet_in[i].is_branch=rs_is_packet_in[i].is_branch; 
			rs_alu_is_packet_in[i].b_mask_bit_branch=rs_is_packet_in[i].b_mask_bit_branch;
			rs_alu_is_packet_in[i].BP_predicted_taken=rs_is_packet_in[i].BP_predicted_taken;
			rs_alu_is_packet_in[i].BP_predicted_target_PC=rs_is_packet_in[i].BP_predicted_target_PC;
			rs_alu_is_packet_in[i].SQ_tail=rs_is_packet_in[i].SQ_tail;
			rs_alu_is_packet_in[i].ROB_tail=rs_is_packet_in[i].ROB_tail;
			rs_alu_is_packet_in[i].load_issue_valid=rs_is_packet_in[i].load_issue_valid;
			end
		end

	end

	ALU_Issue_Buffer  ALU_IB(
		//////////////////input//////////////////
		.clock(clock),
		.reset(reset),
		.rs_alu_is_packet_in(rs_alu_is_packet_in),
		
		.alu_busy(alu_busy),									
		.clean_brat_en(clean_brat_en),              
		.clean_brat_num(clean_brat_num),  
		.clean_bit_brat_en(clean_bit_brat_en),          
		.clean_bit_num_brat_ex(clean_bit_num_brat_ex),

		.pre_alu_is_ex_out(pre_alu_is_out),
		.avail_alu_is_out(avail_alu_is_out),
				.test_alu_is(test_alu_is)
			
	);

	MUL_Issue_Buffer MUL_IB(
		//////////////////input//////////////////
		.clock(clock),
		.reset(reset),
		.rs_mul_is_packet_in(rs_mul_is_packet_in),

		.mul_busy(mul_busy),									/// if mul busy
		.clean_brat_en(clean_brat_en),              
		.clean_brat_num(clean_brat_num),  
		.clean_bit_brat_en(clean_bit_brat_en),          
		.clean_bit_num_brat_ex(clean_bit_num_brat_ex),
		.pre_mul_is_ex_out(pre_mul_is_out),
		.avail_mul_is_out(avail_mul_is_out),
		.test_mul_is(test_mul_is)
	);

	 Load_Issue_Buffer Load_IB(
    //////////////////input//////////////////
    .clock(clock),
    .reset(reset),
    .rs_load_is_packet_in(rs_load_is_packet_in),
   
    .clean_brat_en(clean_brat_en),              ///  clean_brat_en is 1, delete everything in the pipeline which has that b_mask_bit
    .clean_brat_num(clean_brat_num),  //from brat
	.clean_bit_brat_en(clean_bit_brat_en),          /// did not misprediction,we just set all ba_mask[last_b_mask_branch] to be 0
	.clean_bit_num_brat_ex(clean_bit_num_brat_ex),  //which bit should clean when clean_bit_brat_en[i] is 1 

    .stall_IS_MSHR(stall_IS_MSHR || stop_is_en || sq_memsize_stall),            //stall issue from MSHR
    .ready_issue_lsq(ready_issue_lsq),

    .pre_load_is_ex_out(pre_load_is_ex_out),
    .avail_load_is_out(avail_load_is_out),
    .test_load_is(test_load_is),
	.load_SQ_tail_to_SQ(load_SQ_tail_to_SQ),
	.load_SQ_tail_to_SQ_valid(load_SQ_tail_to_SQ_valid),
	.retire_head2rs_is(retire_head2rs_is),
    .retire_enable2rs_is(retire_enable2rs_is)


	);

	Store_Issue_Buffer Store_IB(
    .clock(clock),
    .reset(reset),
    .rs_store_is_packet_in(rs_store_is_packet_in),
	.stop_is_st_en(stop_is_st_en),
   
    .clean_brat_en(clean_brat_en),              ///  clean_brat_en is 1, delete everything in the pipeline which has that b_mask_bit
    .clean_brat_num(clean_brat_num),  //from brat
	.clean_bit_brat_en(clean_bit_brat_en),          /// did not misprediction,we just set all ba_mask[last_b_mask_branch] to be 0
	.clean_bit_num_brat_ex(clean_bit_num_brat_ex),  //which bit should clean when clean_bit_brat_en[i] is 1 

    .pre_store_is_ex_out(pre_store_is_ex_out),
    .avail_store_is_out(avail_store_is_out),
    .test_store_is(test_store_is)

	);

endmodule