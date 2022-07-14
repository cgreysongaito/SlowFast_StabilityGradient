#### Code to create figures
#### "Slow organisms exhibit sudden population disappearances in a reddened world" by Greyson-Gaito, Gellner, & McCann.

include("packages.jl")
include("slowfast_commoncode.jl")

# Figure 2 (primer of different trajectories)
let
    sol_qcyc = RozMac_pert(1.0, 0.71, 1, 0.0, 1234, 5000.0, 2500:2.0:5000.0)
    sol_equil = RozMac_pert(0.1, 0.71, 1, 0.0, 1234, 5000.0, 2500:2.0:5000.0)
    sol_qcan = RozMac_pert(0.01, 0.71, 1, 0.0, 6, 3600.0, 2750.0:1.0:3100.0)
    figure2 = figure(figsize=(10,4))
    subplot(2,3,1)
    iso_plot(0.0:0.1:3.0, RozMacPar(e = 0.71))  
    plot(sol_qcyc[1, :], sol_qcyc[2, :], color = "#FDE725FF")
    xlabel("Resource")
    ylabel("Consumer")
    ylim(0,2.5)
    xlim(0,3.0)
    subplot(2,3,2)
    iso_plot(0.0:0.1:3.0, RozMacPar(e = 0.71))
    plot(sol_equil[1, :], sol_equil[2, :], color = "#73D055FF")
    xlabel("Resource")
    ylabel("Consumer")
    ylim(0,2.5)
    xlim(0,3.0)
    subplot(2,3,3)
    iso_plot(0.0:0.1:3.0, RozMacPar(e = 0.71))
    plot(sol_qcan[1, :], sol_qcan[2, :], color = "#440154FF")
    ylim(0,2.5)
    xlim(0,3.0)
    xlabel("Resource")
    ylabel("Consumer")
    subplot(2,3,4)
    plot(sol_qcyc.t, sol_qcyc.u)
    ylim(0,3.0)
    xlabel("Time")
    ylabel("Biomass")
    tick_params(axis="x", which="both", bottom=False, labelbottom=False)
    subplot(2,3,5)
    plot(sol_equil.t, sol_equil.u)
    ylim(0,3.0)
    tick_params(axis="x", which="both", bottom=False, labelbottom=False)
    xlabel("Time")
    ylabel("Biomass")
    subplot(2,3,6)
    plot(sol_qcan.t, sol_qcan.u)
    tick_params(axis="x", which="both", bottom=False, labelbottom=False)
    xlabel("Time")
    ylabel("Biomass")
    ylim(0,3.0)
    tight_layout()
    # return figure2
    savefig(joinpath(abpath(), "figs/phase_timeseries_examples.pdf"))
end

#Figure 3
CVresult_eff05 = CSV.read(joinpath(abpath(),"data/CVresult_eff05.csv"), DataFrame)
CVresult_eff071 = CSV.read(joinpath(abpath(),"data/CVresult_eff071.csv"), DataFrame)

let
    CVresult = figure()
    plot(CVresult_eff05.eprange, CVresult_eff05.CV, color="black", linestyle="dashed")
    plot(CVresult_eff071.eprange, CVresult_eff071.CV, color="black")
    xlabel("Log10 of 1/ϵ", fontsize=12)
    ylabel("CV", fontsize=12)
    xticks(fontsize=12)
    yticks(fontsize=12)
    yticks(0.00:0.05:0.35)
    # return CVresult
    savefig(joinpath(abpath(), "figs/Fig3_CVresult.pdf"))
end

