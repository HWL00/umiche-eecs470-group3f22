`timescale 1ns/100ps
module BP(
////////input///////////////////////////////
input clock,
input reset,
///////maybe from pc////////
input [`XLEN-1:0] fetch_pc,   //this is first inst pc
// input [`N_way-1:0][`XLEN-1:0] pre_pc,        //maybe from prefetcher
input [`N_way-1:0] pre_pc_valid,              //maybe miss
////////from complete stage////////           
input C_BTB_table[`ALU_num-1:0]  c_btb_packet ,                  /////input from complete stage to btb  

///////////output//////////////
output logic [`N_way-1:0][`XLEN-1:0] target_pc,
output logic [`N_way-1:0] branch_prediction,
//output [`N_way-1:0] mis_prediction               //uncond target misprediction, same as conditonal branch, signal for brat
///////////////////just for test//////////////
output logic [`N_way-1:0][`XLEN-1:0] test_target_pc,
output logic [`N_way-1:0] test_branch_prediction,
output BTB_table[`BTB_depth-1:0] test_btb,
output BHT_table [`BHT_depth-1:0] test_bht,
output  BC2 [`PHT_depth-1:0]test_pht 
);
    logic[`N_way-1:0][`XLEN-1:0] pre_pc;
    ///////////////////////////BTB/////////////////////////////////////////////////////////////////////////////////////////////////
    BTB_table [`BTB_depth-1:0] nx_BTB,BTB;
    logic[`N_way-1:0] hit_cond;                           //1 for hit, 0 for miss and for telling if it is branch
    logic[`N_way-1:0] hit_uncond;  
    logic[`N_way-1:0][`XLEN-1:0]     pre_target_pc;
    ///////////////////////////////BHT/////////////////////////////////////////////////////////////////////////////////////////////
    BHT_table [`BHT_depth-1:0]  nx_bht,bht;
    /////////////////////PHT/////////////////////////////////////////////////////////////////////////////////
    BC2 [`PHT_depth-1:0]  nx_pht,pht;

///////////combinational logic/////////////
    always_comb begin
        nx_pht=pht;
        nx_BTB=BTB;
        nx_bht=bht;
        pre_pc='d0;
        branch_prediction='d0;

        for(int i=0;i<`N_way;i=i+1)begin
            if(i==0)begin
                pre_pc[i]=fetch_pc;
            end
            else begin
                pre_pc[i]=pre_pc[i-1]+4;
            end
        end
        ///////// write calculated result to BTB//////////////
            for(int i=0; i< `ALU_num; i=i+1)begin
                // target_pc[i]='d0;
                if(c_btb_packet[i].if_cond )begin
                    nx_BTB[c_btb_packet[i].branch_pc[6:2]].BTB_tag = c_btb_packet[i].branch_pc[16:7];                       ///writing btb tag                    //BTB 32entry
                    nx_BTB[c_btb_packet[i].branch_pc[6:2]].part_target_pc = c_btb_packet[i].calculated_target[13:2];     ////writing part_target_pc
                    nx_BTB[c_btb_packet[i].branch_pc[6:2]].uncond_BTB =1'b0;
                    nx_BTB[c_btb_packet[i].branch_pc[6:2]].cond_BTB =1'b1;
                end
                else if(c_btb_packet[i].if_uncond)begin
                    nx_BTB[c_btb_packet[i].branch_pc[6:2]].BTB_tag = c_btb_packet[i].branch_pc[16:7];                       ///writing btb tag                    //BTB 32entry
                    nx_BTB[c_btb_packet[i].branch_pc[6:2]].part_target_pc = c_btb_packet[i].calculated_target[13:2];     ////writing part_target_pc
                    nx_BTB[c_btb_packet[i].branch_pc[6:2]].uncond_BTB =1'b1;
                    nx_BTB[c_btb_packet[i].branch_pc[6:2]].cond_BTB =1'b0;
                end
            end
        //////////writing branch results to BHT and PHT///////////////////
            for(int i=0; i<`ALU_num; i=i+1)begin                     
                if(c_btb_packet[i].if_cond)begin
                    case(nx_pht[nx_bht[c_btb_packet[i].branch_pc[6:2]].Branch_history])////////////// change bht entry//////////////
                                    Strong_Not_Taken: if(c_btb_packet[i].c_branch_taken)begin
                                                        nx_pht[nx_bht[c_btb_packet[i].branch_pc[6:2]].Branch_history]=Not_Taken;
                                                    end
                                                    else begin
                                                        nx_pht[nx_bht[c_btb_packet[i].branch_pc[6:2]].Branch_history]=Strong_Not_Taken;
                                                    end
                                    Not_Taken:       if(c_btb_packet[i].c_branch_taken)begin
                                                        nx_pht[nx_bht[c_btb_packet[i].branch_pc[6:2]].Branch_history]=Taken;
                                                    end
                                                    else begin
                                                        nx_pht[nx_bht[c_btb_packet[i].branch_pc[6:2]].Branch_history]=Strong_Not_Taken;
                                                    end
                                    Taken:       if(c_btb_packet[i].c_branch_taken)begin
                                                        nx_pht[nx_bht[c_btb_packet[i].branch_pc[6:2]].Branch_history]=Strong_Taken;
                                                    end
                                                    else begin
                                                        nx_pht[nx_bht[c_btb_packet[i].branch_pc[6:2]].Branch_history]=Not_Taken;
                                                    end
                                    Strong_Taken:   if(c_btb_packet[i].c_branch_taken)begin
                                                        nx_pht[nx_bht[c_btb_packet[i].branch_pc[6:2]].Branch_history]=Strong_Taken;
                                                    end
                                                    else begin
                                                        nx_pht[nx_bht[c_btb_packet[i].branch_pc[6:2]].Branch_history]=Taken;
                                                    end                
                                endcase
                        nx_bht[c_btb_packet[i].branch_pc[6:2]].Branch_history ={nx_bht[c_btb_packet[i].branch_pc[6:2]].Branch_history[`BHT_width-2:0] , c_btb_packet[i].c_branch_taken}; 
                    end
            end
        ////////////in fetch_stage/////////////////////////////////
            for(int i=0; i<`N_way; i++)begin
                pre_target_pc[i]= pre_pc[i];
                hit_cond[i]=1'b0;  
                hit_uncond[i]=1'b0;
                if(pre_pc_valid[i] && nx_BTB[pre_pc[i][6:2]].BTB_tag == pre_pc[i][16:7] && !nx_BTB[pre_pc[i][6:2]].uncond_BTB && nx_BTB[pre_pc[i][6:2]].cond_BTB) begin                                      //tag == tag?
                        pre_target_pc[i]={pre_pc[i][31:14], nx_BTB[pre_pc[i][6:2]].part_target_pc, pre_pc[i][1:0]};        //
                        hit_cond[i]=1'b1;                                                                                                   //yes! hit 
                end
                else if(pre_pc_valid[i] && nx_BTB[pre_pc[i][6:2]].BTB_tag == pre_pc[i][16:7] && nx_BTB[pre_pc[i][6:2]].uncond_BTB && !nx_BTB[pre_pc[i][6:2]].cond_BTB)begin
                        pre_target_pc[i]={pre_pc[i][31:14], nx_BTB[pre_pc[i][6:2]].part_target_pc, pre_pc[i][1:0]};        //entry 6:2    tag 16:7
                        hit_uncond[i]=1'b1;
                end
            end
        /////////reading prediction form PHT//////////////////////////////////////

            for(int i=0; i<`N_way; i=i+1) begin
                branch_prediction[i]=1'b0;
                if(hit_cond[i]==1'b1)begin
                    //for(int j=0; j<`PHT_depth; j=j+1)begin
                        case(nx_pht[nx_bht[pre_pc[i][6:2]].Branch_history ])            //
                            Strong_Not_Taken: branch_prediction[i]=1'b0;
                            Not_Taken:        branch_prediction[i]=1'b0;
                            Taken:            branch_prediction[i]=1'b1;
                            Strong_Taken:     branch_prediction[i]=1'b1;
                        endcase
                    //end
                end
                else if(hit_uncond[i]==1'b1)begin
                    branch_prediction[i]=1'b1;
                end
            end

        for(int i=0; i<`N_way; i=i+1)begin
            target_pc[i]='d0;
            if(branch_prediction[i]) begin
                target_pc[i]=pre_target_pc[i];
            end

        end

    // /////////BTB: check if there is target misprediction for unconditinal branch///////////// for jal and jar /////complete stage???
    end///comb end

    ///////////sequential logic///////////
    always_ff @(posedge clock) begin
        if(reset)begin
            pht <= `SD Strong_Not_Taken;
            test_pht <= `SD Strong_Not_Taken;
            test_branch_prediction <=`SD 'd0;
            test_target_pc <= `SD 'd0;
            for(int i=0; i<`BTB_depth;i=i+1)begin
            BTB[i] <= `SD{
                            10'd0,
                            12'd0,
                            1'd0,
                            1'd0
            };
            bht[i]<= `SD 'd0;
            test_bht[i]<=`SD 'd0;
            test_btb<= `SD{
                            10'd0,
                            12'd0,
                            1'd0,
                            1'b0
            };
            end
        end
        else begin
            BTB<= `SD nx_BTB;
            pht <= `SD nx_pht;
            bht<= `SD nx_bht;
            test_btb<= `SD nx_BTB;
            test_pht <= `SD nx_pht;
            test_bht<= `SD nx_bht;
            test_branch_prediction <=`SD branch_prediction;
            test_target_pc <= `SD target_pc;
        end
    end///sequential logic

endmodule

