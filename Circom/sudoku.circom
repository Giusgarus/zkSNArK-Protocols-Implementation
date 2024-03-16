pragma circom 2.1.6;

template Num2Bits(n) {
    signal input in;
    signal output out[n];
    var lc1=0;

    var e2=1;
    for (var i = 0; i<n; i++) {
        out[i] <-- (in >> i) & 1;
        out[i] * (out[i] -1 ) === 0;
        lc1 += out[i] * e2;
        e2 = e2+e2;
    }

    lc1 === in;
}

template LessThan(n) {
    assert(n <= 252);
    signal input in[2];
    signal output out;

    component n2b = Num2Bits(n+1);
    n2b.in <== in[0]+ (1<<n) - in[1];

    out <== 1-n2b.out[n];
}

template IsZero() {
    signal input in;
    signal output out;

    signal inv;
    inv <-- in!=0 ? 1/in : 0;
    out <== -in*inv +1;
    in*out === 0;
}

template LessEqThan(n) {
    signal input in[2];
    signal output out;

    component lt = LessThan(n);
    lt.in[0] <== in[0];
    lt.in[1] <== in[1]+1;
    lt.out ==> out;
}

template GreaterEqThan(n) {
    signal input in[2];
    signal output out;

    component lt = LessThan(n);
    lt.in[0] <== in[1];
    lt.in[1] <== in[0]+1;
    lt.out ==> out;
}

template IsEqual() {
    signal input in[2];
    signal output out;

    component isz = IsZero();
    in[1] - in[0] ==> isz.in;
    isz.out ==> out;
}



//Controllo che tutti i numeri della solozioni possano appartenere al Sudoku
template checkNumbers(N) {
    signal input in[N*N];
    signal output out;

    component check[N*N];
    for (var i = 0; i < N*N; i++) {
           check[i] = Check(N);
           check[i].in <== in[i];
           // Costraints che impogono l' appartenenza all'intervallo
           check[i].out[0] === 1;
           check[i].out[1] === 1;
    }

    out <== 1;
}

// Controlla che tutti le caselle dell'input siano coerenti
template Check(N) {
    signal input in;
    signal output out[2];

    component results=between(N);
    results.in <== in;

    component equal1 = IsEqual();
    component equal2 = IsEqual();
    // Check che sia vero che "in">=1
    equal1.in[0] <== results.out[0];
    equal1.in[1] <== 1;

    // Check che sia vero che "in"<=N
    equal2.in[0] <== results.out[1];
    equal2.in[1] <== 1;

    out[0] <== equal1.out;
    out[1] <== equal2.out;
}

template between(N){
    signal input in;
    signal output out[2];
   
    //Controllo che sia minore di N
    component upper=LessEqThan(32);
    upper.in[0] <== in;
    upper.in[1] <== N;
    out[0] <== upper.out;

    //Controllo che maggiore di 0
    component low=GreaterEqThan(32);
    low.in[0] <== in;
    low.in[1] <== 1;
    out[1] <== low.out;
}

// Controllo che tutti i numeri fra 1 ed N siano presenti una e una sola volta
template repetitionCheck(N) {
    signal input in[N];
    signal output out;

    // COnteggio accorrenze di ogni numero
    var occurrences[N];
    for (var i = 0; i < N; i++) {
        occurrences[i] = 0;
    }

    // Controllo delle occorrenze dei numeri
    for (var i = 0; i < N; i++) {
        occurrences[in[i]-1] += 1;
    }

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

template checkRighe(N){
    signal input in[N][N];
    signal output out;

    component check[N];
    for (var i = 0; i < N; i++) {
        check[i] = repetitionCheck(N);
        for (var j = 0; j < N; j++) {
            //Ogni elemento della riga viene usato come input delle funzione repetitionCheck
            check[i].in[j] <== in[i][j];
        }
        //Creazione del constraint per le righe
        check[i].out === 1;
    }
    
    out <== 1;
}

template checkColonne(N){
    signal input in[N][N];
    signal output out;

    component check[N];
    for (var i = 0; i < N; i++) {
        check[i] = repetitionCheck(N);
        for (var j = 0; j < N; j++) {
            //Ogni elemento della colonna viene usato come input delle funzione repetitionCheck
            check[i].in[j] <== in[j][i];
        }
        //Creazione del constraint per le colonne
        check[i].out === 1;
    }

    out <== 1;
}

template checkSquare(squareDim, N){
    signal input in[N][N];
    signal output out;

    // Controllo le ripetizioni nei quadrati
    component check[N];
    for (var i = 0; i < squareDim; i++) {
        for (var j = 0; j < squareDim; j++) {

            //Salvo le posizioni di partenza dei quadrati
            var x = i*squareDim;
            var y = j*squareDim;

            //Salvo l'indice del quadrato del sudoku
            var squareI = i*squareDim + j;
            check[squareI] = repetitionCheck(N);
            for (var k = 0; k < squareDim; k++) {
                for (var h = 0; h < squareDim; h++) {
                    // Salvo l'indice di casella all'interno del quadrato
                    var Indice = k*squareDim + h;
                    // Passo alla funzione repetetitionCheck il quadrato come se fosse una riga
                    check[squareI].in[Indice] <== in[x+k][y+h];
                }
            }
            // Creazione del constraint per i quadrati
            check[squareI].out === 1;
        }
    }

    out <== 1;
}

template Sudoku(squareDim, N) {
    signal input problema[N][N];
    signal input soluzione[N][N];
    signal output out;

    // Controlla i numeri inseriti nella matrice
    component CN = checkNumbers(N);
    for (var i = 0; i < N; i++) {
        for (var j = 0; j < N; j++) {
            CN.in[i*N + j] <== soluzione[i][j];
        }
    }
    CN.out === 1;

    // Controllo le ripetizioni sulle righe
    component righe= checkRighe(N);
    righe.in <== soluzione;

    // Controllo le ripetizioni sulle colonne
    component colonne= checkColonne(N);
    colonne.in <== soluzione;

    // Controllo le ripetizioni sulle colonne
    component square= checkSquare(squareDim,N);
    square.in <== soluzione;

    //Verifico che la "soluzione" risolve esattamente "problema"
    component equal[N][N];
    component equal0[N][N];
    for (var i = 0; i < N; i++) {
        for (var j = 0; j < N; j++) {
            equal[i][j] = IsEqual();
            equal[i][j].in[0] <== soluzione[i][j];
            equal[i][j].in[1] <== problema[i][j];
            equal0[i][j] = IsZero();
            equal0[i][j].in <== problema[i][j];
            equal[i][j].out === 1 - equal0[i][j].out;
        }
    }
}

component main {public [problema]} = Sudoku(2, 4);