`timescale 1ns/100ps
module ROB(
    input clock,
    input reset,
    input ROB_IN_PACKET [`N_way-1:0] rob_in_packet, 
    input [`ROB_LEN:0]BP_mispredicted_tail,     //clear_en tail
    input BP_mispredicted_tail_valid,     //clear_en
    input [`ALU_num-1:0][`ROB_LEN:0]BP_notmispredicted_tail, //clear_bit_en tail
    input [`ALU_num-1:0]BP_notmispredicted_tail_valid,//clear_bit_en
    output ROB_OUT_PACKET [`N_way-1:0] rob_out_packet, 
    output logic[`N_LEN:0] ROB_available_size_out,     
    output logic [`ROB_LEN:0]ROB_available_size,
    output ROB_PACKET [`ROB_size-1:0]ROB_table, //for debug
    output logic [`ROB_LEN:0]head,    //for debug
    output logic [`ROB_LEN:0]tail,   //for debug  tail is empty, the line before tail is the last inst
    output ROB_RETIRE_PACKET [`N_way-1:0]ROB_retire_out,

    input  [`ROB_LEN:0]ROB_store_tail_ready, //To ROB to write store ready bit
    input ROB_store_tail_valid
);
    ROB_PACKET [`ROB_size-1:0]next_ROB_table;
    logic [`ROB_LEN:0]next_head;
    logic [`ROB_LEN:0]next_tail;
    logic bp_next_circle_flag;
    logic [`ROB_LEN:0]tail_new;
    logic empty;

    always_comb begin
        ROB_available_size_out = 0;
        ROB_available_size_out = (ROB_available_size >`N_way)?`N_way:ROB_available_size;
    end
 

    always_comb begin
        next_head = head;
        rob_out_packet = 0;
        next_tail = tail;
        next_ROB_table = ROB_table;
        tail_new = tail;
        empty = 1;
        bp_next_circle_flag = 0;
        ROB_retire_out = 0;

        // for(int i=0;i<`N_way;i++)begin
        //     if(rob_in_packet[i].Rd_Preg_CDB!=0 && rob_in_packet[i].Rd_Preg_CDB_valid)begin
        //         for(int j=0;j<`ROB_size;j++)begin
        //             if(rob_in_packet[i].Rd_Preg_CDB == next_ROB_table[j].Preg)begin
        //                 next_ROB_table[j].Preg_ready_bit = 1;
        //             end
        //         end
        //     end
        // end
        for(int i=0;i<`N_way;i++)begin
            if(rob_in_packet[i].Rd_Preg_CDB_valid )begin
                // for(int j=0;j<`ROB_size;j++)begin
                    // if(rob_in_packet[i].Rd_Preg_CDB == next_ROB_table[j].Preg)begin
                    if(next_ROB_table[rob_in_packet[i].ROB_tail[`ROB_LEN-1:0]].valid)begin
                        next_ROB_table[rob_in_packet[i].ROB_tail[`ROB_LEN-1:0]].Preg_ready_bit = 1;
                        next_ROB_table[rob_in_packet[i].ROB_tail[`ROB_LEN-1:0]].Rd_Preg_value = rob_in_packet[i].Rd_Preg_value;
                    end
                // end
            end
        end
        if(ROB_store_tail_valid)begin
            next_ROB_table[ROB_store_tail_ready[`ROB_LEN-1:0]].Preg_ready_bit = 1;
        end

        for(int i=0;i<`N_way;i++)begin
            if(ROB_table[next_head[`ROB_LEN-1:0]].Preg_ready_bit==1 && ROB_table[next_head[`ROB_LEN-1:0]].valid) begin
                rob_out_packet[i].Rd_Preg_RRAT = ROB_table[next_head[`ROB_LEN-1:0]].Preg;
                rob_out_packet[i].Rd_old_Preg_RRAT = ROB_table[next_head[`ROB_LEN-1:0]].Preg_old;
                rob_out_packet[i].Retire_enable = 1;       //complete enable retire enable comes from pipeline
                
                
                ROB_retire_out[i].inst = ROB_table[next_head[`ROB_LEN-1:0]].inst;
                ROB_retire_out[i].Preg = ROB_table[next_head[`ROB_LEN-1:0]].Preg;
                ROB_retire_out[i].Preg_ready_bit = ROB_table[next_head[`ROB_LEN-1:0]].Preg_ready_bit;
                ROB_retire_out[i].Preg_old = ROB_table[next_head[`ROB_LEN-1:0]].Preg_old;
                ROB_retire_out[i].Rd_Preg_value = ROB_table[next_head[`ROB_LEN-1:0]].Rd_Preg_value;
                ROB_retire_out[i].Rd_Areg = ROB_table[next_head[`ROB_LEN-1:0]].Rd_Areg;

                ROB_retire_out[i].is_branch = ROB_table[next_head[`ROB_LEN-1:0]].is_branch;
                ROB_retire_out[i].cond_branch = ROB_table[next_head[`ROB_LEN-1:0]].cond_branch;
                ROB_retire_out[i].uncond_branch = ROB_table[next_head[`ROB_LEN-1:0]].uncond_branch;
                ROB_retire_out[i].csr_op = ROB_table[next_head[`ROB_LEN-1:0]].csr_op;
                ROB_retire_out[i].halt = ROB_table[next_head[`ROB_LEN-1:0]].halt;
                ROB_retire_out[i].illegal = ROB_table[next_head[`ROB_LEN-1:0]].illegal;
                ROB_retire_out[i].valid = ROB_table[next_head[`ROB_LEN-1:0]].valid;
                ROB_retire_out[i].NPC  = ROB_table[next_head[`ROB_LEN-1:0]].NPC;
                ROB_retire_out[i].PC   = ROB_table[next_head[`ROB_LEN-1:0]].PC;
                ROB_retire_out[i].Retire_enable = 1;
                ROB_retire_out[i].rd_mem = ROB_table[next_head[`ROB_LEN-1:0]].rd_mem;
                ROB_retire_out[i].wr_mem = ROB_table[next_head[`ROB_LEN-1:0]].wr_mem;
                ROB_retire_out[i].ROB_pointer = next_head;


                next_ROB_table[next_head[`ROB_LEN-1:0]] = 0;  //cannot clear now wait until retire stage
                next_head = next_head + 1;
                if(ROB_retire_out[i].halt)begin
                    next_ROB_table = 0;
                    next_head = 0;
                    next_tail = {`ROB_LEN+1{1'b1}};
                    break;
                end
            end
            else begin
                rob_out_packet[i].Rd_Preg_RRAT = 0;
                rob_out_packet[i].Rd_old_Preg_RRAT = 0;
                rob_out_packet[i].Retire_enable = 0;
                ROB_retire_out[i].Retire_enable = 0;
            end

            if(rob_in_packet[i].Dispatch_enable)begin
                next_tail = next_tail + 1;
                if(rob_in_packet[i].is_branch) begin
                    rob_out_packet[i].branch_tail = next_tail;
                end
                else begin
                    rob_out_packet[i].branch_tail = 0;
                end
                if(rob_in_packet[i].rd_mem)begin
                    rob_out_packet[i].load_tail = next_tail;
                    rob_out_packet[i].rd_mem = 1;
                end
                if(rob_in_packet[i].wr_mem)begin
                    rob_out_packet[i].store_tail = next_tail;
                    rob_out_packet[i].wr_mem = 1;
                end
                if(rob_in_packet[i].Dispatch_enable)begin
                    rob_out_packet[i].ROB_tail = next_tail;
                end
                next_ROB_table[next_tail[`ROB_LEN-1:0]].inst = rob_in_packet[i].inst;
                next_ROB_table[next_tail[`ROB_LEN-1:0]].Preg = rob_in_packet[i].Rd_Preg_Freelist;
                next_ROB_table[next_tail[`ROB_LEN-1:0]].Preg_old = rob_in_packet[i].Rd_old_Preg_RAT;
                next_ROB_table[next_tail[`ROB_LEN-1:0]].Rd_Areg = rob_in_packet[i].Rd_Areg;

                next_ROB_table[next_tail[`ROB_LEN-1:0]].is_branch = rob_in_packet[i].is_branch;
                next_ROB_table[next_tail[`ROB_LEN-1:0]].rd_mem = rob_in_packet[i].rd_mem;
                next_ROB_table[next_tail[`ROB_LEN-1:0]].wr_mem = rob_in_packet[i].wr_mem;
                next_ROB_table[next_tail[`ROB_LEN-1:0]].cond_branch = rob_in_packet[i].cond_branch;
                next_ROB_table[next_tail[`ROB_LEN-1:0]].uncond_branch = rob_in_packet[i].uncond_branch;
                next_ROB_table[next_tail[`ROB_LEN-1:0]].halt = rob_in_packet[i].halt;
                next_ROB_table[next_tail[`ROB_LEN-1:0]].illegal = rob_in_packet[i].illegal;
                next_ROB_table[next_tail[`ROB_LEN-1:0]].csr_op = rob_in_packet[i].csr_op;
                next_ROB_table[next_tail[`ROB_LEN-1:0]].valid = rob_in_packet[i].valid;
                next_ROB_table[next_tail[`ROB_LEN-1:0]].NPC = rob_in_packet[i].NPC;
                next_ROB_table[next_tail[`ROB_LEN-1:0]].PC = rob_in_packet[i].PC;
                // if(rob_in_packet[i].inst==`WFI) begin
                //     next_ROB_table[next_tail[`ROB_LEN-1:0]].Preg_ready_bit = 1;
                // end
            end
            else begin
                rob_out_packet[i].branch_tail = 0;
            end
        end
        tail_new = next_tail;

        bp_next_circle_flag = (BP_mispredicted_tail[`ROB_LEN] == tail_new[`ROB_LEN])?1'b0:1'b1;
        if(BP_mispredicted_tail_valid && ROB_table[BP_mispredicted_tail[`ROB_LEN-1:0]].is_branch  && ROB_table[BP_mispredicted_tail[`ROB_LEN-1:0]].valid)begin
            next_ROB_table[BP_mispredicted_tail[`ROB_LEN-1:0]].Preg_ready_bit = 1'b1;
            if(bp_next_circle_flag)begin    
                for(int i=0;i<`ROB_size;i++)begin
                    if(i<=tail_new[`ROB_LEN-1:0] || i>BP_mispredicted_tail[`ROB_LEN-1:0])begin
                        next_ROB_table[i] = 0;
                        next_tail = BP_mispredicted_tail;
                        rob_out_packet[i].branch_tail = 0;
                    end
                end
            end
            else begin
                for(int i=0;i<`ROB_size;i++)begin
                    if(i<=tail_new[`ROB_LEN-1:0] && i>BP_mispredicted_tail[`ROB_LEN-1:0])begin
                        next_ROB_table[i] = 0;
                        next_tail = BP_mispredicted_tail;
                        rob_out_packet[i].branch_tail = 0;
                    end
                end
            end
        end
        for(int i=0;i<`ALU_num;i++) begin
            if(BP_notmispredicted_tail_valid[i] && next_ROB_table[BP_notmispredicted_tail[i][`ROB_LEN-1:0]].is_branch)begin
                next_ROB_table[BP_notmispredicted_tail[i][`ROB_LEN-1:0]].Preg_ready_bit = 1'b1;
            end
        end

        for(int i=0;i<`ROB_size;i=i+1)begin
            empty= empty & (next_ROB_table[i].valid==0);
        end
    end

    always_ff@(posedge clock)begin
        if(reset)begin
            ROB_table <= `SD 0;
            head <= `SD 0;
            tail <= `SD {`ROB_LEN+1{1'b1}};
            ROB_available_size <= `SD `ROB_size;
        end
        else begin
            if(empty) begin
                ROB_available_size <= `SD `ROB_size;
                head <= `SD 0;
                tail <= `SD {`ROB_LEN+1{1'b1}};
            end
            else begin
                ROB_available_size <= `SD `ROB_size - (next_tail - next_head) - 1;
                head <= `SD next_head;
                tail <= `SD next_tail;
            end
            ROB_table <= `SD next_ROB_table;
        end
    end





endmodule