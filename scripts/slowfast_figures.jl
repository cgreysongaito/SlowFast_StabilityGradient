#### Code to create figures
#### "Slow organisms exhibit sudden population disappearances in a reddened world" by Greyson-Gaito, Gellner, & McCann.

include("packages.jl")
include("slowfast_commoncode.jl")

# Box 1 Figure 1 (Quasicycles versus quasicanards)
let 
    detqcyep = 1
    qcaep = 0.01
    eff = 0.7
    u0 = [1.75,1.75]
    detqcy_tend = 120.0
    tspan = (0.0, detqcy_tend)
    qca_tend = 1200.0

    detprob = ODEProblem(roz_mac_II!, u0, tspan, RozMacPar(ε = detqcyep, e = eff))
    detsol = DifferentialEquations.solve(detprob, reltol = 1e-8)
    qcysol = RozMac_pert(detqcyep, eff, 1.0, 0.0, 1, detqcy_tend, 0.0:1.0:detqcy_tend)
    qcasol = RozMac_pert(qcaep, eff, 1.0, 0.0, 123, qca_tend, 0.0:1.0:qca_tend)

    box1figure = figure(figsize = (11, 3))
    subplot(1,3,1)
    plot(detsol.t, detsol.u)
    xlabel("Time", fontsize = 15)
    ylabel("Density", fontsize = 15)
    ylim(0.5, 2.75)
    xticks([0,20,40,60,80,100,120],fontsize=12)
    yticks([0.5,1.0, 1.5, 2.0, 2.5], fontsize=12)
    subplot(1,3,2)
    plot(qcysol.t, qcysol.u)
    xlabel("Time", fontsize = 15)
    ylabel("Density", fontsize = 15)
    ylim(0.5, 2.75)
    yticks([0.5,1.0, 1.5, 2.0, 2.5], fontsize=12)
    xticks([0,20,40,60,80,100,120], fontsize=12)
    subplot(1,3,3)
    plot(qcasol.t, qcasol.u)
    xlabel("Time", fontsize = 15)
    ylabel("Density", fontsize = 15)
    ylim(0, 2.75)
    xticks([0,200,400,600,800,1000,1200], fontsize=12)
    yticks(fontsize=12)
    tight_layout()
    # return box1figure
    savefig(joinpath(abpath(), "figs/box1figure.pdf"))
end

# Figure 2 (primer of different trajectories)
let
    sol_axial = RozMac_pert(0.01, 0.48, 1, 0.8, 9, 2500.0, 0.0:2.0:2500.0)
    sol_qc = RozMac_pert(0.01, 0.48, 1, 0.8, 6, 3600.0, 2500.0:1.0:3100.0)
    sol_equil = RozMac_pert(0.01, 0.48, 1, 0.0, 1234, 5000.0, 0.0:2.0:5000.0)
    figure3 = figure(figsize=(3,10))
    subplot(5,1,1)
    iso_plot(0.0:0.1:3.0, RozMacPar(e = 0.48))  
    plot(sol_qc[1, :], sol_qc[2, :], color = "#440154FF")
    plot(sol_axial[1, :], sol_axial[2, :], color = "#73D055FF")
    xlabel("Resource")
    ylabel("Consumer")
    ylim(0,2.5)
    xlim(0,3.0)
    subplot(5,1,2)
    iso_plot(0.0:0.1:3.0, RozMacPar(e = 0.48))
    plot(sol_equil[1, :], sol_equil[2, :], color = "#FDE725FF")
    xlabel("Resource")
    ylabel("Consumer")
    ylim(0,2.5)
    xlim(0,3.0)
    subplot(5,1,3)
    plot(sol_qc.t, sol_qc.u)
    ylim(0,3.0)
    xlabel("Time")
    ylabel("Biomass")
    tick_params(axis="x", which="both", bottom=False, labelbottom=False)
    subplot(5,1,4)
    plot(sol_axial.t, sol_axial.u)
    ylim(0,3.0)
    tick_params(axis="x", which="both", bottom=False, labelbottom=False)
    xlabel("Time")
    ylabel("Biomass")
    subplot(5,1,5)
    plot(sol_equil.t, sol_equil.u)
    tick_params(axis="x", which="both", bottom=False, labelbottom=False)
    xlabel("Time")
    ylabel("Biomass")
    ylim(0,3.0)
    tight_layout()
    return figure3
    # savefig(joinpath(abpath(), "figs/phase_timeseries_examples.pdf"))
