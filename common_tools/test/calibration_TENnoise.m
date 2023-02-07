% Data from Moore et al. (2000) JAES, Fig. 9
% Extracted with WebPlotDigitizer.

dat = [ 56.74224223182155, 11.11385239244856; ...
        56.186798017741935, 11.27706084394175; ...
        59.08743957425362, 10.790117546589961; ...
        60.59624873760155, 10.482451443616497; ...
        62.14420269914844, 10.161029386150695; ...
        63.4712956254872, 9.741097952486141; ...
        65.36559120139593, 9.394381680788065; ...
        67.31502933150387, 9.076323647615688; ...
        69.0325035157561, 8.797315783167925; ...
        70.79778082543476, 8.440357509930255; ...
        72.45275611859401, 8.16711877535246; ...
        74.76875032766966, 7.855901237261422; ...
        76.99773265172901, 7.553891817663439; ...
        79.62520150333678, 7.233466161079349; ...
        82.34825805824775, 6.813309834425819; ...
        85.1597879100794, 6.468811257480141; ...
        88.06730886474827, 6.1243126805344605; ...
        91.07364608090566, 5.78669208083495; ...
        94.18389597254131, 5.430157043708476; ...
        97.39722061432767, 5.118328858682096; ...
        100.71905092869517, 4.821976122459596; ...
        104.15469271890369, 4.518745408990926; ...
        107.70897963917551, 4.196845900139799; ...
        111.85058897139635, 3.8613119861022813; ...
        116.63449911279153, 3.5469265803804273; ...
        121.62760891055392, 3.1802685475876924; ...
        127.3573248451631, 2.885066513825448; ...
        134.4745368402145, 2.569670160572196; ...
        141.98941858930448, 2.2549288527709628; ...
        148.67530144221863, 1.9881557916262143; ...
        156.33284307379694, 1.6590784482102858; ...
        165.06705382946993, 1.3626784130655007; ...
        174.28981593961691, 1.0616930597566014; ...
        184.79612960407871, 0.759977696666029; ...
        196.75699540597284, 0.4345566045643192; ...
        212.1239292151455, 0.12472996713982276; ...
        230.6020912012362, -0.17252234103857944; ...
        251.73517427876763, -0.46359690695921785; ...
        273.6625492701616, -0.7541101869267308; ...
        297.5003841720752, -1.0468466514586616; ...
        326.1194094218453, -1.336120369732729; ...
        357.48637243226545, -1.6053854269270325; ...
        391.85896725159466, -1.8346331619618148; ...
        429.5388404388756, -2.0713841449015042; ...
        470.84528687722934, -2.3181394583810793; ...
        516.1081123181725, -2.5223763670661583; ...
        565.6904373046993, -2.649079714067156; ...
        620.0154101969238, -2.729513032321208; ...
        679.5579888636125, -2.8111968918927452; ...
        744.8099409317279, -2.876623714336972; ...
        816.3444103882639, -2.9708129870833595; ...
        894.7162165815296, -3.0137300658128545; ...
        980.5987017070146, -3.0378890247800783; ...
        1074.7006660563613, -3.0307844508101667; ...
        1177.8500228757878, -3.043688537920019; ...
        1290.8937888972675, -3.0503399184424502; ...
        1414.7715676083933, -3.041984803155053; ...
        1550.5370044602491, -3.033629687867659; ...
        1699.343144212276, -3.0352789031201475; ...
        1862.467301912425, -3.0644400273573105; ...
        2041.2059291280782, -3.063588159974824; ...
        2237.07970130105, -3.051481420734973; ...
        2451.753913539242, -3.041875764130097; ...
        2687.077162926608, -3.0572809338749174; ...
        2944.9738208971858, -3.0664333970323163; ...
        3227.5671785269124, -3.0518255751574976; ...
        3537.3063251103404, -3.048472625140043; ...
        3876.7491351509625, -3.037616427217678; ...
        4248.884051935649, -3.0655270101373553; ...
        4656.681902880647, -3.07593001461224; ...
        5103.605406927827, -3.0825813951346674; ...
        5593.381853335339, -3.0792284451172165; ...
        6130.182690309623, -3.080877660369705; ...
        6718.5249446318985, -3.0875290408921288; ...
        7363.253390546308, -3.079173925604735; ...
        8069.822643151197, -3.065816645047402; ...
        8844.209428676546, -3.0549604471250333; ...
        9693.064500115444, -3.0666139929174037; ...
        10623.24767131274, -3.0595094189474956; ...
        11642.684231887188, -3.051154303660102; ...
        12759.902703086522, -3.0377970231027653; ...
        13984.5048934393, -3.041947320990225; ...
        14824.323198165357, -3.046748445557899];

