`timescale 1ns/100ps
module Dispatcher(	
	input         clock,              // system clock
	input         reset,              // system reset
	input  IF_ID_PACKET [`N_way-1 :0] if_id_packet_in,        //from if stage to instruction decoder
	input[$clog2(`N_way) :0]  num_avail_rs,				//available num of entries in rob, 0 ? 1? the reason of setting
	input[$clog2(`N_way) :0]  num_avail_rob,			//available num in rob
	input[$clog2(`N_way) :0]  num_avail_fl,            //available num in freelist
	// input[`SQ_LEN :0]  num_avail_lsq, 
	input sq_empty, 
	// input[$clog2(`width_b_mask):0] avail_num_b_mask,
////////////////for recovery//////////////////////
    // output  logic brat_full_stall,                  ///when brat is full, stall pipeline
	output logic flag_back_pc,
	output logic [`XLEN-1:0] back2fetch_pc,                         //for fetching inst in next cycle if there is a structure hazard in rs,rob,fl or lsq
	output DP_BRAT_PACKET [`N_way-1 :0 ] dp_brat_packet_out,
	output Dispatch_TO_ConnectedROB_PACKET [`N_way-1 :0 ] dp_rob_packet_out //rob
    );
	logic [`N_way-1:0] [`width_b_mask-1:0] b_mask_reg_out;
	BRAT_RS_PACKET [`N_way-1 :0] id_packet_out;
  	logic[$clog2(`N_way) :0] comp_rs_rob;       	//comparing rs with rob
  	// logic[$clog2(`N_way) :0] comp_fl_lsq;			//comparing fl with lsq
  	logic[$clog2(`N_way) :0] inst_cnt;				//number of instruction  which should be dispatched
  	DEST_REG_SEL [`N_way-1 :0] dest_reg_select; 
  	logic[`N_way-1 :0]  wr2brat_en;
	// logic [`SQ_LEN :0] num_avail_lsq_tmp;
	logic sq_empty_tmp;
    logic [$clog2(`N_way) :0] valid_inst_cnt;	
	logic [$clog2(`N_way) :0] comp_valid_fl;
	
	generate
        genvar i;
		for(i=0;i<`N_way;i=i+1)begin:decode_Instantiations
			decoder decoder_0 (
			.if_packet(if_id_packet_in[i]),	 
			// Outputs
			.opa_select(id_packet_out[i].opa_select),
			.opb_select(id_packet_out[i].opb_select),
			.alu_func(id_packet_out[i].alu_func),
			.dest_reg(dest_reg_select[i]),
			.rd_mem(id_packet_out[i].rd_mem),
			.wr_mem(id_packet_out[i].wr_mem),
			.cond_branch(id_packet_out[i].cond_branch),
			.uncond_branch(id_packet_out[i].uncond_branch),
			.csr_op(id_packet_out[i].csr_op),
			.halt(id_packet_out[i].halt),
			.illegal(id_packet_out[i].illegal),
			.valid_inst(id_packet_out[i].valid),
			.if_mul(id_packet_out[i].if_mul),
			.wr2brat_en(wr2brat_en[i])               
		);
			end 
    endgenerate
	always_comb begin
			back2fetch_pc='d0;
			valid_inst_cnt='d0;
            comp_valid_fl='d0;




			for(int i=0 ; i<`N_way;i=i+1)begin
				if(if_id_packet_in[i].valid)begin
					valid_inst_cnt = valid_inst_cnt + 1;
				end
			end
			//////////////////////compare within rob,rs,freelist,lsq and chosing min num//////////////
			comp_rs_rob=0;
			inst_cnt=0;
			if(num_avail_rs<num_avail_rob)begin
				comp_rs_rob=num_avail_rs;
			end
			else begin
				comp_rs_rob=num_avail_rob;
			end
            if(valid_inst_cnt<num_avail_fl)begin
				comp_valid_fl=valid_inst_cnt;
			end
			else begin
				comp_valid_fl=num_avail_fl;
			end
			if(comp_rs_rob<comp_valid_fl)begin
				inst_cnt=comp_rs_rob;
			end
			else begin
				inst_cnt=comp_valid_fl;
			end
			// comp_fl_lsq=0;
			// if(num_avail_fl<num_avail_lsq)begin
			// 	comp_fl_lsq=num_avail_fl;
			// end
			// else begin
			// 	comp_fl_lsq=num_avail_lsq;
			// end
			// if(comp_rs_rob<comp_fl_lsq)begin
			// 	inst_cnt=comp_rs_rob;
			// end
			// else begin
			// 	inst_cnt=comp_fl_lsq;
			// end
			
			///////////right num of dispatched inst////////////
		flag_back_pc=1'b0;
		// brat_full_stall=1'b0;
		
		if(inst_cnt<valid_inst_cnt)begin
			flag_back_pc=1'b1;                                 //this is a flag, using  in fetch stagewhen this is 1
		end
		for (int j=0;j<`N_way;j=j+1)begin
			dp_brat_packet_out[j] = 0;
				// dp_brat_packet_out[j].opa_select = OPA_IS_RS1;
				// dp_brat_packet_out[j].opb_select = OPB_IS_RS2;
				// dp_brat_packet_out[j].alu_func = ALU_ADD;
				// dp_brat_packet_out[j].rd_mem = `FALSE;
				// dp_brat_packet_out[j].wr_mem = `FALSE;
				// dp_brat_packet_out[j].cond_branch = `FALSE;
				// dp_brat_packet_out[j].uncond_branch = `FALSE;
				// dp_brat_packet_out[j].csr_op = `FALSE;
				// dp_brat_packet_out[j].halt = `FALSE;
				// dp_brat_packet_out[j].illegal = `FALSE;
				// dp_brat_packet_out[j].valid = `FALSE;
				// dp_brat_packet_out[j].if_mul = `FALSE;
				// dp_brat_packet_out[j].inst = `NOP;
				// dp_brat_packet_out[j].NPC  =0;
				// dp_brat_packet_out[j].PC   = 0;
				// dp_brat_packet_out[j].is_branch = 0 ;
				
			dp_rob_packet_out[j] = 0;
				// dp_rob_packet_out[j].rd_mem = `FALSE;
				// dp_rob_packet_out[j].wr_mem = `FALSE;
				// dp_rob_packet_out[j].inst = `NOP;
				// dp_rob_packet_out[j].Dispatch_enable = `FALSE;
				// dp_rob_packet_out[j].Rs1_Areg = `ZERO_REG;
				// dp_rob_packet_out[j].Rs2_Areg = `ZERO_REG;
				// dp_rob_packet_out[j].Rd_Areg = `ZERO_REG;
				// dp_rob_packet_out[j].Dispatch_Rd_available = 1'b0;
				// dp_rob_packet_out[j].is_branch =1'b0;

				// dp_rob_packet_out[j].cond_branch = `FALSE;
				// dp_rob_packet_out[j].uncond_branch = `FALSE;
				// dp_rob_packet_out[j].csr_op = `FALSE;
				// dp_rob_packet_out[j].halt = `FALSE;
				// dp_rob_packet_out[j].illegal = `FALSE;
				// dp_rob_packet_out[j].valid = `FALSE;
				// dp_rob_packet_out[j].NPC  =0;
				// dp_rob_packet_out[j].PC   = 0;

				// dp_brat_packet_out[j].BP_predicted_taken= 0;
				// dp_brat_packet_out[j].BP_predicted_target_PC = 0;

		end
		// num_avail_lsq_tmp = num_avail_lsq;
		sq_empty_tmp = sq_empty;
		for(int j=0;j<`N_way;j=j+1)begin
			if(j<inst_cnt && id_packet_out[j].valid)begin   //  || (j<inst_cnt && !wr2brat_en[j]) && avail_num_b_mask ==0
				//////////////dp to brat ////////////////////
				if(sq_empty_tmp==1 && id_packet_out[j].rd_mem)begin
					dp_brat_packet_out[j].load_issue_valid = 1;
				end
				else if(id_packet_out[j].wr_mem)begin
					sq_empty_tmp = 0;
				end
				dp_brat_packet_out[j].opa_select = id_packet_out[j].opa_select;
				dp_brat_packet_out[j].opb_select = id_packet_out[j].opb_select;
				dp_brat_packet_out[j].alu_func = id_packet_out[j].alu_func;
				dp_brat_packet_out[j].rd_mem = id_packet_out[j].rd_mem;
				dp_brat_packet_out[j].wr_mem = id_packet_out[j].wr_mem;
				dp_brat_packet_out[j].cond_branch = id_packet_out[j].cond_branch;
				dp_brat_packet_out[j].uncond_branch = id_packet_out[j].uncond_branch;
				dp_brat_packet_out[j].csr_op = id_packet_out[j].csr_op;
				dp_brat_packet_out[j].halt = id_packet_out[j].halt;
				dp_brat_packet_out[j].illegal = id_packet_out[j].illegal;
				dp_brat_packet_out[j].valid = id_packet_out[j].valid;
				dp_brat_packet_out[j].if_mul = id_packet_out[j].if_mul;
				dp_brat_packet_out[j].inst = if_id_packet_in[j].inst;
				dp_brat_packet_out[j].NPC  = if_id_packet_in[j].NPC;
				dp_brat_packet_out[j].PC   = if_id_packet_in[j].PC;
				dp_brat_packet_out[j].is_branch = id_packet_out[j].uncond_branch | id_packet_out[j].cond_branch;
				dp_brat_packet_out[j].BP_predicted_taken= if_id_packet_in[j].BP_predicted_taken;
				dp_brat_packet_out[j].BP_predicted_target_PC = if_id_packet_in[j].BP_predicted_target_PC;
				/// to rob connected rs

				dp_rob_packet_out[j].rd_mem = id_packet_out[j].rd_mem;
				dp_rob_packet_out[j].wr_mem = id_packet_out[j].wr_mem;
				dp_rob_packet_out[j].inst = if_id_packet_in[j].inst;
				dp_rob_packet_out[j].Dispatch_enable = id_packet_out[j].valid;
				dp_rob_packet_out[j].Rs1_Areg = if_id_packet_in[j].inst.r.rs1;
				// if(id_packet_out[j].opb_select != OPB_IS_RS2 && id_packet_out[j].uncond_branch)
				if((id_packet_out[j].opb_select != OPB_IS_RS2)&&(id_packet_out[j].opb_select != OPB_IS_S_IMM) && (id_packet_out[j].opb_select != OPB_IS_B_IMM)) // || id_packet_out[j].uncond_branch
					dp_rob_packet_out[j].Rs2_Areg = 0;
				else
					dp_rob_packet_out[j].Rs2_Areg = if_id_packet_in[j].inst.r.rs2;
				dp_rob_packet_out[j].is_branch = id_packet_out[j].uncond_branch | id_packet_out[j].cond_branch;
		
				dp_rob_packet_out[j].cond_branch = id_packet_out[j].cond_branch;
				dp_rob_packet_out[j].uncond_branch = id_packet_out[j].uncond_branch;
				dp_rob_packet_out[j].csr_op = id_packet_out[j].csr_op;
				dp_rob_packet_out[j].halt = id_packet_out[j].halt;
				dp_rob_packet_out[j].illegal = id_packet_out[j].illegal;
				dp_rob_packet_out[j].valid = id_packet_out[j].valid;
				dp_rob_packet_out[j].NPC  = if_id_packet_in[j].NPC;
				dp_rob_packet_out[j].PC   = if_id_packet_in[j].PC;

				
				case (dest_reg_select[j])
				DEST_RD:  begin
					dp_rob_packet_out[j].Rd_Areg = if_id_packet_in[j].inst.r.rd; 
					dp_rob_packet_out[j].Dispatch_Rd_available = 1'b1;
					end//mei gai ming
				DEST_NONE:  begin 
					dp_rob_packet_out[j].Rd_Areg = `ZERO_REG;
					dp_rob_packet_out[j].Dispatch_Rd_available = 1'b0;
				end
				default: begin 
					dp_rob_packet_out[j].Rd_Areg = `ZERO_REG;
					dp_rob_packet_out[j].Dispatch_Rd_available = 1'b0;
				end
				endcase
			end
			if(j<inst_cnt &&if_id_packet_in[j].BP_predicted_taken && wr2brat_en[j] )begin
				back2fetch_pc=if_id_packet_in[j].BP_predicted_target_PC;
				flag_back_pc=1'b1;
				break;
			end

			// if(j<inst_cnt && avail_num_b_mask ==0 && wr2brat_en[j])begin
			// 	brat_full_stall=1'b1;
			// 	flag_back_pc=1'b1;
			// 	back2fetch_pc=if_id_packet_in[j].PC;
			// 	dp_brat_packet_out[j].valid = 1'b0;
			// 	dp_rob_packet_out[j].valid =1'b0;
			// 	dp_rob_packet_out[j].Dispatch_enable = 1'b0;

			// 	break;
			// end
			if(j==inst_cnt && id_packet_out[j].valid)begin
				back2fetch_pc=if_id_packet_in[j].PC;          /// if available num in rs is 2 for fetech
			end
		end
	end//end comb
endmodule
