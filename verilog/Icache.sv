module ICache(
input clock,
input reset,

////////////from Icache///////////////
// input [`XLEN-1:0] current_PC,  //from fetch
input IF_ID_PACKET[`N_way-1:0] if_packet2Icache,
//////////from MSHR///////////////

input [2*`XLEN-1:0] block_data_mshr_in,
input [`XLEN-1:0]  block_addr_mshr_in,
input mshr_out_valid,


output logic [`N_way-1:0] Icache_hit,   // load inst hit in the i cache
output logic  [`N_way-1:0]Icache_miss,  // load inst miss in the i cache
output logic [`N_way-1:0][`XLEN-1:0] icache2fetch_inst,

output logic [`XLEN-1:0] miss_PC, //to mshr
output I_CACHE_BLOCK [`CACHE_Assoc-1:0][`Cache_depth-1:0] i_cache //for print
);
logic[`Cache_Index-1:0] wr_inst_index;
logic[`block_offset_bit-1:0] wr_inst_block_offset;
logic[`XLEN-`lsb_Cache_tag-1:0] wr_inst_tag;
logic[$clog2(`CACHE_Assoc)-1:0] wr_lru_num;
logic [$clog2(`CACHE_Assoc)-1:0] wr_assoc_num;

logic[`N_way-1:0][`Cache_Index-1:0] PC_index;
logic[`N_way-1:0][`block_offset_bit-1:0] PC_block_offset;
// logic[`CACHE_Assoc-1:0] ld_assoc_offset;
logic[`N_way-1:0][`XLEN-`lsb_Cache_tag-1:0] PC_tag;

I_CACHE_BLOCK [`CACHE_Assoc-1:0][`Cache_depth-1:0] nx_i_cache;

// assign?

// logic[`N_way-1:0][`XLEN-1:0] pre_pc;
logic [`N_way-1:0][$clog2(`CACHE_Assoc)-1:0] hit_assoc_num;
logic[`N_way-1:0][$clog2(`CACHE_Assoc)-1:0] hit_lru_num;
logic miss_flag;
logic mshr_out_hit;
// logic [`N_way-1:0] pre_Icache_miss;  // load inst miss in the i cache
always_comb begin
    // pre_pc = 0;
    
    hit_lru_num = 0;
    hit_assoc_num = 0;
    wr_assoc_num = 0;
    wr_lru_num = 0;
    Icache_hit = 0;
    Icache_miss =0;
    // pre_Icache_miss = 0;

    icache2fetch_inst = 0;
    miss_PC = 0;
    
    nx_i_cache = i_cache;

    wr_inst_tag = 0;
    wr_inst_index = 0;
    wr_inst_block_offset = 0;
    miss_flag = 0;
    PC_index = 0;
    PC_block_offset = 0;
    PC_tag = 0;

    {wr_inst_tag,wr_inst_index,wr_inst_block_offset} = block_addr_mshr_in;
    
    // for(int i=0;i<`N_way;i++)begin
    //     if(i==0)begin
    //         pre_pc[i]=pre_pc[i-1]+4;
    //     end
    //     {PC_tag[i],PC_index[i],PC_block_offset[i]}=pre_pc[i];
    // end
    mshr_out_hit = 0;
    /////////////write////////////////
    if(mshr_out_valid)begin
        for(int i=0;i<`CACHE_Assoc;i++)begin
            if(nx_i_cache[i][wr_inst_index].tag==wr_inst_tag && nx_i_cache[i][wr_inst_index].block_valid )begin //
                wr_assoc_num=i;
                wr_lru_num = nx_i_cache[i][wr_inst_index].LRU_num;
                nx_i_cache[i][wr_inst_index].tag = wr_inst_tag;
                nx_i_cache[i][wr_inst_index].block_data = block_data_mshr_in;
                nx_i_cache[i][wr_inst_index].LRU_num = 'd0;
                nx_i_cache[i][wr_inst_index].block_valid = 1'b1;
                mshr_out_hit = 1'b1;
            end
        end
    end

    for(int i=0;i<`CACHE_Assoc;i++)begin
        if(!mshr_out_hit)begin
            if(nx_i_cache[i][wr_inst_index].LRU_num=={$clog2(`CACHE_Assoc){1'b1}} && mshr_out_valid)begin
                wr_assoc_num=i;
                wr_lru_num = nx_i_cache[i][wr_inst_index].LRU_num;
                nx_i_cache[i][wr_inst_index].tag = wr_inst_tag;
                nx_i_cache[i][wr_inst_index].block_data = block_data_mshr_in;
                nx_i_cache[i][wr_inst_index].LRU_num = 'd0;
                nx_i_cache[i][wr_inst_index].block_valid = 1'b1;
            end
        end
    end



    for(int i=0;i<`CACHE_Assoc;i++)begin
        if(i!=wr_assoc_num  && nx_i_cache[i][wr_inst_index].LRU_num<wr_lru_num && mshr_out_valid)begin
            nx_i_cache[i][wr_inst_index].LRU_num = nx_i_cache[i][wr_inst_index].LRU_num+1;
        end
        else begin
            nx_i_cache[i][wr_inst_index].LRU_num = nx_i_cache[i][wr_inst_index].LRU_num;
        end
    end

    for(int i=0;i<`N_way;i++)begin
        {PC_tag[i],PC_index[i],PC_block_offset[i]}= if_packet2Icache[i].PC;
    end

    /////////////////// hit or miss//////////////////////////////
    for(int j=0;j<`N_way;j++)begin
        // if() begin
        if(if_packet2Icache[j].valid)begin
            for(int i=0;i<`CACHE_Assoc;i++)begin
                // begin
                    if(nx_i_cache[i][PC_index[j]].tag==PC_tag[j] && nx_i_cache[i][PC_index[j]].block_valid )begin //
                                hit_assoc_num[j] = i;
                                hit_lru_num[j] = nx_i_cache[i][PC_index[j]].LRU_num;
                                Icache_hit[j] = 1'b1;
                                Icache_miss[j] = 1'b0;
                                nx_i_cache[i][PC_index[j]].LRU_num = 'd0;
                                icache2fetch_inst[j] =  if_packet2Icache[j].PC[2] ? nx_i_cache[i][PC_index[j]].block_data[2*`XLEN-1:`XLEN]:nx_i_cache[i][PC_index[j]].block_data[`XLEN-1:0];
                        end
                    else if(!Icache_hit[j])begin ///writing to MSHR
                        Icache_hit[j] =1'b0;
                        Icache_miss[j] =1'b1;
                end
            end
            for(int i=0;i<`CACHE_Assoc;i++)begin
                if(i!=hit_assoc_num[j]  && nx_i_cache[i][PC_index[j]].LRU_num<hit_lru_num[j] && Icache_hit[j])begin
                    nx_i_cache[i][PC_index[j]].LRU_num = nx_i_cache[i][PC_index[j]].LRU_num+1;
                end
                else begin
                    nx_i_cache[i][PC_index[j]].LRU_num = nx_i_cache[i][PC_index[j]].LRU_num;
                end
            end
        end

    end
    for(int j=0;j<`N_way;j++)begin
        if(Icache_miss[j])begin
            miss_PC = if_packet2Icache[j].PC;
            break;
        end
    end


    // Icache_miss = |pre_Icache_miss;

    // for(int j=0;j<`N_way;j++)begin
    //     for(int i=0;i<`CACHE_Assoc;i++)begin
    //         if(i!=hit_assoc_num[j]  && nx_i_cache[i][PC_index[j]].LRU_num<hit_lru_num[j] && Icache_hit[j])begin
    //             nx_i_cache[i][PC_index[j]].LRU_num = nx_i_cache[i][PC_index[j]].LRU_num+1;
    //         end
    //         else begin
    //             nx_i_cache[i][PC_index[j]].LRU_num = nx_i_cache[i][PC_index[j]].LRU_num;
    //         end
    //     end
    // end


end


/////////////////////////sequential logic////////////////////////////////
always_ff @(posedge clock)begin
    if(reset)begin
        for(int i=0;i<`CACHE_Assoc;i++)begin
            for(int j=0;j<`Cache_depth;j++)begin
                i_cache[i][j].block_valid <=`SD 1'b0;
                i_cache[i][j].LRU_num <=`SD i;
                i_cache[i][j].block_data <=`SD 'd0;
                i_cache[i][j].tag <=`SD 'd0;
            end
        end
    end
    else begin
        i_cache<=`SD nx_i_cache;
    end
end

endmodule