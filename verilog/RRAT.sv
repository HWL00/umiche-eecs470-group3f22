`timescale 1ns/100ps

module RRAT(
    input reset,
    input clock,
    input RRAT_IN_PACKET [`N_way-1:0]  rrat_in_packet,
    output RRAT_PACKET [`Areg_num-1:0]RRAT_table
);

    RRAT_PACKET [`Areg_num-1:0]next_RRAT;

    always_comb begin       //update RAT, get next_RAT
        next_RRAT = RRAT_table;
        for(int i=0;i<`N_way;i=i+1)begin  
            if(rrat_in_packet[i].Retire_enable==1)begin                              //When inst is retired
                for(int j=0;j<`Areg_num;j=j+1)begin                                  //look for the T_old in next_RRAT
                    if(rrat_in_packet[i].Rd_old_Preg_ROB==next_RRAT[j].Preg) 
                        next_RRAT[j].Preg = rrat_in_packet[i].Rd_Preg_ROB;   //replace the T_old with T                        
                end
            end
        end
    end

    always_ff@(posedge clock)begin
        if(reset) begin
            for (int i=0; i<`Areg_num;i=i+1)begin
                RRAT_table[i].Preg <= `SD {1'b0,i};
                RRAT_table[i].ready_bit <= `SD 1'b1;
            end
        end
        else begin
            RRAT_table <= `SD next_RRAT;
        end
    end


endmodule