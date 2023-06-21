 
****************************************
Report : resources
Design : pipeline
Version: T-2022.03-SP3
Date   : Mon Dec  5 23:24:28 2022
****************************************

Resource Sharing Report for design pipeline in file
        /home/yiroug/Desktop/pipeline/verilog/pipeline.sv

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r162     | DW01_inc     | width=2    |               | add_346_I2           |
| r164     | DW01_inc     | width=2    |               | add_348_I2           |
| r166     | DW01_inc     | width=3    |               | add_346_I3           |
| r168     | DW01_inc     | width=3    |               | add_348_I3           |
| r170     | DW01_inc     | width=4    |               | add_346_I4           |
| r172     | DW01_inc     | width=4    |               | add_348_I4           |
===============================================================================


No implementations to report
 
****************************************
Design : physical_regfile
****************************************
Resource Sharing Report for design physical_regfile in file
        /home/yiroug/Desktop/pipeline/verilog/physical_regfile.sv

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r579     | DW01_cmp6    | width=6    |               | eq_35                |
| r581     | DW01_cmp6    | width=6    |               | eq_35_I2_I1          |
| r583     | DW01_cmp6    | width=6    |               | eq_35_I3_I1          |
| r585     | DW01_cmp6    | width=6    |               | eq_35_I4_I1          |
| r587     | DW01_cmp6    | width=6    |               | eq_44                |
| r589     | DW01_cmp6    | width=6    |               | eq_44_I2_I1          |
| r591     | DW01_cmp6    | width=6    |               | eq_44_I3_I1          |
| r593     | DW01_cmp6    | width=6    |               | eq_44_I4_I1          |
| r595     | DW01_cmp6    | width=6    |               | eq_35_I2             |
| r597     | DW01_cmp6    | width=6    |               | eq_35_I2_I2          |
| r599     | DW01_cmp6    | width=6    |               | eq_35_I3_I2          |
| r601     | DW01_cmp6    | width=6    |               | eq_35_I4_I2          |
| r603     | DW01_cmp6    | width=6    |               | eq_44_I2             |
| r605     | DW01_cmp6    | width=6    |               | eq_44_I2_I2          |
| r607     | DW01_cmp6    | width=6    |               | eq_44_I3_I2          |
| r609     | DW01_cmp6    | width=6    |               | eq_44_I4_I2          |
| r611     | DW01_cmp6    | width=6    |               | eq_35_I3             |
| r613     | DW01_cmp6    | width=6    |               | eq_35_I2_I3          |
| r615     | DW01_cmp6    | width=6    |               | eq_35_I3_I3          |
| r617     | DW01_cmp6    | width=6    |               | eq_35_I4_I3          |
| r619     | DW01_cmp6    | width=6    |               | eq_44_I3             |
| r621     | DW01_cmp6    | width=6    |               | eq_44_I2_I3          |
| r623     | DW01_cmp6    | width=6    |               | eq_44_I3_I3          |
| r625     | DW01_cmp6    | width=6    |               | eq_44_I4_I3          |
| r627     | DW01_cmp6    | width=6    |               | eq_35_I4             |
| r629     | DW01_cmp6    | width=6    |               | eq_35_I2_I4          |
| r631     | DW01_cmp6    | width=6    |               | eq_35_I3_I4          |
| r633     | DW01_cmp6    | width=6    |               | eq_35_I4_I4          |
| r635     | DW01_cmp6    | width=6    |               | eq_44_I4             |
| r637     | DW01_cmp6    | width=6    |               | eq_44_I2_I4          |
| r639     | DW01_cmp6    | width=6    |               | eq_44_I3_I4          |
| r641     | DW01_cmp6    | width=6    |               | eq_44_I4_I4          |
===============================================================================


No implementations to report

No resource sharing information to report.
 
****************************************
Design : complete_stage
****************************************

No implementations to report

No resource sharing information to report.
 
****************************************
Design : CDB
****************************************

No implementations to report
 
****************************************
Design : ex_stage
****************************************
Resource Sharing Report for design ex_stage in file
        /home/yiroug/Desktop/pipeline/verilog/ex_stage.sv

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r363     | DW01_cmp6    | width=2    |               | eq_476_2 eq_494_2    |
|          |              |            |               | eq_498_2             |
| r365     | DW01_cmp6    | width=2    |               | eq_476_2_I2          |
|          |              |            |               | eq_494_2_I2          |
|          |              |            |               | eq_498_2_I2          |
| r367     | DW01_cmp6    | width=2    |               | eq_476_2_I3          |
|          |              |            |               | eq_494_2_I3          |
|          |              |            |               | eq_498_2_I3          |
| r369     | DW01_cmp6    | width=2    |               | eq_476_2_I4          |
|          |              |            |               | eq_494_2_I4          |
|          |              |            |               | eq_498_2_I4          |
| r384     | DW01_cmp6    | width=32   |               | eq_480               |
| r386     | DW01_cmp6    | width=32   |               | eq_480_I2            |
| r388     | DW01_cmp6    | width=32   |               | eq_480_I3            |
| r390     | DW01_cmp6    | width=32   |               | eq_480_I4            |
| r392     | DW01_inc     | width=2    |               | add_730_I2           |
| r394     | DW01_inc     | width=3    |               | add_730_I3           |
| r396     | DW01_inc     | width=3    |               | add_730_I4           |
| r398     | DW01_inc     | width=3    |               | add_730_I5           |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| eq_480             | DW01_cmp6        | rpl                |                |
| eq_480_I2          | DW01_cmp6        | rpl                |                |
| eq_480_I3          | DW01_cmp6        | rpl                |                |
| eq_480_I4          | DW01_cmp6        | rpl                |                |
===============================================================================

 
****************************************
Design : round_robin_arbiter
****************************************
Resource Sharing Report for design round_robin_arbiter in file
        /home/yiroug/Desktop/pipeline/verilog/ex_stage.sv

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r192     | DW01_cmp2    | width=3    |               | lte_52_I2            |
| r194     | DW01_inc     | width=2    |               | add_55_I2            |
| r196     | DW01_cmp2    | width=3    |               | lte_52_I3            |
| r198     | DW01_inc     | width=3    |               | add_55_I3            |
| r200     | DW01_cmp2    | width=3    |               | lte_52_I4            |
| r202     | DW01_inc     | width=3    |               | add_55_I4            |
| r204     | DW01_cmp2    | width=3    |               | lte_61               |
| r206     | DW01_cmp2    | width=3    |               | lte_64               |
| r208     | DW01_inc     | width=3    |               | add_67               |
| r210     | DW01_cmp2    | width=3    |               | lte_64_I2            |
| r212     | DW01_inc     | width=3    |               | add_67_I2            |
| r214     | DW01_cmp2    | width=3    |               | lte_64_I3            |
| r216     | DW01_inc     | width=3    |               | add_67_I3            |
| r218     | DW01_cmp2    | width=3    |               | lte_64_I4            |
| r327     | DW01_sub     | width=3    |               | sub_1_root_sub_1_root_sub_49_3 |
| r329     | DW01_sub     | width=3    |               | sub_0_root_sub_1_root_sub_49_3 |
===============================================================================


No implementations to report

No resource sharing information to report.
 
****************************************
Design : alu_0
****************************************

Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| add_110            | DW01_add         | rpl                |                |
| sub_111            | DW01_sub         | rpl                |                |
| sll_118            | DW01_ash         | mx2                |                |
===============================================================================


No resource sharing information to report.
 
****************************************
Design : brcond_0
****************************************

Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| r63                | DW01_cmp6        | rpl                |                |
===============================================================================


No resource sharing information to report.
 
****************************************
Design : alu_1
****************************************

Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| add_110            | DW01_add         | rpl                |                |
| sub_111            | DW01_sub         | rpl                |                |
| sll_118            | DW01_ash         | mx2                |                |
===============================================================================


No resource sharing information to report.
 
****************************************
Design : brcond_1
****************************************

Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| r63                | DW01_cmp6        | rpl                |                |
===============================================================================


No resource sharing information to report.
 
****************************************
Design : alu_2
****************************************

Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| add_110            | DW01_add         | rpl                |                |
| sub_111            | DW01_sub         | rpl                |                |
| sll_118            | DW01_ash         | mx2                |                |
===============================================================================


No resource sharing information to report.
 
****************************************
Design : brcond_2
****************************************

Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| r63                | DW01_cmp6        | rpl                |                |
===============================================================================


No resource sharing information to report.
 
****************************************
Design : alu_3
****************************************

Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| add_110            | DW01_add         | rpl                |                |
| sub_111            | DW01_sub         | rpl                |                |
| sll_118            | DW01_ash         | mx2                |                |
===============================================================================


No resource sharing information to report.
 
****************************************
Design : brcond_3
****************************************

Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| r63                | DW01_cmp6        | rpl                |                |
===============================================================================


No resource sharing information to report.
 
****************************************
Design : alu_4
****************************************

Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| add_110            | DW01_add         | rpl                |                |
| sub_111            | DW01_sub         | rpl                |                |
| sll_118            | DW01_ash         | mx2                |                |
===============================================================================


No resource sharing information to report.
 
****************************************
Design : brcond_4
****************************************

Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| r63                | DW01_cmp6        | rpl                |                |
===============================================================================

 
****************************************
Design : alu_5
****************************************
Resource Sharing Report for design alu_0 in file
        /home/yiroug/Desktop/pipeline/verilog/ex_stage.sv

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r73      | DW01_add     | width=32   |               | add_110              |
| r75      | DW01_sub     | width=32   |               | sub_111              |
| r77      | DW01_cmp2    | width=32   |               | lt_113               |
| r79      | DW01_cmp2    | width=32   |               | lt_114               |
| r81      | DW_rash      | A_width=32 |               | srl_117              |
|          |              | SH_width=5 |               |                      |
| r83      | DW01_ash     | A_width=32 |               | sll_118              |
|          |              | SH_width=5 |               |                      |
| r85      | DW_rash      | A_width=32 |               | sra_119              |
|          |              | SH_width=5 |               |                      |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| add_110            | DW01_add         | rpl                |                |
| sub_111            | DW01_sub         | rpl                |                |
| sll_118            | DW01_ash         | mx2                |                |
===============================================================================

 
****************************************
Design : brcond_5
****************************************
Resource Sharing Report for design brcond_0 in file
        /home/yiroug/Desktop/pipeline/verilog/ex_stage.sv

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r63      | DW01_cmp6    | width=32   |               | eq_160 gte_163       |
|          |              |            |               | lt_162 ne_161        |
| r64      | DW01_cmp2    | width=32   |               | gte_165 lt_164       |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| r63                | DW01_cmp6        | rpl                |                |
===============================================================================


No resource sharing information to report.
 
****************************************
Design : mult_0
****************************************

No implementations to report
 
****************************************
Design : mult_stage_0
****************************************
Resource Sharing Report for design mult_stage_0 in file
        /home/yiroug/Desktop/pipeline/verilog/mult.sv

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r102     | DW02_mult    | A_width=16 |               | mult_98              |
|          |              | B_width=64 |               |                      |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| mult_98            | DW02_mult        | csa                |                |
| add_96             | DW01_add         | rpl                |                |
===============================================================================

 
****************************************
Design : mult_stage_0_DW02_mult_0
****************************************

Resource Sharing Report for design DW02_mult_A_width16_B_width64

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r58      | DW01_add     | width=78   |               | FS_1                 |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| FS_1               | DW01_add         | cla                | cla            |
===============================================================================

 
****************************************
Design : mult_stage_1
****************************************
Resource Sharing Report for design mult_stage_0 in file
        /home/yiroug/Desktop/pipeline/verilog/mult.sv

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r102     | DW02_mult    | A_width=16 |               | mult_98              |
|          |              | B_width=64 |               |                      |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| mult_98            | DW02_mult        | csa                |                |
| add_96             | DW01_add         | rpl                |                |
===============================================================================

 
****************************************
Design : mult_stage_1_DW02_mult_0_DW02_mult_1
****************************************

Resource Sharing Report for design DW02_mult_A_width16_B_width64

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r58      | DW01_add     | width=78   |               | FS_1                 |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| FS_1               | DW01_add         | cla                | cla            |
===============================================================================

 
****************************************
Design : mult_stage_2
****************************************
Resource Sharing Report for design mult_stage_0 in file
        /home/yiroug/Desktop/pipeline/verilog/mult.sv

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r102     | DW02_mult    | A_width=16 |               | mult_98              |
|          |              | B_width=64 |               |                      |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| mult_98            | DW02_mult        | csa                |                |
| add_96             | DW01_add         | rpl                |                |
===============================================================================

 
****************************************
Design : mult_stage_2_DW02_mult_0_DW02_mult_2
****************************************

Resource Sharing Report for design DW02_mult_A_width16_B_width64

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r58      | DW01_add     | width=78   |               | FS_1                 |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| FS_1               | DW01_add         | cla                | cla            |
===============================================================================

 
****************************************
Design : mult_stage_3
****************************************
Resource Sharing Report for design mult_stage_0 in file
        /home/yiroug/Desktop/pipeline/verilog/mult.sv

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r102     | DW02_mult    | A_width=16 |               | mult_98              |
|          |              | B_width=64 |               |                      |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| mult_98            | DW02_mult        | csa                |                |
| add_96             | DW01_add         | rpl                |                |
===============================================================================

 
****************************************
Design : mult_stage_3_DW02_mult_0_DW02_mult_6
****************************************

Resource Sharing Report for design DW02_mult_A_width16_B_width64

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r58      | DW01_add     | width=78   |               | FS_1                 |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| FS_1               | DW01_add         | cla                | cla            |
===============================================================================


No resource sharing information to report.
 
****************************************
Design : mult_1
****************************************

No implementations to report
 
****************************************
Design : mult_stage_4
****************************************
Resource Sharing Report for design mult_stage_0 in file
        /home/yiroug/Desktop/pipeline/verilog/mult.sv

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r102     | DW02_mult    | A_width=16 |               | mult_98              |
|          |              | B_width=64 |               |                      |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| mult_98            | DW02_mult        | csa                |                |
| add_96             | DW01_add         | rpl                |                |
===============================================================================

 
****************************************
Design : mult_stage_4_DW02_mult_0_DW02_mult_3
****************************************

Resource Sharing Report for design DW02_mult_A_width16_B_width64

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r58      | DW01_add     | width=78   |               | FS_1                 |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| FS_1               | DW01_add         | cla                | cla            |
===============================================================================

 
****************************************
Design : mult_stage_5
****************************************
Resource Sharing Report for design mult_stage_0 in file
        /home/yiroug/Desktop/pipeline/verilog/mult.sv

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r102     | DW02_mult    | A_width=16 |               | mult_98              |
|          |              | B_width=64 |               |                      |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| mult_98            | DW02_mult        | csa                |                |
| add_96             | DW01_add         | rpl                |                |
===============================================================================

 
****************************************
Design : mult_stage_5_DW02_mult_0_DW02_mult_4
****************************************

Resource Sharing Report for design DW02_mult_A_width16_B_width64

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r58      | DW01_add     | width=78   |               | FS_1                 |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| FS_1               | DW01_add         | cla                | cla            |
===============================================================================

 
****************************************
Design : mult_stage_6
****************************************
Resource Sharing Report for design mult_stage_0 in file
        /home/yiroug/Desktop/pipeline/verilog/mult.sv

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r102     | DW02_mult    | A_width=16 |               | mult_98              |
|          |              | B_width=64 |               |                      |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| mult_98            | DW02_mult        | csa                |                |
| add_96             | DW01_add         | rpl                |                |
===============================================================================

 
****************************************
Design : mult_stage_6_DW02_mult_0_DW02_mult_5
****************************************

Resource Sharing Report for design DW02_mult_A_width16_B_width64

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r58      | DW01_add     | width=78   |               | FS_1                 |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| FS_1               | DW01_add         | cla                | cla            |
===============================================================================

 
****************************************
Design : mult_stage_7
****************************************
Resource Sharing Report for design mult_stage_0 in file
        /home/yiroug/Desktop/pipeline/verilog/mult.sv

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r61      | DW01_add     | width=64   |               | add_96               |
| r165     | DW02_mult    | A_width=16 |               | mult_98              |
|          |              | B_width=64 |               |                      |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| mult_98            | DW02_mult        | csa                |                |
| add_96             | DW01_add         | rpl                |                |
===============================================================================

 
****************************************
Design : mult_stage_7_DW02_mult_0_DW02_mult_7
****************************************

Resource Sharing Report for design DW02_mult_A_width16_B_width64

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r58      | DW01_add     | width=78   |               | FS_1                 |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| FS_1               | DW01_add         | cla                | cla            |
===============================================================================


No resource sharing information to report.
 
****************************************
Design : Issue_Stage
****************************************

No implementations to report
 
****************************************
Design : Store_Issue_Buffer
****************************************
Resource Sharing Report for design Store_Issue_Buffer in file
        /home/yiroug/Desktop/pipeline/verilog/Store_Issue_Buffer.sv

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r339     | DW01_dec     | width=3    |               | sub_106_I2           |
| r341     | DW01_inc     | width=3    |               | add_111_I2           |
| r343     | DW01_dec     | width=3    |               | sub_106_I3           |
| r345     | DW01_inc     | width=3    |               | add_111_I3           |
| r347     | DW01_dec     | width=3    |               | sub_106_I4           |
| r349     | DW01_inc     | width=3    |               | add_111_I4           |
| r351     | DW01_dec     | width=3    |               | sub_106_I5           |
| r353     | DW01_inc     | width=3    |               | add_111_I5           |
| r355     | DW01_dec     | width=3    |               | sub_106_I6           |
| r357     | DW01_inc     | width=3    |               | add_111_I6           |
| r359     | DW01_dec     | width=3    |               | sub_106_I7           |
| r361     | DW01_inc     | width=3    |               | add_111_I7           |
| r363     | DW01_dec     | width=3    |               | sub_106_I8           |
| r365     | DW01_inc     | width=3    |               | add_111_I8           |
| r367     | DW01_sub     | width=3    |               | sub_123_aco          |
| r369     | DW01_sub     | width=3    |               | sub_123_I2_aco       |
| r371     | DW01_sub     | width=3    |               | sub_123_I3_aco       |
===============================================================================


No implementations to report
 
****************************************
Design : Load_Issue_Buffer
****************************************
Resource Sharing Report for design Load_Issue_Buffer in file
        /home/yiroug/Desktop/pipeline/verilog/Load_Issue_Buffer.sv

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r494     | DW01_cmp6    | width=4    |               | eq_74                |
| r496     | DW01_cmp6    | width=4    |               | eq_74_I2             |
| r498     | DW01_cmp6    | width=4    |               | eq_74_I3             |
| r500     | DW01_cmp6    | width=4    |               | eq_74_I4             |
| r502     | DW01_cmp6    | width=4    |               | eq_74_I5             |
| r504     | DW01_cmp6    | width=4    |               | eq_74_I6             |
| r506     | DW01_cmp6    | width=4    |               | eq_74_I7             |
| r508     | DW01_cmp6    | width=4    |               | eq_74_I8             |
| r510     | DW01_dec     | width=3    |               | sub_161_I2           |
| r512     | DW01_inc     | width=3    |               | add_166_I2           |
| r514     | DW01_dec     | width=3    |               | sub_161_I3           |
| r516     | DW01_inc     | width=3    |               | add_166_I3           |
| r518     | DW01_dec     | width=3    |               | sub_161_I4           |
| r520     | DW01_inc     | width=3    |               | add_166_I4           |
| r522     | DW01_dec     | width=3    |               | sub_161_I5           |
| r524     | DW01_inc     | width=3    |               | add_166_I5           |
| r526     | DW01_dec     | width=3    |               | sub_161_I6           |
| r528     | DW01_inc     | width=3    |               | add_166_I6           |
| r530     | DW01_dec     | width=3    |               | sub_161_I7           |
| r532     | DW01_inc     | width=3    |               | add_166_I7           |
| r534     | DW01_dec     | width=3    |               | sub_161_I8           |
| r536     | DW01_inc     | width=3    |               | add_166_I8           |
| r538     | DW01_sub     | width=3    |               | sub_179_aco          |
| r540     | DW01_sub     | width=3    |               | sub_179_I2_aco       |
| r542     | DW01_sub     | width=3    |               | sub_179_I3_aco       |
| r544     | DW01_inc     | width=2    |               | add_186_I2           |
| r546     | DW01_inc     | width=3    |               | add_186_I3           |
| r548     | DW01_inc     | width=3    |               | add_186_I4           |
| r550     | DW01_inc     | width=3    |               | add_186_I5           |
| r552     | DW01_inc     | width=3    |               | add_186_I6           |
| r554     | DW01_inc     | width=3    |               | add_186_I7           |
| r556     | DW01_inc     | width=3    |               | add_186_I8           |
===============================================================================


No implementations to report
 
****************************************
Design : MUL_Issue_Buffer
****************************************
Resource Sharing Report for design MUL_Issue_Buffer in file
        /home/yiroug/Desktop/pipeline/verilog/MUL_Issue_Buffer.sv

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r653     | DW01_inc     | width=2    |               | add_69_I2            |
| r655     | DW01_cmp2    | width=2    |               | lt_85                |
| r657     | DW01_cmp2    | width=2    |               | lt_85_I2             |
| r659     | DW01_inc     | width=2    |               | add_86_I2            |
| r661     | DW01_dec     | width=2    |               | sub_87_I2            |
| r663     | DW01_cmp2    | width=2    |               | lt_85_I3             |
| r665     | DW01_inc     | width=2    |               | add_86_I3            |
| r667     | DW01_dec     | width=2    |               | sub_87_I3            |
| r669     | DW01_cmp2    | width=2    |               | lt_85_I4             |
| r671     | DW01_inc     | width=2    |               | add_86_I4            |
| r673     | DW01_dec     | width=2    |               | sub_87_I4            |
| r675     | DW01_cmp2    | width=2    |               | lt_85_I5             |
| r677     | DW01_inc     | width=2    |               | add_86_I5            |
| r679     | DW01_dec     | width=2    |               | sub_87_I5            |
| r681     | DW01_cmp2    | width=2    |               | lt_85_I6             |
| r683     | DW01_inc     | width=2    |               | add_86_I6            |
| r685     | DW01_dec     | width=2    |               | sub_87_I6            |
| r687     | DW01_cmp2    | width=2    |               | lt_85_I7             |
| r689     | DW01_inc     | width=2    |               | add_86_I7            |
| r691     | DW01_dec     | width=2    |               | sub_87_I7            |
| r693     | DW01_cmp2    | width=2    |               | lt_85_I8             |
| r695     | DW01_inc     | width=2    |               | add_86_I8            |
| r697     | DW01_dec     | width=2    |               | sub_87_I8            |
| r699     | DW01_cmp2    | width=2    |               | lt_97                |
| r701     | DW01_cmp2    | width=2    |               | lt_97_I2             |
| r703     | DW01_dec     | width=3    |               | sub_129_I2           |
| r705     | DW01_inc     | width=3    |               | add_134_I2           |
| r707     | DW01_dec     | width=3    |               | sub_129_I3           |
| r709     | DW01_inc     | width=3    |               | add_134_I3           |
| r711     | DW01_dec     | width=3    |               | sub_129_I4           |
| r713     | DW01_inc     | width=3    |               | add_134_I4           |
| r715     | DW01_dec     | width=3    |               | sub_129_I5           |
| r717     | DW01_inc     | width=3    |               | add_134_I5           |
| r719     | DW01_dec     | width=3    |               | sub_129_I6           |
| r721     | DW01_inc     | width=3    |               | add_134_I6           |
| r723     | DW01_dec     | width=3    |               | sub_129_I7           |
| r725     | DW01_inc     | width=3    |               | add_134_I7           |
| r727     | DW01_dec     | width=3    |               | sub_129_I8           |
| r729     | DW01_inc     | width=3    |               | add_134_I8           |
| r731     | DW01_sub     | width=3    |               | sub_146_aco          |
| r733     | DW01_sub     | width=3    |               | sub_146_I2_aco       |
| r735     | DW01_sub     | width=3    |               | sub_146_I3_aco       |
| r737     | DW01_inc     | width=2    |               | add_153_I2           |
| r739     | DW01_inc     | width=3    |               | add_153_I3           |
| r741     | DW01_inc     | width=3    |               | add_153_I4           |
| r743     | DW01_inc     | width=3    |               | add_153_I5           |
| r745     | DW01_inc     | width=3    |               | add_153_I6           |
| r747     | DW01_inc     | width=3    |               | add_153_I7           |
| r749     | DW01_inc     | width=3    |               | add_153_I8           |
===============================================================================


