`timescale 1ns/100ps
module LSQ(input clock, reset,halt_flag,
        //dispatch//////////////////////////////////////
        input LSQ_IN_Packet [`N_way-1:0]lsq_in_packet,  //from dispatch
        output logic  sq_empty,        //To dispatch
        output logic [`SQ_LEN:0] sq_available_num, 
        //rs//////////////////////////////////////
        input [`LOAD_IB_Depth-1:0][`SQ_LEN:0]load_SQ_tail_from_is,   //load from rs to check ready
        input [`LOAD_IB_Depth-1:0]load_SQ_tail_from_is_valid,    //load from rs to check ready
        input [`RS_depth-1:0][`SQ_LEN:0]load_SQ_tail_from_rs,   //load from rs to check ready
        input [`RS_depth-1:0]load_SQ_tail_from_rs_valid,    //load from rs to check ready

        output logic [`LOAD_IB_Depth-1:0]load_SQ_tail_to_is_valid, //load to rs ready bit if all store are valid from head and saved sq tail 
        output logic [`RS_depth-1:0]load_SQ_tail_to_rs_valid,
        output logic [`N_way-1:0][`SQ_LEN:0]SQ_tail_rs,        //To RS dispatch
        output logic [`SQ_LEN:0]retire_head2rs_is,
        output logic retire_enable2rs_is,
        //RAT//////////////////////////////////////////
        input RAT_OUT_PACKET [`N_way-1:0] rat_out_packet,
        //ROB//////////////////////////////////////////
        input ROB_OUT_PACKET [`N_way-1:0] rob_out_packet,
        input ROB_RETIRE_PACKET [`N_way-1:0]ROB_retire_out,

        output logic [`ROB_LEN:0]ROB_store_tail_ready, //To ROB to write store ready bit
        output logic ROB_store_tail_valid,
        //BRAT//////////////////////////////////////////
        input SQ_BP_mispredicted_tail_valid,   //from BRAT  connected BP_mispredicted_tail_valid   pipeline clean_brat_en
        input [`SQ_LEN:0]SQ_BP_mispredicted_tail,  //from BRAT
        output logic [`N_way-1:0][`SQ_LEN:0]SQ_tail_BRAT,             //To BRAT
        input reset_sq,
        ///ex/////////////////////////////////////////////
        input EX_COM_PACKET ex_out_packet_store,  //ALU packet for store
        
        input EX_COM_PACKET ex_out_packet_load,
        output logic sq_memsize_stall,
        // output logic sq_memsize_stall_tmp,
        output EX_COM_PACKET ex_out_packet_load_new, //with load address forwarding
        //D Cache///////////////////////////////////
        input stop_sq_retire_en,
        output logic load_hit_sq, // to D cache and execute

        output SQ_OUT_PACKET sq_out_packet, //store To D cache

        output SQ_PACKET [`SQ_size-1:0]store_queue //For print
        // output logic sq_empty
        );
        logic sq_memsize_stall_tmp;
        SQ_PACKET [`SQ_size-1:0] next_store_queue;
        logic [`SQ_LEN:0]head,tail,next_head,next_tail,tail_new, next_head_j,check_tail;
        logic bp_next_circle_flag;
        // logic next_cycle_flag_sq;
        // logic check_next_circle_flag;
        // logic empty_tmp;
        logic retire_clear_en;
        
    
        logic [`LOAD_IB_Depth-1:0] load_SQ_tail_to_is_valid_tmp;
        logic [`RS_depth-1:0] load_SQ_tail_to_rs_valid_tmp;

        always_comb begin
            SQ_tail_BRAT = 0;
            ex_out_packet_load_new = 0;
            load_hit_sq = 0;
            sq_out_packet = 0;
            sq_memsize_stall_tmp=sq_memsize_stall ;

            next_store_queue = store_queue;
            SQ_tail_rs = 0;
            
            next_head = head;
            next_tail = tail;
            next_head_j = 0;
            ROB_store_tail_ready = 0;
            ROB_store_tail_valid = 0;
            
            
            load_SQ_tail_to_is_valid_tmp = 0;
            load_SQ_tail_to_rs_valid_tmp = 0;
            // empty = 1;
            tail_new = 0;
            check_tail = 0;
            bp_next_circle_flag = 0;
            // next_cycle_flag_sq = 0;
            // check_next_circle_flag = 0;
            retire_clear_en = 1;

            retire_head2rs_is = 0;
            retire_enable2rs_is = 0;


            for(int i=0;i<`N_way;i++)begin
                for(int j=0;j<`SQ_size;j++)begin
                    if( 
                    ROB_retire_out[i].Retire_enable && 
                    ROB_retire_out[i].wr_mem && 
                    ROB_retire_out[i].ROB_pointer == next_store_queue[j].ROB_pointer && next_store_queue[j].valid
                    )begin
                        next_store_queue[j].Retire_enable=1'b1;
                    end
                end
            end

            

            if( next_store_queue[next_head[`SQ_LEN-1:0]].Retire_enable && !stop_sq_retire_en )begin
                retire_head2rs_is = next_head;
                retire_enable2rs_is = 1'b1;

                sq_out_packet.value = next_store_queue[next_head[`SQ_LEN-1:0]].value;
                sq_out_packet.store_address = next_store_queue[next_head[`SQ_LEN-1:0]].store_address;
                sq_out_packet.address_value_valid = next_store_queue[next_head[`SQ_LEN-1:0]].address_value_valid;

                sq_out_packet.inst = next_store_queue[next_head[`SQ_LEN-1:0]].inst;
                sq_out_packet.NPC = next_store_queue[next_head[`SQ_LEN-1:0]].NPC;
                sq_out_packet.PC = next_store_queue[next_head[`SQ_LEN-1:0]].PC;
                sq_out_packet.rd_mem = next_store_queue[next_head[`SQ_LEN-1:0]].rd_mem;
                sq_out_packet.wr_mem = next_store_queue[next_head[`SQ_LEN-1:0]].wr_mem;
                sq_out_packet.mem_size = next_store_queue[next_head[`SQ_LEN-1:0]].inst.r.funct3;
                if(next_store_queue[next_head[`SQ_LEN-1:0]].addr_depend)begin
                                sq_memsize_stall_tmp = 0;
                    end
                next_store_queue[next_head[`SQ_LEN-1:0]] = 0;
                next_head = next_head + 1'b1;
            end

            sq_empty = 1;
            for(int i=0;i<`SQ_size;i=i+1)begin
                sq_empty= sq_empty & (next_store_queue[i].valid==0);
            end
            
            for(int i=0;i<`N_way;i++)begin
                if(lsq_in_packet[i].Dispatch_enable)begin  //if store
                    if(lsq_in_packet[i].is_branch) begin
                        SQ_tail_BRAT[i] = next_tail;
                    end
                    else begin
                        SQ_tail_BRAT[i] = 0;
                    end
                    if(lsq_in_packet[i].wr_mem) begin
                        next_tail = next_tail + 1;
                        next_store_queue[next_tail[`SQ_LEN-1:0]].Rs2_Preg = rat_out_packet[i].Rs2_Preg_RS;

                        // next_store_queue[next_tail[`SQ_LEN-1:0]].Rs2_Areg = lsq_in_packet[i].Rs2_Areg;
                        next_store_queue[next_tail[`SQ_LEN-1:0]].inst = lsq_in_packet[i].inst;
                        next_store_queue[next_tail[`SQ_LEN-1:0]].rd_mem = lsq_in_packet[i].rd_mem;
                        next_store_queue[next_tail[`SQ_LEN-1:0]].wr_mem = lsq_in_packet[i].wr_mem;
                        next_store_queue[next_tail[`SQ_LEN-1:0]].halt = lsq_in_packet[i].halt;
                        next_store_queue[next_tail[`SQ_LEN-1:0]].illegal = lsq_in_packet[i].illegal;
                        next_store_queue[next_tail[`SQ_LEN-1:0]].csr_op = lsq_in_packet[i].csr_op;
                        next_store_queue[next_tail[`SQ_LEN-1:0]].valid = lsq_in_packet[i].valid;
                        next_store_queue[next_tail[`SQ_LEN-1:0]].NPC = lsq_in_packet[i].NPC;
                        next_store_queue[next_tail[`SQ_LEN-1:0]].PC = lsq_in_packet[i].PC;
                        next_store_queue[next_tail[`SQ_LEN-1:0]].is_b_mask = lsq_in_packet[i].is_b_mask;
                        next_store_queue[next_tail[`SQ_LEN-1:0]].b_mask_bit_branch = lsq_in_packet[i].b_mask_bit_branch;

                        next_store_queue[next_tail[`SQ_LEN-1:0]].ROB_pointer =  rob_out_packet[i].store_tail;
                        
                    end
                    SQ_tail_rs[i] = next_tail;
                end
            end
            // empty = 1;
            // for(int i=0;i<`SQ_size;i=i+1)begin
            //     empty= empty & (next_store_queue[i].valid==0);
            // end

            
            if(ex_out_packet_store.wr_mem && next_store_queue[ex_out_packet_store.SQ_tail[`SQ_LEN-1:0]].valid)begin
                next_store_queue[ex_out_packet_store.SQ_tail[`SQ_LEN-1:0]].store_address = ex_out_packet_store.alu_result;
                next_store_queue[ex_out_packet_store.SQ_tail[`SQ_LEN-1:0]].value = ex_out_packet_store.rs2_value;
                next_store_queue[ex_out_packet_store.SQ_tail[`SQ_LEN-1:0]].address_value_valid = 1;
                
                next_store_queue[ex_out_packet_store.SQ_tail[`SQ_LEN-1:0]].mem_size = ex_out_packet_store.mem_size;
                ROB_store_tail_ready = next_store_queue[ex_out_packet_store.SQ_tail[`SQ_LEN-1:0]].ROB_pointer;
                ROB_store_tail_valid = 1;
            end
            

            // for(int i=0;i<`LOAD_IB_Depth;i++)begin
            //     if(load_SQ_tail_from_is_valid[i])begin
            //         load_SQ_tail_to_is_valid_tmp[i] = 1;
                    
            //         for(int j=0;j<`SQ_size;j++)begin
            //             next_head_j = head+j;
            //             load_SQ_tail_to_is_valid_tmp[i] = load_SQ_tail_to_is_valid_tmp[i] && (store_queue[next_head_j[`SQ_LEN-1:0]].address_value_valid||!store_queue[next_head_j[`SQ_LEN-1:0]].valid);
            //             if(next_head_j==load_SQ_tail_from_is[i]) begin
            //                 break;
            //             end
            //         end
            //         if(empty)begin
            //             load_SQ_tail_to_is_valid_tmp[i] = 1;
            //         end
            //     end
            // end

            // for(int i=0;i<`RS_depth;i++)begin
            //     if(load_SQ_tail_from_rs_valid[i])begin
            //         load_SQ_tail_to_rs_valid_tmp[i] = 1;
                    
            //         for(int j=0;j<`SQ_size;j++)begin
            //             next_head_j = head+j;
            //             load_SQ_tail_to_rs_valid_tmp[i] = load_SQ_tail_to_rs_valid_tmp[i] && (store_queue[next_head_j[`SQ_LEN-1:0]].address_value_valid||!store_queue[next_head_j[`SQ_LEN-1:0]].valid);
            //             if(next_head_j==load_SQ_tail_from_rs[i]) begin
            //                 break;
            //             end
            //         end
            //         if(empty)begin
            //             load_SQ_tail_to_is_valid_tmp[i] = 1;
            //         end
            //     end
            // end

            


            tail_new = next_tail;

            bp_next_circle_flag = (SQ_BP_mispredicted_tail[`SQ_LEN] == tail_new[`SQ_LEN])?1'b0:1'b1;
            if(SQ_BP_mispredicted_tail_valid)begin
                if(bp_next_circle_flag)begin    
                    for(int i=0;i<`SQ_size;i++)begin
                        if(i<=tail_new[`SQ_LEN-1:0] || i>SQ_BP_mispredicted_tail[`SQ_LEN-1:0])begin
                            next_store_queue[i] = 0;
                            next_tail = SQ_BP_mispredicted_tail;
                        end
                    end
                end
                else begin
                    for(int i=0;i<`SQ_size;i++)begin
                        if(i<=tail_new[`SQ_LEN-1:0] && i>SQ_BP_mispredicted_tail[`SQ_LEN-1:0])begin
                            next_store_queue[i] = 0;
                            next_tail = SQ_BP_mispredicted_tail;
                        end
                    end
                end
            end

            if(SQ_BP_mispredicted_tail_valid && reset_sq)begin
                next_store_queue = 0;
                next_head = 0;
                next_tail = {`SQ_LEN+1{1'b1}};
            end

            // empty = 1;
            // for(int i=0;i<`SQ_size;i=i+1)begin
            //     empty= empty & (store_queue[i].valid==0);
            // end
            
             for(int i=0;i<`LOAD_IB_Depth;i++)begin
                if(load_SQ_tail_from_is_valid[i])begin
                    load_SQ_tail_to_is_valid_tmp[i] = 1;
                    
                    for(int j=0;j<`SQ_size;j++)begin
                        next_head_j = head+j;
                        load_SQ_tail_to_is_valid_tmp[i] = load_SQ_tail_to_is_valid_tmp[i] && (store_queue[next_head_j[`SQ_LEN-1:0]].address_value_valid||!store_queue[next_head_j[`SQ_LEN-1:0]].valid);
                        if(next_head_j==load_SQ_tail_from_is[i]) begin
                            break;
                        end
                    end
                end
            end

            for(int i=0;i<`RS_depth;i++)begin
                if(load_SQ_tail_from_rs_valid[i])begin
                    load_SQ_tail_to_rs_valid_tmp[i] = 1;
                    
                    for(int j=0;j<`SQ_size;j++)begin
                        next_head_j = head+j;
                        load_SQ_tail_to_rs_valid_tmp[i] = load_SQ_tail_to_rs_valid_tmp[i] && (store_queue[next_head_j[`SQ_LEN-1:0]].address_value_valid||!store_queue[next_head_j[`SQ_LEN-1:0]].valid);
                        if(next_head_j==load_SQ_tail_from_rs[i]) begin
                            break;
                        end
                    end
                end
            end
            // check_next_circle_flag = (ex_out_packet_load.SQ_tail[`SQ_LEN]==next_head[`SQ_LEN])?1'b0:1'b1;
            // if(ex_out_packet_load.rd_mem)begin
            //     for(int j=0;j<`SQ_size;j++)begin
            //         check_tail = ex_out_packet_load.SQ_tail-j;
            //         if(!check_next_circle_flag&&(check_tail>=next_head) && ex_out_packet_load.alu_result==store_queue[check_tail[`SQ_LEN-1:0]].store_address && ex_out_packet_load.mem_size==store_queue[check_tail[`SQ_LEN-1:0]].mem_size)begin
            //             ex_out_packet_load_new = ex_out_packet_load;
            //             ex_out_packet_load_new.alu_result = store_queue[check_tail[`SQ_LEN-1:0]].value;
            //             load_hit_sq = 1;
            //             break;
            //         end
            //         else if(check_next_circle_flag &&
            //         (check_tail[`SQ_LEN]!=next_head[`SQ_LEN]||((check_tail[`SQ_LEN]==next_head[`SQ_LEN]) && (check_tail>=next_head)))
            //         && ex_out_packet_load.alu_result==store_queue[check_tail[`SQ_LEN-1:0]].store_address 
            //         && ex_out_packet_load.mem_size==store_queue[check_tail[`SQ_LEN-1:0]].mem_size)begin
            //             ex_out_packet_load_new = ex_out_packet_load;
            //             ex_out_packet_load_new.alu_result = store_queue[check_tail[`SQ_LEN-1:0]].value;
            //             load_hit_sq = 1;
            //             break;
            //         end
            //         else if(ex_out_packet_load.alu_result==store_queue[check_tail[`SQ_LEN-1:0]].store_address && ex_out_packet_load.mem_size!=store_queue[check_tail[`SQ_LEN-1:0]].mem_size)begin
            //             sq_memsize_stall = 1;
            //             load_hit_sq = 0;
            //             next_store_queue[check_tail[`SQ_LEN-1:0]].addr_depend = 1;
            //         end
            //     end
            // end

                    //  check_next_circle_flag = (ex_out_packet_load.SQ_tail[`SQ_LEN]==next_head[`SQ_LEN])?1'b0:1'b1;
            if(ex_out_packet_load.rd_mem && !ex_out_packet_load.no_sort_sq)begin
                for(int j=0;j<`SQ_size;j++)begin
                    check_tail = ex_out_packet_load.SQ_tail-j;
                    if(ex_out_packet_load.alu_result==store_queue[check_tail[`SQ_LEN-1:0]].store_address && ex_out_packet_load.mem_size==store_queue[check_tail[`SQ_LEN-1:0]].mem_size)begin
                        ex_out_packet_load_new = ex_out_packet_load;
                        ex_out_packet_load_new.alu_result = store_queue[check_tail[`SQ_LEN-1:0]].value;
                        load_hit_sq = 1;
                        break;
                    end
                    if(!load_hit_sq && ex_out_packet_load.alu_result==store_queue[check_tail[`SQ_LEN-1:0]].store_address && ex_out_packet_load.mem_size!=store_queue[check_tail[`SQ_LEN-1:0]].mem_size)begin
                        sq_memsize_stall_tmp = 1;
                        load_hit_sq = 0;
                        next_store_queue[check_tail[`SQ_LEN-1:0]].addr_depend = 1;
                    end
                    if(check_tail==next_head)
                        break;
                end
            end

            // empty_tmp = 1;
            // for(int i=0;i<`SQ_size;i=i+1)begin
            //     empty_tmp= empty_tmp & (next_store_queue[i].valid==0);
            // end
        end


        always_ff@(posedge clock)begin
            if(reset || halt_flag   )begin
                store_queue <= `SD 0;
                head <= `SD 0;
                tail <= `SD {`SQ_LEN+1{1'b1}};
                sq_available_num <= `SD `SQ_size;
                sq_memsize_stall <= `SD 0;
                load_SQ_tail_to_is_valid <= `SD  0;
                load_SQ_tail_to_rs_valid <= `SD 0;
                // sq_empty <= `SD 1;
            end
            else begin
                // if(empty) begin
                //     sq_available_num <= `SD `SQ_size;
                //     head <= `SD 0;
                //     tail <= `SD {`SQ_LEN+1{1'b1}};
                //     sq_memsize_stall_tmp <= `SD 0;
                //     load_SQ_tail_to_is_valid <= `SD load_SQ_tail_to_is_valid_tmp;
                //     load_SQ_tail_to_rs_valid <= `SD load_SQ_tail_to_rs_valid_tmp;
                // end
                // else begin
                    sq_available_num <= `SD `SQ_size - (next_tail - next_head + 1) ;
                    head <= `SD next_head;
                    tail <= `SD next_tail;
                    sq_memsize_stall <= `SD sq_memsize_stall_tmp;
                    load_SQ_tail_to_is_valid <= `SD load_SQ_tail_to_is_valid_tmp;
                    load_SQ_tail_to_rs_valid <= `SD load_SQ_tail_to_rs_valid_tmp;
                // end
                store_queue <= `SD next_store_queue;
                // sq_empty <= `SD empty_tmp;
            end
        end

endmodule