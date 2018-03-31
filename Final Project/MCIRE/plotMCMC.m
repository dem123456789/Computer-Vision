function plotMCMC(samples)
    num_param = size(samples,1);
    for i=1:num_param
    cur_param = samples(i,1:end);
    figure
    autocorr(cur_param,100)
    figure
    plot(cur_param)
    end
end