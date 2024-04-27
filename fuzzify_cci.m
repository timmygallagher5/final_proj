function cci_values = fuzzify_cci( cci, plot )
% ************************************************************************
%
% Description
%   Fuzzify the current cci input by applying it to all of the CCI Input
%   MFs.
% 
% Inputs
%   cci: the current cci value
%   plot: Flag to plot the Input MFs across the universe of discourse.
%   1=plot
%
% Outputs
%   cci_values: The values returned by each of the Input MFs
%
% ************************************************************************

    % ***************** Only used for plotting ***********************
    if( plot == 1 )    
        plot_cci = 1:1:100;
        cci_bear = cci_bearish(plot_cci);
        cci_sbear = cci_slightly_bearish(plot_cci);
        cci_sbull = cci_slightly_bullish(plot_cci);
        cci_bull = cci_bullish(plot_cci);
        figure;plot( plot_cci, cci_bear, plot_cci, cci_sbear, plot_cci, cci_sbull, plot_cci, cci_bull );
    end
    % ****************************************************************

    % Take the current input and apply it to all CCI MF functions
    br   = cci_bearish( cci );
    s_br = cci_slightly_bearish( cci );
    s_bl = cci_slightly_bullish( cci );
    bl   = cci_bullish( cci );
    
    % Assign the outputs of the input MFs to the output
    % NOTE: These outputs are set purposely to make looping easier
    cci_values = [ br; s_br; s_bl; bl ];

    % ************************ Input MFs *****************************
    function val = cci_bearish(cci)
        val = max( min( 1, ( 25 - cci )/(25 - 0) ), 0 );
    end

    function val = cci_slightly_bearish(cci)
        val = max( min( (cci - 15)/(35 - 15),(55 - cci)/(55 - 35) ), 0 );
    end

    function val = cci_slightly_bullish(cci)
        val = max( min( (cci - 45)/(65 - 45),(85 - cci)/(85 - 65) ), 0 );
    end

    function val = cci_bullish(cci)
        val = max( min( (cci - 75)/(100 - 75),1 ), 0 );
    end

end