# The Horizon staking nest, authored once as a function (RFC-0018 §2). This file *defines* the nest;
# it never calls `nest()` itself, so it is safe to `load()`. An entry file — this nest's own `nest.star`
# or another nest's — imports `graph_horizon` and instantiates it exactly once.
#
# graph-network is this same unit under a different name: an instance, not a fork.

RPCS = [
    "https://arb1.arbitrum.io/rpc",
    "https://arbitrum-one-rpc.publicnode.com",
    "https://arbitrum.drpc.org",
    "https://arb-pokt.nodies.app",
]

# The three Horizon contracts, with their vendored deployment blocks. Shared by every instance.
def _contracts():
    return [
        contract("staking", "0x00669a4cf01450b64e8a2a20e9b1fcb71e61ef03", 42449585, abi = "abis/staking.json"),
        contract("service", "0xb2bb92d0de618878e438b55d5846cfecd9301105", 397492865, abi = "abis/service.json"),
        contract("extension", "0x3be385576d7c282070ad91bf94366de9f9ba3571", 180370540, abi = "abis/extension.json"),
    ]

def graph_horizon(name, chain = "arbitrum-one", rpc_urls = RPCS, extra = []):
    """The Horizon staking + SubgraphService + delegation-extension nest, parameterized by name.

    Instantiate with `graph_horizon(name = "...")`. `extra` appends instance-specific contracts.
    """
    return nest(
        name = name,
        chain = chain,
        rpc_urls = rpc_urls,
        contracts = _contracts() + extra,
    )
