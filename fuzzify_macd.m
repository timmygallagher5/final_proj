function macd_values = fuzzify_macd( macd, plot )
% ************************************************************************
%
% Description
%   Fuzzify the current macd input by applying it to all of the MACD Input
%   MFs.
% 
% Inputs
%   macd: the current macd value
%   plot: Flag to plot the Input MFs across the universe of discourse.
%   1=plot
%
% Outputs
%   macd_values: The values returned by each of the Input MFs
%
% ************************************************************************
    
    % ***************** Only used for plotting ***********************
    if( plot == 1 )
        plot_macd = -1.0:0.01:1.0;
        bear = macd_bearish(plot_macd);
        sbear = macd_slightly_bearish(plot_macd);
        sbull = macd_slightly_bullish(plot_macd);
        bull = macd_bullish(plot_macd);
        figure;plot( plot_macd, bear, plot_macd, sbear, plot_macd, sbull, plot_macd, bull );
    end
    % ****************************************************************

    % Take the current input and apply it to all MACD MF functions
    br   = macd_bearish( macd );
    s_br = macd_slightly_bearish( macd );
    s_bl = macd_slightly_bullish( macd );
    bl   = macd_bullish( macd );
    
    % Assign the outputs of the input MFs to the output
    % NOTE: These outputs are set purposely to make looping easier
    macd_values = [ br; s_br; s_bl; bl ];

    % ************************ Input MFs *****************************
    function val = macd_bearish(macd)
        val = max( min( 1, ( -0.4 - macd )/(-0.4 - -1) ), 0 );
    end

    function val = macd_slightly_bearish(macd)
        val = max( min( (macd - -0.6)/(-0.2 - -0.6),(0.1 - macd)/(0.1 - -0.2) ), 0 );
    end 

    function val = macd_slightly_bullish(macd)
        val = max( min( (macd - -0.1)/(0.2 - -0.1),(0.6 - macd)/(0.6 - 0.2) ), 0 );
    end 

    function val = macd_bullish(macd)
        val = max( min( (macd - 0.4)/(1.0 - 0.4),1 ), 0 );
    end
end