`ifndef __MULT_SV__
`define __MULT_SV__

module mult #(parameter XLEN = 32, parameter NUM_STAGE = 4) (
				input clock, reset,
				input start,
				input [1:0] sign,
				input [XLEN-1:0] mcand, mplier,
				input IS_EX_PACKET  is_ex_mul_packet_save_mul,
				input clean_brat_en,
				input [$clog2(`b_mask_reg_width)-1:0]clean_brat_num,
				input [`ALU_num-1:0][$clog2(`b_mask_reg_width)-1:0]clean_bit_brat_num_tmp,
				input [`ALU_num-1:0]clean_bit_brat_en_tmp,
				
				// output [(2*XLEN)-1:0] product,
				output IS_EX_PACKET  is_ex_mul_packet_save_mul_out,
				output [2*XLEN-1:0] product,
				output done
			);
	IS_EX_PACKET  next_is_ex_mul_packet_in_save_mul;
	logic [(2*XLEN)-1:0] mcand_out, mplier_out, mcand_in, mplier_in;
	logic [NUM_STAGE:0][2*XLEN-1:0] internal_mcands, internal_mpliers;
	logic [NUM_STAGE:0][2*XLEN-1:0] internal_products;
	logic [NUM_STAGE:0] internal_dones;
	logic clean;
	assign mcand_in  = sign[0] ? {{XLEN{mcand[XLEN-1]}}, mcand}   : {{XLEN{1'b0}}, mcand} ;
	assign mplier_in = sign[1] ? {{XLEN{mplier[XLEN-1]}}, mplier} : {{XLEN{1'b0}}, mplier};

	assign internal_mcands[0]   = mcand_in;
	assign internal_mpliers[0]  = mplier_in;
	assign internal_products[0] = 'h0;
	assign internal_dones[0]    = start;

	assign done    = internal_dones[NUM_STAGE];
	assign product = internal_products[NUM_STAGE];

	genvar i;
	for (i = 0; i < NUM_STAGE; ++i) begin : mstage
		mult_stage #(.XLEN(XLEN), .NUM_STAGE(NUM_STAGE)) ms (
			.clock(clock),
			.reset(reset),
			.clean(clean),
			.product_in(internal_products[i]),
			.mplier_in(internal_mpliers[i]),
			.mcand_in(internal_mcands[i]),
			.start(internal_dones[i]),
			.product_out(internal_products[i+1]),
			.mplier_out(internal_mpliers[i+1]),
			.mcand_out(internal_mcands[i+1]),
			.done(internal_dones[i+1])
		);
	end
	always_comb begin
		clean = 0;
		next_is_ex_mul_packet_in_save_mul = is_ex_mul_packet_save_mul_out;
		if(clean_brat_en && next_is_ex_mul_packet_in_save_mul.is_b_mask[clean_brat_num]==1)begin
				next_is_ex_mul_packet_in_save_mul = 0; //is_ex_alu_packet_in[i].valid;
				clean = 1;
		end
		for(int j=0;j<`ALU_num;j++)begin
			if(clean_bit_brat_en_tmp[j])
				next_is_ex_mul_packet_in_save_mul.is_b_mask[clean_bit_brat_num_tmp[j]] = 0;
		end
	
	end

	always_ff@(posedge clock) begin
		if(reset)
			is_ex_mul_packet_save_mul_out <= `SD 0;
		else if(done) begin
			is_ex_mul_packet_save_mul_out <= `SD 0;
		end
		else if(start)
			is_ex_mul_packet_save_mul_out <= `SD is_ex_mul_packet_save_mul;
		else
			is_ex_mul_packet_save_mul_out <= `SD next_is_ex_mul_packet_in_save_mul;
			// next_is_ex_mul_packet_in_save_mul <= `SD is_ex_mul_packet_save_mul;
	end
endmodule

module mult_stage #(parameter XLEN = 32, parameter NUM_STAGE = 4) (
					input clock, reset, start,
					input [(2*XLEN)-1:0] mplier_in, mcand_in,
					input [(2*XLEN)-1:0] product_in,
					input clean,
					output logic done,
					output logic [(2*XLEN)-1:0] mplier_out, mcand_out,
					output logic [(2*XLEN)-1:0] product_out
				);

	parameter NUM_BITS = (2*XLEN)/NUM_STAGE;

	logic [(2*XLEN)-1:0] prod_in_reg, partial_prod, next_partial_product, partial_prod_unsigned;
	logic [(2*XLEN)-1:0] next_mplier, next_mcand;

	assign product_out = prod_in_reg + partial_prod;

	assign next_partial_product = mplier_in[(NUM_BITS-1):0] * mcand_in;

	assign next_mplier = {{(NUM_BITS){1'b0}},mplier_in[2*XLEN-1:(NUM_BITS)]};
	assign next_mcand  = {mcand_in[(2*XLEN-1-NUM_BITS):0],{(NUM_BITS){1'b0}}};

	//synopsys sync_set_reset "reset"
	always_ff @(posedge clock) begin
		if(!clean)begin
			prod_in_reg      <= `SD product_in;
			partial_prod     <=`SD next_partial_product;
			mplier_out       <= `SD next_mplier;
			mcand_out        <= `SD next_mcand;
		end
		else begin
			prod_in_reg      <= `SD 0;
			partial_prod     <=`SD 0;
			mplier_out       <= `SD 0;
			mcand_out        <= `SD 0;
		end
	end

	// synopsys sync_set_reset "reset"
	always_ff @(posedge clock) begin
		if(reset ||clean) begin
			done     <= `SD 1'b0;
		end else begin
			done     <= `SD start;
		end
	end

endmodule
`endif //__MULT_SV__
