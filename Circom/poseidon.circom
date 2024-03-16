pragma circom 2.0.0;
include "../node_modules/circomlib/circuits/poseidon.circom";

template Crypto(){
  component pos = Poseidon(1);
  signal input in[1];
  pos.inputs <== in;

  signal output out;
  out <== pos.out;
}

component main = Crypto();