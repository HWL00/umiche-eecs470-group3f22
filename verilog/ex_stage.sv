//////////////////////////////////////////////////////////////////////////
//                                                                      //
//   Modulename :  ex_stage.v                                           //
//                                                                      //
//  Description :  instruction execute (EX) stage of the pipeline;      //
//                 given the instruction command code CMD, select the   //
//                 proper input A and B for the ALU, compute the result,// 
//                 and compute the condition for branches, and pass all //
//                 the results down the pipeline. MWB                   // 
//                                                                      //
//                                                                      //
//////////////////////////////////////////////////////////////////////////
`ifndef __EX_STAGE_V__
`define __EX_STAGE_V__

`timescale 1ns/100ps


module round_robin_arbiter (
input         clock,
input         reset,
input [`ALU_num-1:0] req,
input [`MUL_num-1:0] mul_arbiter_request,
input load_arbiter_request,
output logic [`ALU_num-1:0]  grant
);

	logic [`ALU_num-1:0] req_masked;
	logic [`ALU_num-1:0] req_unmasked;
	logic [`ALU_num-1:0] mask_higher_pri_reqs;
	logic [`ALU_num-1:0] unmask_higher_pri_reqs;

	logic [`ALU_num-1:0] pointer_reg;
	logic [2:0]j;
	logic [2:0]max_j;
	// Simple priority arbitration for masked portion
	// assign req_masked = req & pointer_reg;
	// assign req_unmasked = req & ~pointer_reg;
	always_comb begin
		req_masked = req & pointer_reg;
		req_unmasked = req & ~pointer_reg;

		j = 0;
		mask_higher_pri_reqs = req_masked;
		unmask_higher_pri_reqs = req_unmasked;
		grant = 0;
		// grant[1] =req[1];
		// grant[0] =req[0];
		max_j = `N_way-1-load_arbiter_request-mul_arbiter_request[1]-mul_arbiter_request[0];
		for(int i=0;i<`ALU_num;i++) begin
			if(req_masked[i]==1)begin
				if(j<=max_j) begin
					mask_higher_pri_reqs[i] = 1'b0;
					grant[i] = 1'b1;
					j = j + 1;
				end
				else
					break;
			end
		end
		if(j<=`N_way-1)begin
			for(int i=0;i<`ALU_num;i++)begin
				if(req_unmasked[i]==1)begin
					if(j<=max_j) begin
						unmask_higher_pri_reqs[i] = 1'b0;
						grant[i] = 1'b1;
						j = j+1;
					end
				end
			end
		end
	end

// Pointer update
always @ (posedge clock) begin
	if (reset) begin
		pointer_reg <=  `SD {`ALU_num{1'b1}};
	end 
	else begin
		if (|mask_higher_pri_reqs)  // Which arbiter was used?
			pointer_reg <=  `SD mask_higher_pri_reqs;
		else if (|unmask_higher_pri_reqs)  // Which arbiter was used?
			pointer_reg <=  `SD unmask_higher_pri_reqs;
		else
			pointer_reg <=  `SD {`ALU_num{1'b1}};
  	end
end

endmodule


module alu(
	input [`XLEN-1:0] opa,
	input [`XLEN-1:0] opb,
	input ALU_FUNC     func,
	input [`XLEN-1:0] br_rs1,    // Value to check against condition
	input [`XLEN-1:0] br_rs2,
	input  [2:0] br_func,  // Specifies which condition to check
	input cond_branch,

	output logic [`XLEN-1:0] result,
	output logic br_cond
);
	logic signed [`XLEN-1:0] signed_opa, signed_opb;
	
	always_comb begin
		signed_opa = opa;
		signed_opb = opb;
		case (func)
			ALU_ADD:      result = opa + opb;
			ALU_SUB:      result = opa - opb;
			ALU_AND:      result = opa & opb;
			ALU_SLT:      result = signed_opa < signed_opb;
			ALU_SLTU:     result = opa < opb;
			ALU_OR:       result = opa | opb;
			ALU_XOR:      result = opa ^ opb;
			ALU_SRL:      result = opa >> opb[4:0];
			ALU_SLL:      result = opa << opb[4:0];
			ALU_SRA:      result = signed_opa >>> opb[4:0]; // arithmetic from logical shift
			default:      result = `XLEN'hfacebeec;  // here to prevent latches
		endcase
	end


	brcond brcond_0 (
		// Inputs
		.cond_branch(cond_branch),
		.br_rs1(br_rs1), 
		.br_rs2(br_rs2),
		.br_func(br_func), 
		// Output
		.br_cond(br_cond)
	);
endmodule // alu

//
// BrCond module
//
// Given the instruction code, compute the proper condition for the
// instruction; for branches this condition will indicate whether the
// target is taken.
//
// This module is purely combinational
//
module brcond(// Inputs
	input [`XLEN-1:0] br_rs1,    // Value to check against condition
	input [`XLEN-1:0] br_rs2,
	input  [2:0] br_func,  // Specifies which condition to check
	input cond_branch,
	output logic br_cond    // 0/1 condition result (False/True)
);

	logic signed [`XLEN-1:0] signed_rs1, signed_rs2;

	always_comb begin
		signed_rs1 = br_rs1;
		signed_rs2 = br_rs2;
		br_cond = 0;
		case (br_func)
			3'b000: br_cond = signed_rs1 == signed_rs2;  // BEQ
			3'b001: br_cond = signed_rs1 != signed_rs2;  // BNE
			3'b100: br_cond = signed_rs1 < signed_rs2;   // BLT
			3'b101: br_cond = signed_rs1 >= signed_rs2;  // BGE
			3'b110: br_cond = br_rs1 < br_rs2;           // BLTU
			3'b111: br_cond = br_rs1 >= br_rs2;          // BGEU
		endcase
		if(cond_branch)
			br_cond = br_cond;
		else
			br_cond = 0;
	end
	
endmodule // brcond


module ex_stage(
	input clock,               // system clock
	input reset,               // system reset
	input IS_EX_PACKET  [`ALU_num-1:0] is_ex_alu_packet_in, 
	input IS_EX_PACKET  [`MUL_num-1:0] is_ex_mul_packet_in,
	input IS_EX_PACKET is_ex_load_packet_in,
	input IS_EX_PACKET is_ex_store_packet_in,
	input EX_COM_PACKET ex_ld_packet_to_execute, //from Lsq and d cache to arbiter
	// input sq_memsize_stall,
	// input sq_memsize_stall_tmp,

	output EX_COM_PACKET [`N_way-1:0] ex_packet_out_N,
	output EX_COM_PACKET ex_out_packet_store,
	output EX_COM_PACKET ex_ld_packet_out,	//to sq and D cache
	output logic [`ALU_num-1:0] alu_busy_bits,
	output logic [`MUL_num-1:0] mul_busy_bits,
	// for debug
	output EX_COM_PACKET [`FU_num-1:0] ex_packet_out,

	output logic[`ALU_num-1:0]mis_bp,
	output logic[`XLEN-1:0]target_PC_bp_out,
	output logic [`ALU_num-1:0]is_branch,

	input clean_brat_en,
	input [$clog2(`b_mask_reg_width)-1:0]clean_brat_num,
	output logic [`ALU_num-1:0]clean_bit_brat_en,
	output logic [`ALU_num-1:0][$clog2(`b_mask_reg_width)-1:0]clean_bit_brat_num,
	output C_BTB_table[`ALU_num-1:0]  c_btb_packet
);
	C_BTB_table[`ALU_num-1:0]  c_btb_packet_tmp;
	logic[`ALU_num-1:0]mis_bp_tmp;
	logic [`ALU_num-1:0]is_branch_tmp;
	logic [`ALU_num-1:0]clean_bit_brat_en_tmp;
	logic [`ALU_num-1:0][$clog2(`b_mask_reg_width)-1:0]clean_bit_brat_num_tmp;

	IS_EX_PACKET  [`ALU_num-1:0] is_ex_alu_packet_in_save;
	IS_EX_PACKET  [`ALU_num-1:0] is_ex_alu_packet_in_input;
	IS_EX_PACKET is_ex_load_packet_in_save;
	EX_COM_PACKET [`FU_num-1:0] ex_packet_out_save;

	IS_EX_PACKET  is_ex_mul_packet_in_save_mul0;
	IS_EX_PACKET  is_ex_mul_packet_in_save_mul1;


	logic [`ALU_num-1:0] alu_busy_bits_tmp;
	logic [`MUL_num-1:0] mul_busy_bits_tmp;
	
	logic [`ALU_num-1:0] arbiter_out;
	logic [`FU_num-1:0]final_arbiter;
	//------------------------------------------mul------------------------------------------
	logic start0,start1;
	logic [1:0] sign0,sign1;
	logic [`XLEN-1:0] mcand0, mplier0;
	logic [`XLEN-1:0] mcand1, mplier1;

	logic [`XLEN-1:0] final_product0;
	logic [`XLEN-1:0] final_product1;
	logic [2*`XLEN-1:0] product0;
	logic [2*`XLEN-1:0] product1;
	logic mul0_done;
	logic mul1_done;
	// logic mul0_done_arbiter;
	// logic mul1_done_arbiter;


	always_comb begin

		mul_busy_bits_tmp = mul_busy_bits;

		start0 = is_ex_mul_packet_in[1].if_mul && is_ex_mul_packet_in[1].valid;
		start1 = is_ex_mul_packet_in[0].if_mul && is_ex_mul_packet_in[0].valid;
	
		mcand0 = is_ex_mul_packet_in[1].prs1_value;
		mplier0 = is_ex_mul_packet_in[1].prs2_value;

		mcand1 = is_ex_mul_packet_in[0].prs1_value;
		mplier1 = is_ex_mul_packet_in[0].prs2_value;

		if(start0)
			mul_busy_bits_tmp[1] = 1'b1;
		if(start1)
			mul_busy_bits_tmp[0] = 1'b1;
		if(mul0_done && final_arbiter[1])
			mul_busy_bits_tmp[1] = 1'b0;
		if(mul1_done && final_arbiter[0])
			mul_busy_bits_tmp[0] = 1'b0;
		if(clean_brat_en && is_ex_mul_packet_in_save_mul0.is_b_mask[clean_brat_num]==1)begin
			mul_busy_bits_tmp[1] = 1'b0;
		end
		if(clean_brat_en && is_ex_mul_packet_in_save_mul1.is_b_mask[clean_brat_num]==1)begin
			mul_busy_bits_tmp[0] = 1'b0;
		end
	
	end

	always_comb begin
		case(is_ex_mul_packet_in[1].alu_func) 
			ALU_MUL:		sign0 = 2'b11;
			ALU_MULH:		sign0 = 2'b11;
			ALU_MULHSU:		sign0 = 2'b10;
			ALU_MULHU:		sign0 = 2'b00;
			default:		sign0 = 2'b00;
		endcase
	end

	always_comb begin
		case(is_ex_mul_packet_in[0].alu_func)
			ALU_MUL:		sign1 = 2'b11;
			ALU_MULH:		sign1 = 2'b11;
			ALU_MULHSU:		sign1 = 2'b10;
			ALU_MULHU:		sign1 = 2'b00;
			default:		sign1 = 2'b00;
		endcase
	end



	mult #(.XLEN(32), .NUM_STAGE(4)) mul0 (	//in packet 1
		.clock(clock), 
		.reset(reset),
		.start(start0),
		.sign(sign0),
		.mcand(mcand0), 
		.mplier(mplier0),
		.is_ex_mul_packet_save_mul(is_ex_mul_packet_in[1]),
		.is_ex_mul_packet_save_mul_out(is_ex_mul_packet_in_save_mul0),
		.clean_brat_en(clean_brat_en),
		.clean_brat_num(clean_brat_num),
		.clean_bit_brat_en_tmp(clean_bit_brat_en_tmp),
		.clean_bit_brat_num_tmp(clean_bit_brat_num_tmp),

		.product(product0),
		.done(mul0_done)
	);

	mult #(.XLEN(32), .NUM_STAGE(4)) mul1 (	//in packet 0
		.clock(clock), 
		.reset(reset),
		.start(start1),
		.sign(sign1),
		.mcand(mcand1), 
		.mplier(mplier1),
		.is_ex_mul_packet_save_mul(is_ex_mul_packet_in[0]),
		.is_ex_mul_packet_save_mul_out(is_ex_mul_packet_in_save_mul1),
		.clean_brat_en(clean_brat_en),
		.clean_brat_num(clean_brat_num),
		.clean_bit_brat_en_tmp(clean_bit_brat_en_tmp),
		.clean_bit_brat_num_tmp(clean_bit_brat_num_tmp),
		.product(product1),
		.done(mul1_done)
	);

	always_comb begin
		final_product0 = 0;
		final_product1 = 0;
		case(is_ex_mul_packet_in_save_mul0.alu_func)
			ALU_MUL:      final_product0 = product0[`XLEN-1:0];
			ALU_MULH:     final_product0 = product0[2*`XLEN-1:`XLEN];
			ALU_MULHSU:   final_product0 = product0[2*`XLEN-1:`XLEN];
			ALU_MULHU:    final_product0 = product0[2*`XLEN-1:`XLEN];
		endcase
		case(is_ex_mul_packet_in_save_mul1.alu_func)
			ALU_MUL:      final_product1 = product1[`XLEN-1:0];
			ALU_MULH:     final_product1 = product1[2*`XLEN-1:`XLEN];
			ALU_MULHSU:   final_product1 = product1[2*`XLEN-1:`XLEN];
			ALU_MULHU:    final_product1 = product1[2*`XLEN-1:`XLEN];
		endcase


		ex_packet_out[`FU_num-5].alu_result = final_product0;
		ex_packet_out[`FU_num-6].alu_result = final_product1;
		ex_packet_out[`FU_num-5].take_branch = 0; // mul doesn't have take branch
	 	ex_packet_out[`FU_num-6].take_branch = 0; // mul doesn't have take branch

	end
//------------------------------------------mul end------------------------------------------
//load store---------------------------------------------------------------------------


alu alu_store (													//alu 0 in:3 out: 5 /alu1 in: 2 out: 4/ alu2 in: 1 out:3/alu3 in:0 out:2
		.opa(is_ex_store_packet_in.prs1_value),
		.opb(`RV32_signext_Simm(is_ex_store_packet_in.inst)),
		.func(is_ex_store_packet_in.alu_func),
		.br_rs1(is_ex_store_packet_in.prs1_value), 
		.br_rs2(is_ex_store_packet_in.prs2_value),
		.br_func(is_ex_store_packet_in.inst.b.funct3), 
		.cond_branch(is_ex_store_packet_in.cond_branch),

		// Output
		.result(ex_out_packet_store.alu_result),
		.br_cond(ex_out_packet_store.take_branch)
		);
		
alu alu_load (													//alu 0 in:3 out: 5 /alu1 in: 2 out: 4/ alu2 in: 1 out:3/alu3 in:0 out:2
		.opa(is_ex_load_packet_in.prs1_value),
		.opb(`RV32_signext_Iimm(is_ex_load_packet_in.inst)),
		.func(is_ex_load_packet_in.alu_func),
		.br_rs1(is_ex_load_packet_in.prs1_value), 
		.br_rs2(is_ex_load_packet_in.prs2_value),
		.br_func(is_ex_load_packet_in.inst.b.funct3), 
		.cond_branch(is_ex_load_packet_in.cond_branch),

		// Output
		.result(ex_ld_packet_out.alu_result),
		.br_cond(ex_ld_packet_out.take_branch)
		);

//load store end-----------------------------------------------------------------------------------------

//------------------------------------------ALU------------------------------------------
	logic [`ALU_num-1:0] [`XLEN-1:0] opa_mux_out, opb_mux_out;
	logic [`ALU_num-1:0] arbiter_request;
	logic [`MUL_num-1:0] mul_arbiter_request;
	logic load_arbiter_request;

	always_comb begin
		is_ex_alu_packet_in_input = 0;
		for(int i=0;i<`ALU_num;i++)begin
			if(alu_busy_bits[i])begin
                begin
                    if(clean_brat_en && is_ex_alu_packet_in_save[i].is_b_mask[clean_brat_num]==1 && !is_ex_alu_packet_in_save[i].uncond_branch)begin
                        is_ex_alu_packet_in_input[i] = 0;
                    end
                    else begin
				        is_ex_alu_packet_in_input[i] = is_ex_alu_packet_in_save[i];
                    end
                end
				end
			else begin
				is_ex_alu_packet_in_input[i] = is_ex_alu_packet_in[i];
			end
		end

        for(int j=0;j<`ALU_num;j++)begin
			for(int i=0;i<`ALU_num;i++)begin
				if(clean_bit_brat_en_tmp[j])begin
                    is_ex_alu_packet_in_input[i].is_b_mask[clean_bit_brat_num_tmp[j]] = 0;
                end
			end
			for(int i=0;i<`MUL_num;i++)begin
				if(clean_bit_brat_en_tmp[j])begin
                    is_ex_alu_packet_in_input[i].is_b_mask[clean_bit_brat_num_tmp[j]] = 0;
                end
			end
		end

	end

	//
	// ALU opA mux
	//
	always_comb begin
		for(int i = 0; i < `ALU_num; i++)begin
			opa_mux_out[i] = `XLEN'hdeadfbac;
			case (is_ex_alu_packet_in_input[i].opa_select)
				OPA_IS_RS1:  opa_mux_out[i] = is_ex_alu_packet_in_input[i].prs1_value;
				OPA_IS_NPC:  opa_mux_out[i] = is_ex_alu_packet_in_input[i].NPC;
				OPA_IS_PC:   opa_mux_out[i] = is_ex_alu_packet_in_input[i].PC;
				OPA_IS_ZERO: opa_mux_out[i] = 0;
			endcase
		end
	end

	 //
	 // ALU opB mux
	 //
	always_comb begin
		for(int i = 0; i < `ALU_num; i++)begin
			opb_mux_out[i] = `XLEN'hfacefeed;
			case (is_ex_alu_packet_in_input[i].opb_select)
				OPB_IS_RS2:   opb_mux_out[i] = is_ex_alu_packet_in_input[i].prs2_value;
				OPB_IS_I_IMM: opb_mux_out[i] = `RV32_signext_Iimm(is_ex_alu_packet_in_input[i].inst);
				OPB_IS_S_IMM: opb_mux_out[i] = `RV32_signext_Simm(is_ex_alu_packet_in_input[i].inst);
				OPB_IS_B_IMM: opb_mux_out[i] = `RV32_signext_Bimm(is_ex_alu_packet_in_input[i].inst);
				OPB_IS_U_IMM: opb_mux_out[i] = `RV32_signext_Uimm(is_ex_alu_packet_in_input[i].inst);
				OPB_IS_J_IMM: opb_mux_out[i] = `RV32_signext_Jimm(is_ex_alu_packet_in_input[i].inst);
			endcase 
		end
	end
	generate
        genvar i;
		for(i=0;i<`ALU_num;i=i+1)begin:alu_instantiate
			alu alu_0 (													//alu 0 in:3 out: 5 /alu1 in: 2 out: 4/ alu2 in: 1 out:3/alu3 in:0 out:2
		.opa(opa_mux_out[`ALU_num-1-i]),
		.opb(opb_mux_out[`ALU_num-1-i]),
		.func(is_ex_alu_packet_in_input[`ALU_num-1-i].alu_func),
		.br_rs1(is_ex_alu_packet_in_input[`ALU_num-1-i].prs1_value), 
		.br_rs2(is_ex_alu_packet_in_input[`ALU_num-1-i].prs2_value),
		.br_func(is_ex_alu_packet_in_input[`ALU_num-1-i].inst.b.funct3), 
		.cond_branch(is_ex_alu_packet_in_input[`ALU_num-1-i].cond_branch),

		// Output
		.result(ex_packet_out[`FU_num-1-i].alu_result),
		.br_cond(ex_packet_out[`FU_num-1-i].take_branch)
		);
		end 

    endgenerate

//------------------------------------------ALU end------------------------------------------
	
	always_comb begin
		clean_bit_brat_en_tmp = 0;
		clean_bit_brat_num_tmp = 0;
		mis_bp_tmp = 0;
		target_PC_bp_out = 0;
		is_branch_tmp = is_branch;
		for(int i=0;i<`ALU_num;i++) begin
			is_branch_tmp[i] = is_ex_alu_packet_in_input[i].is_branch;
			if(is_ex_alu_packet_in_save[i].uncond_branch) begin
				if(is_ex_alu_packet_in_save[i].is_b_mask[clean_brat_num]==1 && clean_brat_num==is_ex_alu_packet_in_save[i].b_mask_bit_branch)
					target_PC_bp_out = ex_packet_out_save[`MUL_num+i].alu_result;
			end
			if(is_ex_alu_packet_in_input[i].uncond_branch) begin
				if(is_ex_alu_packet_in_input[i].target_PC_bp==ex_packet_out[`MUL_num+i].alu_result)begin
					mis_bp_tmp[i] = 0;
					clean_bit_brat_en_tmp[i] = 1;
					clean_bit_brat_num_tmp[i] = is_ex_alu_packet_in_input[i].b_mask_bit_branch;
				end
				else begin
					mis_bp_tmp[i] = 1;
					clean_bit_brat_en_tmp[i] = 0;
					clean_bit_brat_num_tmp[i] = is_ex_alu_packet_in_input[i].b_mask_bit_branch;
				end
			end

			if(is_ex_alu_packet_in_save[i].cond_branch) begin
				if(ex_packet_out_save[`MUL_num+i].take_branch) begin
					if(is_ex_alu_packet_in_save[i].is_b_mask[clean_brat_num]==1 && clean_brat_num==is_ex_alu_packet_in_save[i].b_mask_bit_branch)
						target_PC_bp_out = ex_packet_out_save[`MUL_num+i].alu_result;
				end
				else begin
					if(is_ex_alu_packet_in_save[i].is_b_mask[clean_brat_num]==1 && clean_brat_num==is_ex_alu_packet_in_save[i].b_mask_bit_branch)
						target_PC_bp_out = is_ex_alu_packet_in_save[i].NPC;
				end
			end
			if(is_ex_alu_packet_in_input[i].cond_branch) begin
				if(ex_packet_out[`MUL_num+i].take_branch) begin
					if(is_ex_alu_packet_in_input[i].cond_bp == ex_packet_out[`MUL_num+i].take_branch) begin
						mis_bp_tmp[i] = 0;
						clean_bit_brat_en_tmp[i] = 1;
						clean_bit_brat_num_tmp[i] = is_ex_alu_packet_in_input[i].b_mask_bit_branch;
					end
					else begin
						mis_bp_tmp[i] = 1;
						clean_bit_brat_en_tmp[i] = 0;
						clean_bit_brat_num_tmp[i] = is_ex_alu_packet_in_input[i].b_mask_bit_branch;
					end
				end
				else begin
					if(is_ex_alu_packet_in_input[i].cond_bp == ex_packet_out[`MUL_num+i].take_branch) begin
						mis_bp_tmp[i] = 0;
						clean_bit_brat_en_tmp[i] = 1;
						clean_bit_brat_num_tmp[i] = is_ex_alu_packet_in_input[i].b_mask_bit_branch;
					end
					else begin
						mis_bp_tmp[i] = 1;
						clean_bit_brat_en_tmp[i] = 0;
						clean_bit_brat_num_tmp[i] = is_ex_alu_packet_in_input[i].b_mask_bit_branch;
					end
				end
			end
		end
	end
	
	// Pass-throughs
	always_comb begin
		for(int i=0;i<`ALU_num;i++)begin
			ex_packet_out[i+`MUL_num].NPC = is_ex_alu_packet_in_input[i].NPC;
			ex_packet_out[i+`MUL_num].rs2_value = is_ex_alu_packet_in_input[i].prs2_value; //LSQ
			ex_packet_out[i+`MUL_num].rd_mem = is_ex_alu_packet_in_input[i].rd_mem;   //LSQ
			ex_packet_out[i+`MUL_num].wr_mem = is_ex_alu_packet_in_input[i].wr_mem;//LSQ
			ex_packet_out[i+`MUL_num].dest_reg_idx = is_ex_alu_packet_in_input[i].p_dest_reg_idx; //LSQ
			ex_packet_out[i+`MUL_num].halt = is_ex_alu_packet_in_input[i].halt;
			ex_packet_out[i+`MUL_num].illegal = is_ex_alu_packet_in_input[i].illegal;
			ex_packet_out[i+`MUL_num].csr_op = is_ex_alu_packet_in_input[i].csr_op;
			ex_packet_out[i+`MUL_num].valid = is_ex_alu_packet_in_input[i].valid;
			ex_packet_out[i+`MUL_num].mem_size = is_ex_alu_packet_in_input[i].inst.r.funct3;
			// Upated on 10.28
			ex_packet_out[i+`MUL_num].is_b_mask = is_ex_alu_packet_in_input[i].is_b_mask;
			ex_packet_out[i+`MUL_num].inst = is_ex_alu_packet_in_input[i].inst;
			ex_packet_out[i+`MUL_num].b_mask_bit_branch = is_ex_alu_packet_in_input[i].b_mask_bit_branch;
			ex_packet_out[i+`MUL_num].SQ_tail = is_ex_alu_packet_in_input[i].SQ_tail;
			ex_packet_out[i+`MUL_num].ROB_tail = is_ex_alu_packet_in_input[i].ROB_tail;
			ex_packet_out[i+`MUL_num].cond_branch = is_ex_alu_packet_in_input[i].cond_branch;
			ex_packet_out[i+`MUL_num].uncond_branch = is_ex_alu_packet_in_input[i].uncond_branch;
		end

	

		ex_ld_packet_out.NPC = is_ex_load_packet_in.NPC;
		ex_ld_packet_out.rs2_value = is_ex_load_packet_in.prs2_value; //LSQ
		ex_ld_packet_out.rd_mem = is_ex_load_packet_in.rd_mem;   //LSQ
		ex_ld_packet_out.wr_mem = is_ex_load_packet_in.wr_mem;//LSQ
		ex_ld_packet_out.dest_reg_idx = is_ex_load_packet_in.p_dest_reg_idx; //LSQ
		ex_ld_packet_out.halt = is_ex_load_packet_in.halt;
		ex_ld_packet_out.illegal = is_ex_load_packet_in.illegal;
		ex_ld_packet_out.csr_op = is_ex_load_packet_in.csr_op;
		ex_ld_packet_out.valid = is_ex_load_packet_in.valid;
		ex_ld_packet_out.mem_size = is_ex_load_packet_in.inst.r.funct3;

		ex_ld_packet_out.is_b_mask = is_ex_load_packet_in.is_b_mask;
		ex_ld_packet_out.inst = is_ex_load_packet_in.inst;
		ex_ld_packet_out.b_mask_bit_branch = is_ex_load_packet_in.b_mask_bit_branch;
		ex_ld_packet_out.SQ_tail = is_ex_load_packet_in.SQ_tail;
		ex_ld_packet_out.ROB_tail = is_ex_load_packet_in.ROB_tail;
		ex_ld_packet_out.no_sort_sq = is_ex_load_packet_in.no_sort_sq;
		ex_ld_packet_out.cond_branch = is_ex_load_packet_in.cond_branch;
		ex_ld_packet_out.uncond_branch = is_ex_load_packet_in.uncond_branch;

		

		ex_out_packet_store.NPC = is_ex_store_packet_in.NPC;
		ex_out_packet_store.rs2_value = is_ex_store_packet_in.prs2_value; //LSQ
		ex_out_packet_store.rd_mem = is_ex_store_packet_in.rd_mem;   //LSQ
		ex_out_packet_store.wr_mem = is_ex_store_packet_in.wr_mem;//LSQ
		ex_out_packet_store.dest_reg_idx = is_ex_store_packet_in.p_dest_reg_idx; //LSQ
		ex_out_packet_store.halt = is_ex_store_packet_in.halt;
		ex_out_packet_store.illegal = is_ex_store_packet_in.illegal;
		ex_out_packet_store.csr_op = is_ex_store_packet_in.csr_op;
		ex_out_packet_store.valid = is_ex_store_packet_in.valid;
		ex_out_packet_store.mem_size = is_ex_store_packet_in.inst.r.funct3;

		ex_out_packet_store.is_b_mask = is_ex_store_packet_in.is_b_mask;
		ex_out_packet_store.inst = is_ex_store_packet_in.inst;
		ex_out_packet_store.b_mask_bit_branch = is_ex_store_packet_in.b_mask_bit_branch;
		ex_out_packet_store.SQ_tail = is_ex_store_packet_in.SQ_tail;
		ex_out_packet_store.ROB_tail = is_ex_store_packet_in.ROB_tail;
		ex_out_packet_store.no_sort_sq = is_ex_store_packet_in.no_sort_sq;
		ex_out_packet_store.cond_branch = is_ex_store_packet_in.cond_branch;
		ex_out_packet_store.uncond_branch = is_ex_store_packet_in.uncond_branch;



		if(mul0_done) begin
			ex_packet_out[1].NPC = is_ex_mul_packet_in_save_mul0.NPC;
			ex_packet_out[1].rs2_value = is_ex_mul_packet_in_save_mul0.prs2_value; //LSQ
			ex_packet_out[1].rd_mem = is_ex_mul_packet_in_save_mul0.rd_mem;   //LSQ
			ex_packet_out[1].wr_mem = is_ex_mul_packet_in_save_mul0.wr_mem;//LSQ
			ex_packet_out[1].dest_reg_idx = is_ex_mul_packet_in_save_mul0.p_dest_reg_idx; //LSQ
			ex_packet_out[1].halt = is_ex_mul_packet_in_save_mul0.halt;
			ex_packet_out[1].illegal = is_ex_mul_packet_in_save_mul0.illegal;
			ex_packet_out[1].csr_op = is_ex_mul_packet_in_save_mul0.csr_op;
			ex_packet_out[1].valid = is_ex_mul_packet_in_save_mul0.valid;
			ex_packet_out[1].mem_size = is_ex_mul_packet_in_save_mul0.inst.r.funct3;

			ex_packet_out[1].is_b_mask = is_ex_mul_packet_in_save_mul0.is_b_mask;
			ex_packet_out[1].inst = is_ex_mul_packet_in_save_mul0.inst;
			ex_packet_out[1].b_mask_bit_branch = is_ex_mul_packet_in_save_mul0.b_mask_bit_branch;
			ex_packet_out[1].SQ_tail = is_ex_mul_packet_in_save_mul0.SQ_tail;
			ex_packet_out[1].ROB_tail = is_ex_mul_packet_in_save_mul0.ROB_tail;
			ex_packet_out[1].cond_branch = is_ex_mul_packet_in_save_mul0.cond_branch;
			ex_packet_out[1].uncond_branch = is_ex_mul_packet_in_save_mul0.uncond_branch;
			
		end
		else begin
			ex_packet_out[1].NPC = 0;
			ex_packet_out[1].rs2_value = 0; //LSQ
			ex_packet_out[1].rd_mem = 0;   //LSQ
			ex_packet_out[1].wr_mem = 0;//LSQ
			ex_packet_out[1].dest_reg_idx = 0; //LSQ
			ex_packet_out[1].halt = 0;
			ex_packet_out[1].illegal = 0;
			ex_packet_out[1].csr_op = 0;
			ex_packet_out[1].valid = 0;
			ex_packet_out[1].mem_size = BYTE;

			ex_packet_out[1].is_b_mask = 0;
			ex_packet_out[1].inst = 0;
			ex_packet_out[1].b_mask_bit_branch = 0;
			ex_packet_out[1].SQ_tail = 0; 
			ex_packet_out[1].ROB_tail = 0; 
			ex_packet_out[1].cond_branch = 0; 
			ex_packet_out[1].uncond_branch = 0; 
		end
		if(mul1_done) begin
			ex_packet_out[0].NPC = is_ex_mul_packet_in_save_mul1.NPC;
			ex_packet_out[0].rs2_value = is_ex_mul_packet_in_save_mul1.prs2_value; //LSQ
			ex_packet_out[0].rd_mem = is_ex_mul_packet_in_save_mul1.rd_mem;   //LSQ
			ex_packet_out[0].wr_mem = is_ex_mul_packet_in_save_mul1.wr_mem;//LSQ
			ex_packet_out[0].dest_reg_idx = is_ex_mul_packet_in_save_mul1.p_dest_reg_idx; //LSQ
			ex_packet_out[0].halt = is_ex_mul_packet_in_save_mul1.halt;
			ex_packet_out[0].illegal = is_ex_mul_packet_in_save_mul1.illegal;
			ex_packet_out[0].csr_op = is_ex_mul_packet_in_save_mul1.csr_op;
			ex_packet_out[0].valid = is_ex_mul_packet_in_save_mul1.valid;
			ex_packet_out[0].mem_size = is_ex_mul_packet_in_save_mul1.inst.r.funct3;

			ex_packet_out[0].is_b_mask = is_ex_mul_packet_in_save_mul1.is_b_mask;
			ex_packet_out[0].inst = is_ex_mul_packet_in_save_mul1.inst;
			ex_packet_out[0].b_mask_bit_branch = is_ex_mul_packet_in_save_mul1.b_mask_bit_branch;
			ex_packet_out[0].SQ_tail = is_ex_mul_packet_in_save_mul1.SQ_tail;
			ex_packet_out[0].ROB_tail = is_ex_mul_packet_in_save_mul1.ROB_tail;
			ex_packet_out[0].cond_branch = is_ex_mul_packet_in_save_mul1.cond_branch;
			ex_packet_out[0].uncond_branch = is_ex_mul_packet_in_save_mul1.uncond_branch;

		end
		else begin
			ex_packet_out[0].NPC = 0;
			ex_packet_out[0].rs2_value = 0; //LSQ
			ex_packet_out[0].rd_mem = 0;   //LSQ
			ex_packet_out[0].wr_mem = 0;//LSQ
			ex_packet_out[0].dest_reg_idx = 0; //LSQ
			ex_packet_out[0].halt = 0;
			ex_packet_out[0].illegal = 0;
			ex_packet_out[0].csr_op = 0;
			ex_packet_out[0].valid = 0;
			ex_packet_out[0].mem_size = BYTE;

			ex_packet_out[0].is_b_mask = 0;
			ex_packet_out[0].inst = 0;
			ex_packet_out[0].b_mask_bit_branch = 0;
			ex_packet_out[0].SQ_tail = 0;
			ex_packet_out[0].ROB_tail = 0;
			ex_packet_out[0].cond_branch = 0; 
			ex_packet_out[0].uncond_branch = 0; 
		end


        for(int i=0;i<`MUL_num;i++)begin
			if(clean_brat_en && is_ex_mul_packet_in[i].is_b_mask[clean_brat_num]==1)
				ex_packet_out[i].valid = 0; //is_ex_alu_packet_in[i].valid;
		end

		arbiter_request = 0;
		mul_arbiter_request = 0;
		load_arbiter_request = 0;
		arbiter_request = {	is_ex_alu_packet_in_input[`ALU_num-1].valid && !is_ex_alu_packet_in_input[`ALU_num-1].cond_branch,//is_ex_alu_packet_in_input[`ALU_num-1].p_dest_reg_idx, //(!is_ex_alu_packet_in_input[`ALU_num-1].is_branch||)
							is_ex_alu_packet_in_input[`ALU_num-2].valid && !is_ex_alu_packet_in_input[`ALU_num-2].cond_branch,//is_ex_alu_packet_in_input[`ALU_num-2].p_dest_reg_idx, //!is_ex_alu_packet_in_input[`ALU_num-2].is_branch,
							is_ex_alu_packet_in_input[`ALU_num-3].valid && !is_ex_alu_packet_in_input[`ALU_num-3].cond_branch,//is_ex_alu_packet_in_input[`ALU_num-3].p_dest_reg_idx, //!is_ex_alu_packet_in_input[`ALU_num-3].is_branch,
							is_ex_alu_packet_in_input[`ALU_num-4].valid && !is_ex_alu_packet_in_input[`ALU_num-4].cond_branch//is_ex_alu_packet_in_input[`ALU_num-4].p_dest_reg_idx,//!is_ex_alu_packet_in_input[`ALU_num-4].is_branch, 
							};
		mul_arbiter_request = {is_ex_mul_packet_in_save_mul0.valid && mul0_done, is_ex_mul_packet_in_save_mul1.valid && mul1_done };
		load_arbiter_request = ex_ld_packet_to_execute.valid;
	end


//------------------------------------------Arbiter------------------------------------------

	round_robin_arbiter ins(
		.req(arbiter_request),
		.load_arbiter_request(load_arbiter_request),
		.mul_arbiter_request(mul_arbiter_request),
		.clock(clock),
		.reset(reset),
		.grant(arbiter_out)
	);
	
	logic [`N_LEN:0] ex_out_bit;

	
	always_comb begin
		ex_out_bit = 0;
		ex_packet_out_N = 0;
		final_arbiter = {arbiter_out,mul_arbiter_request};
		for(int i = 0; i < `FU_num; i++)begin
			if(final_arbiter[i] && ex_out_bit<`N_way) begin
				ex_packet_out_N[ex_out_bit] = ex_packet_out[i];
				if(is_ex_alu_packet_in_input[i-`MUL_num].uncond_branch && i>=`MUL_num)      //jal cdb alu result =NPC
					ex_packet_out_N[ex_out_bit].alu_result = is_ex_alu_packet_in_input[i-`MUL_num].NPC;
				ex_out_bit = ex_out_bit+1;
			end
			
		end
		if(load_arbiter_request)begin
			ex_packet_out_N[`N_way-1] = ex_ld_packet_to_execute;		
		end
	end

	always_comb begin

		alu_busy_bits_tmp = reset? `ALU_num'd0 : alu_busy_bits_tmp;
		
		for(int i=0; i<`ALU_num; i++) begin
			alu_busy_bits_tmp[i] = final_arbiter[i+`MUL_num] ^ arbiter_request[i];//^ arbiter_request[i+`MUL_num];   
		end
	end

	always_comb begin
		for(int i=0;i<`ALU_num;i++)begin
			c_btb_packet_tmp[i].calculated_target = ex_packet_out[i+`MUL_num].alu_result;
			c_btb_packet_tmp[i].if_cond = is_ex_alu_packet_in_input[i].cond_branch;
			c_btb_packet_tmp[i].branch_pc = is_ex_alu_packet_in_input[i].PC;
			c_btb_packet_tmp[i].if_uncond = is_ex_alu_packet_in_input[i].uncond_branch;
			c_btb_packet_tmp[i].c_branch_taken= ex_packet_out[i+`MUL_num].take_branch;
		end
	end

	always_ff@(posedge clock) begin
		if(reset)begin
			alu_busy_bits <= `SD 0;
			mul_busy_bits <= `SD 0;
			mis_bp <= `SD 0;
			is_branch <= `SD 0;
			clean_bit_brat_en <= `SD 0;
			clean_bit_brat_num <= `SD 0;
			ex_packet_out_save <= `SD 0;
			is_ex_alu_packet_in_save <= `SD 0;
			c_btb_packet <= `SD 0;
			is_ex_load_packet_in_save <= `SD 0;
		end
		else begin
			alu_busy_bits <= `SD alu_busy_bits_tmp;
			mul_busy_bits <= `SD mul_busy_bits_tmp;
			mis_bp <= `SD mis_bp_tmp;
			is_branch <= `SD is_branch_tmp;
			clean_bit_brat_en <= `SD clean_bit_brat_en_tmp;
			clean_bit_brat_num <= `SD clean_bit_brat_num_tmp;
			ex_packet_out_save <= `SD ex_packet_out;
			is_ex_alu_packet_in_save <= `SD is_ex_alu_packet_in_input;
			c_btb_packet <= `SD c_btb_packet_tmp;
			is_ex_load_packet_in_save <= `SD is_ex_load_packet_in;
		end
	end

endmodule // module ex_stage
`endif // __EX_STAGE_V__