No implementations to report
 
****************************************
Design : ALU_Issue_Buffer
****************************************
Resource Sharing Report for design ALU_Issue_Buffer in file
        /home/yiroug/Desktop/pipeline/verilog/Alu_issue_buffer.sv

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r519     | DW01_inc     | width=2    |               | add_62_I2            |
| r521     | DW01_inc     | width=3    |               | add_62_I3            |
| r523     | DW01_inc     | width=3    |               | add_62_I4            |
| r525     | DW01_cmp2    | width=3    |               | lt_78                |
| r527     | DW01_cmp2    | width=3    |               | lt_78_I2             |
| r529     | DW01_inc     | width=2    |               | add_79_I2            |
| r531     | DW01_dec     | width=3    |               | sub_80_I2            |
| r533     | DW01_cmp2    | width=3    |               | lt_78_I3             |
| r535     | DW01_inc     | width=3    |               | add_79_I3            |
| r537     | DW01_dec     | width=3    |               | sub_80_I3            |
| r539     | DW01_cmp2    | width=3    |               | lt_78_I4             |
| r541     | DW01_inc     | width=3    |               | add_79_I4            |
| r543     | DW01_dec     | width=3    |               | sub_80_I4            |
| r545     | DW01_cmp2    | width=3    |               | lt_78_I5             |
| r547     | DW01_inc     | width=3    |               | add_79_I5            |
| r549     | DW01_dec     | width=3    |               | sub_80_I5            |
| r551     | DW01_cmp2    | width=3    |               | lt_78_I6             |
| r553     | DW01_inc     | width=3    |               | add_79_I6            |
| r555     | DW01_dec     | width=3    |               | sub_80_I6            |
| r557     | DW01_cmp2    | width=3    |               | lt_78_I7             |
| r559     | DW01_inc     | width=3    |               | add_79_I7            |
| r561     | DW01_dec     | width=3    |               | sub_80_I7            |
| r563     | DW01_cmp2    | width=3    |               | lt_78_I8             |
| r565     | DW01_inc     | width=3    |               | add_79_I8            |
| r567     | DW01_dec     | width=3    |               | sub_80_I8            |
| r569     | DW01_cmp2    | width=3    |               | lt_90                |
| r571     | DW01_cmp2    | width=3    |               | lt_90_I2             |
| r573     | DW01_inc     | width=2    |               | add_93_I2            |
| r575     | DW01_cmp2    | width=3    |               | lt_90_I3             |
| r577     | DW01_inc     | width=3    |               | add_93_I3            |
| r579     | DW01_cmp2    | width=3    |               | lt_90_I4             |
| r581     | DW01_dec     | width=3    |               | sub_125_I2           |
| r583     | DW01_inc     | width=3    |               | add_130_I2           |
| r585     | DW01_dec     | width=3    |               | sub_125_I3           |
| r587     | DW01_inc     | width=3    |               | add_130_I3           |
| r589     | DW01_dec     | width=3    |               | sub_125_I4           |
| r591     | DW01_inc     | width=3    |               | add_130_I4           |
| r593     | DW01_dec     | width=3    |               | sub_125_I5           |
| r595     | DW01_inc     | width=3    |               | add_130_I5           |
| r597     | DW01_dec     | width=3    |               | sub_125_I6           |
| r599     | DW01_inc     | width=3    |               | add_130_I6           |
| r601     | DW01_dec     | width=3    |               | sub_125_I7           |
| r603     | DW01_inc     | width=3    |               | add_130_I7           |
| r605     | DW01_dec     | width=3    |               | sub_125_I8           |
| r607     | DW01_inc     | width=3    |               | add_130_I8           |
| r609     | DW01_sub     | width=3    |               | sub_142_aco          |
| r611     | DW01_sub     | width=3    |               | sub_142_I2_aco       |
| r613     | DW01_sub     | width=3    |               | sub_142_I3_aco       |
| r615     | DW01_inc     | width=2    |               | add_149_I2           |
| r617     | DW01_inc     | width=3    |               | add_149_I3           |
| r619     | DW01_inc     | width=3    |               | add_149_I4           |
| r621     | DW01_inc     | width=3    |               | add_149_I5           |
| r623     | DW01_inc     | width=3    |               | add_149_I6           |
| r625     | DW01_inc     | width=3    |               | add_149_I7           |
| r627     | DW01_inc     | width=3    |               | add_149_I8           |
===============================================================================


No implementations to report

No resource sharing information to report.
 
****************************************
Design : connected_ROB_RS
****************************************

No implementations to report

No resource sharing information to report.
 
****************************************
Design : connected_lsq_dcache
****************************************

No implementations to report
 
****************************************
Design : Dcache_ctrl
****************************************
Resource Sharing Report for design Dcache_ctrl in file
        /home/yiroug/Desktop/pipeline/verilog/Dcache_ctrl.sv

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r4410    | DW01_cmp6    | width=4    |               | eq_462 eq_476        |
| r4411    | DW01_cmp6    | width=4    |               | eq_462_I2 eq_476_I2  |
| r4412    | DW01_cmp6    | width=4    |               | eq_462_I3 eq_476_I3  |
| r4413    | DW01_cmp6    | width=4    |               | eq_462_I4 eq_476_I4  |
| r4414    | DW01_cmp6    | width=4    |               | eq_462_I5 eq_476_I5  |
| r4415    | DW01_cmp6    | width=4    |               | eq_462_I6 eq_476_I6  |
| r4416    | DW01_cmp6    | width=4    |               | eq_462_I7 eq_476_I7  |
| r4417    | DW01_cmp6    | width=4    |               | eq_462_I8 eq_476_I8  |
| r4793    | DW01_cmp6    | width=29   |               | eq_150               |
| r4795    | DW01_cmp6    | width=29   |               | eq_153               |
| r4797    | DW01_inc     | width=2    |               | add_412_I2           |
| r4799    | DW01_inc     | width=3    |               | add_412_I3           |
| r4801    | DW01_inc     | width=4    |               | add_412_I4           |
| r4803    | DW01_inc     | width=4    |               | add_412_I5           |
| r4805    | DW01_inc     | width=4    |               | add_412_I6           |
| r4807    | DW01_inc     | width=4    |               | add_412_I7           |
| r4809    | DW01_inc     | width=4    |               | add_412_I8           |
| r4811    | DW01_cmp2    | width=4    |               | gt_416               |
| r4813    | DW01_cmp6    | width=29   |               | eq_424               |
| r4815    | DW01_cmp6    | width=29   |               | eq_424_I2            |
| r4817    | DW01_cmp6    | width=29   |               | eq_424_I3            |
| r4819    | DW01_cmp6    | width=29   |               | eq_424_I4            |
| r4821    | DW01_cmp6    | width=29   |               | eq_424_I5            |
| r4823    | DW01_cmp6    | width=29   |               | eq_424_I6            |
| r4825    | DW01_cmp6    | width=29   |               | eq_424_I7            |
| r4827    | DW01_cmp6    | width=29   |               | eq_424_I8            |
| r4829    | DW01_cmp6    | width=29   |               | eq_432               |
| r4831    | DW01_cmp6    | width=29   |               | eq_432_I2            |
| r4833    | DW01_cmp6    | width=29   |               | eq_432_I3            |
| r4835    | DW01_cmp6    | width=29   |               | eq_432_I4            |
| r4837    | DW01_cmp6    | width=29   |               | eq_432_I5            |
| r4839    | DW01_cmp6    | width=29   |               | eq_432_I6            |
| r4841    | DW01_cmp6    | width=29   |               | eq_432_I7            |
| r4843    | DW01_cmp6    | width=29   |               | eq_432_I8            |
| r4845    | DW01_cmp6    | width=4    |               | eq_650               |
| r4847    | DW01_cmp6    | width=25   |               | eq_650_2             |
| r4849    | DW01_cmp6    | width=4    |               | eq_650_I2            |
| r4851    | DW01_cmp6    | width=25   |               | eq_650_2_I2          |
| r4853    | DW01_cmp6    | width=4    |               | eq_650_I3            |
| r4855    | DW01_cmp6    | width=25   |               | eq_650_2_I3          |
| r4857    | DW01_cmp6    | width=4    |               | eq_650_I4            |
| r4859    | DW01_cmp6    | width=25   |               | eq_650_2_I4          |
| r4861    | DW01_cmp6    | width=4    |               | eq_650_I5            |
| r4863    | DW01_cmp6    | width=25   |               | eq_650_2_I5          |
| r4865    | DW01_cmp6    | width=4    |               | eq_650_I6            |
| r4867    | DW01_cmp6    | width=25   |               | eq_650_2_I6          |
| r4869    | DW01_cmp6    | width=4    |               | eq_650_I7            |
| r4871    | DW01_cmp6    | width=25   |               | eq_650_2_I7          |
| r4873    | DW01_cmp6    | width=4    |               | eq_650_I8            |
| r4875    | DW01_cmp6    | width=25   |               | eq_650_2_I8          |
| r4885    | DW01_cmp2    | width=4    |               | lt_680               |
| r4887    | DW01_inc     | width=4    |               | add_681_3            |
| r4889    | DW01_cmp2    | width=4    |               | lt_680_I2            |
| r4891    | DW01_inc     | width=4    |               | add_681_3_I2         |
| r4893    | DW01_cmp2    | width=4    |               | lt_680_I2_I2         |
| r4895    | DW01_inc     | width=4    |               | add_681_3_I2_I2      |
| r4897    | DW01_cmp2    | width=4    |               | lt_680_I3            |
| r4899    | DW01_inc     | width=4    |               | add_681_3_I3         |
| r4901    | DW01_cmp2    | width=4    |               | lt_680_I2_I3         |
| r4903    | DW01_inc     | width=4    |               | add_681_3_I2_I3      |
| r4905    | DW01_cmp2    | width=4    |               | lt_680_I3_I3         |
| r4907    | DW01_inc     | width=4    |               | add_681_3_I3_I3      |
| r4909    | DW01_cmp2    | width=4    |               | lt_680_I4            |
| r4911    | DW01_inc     | width=4    |               | add_681_3_I4         |
| r4913    | DW01_cmp2    | width=4    |               | lt_680_I2_I4         |
| r4915    | DW01_inc     | width=4    |               | add_681_3_I2_I4      |
| r4917    | DW01_cmp2    | width=4    |               | lt_680_I3_I4         |
| r4919    | DW01_inc     | width=4    |               | add_681_3_I3_I4      |
| r4921    | DW01_cmp2    | width=4    |               | lt_680_I4_I4         |
| r4923    | DW01_inc     | width=4    |               | add_681_3_I4_I4      |
| r4925    | DW01_cmp2    | width=4    |               | lt_680_I5            |
| r4927    | DW01_inc     | width=4    |               | add_681_3_I5         |
| r4929    | DW01_cmp2    | width=4    |               | lt_680_I2_I5         |
| r4931    | DW01_inc     | width=4    |               | add_681_3_I2_I5      |
| r4933    | DW01_cmp2    | width=4    |               | lt_680_I3_I5         |
| r4935    | DW01_inc     | width=4    |               | add_681_3_I3_I5      |
| r4937    | DW01_cmp2    | width=4    |               | lt_680_I4_I5         |
| r4939    | DW01_inc     | width=4    |               | add_681_3_I4_I5      |
| r4941    | DW01_cmp2    | width=4    |               | lt_680_I5_I5         |
| r4943    | DW01_inc     | width=4    |               | add_681_3_I5_I5      |
| r4945    | DW01_cmp2    | width=4    |               | lt_680_I6            |
| r4947    | DW01_inc     | width=4    |               | add_681_3_I6         |
| r4949    | DW01_cmp2    | width=4    |               | lt_680_I2_I6         |
| r4951    | DW01_inc     | width=4    |               | add_681_3_I2_I6      |
| r4953    | DW01_cmp2    | width=4    |               | lt_680_I3_I6         |
| r4955    | DW01_inc     | width=4    |               | add_681_3_I3_I6      |
| r4957    | DW01_cmp2    | width=4    |               | lt_680_I4_I6         |
| r4959    | DW01_inc     | width=4    |               | add_681_3_I4_I6      |
| r4961    | DW01_cmp2    | width=4    |               | lt_680_I5_I6         |
| r4963    | DW01_inc     | width=4    |               | add_681_3_I5_I6      |
| r4965    | DW01_cmp2    | width=4    |               | lt_680_I6_I6         |
| r4967    | DW01_inc     | width=4    |               | add_681_3_I6_I6      |
| r4969    | DW01_cmp2    | width=4    |               | lt_680_I7            |
| r4971    | DW01_inc     | width=4    |               | add_681_3_I7         |
| r4973    | DW01_cmp2    | width=4    |               | lt_680_I2_I7         |
| r4975    | DW01_inc     | width=4    |               | add_681_3_I2_I7      |
| r4977    | DW01_cmp2    | width=4    |               | lt_680_I3_I7         |
| r4979    | DW01_inc     | width=4    |               | add_681_3_I3_I7      |
| r4981    | DW01_cmp2    | width=4    |               | lt_680_I4_I7         |
| r4983    | DW01_inc     | width=4    |               | add_681_3_I4_I7      |
| r4985    | DW01_cmp2    | width=4    |               | lt_680_I5_I7         |
| r4987    | DW01_inc     | width=4    |               | add_681_3_I5_I7      |
| r4989    | DW01_cmp2    | width=4    |               | lt_680_I6_I7         |
| r4991    | DW01_inc     | width=4    |               | add_681_3_I6_I7      |
| r4993    | DW01_cmp2    | width=4    |               | lt_680_I7_I7         |
| r4995    | DW01_inc     | width=4    |               | add_681_3_I7_I7      |
| r4997    | DW01_sub     | width=4    |               | sub_697_aco          |
| r4999    | DW01_sub     | width=4    |               | sub_702_aco          |
| r5001    | DW01_cmp6    | width=4    |               | eq_720               |
| r5003    | DW01_cmp6    | width=25   |               | eq_720_2             |
| r5005    | DW01_cmp6    | width=4    |               | eq_730               |
| r5007    | DW01_cmp6    | width=25   |               | ne_730               |
| r5009    | DW01_cmp6    | width=4    |               | eq_746               |
| r5011    | DW01_cmp6    | width=25   |               | eq_746_2             |
| r5013    | DW01_cmp6    | width=4    |               | eq_757               |
| r5015    | DW01_cmp6    | width=25   |               | ne_757               |
| r5017    | DW01_cmp6    | width=4    |               | eq_773               |
| r5019    | DW01_cmp6    | width=25   |               | eq_773_2             |
| r5021    | DW01_cmp6    | width=4    |               | eq_788               |
| r5023    | DW01_cmp6    | width=25   |               | ne_788               |
| r5025    | DW01_cmp6    | width=4    |               | eq_720_I2            |
| r5027    | DW01_cmp6    | width=25   |               | eq_720_2_I2          |
| r5029    | DW01_cmp6    | width=4    |               | eq_730_I2            |
| r5031    | DW01_cmp6    | width=25   |               | ne_730_I2            |
| r5033    | DW01_cmp6    | width=4    |               | eq_746_I2            |
| r5035    | DW01_cmp6    | width=25   |               | eq_746_2_I2          |
| r5037    | DW01_cmp6    | width=4    |               | eq_757_I2            |
| r5039    | DW01_cmp6    | width=25   |               | ne_757_I2            |
| r5041    | DW01_cmp6    | width=4    |               | eq_773_I2            |
| r5043    | DW01_cmp6    | width=25   |               | eq_773_2_I2          |
| r5045    | DW01_cmp6    | width=4    |               | eq_788_I2            |
| r5047    | DW01_cmp6    | width=25   |               | ne_788_I2            |
| r5049    | DW01_cmp6    | width=4    |               | eq_720_I3            |
| r5051    | DW01_cmp6    | width=25   |               | eq_720_2_I3          |
| r5053    | DW01_cmp6    | width=4    |               | eq_730_I3            |
| r5055    | DW01_cmp6    | width=25   |               | ne_730_I3            |
| r5057    | DW01_cmp6    | width=4    |               | eq_746_I3            |
| r5059    | DW01_cmp6    | width=25   |               | eq_746_2_I3          |
| r5061    | DW01_cmp6    | width=4    |               | eq_757_I3            |
| r5063    | DW01_cmp6    | width=25   |               | ne_757_I3            |
| r5065    | DW01_cmp6    | width=4    |               | eq_773_I3            |
| r5067    | DW01_cmp6    | width=25   |               | eq_773_2_I3          |
| r5069    | DW01_cmp6    | width=4    |               | eq_788_I3            |
| r5071    | DW01_cmp6    | width=25   |               | ne_788_I3            |
| r5073    | DW01_cmp6    | width=4    |               | eq_720_I4            |
| r5075    | DW01_cmp6    | width=25   |               | eq_720_2_I4          |
| r5077    | DW01_cmp6    | width=4    |               | eq_730_I4            |
| r5079    | DW01_cmp6    | width=25   |               | ne_730_I4            |
| r5081    | DW01_cmp6    | width=4    |               | eq_746_I4            |
| r5083    | DW01_cmp6    | width=25   |               | eq_746_2_I4          |
| r5085    | DW01_cmp6    | width=4    |               | eq_757_I4            |
| r5087    | DW01_cmp6    | width=25   |               | ne_757_I4            |
| r5089    | DW01_cmp6    | width=4    |               | eq_773_I4            |
| r5091    | DW01_cmp6    | width=25   |               | eq_773_2_I4          |
| r5093    | DW01_cmp6    | width=4    |               | eq_788_I4            |
| r5095    | DW01_cmp6    | width=25   |               | ne_788_I4            |
| r5097    | DW01_cmp6    | width=4    |               | eq_720_I5            |
| r5099    | DW01_cmp6    | width=25   |               | eq_720_2_I5          |
| r5101    | DW01_cmp6    | width=4    |               | eq_730_I5            |
| r5103    | DW01_cmp6    | width=25   |               | ne_730_I5            |
| r5105    | DW01_cmp6    | width=4    |               | eq_746_I5            |
| r5107    | DW01_cmp6    | width=25   |               | eq_746_2_I5          |
| r5109    | DW01_cmp6    | width=4    |               | eq_757_I5            |
| r5111    | DW01_cmp6    | width=25   |               | ne_757_I5            |
| r5113    | DW01_cmp6    | width=4    |               | eq_773_I5            |
| r5115    | DW01_cmp6    | width=25   |               | eq_773_2_I5          |
| r5117    | DW01_cmp6    | width=4    |               | eq_788_I5            |
| r5119    | DW01_cmp6    | width=25   |               | ne_788_I5            |
| r5121    | DW01_cmp6    | width=4    |               | eq_720_I6            |
| r5123    | DW01_cmp6    | width=25   |               | eq_720_2_I6          |
| r5125    | DW01_cmp6    | width=4    |               | eq_730_I6            |
| r5127    | DW01_cmp6    | width=25   |               | ne_730_I6            |
| r5129    | DW01_cmp6    | width=4    |               | eq_746_I6            |
| r5131    | DW01_cmp6    | width=25   |               | eq_746_2_I6          |
| r5133    | DW01_cmp6    | width=4    |               | eq_757_I6            |
| r5135    | DW01_cmp6    | width=25   |               | ne_757_I6            |
| r5137    | DW01_cmp6    | width=4    |               | eq_773_I6            |
| r5139    | DW01_cmp6    | width=25   |               | eq_773_2_I6          |
| r5141    | DW01_cmp6    | width=4    |               | eq_788_I6            |
| r5143    | DW01_cmp6    | width=25   |               | ne_788_I6            |
| r5145    | DW01_cmp6    | width=4    |               | eq_720_I7            |
| r5147    | DW01_cmp6    | width=25   |               | eq_720_2_I7          |
| r5149    | DW01_cmp6    | width=4    |               | eq_730_I7            |
| r5151    | DW01_cmp6    | width=25   |               | ne_730_I7            |
| r5153    | DW01_cmp6    | width=4    |               | eq_746_I7            |
| r5155    | DW01_cmp6    | width=25   |               | eq_746_2_I7          |
| r5157    | DW01_cmp6    | width=4    |               | eq_757_I7            |
| r5159    | DW01_cmp6    | width=25   |               | ne_757_I7            |
| r5161    | DW01_cmp6    | width=4    |               | eq_773_I7            |
| r5163    | DW01_cmp6    | width=25   |               | eq_773_2_I7          |
| r5165    | DW01_cmp6    | width=4    |               | eq_788_I7            |
| r5167    | DW01_cmp6    | width=25   |               | ne_788_I7            |
| r5169    | DW01_cmp6    | width=4    |               | eq_720_I8            |
| r5171    | DW01_cmp6    | width=25   |               | eq_720_2_I8          |
| r5173    | DW01_cmp6    | width=4    |               | eq_730_I8            |
| r5175    | DW01_cmp6    | width=25   |               | ne_730_I8            |
| r5177    | DW01_cmp6    | width=4    |               | eq_746_I8            |
| r5179    | DW01_cmp6    | width=25   |               | eq_746_2_I8          |
| r5181    | DW01_cmp6    | width=4    |               | eq_757_I8            |
| r5183    | DW01_cmp6    | width=25   |               | ne_757_I8            |
| r5185    | DW01_cmp6    | width=4    |               | eq_773_I8            |
| r5187    | DW01_cmp6    | width=25   |               | eq_773_2_I8          |
| r5189    | DW01_cmp6    | width=4    |               | eq_788_I8            |
| r5191    | DW01_cmp6    | width=25   |               | ne_788_I8            |
| r5310    | DW01_add     | width=2    |               | add_6_root_add_663_I8_aco |
| r5312    | DW01_add     | width=3    |               | add_5_root_add_663_I8_aco |
| r5314    | DW01_add     | width=4    |               | add_1_root_add_3_root_add_663_I8_aco |
| r5316    | DW01_add     | width=4    |               | add_0_root_add_3_root_add_663_I8_aco |
===============================================================================


