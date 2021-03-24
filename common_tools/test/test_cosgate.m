% test for cosgate.m

fs = 44100;

% Row vector
x = ones(1,fs);
y = cosgate(x, fs, .25);

t = (0:length(x)-1)/fs;

plot(t, y)


% Column vector
x = x';
y = cosgate(x, fs, .25);

hold on
plot(t, y, '-r')

hold off
