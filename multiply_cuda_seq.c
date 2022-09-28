#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int N, **A, **B, **C;

void createMatrix(int ***matrix) {
    *matrix = (int**)malloc(N * sizeof(int*));
    for(int i = 0; i < N; i++) {
        *(*matrix + i) = (int*)malloc(N * sizeof(int));
    }
}

void fillMatrix(int ***matrix) {
    for(int i = 0; i < N; i++) {
        for(int j = 0; j < N; j++) {
            *(*(*matrix + i) + j) = rand()%10 + 1;
        }
    }
}

void init() {
    createMatrix(&A);
    fillMatrix(&A);
    createMatrix(&B);
    fillMatrix(&B);
    createMatrix(&C);
}

void multiply() {
    for(int i = 0; i < N; i++)
        for(int j = 0; j < N; j++)
            for(int k = 0; k < N; k++)
                C[i][j] += A[i][k] * B[k][j];    
}

void printMatrix(int **matrix) {
    for(int i = 0; i < N; i++) {
        for(int j = 0; j < N; j++)
            printf("%d ", matrix[i][j]);
        printf("\n");
    }
    printf("\n");
}

int main(int argc, char* argv[]){
    switch(argc) {
        case 2:
            sscanf(argv[1], "%d", &N);
            break;
        default:
            printf("Wrong parameters. Closing program...\n");
            return 0;
    }
    if(N < 2) {
        printf("Wrong parameters. Closing program...\n");
        return 0;
    }

    init();

    double time = clock();
    multiply();
    time = (clock() - time)/CLOCKS_PER_SEC;
    printf("MATRIX: %dx%d\nTIME: %f\n", N, N, time);
    // printMatrix(C);
}