No implementations to report
 
****************************************
Design : Dcache
****************************************
Resource Sharing Report for design Dcache in file
        /home/yiroug/Desktop/pipeline/verilog/Dcache.sv

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r1186    | DW01_cmp6    | width=2    |               | eq_154               |
| r1188    | DW01_cmp6    | width=32   |               | eq_154_2             |
| r1190    | DW01_cmp6    | width=25   |               | eq_200               |
| r1192    | DW01_cmp6    | width=25   |               | eq_200_I2            |
| r1194    | DW01_cmp6    | width=25   |               | eq_268               |
| r1196    | DW01_cmp6    | width=25   |               | eq_268_I2            |
| r1198    | DW01_cmp6    | width=25   |               | eq_327               |
| r1200    | DW01_cmp6    | width=25   |               | eq_327_I2            |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| eq_154_2           | DW01_cmp6        | rpl                |                |
===============================================================================

 
****************************************
Design : LSQ
****************************************
Resource Sharing Report for design LSQ in file
        /home/yiroug/Desktop/pipeline/verilog/LSQ.sv

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r2534    | DW01_inc     | width=4    |               | add_154              |
|          |              |            |               | add_285_I2_I1        |
|          |              |            |               | add_285_I2_I2        |
|          |              |            |               | add_285_I2_I3        |
|          |              |            |               | add_285_I2_I4        |
|          |              |            |               | add_285_I2_I5        |
|          |              |            |               | add_285_I2_I6        |
|          |              |            |               | add_285_I2_I7        |
|          |              |            |               | add_285_I2_I8        |
|          |              |            |               | add_299_I2_I1        |
|          |              |            |               | add_299_I2_I2        |
|          |              |            |               | add_299_I2_I3        |
|          |              |            |               | add_299_I2_I4        |
|          |              |            |               | add_299_I2_I5        |
|          |              |            |               | add_299_I2_I6        |
|          |              |            |               | add_299_I2_I7        |
|          |              |            |               | add_299_I2_I8        |
| r2539    | DW01_cmp2    | width=3    |               | lte_253_I2           |
|          |              |            |               | lte_261_I2           |
| r2540    | DW01_cmp2    | width=3    |               | gt_253_I2 gt_261_I2  |
| r2541    | DW01_cmp2    | width=3    |               | lte_253_I3           |
|          |              |            |               | lte_261_I3           |
| r2542    | DW01_cmp2    | width=3    |               | gt_253_I3 gt_261_I3  |
| r2543    | DW01_cmp2    | width=3    |               | lte_253_I4           |
|          |              |            |               | lte_261_I4           |
| r2544    | DW01_cmp2    | width=3    |               | gt_253_I4 gt_261_I4  |
| r2545    | DW01_cmp2    | width=3    |               | lte_253_I5           |
|          |              |            |               | lte_261_I5           |
| r2546    | DW01_cmp2    | width=3    |               | gt_253_I5 gt_261_I5  |
| r2547    | DW01_cmp2    | width=3    |               | lte_253_I6           |
|          |              |            |               | lte_261_I6           |
| r2548    | DW01_cmp2    | width=3    |               | gt_253_I6 gt_261_I6  |
| r2549    | DW01_cmp2    | width=3    |               | lte_253_I7           |
|          |              |            |               | lte_261_I7           |
| r2550    | DW01_cmp2    | width=3    |               | gt_253_I7 gt_261_I7  |
| r2551    | DW01_cmp2    | width=3    |               | lte_253_I8           |
|          |              |            |               | lte_261_I8           |
| r2552    | DW01_cmp2    | width=3    |               | gt_253_I8 gt_261_I8  |
| r2555    | DW01_add     | width=4    |               | add_285_I3_I1        |
|          |              |            |               | add_285_I3_I2        |
|          |              |            |               | add_285_I3_I3        |
|          |              |            |               | add_285_I3_I4        |
|          |              |            |               | add_285_I3_I5        |
|          |              |            |               | add_285_I3_I6        |
|          |              |            |               | add_285_I3_I7        |
|          |              |            |               | add_285_I3_I8        |
|          |              |            |               | add_299_I3_I1        |
|          |              |            |               | add_299_I3_I2        |
|          |              |            |               | add_299_I3_I3        |
|          |              |            |               | add_299_I3_I4        |
|          |              |            |               | add_299_I3_I5        |
|          |              |            |               | add_299_I3_I6        |
|          |              |            |               | add_299_I3_I7        |
|          |              |            |               | add_299_I3_I8        |
| r2557    | DW01_add     | width=4    |               | add_285_I4_I1        |
|          |              |            |               | add_285_I4_I2        |
|          |              |            |               | add_285_I4_I3        |
|          |              |            |               | add_285_I4_I4        |
|          |              |            |               | add_285_I4_I5        |
|          |              |            |               | add_285_I4_I6        |
|          |              |            |               | add_285_I4_I7        |
|          |              |            |               | add_285_I4_I8        |
|          |              |            |               | add_299_I4_I1        |
|          |              |            |               | add_299_I4_I2        |
|          |              |            |               | add_299_I4_I3        |
|          |              |            |               | add_299_I4_I4        |
|          |              |            |               | add_299_I4_I5        |
|          |              |            |               | add_299_I4_I6        |
|          |              |            |               | add_299_I4_I7        |
|          |              |            |               | add_299_I4_I8        |
| r2559    | DW01_add     | width=4    |               | add_285_I5_I1        |
|          |              |            |               | add_285_I5_I2        |
|          |              |            |               | add_285_I5_I3        |
|          |              |            |               | add_285_I5_I4        |
|          |              |            |               | add_285_I5_I5        |
|          |              |            |               | add_285_I5_I6        |
|          |              |            |               | add_285_I5_I7        |
|          |              |            |               | add_285_I5_I8        |
|          |              |            |               | add_299_I5_I1        |
|          |              |            |               | add_299_I5_I2        |
|          |              |            |               | add_299_I5_I3        |
|          |              |            |               | add_299_I5_I4        |
|          |              |            |               | add_299_I5_I5        |
|          |              |            |               | add_299_I5_I6        |
|          |              |            |               | add_299_I5_I7        |
|          |              |            |               | add_299_I5_I8        |
| r2561    | DW01_add     | width=4    |               | add_285_I6_I1        |
|          |              |            |               | add_285_I6_I2        |
|          |              |            |               | add_285_I6_I3        |
|          |              |            |               | add_285_I6_I4        |
|          |              |            |               | add_285_I6_I5        |
|          |              |            |               | add_285_I6_I6        |
|          |              |            |               | add_285_I6_I7        |
|          |              |            |               | add_285_I6_I8        |
|          |              |            |               | add_299_I6_I1        |
|          |              |            |               | add_299_I6_I2        |
|          |              |            |               | add_299_I6_I3        |
|          |              |            |               | add_299_I6_I4        |
|          |              |            |               | add_299_I6_I5        |
|          |              |            |               | add_299_I6_I6        |
|          |              |            |               | add_299_I6_I7        |
|          |              |            |               | add_299_I6_I8        |
| r2563    | DW01_add     | width=4    |               | add_285_I7_I1        |
|          |              |            |               | add_285_I7_I2        |
|          |              |            |               | add_285_I7_I3        |
|          |              |            |               | add_285_I7_I4        |
|          |              |            |               | add_285_I7_I5        |
|          |              |            |               | add_285_I7_I6        |
|          |              |            |               | add_285_I7_I7        |
|          |              |            |               | add_285_I7_I8        |
|          |              |            |               | add_299_I7_I1        |
|          |              |            |               | add_299_I7_I2        |
|          |              |            |               | add_299_I7_I3        |
|          |              |            |               | add_299_I7_I4        |
|          |              |            |               | add_299_I7_I5        |
|          |              |            |               | add_299_I7_I6        |
|          |              |            |               | add_299_I7_I7        |
|          |              |            |               | add_299_I7_I8        |
| r2565    | DW01_add     | width=3    |               | add_285_I8_I1        |
|          |              |            |               | add_285_I8_I2        |
|          |              |            |               | add_285_I8_I3        |
|          |              |            |               | add_285_I8_I4        |
|          |              |            |               | add_285_I8_I5        |
|          |              |            |               | add_285_I8_I6        |
|          |              |            |               | add_285_I8_I7        |
|          |              |            |               | add_285_I8_I8        |
|          |              |            |               | add_299_I8_I1        |
|          |              |            |               | add_299_I8_I2        |
|          |              |            |               | add_299_I8_I3        |
|          |              |            |               | add_299_I8_I4        |
|          |              |            |               | add_299_I8_I5        |
|          |              |            |               | add_299_I8_I6        |
|          |              |            |               | add_299_I8_I7        |
|          |              |            |               | add_299_I8_I8        |
| r2918    | DW01_cmp6    | width=6    |               | eq_124               |
| r2920    | DW01_cmp6    | width=6    |               | eq_124_I2_I1         |
| r2922    | DW01_cmp6    | width=6    |               | eq_124_I3_I1         |
| r2924    | DW01_cmp6    | width=6    |               | eq_124_I4_I1         |
| r2926    | DW01_cmp6    | width=6    |               | eq_124_I5_I1         |
| r2928    | DW01_cmp6    | width=6    |               | eq_124_I6_I1         |
| r2930    | DW01_cmp6    | width=6    |               | eq_124_I7_I1         |
| r2932    | DW01_cmp6    | width=6    |               | eq_124_I8_I1         |
| r2934    | DW01_cmp6    | width=6    |               | eq_124_I2            |
| r2936    | DW01_cmp6    | width=6    |               | eq_124_I2_I2         |
| r2938    | DW01_cmp6    | width=6    |               | eq_124_I3_I2         |
| r2940    | DW01_cmp6    | width=6    |               | eq_124_I4_I2         |
| r2942    | DW01_cmp6    | width=6    |               | eq_124_I5_I2         |
| r2944    | DW01_cmp6    | width=6    |               | eq_124_I6_I2         |
| r2946    | DW01_cmp6    | width=6    |               | eq_124_I7_I2         |
| r2948    | DW01_cmp6    | width=6    |               | eq_124_I8_I2         |
| r2950    | DW01_cmp6    | width=6    |               | eq_124_I3            |
| r2952    | DW01_cmp6    | width=6    |               | eq_124_I2_I3         |
| r2954    | DW01_cmp6    | width=6    |               | eq_124_I3_I3         |
| r2956    | DW01_cmp6    | width=6    |               | eq_124_I4_I3         |
| r2958    | DW01_cmp6    | width=6    |               | eq_124_I5_I3         |
| r2960    | DW01_cmp6    | width=6    |               | eq_124_I6_I3         |
| r2962    | DW01_cmp6    | width=6    |               | eq_124_I7_I3         |
| r2964    | DW01_cmp6    | width=6    |               | eq_124_I8_I3         |
| r2966    | DW01_cmp6    | width=6    |               | eq_124_I4            |
| r2968    | DW01_cmp6    | width=6    |               | eq_124_I2_I4         |
| r2970    | DW01_cmp6    | width=6    |               | eq_124_I3_I4         |
| r2972    | DW01_cmp6    | width=6    |               | eq_124_I4_I4         |
| r2974    | DW01_cmp6    | width=6    |               | eq_124_I5_I4         |
| r2976    | DW01_cmp6    | width=6    |               | eq_124_I6_I4         |
| r2978    | DW01_cmp6    | width=6    |               | eq_124_I7_I4         |
| r2980    | DW01_cmp6    | width=6    |               | eq_124_I8_I4         |
| r2982    | DW01_inc     | width=4    |               | add_171              |
| r2984    | DW01_inc     | width=4    |               | add_171_I2           |
| r2986    | DW01_inc     | width=4    |               | add_171_I3           |
| r2988    | DW01_inc     | width=4    |               | add_171_I4           |
| r2990    | DW01_cmp6    | width=4    |               | eq_287               |
| r2992    | DW01_cmp6    | width=4    |               | eq_287_I2_I1         |
| r2994    | DW01_cmp6    | width=4    |               | eq_287_I3_I1         |
| r2996    | DW01_cmp6    | width=4    |               | eq_287_I4_I1         |
| r2998    | DW01_cmp6    | width=4    |               | eq_287_I5_I1         |
| r3000    | DW01_cmp6    | width=4    |               | eq_287_I6_I1         |
| r3002    | DW01_cmp6    | width=4    |               | eq_287_I7_I1         |
| r3004    | DW01_cmp6    | width=4    |               | eq_287_I2            |
| r3006    | DW01_cmp6    | width=4    |               | eq_287_I2_I2         |
| r3008    | DW01_cmp6    | width=4    |               | eq_287_I3_I2         |
| r3010    | DW01_cmp6    | width=4    |               | eq_287_I4_I2         |
| r3012    | DW01_cmp6    | width=4    |               | eq_287_I5_I2         |
| r3014    | DW01_cmp6    | width=4    |               | eq_287_I6_I2         |
| r3016    | DW01_cmp6    | width=4    |               | eq_287_I7_I2         |
| r3018    | DW01_cmp6    | width=4    |               | eq_287_I3            |
| r3020    | DW01_cmp6    | width=4    |               | eq_287_I2_I3         |
| r3022    | DW01_cmp6    | width=4    |               | eq_287_I3_I3         |
| r3024    | DW01_cmp6    | width=4    |               | eq_287_I4_I3         |
| r3026    | DW01_cmp6    | width=4    |               | eq_287_I5_I3         |
| r3028    | DW01_cmp6    | width=4    |               | eq_287_I6_I3         |
| r3030    | DW01_cmp6    | width=4    |               | eq_287_I7_I3         |
| r3032    | DW01_cmp6    | width=4    |               | eq_287_I4            |
| r3034    | DW01_cmp6    | width=4    |               | eq_287_I2_I4         |
| r3036    | DW01_cmp6    | width=4    |               | eq_287_I3_I4         |
| r3038    | DW01_cmp6    | width=4    |               | eq_287_I4_I4         |
| r3040    | DW01_cmp6    | width=4    |               | eq_287_I5_I4         |
| r3042    | DW01_cmp6    | width=4    |               | eq_287_I6_I4         |
| r3044    | DW01_cmp6    | width=4    |               | eq_287_I7_I4         |
| r3046    | DW01_cmp6    | width=4    |               | eq_287_I5            |
| r3048    | DW01_cmp6    | width=4    |               | eq_287_I2_I5         |
| r3050    | DW01_cmp6    | width=4    |               | eq_287_I3_I5         |
| r3052    | DW01_cmp6    | width=4    |               | eq_287_I4_I5         |
| r3054    | DW01_cmp6    | width=4    |               | eq_287_I5_I5         |
| r3056    | DW01_cmp6    | width=4    |               | eq_287_I6_I5         |
| r3058    | DW01_cmp6    | width=4    |               | eq_287_I7_I5         |
| r3060    | DW01_cmp6    | width=4    |               | eq_287_I6            |
| r3062    | DW01_cmp6    | width=4    |               | eq_287_I2_I6         |
| r3064    | DW01_cmp6    | width=4    |               | eq_287_I3_I6         |
| r3066    | DW01_cmp6    | width=4    |               | eq_287_I4_I6         |
| r3068    | DW01_cmp6    | width=4    |               | eq_287_I5_I6         |
| r3070    | DW01_cmp6    | width=4    |               | eq_287_I6_I6         |
| r3072    | DW01_cmp6    | width=4    |               | eq_287_I7_I6         |
| r3074    | DW01_cmp6    | width=4    |               | eq_287_I7            |
| r3076    | DW01_cmp6    | width=4    |               | eq_287_I2_I7         |
| r3078    | DW01_cmp6    | width=4    |               | eq_287_I3_I7         |
| r3080    | DW01_cmp6    | width=4    |               | eq_287_I4_I7         |
| r3082    | DW01_cmp6    | width=4    |               | eq_287_I5_I7         |
| r3084    | DW01_cmp6    | width=4    |               | eq_287_I6_I7         |
| r3086    | DW01_cmp6    | width=4    |               | eq_287_I7_I7         |
| r3088    | DW01_cmp6    | width=4    |               | eq_287_I8            |
| r3090    | DW01_cmp6    | width=4    |               | eq_287_I2_I8         |
| r3092    | DW01_cmp6    | width=4    |               | eq_287_I3_I8         |
| r3094    | DW01_cmp6    | width=4    |               | eq_287_I4_I8         |
| r3096    | DW01_cmp6    | width=4    |               | eq_287_I5_I8         |
| r3098    | DW01_cmp6    | width=4    |               | eq_287_I6_I8         |
| r3100    | DW01_cmp6    | width=4    |               | eq_287_I7_I8         |
| r3102    | DW01_cmp6    | width=4    |               | eq_301               |
| r3104    | DW01_cmp6    | width=4    |               | eq_301_I2_I1         |
| r3106    | DW01_cmp6    | width=4    |               | eq_301_I3_I1         |
| r3108    | DW01_cmp6    | width=4    |               | eq_301_I4_I1         |
| r3110    | DW01_cmp6    | width=4    |               | eq_301_I5_I1         |
| r3112    | DW01_cmp6    | width=4    |               | eq_301_I6_I1         |
| r3114    | DW01_cmp6    | width=4    |               | eq_301_I7_I1         |
| r3116    | DW01_cmp6    | width=4    |               | eq_301_I2            |
| r3118    | DW01_cmp6    | width=4    |               | eq_301_I2_I2         |
| r3120    | DW01_cmp6    | width=4    |               | eq_301_I3_I2         |
| r3122    | DW01_cmp6    | width=4    |               | eq_301_I4_I2         |
| r3124    | DW01_cmp6    | width=4    |               | eq_301_I5_I2         |
| r3126    | DW01_cmp6    | width=4    |               | eq_301_I6_I2         |
| r3128    | DW01_cmp6    | width=4    |               | eq_301_I7_I2         |
| r3130    | DW01_cmp6    | width=4    |               | eq_301_I3            |
| r3132    | DW01_cmp6    | width=4    |               | eq_301_I2_I3         |
| r3134    | DW01_cmp6    | width=4    |               | eq_301_I3_I3         |
| r3136    | DW01_cmp6    | width=4    |               | eq_301_I4_I3         |
| r3138    | DW01_cmp6    | width=4    |               | eq_301_I5_I3         |
| r3140    | DW01_cmp6    | width=4    |               | eq_301_I6_I3         |
| r3142    | DW01_cmp6    | width=4    |               | eq_301_I7_I3         |
| r3144    | DW01_cmp6    | width=4    |               | eq_301_I4            |
| r3146    | DW01_cmp6    | width=4    |               | eq_301_I2_I4         |
| r3148    | DW01_cmp6    | width=4    |               | eq_301_I3_I4         |
| r3150    | DW01_cmp6    | width=4    |               | eq_301_I4_I4         |
| r3152    | DW01_cmp6    | width=4    |               | eq_301_I5_I4         |
| r3154    | DW01_cmp6    | width=4    |               | eq_301_I6_I4         |
| r3156    | DW01_cmp6    | width=4    |               | eq_301_I7_I4         |
| r3158    | DW01_cmp6    | width=4    |               | eq_301_I5            |
| r3160    | DW01_cmp6    | width=4    |               | eq_301_I2_I5         |
| r3162    | DW01_cmp6    | width=4    |               | eq_301_I3_I5         |
| r3164    | DW01_cmp6    | width=4    |               | eq_301_I4_I5         |
| r3166    | DW01_cmp6    | width=4    |               | eq_301_I5_I5         |
| r3168    | DW01_cmp6    | width=4    |               | eq_301_I6_I5         |
| r3170    | DW01_cmp6    | width=4    |               | eq_301_I7_I5         |
| r3172    | DW01_cmp6    | width=4    |               | eq_301_I6            |
| r3174    | DW01_cmp6    | width=4    |               | eq_301_I2_I6         |
| r3176    | DW01_cmp6    | width=4    |               | eq_301_I3_I6         |
| r3178    | DW01_cmp6    | width=4    |               | eq_301_I4_I6         |
| r3180    | DW01_cmp6    | width=4    |               | eq_301_I5_I6         |
| r3182    | DW01_cmp6    | width=4    |               | eq_301_I6_I6         |
| r3184    | DW01_cmp6    | width=4    |               | eq_301_I7_I6         |
| r3186    | DW01_cmp6    | width=4    |               | eq_301_I7            |
| r3188    | DW01_cmp6    | width=4    |               | eq_301_I2_I7         |
| r3190    | DW01_cmp6    | width=4    |               | eq_301_I3_I7         |
| r3192    | DW01_cmp6    | width=4    |               | eq_301_I4_I7         |
| r3194    | DW01_cmp6    | width=4    |               | eq_301_I5_I7         |
| r3196    | DW01_cmp6    | width=4    |               | eq_301_I6_I7         |
| r3198    | DW01_cmp6    | width=4    |               | eq_301_I7_I7         |
| r3200    | DW01_cmp6    | width=4    |               | eq_301_I8            |
| r3202    | DW01_cmp6    | width=4    |               | eq_301_I2_I8         |
| r3204    | DW01_cmp6    | width=4    |               | eq_301_I3_I8         |
| r3206    | DW01_cmp6    | width=4    |               | eq_301_I4_I8         |
| r3208    | DW01_cmp6    | width=4    |               | eq_301_I5_I8         |
| r3210    | DW01_cmp6    | width=4    |               | eq_301_I6_I8         |
| r3212    | DW01_cmp6    | width=4    |               | eq_301_I7_I8         |
| r3214    | DW01_cmp6    | width=32   |               | eq_338               |
| r3216    | DW01_cmp6    | width=2    |               | eq_338_2             |
| r3218    | DW01_cmp6    | width=32   |               | eq_344               |
| r3220    | DW01_cmp6    | width=2    |               | ne_344               |
| r3222    | DW01_cmp6    | width=4    |               | eq_349               |
| r3224    | DW01_dec     | width=4    |               | sub_337_I2           |
| r3226    | DW01_cmp6    | width=32   |               | eq_338_I2            |
| r3228    | DW01_cmp6    | width=2    |               | eq_338_2_I2          |
| r3230    | DW01_cmp6    | width=32   |               | eq_344_I2            |
| r3232    | DW01_cmp6    | width=2    |               | ne_344_I2            |
| r3234    | DW01_cmp6    | width=4    |               | eq_349_I2            |
| r3236    | DW01_sub     | width=4    |               | sub_337_I3           |
| r3238    | DW01_cmp6    | width=32   |               | eq_338_I3            |
| r3240    | DW01_cmp6    | width=2    |               | eq_338_2_I3          |
| r3242    | DW01_cmp6    | width=32   |               | eq_344_I3            |
| r3244    | DW01_cmp6    | width=2    |               | ne_344_I3            |
| r3246    | DW01_cmp6    | width=4    |               | eq_349_I3            |
| r3248    | DW01_sub     | width=4    |               | sub_337_I4           |
| r3250    | DW01_cmp6    | width=32   |               | eq_338_I4            |
| r3252    | DW01_cmp6    | width=2    |               | eq_338_2_I4          |
| r3254    | DW01_cmp6    | width=32   |               | eq_344_I4            |
| r3256    | DW01_cmp6    | width=2    |               | ne_344_I4            |
| r3258    | DW01_cmp6    | width=4    |               | eq_349_I4            |
| r3260    | DW01_sub     | width=4    |               | sub_337_I5           |
| r3262    | DW01_cmp6    | width=32   |               | eq_338_I5            |
| r3264    | DW01_cmp6    | width=2    |               | eq_338_2_I5          |
| r3266    | DW01_cmp6    | width=32   |               | eq_344_I5            |
| r3268    | DW01_cmp6    | width=2    |               | ne_344_I5            |
| r3270    | DW01_cmp6    | width=4    |               | eq_349_I5            |
| r3272    | DW01_sub     | width=4    |               | sub_337_I6           |
| r3274    | DW01_cmp6    | width=32   |               | eq_338_I6            |
| r3276    | DW01_cmp6    | width=2    |               | eq_338_2_I6          |
| r3278    | DW01_cmp6    | width=32   |               | eq_344_I6            |
| r3280    | DW01_cmp6    | width=2    |               | ne_344_I6            |
| r3282    | DW01_cmp6    | width=4    |               | eq_349_I6            |
| r3284    | DW01_sub     | width=4    |               | sub_337_I7           |
| r3286    | DW01_cmp6    | width=32   |               | eq_338_I7            |
| r3288    | DW01_cmp6    | width=2    |               | eq_338_2_I7          |
| r3290    | DW01_cmp6    | width=32   |               | eq_344_I7            |
| r3292    | DW01_cmp6    | width=2    |               | ne_344_I7            |
| r3294    | DW01_cmp6    | width=4    |               | eq_349_I7            |
| r3296    | DW01_sub     | width=3    |               | sub_337_I8           |
| r3298    | DW01_cmp6    | width=32   |               | eq_338_I8            |
| r3300    | DW01_cmp6    | width=2    |               | eq_338_2_I8          |
| r3302    | DW01_cmp6    | width=32   |               | eq_344_I8            |
| r3304    | DW01_cmp6    | width=2    |               | ne_344_I8            |
| r3421    | DW01_sub     | width=4    |               | sub_1_root_add_382   |
| r3423    | DW01_inc     | width=4    |               | add_0_root_add_382   |
| r3425    | DW01_sub     | width=4    |               | sub_382_2            |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| eq_338             | DW01_cmp6        | rpl                |                |
| eq_344             | DW01_cmp6        | rpl                |                |
| eq_338_I2          | DW01_cmp6        | rpl                |                |
| eq_344_I2          | DW01_cmp6        | rpl                |                |
| eq_338_I3          | DW01_cmp6        | rpl                |                |
| eq_344_I3          | DW01_cmp6        | rpl                |                |
| eq_338_I4          | DW01_cmp6        | rpl                |                |
| eq_344_I4          | DW01_cmp6        | rpl                |                |
| eq_338_I5          | DW01_cmp6        | rpl                |                |
| eq_344_I5          | DW01_cmp6        | rpl                |                |
| eq_338_I6          | DW01_cmp6        | rpl                |                |
| eq_344_I6          | DW01_cmp6        | rpl                |                |
| eq_338_I7          | DW01_cmp6        | rpl                |                |
| eq_344_I7          | DW01_cmp6        | rpl                |                |
| eq_338_I8          | DW01_cmp6        | rpl                |                |
| eq_344_I8          | DW01_cmp6        | rpl                |                |
===============================================================================

 
****************************************
Design : rs_entry
****************************************
Resource Sharing Report for design rs_entry in file
        /home/yiroug/Desktop/pipeline/verilog/rs_entry.sv

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r2438    | DW01_dec     | width=3    |               | sub_175_I2           |
|          |              |            |               | sub_176_I2           |
|          |              |            |               | sub_177_I2           |
| r2440    | DW01_dec     | width=3    |               | sub_175_I3           |
|          |              |            |               | sub_176_I3           |
|          |              |            |               | sub_177_I3           |
| r2442    | DW01_dec     | width=3    |               | sub_175_I4           |
|          |              |            |               | sub_176_I4           |
|          |              |            |               | sub_177_I4           |
| r2444    | DW01_dec     | width=3    |               | sub_175_I5           |
|          |              |            |               | sub_176_I5           |
|          |              |            |               | sub_177_I5           |
| r2446    | DW01_dec     | width=3    |               | sub_175_I6           |
|          |              |            |               | sub_176_I6           |
|          |              |            |               | sub_177_I6           |
| r2448    | DW01_dec     | width=3    |               | sub_175_I7           |
|          |              |            |               | sub_176_I7           |
|          |              |            |               | sub_177_I7           |
| r2600    | DW01_cmp6    | width=4    |               | eq_88                |
| r2602    | DW01_cmp6    | width=4    |               | eq_88_I2             |
| r2604    | DW01_cmp6    | width=4    |               | eq_88_I3             |
| r2606    | DW01_cmp6    | width=4    |               | eq_88_I4             |
| r2608    | DW01_cmp6    | width=4    |               | eq_88_I5             |
| r2610    | DW01_cmp6    | width=4    |               | eq_88_I6             |
| r2612    | DW01_cmp6    | width=4    |               | eq_88_I7             |
| r2614    | DW01_cmp6    | width=4    |               | eq_88_I8             |
| r2616    | DW01_cmp6    | width=6    |               | eq_134               |
| r2618    | DW01_cmp6    | width=6    |               | eq_137               |
| r2620    | DW01_cmp6    | width=6    |               | eq_134_I2_I1         |
| r2622    | DW01_cmp6    | width=6    |               | eq_137_I2_I1         |
| r2624    | DW01_cmp6    | width=6    |               | eq_134_I3_I1         |
| r2626    | DW01_cmp6    | width=6    |               | eq_137_I3_I1         |
| r2628    | DW01_cmp6    | width=6    |               | eq_134_I4_I1         |
| r2630    | DW01_cmp6    | width=6    |               | eq_137_I4_I1         |
| r2632    | DW01_cmp6    | width=6    |               | eq_134_I5_I1         |
| r2634    | DW01_cmp6    | width=6    |               | eq_137_I5_I1         |
| r2636    | DW01_cmp6    | width=6    |               | eq_134_I6_I1         |
| r2638    | DW01_cmp6    | width=6    |               | eq_137_I6_I1         |
| r2640    | DW01_cmp6    | width=6    |               | eq_134_I7_I1         |
| r2642    | DW01_cmp6    | width=6    |               | eq_137_I7_I1         |
| r2644    | DW01_cmp6    | width=6    |               | eq_134_I8_I1         |
| r2646    | DW01_cmp6    | width=6    |               | eq_137_I8_I1         |
| r2648    | DW01_cmp6    | width=6    |               | eq_134_I2            |
| r2650    | DW01_cmp6    | width=6    |               | eq_137_I2            |
| r2652    | DW01_cmp6    | width=6    |               | eq_134_I2_I2         |
| r2654    | DW01_cmp6    | width=6    |               | eq_137_I2_I2         |
| r2656    | DW01_cmp6    | width=6    |               | eq_134_I3_I2         |
| r2658    | DW01_cmp6    | width=6    |               | eq_137_I3_I2         |
| r2660    | DW01_cmp6    | width=6    |               | eq_134_I4_I2         |
| r2662    | DW01_cmp6    | width=6    |               | eq_137_I4_I2         |
| r2664    | DW01_cmp6    | width=6    |               | eq_134_I5_I2         |
| r2666    | DW01_cmp6    | width=6    |               | eq_137_I5_I2         |
| r2668    | DW01_cmp6    | width=6    |               | eq_134_I6_I2         |
| r2670    | DW01_cmp6    | width=6    |               | eq_137_I6_I2         |
| r2672    | DW01_cmp6    | width=6    |               | eq_134_I7_I2         |
| r2674    | DW01_cmp6    | width=6    |               | eq_137_I7_I2         |
| r2676    | DW01_cmp6    | width=6    |               | eq_134_I8_I2         |
| r2678    | DW01_cmp6    | width=6    |               | eq_137_I8_I2         |
| r2680    | DW01_cmp6    | width=6    |               | eq_134_I3            |
| r2682    | DW01_cmp6    | width=6    |               | eq_137_I3            |
| r2684    | DW01_cmp6    | width=6    |               | eq_134_I2_I3         |
| r2686    | DW01_cmp6    | width=6    |               | eq_137_I2_I3         |
| r2688    | DW01_cmp6    | width=6    |               | eq_134_I3_I3         |
| r2690    | DW01_cmp6    | width=6    |               | eq_137_I3_I3         |
| r2692    | DW01_cmp6    | width=6    |               | eq_134_I4_I3         |
| r2694    | DW01_cmp6    | width=6    |               | eq_137_I4_I3         |
| r2696    | DW01_cmp6    | width=6    |               | eq_134_I5_I3         |
| r2698    | DW01_cmp6    | width=6    |               | eq_137_I5_I3         |
| r2700    | DW01_cmp6    | width=6    |               | eq_134_I6_I3         |
| r2702    | DW01_cmp6    | width=6    |               | eq_137_I6_I3         |
| r2704    | DW01_cmp6    | width=6    |               | eq_134_I7_I3         |
| r2706    | DW01_cmp6    | width=6    |               | eq_137_I7_I3         |
| r2708    | DW01_cmp6    | width=6    |               | eq_134_I8_I3         |
| r2710    | DW01_cmp6    | width=6    |               | eq_137_I8_I3         |
| r2712    | DW01_cmp6    | width=6    |               | eq_134_I4            |
| r2714    | DW01_cmp6    | width=6    |               | eq_137_I4            |
| r2716    | DW01_cmp6    | width=6    |               | eq_134_I2_I4         |
| r2718    | DW01_cmp6    | width=6    |               | eq_137_I2_I4         |
| r2720    | DW01_cmp6    | width=6    |               | eq_134_I3_I4         |
| r2722    | DW01_cmp6    | width=6    |               | eq_137_I3_I4         |
| r2724    | DW01_cmp6    | width=6    |               | eq_134_I4_I4         |
| r2726    | DW01_cmp6    | width=6    |               | eq_137_I4_I4         |
| r2728    | DW01_cmp6    | width=6    |               | eq_134_I5_I4         |
| r2730    | DW01_cmp6    | width=6    |               | eq_137_I5_I4         |
| r2732    | DW01_cmp6    | width=6    |               | eq_134_I6_I4         |
| r2734    | DW01_cmp6    | width=6    |               | eq_137_I6_I4         |
| r2736    | DW01_cmp6    | width=6    |               | eq_134_I7_I4         |
| r2738    | DW01_cmp6    | width=6    |               | eq_137_I7_I4         |
| r2740    | DW01_cmp6    | width=6    |               | eq_134_I8_I4         |
| r2742    | DW01_cmp6    | width=6    |               | eq_137_I8_I4         |
| r2744    | DW01_sub     | width=3    |               | sub_153_aco          |
| r2746    | DW01_sub     | width=3    |               | sub_158_aco          |
| r2748    | DW01_sub     | width=3    |               | sub_163_aco          |
| r2750    | DW01_sub     | width=3    |               | sub_153_I2_aco       |
| r2752    | DW01_sub     | width=3    |               | sub_158_I2_aco       |
| r2754    | DW01_sub     | width=3    |               | sub_163_I2_aco       |
| r2756    | DW01_sub     | width=3    |               | sub_153_I3_aco       |
| r2758    | DW01_sub     | width=3    |               | sub_158_I3_aco       |
| r2760    | DW01_sub     | width=3    |               | sub_163_I3_aco       |
| r2762    | DW01_sub     | width=3    |               | sub_153_I4_aco       |
| r2764    | DW01_sub     | width=3    |               | sub_158_I4_aco       |
| r2766    | DW01_sub     | width=3    |               | sub_163_I4_aco       |
| r2768    | DW01_sub     | width=3    |               | sub_153_I5_aco       |
| r2770    | DW01_sub     | width=3    |               | sub_158_I5_aco       |
| r2772    | DW01_sub     | width=3    |               | sub_163_I5_aco       |
| r2774    | DW01_sub     | width=3    |               | sub_153_I6_aco       |
| r2776    | DW01_sub     | width=3    |               | sub_158_I6_aco       |
| r2778    | DW01_sub     | width=3    |               | sub_163_I6_aco       |
| r2780    | DW01_sub     | width=3    |               | sub_153_I7_aco       |
| r2782    | DW01_sub     | width=3    |               | sub_158_I7_aco       |
| r2784    | DW01_sub     | width=3    |               | sub_163_I7_aco       |
| r2786    | DW01_inc     | width=2    |               | add_173_I2           |
| r2788    | DW01_inc     | width=3    |               | add_173_I3           |
| r2790    | DW01_inc     | width=3    |               | add_173_I4           |
| r2792    | DW01_inc     | width=3    |               | add_173_I5           |
| r2794    | DW01_inc     | width=3    |               | add_173_I6           |
| r2796    | DW01_inc     | width=3    |               | add_173_I7           |
| r2800    | DW01_inc     | width=2    |               | add_212_I2           |
| r2802    | DW01_inc     | width=3    |               | add_212_I3           |
| r2804    | DW01_inc     | width=3    |               | add_212_I4           |
| r2806    | DW01_inc     | width=3    |               | add_212_I5           |
| r2808    | DW01_inc     | width=3    |               | add_212_I6           |
| r2810    | DW01_inc     | width=3    |               | add_212_I7           |
| r2812    | DW01_inc     | width=3    |               | add_212_I8           |
| r2814    | DW01_dec     | width=3    |               | sub_248_I2           |
| r2816    | DW01_inc     | width=3    |               | add_253_I2           |
| r2818    | DW01_dec     | width=3    |               | sub_248_I3           |
| r2820    | DW01_inc     | width=3    |               | add_253_I3           |
| r2822    | DW01_dec     | width=3    |               | sub_248_I4           |
| r2824    | DW01_inc     | width=3    |               | add_253_I4           |
| r2826    | DW01_dec     | width=3    |               | sub_248_I5           |
| r2828    | DW01_inc     | width=3    |               | add_253_I5           |
| r2830    | DW01_dec     | width=3    |               | sub_248_I6           |
| r2832    | DW01_inc     | width=3    |               | add_253_I6           |
| r2834    | DW01_dec     | width=3    |               | sub_248_I7           |
| r2836    | DW01_inc     | width=3    |               | add_253_I7           |
| r2838    | DW01_dec     | width=3    |               | sub_248_I8           |
| r2840    | DW01_inc     | width=3    |               | add_253_I8           |
| r2842    | DW01_sub     | width=3    |               | sub_292_aco          |
| r2844    | DW01_sub     | width=3    |               | sub_292_I2_aco       |
| r2846    | DW01_sub     | width=3    |               | sub_292_I3_aco       |
| r2954    | DW01_dec     | width=3    |               | sub_1_root_r2450     |
| r2956    | DW01_add     | width=3    |               | sub_175_I8           |
|          |              |            |               | sub_176_I8           |
|          |              |            |               | sub_177_I8           |
===============================================================================


