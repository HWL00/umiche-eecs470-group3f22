`timescale 1ns/100ps

module Freelist(
    input reset,
    input clock,
    input Freelist_IN_PACKET [`N_way-1:0]freelist_in_packet,
    input rollback_brat_en,
    input Freelist_PACKET [`Freelist_size-1:0]Freelist_table_BRAT,
    input [`Freelist_LEN:0]head_BRAT,
    input [`Freelist_LEN:0]tail_BRAT,

    output Freelist_OUT_PACKET [`N_way-1:0] freelist_out_packet,
    output logic[$clog2(`N_way):0] freelist_available_num_out,     //To dispatch whether there are N free physical registers
    output Freelist_PACKET [`Freelist_size-1:0]Freelist_table,
    output logic [`Freelist_LEN:0]freelist_available_num,
    output logic [`Freelist_LEN:0]head,
    output logic [`Freelist_LEN:0]tail,
    output Freelist_PACKET [`N_way-1:0][`Freelist_size-1:0]Freelist_table_to_BRAT,   // Copy to BRAT
    output logic [`N_way-1:0][`Freelist_LEN:0]freelist_head_to_BRAT,
    output logic [`N_way-1:0][`Freelist_LEN:0]freelist_tail_to_BRAT
);

    Freelist_PACKET [`Freelist_size-1:0]next_Freelist;
    logic [`Freelist_LEN:0]next_head;
    logic [`Freelist_LEN:0]next_tail;

    Freelist_OUT_PACKET [`N_way-1:0] next_freelist_out_packet;

    always_comb begin
        freelist_available_num_out = 'd0;

        freelist_available_num_out = (freelist_available_num >`N_way)?`N_way:freelist_available_num;
    end

    always_comb begin
        next_Freelist = 0;
        next_head = 0;
        next_tail = 0;
        next_freelist_out_packet = 0;
        Freelist_table_to_BRAT = 0;
        freelist_head_to_BRAT = 0;
        freelist_tail_to_BRAT = 0;
        if (rollback_brat_en) begin
            next_Freelist = Freelist_table_BRAT;
            next_head = head_BRAT;
            next_tail = tail_BRAT;
        end
        else begin
            next_Freelist = Freelist_table;
            next_tail = tail;
            next_head = head;
            next_freelist_out_packet = 0;
            Freelist_table_to_BRAT = 0;
            freelist_head_to_BRAT = 0;
            freelist_tail_to_BRAT = `Freelist_size-1;
            for(int i=0;i<`N_way;i++)begin
                if(freelist_in_packet[i].Retire_enable)
                begin
                    if(freelist_in_packet[i].Rd_old_Preg_ROB)begin
                        next_tail = next_tail + 1'b1;
                        next_Freelist[next_tail[`Freelist_LEN-1:0]].Preg = freelist_in_packet[i].Rd_old_Preg_ROB;
                    end
                end
                if(freelist_in_packet[i].Dispatch_enable && freelist_in_packet[i].Dispatch_Rd_available && freelist_in_packet[i].Rd_Areg!=0)
                begin
                    next_Freelist[next_head[`Freelist_LEN-1:0]].Preg = 0;
                    next_freelist_out_packet[i].Rd_Preg_out = Freelist_table[next_head[`Freelist_LEN-1:0]].Preg;
                    next_head = next_head + 1'b1;
                end
                else begin
                    next_freelist_out_packet[i].Rd_Preg_out = 0;
                end

                if (freelist_in_packet[i].is_branch == 1) begin
                    Freelist_table_to_BRAT[i] = next_Freelist;
                    freelist_head_to_BRAT[i] = next_head;
                    freelist_tail_to_BRAT[i] = next_tail;
                end
            end
        end
    end
    always_comb begin
        freelist_out_packet = 0;

        freelist_out_packet = next_freelist_out_packet;
    end


    always_ff @(posedge clock) begin
        if(reset) begin
            for (int i=0; i<`Freelist_size; i=i+1)begin
                Freelist_table[i].Preg <= `SD (i + `Areg_num);
            end
            head <= `SD {(`Freelist_LEN+1){1'b0}};
            tail <= `SD `Freelist_size-1;     
            freelist_available_num <= `SD `Freelist_size;  
        end
        else begin
            Freelist_table <= `SD next_Freelist;
            head <= `SD next_head;
            tail <= `SD next_tail;
            freelist_available_num <= `SD next_tail - next_head + 1;
        end
    end
endmodule
