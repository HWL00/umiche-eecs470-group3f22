/////////////////////////////////////////////////////////////////////////
//                                                                     //
//   Modulename :  wb_stage.v                                          //
//                                                                     //
//  Description :   writeback (WB) stage of the pipeline;              //
//                  determine the destination register of the          //
//                  instruction and write the result to the register   //
//                  file (if not to the zero register), also reset the //
//                  NPC in the fetch stage to the correct next PC      //
//                  address.                                           // 
//                                                                     //
//                                                                     //
/////////////////////////////////////////////////////////////////////////

`timescale 1ns/100ps

module CDB(
    input CDB_IN_PACKET [`N_way-1:0] cdb_in_packet,
    output CDB_OUT_PACKET [`N_way-1:0] cdb_out_packet
    );

    always_comb begin
      cdb_out_packet = 0;
        for(int i=0;i<`N_way;i++)begin
            if(cdb_in_packet[i].valid)
            begin
                cdb_out_packet[i].Rd_Preg_CDB = cdb_in_packet[i].Rd_Preg_From_C;
                cdb_out_packet[i].Rd_Preg_ready_bit_CDB = cdb_in_packet[i].valid;
                cdb_out_packet[i].Preg_result = cdb_in_packet[i].Preg_result;
                cdb_out_packet[i].b_mask_bit_branch = cdb_in_packet[i].b_mask_bit_branch;
                cdb_out_packet[i].ROB_tail = cdb_in_packet[i].ROB_tail;
                // cdb_out_packet[i].valid = cdb_in_packet[i].valid;
            end
            // else begin
            //     cdb_out_packet[i].Rd_Preg_CDB = cdb_in_packet[i].Rd_Preg_From_C;
            //     cdb_out_packet[i].Rd_Preg_ready_bit_CDB = 0;
            //     cdb_out_packet[i].Preg_result = 0;
            //     cdb_out_packet[i].b_mask_bit_branch = cdb_in_packet[i].b_mask_bit_branch;
            //     cdb_out_packet[i].ROB_tail = cdb_in_packet[i].ROB_tail;
            // end
        end
    end
endmodule

module complete_stage(
    input         clock,                // system clock
    input         reset,                // system reset
    input EX_COM_PACKET [`N_way-1:0]  com_packet_in,

    input clean_brat_en,                                  //From BRAT
	  input [$clog2(`b_mask_reg_width)-1:0]clean_brat_num,
    input [`ALU_num-1:0]clean_bit_brat_en,                //From execute
	  input [`ALU_num-1:0][$clog2(`b_mask_reg_width)-1:0]clean_bit_brat_num,
    output CDB_OUT_PACKET [`N_way-1:0] cdb_out_packet
  );
  logic [2:0]mem_size;
    EX_COM_PACKET [`N_way-1:0]complete_packet_out;
    always_comb begin     
      complete_packet_out = 0;                                                                //pass through
      for(int i=0;i<`N_way;i++)begin
        // complete_packet_out[i].alu_result = com_packet_in[i].alu_result;
        complete_packet_out[i].NPC = com_packet_in[i].NPC;
        complete_packet_out[i].rs2_value = com_packet_in[i].rs2_value; //LSQ
        complete_packet_out[i].rd_mem = com_packet_in[i].rd_mem;   //LSQ
        complete_packet_out[i].wr_mem = com_packet_in[i].wr_mem;//LSQ
        complete_packet_out[i].dest_reg_idx = com_packet_in[i].dest_reg_idx; //LSQ
        complete_packet_out[i].halt = com_packet_in[i].halt;
        complete_packet_out[i].illegal = com_packet_in[i].illegal;
        complete_packet_out[i].csr_op = com_packet_in[i].csr_op;
        complete_packet_out[i].valid = com_packet_in[i].valid;
        mem_size = com_packet_in[i].inst.r.funct3;
        complete_packet_out[i].is_b_mask = com_packet_in[i].is_b_mask;
        complete_packet_out[i].b_mask_bit_branch = com_packet_in[i].b_mask_bit_branch;
        complete_packet_out[i].take_branch = com_packet_in[i].take_branch;
        complete_packet_out[i].ROB_tail = com_packet_in[i].ROB_tail;
        complete_packet_out[i].cond_branch = com_packet_in[i].cond_branch;
        complete_packet_out[i].uncond_branch = com_packet_in[i].uncond_branch;

        if(complete_packet_out[i].rd_mem)begin
          if(!mem_size[2])begin
            case(mem_size[1:0])
                2'b0: complete_packet_out[i].alu_result = {{(`XLEN-8){com_packet_in[i].alu_result[7]}}, com_packet_in[i].alu_result[7:0]};
                2'b01: complete_packet_out[i].alu_result = {{(`XLEN-16){com_packet_in[i].alu_result[15]}}, com_packet_in[i].alu_result[15:0]};
                default:complete_packet_out[i].alu_result = com_packet_in[i].alu_result;
            endcase
          end
          else begin
            case(mem_size[1:0])
                2'b0: complete_packet_out[i].alu_result = {{(`XLEN-8){1'b0}}, com_packet_in[i].alu_result[7:0]};
                2'b01: complete_packet_out[i].alu_result = {{(`XLEN-16){1'b0}}, com_packet_in[i].alu_result[15:0]};
                default:complete_packet_out[i].alu_result = com_packet_in[i].alu_result;
            endcase
          end
        end
        else begin
          complete_packet_out[i].alu_result = com_packet_in[i].alu_result;
        end
      end

	// always_comb begin
      for(int j=0;j<`ALU_num;j++)begin
        for(int i=0;i<`N_way;i++)begin
          if(clean_bit_brat_en[j])
            complete_packet_out[i].is_b_mask[clean_bit_brat_num[j]] = 0;
        end
      end
      for(int i=0;i<`N_way;i++)begin
        if(clean_brat_en && com_packet_in[i].is_b_mask[clean_brat_num]==1 && !com_packet_in[i].uncond_branch && !com_packet_in[i].cond_branch)
            complete_packet_out[i] = 0;
          // complete_packet_out[i].valid = 0; //is_ex_alu_packet_in[i].valid;
      end
	  end

    CDB_IN_PACKET [`N_way-1:0] cdb_in_packet;
    
    always_comb begin
      cdb_in_packet = 0;
      for(int i=0;i<`N_way;i++)begin
        begin
          if(complete_packet_out[i].valid)begin
            cdb_in_packet[i].Rd_Preg_From_C = complete_packet_out[i].dest_reg_idx;
            cdb_in_packet[i].Preg_result = complete_packet_out[i].alu_result;
            cdb_in_packet[i].b_mask_bit_branch = complete_packet_out[i].b_mask_bit_branch;
            cdb_in_packet[i].ROB_tail = complete_packet_out[i].ROB_tail;
            cdb_in_packet[i].valid = complete_packet_out[i].valid;
          end
        end
      end
    end
    CDB cdb_inst(.cdb_in_packet(cdb_in_packet),.cdb_out_packet(cdb_out_packet));

endmodule // module wb_stage