No implementations to report
 
****************************************
Design : RRAT
****************************************
Resource Sharing Report for design RRAT in file
        /home/yiroug/Desktop/pipeline/verilog/RRAT.sv

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r567     | DW01_cmp6    | width=6    |               | eq_17                |
| r569     | DW01_cmp6    | width=6    |               | eq_17_I2_I1          |
| r571     | DW01_cmp6    | width=6    |               | eq_17_I3_I1          |
| r573     | DW01_cmp6    | width=6    |               | eq_17_I4_I1          |
| r575     | DW01_cmp6    | width=6    |               | eq_17_I5_I1          |
| r577     | DW01_cmp6    | width=6    |               | eq_17_I6_I1          |
| r579     | DW01_cmp6    | width=6    |               | eq_17_I7_I1          |
| r581     | DW01_cmp6    | width=6    |               | eq_17_I8_I1          |
| r583     | DW01_cmp6    | width=6    |               | eq_17_I9_I1          |
| r585     | DW01_cmp6    | width=6    |               | eq_17_I10_I1         |
| r587     | DW01_cmp6    | width=6    |               | eq_17_I11_I1         |
| r589     | DW01_cmp6    | width=6    |               | eq_17_I12_I1         |
| r591     | DW01_cmp6    | width=6    |               | eq_17_I13_I1         |
| r593     | DW01_cmp6    | width=6    |               | eq_17_I14_I1         |
| r595     | DW01_cmp6    | width=6    |               | eq_17_I15_I1         |
| r597     | DW01_cmp6    | width=6    |               | eq_17_I16_I1         |
| r599     | DW01_cmp6    | width=6    |               | eq_17_I17_I1         |
| r601     | DW01_cmp6    | width=6    |               | eq_17_I18_I1         |
| r603     | DW01_cmp6    | width=6    |               | eq_17_I19_I1         |
| r605     | DW01_cmp6    | width=6    |               | eq_17_I20_I1         |
| r607     | DW01_cmp6    | width=6    |               | eq_17_I21_I1         |
| r609     | DW01_cmp6    | width=6    |               | eq_17_I22_I1         |
| r611     | DW01_cmp6    | width=6    |               | eq_17_I23_I1         |
| r613     | DW01_cmp6    | width=6    |               | eq_17_I24_I1         |
| r615     | DW01_cmp6    | width=6    |               | eq_17_I25_I1         |
| r617     | DW01_cmp6    | width=6    |               | eq_17_I26_I1         |
| r619     | DW01_cmp6    | width=6    |               | eq_17_I27_I1         |
| r621     | DW01_cmp6    | width=6    |               | eq_17_I28_I1         |
| r623     | DW01_cmp6    | width=6    |               | eq_17_I29_I1         |
| r625     | DW01_cmp6    | width=6    |               | eq_17_I30_I1         |
| r627     | DW01_cmp6    | width=6    |               | eq_17_I31_I1         |
| r629     | DW01_cmp6    | width=6    |               | eq_17_I32_I1         |
| r631     | DW01_cmp6    | width=6    |               | eq_17_I2             |
| r633     | DW01_cmp6    | width=6    |               | eq_17_I2_I2          |
| r635     | DW01_cmp6    | width=6    |               | eq_17_I3_I2          |
| r637     | DW01_cmp6    | width=6    |               | eq_17_I4_I2          |
| r639     | DW01_cmp6    | width=6    |               | eq_17_I5_I2          |
| r641     | DW01_cmp6    | width=6    |               | eq_17_I6_I2          |
| r643     | DW01_cmp6    | width=6    |               | eq_17_I7_I2          |
| r645     | DW01_cmp6    | width=6    |               | eq_17_I8_I2          |
| r647     | DW01_cmp6    | width=6    |               | eq_17_I9_I2          |
| r649     | DW01_cmp6    | width=6    |               | eq_17_I10_I2         |
| r651     | DW01_cmp6    | width=6    |               | eq_17_I11_I2         |
| r653     | DW01_cmp6    | width=6    |               | eq_17_I12_I2         |
| r655     | DW01_cmp6    | width=6    |               | eq_17_I13_I2         |
| r657     | DW01_cmp6    | width=6    |               | eq_17_I14_I2         |
| r659     | DW01_cmp6    | width=6    |               | eq_17_I15_I2         |
| r661     | DW01_cmp6    | width=6    |               | eq_17_I16_I2         |
| r663     | DW01_cmp6    | width=6    |               | eq_17_I17_I2         |
| r665     | DW01_cmp6    | width=6    |               | eq_17_I18_I2         |
| r667     | DW01_cmp6    | width=6    |               | eq_17_I19_I2         |
| r669     | DW01_cmp6    | width=6    |               | eq_17_I20_I2         |
| r671     | DW01_cmp6    | width=6    |               | eq_17_I21_I2         |
| r673     | DW01_cmp6    | width=6    |               | eq_17_I22_I2         |
| r675     | DW01_cmp6    | width=6    |               | eq_17_I23_I2         |
| r677     | DW01_cmp6    | width=6    |               | eq_17_I24_I2         |
| r679     | DW01_cmp6    | width=6    |               | eq_17_I25_I2         |
| r681     | DW01_cmp6    | width=6    |               | eq_17_I26_I2         |
| r683     | DW01_cmp6    | width=6    |               | eq_17_I27_I2         |
| r685     | DW01_cmp6    | width=6    |               | eq_17_I28_I2         |
| r687     | DW01_cmp6    | width=6    |               | eq_17_I29_I2         |
| r689     | DW01_cmp6    | width=6    |               | eq_17_I30_I2         |
| r691     | DW01_cmp6    | width=6    |               | eq_17_I31_I2         |
| r693     | DW01_cmp6    | width=6    |               | eq_17_I32_I2         |
| r695     | DW01_cmp6    | width=6    |               | eq_17_I3             |
| r697     | DW01_cmp6    | width=6    |               | eq_17_I2_I3          |
| r699     | DW01_cmp6    | width=6    |               | eq_17_I3_I3          |
| r701     | DW01_cmp6    | width=6    |               | eq_17_I4_I3          |
| r703     | DW01_cmp6    | width=6    |               | eq_17_I5_I3          |
| r705     | DW01_cmp6    | width=6    |               | eq_17_I6_I3          |
| r707     | DW01_cmp6    | width=6    |               | eq_17_I7_I3          |
| r709     | DW01_cmp6    | width=6    |               | eq_17_I8_I3          |
| r711     | DW01_cmp6    | width=6    |               | eq_17_I9_I3          |
| r713     | DW01_cmp6    | width=6    |               | eq_17_I10_I3         |
| r715     | DW01_cmp6    | width=6    |               | eq_17_I11_I3         |
| r717     | DW01_cmp6    | width=6    |               | eq_17_I12_I3         |
| r719     | DW01_cmp6    | width=6    |               | eq_17_I13_I3         |
| r721     | DW01_cmp6    | width=6    |               | eq_17_I14_I3         |
| r723     | DW01_cmp6    | width=6    |               | eq_17_I15_I3         |
| r725     | DW01_cmp6    | width=6    |               | eq_17_I16_I3         |
| r727     | DW01_cmp6    | width=6    |               | eq_17_I17_I3         |
| r729     | DW01_cmp6    | width=6    |               | eq_17_I18_I3         |
| r731     | DW01_cmp6    | width=6    |               | eq_17_I19_I3         |
| r733     | DW01_cmp6    | width=6    |               | eq_17_I20_I3         |
| r735     | DW01_cmp6    | width=6    |               | eq_17_I21_I3         |
| r737     | DW01_cmp6    | width=6    |               | eq_17_I22_I3         |
| r739     | DW01_cmp6    | width=6    |               | eq_17_I23_I3         |
| r741     | DW01_cmp6    | width=6    |               | eq_17_I24_I3         |
| r743     | DW01_cmp6    | width=6    |               | eq_17_I25_I3         |
| r745     | DW01_cmp6    | width=6    |               | eq_17_I26_I3         |
| r747     | DW01_cmp6    | width=6    |               | eq_17_I27_I3         |
| r749     | DW01_cmp6    | width=6    |               | eq_17_I28_I3         |
| r751     | DW01_cmp6    | width=6    |               | eq_17_I29_I3         |
| r753     | DW01_cmp6    | width=6    |               | eq_17_I30_I3         |
| r755     | DW01_cmp6    | width=6    |               | eq_17_I31_I3         |
| r757     | DW01_cmp6    | width=6    |               | eq_17_I32_I3         |
| r759     | DW01_cmp6    | width=6    |               | eq_17_I4             |
| r761     | DW01_cmp6    | width=6    |               | eq_17_I2_I4          |
| r763     | DW01_cmp6    | width=6    |               | eq_17_I3_I4          |
| r765     | DW01_cmp6    | width=6    |               | eq_17_I4_I4          |
| r767     | DW01_cmp6    | width=6    |               | eq_17_I5_I4          |
| r769     | DW01_cmp6    | width=6    |               | eq_17_I6_I4          |
| r771     | DW01_cmp6    | width=6    |               | eq_17_I7_I4          |
| r773     | DW01_cmp6    | width=6    |               | eq_17_I8_I4          |
| r775     | DW01_cmp6    | width=6    |               | eq_17_I9_I4          |
| r777     | DW01_cmp6    | width=6    |               | eq_17_I10_I4         |
| r779     | DW01_cmp6    | width=6    |               | eq_17_I11_I4         |
| r781     | DW01_cmp6    | width=6    |               | eq_17_I12_I4         |
| r783     | DW01_cmp6    | width=6    |               | eq_17_I13_I4         |
| r785     | DW01_cmp6    | width=6    |               | eq_17_I14_I4         |
| r787     | DW01_cmp6    | width=6    |               | eq_17_I15_I4         |
| r789     | DW01_cmp6    | width=6    |               | eq_17_I16_I4         |
| r791     | DW01_cmp6    | width=6    |               | eq_17_I17_I4         |
| r793     | DW01_cmp6    | width=6    |               | eq_17_I18_I4         |
| r795     | DW01_cmp6    | width=6    |               | eq_17_I19_I4         |
| r797     | DW01_cmp6    | width=6    |               | eq_17_I20_I4         |
| r799     | DW01_cmp6    | width=6    |               | eq_17_I21_I4         |
| r801     | DW01_cmp6    | width=6    |               | eq_17_I22_I4         |
| r803     | DW01_cmp6    | width=6    |               | eq_17_I23_I4         |
| r805     | DW01_cmp6    | width=6    |               | eq_17_I24_I4         |
| r807     | DW01_cmp6    | width=6    |               | eq_17_I25_I4         |
| r809     | DW01_cmp6    | width=6    |               | eq_17_I26_I4         |
| r811     | DW01_cmp6    | width=6    |               | eq_17_I27_I4         |
| r813     | DW01_cmp6    | width=6    |               | eq_17_I28_I4         |
| r815     | DW01_cmp6    | width=6    |               | eq_17_I29_I4         |
| r817     | DW01_cmp6    | width=6    |               | eq_17_I30_I4         |
| r819     | DW01_cmp6    | width=6    |               | eq_17_I31_I4         |
| r821     | DW01_cmp6    | width=6    |               | eq_17_I32_I4         |
===============================================================================


