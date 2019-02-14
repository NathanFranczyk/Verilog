module mojo_top(
    // 50MHz clock input
    input clk,
	 input button,
    // Input from reset button (active low)
    input rst_n,
    // cclk input from AVR, high when AVR is ready
    input cclk,
    // Outputs to the 8 onboard LEDs
    output[7:0]led,
    // AVR SPI connections
    output spi_miso,
    input spi_ss,
    input spi_mosi,
    input spi_sck,
    // AVR ADC channel select
    output [3:0] spi_channel,
    // Serial connections
    input avr_tx, // AVR Tx => FPGA Rx
    output avr_rx, // AVR Rx => FPGA Tx
    input avr_rx_busy, // AVR Rx buffer full
	 input [3:0] RX0_TMDS,
	 input [3:0] RX0_TMDSB
    );
//TODO: RESOLVE CLOCK ERROR
wire rst = ~rst_n; // make reset active high
wire clk_50;
//Create the 100MHz clk for the HDMI buffer
  clk_100_from_50 instance_name
   (// Clock in ports
    .CLK_IN1(clk),      // IN
    // Clock out ports
    .CLK_OUT1(clk_100),     // OUT
	 .CLK_OUT2(clk_50),
    // Status and control signals
    .RESET(1'b0),// IN
    .LOCKED());      // OUT //both reset & locked active high
//Proper way to use clocking wizard to produce two clocks. one multiplied and one not
// these signals should be high-z when not used
assign spi_miso = 1'bz;
assign avr_rx = 1'bz;
assign spi_channel = 4'bzzzz;
reg [31:0] clk_div_reg;


wire [7:0] red;
wire [7:0] green;
wire [7:0] blue;
wire [7:0] avg_red;
wire [7:0] avg_green;
wire [7:0] avg_blue;
wire [7:0] led_addr;
wire vsync;
wire hsync;
wire leds_ready;
wire tmds_clk;
//Instantiate the dvi_demo that will decode the HDMI input
dvi_demo hdmi_module (
  .rstbtn_n (1'b1),    //The pink reset button //Not on Mojo
  .clk100(clk_100),      //100 MHz osicallator
  .RX0_TMDS(RX0_TMDS),
  .RX0_TMDSB(RX0_TMDSB),

  .LED(led),
  .rx0_red(red),
  .rx0_green(green),
  .rx0_blue(blue),
  .rx0_hsync(hsync),
  .rx0_vsync(vsync),
  .tmds_clk(tmds_clk)
);


//hdmi_averager averager_1(
//	  .red(red),
//	  .green(green),
//	  .blue(blue),
//	  .vsync(vsync),
//	  .hsync(hsync),
//	  .clk(clk_50), //Use the lvds clk?
//	  .avg_red(avg_red),
//	  .avg_green(avg_green),
//	  .avg_blue(avg_blue),
//	  .tmds_clk(tmds_clk) //probably need some sort of control on this
//);


//WS2812b
WS2812b_driver led_driver(
	 .clk(clk_50),          // Clock input.
    .reset(rst_n),        // Resets the internal state of the driver
    //.data_request(), // This signal is asserted one cycle before red_in, green_in, and blue_in are sampled.
    .new_address(leds_ready),  // This signal is asserted whenever the address signal is updated to its new value.
    //^^use this as the "ready for next color"
	 .address(addr),      // log2(#leds)
    .red_in(avg_red),       // 8-bit red data
    .green_in(avg_green),     // 8-bit green data
    .blue_in(avg_blue),      // 8-bit blue data
    .DO(DO)            // Signal to send to WS2812 chain.
    );

//TODO: Pinout for D0

endmodule