end

# Figure 3 (Proportion Real with small delta ε & ACF plots of quasi-cycles)
RCdividedata = findRCdivide_epx_data()
let
    prop_real_smalldelep = figure(figsize=(4,3))
    plot(RCdividedata[:,1], RCdividedata[:,2], color = "black")
    # fill_between(data[:,1], data[:,2], color = "blue", alpha=0.3)
    # fill_between(data[:,1], fill(1.0, length(data[:,2])), data[:,2], color = "orange", alpha=0.3)
    xlim(0,10)
    ylim(0.0,1.0)
    xticks(fontsize=12)
    yticks(fontsize=12)
    ylabel("Proportion Real", fontsize = 12)
    xlabel("1/ε", fontsize = 12)
    # return prop_real_smalldelep
    savefig(joinpath(abpath(), "figs/epsilonxaxis_propReal_smalldelep.pdf"))
end

let 
    lrange = 0:1:40
    acffast = quasicycle_data(1.0, 1000)
    acfslow = quasicycle_data(0.6, 1000)
    acffigure = figure(figsize = (6,2.5))
    subplot(1,2,1)
    plot(collect(lrange), acffast, color = "black")
    hlines(0.0,0.0,40.0, linestyles=`dashed`, linewidths=0.5)
    ylim(-1,1)
    xlim(0,40)
    xlabel("Lag")
    ylabel("Average ACF")
    subplot(1,2,2)
    plot(collect(lrange), acfslow, color = "black")
    hlines(0.0,0.0,40.0, linestyles=`dashed`, linewidths=0.5)
    ylim(-1,1)
    xlim(0,40)
    xlabel("Lag")
    ylabel("Average ACF")
    tight_layout()
    # return acffigure
    savefig(joinpath(abpath(), "figs/quasicycles_ACF.pdf"))
end



# Figure 4 (Proportion real with large delta ε & quasi-canard proportions with white noise )
wn_data05_short_RozMac = CSV.read(joinpath(abpath(),"data/wn_eff05_short_RozMac.csv"), DataFrame)
wn_data06_short_RozMac = CSV.read(joinpath(abpath(),"data/wn_eff06_short_RozMac.csv"), DataFrame)
wn_data07_short_RozMac = CSV.read(joinpath(abpath(),"data/wn_eff07_short_RozMac.csv"), DataFrame)
wn_data05_long_RozMac = CSV.read(joinpath(abpath(),"data/wn_eff05_long_RozMac.csv"), DataFrame)
wn_data06_long_RozMac = CSV.read(joinpath(abpath(),"data/wn_eff06_long_RozMac.csv"), DataFrame)
wn_data07_long_RozMac = CSV.read(joinpath(abpath(),"data/wn_eff07_long_RozMac.csv"), DataFrame)


let
    prop_real_largedelep = figure(figsize=(4,3))
    plot(RCdividedata[:,1], RCdividedata[:,2], color = "black")
    hlines(converteff_prop_RCdivide(0.5), 0.0, 1000.0, linestyles=`dashed`, linewidths=0.5, color = "black")
    hlines(converteff_prop_RCdivide(0.65), 0.0, 1000.0, linestyles=`dashed`, linewidths=0.5, color = "black")
    hlines(converteff_prop_RCdivide(0.7), 0.0, 1000.0, linestyles=`dashed`, linewidths=0.5, color = "black")
    xlim(-10,1000)
    ylim(0.0,1.0)
    xticks(fontsize=12)
    yticks(fontsize=12)
    ylabel("Proportion Real", fontsize = 15)
    xlabel("1/ε", fontsize = 15)
    # return prop_real_largedelep
    savefig(joinpath(abpath(), "figs/epsilonxaxis_propReal_largedelep.pdf"))