No implementations to report
 
****************************************
Design : ROB
****************************************
Resource Sharing Report for design ROB in file
        /home/yiroug/Desktop/pipeline/verilog/ROB.sv

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r3322    | DW01_cmp2    | width=5    |               | lte_163_I2           |
|          |              |            |               | lte_172_I2           |
| r3323    | DW01_cmp2    | width=5    |               | gt_163_I2 gt_172_I2  |
| r3324    | DW01_cmp2    | width=5    |               | lte_163_I3           |
|          |              |            |               | lte_172_I3           |
| r3325    | DW01_cmp2    | width=5    |               | gt_163_I3 gt_172_I3  |
| r3326    | DW01_cmp2    | width=5    |               | lte_163_I4           |
|          |              |            |               | lte_172_I4           |
| r3327    | DW01_cmp2    | width=5    |               | gt_163_I4 gt_172_I4  |
| r3328    | DW01_cmp2    | width=5    |               | lte_163_I5           |
|          |              |            |               | lte_172_I5           |
| r3329    | DW01_cmp2    | width=5    |               | gt_163_I5 gt_172_I5  |
| r3330    | DW01_cmp2    | width=5    |               | lte_163_I6           |
|          |              |            |               | lte_172_I6           |
| r3331    | DW01_cmp2    | width=5    |               | gt_163_I6 gt_172_I6  |
| r3332    | DW01_cmp2    | width=5    |               | lte_163_I7           |
|          |              |            |               | lte_172_I7           |
| r3333    | DW01_cmp2    | width=5    |               | gt_163_I7 gt_172_I7  |
| r3334    | DW01_cmp2    | width=5    |               | lte_163_I8           |
|          |              |            |               | lte_172_I8           |
| r3335    | DW01_cmp2    | width=5    |               | gt_163_I8 gt_172_I8  |
| r3336    | DW01_cmp2    | width=5    |               | lte_163_I9           |
|          |              |            |               | lte_172_I9           |
| r3337    | DW01_cmp2    | width=5    |               | gt_163_I9 gt_172_I9  |
| r3338    | DW01_cmp2    | width=5    |               | lte_163_I10          |
|          |              |            |               | lte_172_I10          |
| r3339    | DW01_cmp2    | width=5    |               | gt_163_I10           |
|          |              |            |               | gt_172_I10           |
| r3340    | DW01_cmp2    | width=5    |               | lte_163_I11          |
|          |              |            |               | lte_172_I11          |
| r3341    | DW01_cmp2    | width=5    |               | gt_163_I11           |
|          |              |            |               | gt_172_I11           |
| r3342    | DW01_cmp2    | width=5    |               | lte_163_I12          |
|          |              |            |               | lte_172_I12          |
| r3343    | DW01_cmp2    | width=5    |               | gt_163_I12           |
|          |              |            |               | gt_172_I12           |
| r3344    | DW01_cmp2    | width=5    |               | lte_163_I13          |
|          |              |            |               | lte_172_I13          |
| r3345    | DW01_cmp2    | width=5    |               | gt_163_I13           |
|          |              |            |               | gt_172_I13           |
| r3346    | DW01_cmp2    | width=5    |               | lte_163_I14          |
|          |              |            |               | lte_172_I14          |
| r3347    | DW01_cmp2    | width=5    |               | gt_163_I14           |
|          |              |            |               | gt_172_I14           |
| r3348    | DW01_cmp2    | width=5    |               | lte_163_I15          |
|          |              |            |               | lte_172_I15          |
| r3349    | DW01_cmp2    | width=5    |               | gt_163_I15           |
|          |              |            |               | gt_172_I15           |
| r3350    | DW01_cmp2    | width=5    |               | lte_163_I16          |
|          |              |            |               | lte_172_I16          |
| r3351    | DW01_cmp2    | width=5    |               | gt_163_I16           |
|          |              |            |               | gt_172_I16           |
| r3352    | DW01_cmp2    | width=5    |               | lte_163_I17          |
|          |              |            |               | lte_172_I17          |
| r3353    | DW01_cmp2    | width=5    |               | gt_163_I17           |
|          |              |            |               | gt_172_I17           |
| r3354    | DW01_cmp2    | width=5    |               | lte_163_I18          |
|          |              |            |               | lte_172_I18          |
| r3355    | DW01_cmp2    | width=5    |               | gt_163_I18           |
|          |              |            |               | gt_172_I18           |
| r3356    | DW01_cmp2    | width=5    |               | lte_163_I19          |
|          |              |            |               | lte_172_I19          |
| r3357    | DW01_cmp2    | width=5    |               | gt_163_I19           |
|          |              |            |               | gt_172_I19           |
| r3358    | DW01_cmp2    | width=5    |               | lte_163_I20          |
|          |              |            |               | lte_172_I20          |
| r3359    | DW01_cmp2    | width=5    |               | gt_163_I20           |
|          |              |            |               | gt_172_I20           |
| r3360    | DW01_cmp2    | width=5    |               | lte_163_I21          |
|          |              |            |               | lte_172_I21          |
| r3361    | DW01_cmp2    | width=5    |               | gt_163_I21           |
|          |              |            |               | gt_172_I21           |
| r3362    | DW01_cmp2    | width=5    |               | lte_163_I22          |
|          |              |            |               | lte_172_I22          |
| r3363    | DW01_cmp2    | width=5    |               | gt_163_I22           |
|          |              |            |               | gt_172_I22           |
| r3364    | DW01_cmp2    | width=5    |               | lte_163_I23          |
|          |              |            |               | lte_172_I23          |
| r3365    | DW01_cmp2    | width=5    |               | gt_163_I23           |
|          |              |            |               | gt_172_I23           |
| r3366    | DW01_cmp2    | width=5    |               | lte_163_I24          |
|          |              |            |               | lte_172_I24          |
| r3367    | DW01_cmp2    | width=5    |               | gt_163_I24           |
|          |              |            |               | gt_172_I24           |
| r3368    | DW01_cmp2    | width=5    |               | lte_163_I25          |
|          |              |            |               | lte_172_I25          |
| r3369    | DW01_cmp2    | width=5    |               | gt_163_I25           |
|          |              |            |               | gt_172_I25           |
| r3370    | DW01_cmp2    | width=5    |               | lte_163_I26          |
|          |              |            |               | lte_172_I26          |
| r3371    | DW01_cmp2    | width=5    |               | gt_163_I26           |
|          |              |            |               | gt_172_I26           |
| r3372    | DW01_cmp2    | width=5    |               | lte_163_I27          |
|          |              |            |               | lte_172_I27          |
| r3373    | DW01_cmp2    | width=5    |               | gt_163_I27           |
|          |              |            |               | gt_172_I27           |
| r3374    | DW01_cmp2    | width=5    |               | lte_163_I28          |
|          |              |            |               | lte_172_I28          |
| r3375    | DW01_cmp2    | width=5    |               | gt_163_I28           |
|          |              |            |               | gt_172_I28           |
| r3376    | DW01_cmp2    | width=5    |               | lte_163_I29          |
|          |              |            |               | lte_172_I29          |
| r3377    | DW01_cmp2    | width=5    |               | gt_163_I29           |
|          |              |            |               | gt_172_I29           |
| r3378    | DW01_cmp2    | width=5    |               | lte_163_I30          |
|          |              |            |               | lte_172_I30          |
| r3379    | DW01_cmp2    | width=5    |               | gt_163_I30           |
|          |              |            |               | gt_172_I30           |
| r3380    | DW01_cmp2    | width=5    |               | lte_163_I31          |
|          |              |            |               | lte_172_I31          |
| r3381    | DW01_cmp2    | width=5    |               | gt_163_I31           |
|          |              |            |               | gt_172_I31           |
| r3382    | DW01_cmp2    | width=5    |               | lte_163_I32          |
|          |              |            |               | lte_172_I32          |
| r3383    | DW01_cmp2    | width=5    |               | gt_163_I32           |
|          |              |            |               | gt_172_I32           |
| r3398    | DW01_cmp2    | width=6    |               | gt_30                |
| r3400    | DW01_inc     | width=6    |               | add_98               |
| r3402    | DW01_inc     | width=6    |               | add_114              |
| r3404    | DW01_inc     | width=6    |               | add_98_I2            |
| r3406    | DW01_inc     | width=6    |               | add_114_I2           |
| r3408    | DW01_inc     | width=6    |               | add_98_I3            |
| r3410    | DW01_inc     | width=6    |               | add_114_I3           |
| r3412    | DW01_inc     | width=6    |               | add_98_I4            |
| r3414    | DW01_inc     | width=6    |               | add_114_I4           |
| r3525    | DW01_sub     | width=6    |               | sub_205              |
| r3527    | DW01_sub     | width=6    |               | sub_1_root_sub_205_3 |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| sub_205            | DW01_sub         | rpl                |                |
===============================================================================

 
****************************************
Design : RAT
****************************************
Resource Sharing Report for design RAT in file
        /home/yiroug/Desktop/pipeline/verilog/RAT.sv

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r1040    | DW01_cmp6    | width=6    |               | eq_38                |
| r1042    | DW01_cmp6    | width=6    |               | eq_38_I2_I1          |
| r1044    | DW01_cmp6    | width=6    |               | eq_38_I3_I1          |
| r1046    | DW01_cmp6    | width=6    |               | eq_38_I4_I1          |
| r1048    | DW01_cmp6    | width=6    |               | eq_38_I5_I1          |
| r1050    | DW01_cmp6    | width=6    |               | eq_38_I6_I1          |
| r1052    | DW01_cmp6    | width=6    |               | eq_38_I7_I1          |
| r1054    | DW01_cmp6    | width=6    |               | eq_38_I8_I1          |
| r1056    | DW01_cmp6    | width=6    |               | eq_38_I9_I1          |
| r1058    | DW01_cmp6    | width=6    |               | eq_38_I10_I1         |
| r1060    | DW01_cmp6    | width=6    |               | eq_38_I11_I1         |
| r1062    | DW01_cmp6    | width=6    |               | eq_38_I12_I1         |
| r1064    | DW01_cmp6    | width=6    |               | eq_38_I13_I1         |
| r1066    | DW01_cmp6    | width=6    |               | eq_38_I14_I1         |
| r1068    | DW01_cmp6    | width=6    |               | eq_38_I15_I1         |
| r1070    | DW01_cmp6    | width=6    |               | eq_38_I16_I1         |
| r1072    | DW01_cmp6    | width=6    |               | eq_38_I17_I1         |
| r1074    | DW01_cmp6    | width=6    |               | eq_38_I18_I1         |
| r1076    | DW01_cmp6    | width=6    |               | eq_38_I19_I1         |
| r1078    | DW01_cmp6    | width=6    |               | eq_38_I20_I1         |
| r1080    | DW01_cmp6    | width=6    |               | eq_38_I21_I1         |
| r1082    | DW01_cmp6    | width=6    |               | eq_38_I22_I1         |
| r1084    | DW01_cmp6    | width=6    |               | eq_38_I23_I1         |
| r1086    | DW01_cmp6    | width=6    |               | eq_38_I24_I1         |
| r1088    | DW01_cmp6    | width=6    |               | eq_38_I25_I1         |
| r1090    | DW01_cmp6    | width=6    |               | eq_38_I26_I1         |
| r1092    | DW01_cmp6    | width=6    |               | eq_38_I27_I1         |
| r1094    | DW01_cmp6    | width=6    |               | eq_38_I28_I1         |
| r1096    | DW01_cmp6    | width=6    |               | eq_38_I29_I1         |
| r1098    | DW01_cmp6    | width=6    |               | eq_38_I30_I1         |
| r1100    | DW01_cmp6    | width=6    |               | eq_38_I31_I1         |
| r1102    | DW01_cmp6    | width=6    |               | eq_38_I32_I1         |
| r1104    | DW01_cmp6    | width=6    |               | eq_38_I2             |
| r1106    | DW01_cmp6    | width=6    |               | eq_38_I2_I2          |
| r1108    | DW01_cmp6    | width=6    |               | eq_38_I3_I2          |
| r1110    | DW01_cmp6    | width=6    |               | eq_38_I4_I2          |
| r1112    | DW01_cmp6    | width=6    |               | eq_38_I5_I2          |
| r1114    | DW01_cmp6    | width=6    |               | eq_38_I6_I2          |
| r1116    | DW01_cmp6    | width=6    |               | eq_38_I7_I2          |
| r1118    | DW01_cmp6    | width=6    |               | eq_38_I8_I2          |
| r1120    | DW01_cmp6    | width=6    |               | eq_38_I9_I2          |
| r1122    | DW01_cmp6    | width=6    |               | eq_38_I10_I2         |
| r1124    | DW01_cmp6    | width=6    |               | eq_38_I11_I2         |
| r1126    | DW01_cmp6    | width=6    |               | eq_38_I12_I2         |
| r1128    | DW01_cmp6    | width=6    |               | eq_38_I13_I2         |
| r1130    | DW01_cmp6    | width=6    |               | eq_38_I14_I2         |
| r1132    | DW01_cmp6    | width=6    |               | eq_38_I15_I2         |
| r1134    | DW01_cmp6    | width=6    |               | eq_38_I16_I2         |
| r1136    | DW01_cmp6    | width=6    |               | eq_38_I17_I2         |
| r1138    | DW01_cmp6    | width=6    |               | eq_38_I18_I2         |
| r1140    | DW01_cmp6    | width=6    |               | eq_38_I19_I2         |
| r1142    | DW01_cmp6    | width=6    |               | eq_38_I20_I2         |
| r1144    | DW01_cmp6    | width=6    |               | eq_38_I21_I2         |
| r1146    | DW01_cmp6    | width=6    |               | eq_38_I22_I2         |
| r1148    | DW01_cmp6    | width=6    |               | eq_38_I23_I2         |
| r1150    | DW01_cmp6    | width=6    |               | eq_38_I24_I2         |
| r1152    | DW01_cmp6    | width=6    |               | eq_38_I25_I2         |
| r1154    | DW01_cmp6    | width=6    |               | eq_38_I26_I2         |
| r1156    | DW01_cmp6    | width=6    |               | eq_38_I27_I2         |
| r1158    | DW01_cmp6    | width=6    |               | eq_38_I28_I2         |
| r1160    | DW01_cmp6    | width=6    |               | eq_38_I29_I2         |
| r1162    | DW01_cmp6    | width=6    |               | eq_38_I30_I2         |
| r1164    | DW01_cmp6    | width=6    |               | eq_38_I31_I2         |
| r1166    | DW01_cmp6    | width=6    |               | eq_38_I32_I2         |
| r1168    | DW01_cmp6    | width=6    |               | eq_38_I3             |
| r1170    | DW01_cmp6    | width=6    |               | eq_38_I2_I3          |
| r1172    | DW01_cmp6    | width=6    |               | eq_38_I3_I3          |
| r1174    | DW01_cmp6    | width=6    |               | eq_38_I4_I3          |
| r1176    | DW01_cmp6    | width=6    |               | eq_38_I5_I3          |
| r1178    | DW01_cmp6    | width=6    |               | eq_38_I6_I3          |
| r1180    | DW01_cmp6    | width=6    |               | eq_38_I7_I3          |
| r1182    | DW01_cmp6    | width=6    |               | eq_38_I8_I3          |
| r1184    | DW01_cmp6    | width=6    |               | eq_38_I9_I3          |
| r1186    | DW01_cmp6    | width=6    |               | eq_38_I10_I3         |
| r1188    | DW01_cmp6    | width=6    |               | eq_38_I11_I3         |
| r1190    | DW01_cmp6    | width=6    |               | eq_38_I12_I3         |
| r1192    | DW01_cmp6    | width=6    |               | eq_38_I13_I3         |
| r1194    | DW01_cmp6    | width=6    |               | eq_38_I14_I3         |
| r1196    | DW01_cmp6    | width=6    |               | eq_38_I15_I3         |
| r1198    | DW01_cmp6    | width=6    |               | eq_38_I16_I3         |
| r1200    | DW01_cmp6    | width=6    |               | eq_38_I17_I3         |
| r1202    | DW01_cmp6    | width=6    |               | eq_38_I18_I3         |
| r1204    | DW01_cmp6    | width=6    |               | eq_38_I19_I3         |
| r1206    | DW01_cmp6    | width=6    |               | eq_38_I20_I3         |
| r1208    | DW01_cmp6    | width=6    |               | eq_38_I21_I3         |
| r1210    | DW01_cmp6    | width=6    |               | eq_38_I22_I3         |
| r1212    | DW01_cmp6    | width=6    |               | eq_38_I23_I3         |
| r1214    | DW01_cmp6    | width=6    |               | eq_38_I24_I3         |
| r1216    | DW01_cmp6    | width=6    |               | eq_38_I25_I3         |
| r1218    | DW01_cmp6    | width=6    |               | eq_38_I26_I3         |
| r1220    | DW01_cmp6    | width=6    |               | eq_38_I27_I3         |
| r1222    | DW01_cmp6    | width=6    |               | eq_38_I28_I3         |
| r1224    | DW01_cmp6    | width=6    |               | eq_38_I29_I3         |
| r1226    | DW01_cmp6    | width=6    |               | eq_38_I30_I3         |
| r1228    | DW01_cmp6    | width=6    |               | eq_38_I31_I3         |
| r1230    | DW01_cmp6    | width=6    |               | eq_38_I32_I3         |
| r1232    | DW01_cmp6    | width=6    |               | eq_38_I4             |
| r1234    | DW01_cmp6    | width=6    |               | eq_38_I2_I4          |
| r1236    | DW01_cmp6    | width=6    |               | eq_38_I3_I4          |
| r1238    | DW01_cmp6    | width=6    |               | eq_38_I4_I4          |
| r1240    | DW01_cmp6    | width=6    |               | eq_38_I5_I4          |
| r1242    | DW01_cmp6    | width=6    |               | eq_38_I6_I4          |
| r1244    | DW01_cmp6    | width=6    |               | eq_38_I7_I4          |
| r1246    | DW01_cmp6    | width=6    |               | eq_38_I8_I4          |
| r1248    | DW01_cmp6    | width=6    |               | eq_38_I9_I4          |
| r1250    | DW01_cmp6    | width=6    |               | eq_38_I10_I4         |
| r1252    | DW01_cmp6    | width=6    |               | eq_38_I11_I4         |
| r1254    | DW01_cmp6    | width=6    |               | eq_38_I12_I4         |
| r1256    | DW01_cmp6    | width=6    |               | eq_38_I13_I4         |
| r1258    | DW01_cmp6    | width=6    |               | eq_38_I14_I4         |
| r1260    | DW01_cmp6    | width=6    |               | eq_38_I15_I4         |
| r1262    | DW01_cmp6    | width=6    |               | eq_38_I16_I4         |
| r1264    | DW01_cmp6    | width=6    |               | eq_38_I17_I4         |
| r1266    | DW01_cmp6    | width=6    |               | eq_38_I18_I4         |
| r1268    | DW01_cmp6    | width=6    |               | eq_38_I19_I4         |
| r1270    | DW01_cmp6    | width=6    |               | eq_38_I20_I4         |
| r1272    | DW01_cmp6    | width=6    |               | eq_38_I21_I4         |
| r1274    | DW01_cmp6    | width=6    |               | eq_38_I22_I4         |
| r1276    | DW01_cmp6    | width=6    |               | eq_38_I23_I4         |
| r1278    | DW01_cmp6    | width=6    |               | eq_38_I24_I4         |
| r1280    | DW01_cmp6    | width=6    |               | eq_38_I25_I4         |
| r1282    | DW01_cmp6    | width=6    |               | eq_38_I26_I4         |
| r1284    | DW01_cmp6    | width=6    |               | eq_38_I27_I4         |
| r1286    | DW01_cmp6    | width=6    |               | eq_38_I28_I4         |
| r1288    | DW01_cmp6    | width=6    |               | eq_38_I29_I4         |
| r1290    | DW01_cmp6    | width=6    |               | eq_38_I30_I4         |
| r1292    | DW01_cmp6    | width=6    |               | eq_38_I31_I4         |
| r1294    | DW01_cmp6    | width=6    |               | eq_38_I32_I4         |
| r1296    | DW01_cmp6    | width=6    |               | eq_102               |
| r1298    | DW01_cmp6    | width=6    |               | eq_104               |
| r1300    | DW01_cmp6    | width=6    |               | eq_102_I2_I1         |
| r1302    | DW01_cmp6    | width=6    |               | eq_104_I2_I1         |
| r1304    | DW01_cmp6    | width=6    |               | eq_102_I3_I1         |
| r1306    | DW01_cmp6    | width=6    |               | eq_104_I3_I1         |
| r1308    | DW01_cmp6    | width=6    |               | eq_102_I4_I1         |
| r1310    | DW01_cmp6    | width=6    |               | eq_104_I4_I1         |
| r1312    | DW01_cmp6    | width=5    |               | eq_72_I2             |
| r1314    | DW01_cmp6    | width=5    |               | eq_82_I2             |
| r1316    | DW01_cmp6    | width=5    |               | eq_92_I2             |
| r1318    | DW01_cmp6    | width=6    |               | eq_102_I2            |
| r1320    | DW01_cmp6    | width=6    |               | eq_104_I2            |
| r1322    | DW01_cmp6    | width=6    |               | eq_102_I2_I2         |
| r1324    | DW01_cmp6    | width=6    |               | eq_104_I2_I2         |
| r1326    | DW01_cmp6    | width=6    |               | eq_102_I3_I2         |
| r1328    | DW01_cmp6    | width=6    |               | eq_104_I3_I2         |
| r1330    | DW01_cmp6    | width=6    |               | eq_102_I4_I2         |
| r1332    | DW01_cmp6    | width=6    |               | eq_104_I4_I2         |
| r1334    | DW01_cmp6    | width=5    |               | eq_72_I3             |
| r1336    | DW01_cmp6    | width=5    |               | eq_82_I3             |
| r1338    | DW01_cmp6    | width=5    |               | eq_92_I3             |
| r1340    | DW01_cmp6    | width=5    |               | eq_72_I2_I3          |
| r1342    | DW01_cmp6    | width=5    |               | eq_82_I2_I3          |
| r1344    | DW01_cmp6    | width=5    |               | eq_92_I2_I3          |
| r1346    | DW01_cmp6    | width=6    |               | eq_102_I3            |
| r1348    | DW01_cmp6    | width=6    |               | eq_104_I3            |
| r1350    | DW01_cmp6    | width=6    |               | eq_102_I2_I3         |
| r1352    | DW01_cmp6    | width=6    |               | eq_104_I2_I3         |
| r1354    | DW01_cmp6    | width=6    |               | eq_102_I3_I3         |
| r1356    | DW01_cmp6    | width=6    |               | eq_104_I3_I3         |
| r1358    | DW01_cmp6    | width=6    |               | eq_102_I4_I3         |
| r1360    | DW01_cmp6    | width=6    |               | eq_104_I4_I3         |
| r1362    | DW01_cmp6    | width=5    |               | eq_72_I4             |
| r1364    | DW01_cmp6    | width=5    |               | eq_82_I4             |
| r1366    | DW01_cmp6    | width=5    |               | eq_92_I4             |
| r1368    | DW01_cmp6    | width=5    |               | eq_72_I2_I4          |
| r1370    | DW01_cmp6    | width=5    |               | eq_82_I2_I4          |
| r1372    | DW01_cmp6    | width=5    |               | eq_92_I2_I4          |
| r1374    | DW01_cmp6    | width=5    |               | eq_72_I3_I4          |
| r1376    | DW01_cmp6    | width=5    |               | eq_82_I3_I4          |
| r1378    | DW01_cmp6    | width=5    |               | eq_92_I3_I4          |
| r1380    | DW01_cmp6    | width=6    |               | eq_102_I4            |
| r1382    | DW01_cmp6    | width=6    |               | eq_104_I4            |
| r1384    | DW01_cmp6    | width=6    |               | eq_102_I2_I4         |
| r1386    | DW01_cmp6    | width=6    |               | eq_104_I2_I4         |
| r1388    | DW01_cmp6    | width=6    |               | eq_102_I3_I4         |
| r1390    | DW01_cmp6    | width=6    |               | eq_104_I3_I4         |
| r1392    | DW01_cmp6    | width=6    |               | eq_102_I4_I4         |
| r1394    | DW01_cmp6    | width=6    |               | eq_104_I4_I4         |
===============================================================================


