pragma circom 2.0.0;
include "node_modules/circomlib/circuits/sha256/sha256.circom";

template Crypto(){
  component sha = Sha256(4);
  signal input in[4];
  sha.in <== in;

  signal output out[256];
  out <== sha.out;
}

component main = Crypto();