end

let
    figure4bc = figure(figsize = (7,2.5))
    subplot(1,3,1)
    plot(1 ./ wn_data05_short_RozMac.xrange, wn_data05_short_RozMac.canard, color = "black", linestyle = "dashed")
    plot(1 ./ wn_data05_long_RozMac.xrange, wn_data05_long_RozMac.canard, color = "black", linestyle = "dotted")
    ylabel("Proportion with\nquasi-canard", fontsize = 15)
    xlabel("1/ϵ", fontsize = 15)
    ylim(0,1)
    xticks(fontsize=12)
    yticks(fontsize=12)
    subplot(1,3,2)
    plot(1 ./ wn_data06_short_RozMac.xrange, wn_data06_short_RozMac.canard, color = "black", linestyle = "dashed")
    plot(1 ./ wn_data06_long_RozMac.xrange, wn_data06_long_RozMac.canard, color = "black", linestyle = "dotted")
    ylim(0,1)
    xticks(fontsize=12)
    yticks(fontsize=12)
    xlabel("1/ϵ", fontsize = 15)
    subplot(1,3,3)
    plot(1 ./ wn_data07_short_RozMac.xrange, wn_data07_short_RozMac.canard, color = "black", linestyle = "dashed")
    plot(1 ./ wn_data07_long_RozMac.xrange, wn_data07_long_RozMac.canard, color = "black", linestyle = "dotted")
    xlabel("1/ϵ", fontsize = 15)
    ylim(0,1)
    xticks(fontsize=12)
    yticks(fontsize=12)
    tight_layout()
    # return figure4bc
    savefig(joinpath(abpath(), "figs/canard_whitenoise_prop.pdf"))
end


# Figure 5 (Proportion quasicanard/axial solution with red noise)

rn_data_ep0004eff05_RozMac = CSV.read(joinpath(abpath(),"data/rn_ep0004eff05_RozMac.csv"), DataFrame)
rn_data_ep0004eff06_RozMac = CSV.read(joinpath(abpath(),"data/rn_ep0004eff06_RozMac.csv"), DataFrame)
rn_data_ep0004eff07_RozMac = CSV.read(joinpath(abpath(),"data/rn_ep0004eff07_RozMac.csv"), DataFrame)
rn_data_ep0079eff05_RozMac = CSV.read(joinpath(abpath(),"data/rn_ep0079eff05_RozMac.csv"), DataFrame)
rn_data_ep0079eff06_RozMac = CSV.read(joinpath(abpath(),"data/rn_ep0079eff06_RozMac.csv"), DataFrame)
rn_data_ep0079eff07_RozMac = CSV.read(joinpath(abpath(),"data/rn_ep0079eff07_RozMac.csv"), DataFrame)


