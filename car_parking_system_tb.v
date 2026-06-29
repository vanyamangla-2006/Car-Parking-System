module car_parking_system_tb;

// Inputs
reg clk;
reg reset;
reg sensor_entry;
reg sensor_exit;
reg [3:0] password_input;

// Outputs
wire gate_open;
wire [6:0] available_spaces;

car_parking_system Car (
    .clk(clk),
    .reset(reset),
    .sensor_entry(sensor_entry),
    .sensor_exit(sensor_exit),
    .password_input(password_input),
    .gate_open(gate_open),
    .available_spaces(available_spaces)
);

// Clock generation (50MHz clock)
always #10 clk = ~clk; // Clock period = 20ns

initial begin
    // Initialize Inputs
    clk = 0;
    reset = 1;
    sensor_entry = 0;
    sensor_exit = 0;
    password_input = 4'b0000;

    // Release reset after some time
    #30 reset = 0;

    // Test 1: Successful car entry with correct password
    #20 sensor_entry = 1; 
    #20 password_input = 4'b1010; // Correct password
    #40 sensor_entry = 0; // Car passes through entry gate

    // Test 2: Failed car entry with incorrect password (two attempts)
    #40 sensor_entry = 1; 
    #20 password_input = 4'b1111; // Incorrect attempt 1
    #20 password_input = 4'b0001; // Incorrect attempt 2
    #20 sensor_entry = 0; // Car leaves entry area without entering

    // Test 3: Car exit scenario
    #40 sensor_exit = 1; 
    #40 sensor_exit = 0; // Car fully exits parking lot

    // Test 4: Multiple entries and exits
    repeat (3) begin
        #40 sensor_entry = 1;
        #20 password_input = 4'b1010; // Correct password
        #40 sensor_entry = 0;

        #60 sensor_exit = 1;
        #40 sensor_exit = 0;
    end

    // Finish simulation after all tests
    #100 $finish;
end

// Monitor outputs and display results
initial begin
   $monitor("Time=%t | Reset=%b | Entry=%b | Exit=%b | Password=%b | GateOpen=%b | AvailableSpaces=%d", $time, reset, sensor_entry, sensor_exit, password_input, gate_open, available_spaces);
   $dumpfile("car_parking.vcd");
   $dumpvars(0, car_parking_system_tb);
end

endmodule

/* 
    1. We have provide RESET to initialize to set a system to a known state.
    2. Test 1: Successful vehile entry with correct password authentication with a decrement in the number of available parking spaces.
    3. Test 2: Failed entry due to incorrect password.
    4. Test 3: It tests vehicle exit detection with an increament in the number of available parking spaces.  
    5. Test 4: Tests multiple sequential entries and exits to verify accurate counting of available spaces.

*/