No implementations to report
 
****************************************
Design : Freelist
****************************************
Resource Sharing Report for design Freelist in file
        /home/yiroug/Desktop/pipeline/verilog/Freelist.sv

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r411     | DW01_cmp2    | width=6    |               | gt_32                |
| r413     | DW01_inc     | width=6    |               | add_60               |
| r415     | DW01_inc     | width=6    |               | add_68               |
| r417     | DW01_inc     | width=6    |               | add_60_I2            |
| r419     | DW01_inc     | width=6    |               | add_68_I2            |
| r421     | DW01_inc     | width=6    |               | add_60_I3            |
| r423     | DW01_inc     | width=6    |               | add_68_I3            |
| r425     | DW01_inc     | width=6    |               | add_60_I4            |
| r427     | DW01_inc     | width=6    |               | add_68_I4            |
| r537     | DW01_sub     | width=6    |               | sub_1_root_add_102   |
| r539     | DW01_inc     | width=6    |               | add_0_root_add_102   |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| sub_1_root_add_102 | DW01_sub         | rpl                |                |
===============================================================================

 
****************************************
Design : BRAT
****************************************
Resource Sharing Report for design BRAT in file
        /home/yiroug/Desktop/pipeline/verilog/BRAT.sv

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r3116    | DW01_cmp2    | width=4    |               | gt_76                |
| r3118    | DW01_inc     | width=6    |               | add_86               |
| r3120    | DW01_inc     | width=6    |               | add_86_I2_I1         |
| r3122    | DW01_inc     | width=6    |               | add_86_I3_I1         |
| r3124    | DW01_inc     | width=6    |               | add_86_I4_I1         |
| r3126    | DW01_cmp6    | width=6    |               | eq_94                |
| r3128    | DW01_cmp6    | width=6    |               | eq_94_I2_I1_I1       |
| r3130    | DW01_cmp6    | width=6    |               | eq_94_I3_I1_I1       |
| r3132    | DW01_cmp6    | width=6    |               | eq_94_I4_I1_I1       |
| r3134    | DW01_cmp6    | width=6    |               | eq_94_I5_I1_I1       |
| r3136    | DW01_cmp6    | width=6    |               | eq_94_I6_I1_I1       |
| r3138    | DW01_cmp6    | width=6    |               | eq_94_I7_I1_I1       |
| r3140    | DW01_cmp6    | width=6    |               | eq_94_I8_I1_I1       |
| r3142    | DW01_cmp6    | width=6    |               | eq_94_I9_I1_I1       |
| r3144    | DW01_cmp6    | width=6    |               | eq_94_I10_I1_I1      |
| r3146    | DW01_cmp6    | width=6    |               | eq_94_I11_I1_I1      |
| r3148    | DW01_cmp6    | width=6    |               | eq_94_I12_I1_I1      |
| r3150    | DW01_cmp6    | width=6    |               | eq_94_I13_I1_I1      |
| r3152    | DW01_cmp6    | width=6    |               | eq_94_I14_I1_I1      |
| r3154    | DW01_cmp6    | width=6    |               | eq_94_I15_I1_I1      |
| r3156    | DW01_cmp6    | width=6    |               | eq_94_I16_I1_I1      |
| r3158    | DW01_cmp6    | width=6    |               | eq_94_I17_I1_I1      |
| r3160    | DW01_cmp6    | width=6    |               | eq_94_I18_I1_I1      |
| r3162    | DW01_cmp6    | width=6    |               | eq_94_I19_I1_I1      |
| r3164    | DW01_cmp6    | width=6    |               | eq_94_I20_I1_I1      |
| r3166    | DW01_cmp6    | width=6    |               | eq_94_I21_I1_I1      |
| r3168    | DW01_cmp6    | width=6    |               | eq_94_I22_I1_I1      |
| r3170    | DW01_cmp6    | width=6    |               | eq_94_I23_I1_I1      |
| r3172    | DW01_cmp6    | width=6    |               | eq_94_I24_I1_I1      |
| r3174    | DW01_cmp6    | width=6    |               | eq_94_I25_I1_I1      |
| r3176    | DW01_cmp6    | width=6    |               | eq_94_I26_I1_I1      |
| r3178    | DW01_cmp6    | width=6    |               | eq_94_I27_I1_I1      |
| r3180    | DW01_cmp6    | width=6    |               | eq_94_I28_I1_I1      |
| r3182    | DW01_cmp6    | width=6    |               | eq_94_I29_I1_I1      |
| r3184    | DW01_cmp6    | width=6    |               | eq_94_I30_I1_I1      |
| r3186    | DW01_cmp6    | width=6    |               | eq_94_I31_I1_I1      |
| r3188    | DW01_cmp6    | width=6    |               | eq_94_I32_I1_I1      |
| r3190    | DW01_cmp6    | width=6    |               | eq_94_I2_I1          |
| r3192    | DW01_cmp6    | width=6    |               | eq_94_I2_I2_I1       |
| r3194    | DW01_cmp6    | width=6    |               | eq_94_I3_I2_I1       |
| r3196    | DW01_cmp6    | width=6    |               | eq_94_I4_I2_I1       |
| r3198    | DW01_cmp6    | width=6    |               | eq_94_I5_I2_I1       |
| r3200    | DW01_cmp6    | width=6    |               | eq_94_I6_I2_I1       |
| r3202    | DW01_cmp6    | width=6    |               | eq_94_I7_I2_I1       |
| r3204    | DW01_cmp6    | width=6    |               | eq_94_I8_I2_I1       |
| r3206    | DW01_cmp6    | width=6    |               | eq_94_I9_I2_I1       |
| r3208    | DW01_cmp6    | width=6    |               | eq_94_I10_I2_I1      |
| r3210    | DW01_cmp6    | width=6    |               | eq_94_I11_I2_I1      |
| r3212    | DW01_cmp6    | width=6    |               | eq_94_I12_I2_I1      |
| r3214    | DW01_cmp6    | width=6    |               | eq_94_I13_I2_I1      |
| r3216    | DW01_cmp6    | width=6    |               | eq_94_I14_I2_I1      |
| r3218    | DW01_cmp6    | width=6    |               | eq_94_I15_I2_I1      |
| r3220    | DW01_cmp6    | width=6    |               | eq_94_I16_I2_I1      |
| r3222    | DW01_cmp6    | width=6    |               | eq_94_I17_I2_I1      |
| r3224    | DW01_cmp6    | width=6    |               | eq_94_I18_I2_I1      |
| r3226    | DW01_cmp6    | width=6    |               | eq_94_I19_I2_I1      |
| r3228    | DW01_cmp6    | width=6    |               | eq_94_I20_I2_I1      |
| r3230    | DW01_cmp6    | width=6    |               | eq_94_I21_I2_I1      |
| r3232    | DW01_cmp6    | width=6    |               | eq_94_I22_I2_I1      |
| r3234    | DW01_cmp6    | width=6    |               | eq_94_I23_I2_I1      |
| r3236    | DW01_cmp6    | width=6    |               | eq_94_I24_I2_I1      |
| r3238    | DW01_cmp6    | width=6    |               | eq_94_I25_I2_I1      |
| r3240    | DW01_cmp6    | width=6    |               | eq_94_I26_I2_I1      |
| r3242    | DW01_cmp6    | width=6    |               | eq_94_I27_I2_I1      |
| r3244    | DW01_cmp6    | width=6    |               | eq_94_I28_I2_I1      |
| r3246    | DW01_cmp6    | width=6    |               | eq_94_I29_I2_I1      |
| r3248    | DW01_cmp6    | width=6    |               | eq_94_I30_I2_I1      |
| r3250    | DW01_cmp6    | width=6    |               | eq_94_I31_I2_I1      |
| r3252    | DW01_cmp6    | width=6    |               | eq_94_I32_I2_I1      |
| r3254    | DW01_cmp6    | width=6    |               | eq_94_I3_I1          |
| r3256    | DW01_cmp6    | width=6    |               | eq_94_I2_I3_I1       |
| r3258    | DW01_cmp6    | width=6    |               | eq_94_I3_I3_I1       |
| r3260    | DW01_cmp6    | width=6    |               | eq_94_I4_I3_I1       |
| r3262    | DW01_cmp6    | width=6    |               | eq_94_I5_I3_I1       |
| r3264    | DW01_cmp6    | width=6    |               | eq_94_I6_I3_I1       |
| r3266    | DW01_cmp6    | width=6    |               | eq_94_I7_I3_I1       |
| r3268    | DW01_cmp6    | width=6    |               | eq_94_I8_I3_I1       |
| r3270    | DW01_cmp6    | width=6    |               | eq_94_I9_I3_I1       |
| r3272    | DW01_cmp6    | width=6    |               | eq_94_I10_I3_I1      |
| r3274    | DW01_cmp6    | width=6    |               | eq_94_I11_I3_I1      |
| r3276    | DW01_cmp6    | width=6    |               | eq_94_I12_I3_I1      |
| r3278    | DW01_cmp6    | width=6    |               | eq_94_I13_I3_I1      |
| r3280    | DW01_cmp6    | width=6    |               | eq_94_I14_I3_I1      |
| r3282    | DW01_cmp6    | width=6    |               | eq_94_I15_I3_I1      |
| r3284    | DW01_cmp6    | width=6    |               | eq_94_I16_I3_I1      |
| r3286    | DW01_cmp6    | width=6    |               | eq_94_I17_I3_I1      |
| r3288    | DW01_cmp6    | width=6    |               | eq_94_I18_I3_I1      |
| r3290    | DW01_cmp6    | width=6    |               | eq_94_I19_I3_I1      |
| r3292    | DW01_cmp6    | width=6    |               | eq_94_I20_I3_I1      |
| r3294    | DW01_cmp6    | width=6    |               | eq_94_I21_I3_I1      |
| r3296    | DW01_cmp6    | width=6    |               | eq_94_I22_I3_I1      |
| r3298    | DW01_cmp6    | width=6    |               | eq_94_I23_I3_I1      |
| r3300    | DW01_cmp6    | width=6    |               | eq_94_I24_I3_I1      |
| r3302    | DW01_cmp6    | width=6    |               | eq_94_I25_I3_I1      |
| r3304    | DW01_cmp6    | width=6    |               | eq_94_I26_I3_I1      |
| r3306    | DW01_cmp6    | width=6    |               | eq_94_I27_I3_I1      |
| r3308    | DW01_cmp6    | width=6    |               | eq_94_I28_I3_I1      |
| r3310    | DW01_cmp6    | width=6    |               | eq_94_I29_I3_I1      |
| r3312    | DW01_cmp6    | width=6    |               | eq_94_I30_I3_I1      |
| r3314    | DW01_cmp6    | width=6    |               | eq_94_I31_I3_I1      |
| r3316    | DW01_cmp6    | width=6    |               | eq_94_I32_I3_I1      |
| r3318    | DW01_cmp6    | width=6    |               | eq_94_I4_I1          |
| r3320    | DW01_cmp6    | width=6    |               | eq_94_I2_I4_I1       |
| r3322    | DW01_cmp6    | width=6    |               | eq_94_I3_I4_I1       |
| r3324    | DW01_cmp6    | width=6    |               | eq_94_I4_I4_I1       |
| r3326    | DW01_cmp6    | width=6    |               | eq_94_I5_I4_I1       |
| r3328    | DW01_cmp6    | width=6    |               | eq_94_I6_I4_I1       |
| r3330    | DW01_cmp6    | width=6    |               | eq_94_I7_I4_I1       |
| r3332    | DW01_cmp6    | width=6    |               | eq_94_I8_I4_I1       |
| r3334    | DW01_cmp6    | width=6    |               | eq_94_I9_I4_I1       |
| r3336    | DW01_cmp6    | width=6    |               | eq_94_I10_I4_I1      |
| r3338    | DW01_cmp6    | width=6    |               | eq_94_I11_I4_I1      |
| r3340    | DW01_cmp6    | width=6    |               | eq_94_I12_I4_I1      |
| r3342    | DW01_cmp6    | width=6    |               | eq_94_I13_I4_I1      |
| r3344    | DW01_cmp6    | width=6    |               | eq_94_I14_I4_I1      |
| r3346    | DW01_cmp6    | width=6    |               | eq_94_I15_I4_I1      |
| r3348    | DW01_cmp6    | width=6    |               | eq_94_I16_I4_I1      |
| r3350    | DW01_cmp6    | width=6    |               | eq_94_I17_I4_I1      |
| r3352    | DW01_cmp6    | width=6    |               | eq_94_I18_I4_I1      |
| r3354    | DW01_cmp6    | width=6    |               | eq_94_I19_I4_I1      |
| r3356    | DW01_cmp6    | width=6    |               | eq_94_I20_I4_I1      |
| r3358    | DW01_cmp6    | width=6    |               | eq_94_I21_I4_I1      |
| r3360    | DW01_cmp6    | width=6    |               | eq_94_I22_I4_I1      |
| r3362    | DW01_cmp6    | width=6    |               | eq_94_I23_I4_I1      |
| r3364    | DW01_cmp6    | width=6    |               | eq_94_I24_I4_I1      |
| r3366    | DW01_cmp6    | width=6    |               | eq_94_I25_I4_I1      |
| r3368    | DW01_cmp6    | width=6    |               | eq_94_I26_I4_I1      |
| r3370    | DW01_cmp6    | width=6    |               | eq_94_I27_I4_I1      |
| r3372    | DW01_cmp6    | width=6    |               | eq_94_I28_I4_I1      |
| r3374    | DW01_cmp6    | width=6    |               | eq_94_I29_I4_I1      |
| r3376    | DW01_cmp6    | width=6    |               | eq_94_I30_I4_I1      |
| r3378    | DW01_cmp6    | width=6    |               | eq_94_I31_I4_I1      |
| r3380    | DW01_cmp6    | width=6    |               | eq_94_I32_I4_I1      |
| r3382    | DW01_inc     | width=6    |               | add_86_I2            |
| r3384    | DW01_inc     | width=6    |               | add_86_I2_I2         |
| r3386    | DW01_inc     | width=6    |               | add_86_I3_I2         |
| r3388    | DW01_inc     | width=6    |               | add_86_I4_I2         |
| r3390    | DW01_cmp6    | width=6    |               | eq_94_I2             |
| r3392    | DW01_cmp6    | width=6    |               | eq_94_I2_I1_I2       |
| r3394    | DW01_cmp6    | width=6    |               | eq_94_I3_I1_I2       |
| r3396    | DW01_cmp6    | width=6    |               | eq_94_I4_I1_I2       |
| r3398    | DW01_cmp6    | width=6    |               | eq_94_I5_I1_I2       |
| r3400    | DW01_cmp6    | width=6    |               | eq_94_I6_I1_I2       |
| r3402    | DW01_cmp6    | width=6    |               | eq_94_I7_I1_I2       |
| r3404    | DW01_cmp6    | width=6    |               | eq_94_I8_I1_I2       |
| r3406    | DW01_cmp6    | width=6    |               | eq_94_I9_I1_I2       |
| r3408    | DW01_cmp6    | width=6    |               | eq_94_I10_I1_I2      |
| r3410    | DW01_cmp6    | width=6    |               | eq_94_I11_I1_I2      |
| r3412    | DW01_cmp6    | width=6    |               | eq_94_I12_I1_I2      |
| r3414    | DW01_cmp6    | width=6    |               | eq_94_I13_I1_I2      |
| r3416    | DW01_cmp6    | width=6    |               | eq_94_I14_I1_I2      |
| r3418    | DW01_cmp6    | width=6    |               | eq_94_I15_I1_I2      |
| r3420    | DW01_cmp6    | width=6    |               | eq_94_I16_I1_I2      |
| r3422    | DW01_cmp6    | width=6    |               | eq_94_I17_I1_I2      |
| r3424    | DW01_cmp6    | width=6    |               | eq_94_I18_I1_I2      |
| r3426    | DW01_cmp6    | width=6    |               | eq_94_I19_I1_I2      |
| r3428    | DW01_cmp6    | width=6    |               | eq_94_I20_I1_I2      |
| r3430    | DW01_cmp6    | width=6    |               | eq_94_I21_I1_I2      |
| r3432    | DW01_cmp6    | width=6    |               | eq_94_I22_I1_I2      |
| r3434    | DW01_cmp6    | width=6    |               | eq_94_I23_I1_I2      |
| r3436    | DW01_cmp6    | width=6    |               | eq_94_I24_I1_I2      |
| r3438    | DW01_cmp6    | width=6    |               | eq_94_I25_I1_I2      |
| r3440    | DW01_cmp6    | width=6    |               | eq_94_I26_I1_I2      |
| r3442    | DW01_cmp6    | width=6    |               | eq_94_I27_I1_I2      |
| r3444    | DW01_cmp6    | width=6    |               | eq_94_I28_I1_I2      |
| r3446    | DW01_cmp6    | width=6    |               | eq_94_I29_I1_I2      |
| r3448    | DW01_cmp6    | width=6    |               | eq_94_I30_I1_I2      |
| r3450    | DW01_cmp6    | width=6    |               | eq_94_I31_I1_I2      |
| r3452    | DW01_cmp6    | width=6    |               | eq_94_I32_I1_I2      |
| r3454    | DW01_cmp6    | width=6    |               | eq_94_I2_I2          |
| r3456    | DW01_cmp6    | width=6    |               | eq_94_I2_I2_I2       |
| r3458    | DW01_cmp6    | width=6    |               | eq_94_I3_I2_I2       |
| r3460    | DW01_cmp6    | width=6    |               | eq_94_I4_I2_I2       |
| r3462    | DW01_cmp6    | width=6    |               | eq_94_I5_I2_I2       |
| r3464    | DW01_cmp6    | width=6    |               | eq_94_I6_I2_I2       |
| r3466    | DW01_cmp6    | width=6    |               | eq_94_I7_I2_I2       |
| r3468    | DW01_cmp6    | width=6    |               | eq_94_I8_I2_I2       |
| r3470    | DW01_cmp6    | width=6    |               | eq_94_I9_I2_I2       |
| r3472    | DW01_cmp6    | width=6    |               | eq_94_I10_I2_I2      |
| r3474    | DW01_cmp6    | width=6    |               | eq_94_I11_I2_I2      |
| r3476    | DW01_cmp6    | width=6    |               | eq_94_I12_I2_I2      |
| r3478    | DW01_cmp6    | width=6    |               | eq_94_I13_I2_I2      |
| r3480    | DW01_cmp6    | width=6    |               | eq_94_I14_I2_I2      |
| r3482    | DW01_cmp6    | width=6    |               | eq_94_I15_I2_I2      |
| r3484    | DW01_cmp6    | width=6    |               | eq_94_I16_I2_I2      |
| r3486    | DW01_cmp6    | width=6    |               | eq_94_I17_I2_I2      |
| r3488    | DW01_cmp6    | width=6    |               | eq_94_I18_I2_I2      |
| r3490    | DW01_cmp6    | width=6    |               | eq_94_I19_I2_I2      |
| r3492    | DW01_cmp6    | width=6    |               | eq_94_I20_I2_I2      |
| r3494    | DW01_cmp6    | width=6    |               | eq_94_I21_I2_I2      |
| r3496    | DW01_cmp6    | width=6    |               | eq_94_I22_I2_I2      |
| r3498    | DW01_cmp6    | width=6    |               | eq_94_I23_I2_I2      |
| r3500    | DW01_cmp6    | width=6    |               | eq_94_I24_I2_I2      |
| r3502    | DW01_cmp6    | width=6    |               | eq_94_I25_I2_I2      |
| r3504    | DW01_cmp6    | width=6    |               | eq_94_I26_I2_I2      |
| r3506    | DW01_cmp6    | width=6    |               | eq_94_I27_I2_I2      |
| r3508    | DW01_cmp6    | width=6    |               | eq_94_I28_I2_I2      |
| r3510    | DW01_cmp6    | width=6    |               | eq_94_I29_I2_I2      |
| r3512    | DW01_cmp6    | width=6    |               | eq_94_I30_I2_I2      |
| r3514    | DW01_cmp6    | width=6    |               | eq_94_I31_I2_I2      |
| r3516    | DW01_cmp6    | width=6    |               | eq_94_I32_I2_I2      |
| r3518    | DW01_cmp6    | width=6    |               | eq_94_I3_I2          |
| r3520    | DW01_cmp6    | width=6    |               | eq_94_I2_I3_I2       |
| r3522    | DW01_cmp6    | width=6    |               | eq_94_I3_I3_I2       |
| r3524    | DW01_cmp6    | width=6    |               | eq_94_I4_I3_I2       |
| r3526    | DW01_cmp6    | width=6    |               | eq_94_I5_I3_I2       |
| r3528    | DW01_cmp6    | width=6    |               | eq_94_I6_I3_I2       |
| r3530    | DW01_cmp6    | width=6    |               | eq_94_I7_I3_I2       |
| r3532    | DW01_cmp6    | width=6    |               | eq_94_I8_I3_I2       |
| r3534    | DW01_cmp6    | width=6    |               | eq_94_I9_I3_I2       |
| r3536    | DW01_cmp6    | width=6    |               | eq_94_I10_I3_I2      |
| r3538    | DW01_cmp6    | width=6    |               | eq_94_I11_I3_I2      |
| r3540    | DW01_cmp6    | width=6    |               | eq_94_I12_I3_I2      |
| r3542    | DW01_cmp6    | width=6    |               | eq_94_I13_I3_I2      |
| r3544    | DW01_cmp6    | width=6    |               | eq_94_I14_I3_I2      |
| r3546    | DW01_cmp6    | width=6    |               | eq_94_I15_I3_I2      |
| r3548    | DW01_cmp6    | width=6    |               | eq_94_I16_I3_I2      |
| r3550    | DW01_cmp6    | width=6    |               | eq_94_I17_I3_I2      |
| r3552    | DW01_cmp6    | width=6    |               | eq_94_I18_I3_I2      |
| r3554    | DW01_cmp6    | width=6    |               | eq_94_I19_I3_I2      |
| r3556    | DW01_cmp6    | width=6    |               | eq_94_I20_I3_I2      |
| r3558    | DW01_cmp6    | width=6    |               | eq_94_I21_I3_I2      |
| r3560    | DW01_cmp6    | width=6    |               | eq_94_I22_I3_I2      |
| r3562    | DW01_cmp6    | width=6    |               | eq_94_I23_I3_I2      |
| r3564    | DW01_cmp6    | width=6    |               | eq_94_I24_I3_I2      |
| r3566    | DW01_cmp6    | width=6    |               | eq_94_I25_I3_I2      |
| r3568    | DW01_cmp6    | width=6    |               | eq_94_I26_I3_I2      |
| r3570    | DW01_cmp6    | width=6    |               | eq_94_I27_I3_I2      |
| r3572    | DW01_cmp6    | width=6    |               | eq_94_I28_I3_I2      |
| r3574    | DW01_cmp6    | width=6    |               | eq_94_I29_I3_I2      |
| r3576    | DW01_cmp6    | width=6    |               | eq_94_I30_I3_I2      |
| r3578    | DW01_cmp6    | width=6    |               | eq_94_I31_I3_I2      |
| r3580    | DW01_cmp6    | width=6    |               | eq_94_I32_I3_I2      |
| r3582    | DW01_cmp6    | width=6    |               | eq_94_I4_I2          |
| r3584    | DW01_cmp6    | width=6    |               | eq_94_I2_I4_I2       |
| r3586    | DW01_cmp6    | width=6    |               | eq_94_I3_I4_I2       |
| r3588    | DW01_cmp6    | width=6    |               | eq_94_I4_I4_I2       |
| r3590    | DW01_cmp6    | width=6    |               | eq_94_I5_I4_I2       |
| r3592    | DW01_cmp6    | width=6    |               | eq_94_I6_I4_I2       |
| r3594    | DW01_cmp6    | width=6    |               | eq_94_I7_I4_I2       |
| r3596    | DW01_cmp6    | width=6    |               | eq_94_I8_I4_I2       |
| r3598    | DW01_cmp6    | width=6    |               | eq_94_I9_I4_I2       |
| r3600    | DW01_cmp6    | width=6    |               | eq_94_I10_I4_I2      |
| r3602    | DW01_cmp6    | width=6    |               | eq_94_I11_I4_I2      |
| r3604    | DW01_cmp6    | width=6    |               | eq_94_I12_I4_I2      |
| r3606    | DW01_cmp6    | width=6    |               | eq_94_I13_I4_I2      |
| r3608    | DW01_cmp6    | width=6    |               | eq_94_I14_I4_I2      |
| r3610    | DW01_cmp6    | width=6    |               | eq_94_I15_I4_I2      |
| r3612    | DW01_cmp6    | width=6    |               | eq_94_I16_I4_I2      |
| r3614    | DW01_cmp6    | width=6    |               | eq_94_I17_I4_I2      |
| r3616    | DW01_cmp6    | width=6    |               | eq_94_I18_I4_I2      |
| r3618    | DW01_cmp6    | width=6    |               | eq_94_I19_I4_I2      |
| r3620    | DW01_cmp6    | width=6    |               | eq_94_I20_I4_I2      |
| r3622    | DW01_cmp6    | width=6    |               | eq_94_I21_I4_I2      |
| r3624    | DW01_cmp6    | width=6    |               | eq_94_I22_I4_I2      |
| r3626    | DW01_cmp6    | width=6    |               | eq_94_I23_I4_I2      |
| r3628    | DW01_cmp6    | width=6    |               | eq_94_I24_I4_I2      |
| r3630    | DW01_cmp6    | width=6    |               | eq_94_I25_I4_I2      |
| r3632    | DW01_cmp6    | width=6    |               | eq_94_I26_I4_I2      |
| r3634    | DW01_cmp6    | width=6    |               | eq_94_I27_I4_I2      |
| r3636    | DW01_cmp6    | width=6    |               | eq_94_I28_I4_I2      |
| r3638    | DW01_cmp6    | width=6    |               | eq_94_I29_I4_I2      |
| r3640    | DW01_cmp6    | width=6    |               | eq_94_I30_I4_I2      |
| r3642    | DW01_cmp6    | width=6    |               | eq_94_I31_I4_I2      |
| r3644    | DW01_cmp6    | width=6    |               | eq_94_I32_I4_I2      |
| r3646    | DW01_inc     | width=6    |               | add_86_I3            |
| r3648    | DW01_inc     | width=6    |               | add_86_I2_I3         |
| r3650    | DW01_inc     | width=6    |               | add_86_I3_I3         |
| r3652    | DW01_inc     | width=6    |               | add_86_I4_I3         |
| r3654    | DW01_cmp6    | width=6    |               | eq_94_I3             |
| r3656    | DW01_cmp6    | width=6    |               | eq_94_I2_I1_I3       |
| r3658    | DW01_cmp6    | width=6    |               | eq_94_I3_I1_I3       |
| r3660    | DW01_cmp6    | width=6    |               | eq_94_I4_I1_I3       |
| r3662    | DW01_cmp6    | width=6    |               | eq_94_I5_I1_I3       |
| r3664    | DW01_cmp6    | width=6    |               | eq_94_I6_I1_I3       |
| r3666    | DW01_cmp6    | width=6    |               | eq_94_I7_I1_I3       |
| r3668    | DW01_cmp6    | width=6    |               | eq_94_I8_I1_I3       |
| r3670    | DW01_cmp6    | width=6    |               | eq_94_I9_I1_I3       |
| r3672    | DW01_cmp6    | width=6    |               | eq_94_I10_I1_I3      |
| r3674    | DW01_cmp6    | width=6    |               | eq_94_I11_I1_I3      |
| r3676    | DW01_cmp6    | width=6    |               | eq_94_I12_I1_I3      |
| r3678    | DW01_cmp6    | width=6    |               | eq_94_I13_I1_I3      |
| r3680    | DW01_cmp6    | width=6    |               | eq_94_I14_I1_I3      |
| r3682    | DW01_cmp6    | width=6    |               | eq_94_I15_I1_I3      |
| r3684    | DW01_cmp6    | width=6    |               | eq_94_I16_I1_I3      |
| r3686    | DW01_cmp6    | width=6    |               | eq_94_I17_I1_I3      |
| r3688    | DW01_cmp6    | width=6    |               | eq_94_I18_I1_I3      |
| r3690    | DW01_cmp6    | width=6    |               | eq_94_I19_I1_I3      |
| r3692    | DW01_cmp6    | width=6    |               | eq_94_I20_I1_I3      |
| r3694    | DW01_cmp6    | width=6    |               | eq_94_I21_I1_I3      |
| r3696    | DW01_cmp6    | width=6    |               | eq_94_I22_I1_I3      |
| r3698    | DW01_cmp6    | width=6    |               | eq_94_I23_I1_I3      |
| r3700    | DW01_cmp6    | width=6    |               | eq_94_I24_I1_I3      |
| r3702    | DW01_cmp6    | width=6    |               | eq_94_I25_I1_I3      |
| r3704    | DW01_cmp6    | width=6    |               | eq_94_I26_I1_I3      |
| r3706    | DW01_cmp6    | width=6    |               | eq_94_I27_I1_I3      |
| r3708    | DW01_cmp6    | width=6    |               | eq_94_I28_I1_I3      |
| r3710    | DW01_cmp6    | width=6    |               | eq_94_I29_I1_I3      |
| r3712    | DW01_cmp6    | width=6    |               | eq_94_I30_I1_I3      |
| r3714    | DW01_cmp6    | width=6    |               | eq_94_I31_I1_I3      |
| r3716    | DW01_cmp6    | width=6    |               | eq_94_I32_I1_I3      |
| r3718    | DW01_cmp6    | width=6    |               | eq_94_I2_I3          |
| r3720    | DW01_cmp6    | width=6    |               | eq_94_I2_I2_I3       |
| r3722    | DW01_cmp6    | width=6    |               | eq_94_I3_I2_I3       |
| r3724    | DW01_cmp6    | width=6    |               | eq_94_I4_I2_I3       |
| r3726    | DW01_cmp6    | width=6    |               | eq_94_I5_I2_I3       |
| r3728    | DW01_cmp6    | width=6    |               | eq_94_I6_I2_I3       |
| r3730    | DW01_cmp6    | width=6    |               | eq_94_I7_I2_I3       |
| r3732    | DW01_cmp6    | width=6    |               | eq_94_I8_I2_I3       |
| r3734    | DW01_cmp6    | width=6    |               | eq_94_I9_I2_I3       |
| r3736    | DW01_cmp6    | width=6    |               | eq_94_I10_I2_I3      |
| r3738    | DW01_cmp6    | width=6    |               | eq_94_I11_I2_I3      |
| r3740    | DW01_cmp6    | width=6    |               | eq_94_I12_I2_I3      |
| r3742    | DW01_cmp6    | width=6    |               | eq_94_I13_I2_I3      |
| r3744    | DW01_cmp6    | width=6    |               | eq_94_I14_I2_I3      |
| r3746    | DW01_cmp6    | width=6    |               | eq_94_I15_I2_I3      |
| r3748    | DW01_cmp6    | width=6    |               | eq_94_I16_I2_I3      |
| r3750    | DW01_cmp6    | width=6    |               | eq_94_I17_I2_I3      |
| r3752    | DW01_cmp6    | width=6    |               | eq_94_I18_I2_I3      |
| r3754    | DW01_cmp6    | width=6    |               | eq_94_I19_I2_I3      |
| r3756    | DW01_cmp6    | width=6    |               | eq_94_I20_I2_I3      |
| r3758    | DW01_cmp6    | width=6    |               | eq_94_I21_I2_I3      |
| r3760    | DW01_cmp6    | width=6    |               | eq_94_I22_I2_I3      |
| r3762    | DW01_cmp6    | width=6    |               | eq_94_I23_I2_I3      |
| r3764    | DW01_cmp6    | width=6    |               | eq_94_I24_I2_I3      |
| r3766    | DW01_cmp6    | width=6    |               | eq_94_I25_I2_I3      |
| r3768    | DW01_cmp6    | width=6    |               | eq_94_I26_I2_I3      |
| r3770    | DW01_cmp6    | width=6    |               | eq_94_I27_I2_I3      |
| r3772    | DW01_cmp6    | width=6    |               | eq_94_I28_I2_I3      |
| r3774    | DW01_cmp6    | width=6    |               | eq_94_I29_I2_I3      |
| r3776    | DW01_cmp6    | width=6    |               | eq_94_I30_I2_I3      |
| r3778    | DW01_cmp6    | width=6    |               | eq_94_I31_I2_I3      |
| r3780    | DW01_cmp6    | width=6    |               | eq_94_I32_I2_I3      |
| r3782    | DW01_cmp6    | width=6    |               | eq_94_I3_I3          |
| r3784    | DW01_cmp6    | width=6    |               | eq_94_I2_I3_I3       |
| r3786    | DW01_cmp6    | width=6    |               | eq_94_I3_I3_I3       |
| r3788    | DW01_cmp6    | width=6    |               | eq_94_I4_I3_I3       |
| r3790    | DW01_cmp6    | width=6    |               | eq_94_I5_I3_I3       |
| r3792    | DW01_cmp6    | width=6    |               | eq_94_I6_I3_I3       |
| r3794    | DW01_cmp6    | width=6    |               | eq_94_I7_I3_I3       |
| r3796    | DW01_cmp6    | width=6    |               | eq_94_I8_I3_I3       |
| r3798    | DW01_cmp6    | width=6    |               | eq_94_I9_I3_I3       |
| r3800    | DW01_cmp6    | width=6    |               | eq_94_I10_I3_I3      |
| r3802    | DW01_cmp6    | width=6    |               | eq_94_I11_I3_I3      |
| r3804    | DW01_cmp6    | width=6    |               | eq_94_I12_I3_I3      |
| r3806    | DW01_cmp6    | width=6    |               | eq_94_I13_I3_I3      |
| r3808    | DW01_cmp6    | width=6    |               | eq_94_I14_I3_I3      |
| r3810    | DW01_cmp6    | width=6    |               | eq_94_I15_I3_I3      |
| r3812    | DW01_cmp6    | width=6    |               | eq_94_I16_I3_I3      |
| r3814    | DW01_cmp6    | width=6    |               | eq_94_I17_I3_I3      |
| r3816    | DW01_cmp6    | width=6    |               | eq_94_I18_I3_I3      |
| r3818    | DW01_cmp6    | width=6    |               | eq_94_I19_I3_I3      |
| r3820    | DW01_cmp6    | width=6    |               | eq_94_I20_I3_I3      |
| r3822    | DW01_cmp6    | width=6    |               | eq_94_I21_I3_I3      |
| r3824    | DW01_cmp6    | width=6    |               | eq_94_I22_I3_I3      |
| r3826    | DW01_cmp6    | width=6    |               | eq_94_I23_I3_I3      |
| r3828    | DW01_cmp6    | width=6    |               | eq_94_I24_I3_I3      |
| r3830    | DW01_cmp6    | width=6    |               | eq_94_I25_I3_I3      |
| r3832    | DW01_cmp6    | width=6    |               | eq_94_I26_I3_I3      |
| r3834    | DW01_cmp6    | width=6    |               | eq_94_I27_I3_I3      |
| r3836    | DW01_cmp6    | width=6    |               | eq_94_I28_I3_I3      |
| r3838    | DW01_cmp6    | width=6    |               | eq_94_I29_I3_I3      |
| r3840    | DW01_cmp6    | width=6    |               | eq_94_I30_I3_I3      |
| r3842    | DW01_cmp6    | width=6    |               | eq_94_I31_I3_I3      |
| r3844    | DW01_cmp6    | width=6    |               | eq_94_I32_I3_I3      |
| r3846    | DW01_cmp6    | width=6    |               | eq_94_I4_I3          |
| r3848    | DW01_cmp6    | width=6    |               | eq_94_I2_I4_I3       |
| r3850    | DW01_cmp6    | width=6    |               | eq_94_I3_I4_I3       |
| r3852    | DW01_cmp6    | width=6    |               | eq_94_I4_I4_I3       |
| r3854    | DW01_cmp6    | width=6    |               | eq_94_I5_I4_I3       |
| r3856    | DW01_cmp6    | width=6    |               | eq_94_I6_I4_I3       |
| r3858    | DW01_cmp6    | width=6    |               | eq_94_I7_I4_I3       |
| r3860    | DW01_cmp6    | width=6    |               | eq_94_I8_I4_I3       |
| r3862    | DW01_cmp6    | width=6    |               | eq_94_I9_I4_I3       |
| r3864    | DW01_cmp6    | width=6    |               | eq_94_I10_I4_I3      |
| r3866    | DW01_cmp6    | width=6    |               | eq_94_I11_I4_I3      |
| r3868    | DW01_cmp6    | width=6    |               | eq_94_I12_I4_I3      |
| r3870    | DW01_cmp6    | width=6    |               | eq_94_I13_I4_I3      |
| r3872    | DW01_cmp6    | width=6    |               | eq_94_I14_I4_I3      |
| r3874    | DW01_cmp6    | width=6    |               | eq_94_I15_I4_I3      |
| r3876    | DW01_cmp6    | width=6    |               | eq_94_I16_I4_I3      |
| r3878    | DW01_cmp6    | width=6    |               | eq_94_I17_I4_I3      |
| r3880    | DW01_cmp6    | width=6    |               | eq_94_I18_I4_I3      |
| r3882    | DW01_cmp6    | width=6    |               | eq_94_I19_I4_I3      |
| r3884    | DW01_cmp6    | width=6    |               | eq_94_I20_I4_I3      |
| r3886    | DW01_cmp6    | width=6    |               | eq_94_I21_I4_I3      |
| r3888    | DW01_cmp6    | width=6    |               | eq_94_I22_I4_I3      |
| r3890    | DW01_cmp6    | width=6    |               | eq_94_I23_I4_I3      |
| r3892    | DW01_cmp6    | width=6    |               | eq_94_I24_I4_I3      |
| r3894    | DW01_cmp6    | width=6    |               | eq_94_I25_I4_I3      |
| r3896    | DW01_cmp6    | width=6    |               | eq_94_I26_I4_I3      |
| r3898    | DW01_cmp6    | width=6    |               | eq_94_I27_I4_I3      |
| r3900    | DW01_cmp6    | width=6    |               | eq_94_I28_I4_I3      |
| r3902    | DW01_cmp6    | width=6    |               | eq_94_I29_I4_I3      |
| r3904    | DW01_cmp6    | width=6    |               | eq_94_I30_I4_I3      |
| r3906    | DW01_cmp6    | width=6    |               | eq_94_I31_I4_I3      |
| r3908    | DW01_cmp6    | width=6    |               | eq_94_I32_I4_I3      |
| r3910    | DW01_inc     | width=6    |               | add_86_I4            |
| r3912    | DW01_inc     | width=6    |               | add_86_I2_I4         |
| r3914    | DW01_inc     | width=6    |               | add_86_I3_I4         |
| r3916    | DW01_inc     | width=6    |               | add_86_I4_I4         |
| r3918    | DW01_cmp6    | width=6    |               | eq_94_I4             |
| r3920    | DW01_cmp6    | width=6    |               | eq_94_I2_I1_I4       |
| r3922    | DW01_cmp6    | width=6    |               | eq_94_I3_I1_I4       |
| r3924    | DW01_cmp6    | width=6    |               | eq_94_I4_I1_I4       |
| r3926    | DW01_cmp6    | width=6    |               | eq_94_I5_I1_I4       |
| r3928    | DW01_cmp6    | width=6    |               | eq_94_I6_I1_I4       |
| r3930    | DW01_cmp6    | width=6    |               | eq_94_I7_I1_I4       |
| r3932    | DW01_cmp6    | width=6    |               | eq_94_I8_I1_I4       |
| r3934    | DW01_cmp6    | width=6    |               | eq_94_I9_I1_I4       |
| r3936    | DW01_cmp6    | width=6    |               | eq_94_I10_I1_I4      |
| r3938    | DW01_cmp6    | width=6    |               | eq_94_I11_I1_I4      |
| r3940    | DW01_cmp6    | width=6    |               | eq_94_I12_I1_I4      |
| r3942    | DW01_cmp6    | width=6    |               | eq_94_I13_I1_I4      |
| r3944    | DW01_cmp6    | width=6    |               | eq_94_I14_I1_I4      |
| r3946    | DW01_cmp6    | width=6    |               | eq_94_I15_I1_I4      |
| r3948    | DW01_cmp6    | width=6    |               | eq_94_I16_I1_I4      |
| r3950    | DW01_cmp6    | width=6    |               | eq_94_I17_I1_I4      |
| r3952    | DW01_cmp6    | width=6    |               | eq_94_I18_I1_I4      |
| r3954    | DW01_cmp6    | width=6    |               | eq_94_I19_I1_I4      |
| r3956    | DW01_cmp6    | width=6    |               | eq_94_I20_I1_I4      |
| r3958    | DW01_cmp6    | width=6    |               | eq_94_I21_I1_I4      |
| r3960    | DW01_cmp6    | width=6    |               | eq_94_I22_I1_I4      |
| r3962    | DW01_cmp6    | width=6    |               | eq_94_I23_I1_I4      |
| r3964    | DW01_cmp6    | width=6    |               | eq_94_I24_I1_I4      |
| r3966    | DW01_cmp6    | width=6    |               | eq_94_I25_I1_I4      |
| r3968    | DW01_cmp6    | width=6    |               | eq_94_I26_I1_I4      |
| r3970    | DW01_cmp6    | width=6    |               | eq_94_I27_I1_I4      |
| r3972    | DW01_cmp6    | width=6    |               | eq_94_I28_I1_I4      |
| r3974    | DW01_cmp6    | width=6    |               | eq_94_I29_I1_I4      |
| r3976    | DW01_cmp6    | width=6    |               | eq_94_I30_I1_I4      |
| r3978    | DW01_cmp6    | width=6    |               | eq_94_I31_I1_I4      |
| r3980    | DW01_cmp6    | width=6    |               | eq_94_I32_I1_I4      |
| r3982    | DW01_cmp6    | width=6    |               | eq_94_I2_I4          |
| r3984    | DW01_cmp6    | width=6    |               | eq_94_I2_I2_I4       |
| r3986    | DW01_cmp6    | width=6    |               | eq_94_I3_I2_I4       |
| r3988    | DW01_cmp6    | width=6    |               | eq_94_I4_I2_I4       |
| r3990    | DW01_cmp6    | width=6    |               | eq_94_I5_I2_I4       |
| r3992    | DW01_cmp6    | width=6    |               | eq_94_I6_I2_I4       |
| r3994    | DW01_cmp6    | width=6    |               | eq_94_I7_I2_I4       |
| r3996    | DW01_cmp6    | width=6    |               | eq_94_I8_I2_I4       |
| r3998    | DW01_cmp6    | width=6    |               | eq_94_I9_I2_I4       |
| r4000    | DW01_cmp6    | width=6    |               | eq_94_I10_I2_I4      |
| r4002    | DW01_cmp6    | width=6    |               | eq_94_I11_I2_I4      |
| r4004    | DW01_cmp6    | width=6    |               | eq_94_I12_I2_I4      |
| r4006    | DW01_cmp6    | width=6    |               | eq_94_I13_I2_I4      |
| r4008    | DW01_cmp6    | width=6    |               | eq_94_I14_I2_I4      |
| r4010    | DW01_cmp6    | width=6    |               | eq_94_I15_I2_I4      |
| r4012    | DW01_cmp6    | width=6    |               | eq_94_I16_I2_I4      |
| r4014    | DW01_cmp6    | width=6    |               | eq_94_I17_I2_I4      |
| r4016    | DW01_cmp6    | width=6    |               | eq_94_I18_I2_I4      |
| r4018    | DW01_cmp6    | width=6    |               | eq_94_I19_I2_I4      |
| r4020    | DW01_cmp6    | width=6    |               | eq_94_I20_I2_I4      |
| r4022    | DW01_cmp6    | width=6    |               | eq_94_I21_I2_I4      |
| r4024    | DW01_cmp6    | width=6    |               | eq_94_I22_I2_I4      |
| r4026    | DW01_cmp6    | width=6    |               | eq_94_I23_I2_I4      |
| r4028    | DW01_cmp6    | width=6    |               | eq_94_I24_I2_I4      |
| r4030    | DW01_cmp6    | width=6    |               | eq_94_I25_I2_I4      |
| r4032    | DW01_cmp6    | width=6    |               | eq_94_I26_I2_I4      |
| r4034    | DW01_cmp6    | width=6    |               | eq_94_I27_I2_I4      |
| r4036    | DW01_cmp6    | width=6    |               | eq_94_I28_I2_I4      |
| r4038    | DW01_cmp6    | width=6    |               | eq_94_I29_I2_I4      |
| r4040    | DW01_cmp6    | width=6    |               | eq_94_I30_I2_I4      |
| r4042    | DW01_cmp6    | width=6    |               | eq_94_I31_I2_I4      |
| r4044    | DW01_cmp6    | width=6    |               | eq_94_I32_I2_I4      |
| r4046    | DW01_cmp6    | width=6    |               | eq_94_I3_I4          |
| r4048    | DW01_cmp6    | width=6    |               | eq_94_I2_I3_I4       |
| r4050    | DW01_cmp6    | width=6    |               | eq_94_I3_I3_I4       |
| r4052    | DW01_cmp6    | width=6    |               | eq_94_I4_I3_I4       |
| r4054    | DW01_cmp6    | width=6    |               | eq_94_I5_I3_I4       |
| r4056    | DW01_cmp6    | width=6    |               | eq_94_I6_I3_I4       |
| r4058    | DW01_cmp6    | width=6    |               | eq_94_I7_I3_I4       |
| r4060    | DW01_cmp6    | width=6    |               | eq_94_I8_I3_I4       |
| r4062    | DW01_cmp6    | width=6    |               | eq_94_I9_I3_I4       |
| r4064    | DW01_cmp6    | width=6    |               | eq_94_I10_I3_I4      |
| r4066    | DW01_cmp6    | width=6    |               | eq_94_I11_I3_I4      |
| r4068    | DW01_cmp6    | width=6    |               | eq_94_I12_I3_I4      |
| r4070    | DW01_cmp6    | width=6    |               | eq_94_I13_I3_I4      |
| r4072    | DW01_cmp6    | width=6    |               | eq_94_I14_I3_I4      |
| r4074    | DW01_cmp6    | width=6    |               | eq_94_I15_I3_I4      |
| r4076    | DW01_cmp6    | width=6    |               | eq_94_I16_I3_I4      |
| r4078    | DW01_cmp6    | width=6    |               | eq_94_I17_I3_I4      |
| r4080    | DW01_cmp6    | width=6    |               | eq_94_I18_I3_I4      |
| r4082    | DW01_cmp6    | width=6    |               | eq_94_I19_I3_I4      |
| r4084    | DW01_cmp6    | width=6    |               | eq_94_I20_I3_I4      |
| r4086    | DW01_cmp6    | width=6    |               | eq_94_I21_I3_I4      |
| r4088    | DW01_cmp6    | width=6    |               | eq_94_I22_I3_I4      |
| r4090    | DW01_cmp6    | width=6    |               | eq_94_I23_I3_I4      |
| r4092    | DW01_cmp6    | width=6    |               | eq_94_I24_I3_I4      |
| r4094    | DW01_cmp6    | width=6    |               | eq_94_I25_I3_I4      |
| r4096    | DW01_cmp6    | width=6    |               | eq_94_I26_I3_I4      |
| r4098    | DW01_cmp6    | width=6    |               | eq_94_I27_I3_I4      |
| r4100    | DW01_cmp6    | width=6    |               | eq_94_I28_I3_I4      |
| r4102    | DW01_cmp6    | width=6    |               | eq_94_I29_I3_I4      |
| r4104    | DW01_cmp6    | width=6    |               | eq_94_I30_I3_I4      |
| r4106    | DW01_cmp6    | width=6    |               | eq_94_I31_I3_I4      |
| r4108    | DW01_cmp6    | width=6    |               | eq_94_I32_I3_I4      |
| r4110    | DW01_cmp6    | width=6    |               | eq_94_I4_I4          |
| r4112    | DW01_cmp6    | width=6    |               | eq_94_I2_I4_I4       |
| r4114    | DW01_cmp6    | width=6    |               | eq_94_I3_I4_I4       |
| r4116    | DW01_cmp6    | width=6    |               | eq_94_I4_I4_I4       |
| r4118    | DW01_cmp6    | width=6    |               | eq_94_I5_I4_I4       |
| r4120    | DW01_cmp6    | width=6    |               | eq_94_I6_I4_I4       |
| r4122    | DW01_cmp6    | width=6    |               | eq_94_I7_I4_I4       |
| r4124    | DW01_cmp6    | width=6    |               | eq_94_I8_I4_I4       |
| r4126    | DW01_cmp6    | width=6    |               | eq_94_I9_I4_I4       |
| r4128    | DW01_cmp6    | width=6    |               | eq_94_I10_I4_I4      |
| r4130    | DW01_cmp6    | width=6    |               | eq_94_I11_I4_I4      |
| r4132    | DW01_cmp6    | width=6    |               | eq_94_I12_I4_I4      |
| r4134    | DW01_cmp6    | width=6    |               | eq_94_I13_I4_I4      |
| r4136    | DW01_cmp6    | width=6    |               | eq_94_I14_I4_I4      |
| r4138    | DW01_cmp6    | width=6    |               | eq_94_I15_I4_I4      |
| r4140    | DW01_cmp6    | width=6    |               | eq_94_I16_I4_I4      |
| r4142    | DW01_cmp6    | width=6    |               | eq_94_I17_I4_I4      |
| r4144    | DW01_cmp6    | width=6    |               | eq_94_I18_I4_I4      |
| r4146    | DW01_cmp6    | width=6    |               | eq_94_I19_I4_I4      |
| r4148    | DW01_cmp6    | width=6    |               | eq_94_I20_I4_I4      |
| r4150    | DW01_cmp6    | width=6    |               | eq_94_I21_I4_I4      |
| r4152    | DW01_cmp6    | width=6    |               | eq_94_I22_I4_I4      |
| r4154    | DW01_cmp6    | width=6    |               | eq_94_I23_I4_I4      |
| r4156    | DW01_cmp6    | width=6    |               | eq_94_I24_I4_I4      |
| r4158    | DW01_cmp6    | width=6    |               | eq_94_I25_I4_I4      |
| r4160    | DW01_cmp6    | width=6    |               | eq_94_I26_I4_I4      |
| r4162    | DW01_cmp6    | width=6    |               | eq_94_I27_I4_I4      |
| r4164    | DW01_cmp6    | width=6    |               | eq_94_I28_I4_I4      |
| r4166    | DW01_cmp6    | width=6    |               | eq_94_I29_I4_I4      |
| r4168    | DW01_cmp6    | width=6    |               | eq_94_I30_I4_I4      |
| r4170    | DW01_cmp6    | width=6    |               | eq_94_I31_I4_I4      |
| r4172    | DW01_cmp6    | width=6    |               | eq_94_I32_I4_I4      |
| r4174    | DW01_cmp6    | width=4    |               | eq_105               |
| r4176    | DW01_cmp6    | width=4    |               | eq_105_I2            |
| r4178    | DW01_cmp6    | width=4    |               | eq_105_I3            |
| r4180    | DW01_cmp6    | width=4    |               | eq_105_I4            |
| r4182    | DW01_sub     | width=3    |               | sub_199_aco          |
| r4184    | DW01_sub     | width=3    |               | sub_199_I2_aco       |
| r4186    | DW01_sub     | width=3    |               | sub_199_I3_aco       |
===============================================================================


