
`timescale 1ns/100ps
module BRAT(
////////////input////////////////
        input clock,
        input reset,
        //////////////from other///////////////////////////
        input[`ALU_num-1:0]  misprediction,
        input[`ALU_num-1:0]  if_branch_ex, ///from complete stage or ex
        input [`ALU_num-1:0][$clog2(`width_b_mask)-1:0]  b_mask_bit_branch_ex,// input[$clog2(`width_b_mask)-1:0]    last_b_mask_branch,  
        input [`N_way-1:0][`SQ_LEN:0]SQ_tail_BRAT,
        input [`SQ_LEN:0]retire_head2rs_is,
        input retire_enable2rs_is,
     /////////////from ex stage/////////////////////
        input  [`ALU_num-1:0]clean_bit_brat_en, //from ex stage
    //////////////////from dispatch stage//////////////////
        input   DP_BRAT_PACKET[`N_way-1:0] dp_brat_in,
	    input[`N_way-1:0] [`ROB_LEN:0]	rob_tail_brat_in,
        input  FL2BRAT_PACKET[`N_way-1:0]freelist_table_to_BRAT_in,
        // input brat_full_stall,
            ///	logic[]					lsq_tail
        input [`SQ_LEN:0]  num_avail_lsq, 
	    input   RAT_PACKET[`N_way-1:0]	rat_brat_in,
        input Dispatch_TO_ConnectedROB_PACKET [`N_way-1 :0]dp_rob_packet,
///////////from rob connected//////
        input [`N_way-1:0][`Preg_LEN-1:0]Rd_old_Preg_BRAT,
        input CDB_OUT_PACKET [`N_way-1:0] cdb_out_packet,
////////////////output///////////////
////////////////for recovery//////////////////////
        output  logic clean_brat_en,              ///  clean_brat_en is 1, delete everything in the pipeline which has that b_mask_bit

        output  logic[$clog2(`width_b_mask)-1:0]   clean_brat_num,
        output BRAT2FL_PACKET   brat2fl_rollback,
        output BRAT2RAT_PACKET    brat2rat_rollback,
        output  BRAT2ROB_PACKET     brat2rob_rollback,
        output logic brat_full_stall,
        output logic [`XLEN-1:0] brat_full_back_pc,
        output logic[`SQ_LEN:0]SQ_BP_mispredicted_tail,
        output logic reset_sq,
////////////////for dispatch////////////////////////
        // output logic[$clog2(`width_b_mask):0] avail_num_b_mask,
