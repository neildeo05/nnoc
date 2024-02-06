import torch
import pprint
import torch.nn as nn
import numpy as np
from collections import namedtuple
from TiledTensor import TiledTensor

op_graph = []
A_SHP = 768
B_SHP = 3 * A_SHP
D_SHP = 4 
# Simple Example
def tile_compute(a, b):
    return a @ b
def tile_accum(a, b, tile_idx):
    Accumulate = namedtuple('Accumulate', ['dest','x_tile','weight_idx'])
    op_graph.append(Accumulate(*tile_idx))
    return a + b

def tiled_matmul(a, b):
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
                out[i][j] = tile_accum(out[i][j], tile_compute(tile_a, tile_b), ((i,j), (i,k), (k,j)))
    out = torch.tensor(np.hstack(np.hstack(out)), dtype=torch.float32)
    op_graph.append('END')
    return out


class TiledLinear(nn.Linear):
    def forward(self, x):
        out = tiled_matmul(x, self.weight.t())
        check = torch.matmul(x, self.weight.t())
        assert(torch.allclose(out, check, rtol=1e-3, atol=1e-5))
        return out

class MiniModel(torch.nn.Module):
    def __init__(self):
        super().__init__()
        self.l1 = TiledLinear(A_SHP,B_SHP,dtype=torch.float32, bias=False)
        self.g1 = nn.GELU()
        self.l2 = TiledLinear(B_SHP,A_SHP, dtype=torch.float32, bias=False)
        #self.l3 = TiledLinear(A_SHP, D_SHP, dtype=torch.float32, bias=False)

    def forward(self, x):
        x = self.l1(x)
        x = self.g1(x)
        x = self.l2(x)
        #x = self.l3(x)
        return x



model = MiniModel()
BS = 4
inp = torch.randn((BS,A_SHP), dtype=torch.float32)
model(inp) # call model



for i in op_graph:
    print(i)

