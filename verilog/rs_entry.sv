`timescale 1ns/100ps
module rs_entry (
	////////////////input//////////////////////
	input         clock,              
	input         reset, 
	input halt_flag,
	////////////From Decoder///////////////   //should be from dispatcher to get ture inst number
	input BRAT_RS_PACKET [`N_way-1:0] dp_rs_packet_in,                                //define in sys_def.sv
	input[`N_way-1:0][`ROB_LEN:0]ROB_tail,
	///////////From maptable//////////////
	input  [`N_way-1:0][$clog2(`Preg_num)-1:0] preg1_in,preg2_in,                             ///tag1,tag2 ///
	input  [`N_way-1:0]  preg1_ready_in,preg2_ready_in,                                                      //if tag1,tage2 ready or not

	////////////From freelist////////////
	input  [`N_way-1:0][$clog2(`Preg_num)-1:0] p_rd_in,                    //tag for rd which from freelist
	
	/////////From  CDB //////////////////
	input  [`N_way-1:0][$clog2(`Preg_num)-1:0] cdb_tag,				//from cdb, comparing tag with tag1 and tag2
	input  [`N_way-1:0] cdb_valid,


	////////b-mask_reg and BRAT////////////////////
	input   clean_brat_en,              ///  clean_brat_en is 1, delete everything in the pipeline which has that b_mask_bit
    input [$clog2(`width_b_mask)-1:0]   clean_brat_num,  //from brat
	input  [`ALU_num-1:0]clean_bit_brat_en,          /// did not misprediction,we just set all ba_mask[last_b_mask_branch] to be 0
	input	 [`ALU_num-1:0][$clog2(`width_b_mask)-1:0] clean_bit_num_brat_ex,  //which bit should clean when clean_bit_brat_en[i] is 1 
	//////input from execution/////////////////

	input [$clog2(`N_way):0]    issue_buffer_alu_avail,									/// if alu and mul busy
	input [$clog2(`N_way):0]     issue_buffer_mul_avail,
	input[$clog2(`N_way):0] issue_buffer_load_avail,
	//////complete////////////////////////
   /////////////output//////////////////////
    output rs_table [`RS_depth-1:0] rs_out_table_print,    ///for test

	output RS_IS_PACKET [`N_way-1:0] rs_is_packet_out, 

	//////RS_full? //////
	output logic[$clog2(`N_way) :0] avail_rs,                      //  available numbers of entries in rs

	input  [`N_way-1:0][`SQ_LEN:0]SQ_tail_rs,

	input [`SQ_LEN:0]retire_head2rs_is,
    input retire_enable2rs_is,
	input [`RS_depth-1:0]load_SQ_tail_to_rs_valid,
	output logic[`RS_depth-1:0][`SQ_LEN:0]load_SQ_tail_to_SQ,
    output logic [`RS_depth-1:0]load_SQ_tail_to_SQ_valid
);
	rs_table [`RS_depth-1:0] rs_out_table;
	RS_PACKET [`RS_depth-1:0] n_rs,rs;
	///////////////issue ////////////////
	logic [`RS_depth-1:0] ready_issue;

	logic [$clog2(`N_way):0] mul_used;
	logic [$clog2(`N_way):0] alu_used;
	logic [$clog2(`N_way):0] load_used;
	logic rs_empty;
	/////rs structure hazard/////
	// logic rs_full;

	logic  [$clog2(`N_way):0] issue_cnt;
	/////////writing to rs/////////////////
	logic [$clog2(`RS_depth)-1:0] nx_ptr_empty;
	always_comb begin
		load_SQ_tail_to_SQ = 0;
        load_SQ_tail_to_SQ_valid = 0;
		n_rs=rs;                           //rs is sequential logic,n_rs is combinational logic
		//-----------------------------------------------------------------------------------------------------BRAT--------------------------------------------------------------------------------------------------//
		if(clean_brat_en)begin
			for(int i=0; i<`RS_depth; i=i+1)begin
				if(n_rs[i].rs_b_mask[clean_brat_num])begin
					n_rs[i].busy_rs=1'b0;
					n_rs[i] = 0;
				end
			end
		end

		for(int j=0;j<`ALU_num;j=j+1)begin
			if(clean_bit_brat_en[j])begin
				for(int i=0; i<`RS_depth; i=i+1)begin
					n_rs[i].rs_b_mask[clean_bit_num_brat_ex[j]]=1'b0;
				end
			end
		end

		for(int i=0;i<`RS_depth;i=i+1)begin
            n_rs[i].load_issue_valid = n_rs[i].load_issue_valid | load_SQ_tail_to_rs_valid[i];
			if(n_rs[i].SQ_tail==retire_head2rs_is && retire_enable2rs_is)begin
				n_rs[i].no_sort_sq = 1;
			end
        end

		/////////////////////////
		/////////cdb_input///////
		////////////////////////

		for(int e=0; e<`N_way; e=e+1)begin  //cdb entry num==superscalar width
			rs_is_packet_out[e]=0;
		// 	rs_is_packet_out[e].PC=0;
		// 	rs_is_packet_out[e].opa_select=OPA_IS_RS1;
		// 	rs_is_packet_out[e].opb_select=OPB_IS_RS2;
		// 	rs_is_packet_out[e].prs1_idx=0;
		// 	rs_is_packet_out[e].prs2_idx=0;
		// 	rs_is_packet_out[e].inst=`NOP;                              
		// 	rs_is_packet_out[e].p_dest_reg_idx=0;                                                                               
		// 	rs_is_packet_out[e].alu_func=ALU_ADD;
		// 	rs_is_packet_out[e].rd_mem=`FALSE;
		// 	rs_is_packet_out[e].wr_mem=`FALSE;
		// 	rs_is_packet_out[e].cond_branch=`FALSE;
		// 	rs_is_packet_out[e].uncond_branch=`FALSE;
		// 	rs_is_packet_out[e].halt=`FALSE;
		// 	rs_is_packet_out[e].illegal=`FALSE;
		// 	rs_is_packet_out[e].csr_op=`FALSE;
		// 	rs_is_packet_out[e].if_mul=`FALSE;
		// 	rs_is_packet_out[e].valid=`FALSE;                                       //this instruction[i] is invalid
		// 	rs_is_packet_out[e].is_b_mask='d0;
		// 	rs_is_packet_out[e].is_branch=1'b0;
		// 	rs_is_packet_out[e].b_mask_bit_branch=1'b0;
		// 	rs_is_packet_out[e].BP_predicted_taken=1'b0;
		// 	rs_is_packet_out[e].BP_predicted_target_PC=1'b0;
		// 	rs_is_packet_out[e].SQ_tail=0;
		// 	rs_is_packet_out[e].ROB_tail=0;
		// 	rs_is_packet_out[e].load_issue_valid=0;
		///////////////rs_table ///////////////////
			rs_out_table[e].inst = 0;
			rs_out_table[e].busy = 0;
			rs_out_table[e].p_rd = 0;
			rs_out_table[e].preg1 = 0;
			rs_out_table[e].preg2 = 0;
			rs_out_table[e].preg1_ready = 0;
			rs_out_table[e].preg2_ready = 0;    	

			for(int f = 0;f<`RS_depth;f=f+1)begin          //if cdb tag match any entries in rs,then rising the ready flag
				if(cdb_tag[e]==n_rs[f].preg1 &&cdb_valid[e] &&n_rs[f].busy_rs )begin
					n_rs[f].preg1_ready=1'b1;
				end
				if(cdb_tag[e]==n_rs[f].preg2 &&cdb_valid[e] &&n_rs[f].busy_rs)begin
					n_rs[f].preg2_ready=1'b1;
				end
			end
		end //end cdb

		///////////////////////////////
		////////issue//////////////////
		///////////////////////////////
		mul_used=issue_buffer_mul_avail;
		alu_used=issue_buffer_alu_avail;
		load_used = issue_buffer_load_avail;
		ready_issue='d0;
		for (int a=`RS_depth-1; a>=0; a=a-1) begin                  //identify which entry is ready_issue
			if(n_rs[a].preg1_ready && n_rs[a].preg2_ready && n_rs[a].if_mul && mul_used != 0)begin
				ready_issue[a]=1'b1;
				mul_used=mul_used-1'b1;
			end
			else if (n_rs[a].preg1_ready && n_rs[a].preg2_ready && !n_rs[a].if_mul && !n_rs[a].rs_rd_mem && alu_used !=0 ) begin

				ready_issue[a]=1'b1;
				alu_used=alu_used-1'b1;
			end
			else if (n_rs[a].preg1_ready && n_rs[a].preg2_ready && n_rs[a].rs_rd_mem && !n_rs[a].if_mul && load_used !=0 ) begin

				ready_issue[a]=1'b1;
				load_used=load_used-1'b1;
			end
			
		end

		issue_cnt=0;
			
		for (int b=`RS_depth-1; b>=0; b=b-1) begin                                               //oldest instruction has highest priority
			if(ready_issue[b] && n_rs[b].busy_rs && issue_cnt<`N_way)begin

				issue_cnt= issue_cnt+1;

				rs_is_packet_out[issue_cnt-1'b1].NPC=n_rs[b].rs_NPC;
				rs_is_packet_out[issue_cnt-1'b1].PC=n_rs[b].rs_PC;
				rs_is_packet_out[issue_cnt-1'b1].opa_select=n_rs[b].rs_opa_select;
				rs_is_packet_out[issue_cnt-1'b1].opb_select=n_rs[b].rs_opb_select;
				rs_is_packet_out[issue_cnt-1'b1].prs1_idx=n_rs[b].preg1;
				rs_is_packet_out[issue_cnt-1'b1].prs2_idx=n_rs[b].preg2;
				rs_is_packet_out[issue_cnt-1'b1].inst=n_rs[b].rs_inst;                              
				rs_is_packet_out[issue_cnt-1'b1].p_dest_reg_idx=n_rs[b].p_rd;                                                                               
				rs_is_packet_out[issue_cnt-1'b1].alu_func=n_rs[b].rs_alu_func;
				rs_is_packet_out[issue_cnt-1'b1].rd_mem=n_rs[b].rs_rd_mem;
				rs_is_packet_out[issue_cnt-1'b1].wr_mem=n_rs[b].rs_wr_mem;
				rs_is_packet_out[issue_cnt-1'b1].cond_branch=n_rs[b].rs_cond_branch;
				rs_is_packet_out[issue_cnt-1'b1].uncond_branch=n_rs[b].rs_uncond_branch;
				rs_is_packet_out[issue_cnt-1'b1].halt=n_rs[b].rs_halt;
				rs_is_packet_out[issue_cnt-1'b1].illegal=n_rs[b].rs_illegal;
				rs_is_packet_out[issue_cnt-1'b1].csr_op=n_rs[b].rs_csr_op;
				rs_is_packet_out[issue_cnt-1'b1].valid=n_rs[b].rs_valid;
				rs_is_packet_out[issue_cnt-1'b1].is_b_mask=n_rs[b].rs_b_mask;
				rs_is_packet_out[issue_cnt-1'b1].if_mul=n_rs[b].if_mul;
				rs_is_packet_out[issue_cnt-1'b1].is_branch=n_rs[b].is_branch;
				rs_is_packet_out[issue_cnt-1'b1].b_mask_bit_branch=n_rs[b].b_mask_bit_branch;
				rs_is_packet_out[issue_cnt-1'b1].BP_predicted_taken=n_rs[b].BP_predicted_taken;
				rs_is_packet_out[issue_cnt-1'b1].BP_predicted_target_PC=n_rs[b].BP_predicted_target_PC;
				rs_is_packet_out[issue_cnt-1'b1].SQ_tail=n_rs[b].SQ_tail;
				rs_is_packet_out[issue_cnt-1'b1].ROB_tail=n_rs[b].ROB_tail;
				rs_is_packet_out[issue_cnt-1'b1].load_issue_valid=n_rs[b].load_issue_valid;
				rs_is_packet_out[issue_cnt-1'b1].no_sort_sq=n_rs[b].no_sort_sq;
				// n_rs[b].busy_rs=1'b0;
				n_rs[b] = 0;

			end
		end
		avail_rs='d0;
		for(int i=0; i<`RS_depth; i=i+1)begin
			// $display("n_rs.busy[i]",i,n_rs[i].busy_rs);
			if(!n_rs[i].busy_rs && avail_rs<`N_way)begin
				// $display("avail_rs:",avail_rs);
				avail_rs= avail_rs+1;
			end
		end
		
		
		///////////////////////////////////////////
		////// Compress issue queue////////////////
		///////////////////////////////////////////
		for (int i=0; i<`RS_depth-1; i=i+1) begin
			if(!n_rs[i+1].busy_rs && n_rs[i].busy_rs)begin
				for (int j=i ;j>=0; j=j-1)begin
					n_rs[j+1] = n_rs[j];
					// n_rs[j].busy_rs = 1'b0;
					n_rs[j] = 0;
					end
				end
			end

		/////////////////////////
		/////write to rs/////////
		////////////////////////

		for(int i=`RS_depth-1;i>=0;i--)begin
            load_SQ_tail_to_SQ[i] = n_rs[i].SQ_tail;
            load_SQ_tail_to_SQ_valid[i] = n_rs[i].rs_rd_mem;
        end
		nx_ptr_empty='d0;
		rs_empty= 1'b1; 
		if(n_rs[`RS_depth-1].busy_rs)begin
			rs_empty=0;
		end
		for(int i=0;i<`RS_depth;i++)begin
			if(rs_empty)begin
				nx_ptr_empty=`RS_depth-1;
			end
			else if(n_rs[i].busy_rs)begin
				nx_ptr_empty=nx_ptr_empty-1'b1;
				break;
			end
			else if(!n_rs[i].busy_rs)begin
				
				nx_ptr_empty=nx_ptr_empty+1'b1;
			end
			
		end

	
		for (int d=0; d<`N_way; d=d+1 )begin
			if( dp_rs_packet_in[d].valid && !clean_brat_en)begin
				n_rs[nx_ptr_empty].SQ_tail = SQ_tail_rs[d];
				n_rs[nx_ptr_empty].ROB_tail= ROB_tail[d];
				n_rs[nx_ptr_empty].rs_NPC = dp_rs_packet_in[d].NPC;
				n_rs[nx_ptr_empty].rs_PC = dp_rs_packet_in[d].PC;
				n_rs[nx_ptr_empty].rs_opa_select = dp_rs_packet_in[d].opa_select;
				n_rs[nx_ptr_empty].rs_opb_select = dp_rs_packet_in[d].opb_select;
				n_rs[nx_ptr_empty].rs_inst = dp_rs_packet_in[d].inst;
				n_rs[nx_ptr_empty].rs_alu_func = dp_rs_packet_in[d].alu_func;
				n_rs[nx_ptr_empty].rs_rd_mem = dp_rs_packet_in[d].rd_mem;
				n_rs[nx_ptr_empty].rs_wr_mem = dp_rs_packet_in[d].wr_mem;
				n_rs[nx_ptr_empty].rs_cond_branch=dp_rs_packet_in[d].cond_branch;
				n_rs[nx_ptr_empty].rs_uncond_branch=dp_rs_packet_in[d].uncond_branch;
				n_rs[nx_ptr_empty].rs_halt=dp_rs_packet_in[d].halt;
				n_rs[nx_ptr_empty].rs_illegal=dp_rs_packet_in[d].illegal;
				n_rs[nx_ptr_empty].rs_csr_op=dp_rs_packet_in[d].csr_op;
				n_rs[nx_ptr_empty].rs_valid=dp_rs_packet_in[d].valid;

				n_rs[nx_ptr_empty].busy_rs=1'b1;
				n_rs[nx_ptr_empty].p_rd=p_rd_in[d];
				n_rs[nx_ptr_empty].preg1=preg1_in[d];
				n_rs[nx_ptr_empty].preg2=preg2_in[d];
				n_rs[nx_ptr_empty].preg1_ready=preg1_ready_in[d];
				n_rs[nx_ptr_empty].preg2_ready=preg2_ready_in[d];
				n_rs[nx_ptr_empty].if_mul= dp_rs_packet_in[d].if_mul;

				n_rs[nx_ptr_empty].rs_b_mask=dp_rs_packet_in[d].b_mask_in;
				n_rs[nx_ptr_empty].is_branch=dp_rs_packet_in[d].is_branch;
				n_rs[nx_ptr_empty].b_mask_bit_branch=dp_rs_packet_in[d].b_mask_bit_branch;
				n_rs[nx_ptr_empty].BP_predicted_taken=dp_rs_packet_in[d].BP_predicted_taken;
				n_rs[nx_ptr_empty].BP_predicted_target_PC=dp_rs_packet_in[d].BP_predicted_target_PC;
				n_rs[nx_ptr_empty].load_issue_valid=dp_rs_packet_in[d].load_issue_valid;
				nx_ptr_empty=nx_ptr_empty-1'b1;
			end 
		end

		for(int m = 0; m<`RS_depth; m=m+1 )begin
			rs_out_table[m].inst = n_rs[m].rs_inst;
			rs_out_table[m].busy = n_rs[m].busy_rs;
			rs_out_table[m].p_rd = n_rs[m].p_rd;
			rs_out_table[m].preg1 = n_rs[m].preg1;
			rs_out_table[m].preg2 = n_rs[m].preg2;
			rs_out_table[m].preg1_ready = n_rs[m].preg1_ready;
			rs_out_table[m].preg2_ready = n_rs[m].preg2_ready;    
		end

	
	end

////////////////////reset and writing into rs///////////////////////////

	always_ff @(posedge clock) begin
		if(reset || halt_flag)begin
			rs_out_table_print <= `SD 0;
			for(int g=0; g<`RS_depth; g=g+1 )begin
				rs[g] <= `SD {
							`XLEN'd0, //n_rs[j+compress_cnt].NPC = n_rs[j].NPC;
							`XLEN'd0,//n_rs[j+compress_cnt].PC = n_rs[j].PC;
							OPA_IS_RS1,//n_rs[j+compress_cnt].opa_select = n_rs[j].opa_select;
							OPB_IS_RS2,//n_rs[j+compress_cnt].opb_select = n_rs[j].opb_select;
							`NOP,//n_rs[j+compress_cnt].inst = n_rs[j].inst;
							ALU_ADD,//n_rs[j+compress_cnt].alu_func = n_rs[j].alu_func;
							`FALSE,//n_rs[j+compress_cnt].rd_mem = n_rs[j].rd_mem;
							`FALSE,//n_rs[j+compress_cnt].wr_mem = n_rs[j].wr_mem;
							`FALSE,//n_rs[j+compress_cnt].cond_branch = n_rs[j].cond_branch;
							`FALSE,//n_rs[j+compress_cnt].uncond_branch = n_rs[j].uncond_branch;
							`FALSE,//n_rs[j+compress_cnt].halt = n_rs[j].halt;
							`FALSE,//n_rs[j+compress_cnt].illegal = n_rs[j].illegal;
							`FALSE,//n_rs[j+compress_cnt].csr_op = n_rs[j].csr_op;
							`FALSE,//n_rs[j+compress_cnt].valid = n_rs[j].valid;

							`FALSE,//n_rs[j+compress_cnt].busy_rs = n_rs[j].busy_rs;
							1'd0,//n_rs[j+compress_cnt].p_rd = n_rs[j].p_rd;
							`Preg_LEN'd0,//n_rs[j+compress_cnt].preg1 = n_rs[j].preg1;
							`Preg_LEN'd0,//n_rs[j+compress_cnt].preg2 = n_rs[j].preg2;
							1'd0,//n_rs[j+compress_cnt].preg1_ready = n_rs[j].preg1_ready;
							1'd0,//n_rs[j+compress_cnt].preg2_ready = n_rs[j].preg2_ready;
							`b_mask_reg_width'd0,//n_rs[j+compress_cnt].b_mask = n_rs[j].b_mask;
							1'd0,
							1'd0,
							`width_b_mask_len'd0,
							1'd0,
							`XLEN'd0,
							'd0,
							'd0,
							'd0,
							'd0
				};
			end
		end
		else begin
			rs_out_table_print <= `SD rs_out_table;
			rs <= `SD n_rs;
		end
	end
endmodule
