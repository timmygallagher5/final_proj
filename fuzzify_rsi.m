function rsi_values = fuzzify_rsi( rsi, plot ) 

    % ***************** Only used for plotting ***********************
    if( plot == 1)
        plot_rsi = 1:1:100;
        os = rsi_oversold(plot_rsi);
        int = rsi_intermediate(plot_rsi);
        ob = rsi_overbought(plot_rsi);
        figure;plot( plot_rsi, os, plot_rsi, int, plot_rsi, ob);
    end
    % ****************************************************************

    % Take the current input and apply it to all RSI MF functions
    os  = rsi_oversold( rsi );
    int = rsi_intermediate( rsi );
    ob  = rsi_overbought( rsi );
    
    % Assign the outputs of the input MFs to the output
    % NOTE: These outputs are set purposely to make looping easier
    rsi_values = [ ob; int; os ];

    % ************************ Input MFs *****************************
    function val = rsi_oversold(rsi)
        val = max( min( 1, ( 35 - rsi )/(35 - 0) ), 0 );
    end

    function val = rsi_intermediate(rsi)
        val = max( min( ( rsi - 25 )/( 50-25 ), ( 75 - rsi )/( 75-50 ) ), 0 );
    end

    function val = rsi_overbought(rsi)
        val = max( min( (rsi - 65)/(100 - 65), 1 ), 0 );
    end

end