let
    figure5 = figure(figsize = (8,4))
    subplot(2,3,1)
    fill_between(rn_data_ep0079eff05_RozMac.xrange, rn_data_ep0079eff05_RozMac.canard, color="#440154FF")
    fill_between(rn_data_ep0079eff05_RozMac.xrange, rn_data_ep0079eff05_RozMac.canard, rn_data_ep0079eff05_RozMac.canard_plus_axial, color="#73D055FF")
    fill_between(rn_data_ep0079eff05_RozMac.xrange, fill(1.0,91), rn_data_ep0079eff05_RozMac.canard_plus_axial, color="#FDE725FF")
    ylabel("Proportion", fontsize=15)
    ylim(0,1)
    xticks(fontsize=12)
    yticks(fontsize=12)
    subplot(2,3,2)
    fill_between(rn_data_ep0079eff06_RozMac.xrange, rn_data_ep0079eff06_RozMac.canard, color="#440154FF")
    fill_between(rn_data_ep0079eff06_RozMac.xrange, rn_data_ep0079eff06_RozMac.canard, rn_data_ep0079eff06_RozMac.canard_plus_axial, color="#73D055FF")
    fill_between(rn_data_ep0079eff06_RozMac.xrange, fill(1.0,91), rn_data_ep0079eff06_RozMac.canard_plus_axial, color="#FDE725FF")
    xlabel("Noise correlation", fontsize=15)
    ylim(0,1)
    xticks(fontsize=12)
    yticks(fontsize=12)
    subplot(2,3,3)
    fill_between(rn_data_ep0079eff07_RozMac.xrange, rn_data_ep0079eff07_RozMac.canard, color="#440154FF")
    fill_between(rn_data_ep0079eff07_RozMac.xrange, rn_data_ep0079eff07_RozMac.canard, rn_data_ep0079eff07_RozMac.canard_plus_axial, color="#73D055FF")
    fill_between(rn_data_ep0079eff07_RozMac.xrange, fill(1.0,91), rn_data_ep0079eff07_RozMac.canard_plus_axial, color="#FDE725FF")
    ylim(0,1)

    subplot(2,3,4)
    fill_between(rn_data_ep0004eff05_RozMac.xrange, rn_data_ep0004eff05_RozMac.canard, color="#440154FF")
    fill_between(rn_data_ep0004eff05_RozMac.xrange, rn_data_ep0004eff05_RozMac.canard, rn_data_ep0004eff05_RozMac.canard_plus_axial, color="#73D055FF")
    fill_between(rn_data_ep0004eff05_RozMac.xrange, fill(1.0,91), rn_data_ep0004eff05_RozMac.canard_plus_axial, color="#FDE725FF")
    ylabel("Proportion", fontsize=15)
    ylim(0,1)
    xticks(fontsize=12)
    yticks(fontsize=12)
    subplot(2,3,5)
    fill_between(rn_data_ep0004eff06_RozMac.xrange, rn_data_ep0004eff06_RozMac.canard, color="#440154FF")
    fill_between(rn_data_ep0004eff06_RozMac.xrange, rn_data_ep0004eff06_RozMac.canard, rn_data_ep0004eff06_RozMac.canard_plus_axial, color="#73D055FF")
    fill_between(rn_data_ep0004eff06_RozMac.xrange, fill(1.0,91), rn_data_ep0004eff06_RozMac.canard_plus_axial, color="#FDE725FF")
    xlabel("Noise correlation", fontsize=15)
    ylim(0,1)
    xticks(fontsize=12)
    yticks(fontsize=12)
    subplot(2,3,6)
    fill_between(rn_data_ep0004eff07_RozMac.xrange, rn_data_ep0004eff07_RozMac.canard, color="#440154FF")
    fill_between(rn_data_ep0004eff07_RozMac.xrange, rn_data_ep0004eff07_RozMac.canard, rn_data_ep0004eff07_RozMac.canard_plus_axial, color="#73D055FF")
    fill_between(rn_data_ep0004eff07_RozMac.xrange, fill(1.0,91), rn_data_ep0004eff07_RozMac.canard_plus_axial, color="#FDE725FF")
    ylim(0,1)
    xticks(fontsize=12)
    yticks(fontsize=12)
    tight_layout()
    annotate("a)", (20, 280), xycoords = "figure points", fontsize = 15)
    annotate("b)", (205, 280), xycoords = "figure points", fontsize = 15)
    annotate("c)", (385, 280), xycoords = "figure points", fontsize = 15)
    annotate("d)", (20, 140), xycoords = "figure points", fontsize = 15)
    annotate("e)", (205, 140), xycoords = "figure points", fontsize = 15)
    annotate("f)", (385, 140), xycoords = "figure points", fontsize = 15)
    # return figure5
    savefig(joinpath(abpath(), "figs/canard_rednoise_prop.pdf"))
end



# Box 2 Figure 1
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