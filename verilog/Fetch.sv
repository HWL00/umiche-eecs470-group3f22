`timescale 1ns/100ps
module Fetch(
////////////input/////////////////////////////////////
    input         clock,                  // system clock
	input         reset,                  // system reset
//////////from ex/////////////////
	input[`ALU_num-1:0] misprediction_ex,
    input[`XLEN-1:0]   target_pc_ex,
///////from bp////////
    input[`N_way-1:0]         taken_bp,              // from bp 1 for taken, 0 for not taken
	input[`N_way-1:0]  [`XLEN-1:0] target_pc,        // target pc if misprediction_ntaken
//////////from BRAT and Dispatcher///////////////
    input brat_full_stall,
    input [`XLEN-1:0] brat_full_back_pc,
    input flag_back_pc,
    input [`XLEN-1:0] back2fetch_pc,  
///////////from I$ or memory fake fetch////////////////////////////////
	input [`N_way-1:0] [`XLEN-1:0] Imem2proc_data,          // Data coming back from instruction-memory
    input [`N_way-1:0]  Icache_miss,
    input [`XLEN-1:0] miss_PC,
/////////////////////output////////////////////////////////
	output logic [`XLEN-1:0] proc2Imem_addr,    // Address sent to Instruction memory
	output IF_ID_PACKET[`N_way-1:0] if_packet2Icache,         // Output data packet from IF going to ID, see sys_defs for signal information 
    output IF_ID_PACKET[`N_way-1:0] if_packet_out

);
    logic[`XLEN-1:0] PC_reg;             // PC we are currently fetching
	logic[`XLEN-1:0] next_PC;
	logic           PC_enable;
    logic [`N_way-1:0] PC_enable_Nbit;
    logic[`XLEN-1:0] pre_pc_reg;
    logic bp_flag;
//////////////////////////comb_logic//////////////////////////////////////////
    always_comb begin
        next_PC = 0;
        if_packet_out=0;
        if_packet2Icache=0;
        pre_pc_reg=|misprediction_ex? target_pc_ex :brat_full_stall? brat_full_back_pc :  flag_back_pc? back2fetch_pc: PC_reg;  //if DP just can dispatch 2 inst, should fetch 3rd inst PC in this stage\
    //-----------------------------addr to mem[update in future]--------------------------------//
        proc2Imem_addr=pre_pc_reg;
    /////////////////////for inst/////////////////////////////////////////////////////////////////////////	

    /////////////// inst, PC and NPC/////////////////////////////////////////
        
        for(int i=0;i<`N_way;i=i+1)begin
            if(i==0)begin                            // PC of first inst is equal to PC_reg, else is last_inst_PC +4
                if_packet2Icache[i].PC  = pre_pc_reg;
                if_packet2Icache[i].NPC = if_packet2Icache[i].PC+4;
                // if_packet2Icache[i].inst=Imem2proc_data[i];
            end
        
            else begin
                if_packet2Icache[i].PC = if_packet2Icache[i-1].NPC;
                if_packet2Icache[i].NPC=if_packet2Icache[i].PC+4;
                // if_packet2Icache[i].inst=Imem2proc_data[i];
            end    
        end
        // next PC is target_pc if there is a taken branch or
        // the next sequential PC (PC+4) if no branch
        // (halting is handled with the enable PC_enable;
    /////////// next PC value for next cycle////////////////////////////////
        bp_flag='d0;
        for(int i=0;i<`N_way;i=i+1 )begin
            if_packet2Icache[i].valid='d1;
            if_packet2Icache[i].BP_predicted_taken='d0;
            if_packet2Icache[i].BP_predicted_target_PC='d0;
            if(bp_flag )begin
                if_packet2Icache[i].valid=1'b0;
            end
            else if(taken_bp[i] && !bp_flag)begin
                bp_flag = 1;
                if_packet2Icache[i].BP_predicted_taken=taken_bp[i];
                if_packet2Icache[i].BP_predicted_target_PC=target_pc[i];
                next_PC=target_pc[i];
                // next_PC=target_pc[i]; 
            end
            else if(if_packet2Icache[i].valid)begin
                next_PC=if_packet2Icache[i].NPC;  
            end
        end

        // if(flag_back_pc)begin
        //      next_PC=back2fetch_pc;
        // end
        for(int i=0;i<`N_way;i=i+1)begin
            if(!Icache_miss[i])begin
           
                if_packet_out[i]=if_packet2Icache[i];
                if_packet_out[i].inst=Imem2proc_data[i];
            end
            else if(Icache_miss[i])begin
                next_PC=miss_PC;
                break;

            end


        end


          for(int i=0;i<`N_way;i++)begin
        // The take-branch signal must override stalling (otherwise it may be lost)
            PC_enable_Nbit[i] = if_packet_out[i].valid | misprediction_ex[i] ;  // if brat full, stall pc enable
        end
        PC_enable = (|PC_enable_Nbit) | flag_back_pc ;


    end//comb_logic end

    always_ff @(posedge clock) begin
        if(reset)
            PC_reg <= `SD 0;       // initial PC value is 0
        else if(PC_enable )
            PC_reg <= `SD next_PC; // transition to next PC
        // else if(brat_full_stall)
        //     PC_reg <= `SD next_PC;
        else
            PC_reg <= `SD PC_reg;
    end  // always

endmodule
	
