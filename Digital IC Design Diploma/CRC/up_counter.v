module up_counter  #(parameter n = 4) 
(
    input clk, reset_n, En,
    output reg done
);
    reg [n - 1 : 0] Q_reg;
    wire high;
    
    always @(posedge clk, negedge reset_n) 
        begin
            if (!reset_n)
            begin
                Q_reg <= 'b0;
                high <= 'b1000;
                done <= 1'b0;
            end
            else if (En && ~high)
                begin
                    Q_reg <= Q_reg + 1;
                    done <= 1'b0;
                end
            else
                begin
                    Q_reg <= 'b0;
                    done <= 1'b1;
                end     
        end
endmodule