# Figure 4 (ACF plots of quasi-cycles)
let 
    lrange = 0:1:40
    acffast_eff071 = quasicycle_data(1.0, 0.71, 1)
    eff071fast_timeseries = RozMac_pert(1.0, 0.71, 1, 0.0, 1234, 5000.0, 4000:2.0:5000.0)
    acfslow_eff071 = quasicycle_data(0.1, 0.71, 1)
    eff071slow_timeseries = RozMac_pert(0.1, 0.71, 1, 0.0, 1234, 5000.0, 4000:2.0:5000.0)
    acffast_eff05 = quasicycle_data(1.0, 0.5, 1)
    eff05fast_timeseries = RozMac_pert(1.0, 0.5, 1, 0.0, 1234, 5000.0, 4000:2.0:5000.0)
    acfslow_eff05 = quasicycle_data(0.1, 0.5, 1)
    eff05slow_timeseries = RozMac_pert(0.1, 0.5, 1, 0.0, 1234, 5000.0, 4000:2.0:5000.0)
    acffigure = figure(figsize = (6,8))
    subplot(3,2,1)
    plot(collect(lrange), acffast_eff05, color = "black")
    plot(collect(lrange), acfslow_eff05, color = "black", linestyle="dashed")
    hlines(0.0,0.0,40.0, linestyles=`dashed`, linewidths=0.5)
    ylim(-1,1)
    xlim(0,40)
    xlabel("Lag")
    ylabel("Average ACF")
    subplot(3,2,2)
    plot(collect(lrange), acffast_eff071, color = "black")
    plot(collect(lrange), acfslow_eff071, color = "black", linestyle="dashed")
    hlines(0.0,0.0,40.0, linestyles=`dashed`, linewidths=0.5)
    ylim(-1,1)
    xlim(0,40)
    xlabel("Lag")
    ylabel("Average ACF")
    subplot(3,2,3)
    plot(eff05slow_timeseries.t, eff05slow_timeseries[2,1:end], color = "black", linestyle="dashed")
    ylim(1.5,3.0)
    xlabel("Time")
    ylabel("Biomass")
    tick_params(axis="x", which="both", bottom=False, labelbottom=False)
    subplot(3,2,4)
    plot(eff071slow_timeseries.t, eff071slow_timeseries[2,1:end], color = "black", linestyle="dashed")
    ylim(1.5,3.0)
    xlabel("Time")
    ylabel("Biomass")
    tick_params(axis="x", which="both", bottom=False, labelbottom=False)
    subplot(3,2,5)
    plot(eff05fast_timeseries.t, eff05fast_timeseries[2,1:end], color = "black")
    ylim(1.5,3.0)
    xlabel("Time")
    ylabel("Biomass")
    tick_params(axis="x", which="both", bottom=False, labelbottom=False)
    subplot(3,2,6)
    plot(eff071fast_timeseries.t, eff071fast_timeseries[2,1:end], color = "black")
    ylim(1.5,3.0)
    xlabel("Time")
    ylabel("Biomass")
    tick_params(axis="x", which="both", bottom=False, labelbottom=False)
    tight_layout()
    return acffigure
    # savefig(joinpath(abpath(), "figs/quasicycles_ACF.pdf"))
end



# Figure 5 (Proportion real with large delta ε & quasi-canard proportions with white noise )
#####*****NEED TO CHANGE to 0.71
wn_data05_long_RozMac = CSV.read(joinpath(abpath(),"data/wn_eff05_long_RozMac.csv"), DataFrame)
wn_data07_long_RozMac = CSV.read(joinpath(abpath(),"data/wn_eff07_long_RozMac.csv"), DataFrame)
rn_data_ep0004eff05_RozMac = CSV.read(joinpath(abpath(),"data/rn_ep0004eff05_RozMac.csv"), DataFrame)
rn_data_ep0004eff07_RozMac = CSV.read(joinpath(abpath(),"data/rn_ep0004eff07_RozMac.csv"), DataFrame)
rn_data_ep0079eff05_RozMac = CSV.read(joinpath(abpath(),"data/rn_ep0079eff05_RozMac.csv"), DataFrame)
rn_data_ep0079eff07_RozMac = CSV.read(joinpath(abpath(),"data/rn_ep0079eff07_RozMac.csv"), DataFrame)

