import AggrCDMAPkg::*;
module adder(
	input  logic clk,
	input  logic [NUM_PORTS-1:0] spreadingChips,
	input  logic [NUM_PORTS-1:0][DATA_WIDTH-1:0] encoded,
	output logic [DATA_WIDTH+LOG_CODE_WIDTH-1 :0] sum
);

logic [NUM_PORTS/2  -1:0][DATA_WIDTH  :0] sum_stage1;
logic [NUM_PORTS/4  -1:0][DATA_WIDTH+1:0] sum_stage2;
logic [NUM_PORTS/8  -1:0][DATA_WIDTH+2:0] sum_stage3;


always_ff@(posedge clk) begin : proc_adder_stage1
	for (int i = 0; i < NUM_PORTS; i=i+2) begin   // 8
		sum_stage1[i/2] <= {encoded[i][DATA_WIDTH-1], encoded[i]} + {encoded[i+1][DATA_WIDTH-1], encoded[i+1]} + spreadingChips[i] + spreadingChips[i+1];
	end
end

always_ff@(posedge clk) begin : proc_adder_stage2
	for (int i = 0; i < NUM_PORTS/2; i=i+2) begin // 4
		sum_stage2[i/2] <= {sum_stage1[  i][DATA_WIDTH], sum_stage1[  i]} 
						+ {sum_stage1[i+1][DATA_WIDTH], sum_stage1[i+1]};
	end
end

always_ff@(posedge clk) begin : proc_adder_stage3
	for (int i = 0; i < NUM_PORTS/4; i=i+2) begin // 2
		sum_stage3[i/2] <= {sum_stage2[  i][DATA_WIDTH+1], sum_stage2[  i]} 
						+ {sum_stage2[i+1][DATA_WIDTH+1], sum_stage2[i+1]};
	end
end

generate 

	if (CDMA_CODE_WIDTH==16) begin
		logic [NUM_PORTS/16 -1:0][DATA_WIDTH+3:0] sum_stage4;
		always_ff@(posedge clk) begin : proc_adder_stage4
			for (int i = 0; i < NUM_PORTS/8; i=i+2) begin 
				sum_stage4[i/2] <= {sum_stage3[  i][DATA_WIDTH+2], sum_stage3[  i]} 
								+ {sum_stage3[i+1][DATA_WIDTH+2], sum_stage3[i+1]};
			end
		end
		assign sum = sum_stage4[0];
	end else begin
		assign sum = sum_stage3[0];
	end
endgenerate


endmodule // adder