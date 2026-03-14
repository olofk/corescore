# ==========================================
# Synthesis Settings
# ==========================================

# Use the highest area optimization strategy
set_property strategy Flow_AreaOptimized_high [get_runs synth_1]

# Flatten hierarchy to allow cross-boundary optimization
set_property STEPS.SYNTH_DESIGN.ARGS.FLATTEN_HIERARCHY full [get_runs synth_1]

# Extract all control signals
set_property STEPS.SYNTH_DESIGN.ARGS.CONTROL_SET_OPT_THRESHOLD 0 [get_runs synth_1]

# Aggressively extract shift registers to SRL primitives
set_property STEPS.SYNTH_DESIGN.ARGS.SHREG_MIN_SIZE 3 [get_runs synth_1]

# Maximize resource sharing to minimize duplicate arithmetic logic
set_property STEPS.SYNTH_DESIGN.ARGS.RESOURCE_SHARING auto [get_runs synth_1]

# ==========================================
# P&R Settings
# ==========================================

# Direct opt_design to run multiple passes for area reduction
set_property STEPS.OPT_DESIGN.ARGS.DIRECTIVE ExploreArea [get_runs impl_1]

# Use Default placement to avoid timing-driven spreading of logic
set_property STEPS.PLACE_DESIGN.ARGS.DIRECTIVE Default [get_runs impl_1]

# Disable physical optimization to prevent register duplication for fanout or timing
set_property STEPS.PHYS_OPT_DESIGN.IS_ENABLED false [get_runs impl_1]

# Use Explore for routing due to congestion
set_property STEPS.ROUTE_DESIGN.ARGS.DIRECTIVE Explore [get_runs impl_1]