let
    figure5 = figure() #figsize = (7,2.5))
    subplot(3,2,1)
    plot(log10.(1 ./ wn_data05_long_RozMac.xrange), wn_data05_long_RozMac.canard, color = "black", linewidth=2)
    vlines(1.10, 0.0, 1.0, color = "black", linestyle = "dashed", linewidth = 1)
    vlines(2.40, 0.0, 1.0, color = "black", linestyle = "dashed", linewidth = 1)
    ylabel("Proportion with\nquasi-canard", fontsize = 15)
    xlabel("Log10 of 1/ϵ", fontsize = 15)
    ylim(0,1)
    xticks(fontsize=12)
    yticks(fontsize=12)
    subplot(3,2,2)
    plot(log10.(1 ./ wn_data07_long_RozMac.xrange), wn_data07_long_RozMac.canard, color = "black", linewidth=2)
    vlines(1.10, 0.0, 1.0, color = "black", linestyle = "dashed", linewidth = 1)
    vlines(2.40, 0.0, 1.0, color = "black", linestyle = "dashed", linewidth = 1)
    ylim(0,1)
    xticks(fontsize=12)
    yticks(fontsize=12)
    xlabel("Log10 of 1/ϵ", fontsize = 15)
    subplot(3,2,3)
    fill_between(rn_data_ep0079eff05_RozMac.xrange, rn_data_ep0079eff05_RozMac.canard, color="#440154FF")
    fill_between(rn_data_ep0079eff05_RozMac.xrange, rn_data_ep0079eff05_RozMac.canard, rn_data_ep0079eff05_RozMac.canard_plus_axial, color="#404788FF")
    fill_between(rn_data_ep0079eff05_RozMac.xrange, fill(1.0,91), rn_data_ep0079eff05_RozMac.canard_plus_axial, color="#73D055FF")
    ylabel("Proportion", fontsize=15)
    xlabel("Noise correlation", fontsize=15)
    ylim(0,1)
    xticks(fontsize=12)
    yticks(fontsize=12)
    subplot(3,2,4)
    fill_between(rn_data_ep0079eff07_RozMac.xrange, rn_data_ep0079eff07_RozMac.canard, color="#440154FF")
    fill_between(rn_data_ep0079eff07_RozMac.xrange, rn_data_ep0079eff07_RozMac.canard, rn_data_ep0079eff07_RozMac.canard_plus_axial, color="#404788FF")
    fill_between(rn_data_ep0079eff07_RozMac.xrange, fill(1.0,91), rn_data_ep0079eff07_RozMac.canard_plus_axial, color="#73D055FF")
    ylabel("Proportion", fontsize=15)
    xlabel("Noise correlation", fontsize=15)
    ylim(0,1)
    xticks(fontsize=12)
    yticks(fontsize=12)
    subplot(3,2,5)
    fill_between(rn_data_ep0004eff05_RozMac.xrange, rn_data_ep0004eff05_RozMac.canard, color="#440154FF")
    fill_between(rn_data_ep0004eff05_RozMac.xrange, rn_data_ep0004eff05_RozMac.canard, rn_data_ep0004eff05_RozMac.canard_plus_axial, color="#404788FF")
    fill_between(rn_data_ep0004eff05_RozMac.xrange, fill(1.0,91), rn_data_ep0004eff05_RozMac.canard_plus_axial, color="#73D055FF")
    ylabel("Proportion", fontsize=15)
    xlabel("Noise correlation", fontsize=15)
    ylim(0,1)
    xticks(fontsize=12)
    yticks(fontsize=12)
    subplot(3,2,6)
    fill_between(rn_data_ep0004eff07_RozMac.xrange, rn_data_ep0004eff07_RozMac.canard, color="#440154FF")
    fill_between(rn_data_ep0004eff07_RozMac.xrange, rn_data_ep0004eff07_RozMac.canard, rn_data_ep0004eff07_RozMac.canard_plus_axial, color="#404788FF")
    fill_between(rn_data_ep0004eff07_RozMac.xrange, fill(1.0,91), rn_data_ep0004eff07_RozMac.canard_plus_axial, color="#73D055FF")
    ylabel("Proportion", fontsize=15)
    xlabel("Noise correlation", fontsize=15)
    ylim(0,1)
    xticks(fontsize=12)
    yticks(fontsize=12)
    tight_layout()
    return figure5
    # savefig(joinpath(abpath(), "figs/canard_whitenoise_prop.pdf"))
end

# Figure 6 (Ratchet)
let 
    figure6 = figure(figsize = (3,4))
    subplot(2,1,1)
    roz_mac_plot(0.01, 0.48, 2, 0.3)
    subplot(2,1,2)
    roz_mac_plot(0.01, 0.48, 2, 0.3)
    tight_layout()
    # return figure6
    savefig(joinpath(abpath(), "figs/ratchet_schematic.pdf"))
end


## Supporting Information

#SI Figure 1 (illustration of quasi-canard finder algorithm)
let
    sol_qc = RozMac_pert(0.01, 0.55, 1, 0.7, 45, 1500.0, 0.0:1.0:1500.0)
    figure2 = figure(figsize=(7,5))
    iso_plot(0.0:0.1:3.0, RozMacPar(e = 0.55))  
    plot(sol_qc[1, :], sol_qc[2, :], color = "#440154FF", linewidth=5)
    xlabel("Resource", fontsize=15)
    ylabel("Consumer", fontsize=15)
    ylim(0, 2.5)
    xlim(0, 3)
    # return figure2
    savefig(joinpath(abpath(), "figs/quasicanardfinder.pdf"))
end

#SI Figure 2  (Isoclines for Rosenzweig-MacArthur consumer-resource model)
let
    isoclines = figure(figsize = (6,2.5))
    subplot(1,3,1)
    iso_plot(0.0:0.1:3.0, RozMacPar(e = 0.5))
    title("Non-excitable\n(Real λ)", fontsize=15)
    ylim(0,2.5)
    xlim(0.0,3.0)
    xticks(fontsize=12)
    yticks(fontsize=12)
    ylabel("Consumer", fontsize=15)
    xlabel("Resource", fontsize=15)
    subplot(1,3,2)
    iso_plot(0.0:0.1:3.0, RozMacPar(e = 0.65))
    title("Excitable\n(Complex λ)", fontsize=15)
    xlabel("Resource", fontsize=15)
    ylim(0,2.5)
    xlim(0.0,3.0)
    xticks(fontsize=12)
    yticks(fontsize=12)
    subplot(1,3,3)
    iso_plot(0.0:0.1:3.0, RozMacPar(e = 0.7))
    title("Excitable\n(Near Hopf)", fontsize=15)
    xlabel("Resource", fontsize=15)
    ylim(0,2.5)
    xlim(0.0,3.0)
    xticks(fontsize=12)
    yticks(fontsize=12)
    tight_layout()
    # return isoclines
    savefig(joinpath(abpath(), "figs/isoclinesSI.pdf"))
