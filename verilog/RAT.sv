`timescale 1ns/100ps

module RAT(
// Input
    input reset,
    input clock,
    input RAT_IN_PACKET [`N_way-1:0]  rat_in_packet,
    // Updated on 10.28
    input rollback_brat_en,
    input RAT_PACKET rat_brat,

// Output
    output RAT_OUT_PACKET [`N_way-1:0] rat_out_packet,
    output RAT_PACKET RAT_table,
    // Updated on 10.28
    output RAT_PACKET [`N_way-1:0] RAT_table_to_BRAT // To BRAT
);

    RAT_PACKET next_RAT;
    logic flag_rs1_forwarding;
    logic flag_rs2_forwarding;
    logic flag_rd_forwarding;


    always_comb begin       //update RAT, get next_RAT
        RAT_table_to_BRAT = 0;
        next_RAT = 0;

        if (rollback_brat_en == 1) begin
            next_RAT = rat_brat;
        end
        else begin
	        RAT_table_to_BRAT = 0;
            next_RAT = RAT_table;
            for(int i=0;i<`N_way;i=i+1)begin  
                if(rat_in_packet[i].Set_ready_bit_enable==1)begin                   //When Preg is ready
                    for(int j=0;j<`Areg_num;j=j+1)begin                                //look for the ready Preg in next_RAT
                        if(rat_in_packet[i].Set_ready_bit==next_RAT.Preg[j]) //find which Preg is ready
                            next_RAT.ready_bit[j] = 1'b1;                                        //readybit set to 1
                    end
                end
            end
            for(int i=0;i<`N_way;i=i+1)begin  
                if(rat_in_packet[i].Dispatch_enable && rat_in_packet[i].Rd_Areg!=0)begin
                    next_RAT.Preg[rat_in_packet[i].Rd_Areg] = rat_in_packet[i].Rd_Preg;  //update rd_preg in next_RAT
                    next_RAT.ready_bit[rat_in_packet[i].Rd_Areg] = 1'b0; 
                end
                if (rat_in_packet[i].is_branch == 1) begin
                    RAT_table_to_BRAT[i] = next_RAT;
                end
            end
        end
    end

    always_comb begin       //get rs1_preg,rs2_preg, rs1_readybit. rs2_readybit to RS, get rd_old_preg to ROB
        rat_out_packet = 0;
        for(int i=0; i < `N_way; i=i+1)begin
            flag_rs1_forwarding = 0;                //prevent overwrite
            flag_rs2_forwarding = 0;
            flag_rd_forwarding = 0;
            if(rat_in_packet[i].Dispatch_enable)begin
                if(i==0)begin               //first inst: rs1,rs2,rd_old, rs1_readybit, rs2_readybit from RAT
                    rat_out_packet[i].Rs1_Preg_RS = RAT_table.Preg[rat_in_packet[i].Rs1_Areg];  
                    rat_out_packet[i].Rs2_Preg_RS = RAT_table.Preg[rat_in_packet[i].Rs2_Areg];
                    rat_out_packet[i].Rs1_Preg_ready_RS = RAT_table.ready_bit[rat_in_packet[i].Rs1_Areg];
                    rat_out_packet[i].Rs2_Preg_ready_RS= RAT_table.ready_bit[rat_in_packet[i].Rs2_Areg];
                    rat_out_packet[i].Rd_old_Preg_ROB = RAT_table.Preg[rat_in_packet[i].Rd_Areg];
                end //first inst
                else begin
                    for(int j=0;j<i;j=j+1)begin  //second inst to Nth inst: forwarding, compare rs(or rd) from ith inst with all rds from above ith inst(jth inst j<i)
                    // compare rs1 with rd
                        if(rat_in_packet[i].Rs1_Areg==rat_in_packet[j].Rd_Areg && rat_in_packet[i].Rs1_Areg!=0)begin  // rs1(ith inst)==rd(j<i jth inst)
                            rat_out_packet[i].Rs1_Preg_RS = rat_in_packet[j].Rd_Preg;  //rs1_preg[i] = rd_preg[j](from free list)
                            rat_out_packet[i].Rs1_Preg_ready_RS = 0;                   // rs1_preg[i] not ready 
                            flag_rs1_forwarding = 1;
                            end // rs1(ith inst)==rd(j<i jth inst)
                        else if(flag_rs1_forwarding!=1)  begin                                                                         //no hazard
                            rat_out_packet[i].Rs1_Preg_RS = RAT_table.Preg[rat_in_packet[i].Rs1_Areg];    //rs1_preg from RAT
                            rat_out_packet[i].Rs1_Preg_ready_RS = RAT_table.ready_bit[rat_in_packet[i].Rs1_Areg];        //rs1_readybit from RAT
                        end //compare rs1 with rd end
                    // compare rs2 with rd
                        if(rat_in_packet[i].Rs2_Areg==rat_in_packet[j].Rd_Areg && rat_in_packet[i].Rs2_Areg!=0)begin //rs2(ith inst)==rd(j<i)
                            rat_out_packet[i].Rs2_Preg_RS = rat_in_packet[j].Rd_Preg;   //rs2_preg[i] = rd_preg[j](from free list)
                            rat_out_packet[i].Rs2_Preg_ready_RS = 0;                     // rs2_preg[i] not ready
                            flag_rs2_forwarding = 1;
                        end //rs2(ith inst)==rd(j<i)
                        else if(flag_rs2_forwarding!=1)begin                                                                          //no hazard
                            rat_out_packet[i].Rs2_Preg_RS = RAT_table.Preg[rat_in_packet[i].Rs2_Areg];    //rs2_preg from RAT
                            rat_out_packet[i].Rs2_Preg_ready_RS = RAT_table.ready_bit[rat_in_packet[i].Rs2_Areg];        //rs2_readybit from RAT
                        end    //  compare rs2 with rd             
                    //compare rd  with rd            
                        if(rat_in_packet[i].Rd_Areg==rat_in_packet[j].Rd_Areg && rat_in_packet[i].Rd_Areg!=0)begin  //rd(j j<i)==rd(ith inst)
                            rat_out_packet[i].Rd_old_Preg_ROB = rat_in_packet[j].Rd_Preg;                           //rd_old_preg[i] = rd_preg[j](from free list)
                            flag_rd_forwarding = 1;
                        end //rd(j j<i)==rd(ith inst)
                        else if(flag_rd_forwarding!=1)begin                                                                          //no hazard
                            rat_out_packet[i].Rd_old_Preg_ROB = RAT_table.Preg[rat_in_packet[i].Rd_Areg];        //rd_old_preg[i] from RAT
                        end //compare rd  with rd    
                    end //second inst to Nth inst: forwarding, compare rs(or rd) from ith inst with all rds from above ith inst(jth inst j<i)
                end //not 1st inst
                for(int j=0;j<`N_way;j++)begin
                    if(rat_in_packet[j].Set_ready_bit_enable && rat_in_packet[j].Set_ready_bit==rat_out_packet[i].Rs1_Preg_RS && rat_in_packet[i].Rs1_Areg!=0)
                        rat_out_packet[i].Rs1_Preg_ready_RS = 1;
                    if(rat_in_packet[j].Set_ready_bit_enable && rat_in_packet[j].Set_ready_bit==rat_out_packet[i].Rs2_Preg_RS && rat_in_packet[i].Rs2_Areg!=0)
                        rat_out_packet[i].Rs2_Preg_ready_RS = 1;
                end
            end //dispatch_enable[i]       
        end //N-way
    end //comb


    always_ff @(posedge clock)begin
        if(reset) begin
            for (int i=0; i<`Areg_num;i=i+1)begin
                RAT_table.Preg[i] <= `SD {1'b0,i};
                RAT_table.ready_bit[i] <= `SD 1'b1;
            end
        end
        else begin
            RAT_table <= `SD next_RAT;
        end
    end


endmodule
