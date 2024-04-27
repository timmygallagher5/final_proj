% List of random stocks to predict
tick_list = { 'NOK'; 'TSLA'; 'SHEL'; 'NKE'; 'VGT'; 'VRT'; 'GOOG'; 'VNCE'; 'MLGO'; 'LMT' };

% Driver loop to run through each stock
for i=1: length(tick_list)
    
    % Convert symbol in order for it to work downstream
    ticker = char(tick_list(i));
    
    % This loop will change the offset for each stock.
    % The offset is used to change the start date.
    % When the offset is 0, the prediction will be done on the most recent
    % data.  When it is 1, it will use yesterday's data.
    % The offset is added so the same stock can used multiple times 
    for j=0:4
        
        % Run the prediction and print results
        [ pc, cc, out ] = fuzz_stock_pred( ticker,j );
        fprintf( 'Stock: %s | Previous Close: %f | Current Close: %f | Defuzzied Out: %f\n', ticker, pc,cc,out);
    
    end
    
end

function [prev_close, curr_close, out] = fuzz_stock_pred( ticker, offset )
%
    stock = struct();
    stock.ticker = ticker;
    stock.raw_data = get_stock_data(ticker, '1-Jan-2018', datetime('today'), '1d');

    NUM_RULES = 48;

    curr_close = stock.raw_data( end-offset );
    prev_close = stock.raw_data( end-(1+offset) );
    stock.rsi  = calc_RSI( stock.raw_data( end-(15+offset):end-(1+offset) ) );
    stock.cci  = get_CCI([]);
    stock.macd = calc_MACD( stock.raw_data( end-(28+offset):end-(1+offset) ) );

    stock.macd_fuzzy = fuzzify_macd( stock.macd,0 );
    stock.cci_fuzzy  = fuzzify_cci( stock.cci,0 );
    stock.rsi_fuzzy  = fuzzify_rsi( stock.rsi,0 );

    stock.h = zeros(1,NUM_RULES);

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

    defuzz = 0;
    for i=1: NUM_RULES
        defuzz = defuzz + stock.h(i)*stock.out_centers(i);
    end

    stock.defuzz = defuzz/sum( stock.h );
    
    out = stock.defuzz;

end
