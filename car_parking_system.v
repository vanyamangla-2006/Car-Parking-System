module car_parking_system(
    input clk,
    input reset,
    input sensor_entry,          // Entry sensor signal
    input sensor_exit,           // Exit sensor signal
    input [3:0] password_input,  // User-entered password (4-bit example)
    output reg gate_open,        // Gate control signal (1=open, 0=closed)
    output reg [6:0] available_spaces // Available parking spaces (max 100)
);

// Parameters
parameter PASSWORD = 4'b1010;        // Example password
parameter MAX_SPACES = 100;          // Total parking spaces

// Internal Registers
reg [1:0] attempts;                  // Password attempts counter
reg [1:0] state;                     // FSM state register

// FSM States
parameter IDLE = 2'b00;
parameter PASSWORD_CHECK = 2'b01;
parameter VEHICLE_ENTRY = 2'b10;
parameter VEHICLE_EXIT = 2'b11;

// Initialize available spaces
always @(posedge clk or posedge reset) begin
    if (reset) begin
        available_spaces <= MAX_SPACES;
        gate_open <= 0;
        attempts <= 0;
        state <= IDLE;
    end else begin
        case (state)
            IDLE: begin
                gate_open <= 0;
                attempts <= 0;

                if (sensor_entry && available_spaces > 0) begin
                    state <= PASSWORD_CHECK; // Proceed to verify password only if space is available
                end else if (sensor_exit && available_spaces < MAX_SPACES) begin
                    state <= VEHICLE_EXIT;   // Car detected at exit gate
                end else begin
                    state <= IDLE;           // Remain idle otherwise
                end
            end

            PASSWORD_CHECK: begin
                if (password_input == PASSWORD) begin
                    gate_open <= 1;          // Open gate upon correct password entry
                    state <= VEHICLE_ENTRY;
                end else begin
                    attempts <= attempts + 1;
                    if (attempts >= 2) begin // Allow maximum two attempts
                        gate_open <= 0;      // Keep gate closed after failed attempts
                        state <= IDLE;
                    end else begin
                        state <= PASSWORD_CHECK; // Allow another attempt
                    end
                end
            end

            VEHICLE_ENTRY: begin
                if (!sensor_entry) begin     // Wait until vehicle fully enters (sensor no longer detects car)
                    gate_open <= 0;          // Close the gate after vehicle passes through entry sensor completely

                    if (available_spaces > 0)
                        available_spaces <= available_spaces - 1; // Decrement available spaces by one

                    state <= IDLE;
                end else begin
                    state <= VEHICLE_ENTRY;   // Wait until vehicle fully enters parking lot 
                end 
            end

            VEHICLE_EXIT: begin 
                if (!sensor_exit) begin      // Wait until vehicle fully exits (sensor no longer detects car)
                    if (available_spaces < MAX_SPACES)
                        available_spaces <= available_spaces + 1; // Increment available spaces by one after vehicle exits

                    state <= IDLE;
                end else begin 
                    state <= VEHICLE_EXIT;   // Wait until vehicle fully exits parking lot 
                end 
            end

            default: state <= IDLE;

        endcase 
    end 
end 

endmodule