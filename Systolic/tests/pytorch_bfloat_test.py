import torch

a = torch.tensor([8.25], dtype=torch.bfloat16)
b = torch.tensor([9.6413], dtype=torch.bfloat16)
print(a)
print(b)
c = (a * b)
print(c)
