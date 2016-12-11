package AggrCDMAPkg;

    parameter int CDMA_CODE_WIDTH = 8;                      // Change to 16 for N = 16 crossbar
    parameter int NUM_PORTS       = CDMA_CODE_WIDTH;        // Number of CDMA ports
    parameter int DATA_WIDTH      = 1;                      // Data width W
    parameter int LOG_CODE_WIDTH  = $clog2(CDMA_CODE_WIDTH-1); 
    parameter int COUNTER_WIDTH   = $clog2(CDMA_CODE_WIDTH-1);  // Width of CDMA synchronous counters
    // Comment the next line and uncomment the one the few lines that follows to change the code
    // width to N = 16
    parameter logic [0:CDMA_CODE_WIDTH-1] [CDMA_CODE_WIDTH-1:0] CDMA_CODES 
                  = {8'h00, 8'h55, 8'h33, 8'h66, 8'h0F, 8'h5A, 8'h3C, 8'h69};
    // parameter logic [0:CDMA_CODE_WIDTH-1] [CDMA_CODE_WIDTH-1:0] CDMA_CODES 
    //                = { 16'd0,
    //                    16'd21845,
    //                    16'd13107,
    //                    16'd26214,
    //                    16'd3855,
    //                    16'd23130,
    //                    16'd15420,
    //                    16'd26985,
    //                    16'd255,
    //                    16'd21930,
    //                    16'd13260,
    //                    16'd26265,
    //                    16'd4080,
    //                    16'd23205,
    //                    16'd15555,
    //                    16'd27030};

    typedef   logic [DATA_WIDTH-1:0] dataWord; // data word




endpackage
