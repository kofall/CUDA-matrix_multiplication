#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int N, *A, *B, *C;

void createMatrix(int **matrix) {
    *matrix = (int*)malloc(N*N * sizeof(int));
}

void fillMatrix(int *matrix) {
    for(int i = 0; i < N * N; i++) {
        matrix[i] = rand()%10 + 1;
    }
}

void init() {
    createMatrix(&A);
    fillMatrix(A);
    createMatrix(&B);
    fillMatrix(B);
    createMatrix(&C);
}

__global__ void multiply(int *A, int *B, int *C, int N) {
    int row = blockIdx.y * blockDim.y + threadIdx.y;
    int col = blockIdx.x * blockDim.x + threadIdx.x;
    int tmp = 0;

    if(row < N && col < N) {
        int shift = row * N;
        for(int k = 0; k < N; k++)
            tmp += A[shift + k] * B[k * N + col];
        C[shift + col] = tmp;
    }
}

void printMatrix(int *matrix) {
    for(int i = 0; i < N * N; i++) {
        if(i % N == 0 && i != 0) {
            printf("\n");
        }
        printf("%d ", matrix[i]);
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

    cudaEvent_t start, stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);
    cudaEventRecord(start, 0);
    multiply<<<1, N*N>>>(A, B, C, N);
    cudaEventRecord(stop, 0);
    cudaEventSynchronize(stop);
    float msecTotal = 0.0f;
    cudaEventElapsedTime(&msecTotal, start, stop);
    cudaEventDestroy(start);
    cudaEventDestroy(stop);
    printf("MATRIX: %dx%d\nTIME: %f\n", N, N, msecTotal);
    // printMatrix(C);
}