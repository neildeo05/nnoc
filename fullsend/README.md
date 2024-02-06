# Fullsend RV32IV Control Unit with L2 $ that sends data to the NoC

Branching is not a priority, as there really aren't any branch instructions. Therefore, branch "taking" happens after the execution stage, and there isn't really any speculation

# Features
32-bit 5 stage (pretty standard)
ONLY memory it can access is the cache
Vector unit based off of <https://github.com/tenstorrent/riscv-ocelot/blob/bobcat/README-TT.md> and <https://github.com/semidynamics/OpenVectorInterface>


# Future plans

- [ ] Run with ucb/chipyard
- [ ] Make it superscalar
- [ ] "Controller" chip that is 64 bit and out of order as well
