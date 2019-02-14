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
    input avr_rx_busy // AVR Rx buffer full
    );

wire rst = ~rst_n; // make reset active high

//Create the 100MHz clk for the HDMI buffer
  clk_100_from_50 instance_name
   (// Clock in ports
    .CLK_IN1(clk),      // IN
    // Clock out ports
    .CLK_OUT1(clk_100),     // OUT
    // Status and control signals
    .RESET(1'b0),// IN
    .LOCKED(1'b0));      // OUT //both reset & locked active high

// these signals should be high-z when not used
assign spi_miso = 1'bz;
assign avr_rx = 1'bz;
assign spi_channel = 4'bzzzz;
assign led[0] = button;
reg [31:0] clk_div_reg;
assign led[7:2] = 1'b0;
reg led1_state = 0;



//Instantiate the dvi_demo that will decode the HDMI input
hdmi_module dvi_demo (
  .rstbtn_n (1'b1),    //The pink reset button //Not on Mojo
  .clk100(clk_100),      //100 MHz osicallator
  .RX0_TMDS(RX0_TMDS),
  .RX0_TMDSB(RX0_TMDSB),

  .LED(led)
);
//TODO: IMPLEMENT protocol for lights

endmodule