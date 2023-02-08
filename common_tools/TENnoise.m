function [x, fs] = TENnoise(d, fs, variant)

%[X, FS] = TENNOISE(D, FS)
%   Generates a threshold equalizing noise (Moore et al., 2000) of duration D,
%   at sampling frequency FS. Intensity is set at 0 dB/ERBN. D is expressed in seconds.
%
%   [X, FS] = TENNOISE(D, FS, VARIANT)
%       VARIANT is either 'equation' or 'figure'. Following Eq.(2) from
%       Moore et al. (2000) gives slightly different results from those
%       shown in their Fig.1. When choose 'equation', the TEN is generated
%       using Eq.(2):
%                             Ps = No.K.ERB
%       With the values of K from Fig.9 of Moore et al. (1997).
%       If VARIANT is 'figure', the values of K are slightly modified to
%       better fit Fig.1.
%   
%
%   References:
%     Moore, Huss, Vickers, Glasberg, Alcantara, (2000)
%         "A test for the diagnosis of dead regions in the cochlea."
%         Br. J. Audiol. 34, 205-224.
%     Moore, Glasberg, Baer, (1997)
%         "A model for the prediction of thresholds, loudness, and partial
%         loudness." J. Audio Eng. Soc. 45(4), 224-240.
%
% IMPORTANT NOTE: This code does not include headphone corrections.


if nargin<3
    variant = 'equation';
end

n = 2*floor(d/2*fs);
x = rand(n, 1)*2-1;

X = fft(x);
f = (0:n-1)'/(n-1)*fs;
f = [f(1:n/2); f(n/2:-1:1)];

f_low = 50;
X(f<f_low) = X(f<f_low) .* (f(f<f_low)/f_low).^1;
f_high = 15000;
X(f>f_high) = X(f>f_high) .* (f(f>f_high)/f_high).^-6;

fn0 = f~=0;

switch variant
    case 'equation'
        Kd = 10;
    case 'figure'
        Kd = 8;
    otherwise
        error('"%s" is not supported as variant.', variant);
end

X(fn0) = X(fn0) ./ (ERBNwidth(f(fn0)) .* 10.^(K(f(fn0))/Kd)).^.5;

% if do_elc
%     X = X .* elc(f);
% end

x = ifft(X, 'symmetric');

%==========================================================================

function w = ERBNwidth(f)

w = 24.7*(4.37e-3 * f + 1);

%==========================================================================
% Keeping this only for future reference
%{ 
function T = elc(f)

f1 = [	20, 25, 30, 35, 40, 45, 50, 55, 60, 70, 80, 90, 100, ...
	125, 150, 177, 200, 250, 300, 350, 400, 450, 500, 550, ...
	600, 700, 800, 900, 1000, 1500, 2000, 2500, 2828, 3000, ...
	3500, 4000, 4500, 5000, 5500, 6000, 7000, 8000, 9000, 10000, ...
	12748, 15000];

ELC = [ 31.8, 26.0, 21.7, 18.8, 17.2, 15.4, 14.0, 12.6, 11.6, 10.6, ...
	9.2, 8.2, 7.7, 6.7, 5.3, 4.6, 3.9, 2.9, 2.7, 2.3, ...
	2.2, 2.3, 2.5, 2.7, 2.9, 3.4, 3.9, 3.9, 3.9, 2.7, ...
	0.9, -1.3, -2.5, -3.2, -4.4, -4.1, -2.5, -0.5, 2.0, 5.0, ...
	10.2, 15.0, 17.0, 15.5, 11.0, 22.0];

% MAF = [ 73.4, 65.2, 57.9, 52.7, 48.0, 45.0, 41.9, 39.3, 36.8, 33.0, ...
% 	29.7, 27.1, 25.0, 22.0, 18.2, 16.0, 14.0, 11.4, 9.2, 8.0, ...
% 	 6.9,  6.2,  5.7,  5.1,  5.0,  5.0,  4.4,  4.3, 3.9, 2.7, ...
% 	 0.9, -1.3, -2.5, -3.2, -4.4, -4.1, -2.5, -0.5, 2.0, 5.0, ...
% 	10.2, 15.0, 17.0, 15.5, 11.0, 22.0]; 

T = 10.^(-interp1(f1, ELC, f, 'spline', 0)/20);
%}

%==========================================================================
function k = K(f)

% The code below is generated by fitting a cubic spline to the data from
% Fig.9 of Moore et al. (1997).

% Run test/calibration_TENnoise.m to update this code
%<K_spline_json>
K_spline = struct('form', 'pp', ...
    'breaks', [4.0385, 4.18, 4.3438, 4.5452, 4.759, 5.052, 5.4407, 5.9709, 6.5214, 7.0714, 7.6213, 8.1711, 8.721, 9.2708, 9.9035, 10.5966], ...
    'coefs', [-4.5193, 5.0201, -12.7735, 11.1139 ; ...
        -4.5193, 3.102, -11.6244, 9.3944 ; ...
        6.2417, 0.88148, -10.972, 7.5539 ; ...
        1.1627, 4.6541, -9.8567, 5.4302 ; ...
        -3.7177, 5.3998, -7.7072, 3.5469 ; ...
        -0.26677, 2.1326, -5.5007, 1.6591 ; ...
        -0.48693, 1.8215, -3.9637, -0.17252 ; ...
        0.30552, 1.047, -2.4428, -1.8346 ; ...
        -0.87225, 1.5516, -1.0122, -2.8112 ; ...
        -0.003037, 0.11236, -0.097053, -3.0437 ; ...
        -0.18288, 0.10735, 0.023753, -3.0636 ; ...
        0.23801, -0.1943, -0.024055, -3.0485 ; ...
        -0.15984, 0.19831, -0.021852, -3.0809 ; ...
        0.025591, -0.065333, 0.051261, -3.0595 ; ...
        0.025591, -0.01676, -0.00067822, -3.0467], ...
    'pieces', 15, ...
    'order', 4, ...
    'dim', 1);
%</K_spline_json>

k = ppval(K_spline, log(f));

