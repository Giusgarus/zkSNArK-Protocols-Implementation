pragma circom 2.1.6;

include "node_modules/circomlib/circuits/comparators.circom";

template maggiorenni() {

    /*Dichiarazione dei segnali in entrata, e' possibile impostare un'eta' minima*/
    signal input age;
    signal input minage;

    //Segnale in uscita
    signal output oldEnough;
    
    //Istanziamento componente comparazione
    component gt = GreaterThan(8);
    gt.in[0] <== age;
    gt.in[1] <== minage;

    //Creazione constraint del sistema
    oldEnough <== gt.out;
}

component main = maggiorenni();


