`timescale 1ns/100ps
module ALU_Issue_Buffer(
    //////////////////input//////////////////
    input clock,
    input reset,
    input   Pre_IS_EX_PACKET [`N_way-1:0] rs_alu_is_packet_in,
    input [`ALU_num-1:0]     alu_busy,									/// if alu busy
    input   clean_brat_en,              ///  clean_brat_en is 1, delete everything in the pipeline which has that b_mask_bit
    input [$clog2(`width_b_mask)-1:0]   clean_brat_num,  //from brat
	input  [`ALU_num-1:0]clean_bit_brat_en,          /// did not misprediction,we just set all ba_mask[last_b_mask_branch] to be 0
	input	 [`ALU_num-1:0][$clog2(`width_b_mask)-1:0] clean_bit_num_brat_ex,  //which bit should clean when clean_bit_brat_en[i] is 1 

    output  Pre_IS_EX_PACKET[`ALU_num-1:0]  pre_alu_is_ex_out,
    output  logic [`N_LEN:0]  avail_alu_is_out,
    output	Pre_IS_EX_PACKET[`ALU_IB_Detpth-1:0] test_alu_is

);
    // logic[$clog2(`ALU_IB_Detpth):0] nx_head,nx_tail,head,tail;
    Pre_IS_EX_PACKET[`ALU_IB_Detpth-1:0] nx_alu_is,alu_is;
    logic empty;
    logic [$clog2(`ALU_IB_Detpth)-1:0] ptr;
    // logic[$clog2(`ALU_IB_Detpth):0]   avail_alu_is_size;
    logic [`N_LEN:0]  nx_avail_alu_is_out;
    // logic [`ALU_IB_Detpth-1:0] ready_issue;
    logic [$clog2(`ALU_num):0]     alu_busy_is;
    logic  [$clog2(`ALU_num):0] issue_cnt;
    logic   [$clog2(`ALU_num):0] re_issue_cnt;

    Pre_IS_EX_PACKET[`ALU_num-1:0]  pre_pre_alu_is_ex_out;
    always_comb begin
    ///////////////Comb_Logic///////////////
        nx_alu_is=alu_is;
        nx_avail_alu_is_out='d0;
        pre_pre_alu_is_ex_out = 0;
        pre_alu_is_ex_out = 0;
        // avail_alu_is_size='d0;
        
        ///////////////BRAT:misprediction ////////////////
        if(clean_brat_en)begin
            for(int i=0; i<`ALU_IB_Detpth; i=i+1)begin
                
                    if(nx_alu_is[i].rs_b_mask[clean_brat_num])begin
                        nx_alu_is[i].valid=1'b0;
                        nx_alu_is[i] = 0;
                    end
            end
        end

        for(int j=0;j<`ALU_num;j=j+1)begin
            if(clean_bit_brat_en[j])begin
                for(int i=0; i<`ALU_IB_Detpth; i=i+1)begin
                    
                    nx_alu_is[i].rs_b_mask[clean_bit_num_brat_ex[j]]=1'b0;
                end
            end
        end
       

        alu_busy_is=0;
        for(int i = 0; i<`ALU_num; i=i+1)begin
            if(!alu_busy[i])begin
               alu_busy_is = alu_busy_is + 1'b1;
            end
        end

       
        // ready_issue = 'd0;
        // for(int i = `ALU_IB_Detpth-1; i>=0; i=i-1)begin
        //     if(alu_busy_is !=0  && nx_alu_is[i].valid)begin
        //         ready_issue[i]=1'b1;
        //         alu_busy_is = alu_busy_is - 1'b1;
        //     end
        // end
         issue_cnt = 0;
        ///////////////issue to ex////////////////////////
        for(int i = `ALU_IB_Detpth-1; i>=0; i=i-1)begin

            if( issue_cnt<alu_busy_is && nx_alu_is[i].valid)begin//ready_issue[i] &&
                issue_cnt= issue_cnt+1;
                pre_pre_alu_is_ex_out[issue_cnt-1'b1]=nx_alu_is[i];
                nx_alu_is[i].valid=1'b0;
                nx_alu_is[i] = 0;
            end
        end

        ///////////////re arrange out///////////////////////
        re_issue_cnt='d0;
        for(int i = 0; i<`ALU_num; i=i+1)begin

            if( !alu_busy[i] && re_issue_cnt< issue_cnt)begin//ready_issue[i] &&
                
                pre_alu_is_ex_out[i]=pre_pre_alu_is_ex_out[re_issue_cnt];
                re_issue_cnt=re_issue_cnt+1'b1;
            end
        end



        

         
        ///////////////compress alu issue buffer////////////////
		for (int i=0; i<`ALU_IB_Detpth-1; i=i+1) begin
			if(!nx_alu_is[i+1].valid && nx_alu_is[i].valid)begin
				for (int j=i ;j>=0; j=j-1)begin
					nx_alu_is[j+1] = nx_alu_is[j];
					nx_alu_is[j] = 0;
					end
				end
		end



    //////////////writing to is//////////////////
        ptr ='d0;
        empty = 1'b1;
        if(nx_alu_is[`ALU_IB_Detpth-1].valid)begin
            empty=0;
        end
        for(int i=0;i<`ALU_IB_Detpth;i++)begin
			if(empty)begin
				ptr=`ALU_IB_Detpth-1;
			end
			else if(nx_alu_is[i].valid)begin
				ptr=ptr-1'b1;
				break;
			end
			else if(!nx_alu_is[i].valid)begin
				
				ptr=ptr+1'b1;
			end
			
		end





        for(int i=0;i<`N_way;i=i+1)begin
            if(rs_alu_is_packet_in[i].valid && !rs_alu_is_packet_in[i].if_mul)begin
                nx_alu_is[ptr]=rs_alu_is_packet_in[i];
                ptr=ptr-1'b1;
            end
        end

        nx_avail_alu_is_out = 'd0;
        for(int i=0; i< `ALU_IB_Detpth; i=i+1)begin
            if(!nx_alu_is[i].valid && nx_avail_alu_is_out<`N_way)begin
                nx_avail_alu_is_out = nx_avail_alu_is_out + 1'b1;
            end
        end

    end//end comb_logic





    //////////////////sequential logic///////////
    always_ff@(posedge clock)begin
        if(reset)begin
            // reset_flag <= `SD 0;

            test_alu_is <= `SD 0;
            avail_alu_is_out <=`SD `N_way;
        for(int g=0; g<`ALU_IB_Detpth; g=g+1 )begin
                alu_is[g] <= `SD {
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
                alu_is<= `SD nx_alu_is;
                test_alu_is <= `SD nx_alu_is;
                avail_alu_is_out <=`SD nx_avail_alu_is_out ;
        end
    end//end sequential logic


endmodule