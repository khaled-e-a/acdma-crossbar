`timescale 1ns/1ps
import AggrCDMAPkg::*;
module top_tb ();

integer f;

logic clk;    	// Clock
logic rst; 	// Synchronous reset active high
logic [NUM_PORTS-1:0][DATA_WIDTH-1:0] data, dataOld;
logic [NUM_PORTS-1:0][DATA_WIDTH-1:0] decoded;


top DUT(
	.clk(clk),    	// Clock
	.rst(rst), 		// Synchronous reset active high
	.data(data),
	.decoded(decoded)
);	

always #5 clk = ~clk; 

initial begin 
	f = $fopen("output.txt","w");
	clk = 0;
	rst = 1;
	#(30);
	rst = 0;
	for (int i = 0; i < NUM_PORTS; i++) begin
		data[i] = $random;
	end
	dataOld = data;
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	wait (DUT.counter == {COUNTER_WIDTH{1'b0}})

	for (int i = 0; i < NUM_PORTS; i++) begin
		data[i] = $random;
	end

	wait (DUT.decoder_counter == {COUNTER_WIDTH{1'b0}})	
	//@(posedge clk);
	@(negedge clk);
	if(decoded == dataOld) begin
		$display("Success!");
		$fwrite(f,"%0d\n",1);
	end else begin
		$display("Fail!");
		$fwrite(f,"%0d\n",0);
	end

	@(posedge clk);
	@(posedge clk);

	wait (DUT.decoder_counter == {COUNTER_WIDTH{1'b0}})	
	//@(posedge clk);
	@(negedge clk);
	if(decoded == data) begin
		$display("Success!");
		$fwrite(f,"%0d\n",1);
	end else begin
		$display("Fail!");
		$fwrite(f,"%0d\n",0);
	end
	$fclose(f); 
	$finish;
end


endmodule