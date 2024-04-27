function macd = calc_MACD(closing_data)
% ************************************************************************
%
% Description
%   This function calculates the MACD for a given set of data.
%   MACD is calculated by using the exponential moving average (ema) for the last
%   26 days and 12 days.
%   The ema is calculated by the following equation:
%       [most recent closing price*k] - [ema_prev*(1-k)]
%   where k = 2/(N+1) and N = Number of periods.
%   As stated before, the ema for N = 26 and 12 are calculated to get MACD.
%   The equation for MACD is:
%       ema12 - ema26
%
% Inputs
%   closing_data: An array of closing data stocks for a given stock.
%                 NOTE: Array must greater than or equal to 27.
%
% Outputs
%   macd: The MACD value for a given set of closing prices.
% ************************************************************************

% Define the N for the 2 different calculations
n26 = 26;
n12 = 12;

% Define the smoothing coeff for each ema calculation
k26 = 2/(n26+1);
k12 = 2/(n12+1);

% Calculate the necessary previous EMA values for the MACD calc
curr_close  = closing_data(end);
ema_26_prev = mean( closing_data(end-26:end-1) );
ema_12_prev = mean( closing_data(end-12:end-1) );

% Calculate the EMA values for the current periods
ema_26 = ( curr_close*k26 ) + ( ema_26_prev*(1-k26) );
ema_12 = ( curr_close*k12 ) + ( ema_12_prev*(1-k12) );

% Calculate the MACD value
macd = ema_12 - ema_26;

end