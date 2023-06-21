/////////////////////////////////////////////////////////////////////////
//                                                                     //
//   Modulename :  regfile.v                                           //
//                                                                     //
//  Description :  This module creates the Regfile used by the ID and  // 
//                 WB Stages of the Pipeline.                          //
//                                                                     //
/////////////////////////////////////////////////////////////////////////

`ifndef __REGFILE_V__
`define __REGFILE_V__

`timescale 1ns/100ps

module physical_regfile(
        input clock,
        input reset,
        input  [`N_way-1:0][`Preg_LEN-1:0] rd_rs1_idx, rd_rs2_idx,
        input  [`N_way-1:0][`Preg_LEN-1:0]wr_idx,    // write index
        input  [`N_way-1:0][`XLEN-1:0] wr_data,            // write data
        input  [`N_way-1:0]wr_en,        //from complete 

        output logic [`N_way-1:0][`XLEN-1:0] rd_rs1_out,rd_rs2_out,    // read data
        output logic [`Preg_num-1:0] [`XLEN-1:0] registers    // 32, 32-bit Registers
      );
  

  always_comb begin
    for(int i= 0;i<`N_way;i++)begin
      rd_rs1_out[i] = registers[rd_rs1_idx[i]];
      if (rd_rs1_idx[i] == `ZERO_REG)
        rd_rs1_out[i] = 0;
      else if (|wr_en)begin
        for(int j=0;j<`N_way;j++)begin
          if(wr_idx[j] == rd_rs1_idx[i])
            rd_rs1_out[i] = wr_data[j];  // internal forwarding
        end
      end
      rd_rs2_out[i] = registers[rd_rs2_idx[i]];
      if (rd_rs2_idx[i] == `ZERO_REG)
        rd_rs2_out[i] = 0;
      else if (|wr_en)
        for(int j=0;j<`N_way;j++)begin
          if(wr_idx[j] == rd_rs2_idx[i])
            rd_rs2_out[i] = wr_data[j];  // internal forwarding
        end
     end
  end

  always_ff @( posedge clock ) begin
    if(reset) begin
        for(int i= 0;i<`Preg_num;i++)begin
          registers[i] <= `SD 0;
        end
      end
    else begin
      for(int i= 0;i<`N_way;i++)begin
        if(wr_en[i])begin
          registers[wr_idx[i]] <= `SD wr_data[i];
        end
      end
    end
  end
endmodule // regfile
`endif //__REGFILE_V__
