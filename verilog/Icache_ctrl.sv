module ICache_ctrl(
input clock,
input reset,

////////////from Icache///////////////
input  [`N_way-1:0]Icache_miss,  // load inst miss in the d cache

input[`XLEN-1:0] miss_PC, //from I cache
///////////from mem////////////////
input [3:0] mem2proc_response,// 0 = can't accept, other=tag of transaction
input [63:0] mem2proc_data,    // data resulting from a load
input [3:0] mem2proc_tag,     // 0 = no value, other=tag of transaction
//////////from arbiter////////////
input [`I_MSHR_Depth-1:0] gnt_bus,
// branch clean
input   clean_brat_en,              ///  clean_brat_en is 1, delete everything in the pipeline which has that b_mask_bit
/////////////output//////////////
//--------------------output for memory----------------------------------------//
output  logic [`XLEN-1:0] proc2mem_addr_out,    // address for current command
// output  logic [63:0] proc2mem_data_out,    // address for current command
output  BUS_COMMAND   proc2mem_command_out,
//--------------------output for I-cache----------------------------------------//
output logic [`XLEN-1:0]  block_addr_mshr_out,
output logic [2*`XLEN-1:0] block_data_mshr_out,      
output logic mshr_out_valid,   
//--------------------output for arbiter--------------------------------------//
output  logic [`I_MSHR_Depth-1:0] request_bus,                            //output to arbiter 


///////for debug/////////////////////////////
output I_MSHR_ENTRY[`I_MSHR_Depth-1:0] mshr
);
I_MSHR_ENTRY [`I_MSHR_Depth-1:0] nx_mshr;
logic [`I_MSHR_Depth-1:0][`XLEN-1:0] pre_proc2mem_addr_out;    // address for current command
BUS_COMMAND [`I_MSHR_Depth-1:0]   pre_proc2mem_command_out;

