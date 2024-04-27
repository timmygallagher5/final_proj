% List of random stocks to predict
tick_list = { 'NOK'; 'TSLA'; 'SHEL'; 'NKE'; 'VGT'; 'VRT'; 'GOOG'; 'VNCE'; 'MLGO'; 'LMT' };

% Driver loop to run through each stock
for i=1: length(tick_list)
    
    % Convert symbol in order for it to work downstream
    ticker = char(tick_list(i));
    
    % This loop will change the offset for each stock.
    % The offset is used to change the start date of the data being used.
    % By default, the engine is setup to calculate a decsion using
    % yesterday's data. This is purposely done in order to compare the
    % decision to what acutally happened.  Changing the offset, will change
    % the closing prices for a given stock by shifting it back in time.
    for j=0:4
        
        % Run the prediction and print results
        [ cc, nc, out ] = fuzz_stock_pred( ticker,j );
        fprintf( 'Stock: %s | Current Close: %f | Next Close: %f | Defuzzied Out: %f\n', ticker, cc,nc,out);
    
    end
    
end

function [curr_close, next_close, out] = fuzz_stock_pred( ticker, offset )
% ************************************************************************
%
% Description
%   This function will get stock data for a given ticker.  The data will
%   then be fuzzified and defuzzified within this function.
%   This acts as a wrapper around all of the other functions needed to
%   accomplish the Simplified Sum-Product Inference Engine with CA defuzz.
%
% NOTE
%   In order to evaluate the effectiveness of the engine, the calculations
%   are not performed on today's data. This is done so the user can see the
%   decision the engine made and compare it what actually happened.  For
%   instance, the engine will calculate using yesterday's data and then the
%   decision made can be compared against today's closing price to see if
%   it was right or wrong.
%
% Inputs
%   ticker: The desired stock
%   offset: Used to offset the range of dates being used in the calculations 
%           so the fuzzy system can be evaluated for effectiveness.        
%
% Outputs
%   curr_close: The most recent closing price in the data that was used for
%               calcs
%   next_close: The closing price the day after the curr_close
%   out:        The defuzzified outputs
% ************************************************************************
    
    % Parameter in the problem
    NUM_RULES = 48;

    % Create a struct to store engine data
    stock = struct();
    stock.ticker = ticker;
    
    % Get closing data
    stock.raw_data = get_stock_data(ticker, '1-Jan-2018', datetime('today'), '1d');

    % Get the value we will compare the decision to
    next_close = stock.raw_data( end-offset );
    
    % Get the most closing price from the data set used in calcs
    curr_close = stock.raw_data( end-(1+offset) );
    
    % Get RSI for current data set
    stock.rsi  = calc_RSI( stock.raw_data( end-(15+offset):end-(1+offset) ) );
    
    % Get CCI
    stock.cci  = get_CCI([]);
    
    % Get MACD for current data set
    stock.macd = calc_MACD( stock.raw_data( end-(28+offset):end-(1+offset) ) );

    % Fuzzify the MACD, CCI, and RSI inputs
    stock.macd_fuzzy = fuzzify_macd( stock.macd,0 );
    stock.cci_fuzzy  = fuzzify_cci( stock.cci,0 );
    stock.rsi_fuzzy  = fuzzify_rsi( stock.rsi,0 );

    % Initialize array to hold the product of a current rule's values
    stock.h = zeros(1,NUM_RULES);
    
    % Get the output centers for the rule base
    stock.out_centers = get_output_centers( 0 );

    % Following Table 1 to loop through all of the fuzzy inputs and mutliply
    % the values together for a given rule
    current_rule = 1;
    for m=1: length(stock.macd_fuzzy)
        for c=1: length(stock.cci_fuzzy)
           for r=1: length(stock.rsi_fuzzy)
               stock.h(1,current_rule) = stock.macd_fuzzy(m)*stock.cci_fuzzy(c)*stock.rsi_fuzzy(r);
               current_rule = current_rule + 1;
           end
        end
    end

    % Sum Product Inference Engine with CA Defuzzification 
    defuzz = 0;
    for i=1: NUM_RULES
        defuzz = defuzz + stock.h(i)*stock.out_centers(i);
    end
    stock.defuzz = defuzz/sum( stock.h );
    
    out = stock.defuzz;

end
