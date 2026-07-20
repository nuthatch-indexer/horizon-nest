# horizon's own entry: instantiate the shared unit (lib.star) under its own name. The reusable
# definition lives in lib.star so graph-network can load() it instead of forking this file.
load("lib.star", "graph_horizon")

graph_horizon(name = "horizon")
