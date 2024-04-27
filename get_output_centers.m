function centers = get_output_centers( plot )
% ************************************************************************
%
% Description
%   Apply the correct output MF center for all the rules. This will be used
%   to defuzzify the data to get a crisp output. This array is essentially
%   hard-coded and was derived from Table 1.
% 
% Inputs
%   plot: Flag to plot the Output MFs across the universe of discourse.
%   1=plot
%
% Outputs
%   centers: An array of output MF centers for each rule.
%
% ************************************************************************

    % ***************** Only used for plotting ***********************
    if( plot == 1)
        plot_outMFs = 1:1:100;
        ss = strong_sell(plot_outMFs);
        s  = sell(plot_outMFs);
        h  = hold(plot_outMFs);
        b  = buy(plot_outMFs);
        sb = strong_buy(plot_MFs);
        figure;plot( [plot_outMFs, ss, plot_outMFs, s, plot_outMFs, h, ...
                        plot_outMFs, b, plot_outMFs, sb] );
    end
    % ****************************************************************
    
    % Define the output centers for all of the output MFs
    ss = 0;
    s  = 30;
    h  = 50;
    b  = 70;
    sb = 100;
    
    % Following Table 1, put the MF center at a specific index so it can be
    % used to defuzzify
    centers = [ s; s; ss; s; s; ss; b; h; s; b; h; s; s; s; ss; h; s; ss; ...
                b; h; s; b; h; s; b; h; s; b; h; s; sb; b; h; sb; b; h; b; ...
                h; s; b; h; s; sb; b; h; sb; b; h ];
            
    % ************************ Output MFs *****************************
    function val = strong_sell(x)
        val = max( min( 1, ( 25 - x )/(25 - 0) ), 0 );
    end

    function val = sell(x)
        val = max( min( ( x - 15 )/(45-30), ( 45 - x )/(45-30) ), 0 );
    end

    function val = hold(x)
        val = max( min( ( x - 35 )/(50-35), ( 65 - x )/(65-50) ), 0 );
    end

    function val = buy(x)
        val = max( min( ( x - 55 )/(70-55), ( 85 - x )/(85-70) ), 0 );
    end

    function val = strong_buy(x)
        val = max( min( (x - 75)/(100 - 75),1 ), 0 );
    end

end