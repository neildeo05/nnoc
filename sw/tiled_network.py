import torch
import pprint
import torch.nn as nn
from torch.fx import symbolic_trace
import numpy as np
from TiledTensor import TiledTensor

tile_graph = []
# Simple Example
def tile_compute(a, b):
    return a @ b
def tile_accum(a, b, tile_dict, tile_idx):
    if tile_dict.get(tile_idx[0]):
        tile_dict[tile_idx[0]].append(tile_idx[1:])
    else:
        tile_dict[tile_idx[0]] = [tile_idx[1:]]
    return a + b

def tiled_matmul(a, b):
    tile_dict = {}
    ta = TiledTensor(a.detach().numpy()).tileit()
    tb = TiledTensor(b.detach().numpy()).tileit()
    ra = ta.shape[0]
    ca = ta.shape[1]
    cb = tb.shape[1]
    out = [[np.zeros((4,4)) for _ in range(cb)] for _ in range(ra)]
    for i in range(ra):
        for j in range(cb):
            for k in range(ca):
                tile_a = ta[i,k]
                tile_b = tb[k,j]
                out[i][j] = tile_accum(out[i][j], tile_compute(tile_a, tile_b), tile_dict, ((i,j), (i,k), (k,j)))
    out = torch.tensor(np.hstack(np.hstack(out)), dtype=torch.float32)
    tile_graph.append(tile_dict)
    return out


class TiledLinear(nn.Linear):
    def forward(self, x):
        out = tiled_matmul(x, self.weight.t())
        check = torch.matmul(x, self.weight.t())
        print(out.shape)
        assert(torch.allclose(out, check))
        return out

class MiniModel(torch.nn.Module):
    def __init__(self):
        super().__init__()
        self.l1 = TiledLinear(8,24, dtype=torch.float32, bias=False)
        self.g1 = nn.GELU()
        self.l2 = TiledLinear(24,12, dtype=torch.float32, bias=False)

    def forward(self, x):
        x = self.l1(x)
        x = self.g1(x)
        x = self.l2(x)
        return x


model = MiniModel()
# batch dimension of 4
inp = torch.randn((4,8), dtype=torch.float32)

model(inp) # call model

for i in tile_graph:
    pprint.pprint(i)
    print()

