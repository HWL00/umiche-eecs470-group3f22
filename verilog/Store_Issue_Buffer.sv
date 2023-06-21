`timescale 1ns/100ps
module Store_Issue_Buffer(
    //////////////////input//////////////////
    input clock,
    input reset,
    input   Pre_IS_EX_PACKET [`N_way-1:0] rs_store_is_packet_in,
    input stop_is_st_en,
   
    input   clean_brat_en,              ///  clean_brat_en is 1, delete everything in the pipeline which has that b_mask_bit
    input [$clog2(`width_b_mask)-1:0]   clean_brat_num,  //from brat
	input  [`ALU_num-1:0]clean_bit_brat_en,          /// did not misprediction,we just set all ba_mask[last_b_mask_branch] to be 0
	input	 [`ALU_num-1:0][$clog2(`width_b_mask)-1:0] clean_bit_num_brat_ex,  //which bit should clean when clean_bit_brat_en[i] is 1 

    output  Pre_IS_EX_PACKET pre_store_is_ex_out,
    output  logic [`N_LEN:0]  avail_store_is_out,
    output	Pre_IS_EX_PACKET[`STORE_IB_Depth-1:0] test_store_is

);
    // logic[$clog2(`ALU_IB_Detpth):0] nx_head,nx_tail,head,tail;
    Pre_IS_EX_PACKET[`STORE_IB_Depth-1:0] nx_store_is,store_is;
    logic empty;
    logic [$clog2(`STORE_IB_Depth)-1:0] ptr;
    // logic[$clog2(`ALU_IB_Detpth):0]   avail_alu_is_size;
    logic [`N_LEN:0]  nx_avail_store_is_out;
    logic [`STORE_IB_Depth-1:0] ready_issue;
    // logic [$clog2(`ALU_num):0]     alu_busy_is;
    // logic  [$clog2(`ALU_num):0] issue_cnt;
    // logic   [$clog2(`ALU_num):0] re_issue_cnt;

    // Pre_IS_EX_PACKET[`ALU_num-1:0]  pre_pre_alu_is_ex_out;
    always_comb begin
    ///////////////Comb_Logic///////////////
        nx_store_is=store_is;
        nx_avail_store_is_out='d0;
        // avail_alu_is_size='d0;
        pre_store_is_ex_out = 0;

        // end
        ///////////////BRAT:misprediction ////////////////
        if(clean_brat_en)begin
            for(int i=0; i<`STORE_IB_Depth; i=i+1)begin
                
                    if(nx_store_is[i].rs_b_mask[clean_brat_num])begin
                        nx_store_is[i]=0;
                    end
            end
        end

        for(int j=0;j<`ALU_num;j=j+1)begin
            if(clean_bit_brat_en[j])begin
                for(int i=0; i<`STORE_IB_Depth; i=i+1)begin
                    
                    nx_store_is[i].rs_b_mask[clean_bit_num_brat_ex[j]]=1'b0;
                end
            end
        end
       

 
        ///////////////issue to ex////////////////////////
        // for(int i = `STORE_IB_Depth-1; i>=0; i=i-1)begin

            if( !stop_is_st_en &&nx_store_is[`STORE_IB_Depth-1].valid)begin//ready_issue[i] && issue_cnt<alu_busy_is
                // issue_cnt= issue_cnt+1;
                pre_store_is_ex_out=nx_store_is[`STORE_IB_Depth-1];
                nx_store_is[`STORE_IB_Depth-1].valid=1'b0;
                nx_store_is[`STORE_IB_Depth-1] = 0;
            end
       


            
        // end

        // nx_avail_store_is_out = 'd0;
        // for(int i=0; i< `STORE_IB_Depth; i=i+1)begin
        //     if(!nx_store_is[i].valid && nx_avail_store_is_out<`N_way)begin
        //         nx_avail_store_is_out = nx_avail_store_is_out + 1'b1;
        //     end
        // end

         
        ///////////////compress store issue buffer////////////////
		for (int i=0; i<`STORE_IB_Depth-1; i=i+1) begin
			if(!nx_store_is[i+1].valid && nx_store_is[i].valid)begin
				for (int j=i ;j>=0; j=j-1)begin
					nx_store_is[j+1] = nx_store_is[j];
					nx_store_is[j] = 0;
					end
				end
		end



    //////////////writing to is//////////////////
        ptr ='d0;
        empty = 1'b1;
        if(nx_store_is[`STORE_IB_Depth-1].valid)begin
            empty=0;
        end
        for(int i=0;i<`STORE_IB_Depth;i++)begin
			if(empty)begin
				ptr=`STORE_IB_Depth-1;
			end
			else if(nx_store_is[i].valid)begin
				ptr=ptr-1'b1;
				break;
			end
			else if(!nx_store_is[i].valid)begin
				
				ptr=ptr+1'b1;
			end
			
		end





        for(int i=0;i<`N_way;i=i+1)begin
            if(rs_store_is_packet_in[i].valid )begin
                nx_store_is[ptr]=rs_store_is_packet_in[i];
                ptr=ptr-1'b1;
            end
        end

 

    end//end comb_logic





    //////////////////sequential logic///////////
    always_ff@(posedge clock)begin
        if(reset)begin
            // reset_flag <= `SD 0;

            test_store_is <= `SD 0;
            avail_store_is_out <=`SD `N_way;
        for(int g=0; g<`STORE_IB_Depth; g=g+1 )begin
                store_is[g] <= `SD {
                            `XLEN'd0, //n_rs[j+compress_cnt].NPC = n_rs[j].NPC;
                            `XLEN'd0,//n_rs[j+compress_cnt].PC = n_rs[j].PC;
                            `XLEN'd0,
                            `XLEN'd0,
                            OPA_IS_RS1,//n_rs[j+compress_cnt].opa_select = n_rs[j].opa_select;
                            OPB_IS_RS2,//n_rs[j+compress_cnt].opb_select = n_rs[j].opb_select;
                            `NOP,//n_rs[j+compress_cnt].inst = n_rs[j].inst;
                            `Preg_LEN'd0,
                            ALU_ADD,//n_rs[j+compress_cnt].alu_func = n_rs[j].alu_func;
                            `FALSE,//n_rs[j+compress_cnt].rd_mem = n_rs[j].rd_mem;
                            `FALSE,//n_rs[j+compress_cnt].wr_mem = n_rs[j].wr_mem;
                            `FALSE,//n_rs[j+compress_cnt].cond_branch = n_rs[j].cond_branch;
                            `FALSE,//n_rs[j+compress_cnt].uncond_branch = n_rs[j].uncond_branch;
                            `FALSE,//n_rs[j+compress_cnt].halt = n_rs[j].halt;
                            `FALSE,//n_rs[j+compress_cnt].illegal = n_rs[j].illegal;
                            `FALSE,//n_rs[j+compress_cnt].csr_op = n_rs[j].csr_op;
                            `FALSE,//n_rs[j+compress_cnt].valid = n_rs[j].valid
                            1'd0,
                            `b_mask_reg_width'd0,
                            `width_b_mask_len'd0,
                            1'd0,
                            1'd0,
                            `XLEN'd0,
                            0,
                            0
                };
            end
        end
        else begin
                store_is<= `SD nx_store_is;
                test_store_is <= `SD nx_store_is;
                avail_store_is_out <=`SD nx_avail_store_is_out ;
        end
    end//end sequential logic


endmodule