///////////////for rs//////////////////////////////
        output BRAT_RS_PACKET[`N_way-1:0] brat2rs_out,
/////////////// for rob////////////////////////////
        output  Dispatch_TO_ConnectedROB_PACKET [`N_way-1 :0]brat_rob_packet_out,
        output  BRAT2ROB_PACKET[`ALU_num-1:0]    brat2rob_clean_bit,  
///////////////////////for test////////////////////////////////
        output BRAT_PACKET[`width_b_mask-1:0]  test_bart,
        output brat_rec recver,
        output logic [`N_way-1:0] [`width_b_mask-1:0] test_b_mask_reg_out
        

);
   // logic flag;
    logic[`width_b_mask-1:0]   nx_b_mask_reg,b_mask_reg;
    BRAT_PACKET[`width_b_mask-1:0]  nx_brat,brat;
    logic [`N_way-1:0] [`width_b_mask-1:0] b_out;
    logic [`N_way-1:0][$clog2(`width_b_mask)-1:0]    b_mask_bit_branch_dp; //for rs but it is old name
    //logic[$clog2(`width_b_mask)-1:0] cnt;
    logic [$clog2(`N_way) :0]  tmp_num_avail_lsq; 
    ////////////////////COMB_logic/////////////////////
    always_comb begin
        b_mask_bit_branch_dp='d0;
        nx_b_mask_reg=b_mask_reg;
        nx_brat=brat;
        clean_brat_en=1'b0;
        brat2fl_rollback='d0;
        brat2rat_rollback='d0;
        brat2rob_rollback='d0;
        clean_brat_num='d0;
        brat2rob_clean_bit='d0;
        brat2rs_out=0; 
        brat_rob_packet_out = 0;
        brat_full_stall=1'b0;
        brat_full_back_pc='d0;
        tmp_num_avail_lsq=(num_avail_lsq>`N_way)?`N_way:num_avail_lsq;
        reset_sq = 0;
        SQ_BP_mispredicted_tail = 0;
        for(int i=0;i<`N_way;i++)begin
            b_out[i]=nx_b_mask_reg;
        end
        for(int i=0; i<`width_b_mask;i++)begin
            for(int j=0; j<`N_way;j++)begin
                if(Rd_old_Preg_BRAT[j]!=0 &&  b_mask_reg[i]==1)begin
                    // $display("i %d ",i);
                    nx_brat[i].freelist_tail_to_BRAT=nx_brat[i].freelist_tail_to_BRAT+1;
                    nx_brat[i].freelist_table_to_BRAT[ nx_brat[i].freelist_tail_to_BRAT[`Freelist_LEN-1:0]]=Rd_old_Preg_BRAT[j];
                    // $display("nx_brat[i].freelist_table_to_BRAT[ nx_brat[i].freelist_tail_to_BRAT] %d ",nx_brat[i].freelist_table_to_BRAT[ nx_brat[i].freelist_tail_to_BRAT]);
                
                end
            end
            for(int j=0; j<`N_way;j++)begin
                for(int k=0;k<`Areg_num;k++)begin
                    if(cdb_out_packet[j].Rd_Preg_CDB!=0 && cdb_out_packet[j].Rd_Preg_CDB==nx_brat[i].Preg[k] && b_mask_reg[i]==1)begin/// nx_brat[i].b_mask_org[cdb_out_packet[j].b_mask_bit_branch]!=1
                        // $display("i %d ",i);
                        nx_brat[i].ready_bit[k] = 1;
                        // $display("nx_brat[i].freelist_table_to_BRAT[ nx_brat[i].freelist_tail_to_BRAT] %d ",nx_brat[i].freelist_table_to_BRAT[ nx_brat[i].freelist_tail_to_BRAT]);
                    end
                end
            end
        end
        if(retire_enable2rs_is)begin
            for(int i=0; i<`width_b_mask;i++)begin
                if(b_mask_reg[i]==1)begin
                    if(nx_brat[i].SQ_tail_BRAT==retire_head2rs_is)begin
                        nx_brat[i].reset_sq = 1;
                    end
                end
            end
        end
        ///////////////misprediction happened and not misprediction///////////////////
        for(int i=0;i<`ALU_num;i++)begin                   
            if(misprediction[i]&&if_branch_ex[i]&& nx_b_mask_reg[b_mask_bit_branch_ex[i]])begin         //if
                clean_brat_en=1'b1;
                brat2fl_rollback.freelist_table_to_BRAT = nx_brat[b_mask_bit_branch_ex[i]].freelist_table_to_BRAT;
                brat2fl_rollback.freelist_head_to_BRAT = nx_brat[b_mask_bit_branch_ex[i]].freelist_head_to_BRAT;
                brat2fl_rollback.freelist_tail_to_BRAT = nx_brat[b_mask_bit_branch_ex[i]].freelist_tail_to_BRAT;
                brat2rat_rollback.Preg = nx_brat[b_mask_bit_branch_ex[i]].Preg;
                brat2rat_rollback.ready_bit = nx_brat[b_mask_bit_branch_ex[i]].ready_bit;
                brat2rob_rollback.rob_tail_brat = nx_brat[b_mask_bit_branch_ex[i]].rob_tail_brat;
                SQ_BP_mispredicted_tail = nx_brat[b_mask_bit_branch_ex[i]].SQ_tail_BRAT;
                reset_sq = nx_brat[b_mask_bit_branch_ex[i]].reset_sq;
                nx_b_mask_reg=nx_b_mask_reg & nx_brat[b_mask_bit_branch_ex[i]].b_mask_org;  //if 1110 , 2rd bit misprediction(org1100), now 1011,now 1000
                // nx_b_mask_reg[b_mask_bit_branch_ex[i]]='d0;
                clean_brat_num= b_mask_bit_branch_ex[i];

            end
            if(clean_bit_brat_en[i])begin
                brat2rob_clean_bit[i]=nx_brat[b_mask_bit_branch_ex[i]].rob_tail_brat;
                nx_b_mask_reg[b_mask_bit_branch_ex[i]]='d0;
                
            end
                // nx_brat[b_mask_bit_branch_ex[i]].b_mask_org='d0;
        end
        for(int i=0;i<`width_b_mask;i++)begin
            if(nx_b_mask_reg[i]==0)begin
                nx_brat[i] = 0;
            end
        end

        for(int i=0;i<`ALU_num;i++)begin
            if(clean_bit_brat_en[i])begin
                for(int j=0;j<`width_b_mask;j++)begin
                    nx_brat[j].b_mask_org[b_mask_bit_branch_ex[i]]='d0;
                end

            end
        end

       
        ///////////////writting to brat//////////////////
        // brat_full= &nx_b_mask_reg;
        // b_mask_bit_branch_dp[$clog2(`width_b_mask)]=1'b1;
        //  avail_num_b_mask='d0;
        // flag = 0;
        for(int i=0; i<`N_way;i=i+1)begin
            //  if(brat_full_stall || clean_brat_en)begin
            //         brat2rs_out=0; 
            //         brat_rob_packet_out = 0;
            // end
            // else begin
                
                if( dp_brat_in[i].is_branch && dp_brat_in[i].valid && !(&nx_b_mask_reg) && !clean_brat_en)begin
                    // cnt=`width_b_mask-1;       
                        for(int j=`width_b_mask-1;j>=0;j=j-1)begin
                            if(nx_b_mask_reg[j]==1'b0)begin
                                nx_brat[j].b_mask_org=nx_b_mask_reg;
                                b_mask_bit_branch_dp[i]=j;
                                nx_b_mask_reg[j]=1'b1;
                                // nx_brat[j].recovery_pc=recovery_pc_in[i];
                                nx_brat[j].SQ_tail_BRAT=SQ_tail_BRAT[i];
                                nx_brat[j].rob_tail_brat=rob_tail_brat_in[i];
                                nx_brat[j].freelist_table_to_BRAT=freelist_table_to_BRAT_in[i].freelist_table_to_BRAT;
                                nx_brat[j].freelist_head_to_BRAT=freelist_table_to_BRAT_in[i].freelist_head_to_BRAT;
                                nx_brat[j].freelist_tail_to_BRAT=freelist_table_to_BRAT_in[i].freelist_tail_to_BRAT;
                                nx_brat[j].Preg=rat_brat_in[i].Preg;
                                nx_brat[j].ready_bit = rat_brat_in[i].ready_bit;
                                // flag = 1;
                            // //output to rs                            
                                break;
                            end
                        // cnt = cnt -1; 
                        end//end j loop                         
                    // continue;                                                             
                end
                else if( &nx_b_mask_reg && dp_brat_in[i].is_branch && !clean_brat_en )begin
                    brat_full_stall=1'b1;
                    // flag_back_pc=1'b1;
                    brat_full_back_pc=dp_brat_in[i].PC;
                    brat2rs_out[i].valid = 1'b0;
                    brat_rob_packet_out[i].valid =1'b0;
                    brat_rob_packet_out[i].Dispatch_enable = 1'b0;
                    // flag = 0;
                    break;
                end

                if( dp_brat_in[i].wr_mem && dp_brat_in[i].valid && !clean_brat_en && tmp_num_avail_lsq!=0)begin
                    // cnt=`width_b_mask-1;       
                    tmp_num_avail_lsq=tmp_num_avail_lsq-1'b1;//j loop           
                                      
                    // continue;                                                             
                end
                else if( tmp_num_avail_lsq==0&& dp_brat_in[i].wr_mem && !clean_brat_en )begin
                    brat_full_stall=1'b1;
                    // flag_back_pc=1'b1;
                    brat_full_back_pc=dp_brat_in[i].PC;
                    brat2rs_out[i].valid = 1'b0;
                    brat_rob_packet_out[i].valid =1'b0;
                    brat_rob_packet_out[i].Dispatch_enable = 1'b0;
                    // flag = 0;
                    break;
                end
               



                
                if(clean_brat_en)begin
                    brat2rs_out[i].valid=1'b0;
                    brat_rob_packet_out[i].valid =1'b0;
                    brat_rob_packet_out[i].Dispatch_enable = 1'b0;
                end
                else begin
                    brat2rs_out[i].NPC = dp_brat_in[i].NPC;
                    brat2rs_out[i].PC=dp_brat_in[i].PC;    // PC                       
                    brat2rs_out[i].opa_select=dp_brat_in[i].opa_select; // ALU opa mux select (ALU_OPA_xxx *)
                    brat2rs_out[i].opb_select=dp_brat_in[i].opb_select; // ALU opb mux select (ALU_OPB_xxx *)
                    brat2rs_out[i].inst=dp_brat_in[i].inst;                 // instruction    
                    brat2rs_out[i].alu_func=dp_brat_in[i].alu_func;      // ALU function select (ALU_xxx *)
                    brat2rs_out[i].rd_mem=dp_brat_in[i].rd_mem;        // does inst read memory?
                    brat2rs_out[i].wr_mem=dp_brat_in[i].wr_mem;        // does inst write memory?
                    brat2rs_out[i].cond_branch=dp_brat_in[i].cond_branch;   // is inst a conditional branch?
                    brat2rs_out[i].uncond_branch=dp_brat_in[i].uncond_branch; // is inst an unconditional branch?
                    brat2rs_out[i].halt=dp_brat_in[i].halt;          // is this a halt?
                    brat2rs_out[i].illegal=dp_brat_in[i].illegal;       // is this instruction illegal?
                    brat2rs_out[i].csr_op=dp_brat_in[i].csr_op;        // is this a CSR operation? (we only used this as a cheap way to get return code)
                    brat2rs_out[i].valid=dp_brat_in[i].valid;         // is inst a valid instruction to be counted for CPI calculations?
                    brat2rs_out[i].if_mul=dp_brat_in[i].if_mul;
                    brat2rs_out[i].b_mask_in=nx_b_mask_reg;   
                    brat2rs_out[i].is_branch=dp_brat_in[i].is_branch;     //if it is mul inst
                    brat2rs_out[i].b_mask_bit_branch=b_mask_bit_branch_dp[i];
                    brat2rs_out[i].BP_predicted_taken=dp_brat_in[i].BP_predicted_taken;
                    brat2rs_out[i].BP_predicted_target_PC=dp_brat_in[i].BP_predicted_target_PC;   
                    brat2rs_out[i].load_issue_valid=dp_brat_in[i].load_issue_valid;            
                    // b_mask_reg_out[i]=nx_b_mask_reg;
                    b_out[i]=nx_b_mask_reg;

                    brat_rob_packet_out[i] = dp_rob_packet[i];
                end
                
                //  if(dp_brat_in[i].wr_mem && dp_brat_in[i].valid)begin
                //     tmp_num_avail_lsq=tmp_num_avail_lsq-1'b1;
                // end

                

                //////////////before writing to brat from dp/////////
                // avail_num_b_mask='d0;
                // for(int i=0;i<`width_b_mask;i++)begin
                //     if(!nx_b_mask_reg[i])begin
                //         avail_num_b_mask=avail_num_b_mask+1'b1;
                //     end
                // end
                
                // if(&nx_b_mask_reg && dp_brat_in[i].is_branch) begin
                //     brat2rs_out[i] = 0;
                //     brat_rob_packet_out[i] = 0;
                //     break;
                // end
               

        end
    end// comb logic end 
        // //output to rs
        // for(int i=0; i<`N_way;i=i+1)begin
        //     brat2rs_out[i].NPC = dp_brat_in[i].NPC;
        //     brat2rs_out[i].PC=dp_brat_in[i].PC;    // PC                       
        //     brat2rs_out[i].opa_select=dp_brat_in[i].opa_select; // ALU opa mux select (ALU_OPA_xxx *)
        //     brat2rs_out[i].opb_select=dp_brat_in[i].opb_select; // ALU opb mux select (ALU_OPB_xxx *)
        //     brat2rs_out[i].inst=dp_brat_in[i].inst;                 // instruction    
        //     brat2rs_out[i].alu_func=dp_brat_in[i].alu_func;      // ALU function select (ALU_xxx *)
        //     brat2rs_out[i].rd_mem=dp_brat_in[i].rd_mem;        // does inst read memory?
        //     brat2rs_out[i].wr_mem=dp_brat_in[i].wr_mem;        // does inst write memory?
        //     brat2rs_out[i].cond_branch=dp_brat_in[i].cond_branch;   // is inst a conditional branch?
        //     brat2rs_out[i].uncond_branch=dp_brat_in[i].uncond_branch; // is inst an unconditional branch?
        //     brat2rs_out[i].halt=dp_brat_in[i].halt;          // is this a halt?
        //     brat2rs_out[i].illegal=dp_brat_in[i].illegal;       // is this instruction illegal?
        //     brat2rs_out[i].csr_op=dp_brat_in[i].csr_op;        // is this a CSR operation? (we only used this as a cheap way to get return code)
        //     brat2rs_out[i].valid=dp_brat_in[i].valid;         // is inst a valid instruction to be counted for CPI calculations?
        //     brat2rs_out[i].if_mul=dp_brat_in[i].if_mul;
        //     brat2rs_out[i].b_mask_in=nx_b_mask_reg;   
        //     brat2rs_out[i].is_branch=dp_brat_in[i].is_branch;     //if it is mul inst
        //     brat2rs_out[i].b_mask_bit_branch=b_mask_bit_branch_dp[i];
        //     brat2rs_out[i].BP_predicted_taken=dp_brat_in[i].BP_predicted_taken;
        //     brat2rs_out[i].BP_predicted_target_PC=dp_brat_in[i].BP_predicted_target_PC;
        // end

        ////for updating freelist



    ///////////////////Sequential logic///////////////
    always_ff@(posedge clock)begin
        if(reset)begin
            b_mask_reg<=`SD 0;
            brat<=`SD    0;
            test_bart<=`SD    0;
            recver<=`SD    0;
            test_b_mask_reg_out <=`SD 0;
        end
        else begin
            b_mask_reg<=`SD nx_b_mask_reg;
            brat<=`SD nx_brat;
            test_bart <=`SD nx_brat;
        
            // recver.rollback_brat_en <=`SD rollback_brat_en;
            recver.clean_brat_en <=`SD clean_brat_en;
            recver.clean_bit_brat_en<=`SD clean_bit_brat_en;
            test_b_mask_reg_out <=`SD b_out ;
        end
    end


endmodule
