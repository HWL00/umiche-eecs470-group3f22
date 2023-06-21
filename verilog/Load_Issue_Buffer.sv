`timescale 1ns/100ps
module Load_Issue_Buffer(
    //////////////////input//////////////////
    input clock,
    input reset,
    input   Pre_IS_EX_PACKET [`N_way-1:0] rs_load_is_packet_in,
   
    input   clean_brat_en,              ///  clean_brat_en is 1, delete everything in the pipeline which has that b_mask_bit
    input [$clog2(`width_b_mask)-1:0]   clean_brat_num,  //from brat
	input  [`ALU_num-1:0]clean_bit_brat_en,          /// did not misprediction,we just set all ba_mask[last_b_mask_branch] to be 0
	input	 [`ALU_num-1:0][$clog2(`width_b_mask)-1:0] clean_bit_num_brat_ex,  //which bit should clean when clean_bit_brat_en[i] is 1 

    input stall_IS_MSHR,            //stall issue from MSHR
    input [`LOAD_IB_Depth-1:0] ready_issue_lsq,

    input [`SQ_LEN:0]retire_head2rs_is,
    input retire_enable2rs_is,
    
    output  Pre_IS_EX_PACKET pre_load_is_ex_out,
    output  logic [`N_LEN:0]  avail_load_is_out,
    output	Pre_IS_EX_PACKET[`LOAD_IB_Depth-1:0] test_load_is,
    output logic[`LOAD_IB_Depth-1:0][`SQ_LEN:0]load_SQ_tail_to_SQ,
    output logic [`LOAD_IB_Depth-1:0]load_SQ_tail_to_SQ_valid

);
    // logic[$clog2(`ALU_IB_Detpth):0] nx_head,nx_tail,head,tail;
    Pre_IS_EX_PACKET[`LOAD_IB_Depth-1:0] nx_load_is,load_is;
    logic empty;
    logic [$clog2(`LOAD_IB_Depth)-1:0] ptr;
    // logic[$clog2(`ALU_IB_Detpth):0]   avail_alu_is_size;
    logic [`N_LEN:0]  nx_avail_load_is_out;
     logic [`LOAD_IB_Depth-1:0] nx_ready_issue,ready_issue;
    // logic [$clog2(`ALU_num):0]     alu_busy_is;
    // logic  [$clog2(`ALU_num):0] issue_cnt;
    // logic   [$clog2(`ALU_num):0] re_issue_cnt;

    // Pre_IS_EX_PACKET[`ALU_num-1:0]  pre_pre_alu_is_ex_out;
    always_comb begin
    ///////////////Comb_Logic///////////////
        nx_load_is=load_is;
        nx_avail_load_is_out='d0;
        load_SQ_tail_to_SQ = 0;
        load_SQ_tail_to_SQ_valid = 0;
        // avail_alu_is_size='d0;
        // for(int e=0;e<`N_way;e++)begin
        pre_load_is_ex_out =0;
        nx_ready_issue=ready_issue;

        // end
        // ///////////////BRAT:misprediction ////////////////
        // if(clean_brat_en)begin
        //     for(int i=0; i<`LOAD_IB_Depth; i=i+1)begin
                
        //             if(nx_load_is[i].rs_b_mask[clean_brat_num])begin
        //                 nx_load_is[i].valid=1'b0;
        //                 nx_load_is[i] = 0;
        //                 nx_ready_issue[i]=1'b0;
        //             end
        //     end
        // end

        // for(int j=0;j<`ALU_num;j=j+1)begin
        //     if(clean_bit_brat_en[j])begin
        //         for(int i=0; i<`LOAD_IB_Depth; i=i+1)begin
                    
        //             nx_load_is[i].rs_b_mask[clean_bit_num_brat_ex[j]]=1'b0;
        //         end
        //     end
        // end
       
        // nx_ready_issue=nx_ready_issue | ready_issue_lsq;
        for(int i=0;i<`LOAD_IB_Depth;i=i+1)begin
            nx_ready_issue[i] = nx_ready_issue[i] | ready_issue_lsq[i] | nx_load_is[i].load_issue_valid;
            if(nx_load_is[i].SQ_tail==retire_head2rs_is && retire_enable2rs_is)begin
				nx_load_is[i].no_sort_sq = 1;
			end
        end

        ///////////////BRAT:misprediction ////////////////
        if(clean_brat_en)begin
            for(int i=0; i<`LOAD_IB_Depth; i=i+1)begin
                
                    if(nx_load_is[i].rs_b_mask[clean_brat_num])begin
                        nx_load_is[i].valid=1'b0;
                        nx_load_is[i] = 0;
                        nx_ready_issue[i]=1'b0;
                    end
            end
        end

        for(int j=0;j<`ALU_num;j=j+1)begin
            if(clean_bit_brat_en[j])begin
                for(int i=0; i<`LOAD_IB_Depth; i=i+1)begin
                    
                    nx_load_is[i].rs_b_mask[clean_bit_num_brat_ex[j]]=1'b0;
                end
            end
        end
 
        ///////////////issue to ex////////////////////////
        for(int i = `LOAD_IB_Depth-1; i>=0; i=i-1)begin
            
            if( !stall_IS_MSHR  && nx_load_is[i].valid && nx_ready_issue[i] )begin//ready_issue[i] && issue_cnt<alu_busy_is
                // issue_cnt= issue_cnt+1;
                pre_load_is_ex_out=nx_load_is[i];
                // nx_load_is[`LOAD_IB_Depth-1].valid=1'b0;
                nx_load_is[i] = 0;
                nx_ready_issue[i]=1'b0;
                break;
            end
            else if( stall_IS_MSHR  && nx_load_is[i].valid && nx_ready_issue[i] )begin//ready_issue[i] && issue_cnt<alu_busy_is
                // issue_cnt= issue_cnt+1;
                pre_load_is_ex_out=0;
                pre_load_is_ex_out.rd_mem = 0;
                pre_load_is_ex_out.valid = 0;
                // nx_load_is[`LOAD_IB_Depth-1].valid=1'b0;
            end
        end

        // if( !stall_IS_MSHR  && nx_load_is[`LOAD_IB_Depth-1].valid && nx_ready_issue[`LOAD_IB_Depth-1] )begin//ready_issue[i] && issue_cnt<alu_busy_is
        //         // issue_cnt= issue_cnt+1;
        //         pre_load_is_ex_out=nx_load_is[`LOAD_IB_Depth-1];
        //         // nx_load_is[`LOAD_IB_Depth-1].valid=1'b0;
        //         nx_load_is[`LOAD_IB_Depth-1] = 0;
        //         nx_ready_issue[`LOAD_IB_Depth-1]=1'b0;
        //     end
        //     else if( stall_IS_MSHR  && nx_load_is[`LOAD_IB_Depth-1].valid && nx_ready_issue[`LOAD_IB_Depth-1] )begin//ready_issue[i] && issue_cnt<alu_busy_is
        //         // issue_cnt= issue_cnt+1;
        //         pre_load_is_ex_out=0;
        //         pre_load_is_ex_out.rd_mem = 0;
        //         pre_load_is_ex_out.valid = 0;
        //         // nx_load_is[`LOAD_IB_Depth-1].valid=1'b0;
        //     end

         
        ///////////////compress load issue buffer////////////////
		for (int i=0; i<`LOAD_IB_Depth-1; i=i+1) begin
			if(!nx_load_is[i+1].valid && nx_load_is[i].valid)begin
				for (int j=i ;j>=0; j=j-1)begin
					nx_load_is[j+1] = nx_load_is[j];
					nx_load_is[j] = 0;
                    nx_ready_issue[j+1] =nx_ready_issue[j];
                    nx_ready_issue[j]='d0;
					end
				end
		end



    //////////////writing to is//////////////////
        ptr ='d0;
        empty = 1'b1;
        if(nx_load_is[`LOAD_IB_Depth-1].valid)begin
            empty=0;
        end
        for(int i=0;i<`LOAD_IB_Depth;i++)begin
			if(empty)begin
				ptr=`LOAD_IB_Depth-1;
			end
			else if(nx_load_is[i].valid)begin
				ptr=ptr-1'b1;
				break;
			end
			else if(!nx_load_is[i].valid)begin
				
				ptr=ptr+1'b1;
			end
			
		end





        for(int i=0;i<`N_way;i=i+1)begin
            if(rs_load_is_packet_in[i].valid )begin
                nx_load_is[ptr]=rs_load_is_packet_in[i];

                ptr=ptr-1'b1;
            end
        end

        nx_avail_load_is_out = 'd0;
        for(int i=0; i< `LOAD_IB_Depth; i=i+1)begin
            if(!nx_load_is[i].valid && nx_avail_load_is_out<`N_way)begin
                nx_avail_load_is_out = nx_avail_load_is_out + 1'b1;
            end
        end
        for(int i=`LOAD_IB_Depth-1;i>=0;i--)begin

            load_SQ_tail_to_SQ[i] = nx_load_is[i].SQ_tail;
            load_SQ_tail_to_SQ_valid[i] = nx_load_is[i].valid;

        end

    end//end comb_logic





    //////////////////sequential logic///////////
    always_ff@(posedge clock)begin
        if(reset)begin
            // reset_flag <= `SD 0;

            test_load_is <= `SD 0;
            avail_load_is_out <=`SD `N_way;
            ready_issue <= `SD 0;
        for(int g=0; g<`LOAD_IB_Depth; g=g+1 )begin
                load_is[g] <= `SD {
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
                            0,
                            0,
                            0
                };
            end
        end
        // else if(stall_IS_MSHR)begin
        //     load_is<= `SD load_is;
        //     test_load_is <= `SD test_load_is;
        //     avail_load_is_out <=`SD avail_load_is_out ;
        // end
        else begin
                load_is<= `SD nx_load_is;
                test_load_is <= `SD nx_load_is;
                avail_load_is_out <=`SD nx_avail_load_is_out ;
                ready_issue <= `SD nx_ready_issue;
        end
    end//end sequential logic


endmodule