pragma circom 2.1.6;

include "../node_modules/circomlib/circuits/comparators.circom";

template Hamilton(N) {
    signal input grafo[N][N];
    signal input soluzione[N];
    signal output out;

    // Controllo che ogni nodo abbia almeno un arco entrante
    component grafoOK= checkGrafo(N);
    grafoOK.in <== grafo;

    // Controllo che ogni arco della soluzione esista all'interno del grafo
    component archiOK= checkArco(N);
    archiOK.in1 <== grafo;
    archiOK.in2 <== soluzione;

    // Controllo che la soluzione sia corretta
    component solOK= checkSol(N);
    solOK.in <== soluzione;
}

// Controllo cla presenza di archi entranti per ogni nodo
template checkGrafo(N) {

    signal input in[N][N];
    signal output out;

    var occurrences[N];
    for (var i = 0; i < N; i++) {
        occurrences[i] = 0;
    }

    // Conteggio degli archi entranti in ogni nodo
    for (var i = 0; i < N; i++) {
        for (var j = 0; j < N; j++) {
            var pos= in[i][j];
            if( pos == 1){
                occurrences[j] += 1;
            }
        }
    }

    // Controllo che il numero di archi per nodo sia maggiore di 0
    component grather[N];
    signal occ[N];
    for (var i = 0; i < N; i++) {
        grather[i] = GreaterThan(32);
        occ[i] <-- occurrences[i];
        grather[i].in[0] <== occ[i];
        grather[i].in[1] <== 0;
        grather[i].out === 1;
    }

    out <== 1;
}

// Controllo che ogni nodo venga visitato solo una volta
template checkSol(N) {
    signal input in[N];
    signal output out;

    var occurrences[N];
    for (var i = 0; i < N; i++) {
        occurrences[i] = 0;
    }

    // Conteggio occorrenze di ogni nodo
    for (var i = 0; i < N; i++) {
        occurrences[in[i]-1] += 1;
    }

    // Controllo che tutte le occorrenze siano esattamente 1
    component equal0[N];
    signal occ[N];
    for (var i = 0; i < N; i++) {
        equal0[i] = IsEqual();
        occ[i] <-- occurrences[i];
        equal0[i].in[0] <== occ[i];
        equal0[i].in[1] <== 1;
        equal0[i].out === 1;
    }
    out <== 1;
}

// Controllo che ogni arco della soluzione esista all'interno del grafo 
template checkArco(N){
    signal input in1[N][N];
    signal input in2[N];
    signal output out;

    // Controllo che nella matrice che rappresenta il grafo gli archi della soluzione esistano
    component equal0[N-1];
    signal pos[N-1];
    for (var i = 0; i < N-1; i++) {
        equal0[i] = IsEqual();
        pos[i] <-- in1[in2[i]-1][in2[i+1]-1];
        equal0[i].in[0] <== pos[i];
        equal0[i].in[1] <== 1;
        equal0[i].out === 1;
    }

    out <== 1;
}

component main {public [grafo]} = Hamilton(5);