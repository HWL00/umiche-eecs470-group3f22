module arbiter (
input         clock,
input         reset,
input [`MSHR_Depth-1:0] req,
input [`I_MSHR_Depth-1:0] I_req,
input [3:0]   mem2proc_response,
output logic [`MSHR_Depth-1:0] I_grant,
output logic [`MSHR_Depth-1:0]  grant
);

	logic [`MSHR_Depth-1:0] req_masked;
	logic [`MSHR_Depth-1:0] req_unmasked;
	logic [`MSHR_Depth-1:0] mask_higher_pri_reqs;
	logic [`MSHR_Depth-1:0] unmask_higher_pri_reqs;

	logic [`MSHR_Depth-1:0] pointer_reg;
	logic grant_flag;
	logic dcache_grant_flag;


	// logic [`I_MSHR_Depth-1:0] I_req_masked;
	// logic [`I_MSHR_Depth-1:0] I_req_unmasked;
	// logic [`I_MSHR_Depth-1:0] I_mask_higher_pri_reqs;
	// logic [`I_MSHR_Depth-1:0] I_unmask_higher_pri_reqs;

	// logic [`I_MSHR_Depth-1:0] I_pointer_reg;
	// logic I_grant_flag;

	always_comb begin
		dcache_grant_flag = 0;
		dcache_grant_flag = |req;
		req_masked = req & pointer_reg;
		req_unmasked = req & ~pointer_reg;
		grant_flag = 0;

		mask_higher_pri_reqs = req_masked;
		unmask_higher_pri_reqs = req_unmasked;
		grant = 0;
		I_grant=0;
		for(int i=0;i<`MSHR_Depth;i++) begin
			if(req_masked[i]==1)begin
					mask_higher_pri_reqs[i] = 1'b0;
					grant[i] = 1'b1;
					grant_flag = 1'b1;
					
                    break;
				end
		end
		if(!grant_flag)begin
			for(int i=0;i<`MSHR_Depth;i++)begin
				if(req_unmasked[i]==1)begin
						unmask_higher_pri_reqs[i] = 1'b0;
						grant[i] = 1'b1;
						break;
					end
				end
		end

		// I_req_masked = I_req & I_pointer_reg;
		// I_req_unmasked = I_req & ~I_pointer_reg;
		// I_grant_flag = 0;

		// I_mask_higher_pri_reqs = I_req_masked;
		// I_unmask_higher_pri_reqs = I_req_unmasked;
		// I_grant = 0;

		if(!dcache_grant_flag)begin
			for(int i=0;i<`I_MSHR_Depth;i++) begin
				if(I_req[i])begin
					I_grant[i]=1'b1;

				end
			// 	if(I_req_masked[i]==1)begin
			// 			I_mask_higher_pri_reqs[i] = 1'b0;
			// 			I_grant[i] = 1'b1;
			// 			I_grant_flag = 1'b1;
						
			// 			break;
			// 		end
			// end
			// if(!I_grant_flag)begin
			// 	for(int i=0;i<`I_MSHR_Depth;i++)begin
			// 		if(I_req_unmasked[i]==1)begin
			// 			I_unmask_higher_pri_reqs[i] = 1'b0;
			// 			I_grant[i] = 1'b1;
			// 			break;
			// 		end
			// 	end
			// end
			end
		end



	end

// Pointer update
always @ (posedge clock) begin
	if (reset) begin
		pointer_reg <=  `SD{`MSHR_Depth{1'b1}};
		// I_pointer_reg <=  `SD{`I_MSHR_Depth{1'b1}};
	end 
	else begin
		if(mem2proc_response!=0)begin
			if (|mask_higher_pri_reqs)  // Which arbiter was used?
				pointer_reg <= `SD mask_higher_pri_reqs;
			else if (|unmask_higher_pri_reqs)  // Which arbiter was used?
				pointer_reg <= `SD unmask_higher_pri_reqs;
			else
				pointer_reg <= `SD{`MSHR_Depth{1'b1}};
			
			// if (|I_mask_higher_pri_reqs)  // Which arbiter was used?
			// 	I_pointer_reg <= `SD I_mask_higher_pri_reqs;
			// else if (|I_unmask_higher_pri_reqs)  // Which arbiter was used?
			// 	I_pointer_reg <= `SD I_unmask_higher_pri_reqs;
			// else
			// 	I_pointer_reg <= `SD{`I_MSHR_Depth{1'b1}};
		end
		else begin
			pointer_reg <= `SD pointer_reg;
			// I_pointer_reg <= `SD I_pointer_reg;
		end
  	end
end

endmodule