No implementations to report
 
****************************************
Design : Dispatcher
****************************************
Resource Sharing Report for design Dispatcher in file
        /home/yiroug/Desktop/pipeline/verilog/Dispatcher.sv

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r154     | DW01_inc     | width=2    |               | add_64_I2            |
| r156     | DW01_inc     | width=3    |               | add_64_I3            |
| r158     | DW01_inc     | width=3    |               | add_64_I4            |
| r160     | DW01_cmp2    | width=3    |               | lt_70                |
| r162     | DW01_cmp2    | width=3    |               | lt_76                |
| r164     | DW01_cmp2    | width=3    |               | lt_82                |
| r166     | DW01_cmp2    | width=3    |               | lt_106               |
| r168     | DW01_cmp2    | width=3    |               | lt_155               |
| r170     | DW01_cmp2    | width=3    |               | lt_155_I2            |
| r172     | DW01_cmp2    | width=3    |               | lt_155_I3            |
| r174     | DW01_cmp2    | width=3    |               | lt_155_I4            |
===============================================================================


No implementations to report

No resource sharing information to report.
 
****************************************
Design : decoder_0
****************************************

No implementations to report

No resource sharing information to report.
 
****************************************
Design : decoder_1
****************************************

No implementations to report

No resource sharing information to report.
 