end


# SI Figure 3 (Yodiz & Innes model with white noise)
wn_R12_short_YodInn = CSV.read(joinpath(abpath(),"data/wn_R12_short_YodInn.csv"), DataFrame)
wn_R10_short_YodInn = CSV.read(joinpath(abpath(),"data/wn_R10_short_YodInn.csv"), DataFrame)
wn_R08_short_YodInn = CSV.read(joinpath(abpath(),"data/wn_R08_short_YodInn.csv"), DataFrame)
wn_R12_long_YodInn = CSV.read(joinpath(abpath(),"data/wn_R12_long_YodInn.csv"), DataFrame)
wn_R10_long_YodInn = CSV.read(joinpath(abpath(),"data/wn_R10_long_YodInn.csv"), DataFrame)
wn_R08_long_YodInn = CSV.read(joinpath(abpath(),"data/wn_R08_long_YodInn.csv"), DataFrame)

let
    SIfigure3 = figure(figsize = (10,6))
    subplot(2,3,1)
    iso_plot_YodInn(0.0:0.1:3.0, YodInnScalePar(R₀ = 1.2))
    ylim(0,0.5)
    xlim(0.0,3.0)
    ylabel("Consumer", fontsize=15)
    xlabel("Resource", fontsize=15)
    xticks(fontsize=12)
    yticks(fontsize=12)
    subplot(2,3,2)
    iso_plot_YodInn(0.0:0.1:3.0, YodInnScalePar(R₀ = 1.0))
    ylim(0,0.5)
    xlim(0.0,3.0)
    ylabel("Consumer", fontsize=15)
    xlabel("Resource", fontsize=15)
    xticks(fontsize=12)
    yticks(fontsize=12)
    subplot(2,3,3)
    iso_plot_YodInn(0.0:0.1:3.0, YodInnScalePar(R₀ = 0.8))
    ylim(0,0.5)
    xlim(0.0,3.0)
    ylabel("Consumer", fontsize=15)
    xlabel("Resource", fontsize=15)
    xticks(fontsize=12)
    yticks(fontsize=12)
    subplot(2,3,4)
    plot(1 ./ wn_R12_short_YodInn.xrange, wn_R12_short_YodInn.canard, color = "black", linestyle = "dashed")
    plot(1 ./ wn_R12_long_YodInn.xrange, wn_R12_long_YodInn.canard, color = "black", linestyle = "dotted")
    ylabel("Proportion with\nquasi-canard", fontsize=15)
    xlabel("1/ϵ", fontsize=15)
    ylim(0,1)
    xticks(fontsize=12)
    yticks(fontsize=12)
    subplot(2,3,5)
    plot(1 ./ wn_R10_short_YodInn.xrange, wn_R10_short_YodInn.canard, color = "black", linestyle = "dashed")
    plot(1 ./ wn_R10_long_YodInn.xrange, wn_R10_long_YodInn.canard, color = "black", linestyle = "dotted")
    ylim(0,1)
    xticks(fontsize=12)
    yticks(fontsize=12)
    xlabel("1/ϵ", fontsize=15)
    subplot(2,3,6)
    plot(1 ./ wn_R08_short_YodInn.xrange, wn_R08_short_YodInn.canard, color = "black", linestyle = "dashed")
    plot(1 ./ wn_R08_long_YodInn.xrange, wn_R08_long_YodInn.canard, color = "black", linestyle = "dotted")
    xlabel("1/ϵ", fontsize=15)
    ylim(0,1)
    xticks(fontsize=12)
    yticks(fontsize=12)
    tight_layout()
    # return SIfigure3
    savefig(joinpath(abpath(), "figs/canard_whitenoise_prop_YodInn.pdf"))
end

# Code to make resource isocline data for quasipotential figures (created in R)
resiso_data_05 = DataFrame(xrange = 0.0:0.01:3.0, resiso = [res_iso_roz_mac(R, RozMacPar(e = 0.5)) for R in 0.0:0.01:3.0])
CSV.write(joinpath(abpath(), "data/resiso_data_05.csv"), resiso_data_05)
con_iso_roz_mac(RozMacPar(e = 0.5))

resiso_data_07 = DataFrame(xrange = 0.0:0.01:3.0, resiso = [res_iso_roz_mac(R, RozMacPar(e = 0.7)) for R in 0.0:0.01:3.0])
CSV.write(joinpath(abpath(), "data/resiso_data_07.csv"), resiso_data_07)
con_iso_roz_mac(RozMacPar(e = 0.7))