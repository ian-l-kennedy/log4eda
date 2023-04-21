#include <stdio.h>
#include <stdlib.h>
#define BUFSIZE 80

int main(int argc, char** argv) {
  char path[BUFSIZE];
  char *envvar = "SHELL";

  // Make sure envar actually exists
  if(!getenv(envvar)){
      fprintf(stderr, "The environment variable %s was not found.\n", envvar);
      exit(1);
  }

  // Make sure the buffer is large enough to hold the environment variable
  // value.
  if(snprintf(path, BUFSIZE, "%s", getenv(envvar)) >= BUFSIZE){
      fprintf(stderr, "BUFSIZE of %d was too small. Aborting\n", BUFSIZE);
      exit(1);
  }
  printf("PATH: %s\n", path);
  printf("hello world\n");
  // std::cout << "Have " << argc << " arguments:" << std::endl;
  // for (int i = 0; i < argc; ++i) {
  //     std::cout << argv[i] << std::endl;
  // }
  int status = system("");
}