import numpy as np


class TiledTensor:
    def __init__(self, tensor, TILE_SIZE=4):
        self.tensor = tensor
        self.tiled = None
        self.TILE_SIZE = TILE_SIZE
        # TODO: make this logic better, mismatch dimensions shouldn't be put in a list like this, honestly probably bettter to just keep it in a variable
        # self.mismatch conatins the new shape of the array
        self.mismatch = list(self.tensor.shape)
        checkdims2 = self.tensor.shape[-2] % TILE_SIZE
        checkdims1 = self.tensor.shape[-2] % TILE_SIZE
        self.checkdims = checkdims1 or checkdims2
        self.mismatch[-2] = (self.tensor.shape[-2] + TILE_SIZE - checkdims2) if checkdims2 else self.tensor.shape[-2]
        self.mismatch[-1] = (self.tensor.shape[-1] + TILE_SIZE - checkdims1) if checkdims1 else self.tensor.shape[-1]
        self.mismatch = tuple(self.mismatch)

    def tileit(self):
        arr = self.tensor
        if self.checkdims:
            arr = np.resize(self.tensor, self.mismatch)
        TILE_SIZE = self.TILE_SIZE
        # basically all this is doing is tiling the last two dims. This is what we want, so for a case of like an image, we have three tiled tensors for each channel. also works for higher dims and such
        shape = arr.shape[:-2] + (arr.shape[-2] // TILE_SIZE, arr.shape[-1] // TILE_SIZE, TILE_SIZE, TILE_SIZE)
        strides = arr.strides[:-2] + (arr.strides[-2] * TILE_SIZE, arr.strides[-1] * TILE_SIZE) + arr.strides[-2:]
        self.tiled = np.lib.stride_tricks.as_strided(arr, shape=shape, strides=strides)
        return self.tiled


def test_tiling():
    tensor1 = np.random.randn(4, 8)
    tiled_tensor1 = TiledTensor(tensor1)
    tiled_tensor1.tileit()
    for i in tiled_tensor1.tiled:
        for j in i:
            print(j.shape)
    tensor2 = np.random.randn(8, 16)
    tiled_tensor2 = TiledTensor(tensor2)
    tiled_tensor2.tileit()
    print()
    a = 0
    for p in tiled_tensor2.tiled:
        for q in p:
            print(q.shape)
        print()

    print(a)
    print(tensor1 @ tensor2)
    


if __name__ == '__main__':
    test_tiling()
    
