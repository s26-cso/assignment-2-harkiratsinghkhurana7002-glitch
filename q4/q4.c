#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dlfcn.h>

int main(){
    char op[6];
    int num1,num2;

    while(scanf("%s %d %d",op,&num1,&num2)==3){

        char libname[15];
        int idx=0;
        strcpy(libname,"lib");
        for(int i=0;i<strlen(op);i++){
            libname[i+3]=op[i];
        }
        libname[strlen(op)+3]='\0';
        strcat(libname,".so");
        void* lib=dlopen(libname,RTLD_LAZY);
        if(!lib){
            printf("Error.Attached library is not opening");
            continue;
        }

        int (*f)(int,int);

        f= (int (*)(int,int)) dlsym(lib,op);
        if(!f){
            printf("Error.Operator named the 'op' is not present in the attached library \n");
            dlclose(lib);
            continue;
        }

        int ans=f(num1,num2);
        printf("%d\n",ans);

        dlclose(lib);
    }

    return 0;
}