logic [`I_MSHR_LEN-1:0]request_head,complete_head,tail,next_request_head,next_complete_head,next_tail;
logic [`XLEN-1:0] pre_miss_PC;
logic [`STRIDE-1:0] miss_PC_hit;

logic [`XLEN-1:0]  block_addr_mshr_out_tmp;
logic [2*`XLEN-1:0] block_data_mshr_out_tmp;
logic mshr_out_valid_tmp;
// logic request_poin

always_ff @(posedge clock)begin
    if(reset)begin
        mshr<= `SD 'd0;
        complete_head <= `SD 'd0;
        request_head <= `SD 'd0;
        tail <= `SD 0;
        // block_addr_mshr_out <= `SD 0;
        // block_data_mshr_out <= `SD 0;          
        // mshr_out_valid <= `SD 0;
    end
    else begin
        mshr<= `SD nx_mshr;
        complete_head <= `SD next_complete_head;
        request_head <= `SD next_request_head;
        tail <= `SD next_tail;
        // block_addr_mshr_out <= `SD block_addr_mshr_out_tmp;
        // block_data_mshr_out <= `SD block_data_mshr_out_tmp;          
        // mshr_out_valid <= `SD mshr_out_valid_tmp;
    end
end

always_comb begin
    next_complete_head = complete_head;
    next_request_head = request_head;
    next_tail = tail;
    pre_proc2mem_addr_out = 0;    // address for current command
    pre_proc2mem_command_out = 0;
    // mshr_out_valid=0;
    proc2mem_addr_out = 0;
    proc2mem_command_out = 0;

    request_bus = 0;
    nx_mshr = mshr;
    miss_PC_hit=0;
    pre_miss_PC=0;
    mshr_out_valid_tmp=0;
    // block_addr_mshr_out_tmp = 0;
    // block_data_mshr_out_tmp = 0;
    block_addr_mshr_out = 0;
    block_data_mshr_out = 0;
    mshr_out_valid = 0;
    // if(clean_brat_en)begin
    //     nx_mshr = 0;
    //     next_complete_head = 0;
    //     next_request_head = 0;
    //     next_tail = 0;
    // end

     /////////////output///////////////////////////

             /////////////output for I cache///////////////////////////
    if(nx_mshr[next_complete_head].MSHR_state==COMPLETE)begin//change to last mshr_state. stall ld of Issue buffer issue
        block_addr_mshr_out = nx_mshr[next_complete_head].MSHR_addr;
        block_data_mshr_out = nx_mshr[next_complete_head].MSHR_data;          
        mshr_out_valid = 1;
        // nx_mshr[next_complete_head]='d0;
        // nx_mshr[next_complete_head].MSHR_state=I_IDLE;
        nx_mshr[next_complete_head]='d0;
        next_complete_head = next_complete_head + 1;
    end
    //request////////////////////////////////////////////////////////////////////
    if(nx_mshr[next_request_head].MSHR_state==MISS_WAITTING_BUS )begin                     
        request_bus[next_request_head]=1'b1;
        pre_proc2mem_addr_out[next_request_head]= {nx_mshr[next_request_head].MSHR_addr[`XLEN-1:3],3'd0};
        pre_proc2mem_command_out[next_request_head]= BUS_LOAD;
    end


    for(int i=0;i<`I_MSHR_Depth;i++)begin
        if(gnt_bus[i]) begin
            proc2mem_command_out = pre_proc2mem_command_out[i];
            proc2mem_addr_out = pre_proc2mem_addr_out[i];
            
        end
    end

    ///////////FSM////////////////////////////////////////////////////////
    for(int i=0; i<`I_MSHR_Depth;i++)begin
        case(nx_mshr[i].MSHR_state)
            MISS_WAITTING_BUS:      begin                     
                                            if(gnt_bus[i] && mem2proc_response!=0)begin
                                                nx_mshr[i].MSHR_state=MISS_IN_USE;
                                                nx_mshr[i].mem_tag=mem2proc_response;
                                                next_request_head = next_request_head + 1;
                                            end 
            end
            MISS_IN_USE:            begin   
                                            if(nx_mshr[i].mem_tag == mem2proc_tag && mem2proc_tag !=0)begin
                                                nx_mshr[i].MSHR_state=COMPLETE;
                                                nx_mshr[i].mem_tag='d0;
                                                nx_mshr[i].MSHR_data=mem2proc_data;
                                            end
                                            else begin
                                                nx_mshr[i].MSHR_state=MISS_IN_USE;
                                                nx_mshr[i].MSHR_data='d0;
                                            end
            end             
            // COMPLETE:               begin
            //                                 nx_mshr[next_complete_head]='d0;
            //                                 nx_mshr[next_complete_head].MSHR_state=I_IDLE;
            //                                 next_complete_head = next_complete_head + 1;
            // end
            default:                begin
                                            nx_mshr[i].MSHR_state= nx_mshr[i].MSHR_state;
                                            nx_mshr[i].mem_tag = nx_mshr[i].mem_tag;
            end                             
        endcase
    end
    if(|Icache_miss)begin
        for(int i=0; i<`I_MSHR_Depth;i++)begin
            for(int j=0;j<`STRIDE;j++)begin
                pre_miss_PC = {miss_PC[`XLEN-1:3]+j,3'b0};
                if(pre_miss_PC==nx_mshr[i].MSHR_addr && nx_mshr[i].MSHR_state!=I_IDLE)begin
                    miss_PC_hit[j]=1'b1;
                end
            end
        end
    end


    
    if(|Icache_miss)begin
        for(int i=0;i<`STRIDE;i++)begin
            if(!miss_PC_hit[i])begin
                if(nx_mshr[next_tail].MSHR_state!=I_IDLE)begin
                    break;
                end
                else begin
                    pre_miss_PC = {miss_PC[`XLEN-1:3]+i,3'b0};
                    nx_mshr[next_tail].MSHR_addr=pre_miss_PC;
                    nx_mshr[next_tail].MSHR_state = MISS_WAITTING_BUS;
                    next_tail = next_tail + 1;
                end
            end
        end
    end

    //     /////////////output for I cache///////////////////////////
    // if(nx_mshr[next_complete_head].MSHR_state==COMPLETE)begin//change to last mshr_state. stall ld of Issue buffer issue
    //     block_addr_mshr_out_tmp = nx_mshr[next_complete_head].MSHR_addr;
    //     block_data_mshr_out_tmp = nx_mshr[next_complete_head].MSHR_data;          
    //     mshr_out_valid_tmp = 1;
    //     // nx_mshr[next_complete_head]='d0;
    //     // nx_mshr[next_complete_head].MSHR_state=I_IDLE;
    //     // next_complete_head = next_complete_head + 1;
    // end
   
end//end comb

endmodule