figure(42)
semilogx(dat(:,1),dat(:,2), '+')

s = 6;
x_spline = log([dat(1:s:end,1); 20000; 40000]);
y_spline = [dat(1:s:end,2); dat(end,2); dat(end,2)];
K_spline = spline(x_spline, y_spline);

hold on
semilogx(dat(1:s:end,1), dat(1:s:end,2), 'o');
f = linspace(log(dat(1,1)/2), log(dat(end,1)*2), 1000);
semilogx(exp(f), ppval(K_spline, f))
hold off

% Saving to TENnoise.m

str = fileread('../TENnoise.m');
new_K_spline_literal = sprintf('%%<K_spline_json>\n%s;\n%%</K_spline_json>', struct_to_literal(K_spline, 'K_spline', '    '));
new_str = regexprep(str, '%<K_spline_json>\n.*\n%</K_spline_json>', new_K_spline_literal);
fid = fopen('../TENnoise.m', 'w');
fprintf(fid, '%s', new_str);
fclose(fid);

%------ Testing speed of jsondecode vs. literal
%{
N = 1000;
tic
for i=1:N
    K_spline_json = '{"form":"pp","breaks":[4.0385189462562581,4.1799959915900082,4.3437759753386977,4.5452492112622185,4.759045105906722,5.0519873437847469,5.4406936763161129,5.9709019976356377,6.5214425704408736,7.0714460410602626,7.6212960539122676,8.1711207913672919,8.72097983114679,9.2708000551380678,9.9034875525361272,10.596634733096073],"coefs":[[-4.519266668778422,5.0200960908643246,-12.773479929467161,11.11385239244856],[-4.5192666687784726,3.1019786047421,-11.624392799552744,9.3943816807880651],[6.2417003026700364,0.88148234003656967,-10.971981630753366,7.5538918176634393],[1.1626546636996522,4.654089012967864,-9.8567121575780288,5.4301570437084763],[-3.7177161531014011,5.3998013949326626,-7.70723166316314,3.5469265803804273],[-0.2667651408333015,2.1325731258782525,-5.5006810145013771,1.6590784482102858],[-0.48693099975306858,1.8214932272566815,-3.9637103837886265,-0.17252234103857944],[0.30552257306376412,1.046968623324138,-2.4428280412230694,-1.8346331619618148],[-0.8722474383801877,1.5515763404625011,-1.0122236083998122,-2.8111968918927452],[-0.0030369809055149043,0.11235898541857622,-0.097053404279015348,-3.0436885379200191],[-0.18287681551749871,0.10734933344879026,0.02375321767389851,-3.0635881599748238],[0.23800645954255562,-0.1943012577867686,-0.024055101296439584,-3.0484726251400431],[-0.15983527170003634,0.19830875212939447,-0.021851544305281561,-3.0808776603697048],[0.025591020897331927,-0.065333242534067568,0.051261080165775352,-3.0595094189474956],[0.025591020897331927,-0.016759885631884443,-0.00067821564711896326,-3.046748445557899]],"pieces":15,"order":4,"dim":1}';
    K_spline = jsondecode(K_spline_json);
end
toc

tic
for i=1:N
    K_spline = struct('form', 'pp', ...
         'breaks', [4.0385, 4.18, 4.3438, 4.5452, 4.759, 5.052, 5.4407, 5.9709, 6.5214, 7.0714, 7.6213, 8.1711, 8.721, 9.2708, 9.9035, 10.5966], ...
         'coefs', [-4.5193, 5.0201, -12.7735, 11.1139 ; -4.5193, 3.102, -11.6244, 9.3944 ; 6.2417, 0.88148, -10.972, 7.5539 ; 1.1627, 4.6541, -9.8567, 5.4302 ; -3.7177, 5.3998, -7.7072, 3.5469 ; -0.26677, 2.1326, -5.5007, 1.6591 ; -0.48693, 1.8215, -3.9637, -0.17252 ; 0.30552, 1.047, -2.4428, -1.8346 ; -0.87225, 1.5516, -1.0122, -2.8112 ; -0.003037, 0.11236, -0.097053, -3.0437 ; -0.18288, 0.10735, 0.023753, -3.0636 ; 0.23801, -0.1943, -0.024055, -3.0485 ; -0.15984, 0.19831, -0.021852, -3.0809 ; 0.025591, -0.065333, 0.051261, -3.0595 ; 0.025591, -0.01676, -0.00067822, -3.0467], ...
         'pieces', 15, ...
         'order', 4, ...
         'dim', 1);
end
toc
%}
% Literals are about 10x faster