****************************************
Design : decoder_2
****************************************

No implementations to report

No resource sharing information to report.
 
****************************************
Design : decoder_3
****************************************

No implementations to report
 
****************************************
Design : BP
****************************************
Resource Sharing Report for design BP in file
        /home/yiroug/Desktop/pipeline/verilog/BP.sv

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r1355    | DW01_add     | width=32   |               | add_48_I2            |
| r1357    | DW01_add     | width=32   |               | add_48_I3            |
| r1359    | DW01_add     | width=32   |               | add_48_I4            |
| r1361    | DW01_cmp6    | width=10   |               | eq_104               |
| r1363    | DW01_cmp6    | width=10   |               | eq_108               |
| r1365    | DW01_cmp6    | width=10   |               | eq_104_I2            |
| r1367    | DW01_cmp6    | width=10   |               | eq_108_I2            |
| r1369    | DW01_cmp6    | width=10   |               | eq_104_I3            |
| r1371    | DW01_cmp6    | width=10   |               | eq_108_I3            |
| r1373    | DW01_cmp6    | width=10   |               | eq_104_I4            |
| r1375    | DW01_cmp6    | width=10   |               | eq_108_I4            |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| add_48_I2          | DW01_add         | rpl                |                |
| add_48_I3          | DW01_add         | rpl                |                |
| add_48_I4          | DW01_add         | rpl                |                |
===============================================================================

 
****************************************
Design : Fetch
****************************************
Resource Sharing Report for design Fetch in file
        /home/yiroug/Desktop/pipeline/verilog/Fetch.sv

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r111     | DW01_add     | width=32   |               | add_48               |
| r113     | DW01_add     | width=32   |               | add_54_I2            |
| r115     | DW01_add     | width=32   |               | add_54_I3            |
| r117     | DW01_add     | width=32   |               | add_54_I4            |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| add_48             | DW01_add         | rpl                |                |
| add_54_I2          | DW01_add         | rpl                |                |
| add_54_I3          | DW01_add         | rpl                |                |
| add_54_I4          | DW01_add         | rpl                |                |
===============================================================================

 
****************************************
Design : ICache
****************************************
Resource Sharing Report for design ICache in file
        /home/yiroug/Desktop/pipeline/verilog/Icache.sv

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r892     | DW01_cmp6    | width=25   |               | eq_79                |
| r894     | DW01_cmp6    | width=25   |               | eq_79_I2             |
| r896     | DW01_cmp6    | width=25   |               | eq_125               |
| r898     | DW01_cmp6    | width=25   |               | eq_125_I2_I1         |
| r900     | DW01_cmp6    | width=25   |               | eq_125_I2            |
| r902     | DW01_cmp6    | width=25   |               | eq_125_I2_I2         |
| r904     | DW01_cmp6    | width=25   |               | eq_125_I3            |
| r906     | DW01_cmp6    | width=25   |               | eq_125_I2_I3         |
| r908     | DW01_cmp6    | width=25   |               | eq_125_I4            |
| r910     | DW01_cmp6    | width=25   |               | eq_125_I2_I4         |
===============================================================================


No implementations to report
 
****************************************
Design : ICache_ctrl
****************************************
Resource Sharing Report for design ICache_ctrl in file
        /home/yiroug/Desktop/pipeline/verilog/Icache_ctrl.sv

===============================================================================
|          |              |            | Contained     |                      |
| Resource | Module       | Parameters | Resources     | Contained Operations |
===============================================================================
| r562     | DW01_inc     | width=29   |               | add_157_I2_I6        |
|          |              |            |               | add_157_I2_I7        |
|          |              |            |               | add_157_I2_I8        |
| r564     | DW01_add     | width=29   |               | add_157_I3_I6        |
|          |              |            |               | add_157_I3_I7        |
|          |              |            |               | add_157_I3_I8        |
| r566     | DW01_add     | width=29   |               | add_157_I4_I6        |
|          |              |            |               | add_157_I4_I7        |
|          |              |            |               | add_157_I4_I8        |
| r568     | DW01_add     | width=29   |               | add_157_I5_I6        |
|          |              |            |               | add_157_I5_I7        |
|          |              |            |               | add_157_I5_I8        |
| r570     | DW01_add     | width=29   |               | add_157_I6_I6        |
|          |              |            |               | add_157_I6_I7        |
|          |              |            |               | add_157_I6_I8        |
| r672     | DW01_inc     | width=3    |               | add_104              |
| r674     | DW01_inc     | width=3    |               | add_129              |
| r676     | DW01_cmp6    | width=4    |               | eq_133               |
| r678     | DW01_inc     | width=3    |               | add_129_I2           |
| r680     | DW01_cmp6    | width=4    |               | eq_133_I2            |
| r682     | DW01_inc     | width=3    |               | add_129_I3           |
| r684     | DW01_cmp6    | width=4    |               | eq_133_I3            |
| r686     | DW01_inc     | width=3    |               | add_129_I4           |
| r688     | DW01_cmp6    | width=4    |               | eq_133_I4            |
| r690     | DW01_inc     | width=3    |               | add_129_I5           |
| r692     | DW01_cmp6    | width=4    |               | eq_133_I5            |
| r694     | DW01_inc     | width=3    |               | add_129_I6           |
| r696     | DW01_cmp6    | width=4    |               | eq_133_I6            |
| r698     | DW01_inc     | width=3    |               | add_129_I7           |
| r700     | DW01_cmp6    | width=4    |               | eq_133_I7            |
| r702     | DW01_inc     | width=3    |               | add_129_I8           |
| r704     | DW01_cmp6    | width=4    |               | eq_133_I8            |
| r706     | DW01_cmp6    | width=32   |               | eq_158               |
| r708     | DW01_cmp6    | width=32   |               | eq_158_I2_I1         |
| r710     | DW01_cmp6    | width=32   |               | eq_158_I3_I1         |
| r712     | DW01_cmp6    | width=32   |               | eq_158_I4_I1         |
| r714     | DW01_cmp6    | width=32   |               | eq_158_I5_I1         |
| r716     | DW01_cmp6    | width=32   |               | eq_158_I6_I1         |
| r718     | DW01_cmp6    | width=32   |               | eq_158_I2            |
| r720     | DW01_cmp6    | width=32   |               | eq_158_I2_I2         |
| r722     | DW01_cmp6    | width=32   |               | eq_158_I3_I2         |
| r724     | DW01_cmp6    | width=32   |               | eq_158_I4_I2         |
| r726     | DW01_cmp6    | width=32   |               | eq_158_I5_I2         |
| r728     | DW01_cmp6    | width=32   |               | eq_158_I6_I2         |
| r730     | DW01_cmp6    | width=32   |               | eq_158_I3            |
| r732     | DW01_cmp6    | width=32   |               | eq_158_I2_I3         |
| r734     | DW01_cmp6    | width=32   |               | eq_158_I3_I3         |
| r736     | DW01_cmp6    | width=32   |               | eq_158_I4_I3         |
| r738     | DW01_cmp6    | width=32   |               | eq_158_I5_I3         |
| r740     | DW01_cmp6    | width=32   |               | eq_158_I6_I3         |
| r742     | DW01_cmp6    | width=32   |               | eq_158_I4            |
| r744     | DW01_cmp6    | width=32   |               | eq_158_I2_I4         |
| r746     | DW01_cmp6    | width=32   |               | eq_158_I3_I4         |
| r748     | DW01_cmp6    | width=32   |               | eq_158_I4_I4         |
| r750     | DW01_cmp6    | width=32   |               | eq_158_I5_I4         |
| r752     | DW01_cmp6    | width=32   |               | eq_158_I6_I4         |
| r754     | DW01_cmp6    | width=32   |               | eq_158_I5            |
| r756     | DW01_cmp6    | width=32   |               | eq_158_I2_I5         |
| r758     | DW01_cmp6    | width=32   |               | eq_158_I3_I5         |
| r760     | DW01_cmp6    | width=32   |               | eq_158_I4_I5         |
| r762     | DW01_cmp6    | width=32   |               | eq_158_I5_I5         |
| r764     | DW01_cmp6    | width=32   |               | eq_158_I6_I5         |
| r766     | DW01_cmp6    | width=32   |               | eq_158_I6            |
| r768     | DW01_cmp6    | width=32   |               | eq_158_I2_I6         |
| r770     | DW01_cmp6    | width=32   |               | eq_158_I3_I6         |
| r772     | DW01_cmp6    | width=32   |               | eq_158_I4_I6         |
| r774     | DW01_cmp6    | width=32   |               | eq_158_I5_I6         |
| r776     | DW01_cmp6    | width=32   |               | eq_158_I6_I6         |
| r778     | DW01_cmp6    | width=32   |               | eq_158_I7            |
| r780     | DW01_cmp6    | width=32   |               | eq_158_I2_I7         |
| r782     | DW01_cmp6    | width=32   |               | eq_158_I3_I7         |
| r784     | DW01_cmp6    | width=32   |               | eq_158_I4_I7         |
| r786     | DW01_cmp6    | width=32   |               | eq_158_I5_I7         |
| r788     | DW01_cmp6    | width=32   |               | eq_158_I6_I7         |
| r790     | DW01_cmp6    | width=32   |               | eq_158_I8            |
| r792     | DW01_cmp6    | width=32   |               | eq_158_I2_I8         |
| r794     | DW01_cmp6    | width=32   |               | eq_158_I3_I8         |
| r796     | DW01_cmp6    | width=32   |               | eq_158_I4_I8         |
| r798     | DW01_cmp6    | width=32   |               | eq_158_I5_I8         |
| r800     | DW01_cmp6    | width=32   |               | eq_158_I6_I8         |
| r802     | DW01_inc     | width=3    |               | add_177              |
| r804     | DW01_inc     | width=29   |               | add_174_I2           |
| r806     | DW01_inc     | width=3    |               | add_177_I2           |
| r808     | DW01_add     | width=29   |               | add_174_I3           |
| r810     | DW01_inc     | width=3    |               | add_177_I3           |
| r812     | DW01_add     | width=29   |               | add_174_I4           |
| r814     | DW01_inc     | width=3    |               | add_177_I4           |
| r816     | DW01_add     | width=29   |               | add_174_I5           |
| r818     | DW01_inc     | width=3    |               | add_177_I5           |
| r820     | DW01_add     | width=29   |               | add_174_I6           |
| r822     | DW01_inc     | width=3    |               | add_177_I6           |
===============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| r562               | DW01_inc         | rpl                |                |
| r564               | DW01_add         | rpl                |                |
| r566               | DW01_add         | rpl                |                |
| r568               | DW01_add         | rpl                |                |
| r570               | DW01_add         | rpl                |                |
| add_174_I2         | DW01_inc         | rpl                |                |
| add_174_I3         | DW01_add         | rpl                |                |
| add_174_I4         | DW01_add         | rpl                |                |
| add_174_I5         | DW01_add         | rpl                |                |
| add_174_I6         | DW01_add         | rpl                |                |
===============================================================================


No resource sharing information to report.
 
****************************************
Design : arbiter
****************************************

No implementations to report
1
