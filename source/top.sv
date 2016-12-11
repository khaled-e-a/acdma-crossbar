import AggrCDMAPkg::*;
module top (
	input  clk,    	// Clock
	input  rst, 	// Synchronous reset active high
	input  logic [NUM_PORTS-1:0][DATA_WIDTH-1:0] data,
	output logic [NUM_PORTS-1:0][DATA_WIDTH-1:0] decoded
);

// logic [NUM_PORTS-1:0][DATA_WIDTH-1:0] decoded;
logic [NUM_PORTS-1:0][DATA_WIDTH-1:0] encoded, encoded_reg1;
logic [NUM_PORTS-1:0] spreadingChips, spreadingChips_reg1;
logic [COUNTER_WIDTH-1:0] counter, counter_reg1, counter_reg2, counter_reg3, counter_reg4;
logic [COUNTER_WIDTH-1:0] counter1_reg4; // second replica for speed
logic [COUNTER_WIDTH-1:0] decoder_counter, decoder_counter1;
logic [DATA_WIDTH+LOG_CODE_WIDTH-1:0] channel;
logic rotate_code;


genvar x;

// counter
always_ff @(posedge clk) begin : proc_counter
	if(rst) begin
		counter  <= -1;
	end else begin
		counter  <= counter + 1;
	end
end


// generate encoders
generate
	for ( x = 0; x < NUM_PORTS; x++) begin
		encoder #(
			.CODE_NUM(x)
		) encoder (
			.clk(clk),
			.rst(rst),
			.rotate_code(rotate_code),
			.counter(counter),
			.data(data[x]),
			.encoded(encoded[x]),
			.chip(spreadingChips[x])
		);
	end
endgenerate

assign rotate_code = 1'b1;

// Pipeline stage 1

always_ff@(posedge clk) begin 
	encoded_reg1 <= encoded;
	counter_reg1 <= counter;
	spreadingChips_reg1 <= spreadingChips;
end

// generate adder
// contains pipeline stages 2, 3, 4
adder adder (
	.clk(clk),
	.spreadingChips(spreadingChips_reg1),
	.encoded(encoded_reg1),
	.sum(channel)
);

// Pipeline stage 2,3, 4 

always_ff@(posedge clk) begin 
	counter_reg2  <= counter_reg1;
	counter_reg3  <= counter_reg2;
	counter_reg4  <= counter_reg3;
	counter1_reg4 <= counter_reg3;
end

generate
	if (CDMA_CODE_WIDTH==16) begin
		logic [COUNTER_WIDTH-1:0] counter_reg5, counter1_reg5;
		always_ff@(posedge clk) begin 
			counter_reg5  <= counter_reg4;
			counter1_reg5 <= counter_reg4;
		end
		assign decoder_counter  = counter_reg5;
		assign decoder_counter1 = counter1_reg5;
	end else begin
		assign decoder_counter  = counter_reg4;
		assign decoder_counter1 = counter1_reg4;
	end

endgenerate

// generate decoder
generate
	for ( x = 0; x < NUM_PORTS/2; x++) begin
		decoder #(
		.CODE_NUM(x)
		) decoder (
		.clk(clk),    // Clock
		.rst(rst),  // Synchronous reset active high
		.rotate_code(rotate_code),
		.counter(decoder_counter),
		.channel(channel),
		.decoded(decoded[x])
		);
	end
	for ( x = NUM_PORTS/2; x < NUM_PORTS; x++) begin
		decoder #(
		.CODE_NUM(x)
		) decoder (
		.clk(clk),    // Clock
		.rst(rst),  // Synchronous reset active high
		.rotate_code(rotate_code),
		.counter(decoder_counter1),
		.channel(channel),
		.decoded(decoded[x])
		);
	end
endgenerate




endmodule